import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authPages/splash.dart';

showInternetDialog(BuildContext context, String text) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: text,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontFamily: "cairo",
                        fontSize: 15)),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  tr("sharedInternet1"),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontFamily: "cairo",
                      fontSize: 15),
                ),
              ),
            ),
          ],
        );
      });
}

showLoadingIcon(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (conext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            ],
          ),
        );
      });
}

Future showErrorDialog(BuildContext context, String errorMsg) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: errorMsg,
                    style: TextStyle(
                        fontFamily: "cairo",
                        color: Theme.of(context).primaryColor,
                        fontSize: 18)),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  tr("sharedInternet1"),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontFamily: "cairo",
                      fontSize: 15),
                ),
              ),
            ),
          ],
        );
      });
}

Future logOut(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: tr("sharedInternet2"),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "cairo",
                        color: Theme.of(context).primaryColor,
                        fontSize: 15)),
              ],
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  tr("sharedInternet3"),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: "cairo",
                      fontSize: 15),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.clear();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Splash()),
                      (route) => false);
                },
                child: Text(
                  tr("sharedInternet4"),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontFamily: "cairo",
                      fontSize: 15),
                ),
              ),
            ),
          ],
        );
      });
}
