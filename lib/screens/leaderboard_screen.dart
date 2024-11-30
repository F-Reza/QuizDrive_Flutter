import 'package:flutter/material.dart';
import '../db/database.dart';
import '../models/models.dart';

class LeaderBoardScreen extends StatelessWidget {
  const LeaderBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Category category = ModalRoute.of(context)!.settings.arguments as Category;

    return Scaffold(
      appBar: AppBar(title: Text('${category.name} Leaderboard')),
      body: FutureBuilder<List<LeaderboardEntry>>(
        future: _fetchLeaderboard(category.id!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final leaderboard = snapshot.data!;
          return ListView.builder(
            itemCount: leaderboard.length,
            itemBuilder: (context, index) {
              final entry = leaderboard[index];
              return ListTile(
                title: Text(entry.name),
                trailing: Text(entry.score.toString()),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<LeaderboardEntry>> _fetchLeaderboard(int categoryId) async {
    final db = await QuizDatabase.instance.database;
    final result = await db.query(
      'leaderboard',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'score DESC',
    );
    return result.map((e) => LeaderboardEntry.fromMap(e)).toList();
  }
}
