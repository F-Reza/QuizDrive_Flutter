import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database.dart';
import '../models/models.dart';

class LeaderBoardScreen extends StatefulWidget {
  final Category category;

  const LeaderBoardScreen({super.key, required this.category});

  @override
  _LeaderBoardScreenState createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.amber,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Leaderboard - ${widget.category.name}'),
        actions: [
          IconButton(
            onPressed: () {
              _clearLeaderboardData(context);
            },
            icon: const Icon(Icons.cleaning_services),
          ),
        ],
      ),
      body: FutureBuilder<List<LeaderboardEntry>>(
        future: _fetchLeaderboard(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No leaderboard data available.'));
          }

          final leaderboard = snapshot.data!;

          final highestScoreEntry = leaderboard.isNotEmpty
              ? leaderboard.first
              : null;

          return ListView(
            children: [
              if (highestScoreEntry != null) _buildHighestScoreWidget(highestScoreEntry),
              ...leaderboard.map((entry) => _buildLeaderboardCard(entry)),
            ],
          );
        },
      ),
    );
  }

  // Widget to display the highest score at the top
  Widget _buildHighestScoreWidget(LeaderboardEntry entry) {
    return Card(
      margin: const EdgeInsets.all(10),
      color: Colors.green[100],
      child: ListTile(
        title: Text('Highest Score: ${entry.name}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        subtitle: Text('Score: ${entry.score}', style: const TextStyle(fontSize: 18)),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Date: ${_formatDate(entry.timestamp)}'),
            Text('Time: ${_formatTime(entry.timestamp)}'),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardCard(LeaderboardEntry entry) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(entry.name),
        subtitle: Text('Score: ${entry.score}'),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Date: ${_formatDate(entry.timestamp)}'),
            Text('Time: ${_formatTime(entry.timestamp)}'),
          ],
        ),
      ),
    );
  }

  String _formatDate(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  String _formatTime(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('hh:mm a').format(dateTime);
  }

  Future<List<LeaderboardEntry>> _fetchLeaderboard() async {
    final db = await QuizDatabase.instance.database;
    final result = await db.query(
      'leaderboard',
      where: 'category_id = ?',
      whereArgs: [widget.category.id],
      orderBy: 'timestamp DESC, score DESC',
    );
    return result.map((e) => LeaderboardEntry.fromMap(e)).toList();
  }

  void _clearLeaderboardData(BuildContext context) async {
    // Show a confirmation dialog
    final shouldClear = await _showClearConfirmationDialog(context);

    if (shouldClear == true) {
      final db = await QuizDatabase.instance.database;
      await db.delete(
        'leaderboard',
        where: 'category_id = ?',
        whereArgs: [widget.category.id],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Leaderboard data cleared.')),
      );

      setState(() {});
    } else if (shouldClear == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Operation canceled.')),
      );
    }
  }

  Future<bool?> _showClearConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear Leaderboard Data'),
          content: const Text('Are you sure you want to clear all leaderboard data for this category?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }
}
