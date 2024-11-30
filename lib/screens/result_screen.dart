import 'package:flutter/material.dart';
import '../db/database.dart';
import '../models/models.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                'You scored $score out of $total',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              //Spacer(),
              const SizedBox(height: 20,),
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
