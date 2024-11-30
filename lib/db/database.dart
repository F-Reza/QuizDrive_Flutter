import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class QuizDatabase {
  static final QuizDatabase instance = QuizDatabase._init();
  static Database? _database;

  QuizDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quiz.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL,
        question TEXT NOT NULL,
        option1 TEXT NOT NULL,
        option2 TEXT NOT NULL,
        option3 TEXT NOT NULL,
        option4 TEXT NOT NULL,
        answer INTEGER NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE leaderboard (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        score INTEGER NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      );
    ''');

    // Automatically seed categories after creating the database
    await _seedCategories(db);
  }

  Future<void> _seedCategories(Database db) async {
    final existing = await db.query('categories');
    if (existing.isEmpty) {
      await db.insert('categories', {'name': 'Physics'});
      await db.insert('categories', {'name': 'Chemistry'});
      await db.insert('categories', {'name': 'Math'});
      await db.insert('categories', {'name': 'Bangla'});
      await db.insert('categories', {'name': 'English'});
      await db.insert('categories', {'name': 'ICT'});
    }
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) await db.close();
  }
}

