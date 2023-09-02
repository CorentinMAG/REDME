import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redme/providers/note.dart';
import 'package:redme/screens/note.dart';
import 'package:redme/screens/task.dart';
import 'package:redme/widgets/bottombar.dart';
import 'package:redme/widgets/createfloatbutton.dart';
import 'package:redme/widgets/indicator.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController textController = TextEditingController();
  late TabController tabController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (BuildContext ctx, noteProvider, child) {
      return Scaffold(
        body: SafeArea(
          child: Column(
              children: [
                TabBar(
                  controller: tabController,
                  labelColor: Colors.black,
                  tabs: const [
                    Tab(text: 'Notes', icon: Icon(Icons.article)),
                    Tab(text: 'Tasks', icon: Icon(Icons.fact_check_outlined)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: textController,
                    onChanged: (String text) {
                      if (text == "") {
                        setState(() {
                          isEditing = false;
                        });
                      } else {
                        setState(() {
                          isEditing = true;
                        });
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
                      suffixIcon: isEditing ? IconButton(
                        onPressed: () {
                          textController.clear();
                          noteProvider.filter("");
                          setState(() {
                            isEditing = false;
                          });
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
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Indicator(child: NoteScreen())
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Indicator(child: TaskScreen())
                      )
                    ]
                  )
                ),
              ]
            )
          ),
        bottomNavigationBar: const BottomBar(),
        floatingActionButton: noteProvider.isSelectMode || isEditing ? null : const CreateFloatBtn()
      );
    });
  }
}