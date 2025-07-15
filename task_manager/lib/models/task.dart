class Task {
  int? id;
  String title;
  String? description;
  DateTime? deadline;
  bool isCompleted;

  Task({
    this.id,
    required this.title,
    this.description,
    this.deadline,
    this.isCompleted = false,
  });

 //Methods needed for Sqflite
 
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline?.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      deadline: map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
