import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../model/notification_model.dart';

class NotificationServices {
  static var navigatorKey = GlobalKey<NavigatorState>();

  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermission() async {
    try {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        if (kDebugMode) {
          print('user granted permission');
        }
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        if (kDebugMode) {
          print('user granted provisional permission');
        }
      } else {
        //appsetting.AppSettings.openNotificationSettings();
        if (kDebugMode) {
          print('user denied permission');
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> firebaseInit() async {
    FirebaseMessaging.onMessage.listen((message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        print('count:${android!.count}');
        print('data:${message.data.toString()}');
      }

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        try {
          await initLocalNotifications(message);
          await showNotification(message);
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });
  }

  //function to initialise flutter local notification plugin to show notifications
  //for android when app is active
  Future<void> initLocalNotifications(RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/launcher_icon');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSetting,
      onDidReceiveNotificationResponse: (payload) {
        // handle interaction when app is active for android
        handleMessage(message);
      },
    );
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      sound: channel.sound,
      icon: '@mipmap/launcher_icon',
      // icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    _flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      notificationDetails,
    );
  }

  //function to get device token
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    try {
      // when app is terminated
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        // handleMessage(initialMessage, ref);
      }

      //when app ins background
      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        // handleMessage(event, ref);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

void handleMessage(RemoteMessage message) {
  var notificationDataMap = message.data;
  var notification = NotificationModel.fromJson(notificationDataMap);
  print(notification);
//   NotificationServices.navigatorKey.currentState?.push(
//     MaterialPageRoute(builder: (context) => NotificationDetail(notification: notification)),
//   );
}
