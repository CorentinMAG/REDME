import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redme/providers/app_provider.dart';
import 'package:redme/providers/note_provider.dart';
import 'package:redme/providers/task_provider.dart';
import 'package:redme/screens/home.dart';
import 'package:redme/services/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProxyProvider<AppProvider, NoteProvider>(
            create: (context) => NoteProvider(
                  Provider.of<AppProvider>(context, listen: false),
                ),
            update: (context, appProvider, noteProvider) =>
                noteProvider!..updateState(appProvider)),
        ChangeNotifierProxyProvider<AppProvider, TaskProvider>(
            create: (context) =>
                TaskProvider(Provider.of<AppProvider>(context, listen: false)),
            update: (context, appProvider, taskProvider) =>
                taskProvider!..updateState(appProvider))
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REDME',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
