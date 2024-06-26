import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {

  static final LocalNotificationService _localNotificationService = LocalNotificationService._internal();
  factory LocalNotificationService(){
    return _localNotificationService;
  }
  LocalNotificationService._internal();



  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Future<void> init() async {
    ///configuraciones para android
    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('icono');
    ///Configuracion por plataforma
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,onDidReceiveNotificationResponse: selectNotification);
  }

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,

      )
    );
  }

  static Future showLocalNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
  }) async => flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      await _notificationDetails(),
      payload: payload
  );



  Future selectNotification(NotificationResponse payload) async {
    //Handle notification tapped logic here
  }

}