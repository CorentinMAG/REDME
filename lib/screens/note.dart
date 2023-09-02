import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redme/models/note.dart';
import 'package:redme/providers/note.dart';
import 'package:redme/widgets/indicator.dart';
import 'package:redme/widgets/notetile.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Indicator(
      child: Container(
        color: Colors.white,
        child: Consumer<NoteProvider>(
          builder: (BuildContext ctx, noteProvider, child) {
            if (noteProvider.notes.isEmpty) {
              return Center(
                child: Image.asset("assets/images/note.png", scale: 2,),
              );
            } else {
              return GridView.count(
                //physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                children: List.generate(noteProvider.notes.length, (idx) {
                  final Note note = noteProvider.notes[idx];
                  return NoteTile(note: note);
                })
              );
            }
          }
        ),
      ),
    );
  }
}