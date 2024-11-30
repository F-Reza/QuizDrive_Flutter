import 'package:flutter/material.dart';
import '../models/models.dart';

class AnswerCheckScreen extends StatelessWidget {
  const AnswerCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final Question question = args['question'];
    final int selectedAnswer = args['selectedAnswer'];

    return Scaffold(
      appBar: AppBar(title: const Text('Answer Check')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Question:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(question.question),
            const SizedBox(height: 20),
            const Text(
              'Your Answer:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(selectedAnswer == question.answer
                ? 'Correct: ${_getOptionText(question, selectedAnswer)}'
                : 'Incorrect: ${_getOptionText(question, selectedAnswer)}'),
            const SizedBox(height: 20),
            const Text(
              'Correct Answer:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(_getOptionText(question, question.answer)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'next');
              },
              child: const Text('Next Question'),
            ),
          ],
        ),
      ),
    );
  }

  String _getOptionText(Question question, int option) {
    switch (option) {
      case 1:
        return question.option1;
      case 2:
        return question.option2;
      case 3:
        return question.option3;
      case 4:
        return question.option4;
      default:
        return '';
    }
  }
}
