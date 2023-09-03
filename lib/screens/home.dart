import 'package:flutter/material.dart';
import 'package:redme/screens/note.dart';
import 'package:redme/screens/task.dart';
import 'package:redme/widgets/bottombar.dart';
import 'package:redme/widgets/floatbutton.dart';
import 'package:redme/widgets/indicator.dart';
import 'package:redme/widgets/searchfield.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController tabController;

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
                  child: SearchField()
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
        floatingActionButton: const FloatButton()
      );
  }
}