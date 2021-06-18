import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:orody/insidePages/settings/favs.dart';
import 'package:orody/insidePages/settings/languages.dart';
import 'package:orody/insidePages/stores/storeFlyer.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'offers.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  buildTaps(ThemeData theme, double width, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20, right: 20, left: 20),
      child: Container(
        height: 50,
        width: width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Icon(Icons.arrow_forward_ios,
                  size: 22, color: theme.primaryColor),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          tr("settings1"),
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
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              // ChangeLanguage
              InkWell(
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: ChangeLanguage(),
                    withNavBar: false,
                    customPageRoute: PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => ChangeLanguage(),
                      transitionsBuilder: (c, anim, a2, child) =>
                          FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 1000),
                    ),
                  );
                },
                child: buildTaps(theme, width, tr("settings2")),
              ),
              // buildTaps(theme, width, tr("settings3")),
              // buildTaps(theme, width, tr("settings4")),
              // buildTaps(theme, width, tr("settings5")),
              buildTaps(theme, width, tr("settings7")),
              buildTaps(theme, width, tr("settings8")),
              buildTaps(theme, width, tr("settings9")),

              InkWell(
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: ChangeLanguage(),
                    withNavBar: false,
                    customPageRoute: PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => Favs(),
                      transitionsBuilder: (c, anim, a2, child) =>
                          FadeTransition(opacity: anim, child: child),
                      transitionDuration: Duration(milliseconds: 1000),
                    ),
                  );
                },
                child: buildTaps(theme, width, tr("settings10")),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
