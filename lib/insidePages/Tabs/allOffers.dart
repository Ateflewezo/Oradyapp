import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orody/API/SharedApi.dart';
import 'package:orody/API/insideApi.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import '../../sharedInternet.dart';
import 'oneStoreCoupon.dart';

class AllOffers extends StatefulWidget {
  @override
  _AllOffersState createState() => _AllOffersState();
}

class _AllOffersState extends State<AllOffers> {
  String jwt;
  String lang;
  List offers = [];
  List stores = [];
  List categories = [];

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
          getAllOffers(lang, jwt).then((response) {
            if (response[0] == false) {
              showErrorDialog(
                  context, "حدث خطأ ما , من فضلك حاول لاحقا مرة اخري");
            } else {
              if (!mounted) return null;
              print(response[1][0]);
              setState(() {
                offers = response[1];
              });
            }
          });

          getAllFlyers(lang, jwt).then((response) {
            if (response["status"] == true) {
              if (!mounted) return null;
              setState(() {
                stores = response["data"];
              });
            } else {
              showErrorDialog(context, tr("global1"));
            }
          });
          getAllCategories(lang, jwt).then((response) {
            if (response["status"] == true) {
              if (!mounted) return null;
              setState(() {
                categories = response["data"];
              });
            } else {
              showErrorDialog(context, tr("global1"));
            }
          });
        } else {
          showInternetDialog(
              context, 'من فضلك تأكد من إتصالك بالإنترنت وحاول مرة أخري');
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
          tr("tabs3"),
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: height,
        width: width,
        color: Colors.grey.shade100,
        child: SingleChildScrollView(
          physics: ScrollPhysics(parent: ScrollPhysics()),
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                width: width,
                height: 80,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: stores.length,
                    scrollDirection: Axis.horizontal,
                    physics: ScrollPhysics(parent: ScrollPhysics()),
                    itemBuilder: (context, int index) {
                      Map store = stores[index];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          onTap: () {
                            pushNewScreen(
                              context,
                              screen: OneStoreCoupon("${store["id"]}",
                                  "${store["name"]} ${store["lastname"]}"),
                              withNavBar: false,
                              customPageRoute: PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => OneStoreCoupon(
                                    "${store["id"]}",
                                    "${store["name"]} ${store["lastname"]}"),
                                transitionsBuilder: (c, anim, a2, child) =>
                                    FadeTransition(opacity: anim, child: child),
                                transitionDuration:
                                    Duration(milliseconds: 1000),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // image: DecorationImage(
                              //     image: NetworkImage(
                              //         "http://orody.com/project/public${store["image"]}"),
                              //     fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Container(
                color: Colors.white,
                width: width,
                height: 150,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    physics: ScrollPhysics(parent: ScrollPhysics()),
                    itemBuilder: (context, int index) {
                      Map category = categories[index];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          onTap: () {
                            pushNewScreen(
                              context,
                              screen: OneStoreCoupon("${category["id"]}",
                                  "${category["name"]} ${category["lastname"]}"),
                              withNavBar: false,
                              customPageRoute: PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => OneStoreCoupon(
                                    "${category["id"]}",
                                    "${category["name"]} ${category["lastname"]}"),
                                transitionsBuilder: (c, anim, a2, child) =>
                                    FadeTransition(opacity: anim, child: child),
                                transitionDuration:
                                    Duration(milliseconds: 1000),
                              ),
                            );
                          },
                          child: Container(
                            height: 130,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "http://orody.com/project/public${category["image"]}"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      tr("tabs2"),
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 1,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                itemCount: offers.length,
                shrinkWrap: true,
                physics: ScrollPhysics(parent: ScrollPhysics()),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  Map offer = offers[index];
                  return Padding(
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
                                image: DecorationImage(
                                    image: NetworkImage(
                                      "http://orody.com/project/public${offer["cover"]}",
                                    ),
                                    fit: BoxFit.cover)),
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
                                          "${offer["title"]}",
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
                                            if ("${offer["code"]}".length ==
                                                    0 ||
                                                "${offer["code"]}" == "null") {
                                              checkNetwork()
                                                  .then((value) async {
                                                if (value) {
                                                  await launch(
                                                      "${offer["link"]}");
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
                                                                text: offer[
                                                                    "code"],
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
                                                                      text: offer[
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
                                                        "${offer["id"]}", jwt)
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
