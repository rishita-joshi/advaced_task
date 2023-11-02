import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  printConsole("Handling a background message");
}

void printConsole(String s) {}

class NotificationManager {
  static bool iosNotify = false;

  static onNavigateFromNotification(data,
      {isForeground = true, fromRecent = false, fromKill = false}) {
    Map jsn = {};
    if (isForeground) {
      jsn = jsonDecode(data!);
    } else {
      jsn = data;
    }
    printConsole(jsn.toString());

    var seconds = 0;
    if (fromKill) seconds = 4;
    if (fromRecent) seconds = 1;
    if (isForeground) seconds = 0;

    Future.delayed(Duration(seconds: seconds), () {
      //notification task will be handle here.
    });
  }

  static showNotification(String? title, String? body, String param) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'Notification Test', ' Notifications desc',
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(""),
        showProgress: true,
        priority: Priority.high,
        ticker: 'test ticker');

    var iOSChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: param);
  }

  static onNotificationArrivedProcess(RemoteMessage message) {
    // RemoteNotification? notification = message.notification;
    // AndroidNotification? android = message.notification?.android;
    print("Yeah, Notification Arrived in onMessage");
    // PushNotificationEntity p =
    //     PushNotificationEntity.fromJson(jsonDecode(message.data["other"]));
    // print('p.runtimeType== p p pp onMessage=> $p');

    // print('p.runtimeType==onMessage=> ${message.toString()}');
    print('p.runtimeType=map=onMessage=> ${message.toMap()}');
    // print('p.runtimeType=[other=onMessage=> ${message.data["other"]}');
    print('p.runtimeType=body=onMessage=> ${message.notification!.body!}');
    print('p.runtimeType=data=onMessage=> ${message.data.toString()}');

    // if (Platform.isAndroid || Platform.isIOS) {

    if (Platform.isAndroid) {
      showNotification(message.notification!.title, message.notification!.body,
          jsonEncode(message.data));
    } else if (Platform.isIOS) {
      if (!iosNotify) {
        showNotification(message.notification!.title,
            message.notification!.body, jsonEncode(message.data));
      } else {
        iosNotify = false;
      }
    }

  }

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static onDidReceiveBackgroundNotificationResponse(
      NotificationResponse details) {
    print("onDidReceiveBackgroundNotificationResponse");
  }

  static init() {
    Future onSelectNotification(String? data) async {
      printConsole("onSelectNotification == ? $data");
      if (data != null) {
        onNavigateFromNotification(data);
      }
    }

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_android_notification');

//VIEW IN PERMISSION IN IOS SETTING WHILE requestAlertPermission &&requestBadgePermission IS TRUE
    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // your call back to the UI
      },
    );
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        print("onDidReceiveNotificationResponse");
        onSelectNotification(details.payload);
      },
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );

    //Foreground message handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      onNotificationArrivedProcess(message);
    });

    //App goes to background but not killed
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      printConsole(
          "FirebaseMessaging.onMessageOpenedApp=======> ${message.data}");

      printConsole(
          "onMessageOpenedApp notification.title:- ${notification.title!}");
      printConsole(
          "onMessageOpenedApp message.notification.body:- ${message.data}");
      printConsole(
          "onMessageOpenedApp message.notification.body:- ${message.data['name']}");
      // PushNotificationEntity p =
      //     PushNotificationEntity.fromJson(jsonDecode(message.data["other"]));
      onNavigateFromNotification(message.data,
          isForeground: false, fromRecent: true);
      iosNotify = true;
    });

    //App goes to background but not killed System tray notification also come, so nothing in onBackgroundMessage
    //this function should out side the class or static.. due to isolation.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    //called first time app opened and in kill state too.
    //our notification data keep here.
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      //  Firebase.initializeApp();
      if (message != null) {
        printConsole(
            "FirebaseMessaging.getInitialMessage=======> ${message.data}");

        iosNotify = true;
        onNavigateFromNotification(message.data,
            isForeground: false, fromKill: true);
      } else {
        printConsole(
            "FirebaseMessaging.getInitialMessage=======> NO NOTIFICATIONS");
      }
    });
  }

  static askAndroid13NotificationPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission()
        .then(
      (value) {
        if (value != null) {
          if (value) {
            printConsole("POST_NOTIFICATIONS Permission Granted");
          } else {
            printConsole("POST_NOTIFICATIONS Permission Not Granted");
          }
        }
      },
    );
  }

  static Future<void> sendFCMPushNotification(
      String token, String title, String body) async {
    final String serverKey =
        'AAAA1Si-xOk:APA91bFbrH-oPnqNzwr05p0uE8hyh0PNMhK23d1RPRZcYAmywl29RD9zC5ufumaG8dhNdj-L_sl50MI81wEWa7pSjzfaaYQxxWU0iUtwqeAvhcyU5TX9XGR2ta0-OMZyhd7ZBXpGuQq7'; // Replace with your FCM server key
    final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final Map<String, dynamic> notification = {
      'body': body,
      'title': title,
    };

    final Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    };

    final Map<String, dynamic> requestBody = {
      'notification': notification,
      'data': data,
      'to': token, // FCM token of the recipient device
    };

    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('FCM push notification sent successfully');
    } else {
      print('Failed to send FCM push notification: ${response.reasonPhrase}');
    }
  }
}
