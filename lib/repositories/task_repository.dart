import 'package:redme/db/db.dart';
import 'package:redme/models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:redme/exceptions/task.dart';

class TaskRepository {

  Future<Map> create(Task task) async {
    if (task.id != null) throw TaskException("Task has an id");

    Database db = await DatabaseManager.initializeDB();
    final id = await db.insert('task', task.toMap3(), conflictAlgorithm: ConflictAlgorithm.replace);

    List<int> subtaskIds = [];
    for (final subtask in task.subtasks) {
      subtask.parentId = id;
      final subtaskId = await db.insert("task", subtask.toMap3(), conflictAlgorithm: ConflictAlgorithm.replace);
      subtaskIds.add(subtaskId);
    }
    return {"id": id, "subtaskIds": subtaskIds};
  }

  Future<int> update(Task task) async {
    if (task.id == null) throw TaskException("Note has no id");

    Database db = await DatabaseManager.initializeDB();
    var result = db.update("task", task.toMap3(), where: "id=?", whereArgs: [task.id]);

    for (final subtask in task.subtasks) {
      final subtask_id = await db.update("task", subtask.toMap3(), where: "id=?", whereArgs: [subtask.id]);
    }
    return result;
  }

  Future<int> delete(int id) async {
    Database db = await DatabaseManager.initializeDB();
    var result = db.delete("task", where: "id=?", whereArgs: [id]);
    return result;
  }

  Future<List<Task>> fetchAll() async {
    Database db = await DatabaseManager.initializeDB();

    List<Map<String, dynamic>> maps = await db.query("task", where: "parentId is NULL");
    List<Task> tasks = maps.map((e) => Task.fromDatabase3(e)).toList();


    for (var task in tasks) {
      final maps = await db.query("task", where: "parentId=?", whereArgs: [task.id]);
      final subtasks = maps.map((e) => Task.fromDatabase3(e)).toList();
      task.subtasks = subtasks;
    }

    return tasks;
  }
}