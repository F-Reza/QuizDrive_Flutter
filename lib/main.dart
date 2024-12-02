import 'package:flutter/material.dart';
import 'package:quiz_drive/screens/answer_check_screen.dart';
import 'package:quiz_drive/screens/home_screen.dart';
import 'package:quiz_drive/screens/leaderboard_screen.dart';
import 'package:quiz_drive/screens/quiz_overview_screen.dart';
import 'package:quiz_drive/screens/quiz_screen.dart';
import 'package:quiz_drive/screens/result_screen.dart';

import 'models/models.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuizDrive',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/quiz-overview': (context) => const QuizOverviewScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/answer-check': (context) => const AnswerCheckScreen(),
        '/result': (context) => const ResultScreen(),
        '/leaderboard': (context) => LeaderBoardScreen(category: ModalRoute.of(context)!.settings.arguments as Category),
      },
    );
  }
}

