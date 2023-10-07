import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redme/providers/app_provider.dart';
import 'package:redme/providers/note_provider.dart';

class BottomBar extends StatelessWidget {
  int index;
  BottomBar({super.key, required this.index});

  Widget _modalBuilder(BuildContext context, String word, Function onPressed) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    return Container(
      height: 160.0, // Adjust the height as needed
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: SizedBox(
              width: 300,
              child: noteProvider.selected > 1
                  ? Text(
                      "Are you sure to $word these ${noteProvider.selected} items ?",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      "Are you sure to $word this item ?",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 300,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            FilledButton(
                onPressed: () => onPressed(),
                style: FilledButton.styleFrom(backgroundColor: Colors.green),
                child: const SizedBox(
                    width: 60,
                    child: Text(
                      'Yes',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ))),
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
                    ))),
          ]),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    return Consumer<AppProvider>(
        builder: (BuildContext context, appProvider, child) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: appProvider.isSelectedMode ? 100 : 0.0,
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Column(children: [
                  IconButton(
                    icon: const Icon(Icons.delete_outlined),
                    onPressed: () {
                      showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        context: context,
                        builder: (ctx) =>
                            _modalBuilder(ctx, "delete", () async {
                          await noteProvider.deleteAll();
                          appProvider.toggleSelectedMode();
                          Navigator.pop(context);
                        }),
                      );
                    },
                  ),
                  const Text("Delete")
                ]),
              ),
              SingleChildScrollView(
                child: Column(children: [
                  IconButton(
                    icon: const Icon(Icons.archive_outlined),
                    onPressed: () {
                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                          ),
                          context: context,
                          builder: (ctx) => _modalBuilder(
                                  ctx,
                                  appProvider.isArchiveMode
                                      ? "unarchive"
                                      : "archive", () async {
                                if (appProvider.isArchiveMode) {
                                  await noteProvider.unarchiveAll();
                                } else {
                                  await noteProvider.archiveAll();
                                }
                                appProvider.toggleSelectedMode();
                                Navigator.pop(context);
                              }));
                    },
                  ),
                  appProvider.isArchiveMode
                      ? const Text("Unarchive")
                      : const Text("Archive")
                ]),
              )
            ],
          ),
        ),
      );
    });
  }
}
