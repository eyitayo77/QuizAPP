import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz_model.dart';

Future<List<Question>> fetchQuestions() async {
  const url =
      'https://nosa.pythonanywhere.com/questions'; // Replace with your API URL
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Question.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load questions');
  }
}
