import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:redme/models/note.dart';

class EditNote extends StatefulWidget {
  final Note? note;
  EditNote({super.key, this.note});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  final FocusNode _contentFocusNode = FocusNode();
  DateTime updatedAt = DateTime.now();

  String? _originalTitle;
  String? _originalContent;

  @override
  void initState() {
    if (widget.note != null) {
      updatedAt = widget.note!.updatedAt;
      _originalTitle = widget.note!.title;
      _originalContent = widget.note!.content;
      _titleController = TextEditingController(text: _originalTitle);
      _contentController = TextEditingController(text: _originalContent);
    }
    super.initState();
  }

  @override
  void dispose() {
    _contentFocusNode.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!_contentFocusNode.hasFocus) {
      FocusScope.of(context).requestFocus(_contentFocusNode);
    }
  }

  Future<dynamic> confirmDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Are you sure you want to delete?',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilledButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: FilledButton.styleFrom(backgroundColor: Colors.green),
                      child: const SizedBox(
                        width: 60,
                        child: Text(
                          'Yes',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      )),
                  FilledButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      style:
                          FilledButton.styleFrom(backgroundColor: Colors.red),
                      child: const SizedBox(
                        width: 60,
                        child: Text(
                          'No',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      )),
                ]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_titleController.text == "" && _contentController.text == "") {
          Navigator.pop(context);
        } else if (_titleController.text != _originalTitle || _contentController.text != _originalContent) {
          Navigator.pop(context, [_titleController.text, _contentController.text]);
        } else {
          Navigator.pop(context);
        }
        return Future(() => true);
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: _handleTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
            child: Column(
              children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        if (_titleController.text == "" && _contentController.text == "") {
                          Navigator.pop(context);
                        } else if (_titleController.text != _originalTitle || _contentController.text != _originalContent) {
                          Navigator.pop(context, [_titleController.text, _contentController.text]);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      padding: const EdgeInsets.all(0),
                      icon: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade800.withOpacity(.8),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      )
                    ),
                  IconButton(
                      onPressed: () async {
                        final result = await confirmDialog(context);
                        if (result != null && result) {
                          Navigator.pop(context, widget.note);
                        }
                      },
                      padding: const EdgeInsets.all(0),
                      icon: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.red.withOpacity(.8),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          Icons.delete_outline_outlined,
                          color: Colors.white,
                        ),
                      )
                    ),
                ],
              ),
              Expanded(
                  child: ListView(
                    children: [
                      TextField(
                        controller: _titleController,
                        style: const TextStyle(color: Colors.black87, fontSize: 30),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Title',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 30)),
                      ),
                      RichText(
                          maxLines: 1, 
                          overflow: TextOverflow.ellipsis, 
                          text: TextSpan(
                            text: Jiffy.parseFromDateTime(updatedAt).yMMMMEEEEdjm,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                              height: 1
                            )
                          ),
                        ),
                      TextField(
                          focusNode: _contentFocusNode,
                          keyboardType: TextInputType.multiline,
                          controller: _contentController,
                          style: const TextStyle(
                            color: Colors.black87,
                          ),
                          maxLines: null,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type something here',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              )
                          ),
                        ),
                    ],
                  )
                )
            ]),
          ),
        )
      ),
    );
  }
}