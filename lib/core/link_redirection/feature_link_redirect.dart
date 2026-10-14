import '../../features/index.dart';
import '../../features/permission.dart';
import '../../features/vibration.dart';
import 'link_redirector.dart';

// window.flutter_inappwebview.callHandler('link_redirector', 'feature://permission?for=location')
class FeatureLinkRedirect extends LinkRedirector {
  Map<String, Feature> linksToFeature = {
    "qr_code": QRCodeFeature(),
    "in_app_review": InAppReviewFeature(),
    "app_sharing": AppSharingFeature(),
    "subscribe_to_topic": SubscribeToTopic(),
    "unsubscribe_from_topic": UnsubscribeFromTopic(),
    "vibration": VibrationFeature(),
    "permission": PermissionFeature(),
  };

  //

  FeatureLinkRedirect(super.link);

  @override
  void redirect() async {
    await super.readyToRedirect;
    await Future.delayed(super.duration);
    var uri = Uri.parse(link);
    var feature = linksToFeature[uri.host];
    if (feature == null) return;

    feature.parameters = uri.queryParameters;
    feature.trigger();
  }
}
