import 'package:easy_localization/easy_localization.dart';
import '../../authPages/splash.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguage extends StatefulWidget {
  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  Future changeLang(String newLang) async {
    context.locale = Locale(newLang);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("lang", newLang == "ar" ? "2" : "1");
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Splash()), (route) => false);
  }

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
        automaticallyImplyLeading: true,
        title: Text(
          tr("language"),
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
              InkWell(
                onTap: () {
                  changeLang("ar");
                },
                child: buildTaps(theme, width, "العربية"),
              ),
              InkWell(
                onTap: () {
                  changeLang("en");
                },
                child: buildTaps(theme, width, "English"),
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
