import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }
}

// class NotificationServices {
//   final FlutterLocalNotificationsPlugin _localNotification =
//       FlutterLocalNotificationsPlugin();

//   final AndroidInitializationSettings _initializationSettings =
//       const AndroidInitializationSettings('assets/WachupLogoResized.png');

//   void initializeNotifications() async {
//     InitializationSettings initialSettings =
//         InitializationSettings(android: _initializationSettings);

//     await _localNotification.initialize(initialSettings);
//   }

//   void sendNotifications(String title, String body) async {
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails('channelId', 'Wachup Notification',
//             importance: Importance.max, priority: Priority.high);

//     NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);

//     await _localNotification.show(0, title, body, notificationDetails);
//   }

//   void scheduleNotifications(String title, String body) async {
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails('channelId', 'Wachup Notification',
//             importance: Importance.max, priority: Priority.high);

//     NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);

//     await _localNotification.periodicallyShow(
//         0, title, body, RepeatInterval.everyMinute, notificationDetails);
//   }
// }
