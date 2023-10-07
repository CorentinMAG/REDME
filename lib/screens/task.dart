import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redme/providers/task_provider.dart';
import 'package:redme/widgets/task_tile.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Consumer<TaskProvider>(
        builder: (BuildContext context, taskProvider, child) {
          if (taskProvider.tasks.isEmpty) {
            return ListView(children: [
              Container(
                child: Image.asset("assets/images/task.png", scale: 2),
              )
            ]);
          } else {
            return ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (BuildContext context, int index) {
                final task = taskProvider.tasks[index];
                return Dismissible(
                  background: Container(
                    color: Colors.red[200],
                    child: const Center(
                        child: Text(
                      "DELETE",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                  key: Key(task.id!.toString()),
                  child: TaskTile(
                    task: task,
                    onChanged: () {
                      if (task.subtasks.isNotEmpty) {
                        for (int i = 0; i < task.subtasks.length; i++) {
                          final subtask = task.subtasks[i];
                          subtask.isCompleted = task.isCompleted;
                        }
                      }
                    },
                  ),
                  onDismissed: (direction) {
                    taskProvider.delete(task.id!);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
