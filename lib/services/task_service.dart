import 'package:redme/models/task.dart';
import 'package:redme/repositories/task_repository.dart';

class TaskService {
  final taskRepository = TaskRepository();

  Future<List<Task>> fetchAll() => taskRepository.fetchAll();

  Future<int> create(Task task) {
    task.subtasks.removeWhere((t) => t.content.trim().isEmpty);
    final id = taskRepository.create(task);
    return id;
  }

  Future<int> update(Task task) => taskRepository.update(task);

  Future<int> delete(int id) => taskRepository.delete(id);

}