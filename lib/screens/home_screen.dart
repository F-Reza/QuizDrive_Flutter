import 'package:flutter/material.dart';
import '../db/database.dart';
import '../models/models.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuizDrive'),
        leading: const Icon(Icons.light_mode_sharp),
      ),
      body: FutureBuilder<List<Category>>(
        future: _fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories available.'));
          }

          final categories = snapshot.data!;
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(category.name),
                  onTap: () {
                    // Navigate to quiz overview screen and pass selected category
                    Navigator.pushNamed(
                      context,
                      '/quiz-overview',
                      arguments: category, // Pass category when navigating to quiz overview
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Category>> _fetchCategories() async {
    final db = await QuizDatabase.instance.database;
    final result = await db.query('categories');
    return result.map((e) => Category.fromMap(e)).toList();
  }
}
