import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../globals.dart';

import '../extensions.dart';
import 'app_firebase_messaging.dart';
import 'app_helper.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void init() async {
    var initializationSettingsAndroid = const AndroidInitializationSettings(
      "notification_icon",
    );

    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    handleNotification(NotificationResponse response) async {
      var argPayload = response.payload;
      if (argPayload != null && argPayload.isNotEmpty) {
        var payload = json.decode(argPayload) as Map<String, dynamic>;
        var notification = FirebaseNotificationModel.fromMap(payload);
        if (notification.isNotification) {
          (notification.link ?? "").toLinkRedirector
            ?..duration = Duration(
              milliseconds: Globals.configuration.preferences.initialLinkDelay,
            )
            ..redirect();
        } else if (notification.isRemoteConfigChanges) {
          AppHelper.remoteChangesNotification(notification);
        }
      }
    }

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: handleNotification,
    );
  }

  static void showNotification(FirebaseNotificationModel notificationObject) {
    if (notificationObject.hasPicture) {
      NotificationHelper.showBigPictureNotification(
        DateTime.now().microsecond,
        notificationObject.title,
        notificationObject.body,
        notificationObject.image!,
        json.encode(notificationObject.toJSON()),
      );
    } else {
      NotificationHelper.showNormal(
        DateTime.now().microsecond,
        notificationObject.title,
        notificationObject.body,
        json.encode(notificationObject.toJSON()),
      );
    }
  }

  static Future<void> showNormal(
    int id,
    String title,
    String body,
    String? payload,
  ) async {
    //var imageLocalPath = await _downloadAndSaveFile(imageURL, 'largeIcon');
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      DateTime.now().microsecond.toString(),
      DateTime.now().microsecond.toString(),
      channelDescription: "channel description",
      importance: Importance.max,
      playSound: true,
      visibility: NotificationVisibility.public,
      priority: Priority.high,
      ticker: "test ticker",
    );

    var iOSChannelSpecifics = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    var platformSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformSpecifics,
      payload: payload,
    );
  }

  static Future<void> showBigPictureNotification(
    int id,
    String title,
    String body,
    String pictureURL,
    String? payload,
  ) async {
    final String bigPicturePath = await _downloadAndSaveFile(
      pictureURL,
      'bigPicture.jpg',
    );

    // Android
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          //largeIcon: FilePathAndroidBitmap(largeIconPath),
        );
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          DateTime.now().microsecond.toString(),
          DateTime.now().microsecond.toString(),
          channelDescription: "channel description",
          importance: Importance.max,
          playSound: true,
          visibility: NotificationVisibility.public,
          priority: Priority.high,
          ticker: "test ticker",
          styleInformation: bigPictureStyleInformation,
        );

    // IOS
    final DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          attachments: <DarwinNotificationAttachment>[
            DarwinNotificationAttachment(bigPicturePath),
          ],
        );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  static Future<String> _downloadAndSaveFile(
    String url,
    String fileName,
  ) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
