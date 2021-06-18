import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orody/API/SharedApi.dart';
import 'package:orody/API/insideApi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../sharedInternet.dart';
import '../funkyPopUp.dart';

class OneStoreCoupon extends StatefulWidget {
  final String storeId;
  final String storeTitle;

  const OneStoreCoupon(this.storeId, this.storeTitle);
  @override
  _OneStoreCouponState createState() => _OneStoreCouponState();
}

class _OneStoreCouponState extends State<OneStoreCoupon> {
  String jwt;
  String lang;
  bool weekly = true;

  List allStoreDiscounts = [];

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      jwt = prefs.getString("jwt");
      lang = prefs.getString("lang");
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData().then((dsa) {
      checkNetwork().then((value) {
        if (value) {
          getAllStoreDiscounts(lang, jwt, widget.storeId).then((response) {
            print(widget.storeId);
            if (response["status"] == true) {
              if (!mounted) return null;
              setState(() {
                allStoreDiscounts = response["data"];
              });
            } else {
              showErrorDialog(context, tr("global1"));
            }
          });
        } else {
          showErrorDialog(context, tr("global2"));
        }
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
          widget.storeTitle,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: height,
        width: width,
        color: Colors.grey.shade100,
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              ListView.builder(
                itemCount: allStoreDiscounts.length,
                shrinkWrap: true,
                physics: ScrollPhysics(parent: ScrollPhysics()),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  Map copoun = allStoreDiscounts[index];
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
                                      "http://orody.com/project/public${copoun["cover"]}",
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
                                          "${copoun["title"]}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      // Container(
                                      //   decoration: BoxDecoration(
                                      //       color: Colors.red,
                                      //       borderRadius: BorderRadius.circular(5)),
                                      //   child: Padding(
                                      //     padding: EdgeInsets.all(5),
                                      //     child: Text(
                                      //       "جديد",
                                      //       style: TextStyle(
                                      //           color: Colors.white,
                                      //           fontSize: 11,
                                      //           fontWeight: FontWeight.bold),
                                      //     ),
                                      //   ),
                                      // ),
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
                                        child: RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                              text:
                                                  " ${copoun["price_after"]} ",
                                              style: TextStyle(
                                                  fontFamily: "cairo",
                                                  fontSize: 18,
                                                  color: Colors.red)),
                                          TextSpan(
                                              text:
                                                  " ${copoun["price_before"]} ",
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
                                            checkNetwork().then((value) async {
                                              if (value) {
                                                showLoadingIcon(context);
                                                addCouponToFavourite(
                                                        "${copoun["id"]}", jwt)
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
