import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redme/models/note.dart';
import 'package:redme/providers/app.dart';
import 'package:redme/providers/note.dart';
import 'package:redme/screens/edit.dart';
import 'package:redme/services/notification.dart';

class FloatButton extends StatelessWidget {
  const FloatButton({super.key});

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
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext ctx) => EditNote())
              );
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
            },
            child: const Icon(Icons.add, size: 50),
          );
        }
      } 
    );
  }
}