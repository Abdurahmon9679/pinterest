import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:logger/logger.dart';
 Logger logger = Logger();
class LinkService{
  static Future <Uri>createLongLink(String partnerId)async{
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        link: Uri.parse("https://paybek.io?partnerId=$partnerId"),
        uriPrefix: "https://pinterestclone.page.link",
      androidParameters: const AndroidParameters(
        packageName: "com.example.pinterest"
      ),
      iosParameters: const IOSParameters(
        bundleId: "pinterest",
        minimumVersion: '13.0',
        appStoreId: '1605546614',
      ),
      navigationInfoParameters: const NavigationInfoParameters(forcedRedirectEnabled: true),
        
    );
    final Uri uri = await FirebaseDynamicLinks.instance.buildLink(parameters);
    logger.d(uri.toString());
    return uri;
  }
  static Future<Uri> createShortLink(String partnerId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://pdpdemo.page.link',
      link: Uri.parse("https://paybek.io?partnerId=$partnerId",),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.flutterdemo',
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.example.flutterdemo',
        minimumVersion: '13.0',
        appStoreId: '1605546414',
      ),
      navigationInfoParameters:
      const NavigationInfoParameters(forcedRedirectEnabled: true),
    );

    var shortLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    var shortUrl = shortLink.shortUrl;
    logger.d(shortUrl.toString());
    return shortUrl;
  }

  static Future<Uri?> retrieveDynamicLink() async {
    try {
      final PendingDynamicLinkData? data =
      await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = data?.link;
      logger.d(deepLink.toString());
      //#todo save deep link info to local and use when user logins in

      return deepLink;
    } catch (e) {
      logger.d(e.toString());
    }

    return null;
  }


  
}