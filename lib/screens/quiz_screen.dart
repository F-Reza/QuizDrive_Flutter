import 'package:flutter/material.dart';
import 'dart:async';

import '../db/database.dart';
import '../models/models.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Category category;
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  late Timer _timer;
  int _timeLeft = 1200; // Start with 20 minutes (1200 seconds)
  bool _isAnswered = false;
  bool _isCorrect = false;

  static int testCounter = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    category = ModalRoute.of(context)!.settings.arguments as Category;
    _loadQuestions();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _timeLeft > 0) {
        setState(() => _timeLeft--);
      } else if (mounted) {
        _timer.cancel();
        _endQuiz();
      }
    });
  }

  Future<void> _loadQuestions() async {
    final db = await QuizDatabase.instance.database;
    final result = await db.rawQuery(
        'SELECT * FROM questions WHERE category_id = ? ORDER BY RANDOM() LIMIT 20',
        [category.id]
    );

    if (mounted) {
      setState(() {
        _questions = result.map((e) => Question.fromMap(e)).toList();
      });
    }
  }


  void _answerQuestion(int selectedOption) {
    if (mounted) {
      setState(() {
        _isAnswered = true;
        _isCorrect = _questions[_currentIndex].answer == selectedOption;
        if (_isCorrect) {
          _score++;
        }
      });
    }
  }

  void _nextQuestion() {
    if (mounted && _currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _isAnswered = false;
        _isCorrect = false;
      });
    } else {
      _endQuiz();
    }
  }

  void _endQuiz() async {
    _timer.cancel();

    String timestamp = DateTime.now().toIso8601String();
    String playerName = 'TEST-${testCounter++}';

    final db = await QuizDatabase.instance.database;
    await db.insert('leaderboard', {
      'category_id': category.id,
      'name': playerName,
      'score': _score,
      'timestamp': timestamp,
    });

    if (mounted) {
      setState(() {
        _timeLeft = 1200; // Reset to 20 minutes
      });
    }

    Navigator.pushReplacementNamed(
      context,
      '/result',
      arguments: {
        'category': category,
        'score': _score,
        'total': _questions.length,
      },
    );
  }

  // Intercept back button press
  Future<bool> _onWillPop() async {
    // Show confirmation dialog
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit Quiz'),
          content: const Text('Are you sure you want to exit the quiz? Your progress will not be saved.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Exit'),
            ),
          ],
        );
      },
    ) ?? false;

    if (shouldExit) {
      _endQuiz();
    }

    return shouldExit;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final question = _questions[_currentIndex];
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.amber,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text('${category.name} Quiz'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text('Time: ${_formatTime(_timeLeft)}')),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Q: ${question.question}', style: const TextStyle(fontSize: 18)),
              ...List.generate(4, (index) {
                final option = [
                  question.option1,
                  question.option2,
                  question.option3,
                  question.option4
                ][index];
                return ElevatedButton(
                  onPressed: _isAnswered
                      ? null
                      : () => _answerQuestion(index + 1),
                  style: ButtonStyle(
                    backgroundColor: _isAnswered
                        ? (_isCorrect && index + 1 == question.answer
                        ? WidgetStateProperty.all(Colors.green)
                        : (index + 1 == question.answer
                        ? WidgetStateProperty.all(Colors.red)
                        : WidgetStateProperty.all(Colors.grey)))
                        : WidgetStateProperty.all(Colors.blue),
                  ),
                  child: Text(option),
                );
              }),
              const SizedBox(height: 20),
              // Show progress box below the question
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 50,
                decoration: BoxDecoration(
                  color: _isAnswered
                      ? (_isCorrect ? Colors.green : Colors.red)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    _isAnswered
                        ? (_isCorrect ? 'Correct!' : 'Incorrect!')
                        : '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isAnswered ? _nextQuestion : null,
                child: Text(_currentIndex == _questions.length - 1
                    ? 'Finish Quiz'
                    : 'Next Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
