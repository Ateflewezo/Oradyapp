import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orody/API/SharedApi.dart';
import 'package:orody/API/insideApi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../sharedInternet.dart';
import '../funkyPopUp.dart';

class Favs extends StatefulWidget {
  @override
  _FavsState createState() => _FavsState();
}

class _FavsState extends State<Favs> {
  String jwt;
  String lang;
  List favs = [];

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      jwt = prefs.getString("jwt");
      lang = prefs.getString("lang");
    });
  }

  @override
  void initState() {
    getUserData().then((value) {
      checkNetwork().then((value) {
        if (value) {
          getAllFavs(lang, jwt).then((response) {
            if (response[0] == false) {
              showErrorDialog(context, tr("global1"));
            } else {
              if (!mounted) return null;
              setState(() {
                favs = response[1];
              });
            }
          });
        } else {
          showInternetDialog(context, tr("global2"));
        }
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
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text(
          tr("settings10"),
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: height,
        width: width,
        color: Colors.grey.shade100,
        child: ListView.builder(
          itemCount: favs.length,
          shrinkWrap: true,
          physics: ScrollPhysics(parent: ScrollPhysics()),
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            Map fav = favs[index];
            return fav["favoriteable_type"] == "App\\Offer"
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Container(
                      height: height / 5,
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: height / 4,
                            width: width / 3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                              color: theme.accentColor,
                              // image: DecorationImage(
                              //     image: NetworkImage(
                              //       "http://orody.com/project/public${fav["cover"]}",
                              //     ),
                              //     fit: BoxFit.cover)
                            ),
                          ),
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: width / 1.5,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        width: width / 2.5,
                                        child: Text(
                                          "${fav["title"]}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width / 1.5,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: InkWell(
                                          onTap: () {
                                            if ("${fav["code"]}".length == 0 ||
                                                "${fav["code"]}" == "null") {
                                              checkNetwork()
                                                  .then((value) async {
                                                if (value) {
                                                  await launch(
                                                      "${fav["link"]}");
                                                } else {
                                                  showErrorDialog(
                                                      context, tr("global1"));
                                                }
                                              });
                                            } else {
                                              return showDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: RichText(
                                                        textAlign:
                                                            TextAlign.center,
                                                        text: TextSpan(
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text:
                                                                    fav["code"],
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "cairo",
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontSize:
                                                                        18)),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: InkWell(
                                                            onTap: () {
                                                              Clipboard.setData(
                                                                  new ClipboardData(
                                                                      text: fav[
                                                                          "code"]));
                                                              Fluttertoast
                                                                  .showToast(
                                                                msg: tr(
                                                                    "sharedInternet6"),
                                                                backgroundColor:
                                                                    theme
                                                                        .primaryColor,
                                                                fontSize: 16,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                gravity:
                                                                    ToastGravity
                                                                        .CENTER,
                                                              );
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              tr("sharedInternet5"),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  fontFamily:
                                                                      "cairo",
                                                                  fontSize: 15),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            }
                                          },
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: theme.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Center(
                                                child: Text(
                                                  tr("stores3"),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            checkNetwork().then((value) async {
                                              if (value) {
                                                showLoadingIcon(context);
                                                addOfferToFavourite(
                                                        "${fav["id"]}", jwt)
                                                    .then((response) {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                  if (response["status"] ==
                                                      true) {
                                                    Fluttertoast.showToast(
                                                        msg: tr("addTo"),
                                                        backgroundColor:
                                                            theme.primaryColor,
                                                        textColor: Colors.white,
                                                        fontSize: 18,
                                                        gravity: ToastGravity
                                                            .CENTER);
                                                  } else {
                                                    showErrorDialog(
                                                        context, tr("global1"));
                                                  }
                                                });
                                              } else {
                                                showErrorDialog(
                                                    context, tr("global2"));
                                              }
                                            });
                                          },
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: theme.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Center(
                                              child: Icon(
                                                Icons.bookmark,
                                                color: Colors.white,
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: theme.primaryColor,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Center(
                                            child: Icon(
                                              Icons.share,
                                              color: theme.primaryColor,
                                              size: 28,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                  )
                : fav["favoriteable_type"] == "App\\Flyer"
                    ? Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Container(
                          height: height / 5,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  checkNetwork().then((value) {
                                    if (value) {
                                      showLoadingIcon(context);
                                      getOneStoreFlyerImages(
                                              lang, jwt, "${fav["id"]}")
                                          .then((response) {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                        if (response["status"] == true) {
                                          if (!mounted) return null;
                                          setState(() {
                                            showDialog(
                                              context: context,
                                              builder: (_) => FunkyOverlay(
                                                  response["data"]["images"]),
                                            );
                                          });
                                        } else {
                                          showErrorDialog(
                                              context, tr("global1"));
                                        }
                                      });
                                    } else {
                                      showErrorDialog(context, tr("global2"));
                                    }
                                  });
                                },
                                child: Container(
                                  height: height / 4,
                                  width: width / 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5)),
                                    color: theme.accentColor,
                                    // image: DecorationImage(
                                    //     image: NetworkImage(
                                    //       "http://orody.com/project/public${fav["cover"]}",
                                    //     ),
                                    //     fit: BoxFit.cover)
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: width / 1.5,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: width / 2.5,
                                            child: Text(
                                              "${fav["title"]}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: width / 1.5,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 3,
                                            child: InkWell(
                                              onTap: () {
                                                checkNetwork()
                                                    .then((value) async {
                                                  if (value) {
                                                    await launch(
                                                        "${fav["link"]}");
                                                  } else {
                                                    showErrorDialog(
                                                        context, tr("global2"));
                                                  }
                                                });
                                              },
                                              child: Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: theme.primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Center(
                                                    child: Text(
                                                      tr("stores3"),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () {
                                                checkNetwork()
                                                    .then((value) async {
                                                  if (value) {
                                                    showLoadingIcon(context);
                                                    addFlyersToFavourite(
                                                            "${fav["id"]}", jwt)
                                                        .then((response) {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                      if (response["status"] ==
                                                          true) {
                                                        Fluttertoast.showToast(
                                                            msg: tr("addTo"),
                                                            backgroundColor: theme
                                                                .primaryColor,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 18,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER);
                                                      } else {
                                                        showErrorDialog(context,
                                                            tr("global1"));
                                                      }
                                                    });
                                                  } else {
                                                    showErrorDialog(
                                                        context, tr("global2"));
                                                  }
                                                });
                                              },
                                              child: Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: theme.primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.bookmark,
                                                    color: Colors.white,
                                                    size: 28,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: theme.primaryColor,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Center(
                                                child: Icon(
                                                  Icons.share,
                                                  color: theme.primaryColor,
                                                  size: 28,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ))
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Container(
                          height: height / 5,
                          width: width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: height / 4,
                                width: width / 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                  color: theme.accentColor,
                                  // image: DecorationImage(
                                  //     image: NetworkImage(
                                  //       "http://orody.com/project/public${fav["cover"]}",
                                  //     ),
                                  //     fit: BoxFit.cover)
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: width / 1.5,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: width / 2.5,
                                            child: Text(
                                              "${fav["title"]}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: width / 1.5,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 3,
                                            child: RichText(
                                                text: TextSpan(children: [
                                              TextSpan(
                                                  text:
                                                      " ${fav["price_after"]} ",
                                                  style: TextStyle(
                                                      fontFamily: "cairo",
                                                      fontSize: 18,
                                                      color: Colors.red)),
                                              TextSpan(
                                                  text:
                                                      " ${fav["price_before"]} ",
                                                  style: TextStyle(
                                                      fontFamily: "cairo",
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                      decoration: TextDecoration
                                                          .lineThrough)),
                                            ])),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: InkWell(
                                              onTap: () {
                                                checkNetwork()
                                                    .then((value) async {
                                                  if (value) {
                                                    showLoadingIcon(context);
                                                    addCouponToFavourite(
                                                            "${fav["id"]}", jwt)
                                                        .then((response) {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                      if (response["status"] ==
                                                          true) {
                                                        Fluttertoast.showToast(
                                                            msg: tr("addTo"),
                                                            backgroundColor: theme
                                                                .primaryColor,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 18,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER);
                                                      } else {
                                                        showErrorDialog(context,
                                                            tr("global1"));
                                                      }
                                                    });
                                                  } else {
                                                    showErrorDialog(
                                                        context, tr("global2"));
                                                  }
                                                });
                                              },
                                              child: Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: theme.primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.bookmark,
                                                    color: Colors.white,
                                                    size: 28,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: theme.primaryColor,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Center(
                                                child: Icon(
                                                  Icons.share,
                                                  color: theme.primaryColor,
                                                  size: 28,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ))
                            ],
                          ),
                        ),
                      );
          },
        ),
      ),
    );
  }
}
