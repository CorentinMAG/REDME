import 'package:flutter/material.dart';
import 'package:redme/models/task.dart';
import 'package:redme/providers/app_provider.dart';
import 'package:redme/services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  List<Task> _completedTasks = [];

  final _taskService  = TaskService();

  List<Task> get tasks => _filteredTasks;
  List get completedTasks => _completedTasks;
  AppProvider _appProvider;
  
  TaskProvider(this._appProvider) {
    _loadTasksFromDB();
  }

  Future<void> _loadTasksFromDB() async {
    List<Task> tasks = await _taskService.fetchAll();
    _tasks.addAll(tasks.where((t) => !t.isCompleted).toList());
    _completedTasks.addAll(tasks.where((t) => t.isCompleted).toList());
    _filteredTasks = List.from(_tasks);
    notifyListeners();
  }

  Future<Map> create(Task task) async {
    final ids = await _taskService.create(task);
    final id = ids["id"];
    final subtask_ids = ids["subtaskIds"];
    final List<Task> subtasks = [];
    for (var i = 0; i < task.subtasks.length; i++) {
      final subtask = task.subtasks[i];
      subtask.id = subtask_ids[i];
      subtasks.add(subtask);
    }
    final newNote = task.copyWith(id: id, subtasks: subtasks);
    _tasks.insert(0, newNote);
    _filteredTasks.insert(0, newNote);
    notifyListeners();
    return ids;
  }

  Future<void> delete(Task task) async {
    final parentId = task.parentId;
    await _taskService.delete(task.id!);

    if (parentId == null) {
      for (var i = 0; i < task.subtasks.length; i++) {
        await _taskService.delete(task.subtasks[i].id!);
      }
      _tasks.removeWhere((t) => t.id == task.id);
      _filteredTasks.removeWhere((t) => t.id == task.id);
    } else {
      final parentTask = _filteredTasks.firstWhere((t) => t.id == parentId);
      parentTask.subtasks.removeWhere((t) => t.id == task.id);
    }
 
    notifyListeners();
  }

  Future<void> update(Task task) async {
    await _taskService.update(task);
    if (task.isCompleted) {
      _tasks.removeWhere((t) => t.id == task.id);
      _completedTasks.insert(0, task);
    } else {
      _completedTasks.removeWhere((t) => t.id == task.id);
      _tasks.insert(0, task);
    }
    notifyListeners();
  }

  Future<void> toggleCompleted(Task task, bool? value) async {
    task.isCompleted = !task.isCompleted;
    if (task.subtasks.isNotEmpty) {
      for (var i = 0; i < task.subtasks.length; i++) {
        final subtask = task.subtasks[i];
        subtask.isCompleted = task.isCompleted;
      }
    }
    await update(task);
  }

  void updateState(AppProvider appProvider) {
    _appProvider = appProvider;

    // if (appProvider.isArchiveMode) {
    //   _filteredTasks = List.from(_completedTasks);
    // } else {
    //   _filteredTasks = List.from(_tasks);
    // }

    // notifyListeners();

  }
 
  void filter(String searchText) {
    final searchTextlow = searchText.toLowerCase();
    if (_appProvider.isArchiveMode) {
      _filteredTasks = _completedTasks.where((t) {
        final contents = t.subtasks.map((t) => t.content).toList();
        contents.add(t.content);

        return contents.contains(searchTextlow);
      }).toList();
    } else {
      _filteredTasks = _tasks.where((t) {
        final contents = t.subtasks.map((t) => t.content).toList();
        contents.add(t.content);
        return contents.contains(searchTextlow);
      }).toList();
    }
    notifyListeners();
  }

}