import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'package:flutter_quiz_app/components/my_button.dart';
import 'package:flutter_quiz_app/components/my_textfield.dart';
import 'package:flutter_quiz_app/components/square_tile.dart';
import 'package:flutter_quiz_app/pages/intro_page.dart';
import 'package:flutter_quiz_app/pages/signup_page.dart'; // Assuming you have a signup page

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text editing controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false; // To show a loading indicator

  // Method to show error messages
  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Sign user in method
  Future<void> signUserIn() async {
    setState(() {
      isLoading = true;
    });

    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();

    // Basic validation
    if (username.isEmpty || password.isEmpty) {
      showError('Please enter both username and password.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    final Uri loginUrl = Uri.parse('https://nosa.pythonanywhere.com/login');

    try {
      final response = await http.post(
        loginUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String token = data['token']; // Adjust based on API response

        // Optionally, you can verify the token
        final bool isValid = await verifyToken(token);
        if (isValid) {
          // Navigate to IntroPage on successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const IntroPage()),
          );
        } else {
          showError('Invalid token. Please try logging in again.');
        }
      } else {
        // Handle different status codes accordingly
        final data = jsonDecode(response.body);
        final String error = data['error'] ?? 'Login failed. Please try again.';
        showError(error);
      }
    } catch (e) {
      showError('An error occurred. Please try again.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Signup method (optional if you have a signup page)
  Future<void> signUserUp() async {
    // Implement signup logic similar to signUserIn
  }

  // Token verification method
  Future<bool> verifyToken(String token) async {
    final Uri tokenUrl =
        Uri.parse('https://nosa.pythonanywhere.com/test_token');

    try {
      final response = await http.get(
        tokenUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Adjust based on API requirements
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 25.0), // Added padding for better UI
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // Logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(height: 50),

                // Welcome back message
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // Username textfield
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // Password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // Forgot password?
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Implement forgot password functionality
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Sign in button
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : signUserIn, // Disable button when loading
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                ),

                const SizedBox(height: 50),

                // Or continue with
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // Google + Apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // Google button
                    SquareTile(imagePath: 'lib/images/google.png'),

                    SizedBox(width: 25),

                    // Apple button
                    SquareTile(imagePath: 'lib/images/apple.png'),
                  ],
                ),

                const SizedBox(height: 50),

                // Not a member? Register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        // Navigate to Signup Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupPage()),
                        );
                      },
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
