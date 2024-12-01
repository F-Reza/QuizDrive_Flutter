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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('images/bg-1.gif',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 14),
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
                        ' 10 Minutes',
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
                  const SizedBox(height: 16,),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          Colors.amber,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/quiz',
                        arguments: category, // Passing the category
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Start Quiz',style: TextStyle(fontSize: 16,color: Colors.white),),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Image.asset('images/qtime.jpg',width: MediaQuery.of(context).size.width,),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
