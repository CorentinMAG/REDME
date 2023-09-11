import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:redme/data/colors.dart';
import 'package:redme/models/note.dart';
import 'package:redme/providers/app.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:redme/widgets/button.dart';

class EditNote extends StatefulWidget {
  final Note? note;
  const EditNote({super.key, this.note});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  final FocusNode _contentFocusNode = FocusNode();
  DateTime? _reminderTime;
  bool _changeColor = false;
  int _color = Colors.white.value;

  @override
  void initState() {
    if (widget.note != null) {
      _reminderTime = widget.note!.reminderTime;
      _color = widget.note!.color;
      _titleController = TextEditingController(text: widget.note!.title);
      _contentController = TextEditingController(text: widget.note!.content);
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

  Future<bool> onWillPop() async {
    if (widget.note != null) {
      // no modifiations
      if (_titleController.text == "" && _contentController.text == "" && widget.note!.reminderTime == _reminderTime && _color == widget.note!.color ) {
        Navigator.pop(context);
      // some modifications
      } else if (
        _titleController.text != widget.note!.title || 
        _contentController.text != widget.note!.content ||
        _reminderTime != widget.note!.reminderTime ||
        _color != widget.note!.color){
        Navigator.pop(context, {"action": "update", "data": [_titleController.text, _contentController.text, _reminderTime, _color]});
      } else {
        Navigator.pop(context);
      }
    } else {
      if (_titleController.text == "" && _contentController.text == "") {
        Navigator.pop(context);
      } else {
        Navigator.pop(context, {"action": "create", "data": [_titleController.text, _contentController.text, _reminderTime, _color]});
      }
    }
    return Future(() => true);
  }
  
  Future<void> onPressedArchive() async {
    if (widget.note != null && widget.note!.isArchived) {
      Navigator.pop(context, {"action": "unarchive", "data": widget.note});
    } else {
      Navigator.pop(context, {"action": "archive", "data": widget.note});
    }
  }

  Future<void> onPressedDelete(context) async {
    final result = await confirmDialog(context);
    if (result != null && result) {
      Navigator.pop(context, {"action": "delete", "data": widget.note});
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Color(_color),
        body: GestureDetector(
          onTap: _handleTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
            child: Column(
              children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyButton(
                    color: Colors.grey.shade800.withOpacity(.8),
                    tooltip: "Go back",
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: onWillPop,
                  ),
                  Row(
                    children: [
                      if (!appProvider.isArchiveMode)
                      MyButton(
                        tooltip: "Change color", 
                        onPressed: () {
                          setState(() {
                            _changeColor = !_changeColor;
                          });
                        }, 
                        icon: const Icon(
                          Icons.color_lens_outlined,
                          color: Colors.white
                        ), 
                        color: Colors.cyan
                      ),
                      if (widget.note != null)
                      MyButton(
                        tooltip: appProvider.isArchiveMode ? "Unarchive note" : "Archive note", 
                        onPressed: onPressedArchive, 
                        icon: const Icon(
                              Icons.archive_outlined,
                              color: Colors.white,
                        ),
                        color: Colors.amber.withOpacity(.8)
                      ),
                      MyButton(
                        tooltip: "Delete note",
                        onPressed: () => onPressedDelete(context),
                        icon: const Icon(
                          Icons.delete_outline_outlined,
                          color: Colors.white,
                        ),
                        color: Colors.red.withOpacity(.8),
                      )
                    ]
                  )
                ]
              ),
              Expanded(
                  child: ListView(
                    children: [
                      TextField(
                        readOnly: appProvider.isArchiveMode,
                        controller: _titleController,
                        style: const TextStyle(color: Colors.black87, fontSize: 30),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Title',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 30)),
                      ),
                      Row(
                        children: [
                          RichText(
                            maxLines: 1, 
                            overflow: TextOverflow.ellipsis, 
                            text: TextSpan(
                              text: widget.note != null ? 
                              Jiffy.parseFromDateTime(widget.note!.updatedAt).yMMMMEEEEdjm : 
                              Jiffy.parseFromDateTime(DateTime.now()).yMMMMEEEEdjm,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                                height: 1
                              )
                            ),
                          ),
                          Visibility(
                            visible: widget.note != null ? !widget.note!.isArchived : true,
                            child: GestureDetector(
                              onLongPress: () {
                                setState(() {
                                  _reminderTime = null;
                                });
                              },
                              child: IconButton(
                                onPressed: () {
                                  picker.DatePicker.showDateTimePicker(context,
                                    showTitleActions: true, 
                                    minTime: DateTime.now().add(const Duration(minutes: 5)),
                                    onConfirm: (date) {
                                      setState(() {
                                        _reminderTime = date;
                                      });
                                    },
                                    currentTime: DateTime.now().add(const Duration(minutes: 20)),
                                    locale: picker.LocaleType.en);
                                },
                                icon: Icon(Icons.timer_outlined, color: _reminderTime != null ? Colors.amber : Colors.black)
                              ),
                            ),
                          )
                        ],
                      ),
                      TextField(
                        readOnly: appProvider.isArchiveMode,
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
              ]
            ),
          ),
        ),
        bottomNavigationBar: AnimatedContainer(
          color: Colors.grey[300],
          duration: const Duration(milliseconds: 200),
          height: _changeColor ? 180 : 0.0,
          child: Container(
            padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: colors.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                    setState(() {
                      _color = colors[index].value;
                    });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage("assets/images/preview.png"),
                          scale: 8
                          ),
                        color: colors[index],
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                      width: 160,
                    ),
                  ),
                );
              }
            )
          )
        )
      )
    );
  }
}