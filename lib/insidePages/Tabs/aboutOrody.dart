import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:orody/API/SharedApi.dart';
import 'package:orody/API/insideApi.dart';
import 'package:orody/sharedInternet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AboutOrody extends StatefulWidget {
  @override
  _AboutOrodyState createState() => _AboutOrodyState();
}

class _AboutOrodyState extends State<AboutOrody> {
  String about_us = '';
  String title = '';

  @override
  void initState() {
    checkNetwork().then((value) {
      if (value) {
        settingsData().then((response) {
          print(response);
          if (response["status"] == true) {
            if (!mounted) return null;
            setState(() {
              about_us = response["data"]["app_about_us"];
              title = response["data"]["title"];
            });
          } else {
            showErrorDialog(context, tr("global1"));
          }
        });
      } else {
        return showErrorDialog(context, tr("global2"));
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text(
          title,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: height,
        width: width,
        color: Colors.grey.shade200,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Image.asset(
                "assets/images/logo.png",
                height: width / 2,
                width: width / 2,
                fit: BoxFit.scaleDown,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  child: Text(
                    about_us,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
