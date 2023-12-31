import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redme/providers/app_provider.dart';
import 'package:redme/providers/note_provider.dart';
import 'package:redme/providers/task_provider.dart';

class SearchField extends StatefulWidget {
  int index;
  SearchField({super.key, required this.index});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    return Consumer<AppProvider>(
        builder: (BuildContext context, appProvider, child) {
      return TextField(
        controller: _textController,
        onChanged: (text) {
            if (text == "") {
              appProvider.isEditing = false;
            } else if (!appProvider.isEditing) {
              appProvider.isEditing = true;
            }

            if (widget.index == 0) {
            noteProvider.filter(text);
            noteProvider.sortByLastUpdated();
            } else if (widget.index == 1) {
              taskProvider.filter(text);
            }
        },
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          hintText: "Search...",
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.grey,
          ),
          suffixIcon: appProvider.isEditing
              ? IconButton(
                  onPressed: () {
                    _textController.clear();
                    noteProvider.filter("");
                    appProvider.isEditing = false;
                  },
                  icon: const Icon(Icons.clear_outlined),
                  color: Colors.grey,
                )
              : null,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
        ),
      );
    });
  }
}
