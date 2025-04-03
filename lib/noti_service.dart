import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotiService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized; 

  //Initialize the notification service
  Future<void> initNotification() async{
    if (_isInitialized) return; // Check if already initialized

    const initSettingAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: initSettingAndroid,
    );

    await notificationsPlugin.initialize(initSettings);
  
  }

  //Notification Detail setup
  NotificationDetails notificationDetails(){
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily_Notification',
        channelDescription: 'description',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    );
  }
  //show notification
  Future <void> showNotification({int id = 0, String? title, String? body}) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }

  //On Noti Tap
  
}