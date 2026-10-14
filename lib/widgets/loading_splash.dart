import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../screens/screen_base.dart';

import '../extensions.dart';
import '../widgets/fade_animation.dart';

//com.webview
class LoadingSplashWidget extends StatefulWidget {
  const LoadingSplashWidget({Key? key}) : super(key: key);

  @override
  LoadingSplashWidgetState createState() => LoadingSplashWidgetState();
}

class LoadingSplashWidgetState extends State<LoadingSplashWidget>
    with ScreenBase {
  final String imageURL = tr("splash_image");
  bool active = true;

  @override
  void initState() {
    FlutterNativeSplash.remove();
    configure(context: context, fullscreen: true);
    super.initState();
    listenWebViewLoading();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return active
        ? Container(
          decoration: BoxDecoration(
            color: tr("splash_background").toColor,
            image:
                tr("splash_background_image") == "splash_background_image"
                    ? null
                    : DecorationImage(
                      image: tr("splash_background_image").toImageProvider,
                      fit: BoxFit.cover,
                    ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeAnimationWidget(
                key: Key(imageURL),
                child: SizedBox(
                  child: Image(
                    image: imageURL.toImageProvider,
                    fit: BoxFit.cover,
                    width: double.parse(
                      tr("splash_dimension").split("x").first,
                    ),
                    height: double.parse(
                      tr("splash_dimension").split("x").last,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        : SizedBox();
  }

  void listenWebViewLoading() {
    var splashDur = int.tryParse(tr("splash_duration_ms")) ?? 500;
    Future.delayed(Duration(milliseconds: splashDur)).then((value) {
      setState(() {
        active = false;
        configure(context: context, fullscreen: false);
      });
    });
  }
}
