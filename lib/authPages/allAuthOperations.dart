import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:orody/API/SharedApi.dart';
import 'package:orody/API/authPagesApi.dart';
import 'package:orody/authPages/transitionPage.dart';
import 'package:orody/insidePages/tabs.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../sharedInternet.dart';

class AllAuthOperations extends StatefulWidget {
  @override
  _AllAuthOperationsState createState() => _AllAuthOperationsState();
}

class _AllAuthOperationsState extends State<AllAuthOperations> {
  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();
  TextEditingController registerEmail = TextEditingController();
  TextEditingController registerPassword = TextEditingController();
  TextEditingController registerPasswordConfirm = TextEditingController();
  TextEditingController registerName = TextEditingController();

  final loginKey = GlobalKey<FormState>();
  final registerKey = GlobalKey<FormState>();
  bool loginPasswordHide = true;
  final resetKeyEmail = GlobalKey<FormState>();
  TextEditingController resetEmail = TextEditingController();
  final resetKeyPassword = GlobalKey<FormState>();
  TextEditingController resetPassword = TextEditingController();
  TextEditingController confirmResetPassword = TextEditingController();
  List countries = [];
  List cities = [];
  String countryId;
  String countryName = 'الدولة';
  String cityId;
  String cityName = 'المدينة';
  String dateFormatted = "الفئة العمرية";
  bool registerSent = false;
  bool loginSent = false;
  String lang;

  Future getUserJWT() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lang = prefs.getString("lang");
    });
  }

  @override
  void initState() {
    getUserJWT().then((value) {
      checkNetwork().then((value) {
        if (value) {
          getAllCountries(lang).then((response) {
            if (response[0] == false) {
              showErrorDialog(context, tr("global1"));
            } else {
              if (!mounted) return null;
              setState(() {
                countries = response[1];
              });
            }
          });
        } else {
          showInternetDialog(context, tr("global2"));
        }
      });
    });
  }

  buildButton(double width, ThemeData theme, String text, Color borderColor,
      Color textColor, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        height: 60,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
            border: Border.all(width: 2, color: borderColor)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
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

  buildInput(
      ThemeData theme,
      String hintText,
      TextEditingController controller,
      IconData prefixIcon,
      bool hideText,
      TextInputType keyBoardType,
      String validationText) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      child: TextFormField(
        validator: (value) {
          if (value.trim().isEmpty) {
            return validationText;
          }
          if (controller == registerPasswordConfirm &&
              value.trim() != registerPassword.text.trim()) {
            return tr("allAuth1");
          }
          return null;
        },
        maxLines: 1,
        keyboardType: keyBoardType,
        controller: controller,
        obscureText: hideText,
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
            prefixIcon: Icon(
              prefixIcon,
              color: Colors.grey.shade500,
              size: 25,
            ),
            fillColor: theme.accentColor,
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

// startRegisterForm

  openRegisterForm() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    return showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter newSetState /*You can rename this!*/) {
            return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Form(
                  key: registerKey,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Center(
                              child: Text(
                                tr("allAuth2"),
                                style: TextStyle(
                                    color: theme.primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Divider(
                            height: 10,
                            color: theme.primaryColor.withOpacity(0.5),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          buildInput(
                              theme,
                              tr("allAuth3"),
                              registerName,
                              Icons.person,
                              false,
                              TextInputType.text,
                              tr("allAuth4")),
                          buildInput(
                              theme,
                              tr("allAuth5"),
                              registerEmail,
                              FontAwesomeIcons.envelope,
                              false,
                              TextInputType.emailAddress,
                              tr("allAuth6")),
                          buildInput(
                              theme,
                              tr("allAuth67"),
                              registerPassword,
                              Icons.lock,
                              true,
                              TextInputType.text,
                              tr("allAuth8")),
                          buildInput(
                              theme,
                              tr("allAuth9"),
                              registerPasswordConfirm,
                              Icons.lock,
                              loginPasswordHide,
                              TextInputType.text,
                              tr("allAuth10")),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 30),
                            child: InkWell(
                              onTap: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime(2000),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(2015))
                                    .then((pickedDate) {
                                  if (pickedDate == null) {
                                    //if user tap cancel then this function will stop
                                    return;
                                  }
                                  newSetState(() {
                                    dateFormatted =
                                        "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}";
                                  });
                                });
                              },
                              child: Container(
                                height: 60,
                                width: width,
                                decoration: BoxDecoration(
                                    color: theme.accentColor,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 1, color: theme.accentColor)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        dateFormatted,
                                        style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        size: 30,
                                        color: Colors.grey.shade500,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          countries.length < 1
                              ? SizedBox()
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 30),
                                  child: Container(
                                    height: 60,
                                    width: width,
                                    decoration: BoxDecoration(
                                        color: theme.accentColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            width: 1,
                                            color: theme.accentColor)),
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: DropdownButton(
                                        underline: SizedBox(),
                                        iconSize: 30,
                                        isExpanded: true,
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          size: 30,
                                          color: Colors.grey.shade500,
                                        ),
                                        hint: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            countryName,
                                            style: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        items: countries.map((country) {
                                          return DropdownMenuItem<String>(
                                            value: "${country}",
                                            onTap: () {
                                              if (!mounted) return null;
                                              newSetState(() {
                                                countryName =
                                                    "${country["title"]}";
                                                countryId = "${country["id"]}";
                                                cityId = null;
                                                cityName = "المدينة";
                                                cities = [];
                                              });
                                              showLoadingIcon(context);
                                              checkNetwork().then((value) {
                                                Navigator.of(context).pop();
                                                if (value) {
                                                  getAllCountryCities(
                                                          lang, countryId)
                                                      .then((response) {
                                                    if (response[0] == false) {
                                                      showErrorDialog(context,
                                                          tr("global1"));
                                                    } else {
                                                      if (!mounted) return null;
                                                      newSetState(() {
                                                        cities = response[1];
                                                      });
                                                    }
                                                  });
                                                } else {
                                                  showInternetDialog(
                                                      context, tr("global2"));
                                                }
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: new Text(
                                                "${country["title"]}",
                                                style: TextStyle(
                                                    color: Colors.grey.shade500,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (_) {},
                                      ),
                                    ),
                                  ),
                                ),
                          cities.length < 1
                              ? SizedBox()
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 30),
                                  child: Container(
                                    height: 60,
                                    width: width,
                                    decoration: BoxDecoration(
                                        color: theme.accentColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            width: 1,
                                            color: theme.accentColor)),
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: DropdownButton(
                                        underline: SizedBox(),
                                        iconSize: 30,
                                        isExpanded: true,
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          size: 30,
                                          color: Colors.grey.shade500,
                                        ),
                                        hint: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            cityName,
                                            style: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        items: cities.map((city) {
                                          return DropdownMenuItem<String>(
                                            value: "${city}",
                                            onTap: () {
                                              newSetState(() {
                                                cityName = "${city["title"]}";
                                                cityId = "${city["id"]}";
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: new Text(
                                                "${city["title"]}",
                                                style: TextStyle(
                                                    color: Colors.grey.shade500,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (_) {},
                                      ),
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: registerSent
                                ? Container(
                                    child: SpinKitDoubleBounce(
                                      color:
                                          theme.primaryColor.withOpacity(0.8),
                                      size: 50.0,
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      if (registerKey.currentState.validate()) {
                                        if (dateFormatted == "الفئة العمرية") {
                                          return showErrorDialog(
                                              context, tr("allAuth11"));
                                        } else if (countryId == null) {
                                          return showErrorDialog(
                                              context, tr("allAuth12"));
                                        } else if (cityId == null) {
                                          return showErrorDialog(
                                              context, tr("allAuth13"));
                                        } else {
                                          newSetState(() {
                                            registerSent = true;
                                          });
                                          checkNetwork().then((value) {
                                            if (value) {
                                              register(
                                                      registerName.text.trim(),
                                                      registerEmail.text.trim(),
                                                      registerPassword.text
                                                          .trim(),
                                                      dateFormatted,
                                                      countryId,
                                                      cityId)
                                                  .then((response) async {
                                                newSetState(() {
                                                  registerSent = false;
                                                });
                                                if (response["code"] == "400" &&
                                                    response["data"] == null) {
                                                  showErrorDialog(
                                                      context, tr("allAuth14"));
                                                } else if (response["user"]
                                                    is Map) {
                                                  registerAndGo(response);
                                                } else {
                                                  showErrorDialog(
                                                      context, tr("global1"));
                                                }
                                              });
                                            } else {
                                              newSetState(() {
                                                registerSent = false;
                                              });
                                              showInternetDialog(
                                                  context, tr("global2"));
                                            }
                                          });
                                        }
                                      }
                                    },
                                    child: buildButton(
                                        width,
                                        theme,
                                        tr("allAuth15"),
                                        theme.primaryColor,
                                        Colors.white,
                                        theme.primaryColor),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          });
        });
  }

  registerAndGo(response) async {
    Navigator.pop(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name", response["user"]["name"]);
    // prefs.setString(
    //     "image", "http://orody.com/project/public${response["user"]["image"]}");
    prefs.setString("email", response["user"]["email"]);
    prefs.setString("city_id", "${response["user"]["city_id"]}");
    prefs.setString("country_id", "${response["user"]["country_id"]}");
    prefs.setString("birth_date", response["user"]["birth_date"]);
    prefs.setString("id", "${response["user"]["id"]}");
    prefs.setString("jwt", response["access_token"]);
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => TransitionPage(),
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: Duration(milliseconds: 1000),
        ),
        (route) => false);
  }
  // endRegisterForm

  openLoginForm() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    return showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter newSetState /*You can rename this!*/) {
            return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Form(
                  key: loginKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: Center(
                            child: Text(
                              tr("allAuth16"),
                              style: TextStyle(
                                  color: theme.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Divider(
                          height: 10,
                          color: theme.primaryColor.withOpacity(0.5),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        buildInput(
                            theme,
                            tr("allAuth5"),
                            loginEmail,
                            FontAwesomeIcons.envelope,
                            false,
                            TextInputType.emailAddress,
                            tr("allAuth6")),
                        buildInput(
                            theme,
                            tr("allAuth7"),
                            loginPassword,
                            Icons.lock,
                            true,
                            TextInputType.text,
                            tr("allAuth8")),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: loginSent
                              ? Container(
                                  child: SpinKitDoubleBounce(
                                    color: theme.primaryColor.withOpacity(0.8),
                                    size: 50.0,
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    if (loginKey.currentState.validate()) {
                                      newSetState(() {
                                        loginSent = true;
                                      });
                                      checkNetwork().then((value) {
                                        if (value) {
                                          login(
                                            loginEmail.text.trim(),
                                            loginPassword.text.trim(),
                                          ).then((response) async {
                                            newSetState(() {
                                              loginSent = false;
                                            });

                                            if (response["code"] == "401" &&
                                                response["data"] == null) {
                                              showErrorDialog(
                                                  context, tr("allAuth17"));
                                            } else if (response["data"]
                                                is Map) {
                                              loginAndGo(response);
                                            } else {
                                              showErrorDialog(
                                                  context, tr("global1"));
                                            }
                                          });
                                        } else {
                                          newSetState(() {
                                            loginSent = false;
                                          });
                                          showInternetDialog(
                                              context, tr("global2"));
                                        }
                                      });
                                    }
                                  },
                                  child: buildButton(
                                      width,
                                      theme,
                                      tr("allAuth16"),
                                      theme.primaryColor,
                                      Colors.white,
                                      theme.primaryColor),
                                ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                openForgetPassword();
                              },
                              child: Text(
                                tr("allAuth18"),
                                style: TextStyle(
                                    color: theme.primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          });
        });
  }

  loginAndGo(response) async {
    Navigator.pop(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name", response["data"]["name"]);
    prefs.setString("email", response["data"]["email"]);
    prefs.setString(
        "image", "http://orody.com/project/public${response["data"]["image"]}");
    prefs.setString("city_id", "${response["data"]["city_id"]}");
    prefs.setString("birth_date", response["data"]["birth_date"]);
    prefs.setString("country_id", "${response["data"]["country_id"]}");
    prefs.setString("id", "${response["data"]["id"]}");
    prefs.setString("jwt", response["access_token"]);
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => TransitionPage(),
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: Duration(milliseconds: 1000),
        ),
        (route) => false);
  }
  // End Login

  openForgetPassword() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    Navigator.pop(context);
    return showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        context: context,
        builder: (builder) {
          return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: forgetPasswordFormEmail(theme, width));
        });
  }

  forgetPasswordFormEmail(theme, width) {
    return Form(
      key: resetKeyEmail,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                child: Text(
                  tr("allAuth19"),
                  style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(
              height: 10,
              color: theme.primaryColor.withOpacity(0.5),
            ),
            SizedBox(
              height: 20,
            ),
            buildInput(
              theme,
              tr("allAuth5"),
              resetEmail,
              FontAwesomeIcons.envelope,
              false,
              TextInputType.emailAddress,
              tr("allAuth6"),
            ),
            InkWell(
              onTap: () {
                if (resetEmail.text.trim().isNotEmpty) {
                  if (RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(resetEmail.text.trim())) {
                    checkNetwork().then((value) async {
                      if (value) {
                        showLoadingIcon(context);
                        sendMePasswordAgain(resetEmail.text.trim())
                            .then((response) {
                          Navigator.of(context, rootNavigator: true).pop();
                          if (response["status"] == true) {
                            resetEmail.clear();
                            Navigator.of(context, rootNavigator: true).pop();
                            Fluttertoast.showToast(
                                msg: tr("allAuth20"),
                                backgroundColor: theme.primaryColor,
                                textColor: Colors.white,
                                fontSize: 18,
                                gravity: ToastGravity.CENTER);
                          } else {
                            showErrorDialog(context, tr("global1"));
                          }
                        });
                      } else {
                        showErrorDialog(context, tr("global2"));
                      }
                    });
                  }
                }
              },
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: buildButton(width, theme, tr("contactus7"),
                    theme.primaryColor, Colors.white, theme.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // openForgetPasswordConfirm() {
  //   double height = MediaQuery.of(context).size.height;
  //   double width = MediaQuery.of(context).size.width;
  //   ThemeData theme = Theme.of(context);
  //   Navigator.pop(context);
  //   return showModalBottomSheet(
  //       isDismissible: true,
  //       isScrollControlled: true,
  //       backgroundColor: Colors.white,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(15), topRight: Radius.circular(15)),
  //       ),
  //       context: context,
  //       builder: (builder) {
  //         return Padding(
  //             padding: MediaQuery.of(context).viewInsets,
  //             child: forgetPasswordFormNewPassword(theme, width));
  //       });
  // }

  // forgetPasswordFormNewPassword(theme, width) {
  //   return Form(
  //     key: resetKeyPassword,
  //     child: SingleChildScrollView(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: <Widget>[
  //           Padding(
  //             padding: EdgeInsets.all(15),
  //             child: Center(
  //               child: Text(
  //                 "استعادة كلمة السر",
  //                 style: TextStyle(
  //                     color: theme.primaryColor,
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.bold),
  //               ),
  //             ),
  //           ),
  //           Divider(
  //             height: 10,
  //             color: theme.primaryColor.withOpacity(0.5),
  //           ),
  //           SizedBox(
  //             height: 20,
  //           ),
  //           buildInput(theme, "كلمة السر الجديدة", resetPassword, Icons.lock,
  //               false, TextInputType.text, "من  فضلك أدخل كلمة السر الجديدة"),
  //           buildInput(
  //               theme,
  //               "تأكيد كلمة السر الجديدة",
  //               confirmResetPassword,
  //               Icons.lock,
  //               false,
  //               TextInputType.text,
  //               "من  فضلك أكد كلمة السر الجديدة"),
  //           Padding(
  //             padding: EdgeInsets.only(top: 20),
  //             child: buildButton(width, theme, "تأكيد", theme.primaryColor,
  //                 Colors.white, theme.primaryColor),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: height / 3, bottom: 70),
                child: Image.asset(
                  "assets/images/logo.png",
                  height: width / 2,
                  width: width / 2,
                ),
              ),
              InkWell(
                onTap: () {
                  openLoginForm();
                },
                child: buildButton(width, theme, tr("allAuth16"),
                    theme.primaryColor, Colors.white, theme.primaryColor),
              ),
              SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: () {
                  openRegisterForm();
                },
                child: buildButton(width, theme, tr("allAuth2"),
                    theme.primaryColor, theme.primaryColor, Colors.white),
              ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
