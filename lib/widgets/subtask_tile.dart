import 'package:flutter/material.dart';
import 'package:redme/models/task.dart';

class SubTaskTile extends StatefulWidget {
  Task task;
  FocusNode focusNode;
  SubTaskTile({super.key, required this.task, required this.focusNode});

  @override
  State<SubTaskTile> createState() => _SubTaskTileState();
}

class _SubTaskTileState extends State<SubTaskTile> {

  late TextEditingController _textController;
  late bool _isChecked;

  void onChanged(bool? value) {
    setState(() {
      _isChecked = !_isChecked;
    });
    widget.task.isCompleted = _isChecked;
  }

  void onContentChanged(String text) {
    widget.task.content = text;
  }

  @override
  void initState() {
    _textController = TextEditingController(text: widget.task.content);
    _isChecked = widget.task.isCompleted;
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: ListTile(
        leading: Checkbox(
          value: _isChecked,
          onChanged: onChanged,
        ),
        title: TextField(
          focusNode: widget.focusNode,
          readOnly: false,
          controller: _textController,
          onChanged: onContentChanged,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Subtask...',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 18)
          ),
        ),
      ),
    );
  }
}