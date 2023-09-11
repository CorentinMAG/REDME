import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redme/models/note.dart';
import 'package:redme/providers/app.dart';

class ControlBar extends StatelessWidget {
  Function onWillPop;
  Function onPressedArchive;
  Function onPressedDelete;
  Note? note;

  ControlBar(
    {
      super.key, 
      required this.onWillPop, 
      required this.note, 
      required this.onPressedArchive,
      required this.onPressedDelete
    }
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (BuildContext context, appProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                tooltip: "Go back",
                onPressed: () => onWillPop(),
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
              Row(
                children: [
                  if (note != null)
                  IconButton(
                    tooltip: appProvider.isArchiveMode ? "Unarchive note" : "Archive note",
                    onPressed: () => onPressedArchive(),
                    padding: const EdgeInsets.all(0),
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(.8),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.archive_outlined,
                        color: Colors.white,
                      ),
                    )
                  ),
                  IconButton(
                    tooltip: "Delete note",
                    onPressed: () => onPressedDelete(context),
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
                  )
                ]
              )
          ]
        );
      }
    );
  }
}