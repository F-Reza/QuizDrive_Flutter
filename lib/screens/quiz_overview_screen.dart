import 'package:flutter/material.dart';

import '../models/models.dart';
import 'leaderboard_screen.dart';


class QuizOverviewScreen extends StatelessWidget {
  const QuizOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as Category;

    return Scaffold(
      appBar: AppBar(
        title: Text('${category.name} Quiz'),
        actions: [
          IconButton(
            onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LeaderBoardScreen(category: category),
                  ),
                );
              },
            icon: const Icon(Icons.analytics_sharp),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Ready to start the ${category.name} quiz?',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/quiz',
                    arguments: category, // Passing the category
                  );
                },
                child: const Text('Start Quiz'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
