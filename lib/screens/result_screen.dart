import 'package:flutter/material.dart';
import '../db/database.dart';
import '../models/models.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final Category category = args['category'];
    final int score = args['score'];
    final int total = args['total'];

    return Scaffold(
      appBar: AppBar(title: Text('Results for ${category.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You scored $score out of $total',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                final db = await QuizDatabase.instance.database;
                await db.insert('leaderboard', {
                  'category_id': category.id,
                  'name': 'Guest', // Replace with actual user input if needed
                  'score': score,
                });
                Navigator.pushNamed(
                  context,
                  '/leaderboard',
                  arguments: category,
                );
              },
              child: Text('Save to Leaderboard'),
            ),
          ],
        ),
      ),
    );
  }
}
