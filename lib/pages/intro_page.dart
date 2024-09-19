import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/pages/quiz_screen.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.grey[400],
          // ignore: prefer_const_constructors
          title: Text("W E L C O M E ")),
      backgroundColor: Colors.grey[300],
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[500], // Set the background color here
            foregroundColor: Colors.white,
          ), // This sets the text color
          // ignore: prefer_const_constructors
          child: Text(
            "B E G I N Q U I Z!",
          ),
          onPressed: () {
            //go to  new page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuizScreen()),
            );
          },
        ),
      ),
    );
  }
}
