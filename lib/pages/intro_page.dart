import 'package:flutter/material.dart';
import 'package:flutter_quiz_app/pages/login_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // ignore: prefer_const_constructors
          title: Text("I N T R O P A G E ")),
      body: Center(
        child: ElevatedButton(
          // ignore: prefer_const_constructors
          child: Text("go to home"),
          onPressed: () {
            //go to  new page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ),
    );
  }
}
