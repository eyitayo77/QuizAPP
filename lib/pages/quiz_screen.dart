import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/models/quiz_model.dart';
import 'package:flutter_quiz_app/api/quiz_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> questionList = [];
  int currentQuestionIndex = 0;
  int score = 0;
  Answer? selectedAnswer;
  bool showCorrectAnswer = false;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  void loadQuestions() async {
    try {
      List<Question> questions = await fetchQuestions();
      setState(() {
        questionList = questions;
      });
    } catch (e) {
      print('Error fetching questions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: questionList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Q U E S T I O N S",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 24,
                    ),
                  ),
                  _questionWidget(),
                  _answerList(),
                  _nextButton(),
                ],
              ),
            ),
    );
  }

  Widget _questionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Question ${currentQuestionIndex + 1}/${questionList.length}",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.grey[600],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            questionList[currentQuestionIndex].questionText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _answerList() {
    return Column(
      children: questionList[currentQuestionIndex]
          .answers
          .map((answer) => _answerButton(answer))
          .toList(),
    );
  }

  Widget _answerButton(Answer answer) {
    bool isCorrectAnswer = answer.isCorrect;
    bool isSelected = answer == selectedAnswer;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 48,
      child: ElevatedButton(
        child: Text(answer.answerText),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: showCorrectAnswer
              ? (isCorrectAnswer
                  ? Colors.green
                  : (isSelected ? Colors.red : Colors.grey[700]))
              : Colors.grey[700],
          shape: const StadiumBorder(),
        ),
        onPressed: () {
          if (!showCorrectAnswer) {
            if (isCorrectAnswer) {
              score++;
            }
            setState(() {
              selectedAnswer = answer;
              showCorrectAnswer = true;
            });
          }
        },
      ),
    );
  }

  Widget _nextButton() {
    bool isLastQuestion = currentQuestionIndex == questionList.length - 1;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.grey[800],
        shape: const StadiumBorder(),
      ),
      child: Text(isLastQuestion ? "Submit" : "Next"),
      onPressed: () {
        if (showCorrectAnswer) {
          if (isLastQuestion) {
            showDialog(
              context: context,
              builder: (_) => _showScoreDialog(),
            );
          } else {
            setState(() {
              currentQuestionIndex++;
              selectedAnswer = null;
              showCorrectAnswer = false;
            });
          }
        }
      },
    );
  }

  Widget _showScoreDialog() {
    bool isPassed = score >= questionList.length * 0.6;
    String title = isPassed ? "Passed!" : "Failed!";

    return AlertDialog(
      backgroundColor: Colors.grey[700],
      title: Text(
        "$title\nYour Score: $score/${questionList.length}",
        style: TextStyle(
          color: isPassed ? Colors.green : Colors.redAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[500],
          foregroundColor: Colors.white,
        ),
        child: const Text("Restart"),
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            currentQuestionIndex = 0;
            score = 0;
            selectedAnswer = null;
            showCorrectAnswer = false;
          });
        },
      ),
    );
  }
}
