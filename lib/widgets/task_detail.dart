import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redme/models/task.dart';
import 'package:redme/providers/task_provider.dart';
import 'package:redme/widgets/button.dart';
import 'package:redme/widgets/task_tile.dart';

class TaskDetail extends StatefulWidget {
  Task task;
  TaskDetail({super.key, required this.task});

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  TextEditingController _titleController = TextEditingController();
  late List<Task> notCompletedTasks = [];
  late List<Task> completedTasks = [];

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.task.content);
    super.initState();
  }

  Future<bool> onWillPop() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    if (notCompletedTasks.isEmpty) {
      widget.task.isCompleted = true;
    } else if (completedTasks.length != widget.task.subtasks.length && widget.task.isCompleted) {
      widget.task.isCompleted = false;
    }
    print("content: ${widget.task.content}");
    await taskProvider.update(widget.task);
    Navigator.pop(context);
    return Future(() => true);
  }

  onPressedDelete() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    await taskProvider.delete(widget.task);
    Navigator.pop(context);
  }

  Widget _buttonRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      MyButton(
        color: Colors.grey.shade800.withOpacity(.8),
        tooltip: "Go back",
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: onWillPop,
      ),
      Row(children: [
        MyButton(
          tooltip: "Delete note",
          onPressed: onPressedDelete,
          icon: const Icon(
            Icons.delete_outline_outlined,
            color: Colors.white,
          ),
          color: Colors.red.withOpacity(.8),
        )
      ])
    ]);
  }


  @override
  Widget build(BuildContext context) {
    notCompletedTasks = widget.task.subtasks.where((t) => !t.isCompleted).toList();
    completedTasks = widget.task.subtasks.where((t) => t.isCompleted).toList();
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
          child: Column(
            children: [
              _buttonRow(),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.black87, fontSize: 30),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 30)),
              ),
              const SizedBox(
                height: 35,
              ),
              Expanded(
                child: ListView(
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        title: Row(
                          children: [
                            const Text("not completed tasks"),
                            const SizedBox(width: 25.0),
                            Text("${notCompletedTasks.length} / ${widget.task.subtasks.length}")
                          ],
                        ),
                        children: notCompletedTasks.map((t) => TaskTile(task: t,),).toList(),
                      ),
                    ),
                    Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Row(
                          children: [
                            const Text("completed tasks"),
                            const SizedBox(width: 25.0),
                            Text("${completedTasks.length} / ${widget.task.subtasks.length}")
                          ],
                        ),
                        children: completedTasks.map((t) => TaskTile(task: t,),).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
