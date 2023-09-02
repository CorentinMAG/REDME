import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redme/models/note.dart';
import 'package:redme/providers/note.dart';
import 'package:redme/screens/editnote.dart';

class CreateFloatBtn extends StatelessWidget {
  const CreateFloatBtn({super.key});

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    return FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext ctx) => EditNote())
          );
        if (result != null) {
          final newNote = Note(title: result[0], content: result[1]);
          await noteProvider.create(newNote);
        }
        },
      child: const Icon(Icons.add, size: 50),
    );
  }
}