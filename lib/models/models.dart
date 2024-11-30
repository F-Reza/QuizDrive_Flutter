class Category {
  final int? id;
  final String name;

  Category({this.id, required this.name});

  factory Category.fromMap(Map<String, dynamic> json) => Category(
    id: json['id'] as int?,
    name: json['name'] as String,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
  };
}

class Question {
  final int? id;
  final int categoryId;
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final int answer;

  Question({
    this.id,
    required this.categoryId,
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.answer,
  });

  factory Question.fromMap(Map<String, dynamic> json) => Question(
    id: json['id'] as int?,
    categoryId: json['category_id'] as int,
    question: json['question'] as String,
    option1: json['option1'] as String,
    option2: json['option2'] as String,
    option3: json['option3'] as String,
    option4: json['option4'] as String,
    answer: json['answer'] as int,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'category_id': categoryId,
    'question': question,
    'option1': option1,
    'option2': option2,
    'option3': option3,
    'option4': option4,
    'answer': answer,
  };
}

class LeaderboardEntry {
  final int? id;
  final int categoryId;
  final String name;
  final int score;
  final String timestamp;  // Add the timestamp field

  LeaderboardEntry({
    this.id,
    required this.categoryId,
    required this.name,
    required this.score,
    required this.timestamp,  // Make sure to pass timestamp when creating the object
  });

  // Factory constructor to create an object from a Map (database entry)
  factory LeaderboardEntry.fromMap(Map<String, dynamic> json) => LeaderboardEntry(
    id: json['id'] as int?,
    categoryId: json['category_id'] as int,
    name: json['name'] as String,
    score: json['score'] as int,
    timestamp: json['timestamp'] as String,  // Retrieve timestamp from the database
  );

  // Method to convert an object to a Map for database insertion
  Map<String, dynamic> toMap() => {
    'id': id,
    'category_id': categoryId,
    'name': name,
    'score': score,
    'timestamp': timestamp,  // Include timestamp when inserting into the database
  };
}
