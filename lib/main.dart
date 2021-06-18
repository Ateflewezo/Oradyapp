import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:easy_localization/easy_localization.dart';

import 'authPages/splash.dart';

void main() {
  runApp(EasyLocalization(
    child: MyApp(),
    useOnlyLangCode: true,
    startLocale: Locale("ar"),
    supportedLocales: [
      Locale('en'),
      Locale('ar'),
    ],
    path: 'lang',
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    // checkNetwork().then((value) {
    // if (value) {
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });
    // }
    // });
    // _firebaseMessaging.requestNotificationPermissions(); for IOS Only
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print(message);
      },
      onLaunch: (Map<String, dynamic> message) {
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(12, 101, 175, 1),
        accentColor: Color.fromRGBO(12, 101, 175, 0.1),
        fontFamily: "cairo",
      ),
      debugShowCheckedModeBanner: false,
      title: 'Oroody',
      home: Splash(),
    );
  }
}
