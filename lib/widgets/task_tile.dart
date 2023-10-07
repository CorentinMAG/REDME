import 'package:flutter/material.dart';
import 'package:redme/models/task.dart';
import 'package:redme/widgets/task_detail.dart';

class TaskTile extends StatefulWidget {
  Task task;
  Function onChanged;
  TaskTile({super.key, required this.task, required this.onChanged});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {

  void _toggleCompleted(bool? value) {
    setState(() {
      widget.task.isCompleted = !widget.task.isCompleted;
    });
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final int completedSubTasks =
        widget.task.subtasks.where((t) => t.isCompleted).length;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: () => {
          if (widget.task.subtasks.isNotEmpty) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetail(task: widget.task)))
          }
        },
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                    value: widget.task.isCompleted,
                    onChanged: _toggleCompleted,),
                Text(
                  widget.task.content,
                  style: TextStyle(
                    color: widget.task.isCompleted ? Colors.grey : Colors.black,
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ],
            ),
            if (widget.task.subtasks.isNotEmpty)
              Row(
                children: [
                  Text(
                    "$completedSubTasks / ${widget.task.subtasks.length}",
                    style: TextStyle(
                      color:
                          widget.task.isCompleted ? Colors.grey : Colors.black,
                    ),
                  ),
                ],
              )
          ]),
        ),
      ),
    );
  }
}
