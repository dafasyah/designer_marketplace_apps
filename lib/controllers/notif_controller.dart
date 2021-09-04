import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotifController extends GetxController {
  FlutterLocalNotificationsPlugin localNotification;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var androidInitialize = AndroidInitializationSettings('ic_launcher');
    var iOSInitialize = IOSInitializationSettings();
    var initialzationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    localNotification = FlutterLocalNotificationsPlugin();
    localNotification.initialize(initialzationSettings);
  }

  Future showNotification(String title, String body) async {
    var androidDetails = AndroidNotificationDetails("channelId",
        "Local Notification", "This is the description of the Notification",
        importance: Importance.high);

    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotification.show(0, title, body, generalNotificationDetails);
  }
}
