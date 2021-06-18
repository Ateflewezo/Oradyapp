import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:orody/API/SharedApi.dart';
import 'package:orody/API/insideApi.dart';
import 'package:orody/sharedInternet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final contactKey = GlobalKey<FormState>();
  TextEditingController phone = TextEditingController();
  TextEditingController message = TextEditingController();
  String name;
  String email;

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name");
      email = prefs.getString("email");
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  buildInputBorder(ThemeData theme) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(width: 1, color: theme.accentColor));
  }

  buildfocusBorder(ThemeData theme) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(width: 2, color: theme.primaryColor));
  }

  buildInput(ThemeData theme, String hintText, TextEditingController controller,
      TextInputType keyBoardType, String validationText) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      child: TextFormField(
        validator: (value) {
          if (value.trim().isEmpty) {
            return validationText;
          }

          return null;
        },
        maxLines: controller == phone ? 1 : 5,
        keyboardType: keyBoardType,
        controller: controller,
        style: TextStyle(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16),
        decoration: InputDecoration(
            errorStyle: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 13),
            hintText: hintText,
            hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16,
                fontWeight: FontWeight.bold),
            fillColor: Colors.white,
            filled: true,
            disabledBorder: buildInputBorder(theme),
            enabledBorder: buildInputBorder(theme),
            errorBorder: buildfocusBorder(theme),
            focusedBorder: buildfocusBorder(theme),
            focusedErrorBorder: buildfocusBorder(theme),
            border: buildInputBorder(theme),
            contentPadding: EdgeInsets.all(14)),
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
          tr("contactus1"),
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: contactKey,
        child: Container(
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
                buildInput(theme, tr("contactus2"), phone, TextInputType.phone,
                    tr("contactus3")),
                buildInput(theme, tr("contactus4"), message, TextInputType.text,
                    tr("contactus5")),
                Padding(
                  padding: EdgeInsets.all(30),
                  child: InkWell(
                    onTap: () {
                      if (contactKey.currentState.validate()) {
                        checkNetwork().then((value) {
                          if (value) {
                            showLoadingIcon(context);
                            contactUs(name, email, phone.text.trim(),
                                    message.text.trim())
                                .then((response) {
                              Navigator.of(context, rootNavigator: true).pop();
                              if (response["status"] == true) {
                                message.clear();
                                phone.clear();
                                Fluttertoast.showToast(
                                    msg: tr("contactus6"),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: theme.primaryColor,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                showErrorDialog(context, tr("global1"));
                              }
                            });
                          } else {
                            showErrorDialog(context, tr("global2"));
                          }
                        });
                      }
                    },
                    child: Container(
                      height: 50,
                      width: width,
                      decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          tr("contactus7"),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
