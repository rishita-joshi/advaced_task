import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wings_advanced_tasl/api/firebase_api.dart';
import 'package:wings_advanced_tasl/screens/splash_screen.dart';
import 'package:wings_advanced_tasl/services/user_service.dart';
import 'api/notification_service.dart';
import 'firebase/firebase_config.dart';
import 'notification/awesome_notification.dart';

AuthServices authServices = AuthServices();
UserService userService = UserService();
NotificationServices notificationServices = NotificationServices();
var prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationManager.init();
  AwesomeNotifications().requestPermissionToSendNotifications();
  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();
  getFcmToken();
  notificationServices.requestNotificationPermission();
  notificationServices.forgroundMessage();
  notificationServices.firebaseInit();
  runApp(const MyApp());
}

void getFcmToken() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  FirebaseMessaging.instance.getToken().then((token) {
    print("---> FCM");
    print("FCM Firebase token   ======> $token");

    sharedPreferences.setString("user_token", token!);
    if (Platform.isAndroid) {
      NotificationManager.askAndroid13NotificationPermission();
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreeen());
  }
}
