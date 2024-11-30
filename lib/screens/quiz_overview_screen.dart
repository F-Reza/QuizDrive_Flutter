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
        foregroundColor: Colors.white,
        backgroundColor: Colors.amber,
        iconTheme: const IconThemeData(color: Colors.white),
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
            icon: const Icon(Icons.developer_board_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Ready to start the ${category.name} quiz?',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.access_time_outlined),
                  Text(
                    ' 15 Minutes',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8,),
                  Icon(Icons.quiz_outlined),
                  Text(
                    ' 20 Quizzes',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/quiz',
                    arguments: category, // Passing the category
                  );
                },
                child: const Text('Start Quiz'),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
