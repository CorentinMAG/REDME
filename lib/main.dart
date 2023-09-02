import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redme/providers/note.dart';
import 'package:redme/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (ctx) => NoteProvider(),
      child: const MyApp()),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REDME',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      themeMode: ThemeMode.system,
      home: HomeScreen()
    );
  }
}