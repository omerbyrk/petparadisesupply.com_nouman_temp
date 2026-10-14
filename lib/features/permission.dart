import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/permission_helper.dart';
import 'feature.dart';

class PermissionFeature extends Feature {
  @override
  void trigger() async {
    print("PermissionFeature");
    if (parameters.containsKey("for")) {
      String permission = parameters["for"]!;
      switch (permission) {
        case "location":
          await PermissionHelper.lookLocationPermission();
          break;
        case "camera":
          await Permission.camera.request();
          break;
        case "storage":
          await Permission.storage.request();
          break;
        case "microphone":
          await Permission.microphone.request();
          break;
        case "notification":
          await FirebaseMessaging.instance.requestPermission(
            alert: true,
            badge: true,
            sound: true,
          );
          break;
        case "settings":
          await openAppSettings();
          break;
      }
    }
  }
}
