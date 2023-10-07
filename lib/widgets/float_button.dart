import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redme/models/note.dart';
import 'package:redme/providers/app_provider.dart';
import 'package:redme/providers/note_provider.dart';
import 'package:redme/screens/edit.dart';
import 'package:redme/services/notification_service.dart';
import 'package:redme/widgets/task_bottom_sheet.dart';

class FloatButton extends StatelessWidget {
  int index;
  FloatButton({super.key, required this.index});

  Future<void> _createNote(BuildContext context, NoteProvider noteProvider) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext ctx) => EditNote()));
    if (result != null) {
      final newNote = Note(
        title: result["data"][0], 
        content: result["data"][1], 
        reminderTime: result["data"][2],
        color: result["data"][3]
      );

      final id = await noteProvider.create(newNote);
      if (newNote.reminderTime != null) {
        NotificationService.scheduleLocalNotification(
          id, newNote.title, newNote.content, newNote.reminderTime!
        );
      }
    }
  }

  Future<void> _createTask(BuildContext context) async {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) => const TaskBottomSheet()
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    return Consumer<AppProvider>(
      builder: (BuildContext context, appProvider, child) {
        if (appProvider.isEditing) {
          return Container();
        }
        if (appProvider.isArchiveMode) {
          return Container();
        } else {
          return FloatingActionButton(
            tooltip: "Create note",
            backgroundColor: appProvider.isArchiveMode ? Colors.amber.shade500 : Theme.of(context).floatingActionButtonTheme.backgroundColor,
            onPressed: () => index == 0 ? _createNote(context, noteProvider) : _createTask(context),
            child: const Icon(Icons.add, size: 50),
          );
        }
      } 
    );
  }
}