import 'dart:async';
import 'dart:math';
import 'package:caco_cooking/common/const.dart';
import 'package:caco_cooking/common/lifecyle.dart';
import 'package:caco_cooking/firebase/apirequest.dart';
import 'package:caco_cooking/firebase/firebase_options.dart';
import 'package:caco_cooking/models/notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/foundation.dart' show kIsWeb;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationData notificationData = NotificationData.fromJson(message.data);
  String? a = await findStringPref(TOKEN, null);
  if (notificationData.title.isNotEmpty && notificationData.token != a) {
    displayNotification(notificationData);
  }
}

intiMessage(int userType) async {
  if (kIsWeb) {
    return;
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  await firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  await firebaseMessaging.subscribeToTopic(TOPIC);
  await firebaseMessaging.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  await createChannel();
  if (userType == 1) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      NotificationData notificationData = NotificationData.fromJson(message.data);
      final a = await findStringPref(TOKEN, null);
      if (notificationData.title.isNotEmpty && notificationData.token != a) {
        displayNotification(notificationData);
      }
    });
  }
}


Future<void> sendPushMessage({required PushNotification pushNotification}) async {
  ApiClient(Dio()).postNotification(pushNotification)
      .then((value) => null)
      .catchError((onError) => logProv(e));
}

displayNotification(NotificationData notificationData) async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    CHANNEL_ID, // id
    CHANNEL_MESSAGE, // title
    description: CHANNEL_DES, // description
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  await notificationsPlugin.initialize(const InitializationSettings(android: AndroidInitializationSettings('mipmap/ic_launcher')));

  await notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  notificationsPlugin.show(
      notificationData.hashCode,
      notificationData.title,
      notificationData.body,
      payload: 'Notification',
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.high,
          ongoing: false,
          styleInformation: const BigTextStyleInformation(''),
          visibility: NotificationVisibility.public,
        ),
      ));
}

createChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    CHANNEL_ID, // id
    CHANNEL_MESSAGE, // title
    description: CHANNEL_DES, // description
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}
