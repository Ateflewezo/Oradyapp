import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orody/API/SharedApi.dart';
import 'package:orody/API/insideApi.dart';
import 'package:orody/sharedInternet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoyalityCard extends StatefulWidget {
  @override
  _LoyalityCardState createState() => _LoyalityCardState();
}

class _LoyalityCardState extends State<LoyalityCard> {
  List cards = [];
  TextEditingController nameOfCard = TextEditingController();
  TextEditingController nameOfPerson = TextEditingController();
  TextEditingController numebrOfCard = TextEditingController();
  File frontardImage;
  File backardImage;
  bool addCardSent = false;
  String jwt;
  final picker = ImagePicker();
  Future getUserJwt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      jwt = prefs.getString("jwt");
    });
  }

  getListOfCards() {
    checkNetwork().then((value) {
      if (value) {
        getLoyalityCards(jwt).then((response) {
          if (response["status"] == true) {
            if (!mounted) return null;
            setState(() {
              cards = response["data"];
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

  @override
  void initState() {
    // TODO: implement initState
    getUserJwt().then((sda) {
      getListOfCards();
    });
    super.initState();
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
    TextInputType keyBoardType,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      child: TextFormField(
        maxLines: 1,
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

  Future getImageFromCamera(int step) async {
    Navigator.of(context, rootNavigator: true).pop();
    await Permission.camera.request().then((value) async {
      if (value != PermissionStatus.denied) {
        final pickedFile = await picker.getImage(source: ImageSource.camera);
        if (pickedFile != null) {
          _cropImage(pickedFile, step);
        }
      }
    });
  }

  Future getImageFromGallery(int step) async {
    Navigator.of(context, rootNavigator: true).pop();
    await Permission.storage.request().then((value) async {
      if (value == PermissionStatus.granted) {
        final pickedFile = await picker.getImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          _cropImage(pickedFile, step);
        }
      }
    });
  }

  Future<Null> _cropImage(pickedFile, int step) async {
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
      setState(() {
        step == 1 ? frontardImage = croppedFile : backardImage = croppedFile;
        Navigator.of(context, rootNavigator: true).pop();
        addNewCardBottomSheet();
      });
    }
  }

  chooseImageSource(int step) {
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
                        getImageFromGallery(step);
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
                        getImageFromCamera(step);
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

  addNewCardBottomSheet() {
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Center(
                          child: Text(
                            tr("loyal1"),
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
                        tr("loyal2"),
                        nameOfCard,
                        TextInputType.text,
                      ),
                      buildInput(
                        theme,
                        tr("loyal3"),
                        nameOfPerson,
                        TextInputType.text,
                      ),
                      buildInput(
                        theme,
                        tr("loyal4"),
                        numebrOfCard,
                        TextInputType.phone,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        child: InkWell(
                          onTap: () {
                            chooseImageSource(1);
                          },
                          child: Container(
                            height: height / 5,
                            width: width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade200,
                              image: frontardImage != null
                                  ? DecorationImage(
                                      image: FileImage(frontardImage),
                                      fit: BoxFit.cover)
                                  : null,
                            ),
                            child: frontardImage != null
                                ? SizedBox()
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.photo),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            tr("loyal5"),
                                            style: TextStyle(
                                                color: Colors.grey.shade400,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        child: InkWell(
                          onTap: () {
                            chooseImageSource(2);
                          },
                          child: Container(
                            height: height / 5,
                            width: width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade200,
                              image: backardImage != null
                                  ? DecorationImage(
                                      image: FileImage(backardImage),
                                      fit: BoxFit.cover)
                                  : null,
                            ),
                            child: backardImage != null
                                ? SizedBox()
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.photo),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            tr("loyal5"),
                                            style: TextStyle(
                                                color: Colors.grey.shade400,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: addCardSent
                            ? Container(
                                child: SpinKitDoubleBounce(
                                  color: theme.primaryColor.withOpacity(0.8),
                                  size: 50.0,
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  if (nameOfPerson.text.trim().isNotEmpty &&
                                      nameOfCard.text.trim().isNotEmpty &&
                                      numebrOfCard.text.trim().isNotEmpty &&
                                      frontardImage != null &&
                                      backardImage != null) {
                                    newSetState(() {
                                      addCardSent = true;
                                    });
                                    checkNetwork().then((value) {
                                      if (value) {
                                        addNewCard(
                                                nameOfCard.text.trim(),
                                                nameOfCard.text.trim(),
                                                numebrOfCard.text.trim(),
                                                frontardImage,
                                                backardImage,
                                                jwt)
                                            .then((response) async {
                                          newSetState(() {
                                            addCardSent = false;
                                            frontardImage = null;
                                            backardImage = null;
                                            nameOfCard.clear();
                                            nameOfPerson.clear();
                                            numebrOfCard.clear();
                                          });

                                          if (response["data"] == null) {
                                            showErrorDialog(
                                                context, tr("loyal7"));
                                          } else if (response["data"] is Map) {
                                            getListOfCards();
                                            Fluttertoast.showToast(
                                                msg: tr("loyal8"),
                                                backgroundColor:
                                                    theme.primaryColor,
                                                fontSize: 16,
                                                textColor: Colors.white,
                                                gravity: ToastGravity.CENTER);
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          } else {
                                            showErrorDialog(
                                                context, tr("global1"));
                                          }
                                        });
                                      } else {
                                        newSetState(() {
                                          addCardSent = false;
                                        });
                                        showInternetDialog(
                                            context, tr("global2"));
                                      }
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Container(
                                    height: 60,
                                    width: width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: theme.primaryColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        tr("loyal9"),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ));
          });
        });
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
          tr("loyal10"),
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: height,
        width: width,
        color: Colors.grey.shade200,
        child: SingleChildScrollView(
          physics: ScrollPhysics(parent: ScrollPhysics()),
          child: Column(
            children: <Widget>[
              ListView.builder(
                itemCount: cards.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(parent: ScrollPhysics()),
                itemBuilder: (BuildContext context, int index) {
                  Map card = cards[index];
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: 10, right: 20, left: 20, top: 10),
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: ListTile(
                        trailing: Icon(Icons.arrow_forward_ios,
                            size: 26, color: theme.primaryColor),
                        title: Text(
                          "${card["card_name"]}",
                          style: TextStyle(
                              color: theme.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.all(30),
                child: InkWell(
                  onTap: () {
                    addNewCardBottomSheet();
                  },
                  child: Container(
                    height: 50,
                    width: width,
                    decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        tr("loyal11"),
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
    );
  }
}
