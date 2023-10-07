import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redme/models/task.dart';
import 'package:redme/providers/task_provider.dart';
import 'package:redme/widgets/subtask_tile.dart';

class TaskBottomSheet extends StatefulWidget {
  const TaskBottomSheet({super.key});

  @override
  State<TaskBottomSheet> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  final _textController = TextEditingController();
  final ScrollController _listController = ScrollController();
  late Task task;
  List<Task> subtasks = [];
  bool _needsScroll = false;

  addSubtask(Task task) {
    setState(() {
      subtasks.add(task);
    });
    _needsScroll = true;
  }

  Widget makeDismissable({required Widget child}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(onTap: () {}, child: child)
    );
  }

  void _scrollToEnd() {
    _listController.animateTo(
      _listController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300)
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    if (_needsScroll) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollToEnd()
      );
      _needsScroll = false;
    }
    return makeDismissable(
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.8,
        minChildSize: 0.2,
        builder: (context, controller) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              color: Colors.white
              ),
            padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  controller: _textController,
                  style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    helperStyle: TextStyle(fontWeight: FontWeight.bold),
                    hintText: 'Task...',
                    hintStyle: TextStyle(color: Colors.grey)),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _listController,
                    itemCount: subtasks.length + 1,
                    itemBuilder: (context, index) {
                      if (index < subtasks.length) {
                        return SubTaskTile(task: subtasks[index]);
                      } else {
                        return ListTile(
                          leading: const Icon(Icons.add),
                            contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                            onTap: () {
                              addSubtask(Task(content: ""));
                            },
                            title: const Text("Add subtask"),
                        );
                      }
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                      task = Task(content: _textController.text);
                      task.subtasks = subtasks;
                      await taskProvider.create(task);
                      Navigator.of(context).pop();
                    }, 
                    child: const Text("Done")
                  ),
                )
              ]
            )
        );
        }
      ),
    );
  }
}