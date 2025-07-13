import 'dart:io';
import 'package:danapaniexpress/core/consts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NavigationRepository {

   Future<void> goToDeveloperPage() async {
    const devID = 'O5Studio';
    const market = 'market://dev?id=$devID';
    const url = 'https://play.google.com/store/apps/developer?id=$devID';
    if (await canLaunchUrlString(market)) {
      await launchUrlString(market);
    } else if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

   Future<void> launchSocialMediaAppURLIfInstalledEvent(
      {required String url}) async {
    try {
      bool launched = await launchUrlString(url, mode: LaunchMode
          .externalNonBrowserApplication); // Launch the app if installed!
      if (!launched) {
        launchUrlString(url, mode: LaunchMode
            .externalNonBrowserApplication); // Launch web view if app is not installed!
      }
    } catch (e) {
      launchUrlString(url); // Launch web view if app is not installed!
    }
  }

   Future<void> launchUniversalLinkURI({required Uri uri}) async {
    final bool nativeAppLaunchSucceeded = await launchUrl(uri,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(uri,
          mode: LaunchMode.inAppWebView);
    }
  }

   Future<void> launchWhatsapp({required String phone}) async {
    final Uri whatsApp = Uri.parse('whatsapp://send?phone=$phone');
    launchUrl(whatsApp);
  }

   Future<void> launchFacebookPage({required String pageUserName}) async {
     final String facebookWebUrl = "https://www.facebook.com/$pageUserName";
     final Uri webUri = Uri.parse(facebookWebUrl);

     // Try deep link (Facebook app)
     final Uri fbAppUri = Uri.parse("fb://facewebmodal/f?href=$facebookWebUrl");

     try {
       final canLaunchFb = await canLaunchUrl(fbAppUri);
       if (canLaunchFb) {
         await launchUrl(fbAppUri, mode: LaunchMode.externalNonBrowserApplication);
       } else if (await canLaunchUrl(webUri)) {
         await launchUrl(webUri, mode: LaunchMode.externalApplication);
       } else {
         print("❌ Could not open Facebook page in any mode.");
       }
     } catch (e) {
       print("❌ Facebook Launch Error: $e");
     }
   }


   Future<void> launchPlayStoreApp({required String appId}) async {
    final Uri playStoreUri = Uri.parse("https://play.google.com/store/apps/details?id=$appId");
    if (await canLaunchUrl(playStoreUri)) {
      await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch $playStoreUri";
    }
  }

   Future<void> launchEmail({required String email}) async {
    var body = '';
    var subject = EmailSubject.emailSubject;

    if (Platform.isAndroid) {
      // Open Gmail directly on Android
      final Uri gmailUri = Uri(
        scheme: 'mailto',
        path: email,
        query: Uri.encodeFull('subject=$subject&body=$body'),
      );

      // Package name for Gmail
      try {
        await launchUrl(
          gmailUri,
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        print("Error launching Gmail: $e");
      }
    } else if (Platform.isIOS) {
      // Open the default mail client on iOS
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
        query: Uri.encodeFull('subject=$subject&body=$body'),
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        print("Could not launch mail client");
      }
    }
  }

   Future<void> launchPhoneCall({required String phoneNumber}) async {
     final Uri phoneUri = Uri(
       scheme: 'tel',
       path: phoneNumber,
     );

     try {
       if (await canLaunchUrl(phoneUri)) {
         await launchUrl(
           phoneUri,
           mode: LaunchMode.externalApplication,
         );
       } else {
         print("Could not launch phone dialer");
       }
     } catch (e) {
       print("Error launching phone call: $e");
     }
   }
}