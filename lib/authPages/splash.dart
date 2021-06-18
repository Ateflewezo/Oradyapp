import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:orody/insidePages/tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'allAuthOperations.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String jwt;
  double opacity = 0;
  Future getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      opacity = 1;
      jwt = prefs.get("jwt");
    });
    if (prefs.getString("lang") != null) {
      context.locale = Locale(prefs.getString("lang") == "1" ? "en" : "ar");
    } else {
      prefs.setString("lang", "2");
      context.locale = Locale("ar");
    }
  }

  @override
  void initState() {
    getLang().then((sda) {
      Timer(Duration(seconds: 1), () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) =>
                jwt == null ? AllAuthOperations() : Tabs(),
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 1000),
          ),
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Container(
        height: height,
        color: Colors.white,
        width: width,
        child: AnimatedOpacity(
          duration: Duration(seconds: 1),
          opacity: opacity,
          curve: Curves.easeInOut,
          child: Center(
            child: Image.asset(
              "assets/images/logo.png",
              height: width / 2,
              width: width / 2,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
      ),
    );
  }
}
