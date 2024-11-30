import 'package:flutter/material.dart';
import 'dart:async';

import '../db/database.dart';
import '../models/models.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Category category;
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  late Timer _timer;
  int _timeLeft = 600;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    category = ModalRoute.of(context)!.settings.arguments as Category; // Fetching category from the route
    _loadQuestions();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _timer.cancel();
        _endQuiz();
      }
    });
  }

  Future<void> _loadQuestions() async {
    final db = await QuizDatabase.instance.database;
    final result = await db.query('questions', where: 'category_id = ?', whereArgs: [category.id]);
    setState(() {
      _questions = result.map((e) => Question.fromMap(e)).toList();
    });
  }

  void _answerQuestion(int selectedOption) {
    if (_questions[_currentIndex].answer == selectedOption) {
      _score++;
    }
    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      _endQuiz();
    }
  }

  void _endQuiz() {
    Navigator.pushNamed(
      context,
      '/result',
      arguments: {
        'category': category,
        'score': _score,
        'total': _questions.length,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final question = _questions[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('${category.name} Quiz'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('Time: ${_timeLeft}s')),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Q: ${question.question}', style: TextStyle(fontSize: 18)),
            ...List.generate(4, (index) {
              final option = [question.option1, question.option2, question.option3, question.option4][index];
              return ElevatedButton(
                onPressed: () => _answerQuestion(index + 1),
                child: Text(option),
              );
            }),
          ],
        ),
      ),
    );
  }
}
