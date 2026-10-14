// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:webview_app/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen_base.dart';

import '../consts.dart';
import '../globals.dart';
import '../core/app_helper.dart';

bool lookedForOnboardingScreen = false;

// ignore: slash_for_doc_comments
/**
 * The app is not started yet. That's why we didn't implement [ScreenBase] class in here.
 * If we implement the [ScreenBase] here, and set the Global BuildContext. AppHelper.loadInUrl is not working when click at the notification on app terminated mode 
 */
class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    findNextRoute();
    super.initState();
  }

  void findNextRoute() async {
    await Future.delayed(Duration.zero);
    if (!lookedForOnboardingScreen && await lookForOnboardingScreen()) {
      lookedForOnboardingScreen = true;
      return;
    }

    await goToHomeScreen();
  }

  Future<bool> lookForOnboardingScreen() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // checks for onboarding screen
    bool onboardingShowedBefore =
        sharedPreferences.getBool(AppConsts.onboardingKey) == true;
    var showOnboardingScreen =
        Globals.configuration.onboardingScreenModel.active &&
        (!onboardingShowedBefore ||
            Globals.configuration.onboardingScreenModel.showOnEveryLaunch);

    if (showOnboardingScreen) {
      debugPrint("will go to Onboarding Screen");
      Navigator.of(context).pushReplacementNamed(AppConsts.onboardingRoute);
      return true;
    }

    return false;
  }

  Future<bool> goToHomeScreen() async {
    // checks for home screen
    debugPrint("will go to Home Screen");
    Navigator.of(context).pushReplacementNamed(
      Globals.configuration.homeScreen.active
          ? AppConsts.homeRoute
          : AppConsts.homeWebviewRoute,
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    AppHelper.fullscreen();
    return Scaffold(backgroundColor: tr("splash_background").toColor);
  }
}
