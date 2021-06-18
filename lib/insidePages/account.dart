import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orody/API/SharedApi.dart';
import 'package:orody/API/authPagesApi.dart';
import 'package:orody/sharedInternet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool edit = false;
  String name = "";
  String email = "";
  String birth_date = "";
  String jwt = "";
  String id = "";
  String imageUrl = "";

  File licenseImage;
  final picker = ImagePicker();

  TextEditingController controller = TextEditingController();
  Future getUserJwt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!mounted) return null;
    setState(() {
      id = prefs.getString("id");
      name = prefs.getString("name");
      email = prefs.getString("email");
      imageUrl = prefs.getString("image");
      birth_date = prefs.getString("birth_date");
      jwt = prefs.getString("jwt");
      print(jwt);
    });
  }

  @override
  void initState() {
    super.initState();
    getUserJwt();
  }

  Future getImageFromCamera() async {
    Navigator.of(context, rootNavigator: true).pop();
    await Permission.camera.request().then((value) async {
      if (value != PermissionStatus.denied) {
        final pickedFile = await picker.getImage(source: ImageSource.camera);
        if (pickedFile != null) {
          _cropImage(pickedFile);
        }
      }
    });
  }

  Future getImageFromGallery() async {
    Navigator.of(context, rootNavigator: true).pop();
    await Permission.storage.request().then((value) async {
      if (value == PermissionStatus.granted) {
        final pickedFile = await picker.getImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          _cropImage(pickedFile);
        }
      }
    });
  }

  Future<Null> _cropImage(pickedFile) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            activeControlsWidgetColor: Theme.of(context).primaryColor,
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));

    if (croppedFile != null) {
      showLoadingIcon(context);
      checkNetwork().then((value) {
        if (value) {
          updateAccountFields("image", jwt, croppedFile).then((response) async {
            Navigator.of(context, rootNavigator: true).pop();
            if (response["status"] == true) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              print(prefs.getString("image"));
              prefs.setString("name", response["data"]["name"]);
              prefs.setString("email", response["data"]["email"]);
              prefs.setString("image",
                  "http://orody.com/project/public${response["data"]["image"]}");
              prefs.setString("birth_date", response["data"]["birth_date"]);
              print(prefs.getString("image"));
              if (!mounted) return null;
              setState(() {
                name = response["data"]["name"];
                email = response["data"]["email"];
                birth_date = response["data"]["birth_date"];
                imageUrl =
                    "http://orody.com/project/public${response["data"]["image"]}";
              });
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

  chooseImageSource() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                    child: InkWell(
                      onTap: () {
                        getImageFromGallery();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Icon(
                            Icons.photo,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                    child: InkWell(
                      onTap: () {
                        getImageFromCamera();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _showDialog(String title, String type) async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    controller: controller,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontFamily: "cairo",
                        fontSize: 15),
                    autofocus: true,
                    keyboardType: type == "name"
                        ? TextInputType.text
                        : TextInputType.emailAddress,
                    decoration: new InputDecoration(
                        prefixIcon:
                            Icon(type == "name" ? Icons.person : Icons.email),
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontFamily: "cairo",
                            fontSize: 15),
                        hintText: '$title'),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: Text(
                    tr("sharedInternet3"),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontFamily: "cairo",
                        fontSize: 15),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  }),
              new FlatButton(
                  child: Text(
                    tr("sharedInternet4"),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontFamily: "cairo",
                        fontSize: 15),
                  ),
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      updateField(controller.text.trim(),
                          type == "name" ? "name" : "email", 2);
                    }
                  })
            ],
          );
        });
  }

  updateField(String value, String fieldName, int nav) {
    nav == 1 ? null : Navigator.of(context, rootNavigator: true).pop();
    checkNetwork().then((checkInternetValue) {
      if (checkInternetValue) {
        showLoadingIcon(context);
        updateAccountFields(fieldName, jwt, value).then((response) async {
          Navigator.of(context, rootNavigator: true).pop();
          if (response["status"] == true) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("name", response["data"]["name"]);
            prefs.setString("email", response["data"]["email"]);
            prefs.setString("image",
                "http://orody.com/project/public${response["data"]["image"]}");
            prefs.setString("birth_date", response["data"]["birth_date"]);
            if (!mounted) return null;
            setState(() {
              name = response["data"]["name"];
              email = response["data"]["email"];
              birth_date = response["data"]["birth_date"];
              imageUrl =
                  "http://orody.com/project/public${response["data"]["image"]}";
            });
          } else {
            showErrorDialog(context, tr("global1"));
          }
        });
      } else {
        showInternetDialog(context, tr("global2"));
      }
    });
  }

  buildTaps(
      ThemeData theme, double width, String text, IconData icon, String type) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20, right: 20, left: 20),
      child: Container(
        width: width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: ListTile(
          leading: Icon(icon, size: 26, color: theme.primaryColor),
          title: Text(
            text,
            style: TextStyle(
                color: theme.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          trailing: !edit
              ? SizedBox()
              : InkWell(
                  onTap: () {
                    type == "date"
                        ? showDatePicker(
                                context: context,
                                initialDate: DateTime(2000),
                                firstDate: DateTime(1950),
                                confirmText: tr("sharedInternet4"),
                                lastDate: DateTime(2015))
                            .then((pickedDate) {
                            if (pickedDate == null) {
                              //if user tap cancel then this function will stop
                              return;
                            }
                            updateField(
                                "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}",
                                "birth_date",
                                1);
                          })
                        : _showDialog(
                            type == "name" ? tr("allAuth3") : tr("allAuth5"),
                            type);
                  },
                  child: Icon(Icons.edit, size: 26, color: theme.primaryColor)),
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
        actions: <Widget>[
          context.locale.toString() == "en"
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          edit = !edit;
                        });
                      },
                      child: Image.asset(
                        edit
                            ? "assets/images/save_edit.png"
                            : "assets/images/edit_icon.png",
                        fit: BoxFit.scaleDown,
                        height: 30,
                        width: 30,
                      )),
                )
              : SizedBox(),
        ],
        leading: context.locale.toString() == "en"
            ? SizedBox()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                    onTap: () {
                      setState(() {
                        edit = !edit;
                      });
                    },
                    child: Image.asset(
                      edit
                          ? "assets/images/save_edit.png"
                          : "assets/images/edit_icon.png",
                      fit: BoxFit.scaleDown,
                      height: 30,
                      width: 30,
                    )),
              ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          tr("account1"),
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
              Padding(
                  padding: EdgeInsets.all(50),
                  child: Center(
                    child: Container(
                      height: width / 3,
                      width: width / 3,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageUrl != null
                                  ? NetworkImage("${imageUrl}")
                                  : AssetImage(
                                      "assets/images/profile_icon.png"),
                              fit: imageUrl != null
                                  ? BoxFit.cover
                                  : BoxFit.scaleDown),
                          shape: BoxShape.circle,
                          color: theme.primaryColor),
                      child: Stack(
                        children: <Widget>[
                          imageUrl != null
                              ? SizedBox()
                              : Center(
                                  child: Container(
                                    height: width / 3.2,
                                    width: width / 3.2,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 5, color: Colors.white),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                          !edit
                              ? SizedBox()
                              : Positioned(
                                  right: 3,
                                  bottom: 3,
                                  child: InkWell(
                                    onTap: () {
                                      chooseImageSource();
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                          shape: BoxShape.circle),
                                      child: InkWell(
                                        child: Icon(
                                          Icons.edit,
                                          color: theme.primaryColor,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  )),
              buildTaps(theme, width, name, Icons.person_outline, "name"),
              buildTaps(
                  theme, width, email, FontAwesomeIcons.envelope, "email"),
              // buildTaps(theme, width, "0966123456789", Icons.phone),
              // buildTaps(theme, width, "السعودية, الرياض", Icons.location_on),
              buildTaps(theme, width, birth_date, Icons.access_time, "date"),
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
