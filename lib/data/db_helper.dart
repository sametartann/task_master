import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_master/models/task.dart';

class DbHelper {

  var _db;

  Future<Database> get db async {
    _db ??= await initializeDb();
    return _db;
  }

  Future<Database> initializeDb() async {
    String dbPath = join(await getDatabasesPath(), "task_master.db");
    var taskMasterDb = await openDatabase(dbPath, version: 1, onCreate: createDb);
    return taskMasterDb;
  }

  void createDb(Database db, int version) async {
    await db.execute(
        "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT, taskStatus INTEGER, creationDateTime TEXT, processingStartDateTime TEXT, completedDateTime TEXT)"
    );
  }

  Future<List<Task>> fetchTasks() async {
    Database db = await this.db;
    var result = await db.query("tasks", orderBy: "id");
    return List.generate(result.length, (index) {
      return Task.fromObject(result[index]);
    });
  }

  Future<Task> fetchTask(int taskId) async {
    Database db = await this.db;
    var result = await db.query("tasks", where: 'id = ?', whereArgs: [taskId]);
    return Task.fromObject(result[0]);
  }

  Future<void> insert(Task task) async {
    Database db = await this.db;
    await db.insert("tasks", task.toMap());
  }

  Future<void> update(Task task) async {
    Database db = await this.db;
    await db.update("tasks", task.toMap(), where: "id = ?", whereArgs: [task.id]);
  }

  Future<void> deleteTask(int id) async {
    Database db = await this.db;
    await db.delete("tasks", where: "id = ?", whereArgs: [id]);
  }

}