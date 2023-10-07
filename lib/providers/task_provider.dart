import 'package:flutter/material.dart';
import 'package:redme/models/task.dart';
import 'package:redme/providers/app_provider.dart';
import 'package:redme/services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  List<Task> _archivedTasks = [];

  final _taskService  = TaskService();

  List<Task> get tasks => _filteredTasks;
  List get archivedTasks => _archivedTasks;
  AppProvider _appProvider;
  
  TaskProvider(this._appProvider) {
    _loadTasksFromDB();
  }

  Future<void> _loadTasksFromDB() async {
    List<Task> tasks = await _taskService.fetchAll();
    _tasks.addAll(tasks.where((t) => !t.isArchived).toList());
    _archivedTasks.addAll(tasks.where((t) => t.isArchived).toList());
    _filteredTasks = List.from(_tasks);
    notifyListeners();
  }

  Future<int> create(Task task) async {
    final id = await _taskService.create(task);
    final newNote = task.copyWith(id: id);
    _tasks.insert(0, newNote);
    _filteredTasks.insert(0, newNote);
    notifyListeners();
    return id;
  }

  Future<void> delete(int id) async {
    await _taskService.delete(id);
    _tasks.removeWhere((note) => note.id == id);
    _filteredTasks.removeWhere((note) => note.id == id);
    notifyListeners();
  }

  Future<void> update(Task task) async {
    await _taskService.update(task);
    notifyListeners();
  }

  void updateState(AppProvider appProvider) {

  }


}