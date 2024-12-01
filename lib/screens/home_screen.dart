import 'package:flutter/material.dart';
import '../db/database.dart';
import '../models/models.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.amber,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('QuizDrive',
          style: TextStyle(fontSize: 24,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
          ),
        ),
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
                color: Colors.amber.withOpacity(0.5),
                elevation: 2,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(category.name,
                    style: const TextStyle(fontSize: 22),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/quiz-overview',
                      arguments: category,
                    );
                  },
                  subtitle: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.access_time_outlined),
                        Text(
                          ' 10 Minutes',
                          style: TextStyle(fontWeight: FontWeight.w300,color: Colors.white),
                        ),
                        SizedBox(width: 8,),
                        Icon(Icons.quiz_outlined),
                        Text(
                          ' 20 Quizzes',
                          style: TextStyle(fontWeight: FontWeight.w300,color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  //leading: const Icon(Icons.light_mode_sharp,size: 40,),
                  trailing: Image.asset('images/trophy1.png',height: 45,),
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
