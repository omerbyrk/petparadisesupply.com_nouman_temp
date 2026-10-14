import 'package:app_links/app_links.dart';
import '../globals.dart';

import '../extensions.dart';

class UniLinksHelper {
  static void listenDeepLink() async {
    final appLinks = AppLinks(); // AppLinks is singleton

    // Subscribe to all events (initial link and further)
    appLinks.uriLinkStream.listen((uri) {
      _initLink(uri);
    });
  }

  static void _initLink(Uri? uri, {bool initialUri = false}) {
    if (uri == null) return;

    var prefs = Globals.configuration.preferences;
    var splashDelay = initialUri ? prefs.splashDelay : 0;

    if (uri.scheme == "https" || uri.scheme == "http") {
      uri.toString().toLinkRedirector
        ?..duration = Duration(
          milliseconds: splashDelay + prefs.initialLinkDelay,
        )
        ..redirect();
    } else {
      var initialLink = uri.queryParameters["link"];

      if (initialLink == null) return;

      Uri? initialLinkURI = Uri.tryParse(initialLink);
      if (initialLinkURI != null) {
        initialLink.toString().toLinkRedirector
          ?..duration = Duration(
            milliseconds: splashDelay + prefs.initialLinkDelay,
          )
          ..redirect();
      }
    }
  }
}
