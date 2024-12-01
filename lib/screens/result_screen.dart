import 'package:flutter/material.dart';
import '../models/models.dart';
import 'leaderboard_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final Category category = args['category'];
    final int score = args['score'];
    final int total = args['total'];

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.amber,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Results for ${category.name}'),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Stack(
                children: [
                  Image.asset('images/giphy.gif',width: MediaQuery.of(context).size.width,),
                  const Positioned(
                    left: 50,
                    right: 50,
                    top: 20,
                      child: Text('Congratulations!',
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                  ),

                ],
              ),
              Text(
                'You scored $score out of $total',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 0,),
              Text('You have got $score Points'),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pushReplacementNamed(
                    context,
                    '/',
                    arguments: category,
                  );
                },
                child: const Text('Back to Home'),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
