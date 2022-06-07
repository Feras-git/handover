import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

//! Tested on android only

class PushNotificationsManager {
  static String _authorizationKey =
      "AAAAFTSG5WE:APA91bHia2WQEUVTwq_eyCO79pszIajIEX9Jmhyu6FnZmp45xqZNIUgqG-AvqLFPQhj5FnnFqlrRZ5JOZOcTctlyBzU3DtnVTqTPb_2hMzBFLAfqc76FZOMruCOLu5qrZ55NJZoslkyc";
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'my_channel', // id
    'My Channel', // name
    description: 'Important notifications from my server.', // description
    importance: Importance.high,
  );

  static bool _initialized = false;

  /// INITIALIZE THE SERVICE
  /// It will init fcm and flutter_local_notification for foreground messages.
  static Future init(
      // {
      // required clickMessageActionAppIsClosed(RemoteMessage message),
      // required clickMessageActionAppInBackground(RemoteMessage message),
      // required clickMessageActionAppInForeground(String? payload),
      // }
      ) async {
    if (!_initialized) {
      // Initialize flutter local notifications settings.
      _flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: IOSInitializationSettings(),
        ),
        onSelectNotification: (payload) {
          //clickMessageActionAppInForeground(payload);
        },
      );

      // ##### FCM SETTINGS ##### //

      //------------------- IOS PEMISSIONS --------------------------//
      // For iOS request permission first.
      FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      /// Update the iOS foreground notification presentation options to allow heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      //------------------------------------------------------------//

      //! onLaunch: app is closed
      // Workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        if (message != null) {
          print('getInitialMessage data: ${message.data}');
          //clickMessageActionAppIsClosed(message);
        }
      });

      //! onMessage: app on foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("onMessage data: ${message.notification?.body}");

        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          _flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _channel.id,
                _channel.name,
                channelDescription: _channel.description,
                icon: '@mipmap/ic_launcher',
              ),
            ),
            //payload:
          );
        }
      });

      //! onResume: app in background
      // onLaunch and onResume (app in background or closed).
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('onMessageOpenedApp data: ${message.data}');
        //clickMessageActionAppInBackground(message);
      });

      _initialized = true;
    }
  }

  /// Clear all push notifications from system's notifications bar.
  static Future clearAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll().onError((error, _) {
      print('Error: $error');
    });
  }

  /// Send notification returns true if sent successfully, false if not.
  static Future<bool> sendNotification({
    required List recieverTokens,
    required String title,
    required String body,
    //String type = "message",
    //String userById,
  }) async {
    if (recieverTokens.isEmpty) {
      print('Passed empty tokens list!');
      return false;
    }
    var postUrl = 'https://fcm.googleapis.com/fcm/send';
    var data = {
      "registration_ids": recieverTokens,
      "priority": "high",
      "content_available": true,
      "collapse_key": "type_a",
      "notification": {
        "title": title,
        "body": body,
        "tag": 'platonic',
        "sound": "default",
      },
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        // "type": type,
        // "id": "1",
        // "status": "done",
        // "userById": userById
      }
    };
    var headers = {
      'content-type': 'application/json',
      'Authorization': 'key=$_authorizationKey',
    };
    //Send the notification:
    var response = await http.post(
      Uri.parse(postUrl),
      body: jsonEncode(data),
      encoding: Encoding.getByName('utf-8'),
      headers: headers,
    );
    //Check success:
    if (response.statusCode == 200) {
      print('test ok push FCM');
      return true;
    } else {
      print(' FCM error');
      return false;
    }
  }
}
