import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:quizzzy/libs/custom_widgets.dart';

class DynamicLinks {
  static Future<String> generateDynamicLink(
      String teacherID, String quizID) async {
    String url = "https://quizzzy.page.link";
    final dynamicLinkParams = DynamicLinkParameters(
        link: Uri.parse("$url/$teacherID/$quizID"),
        uriPrefix: url,
        androidParameters:
            const AndroidParameters(packageName: "com.example.quizzzy"),
        iosParameters: const IOSParameters(bundleId: "com.example.quizzzy"));

    //final ShortDynamicLink dynamicUrl = await dynamicLinkParams.buildShortLink();
    //desc = "${dynamicUrl.shortUrl.toString()}";
    // Share.share(desc, subject:quizID)

    return FirebaseDynamicLinks.instance
        .buildShortLink(dynamicLinkParams)
        .toString();
  }

  static Future initDynamicLink(BuildContext context) async {
    // initilize dynamic link for terminated state
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinksPlatform.instance.getInitialLink();

    if (initialLink != null) {
      try {
        handleDynamicLink(initialLink.link);
      } catch (e) {
        snackBar(context, "Link not found", (Colors.red.shade800));
      }
    } else {
      return null;
    }

    // fg/bg state
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) async {
      handleDynamicLink(dynamicLink.link);
    }).onError((e) => snackBar(context, e.toString(), (Colors.red.shade800)));
  }
}

handleDynamicLink(Uri url) {
  List<String> splitLink = url.path.split('/');
  // ignore: avoid_print
  print(splitLink);
}
