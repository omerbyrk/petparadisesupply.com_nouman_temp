import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_new_badger/flutter_new_badger.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_app/core/app_local_notification.dart';

import 'consts.dart';
import 'core/app_firebase_messaging.dart';
import 'core/app_helper.dart';
import 'core/app_uni_links.dart';
import 'core/connection_status_listener.dart';
import 'core/in_app_review_checker.dart';
import 'core/permission_helper.dart';
import 'core/remote_configuration/configuration.dart';
import 'globals.dart';
import 'screens/error_screens/no_connection.dart';
import 'screens/home.dart';
import 'screens/home_webview.dart';
import 'screens/landing.dart';
import 'screens/onboarding.dart';
import 'screens/splash.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// App notes -- Errors
// Rarely Update $FirebaseSDKVersion in the Pod file
// Flutter downloader is working on real device without problem (iOS)
// Firebase Crashlytics is depends on the assets firebase/GoogleService-Info.plist files
// for FFI errors: sudo arch -x86_64 gem install ffi and arch -x86_64 pod install
// firebase_core_platform_interface: 4.5.1 eklendi FirebaseAppPlatform.verifyExtends hatasından dolayı

late bool isConnectedToInternet;

void main() async {
  try {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    if (Platform.isAndroid) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
    }
    await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
    await EasyLocalization.ensureInitialized();
    UniLinksHelper.listenDeepLink();
    FlutterNewBadger.removeBadge();
    NotificationHelper.init();

    await runRemoteConfigDependencies();
    if (Globals.configuration.preferences.splashScreenPreserve) {
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    }
  } catch (error, stack) {
    debugPrint(error.toString());
    debugPrint(stack.toString());
    AppHelper.alertError(error, stack);
  } finally {
    runApp(
      Phoenix(
        child: EasyLocalization(
          supportedLocales: Globals.configuration.localization.supportedLocales,
          fallbackLocale: Globals.configuration.localization.defaultLocale,
          path: Globals.configuration.localization.path,
          assetLoader: Globals.configuration.localization,
          saveLocale: false,
          useOnlyLangCode: true,
          child: const Webview(),
        ),
      ),
    );
  }
}

Future<void> runNetworkDependencies() async {
  await Firebase.initializeApp();

  if (!Globals.configuration.useLocal) {
    Globals.configuration = await Configuration.getInstanceFromFirebase();
  }
  await FirebaseMessagingInitilizer.init();
}

Future<void> runRemoteConfigDependencies() async {
  Globals.configuration = await Configuration.getInstanceFromLocal();

  ConnectionStatusListener connectionStatus =
      ConnectionStatusListener.getInstance();
  connectionStatus.startListen();

  isConnectedToInternet = await connectionStatus.checkConnection();

  if (isConnectedToInternet) {
    await runNetworkDependencies();
  }

  // await MobileAds.instance.disableSDKCrashReporting();

  // if (Globals.configuration.mobileAds.active) {
  //   await MobileAds.instance.initialize();
  // }

  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(
    Globals.configuration.preferences.firebaseAnalytics,
  );

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  if (sharedPreferences.getInt(AppConsts.websiteVersionKey) == null) {
    await sharedPreferences.setInt(
      AppConsts.websiteVersionKey,
      Globals.configuration.websiteVersion,
    );
  }

  if (Globals.configuration.appRatingModel.active) {
    Future.delayed(
      Duration(seconds: Globals.configuration.appRatingModel.delayTime),
      () => InAppReviewChecker.check(),
    );
  }

  if (Globals.configuration.preferences.verticalOrientations) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  if (Platform.isAndroid) {
    if (Globals.configuration.preferences.cameraPermission &&
        await Permission.camera.isDenied) {
      await Permission.camera.request();
    }

    if (Globals.configuration.preferences.storagePermission &&
        await Permission.storage.isDenied) {
      await Permission.storage.request();
    }

    if (Globals.configuration.preferences.microphonePermission &&
        await Permission.microphone.isDenied) {
      await Permission.microphone.request();
    }

    if (Globals.configuration.preferences.locationPermission) {
      await PermissionHelper.lookLocationPermission();
    }
  }

  if (await AppHelper.isNotificationSupported) {
    FlutterNewBadger.removeBadge();
  }
}

class Webview extends StatelessWidget {
  const Webview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      color: Globals.configuration.backgroundColor,
      theme: ThemeData(
        primaryColor: Globals.configuration.primaryColor,
        useMaterial3: false,
        primarySwatch: MaterialColor(
          Globals.configuration.primaryColor.value,
          AppHelper.getSwatch(Globals.configuration.primaryColor),
        ),
        colorScheme: ColorScheme.light(
          background: Globals.configuration.backgroundColor,
          primary: Globals.configuration.primaryColor,
        ),
        canvasColor: Globals.configuration.backgroundColor,
      ),
      locale: context.deviceLocale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      initialRoute:
          isConnectedToInternet
              ? AppConsts.landingRoute
              : AppConsts.notOnlineRoute,
      routes: {
        AppConsts.splashRoute: (_) => const SplashScreen(),
        AppConsts.landingRoute: (_) => const LandingScreen(),
        AppConsts.onboardingRoute: (_) => const OnboardingScreen(),
        AppConsts.homeRoute: (_) => const HomeScreen(),
        AppConsts.homeWebviewRoute: (_) => const HomeWebviewScreen(),
        AppConsts.notOnlineRoute: (_) => const NoConnectionScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
