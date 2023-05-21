import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:wachup_android_12/helper/helper_function.dart';
import 'package:wachup_android_12/notification_service.dart';
import 'package:wachup_android_12/pages/auth/splash_screen.dart';
import 'package:wachup_android_12/pages/home_page.dart';
import 'package:wachup_android_12/pages/screens/reels_page.dart';
import 'package:wachup_android_12/pages/test.dart';
import 'package:wachup_android_12/shared/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await Locales.init(['en', 'fil']);
  if (kIsWeb) {
    // run for web
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.apiId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    // run for android, ios
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSignedIn = false;

  //NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
    //notificationServices.initializeNotifications();
    //getUserLoggedInStatusOffline();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          isSignedIn = value;
        });
      }
    });
  }

  // offline
  getUserLoggedInStatusOffline() async {
    setState(() {
      isSignedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //timeDilation = 0.5;
    return LocaleBuilder(
        builder: (locale) => MaterialApp(
            localizationsDelegates: Locales.delegates,
            supportedLocales: Locales.supportedLocales,
            locale: locale,
            theme: ThemeData(
              primaryColor: Constants().customColor3,
              fontFamily: 'Comfortaa',
              scaffoldBackgroundColor: Constants().customBackColor,
              //visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            debugShowCheckedModeBanner: false,
            title: "Wachup",
            // home: MyHomePage(
            //   title: "Test",
            // )));
            home: isSignedIn ? ReelsPage() : const SplashScreen()));
    //home: const SplashScreen()));
  }
}
