import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redme/providers/note_provider.dart';

class WatcherLoop extends StatefulWidget {
  Widget child;
  NoteProvider provider;
  Duration duration;
  WatcherLoop({super.key, required this.provider, required this.duration, required this.child});

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
    _timer = Timer.periodic(widget.duration, (Timer timer) {
      widget.provider.watch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}