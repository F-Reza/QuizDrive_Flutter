import 'package:flutter/material.dart';
import 'package:quiz_drive/screens/answer_check_screen.dart';
import 'package:quiz_drive/screens/home_screen.dart';
import 'package:quiz_drive/screens/leaderboard_screen.dart';
import 'package:quiz_drive/screens/quiz_overview_screen.dart';
import 'package:quiz_drive/screens/quiz_screen.dart';
import 'package:quiz_drive/screens/result_screen.dart';

import 'models/models.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuizDrive',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/quiz-overview': (context) => QuizOverviewScreen(),
        '/quiz': (context) => QuizScreen(),
        '/answer-check': (context) => AnswerCheckScreen(),
        '/result': (context) => ResultScreen(),
        '/leaderboard': (context) => LeaderBoardScreen(category: ModalRoute.of(context)!.settings.arguments as Category),
      },
    );
  }
}

