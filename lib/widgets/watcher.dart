import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redme/providers/note.dart';

class WatcherLoop extends StatefulWidget {
  Widget child;
  NoteProvider provider;
  WatcherLoop({super.key, required this.provider, required this.child});

  @override
  State<WatcherLoop> createState() => _WatcherLoopState();
}

class _WatcherLoopState extends State<WatcherLoop> {

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startWatcherLoop();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // every 5 seconds we loop through the list of notes and 
  // if the reminder time is over, we set reminder time to null
  void _startWatcherLoop() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      widget.provider.watch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}