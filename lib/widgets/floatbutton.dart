import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redme/models/note.dart';
import 'package:redme/providers/app.dart';
import 'package:redme/providers/note.dart';
import 'package:redme/screens/editnote.dart';

class FloatButton extends StatelessWidget {
  const FloatButton({super.key});

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
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
                final newNote = Note(title: result["data"][0], content: result["data"][1]);
                await noteProvider.create(newNote);
              }
            },
            child: const Icon(Icons.add, size: 50),
          );
        }
      } 
    );
  }
}