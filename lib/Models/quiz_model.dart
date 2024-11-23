class Question {
  final int id;
  final String type;
  final String difficulty;
  final String category;
  final String questionText;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.type,
    required this.difficulty,
    required this.category,
    required this.questionText,
    required this.answers,
  });

  // Factory constructor to create a Question object from JSON
  factory Question.fromJson(Map<String, dynamic> json) {
    List<Answer> answers = [
      Answer(answerText: json['correct_answer'], isCorrect: true),
      Answer(answerText: json['incorrect_answer_0'], isCorrect: false),
      Answer(answerText: json['incorrect_answer_1'], isCorrect: false),
      Answer(answerText: json['incorrect_answer_2'], isCorrect: false),
    ]..shuffle();

    return Question(
      id: json['id'],
      type: json['type'],
      difficulty: json['difficulty'],
      category: json['category'],
      questionText: json['question'],
      answers: answers,
    );
  }
}

class Answer {
  final String answerText;
  final bool isCorrect;

  Answer({required this.answerText, required this.isCorrect});
}
