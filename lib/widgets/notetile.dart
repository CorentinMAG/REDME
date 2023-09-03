import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:redme/models/note.dart';
import 'package:redme/providers/app.dart';
import 'package:redme/providers/note.dart';
import 'package:redme/screens/editnote.dart';

class NoteTile extends StatefulWidget {
  final Note note;
  const NoteTile({super.key, required this.note});

  @override
  State<NoteTile> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteTile> {
  bool selectedMode = false;

  Future<void> _doAction(NoteProvider provider, Map data) async {
    switch (data["action"]) {
      case "delete":
        final Note note = data["data"];
        await provider.delete(note.id!);
        break;
      case "archive":
        final Note note = data["data"];
        await provider.archive(note);
        break;
      case "update":
        final List<String> d = data["data"];
        final Note note = widget.note.copyWith(
          title: d[0],
          content: d[1],
          updatedAt: DateTime.now()
        );
        await provider.update(note);
        provider.sortByLastUpdated();
        break;
      case "unarchive":
      final Note note = data["data"];
      await provider.unarchive(note);
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    return 
        Container(
          width: double.infinity,
          child: Card(
            color: Color(widget.note.color),
            margin: const EdgeInsets.only(bottom: 20),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)),
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onLongPress: () {
                  appProvider.toggleSelectedMode();
                  noteProvider.toggleSelected(widget.note);
                },
                onTap: () async {
                  if (appProvider.isSelectedMode) {
                    noteProvider.toggleSelected(widget.note);

                  } else {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext ctx) => EditNote(note: widget.note))
                    );
                    if (result != null) {
                      await _doAction(noteProvider, result);
                    }
                  }
                },
                child: Stack(
                  children: [
                      Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            maxLines: 1, 
                            overflow: TextOverflow.ellipsis, 
                            text: TextSpan(
                              text: widget.note.title,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                height: 1.5
                              )
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: RichText(
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: widget.note.content,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                  height: 1.5
                                ),
                              )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              Jiffy.parseFromDateTime(widget.note.updatedAt).fromNow(),
                              style: TextStyle(
                                fontSize: 10,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey.shade800
                              )
                            )
                          ),
                        ],
                      )
                    ),
                    Visibility(
                      visible: appProvider.isSelectedMode,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          color: Colors.grey,
                          onPressed: () => {}, 
                          icon: widget.note.isSelected ? const Icon(Icons.check_circle) : const Icon(Icons.circle)
                        ),
                      )
                    )
                  ],
                )
              )
          ),
        );
  }
}