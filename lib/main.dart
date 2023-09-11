import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redme/providers/app.dart';
import 'package:redme/providers/note.dart';
import 'package:redme/screens/home.dart';
import 'package:redme/services/notification.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  await NotificationService.requestPermission();
  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppProvider()
        ),
        ChangeNotifierProxyProvider<AppProvider, NoteProvider>(
          create: (BuildContext context) => NoteProvider(Provider.of<AppProvider>(context, listen: false)),
          update: (BuildContext context, appProvider, noteProvider) => noteProvider!
            ..updateState(appProvider)
        )
      ],
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
      home: const HomeScreen()
    );
  }
}