import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redme/providers/app.dart';
import 'package:redme/providers/note.dart';

class SearchField extends StatelessWidget {
  final TextEditingController textController = TextEditingController();
  SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    return Consumer<AppProvider>(
      builder: (BuildContext context, appProvider, child) {
        return TextField(
          controller: textController,
          onChanged: (String text) {
            if (text == "") {
              appProvider.isEditing = false;
            } else if(!appProvider.isEditing) {
              appProvider.isEditing = true;
            }
            noteProvider.filter(text);
            noteProvider.sortByLastUpdated();
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
            suffixIcon: appProvider.isEditing ? IconButton(
              onPressed: () {
                textController.clear();
                noteProvider.filter("");
                appProvider.isEditing = false;
                },
              icon: const Icon(Icons.clear_outlined),
              color: Colors.grey,
              
            ) : null,
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
      }
    );
  }
}