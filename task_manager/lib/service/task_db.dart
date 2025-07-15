import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_manager/models/task.dart'; 

class TaskDB {
  static final TaskDB instance = TaskDB._init();
  static Database? _database;
  TaskDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        deadline TEXT,
        isCompleted INTEGER NOT NULL
      )
    ''');
  }

  Future<List<Task>> getTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks');
    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<List<Task>> getTaskPage({int offset = 0, int limit = 20}) async {
  final db = await instance.database;
  final result = await db.query(
    'tasks',
    limit: limit,
    offset: offset,
    orderBy: 'id DESC',
  );
  return result.map((e) => Task.fromMap(e)).toList();
}

  //CREATE TASK
  Future<int> insertTask(Task task) async {
    final db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  //EDIT TASK
  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  //REMOVE TASK
  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
