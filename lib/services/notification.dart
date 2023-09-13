import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  NotificationService();

  static final _flnp = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: null,
      linux: null
      );
    
    await _flnp.initialize(
      initializationSettings, 
      onDidReceiveNotificationResponse: onReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onReceiveBackgroundNotificationResponse
      );
  }

  static Future<void> onReceiveNotificationResponse(NotificationResponse response) async {
    print("on receive notification: $response");
  }

  static Future<void> onReceiveBackgroundNotificationResponse(NotificationResponse response) async {
    print("on receive background notification: $response");
  }

  static Future<bool> _requestPermission() async {
    return await _flnp.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestPermission() as bool;
  }

  static Future<void> showLocalNotification(String title, String body) async {
    final bool isAllowed = await _requestPermission();
    if (!isAllowed) return;
    const androidNotificationDetail = AndroidNotificationDetails(
    '0',
    'general',
    importance: Importance.max,
    priority: Priority.high
    );
    const iosNotificatonDetail = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      iOS: iosNotificatonDetail,
      android: androidNotificationDetail,
    );
    await _flnp.show(0, title, body, notificationDetails);
  }

  static Future<void> scheduleLocalNotification(int id, String title, String body, DateTime datetime) async {
    final isAllowed = await _requestPermission();
    if (!isAllowed) return; 
    const androidNotificationDetail = AndroidNotificationDetails(
      '0',
      'general',
      sound: RawResourceAndroidNotificationSound('sound'),
      playSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidNotificationDetail
    );

    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    
    await _flnp.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(datetime, tz.getLocation(currentTimeZone)),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }

  static Future<void> updateScheduleNotification(int id, String title, String body, DateTime datetime) async {
    await NotificationService.cancelScheduleNotification(id);
    await scheduleLocalNotification(id, title, body, datetime);
  }

  static Future<void> cancelScheduleNotification(int id) async {
    await _flnp.cancel(id);
  }
}