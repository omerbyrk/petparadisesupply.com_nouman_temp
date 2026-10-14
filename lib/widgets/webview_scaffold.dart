import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'loading_splash.dart';

import '../globals.dart';
import 'app_bar.dart';
import 'app_webview.dart';
import 'double_back_to_close_app.dart';

class WebviewScafoldWidget extends StatelessWidget {
  final AppWebViewWidget webView;
  final Widget? bottomNavBar;
  final Widget floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const WebviewScafoldWidget({
    Key? key,
    required this.webView,
    required this.floatingActionButton,
    this.bottomNavBar,
    this.floatingActionButtonLocation,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Globals.configuration.backgroundColor,
          child: SafeArea(
            top: false,
            left: false,
            right: false,
            bottom: "safearea.bottom".tr() == "true",
            child: AnnotatedRegion<SystemUiOverlayStyle>(
              value: Globals.configuration.statusBarStyle,
              child: Scaffold(
                backgroundColor: Globals.configuration.backgroundColor,
                floatingActionButton: Padding(
                  padding: EdgeInsets.only(
                    bottom: Globals
                        .configuration
                        .preferences
                        .floatButtonBottomPadding,
                  ),
                  child: floatingActionButton,
                ),
                floatingActionButtonLocation: floatingActionButtonLocation,
                resizeToAvoidBottomInset:
                    Globals.configuration.preferences.resizeToAvoidBottomInset,
                bottomNavigationBar: bottomNavBar,
                appBar: const AppBarWidget(),
                body: DoubleBackToCloseAppWidget(
                  snackBar: SnackBar(content: Text(tr("tap_to_exit"))),
                  child: Column(children: [Expanded(child: webView)]),
                ),
              ),
            ),
          ),
        ),
        if (tr("splash_enabled") == "true")
          Positioned.fill(child: LoadingSplashWidget()),
      ],
    );
  }
}
