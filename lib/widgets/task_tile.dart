import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redme/models/task.dart';
import 'package:redme/providers/task_provider.dart';
import 'package:redme/widgets/task_detail.dart';

class TaskTile extends StatefulWidget {
  Task task;
  TaskTile({super.key, required this.task});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  TextEditingController _contentControler = TextEditingController();

  @override
  void initState() {
    _contentControler = TextEditingController(text: widget.task.content);
    super.initState();
  }

  @override
  void dispose() {
    _contentControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final int completedSubTasks =
        widget.task.subtasks.where((t) => t.isCompleted).length;
    return Dismissible(
      onDismissed: (direction) async {
        await taskProvider.delete(widget.task);
      },
      background: Container(
        color: Colors.red[200],
        child: const Center(
          child: Text(
            "DELETE",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      key: Key(
        widget.task.id != null ? widget.task.id.toString() : DateTime.now().toString(),
      ),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0),
          onTap: () => {
            if (widget.task.subtasks.isNotEmpty)
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Consumer<TaskProvider>(
                        builder: (context, taskProvider, child) =>
                            TaskDetail(task: widget.task),
                      );
                    },
                  ),
                )
              }
          },
          child: ListTile(
              contentPadding: const EdgeInsets.all(10.0),
              leading: Checkbox(
                onChanged: (bool? value) async {
                  await taskProvider.toggleCompleted(widget.task, value);
                },
                value: widget.task.isCompleted,
              ),
              title: widget.task.subtasks.isNotEmpty || widget.task.isCompleted
                  ? Text(widget.task.content,
                      style: widget.task.isCompleted
                          ? const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey)
                          : null)
                  : TextField(
                      controller: _contentControler,
                      readOnly: widget.task.subtasks.isNotEmpty,
                      onChanged: (value) => print("on change: $value"),
                      onEditingComplete: () => print("on complete: ${_contentControler.text}"),
                      onSubmitted: (value) => print("on submitted: $value"),
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
              trailing: widget.task.subtasks.isNotEmpty
                  ? Text(
                      "$completedSubTasks / ${widget.task.subtasks.length}",
                      style: TextStyle(
                          color: widget.task.isCompleted
                              ? Colors.grey
                              : Colors.black),
                    )
                  : null),
        ),
      ),
    );
  }
}
