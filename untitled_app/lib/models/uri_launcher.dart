import 'dart:io';

import 'package:url_launcher/url_launcher.dart';
import '../utilities/constants.dart' as c;

class UriLauncher {
  static void launchCorrectStore() async {
    if (Platform.isIOS) {
      await launchAppStore();
    } else {
      await launchPlayStore();
    }
  }

  static Future<void> launchAppStore() async {
    final Uri appStoreUrl = Uri.parse(c.appStoreURL);
    await launchUrl(appStoreUrl);
  }

  static Future<void> launchPlayStore() async {
    final Uri playStoreUrl = Uri.parse(c.playStoreURL);
    await launchUrl(playStoreUrl);
  }
}
