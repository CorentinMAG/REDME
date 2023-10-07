import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redme/providers/note_provider.dart';
import 'package:redme/screens/note.dart';
import 'package:redme/screens/task.dart';
import 'package:redme/widgets/bottom_bar.dart';
import 'package:redme/widgets/float_button.dart';
import 'package:redme/widgets/indicator.dart';
import 'package:redme/widgets/search_field.dart';
import 'package:redme/widgets/watcher.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    setState(() {
      tabIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    return WatcherLoop(
      provider: noteProvider,
      duration: const Duration(seconds: 5),
      child: Scaffold(
        body: SafeArea(
          child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  tabs: const [
                    Tab(text: 'Notes', icon: Icon(Icons.article)),
                    Tab(text: 'Tasks', icon: Icon(Icons.fact_check_outlined)),
                    Tab(text: "Settings", icon: Icon(Icons.settings))
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: SearchField()
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Indicator(child: NoteScreen())
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Indicator(child: TaskScreen())
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Indicator(child: Text("Settings"))
                      ),
                    ]
                  )
                ),
              ]
            )
          ),
        bottomNavigationBar: BottomBar(index: tabIndex),
        floatingActionButton: FloatButton(index: tabIndex)
      )
    );
  }
}