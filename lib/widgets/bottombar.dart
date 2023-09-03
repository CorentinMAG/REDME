import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redme/providers/app.dart';
import 'package:redme/providers/note.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  Widget _modalBuilder(BuildContext context, String word, Function onPressed) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    return Container(
      height: 150.0, // Adjust the height as needed
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: 200,
              child: Text("Are you sure to ${word} these ${noteProvider.selected} items ?", textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilledButton(
                  onPressed: () => onPressed(), 
                  style: FilledButton.styleFrom(backgroundColor: Colors.green), 
                  child: const SizedBox(
                    width: 60,
                    child: Text(
                      'Yes', style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    )
                  )
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    appProvider.toggleSelectedMode();
                  }, 
                  style: FilledButton.styleFrom(backgroundColor: Colors.red), 
                  child: const SizedBox(
                    width: 60,
                    child: Text(
                      'No', 
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    )
                  )
                ),
              ]
            ),
          )
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: appProvider.isSelectedMode ? 80 : 0.0,
        child: Visibility(
          visible: appProvider.isSelectedMode,
          child: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete_outlined),
                        onPressed: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)
                              ),
                            ),
                            context: context, 
                            builder: (ctx) => _modalBuilder(
                              ctx, 
                              "delete",
                              () async {
                                await noteProvider.deleteAll();
                                appProvider.toggleSelectedMode();
                                Navigator.pop(context);
                              }
                            ),
                          );
                        },
                      ),
                      const Text("Delete")
                    ]
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.label_important_outline),
                        onPressed: () {},
                      ),
                      const Text("Important")
                    ]
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.archive_outlined),
                        onPressed: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)
                              ),
                            ),
                            context: context, 
                            builder: (ctx) => _modalBuilder(
                              ctx,
                              appProvider.isArchiveMode ? "unarchive" : "archive",
                              () async {
                                await noteProvider.archiveAll();
                                appProvider.toggleSelectedMode();
                                Navigator.pop(context);
                              }
                            )
                          );
                        },
                      ),
                     appProvider.isArchiveMode ? const Text("Unarchive") : const Text("Archive")
                    ]
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }
}