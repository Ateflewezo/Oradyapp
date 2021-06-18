import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:orody/API/SharedApi.dart';
import 'package:orody/API/insideApi.dart';
import 'package:orody/insidePages/stores/allStores.dart';
import 'package:orody/insidePages/stores/storeFlyer.dart';
import 'package:orody/sharedInternet.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Tabs/allCoupouns.dart';
import 'Tabs/allOffers.dart';
import 'home/storeFlyerFromHome.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List categories = [];
  List flyers = [];
  List categoryStores = [];
  String jwt;
  String currentSubTab = "";
  String lang;

  Future getUserJWT() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      jwt = prefs.getString("jwt");
      print(11111111);
      print(jwt);
      print(11111111);
      lang = prefs.getString("lang");
    });
  }

  List banners = [
    {
      "image":
          "https://images.pexels.com/photos/5956/gift-brown-shopping-market.jpg?auto=compress&cs=tinysrgb&dpr=1&w=500"
    },
    {
      "image":
          "https://images.pexels.com/photos/341523/pexels-photo-341523.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"
    },
    {
      "image":
          "https://images.pexels.com/photos/279906/pexels-photo-279906.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"
    },
  ];
  int _current = 1;
  int whichTap = 1;
  bool showSubMenu = false;

  buildListItems(ThemeData theme, double width, double height,
      int whichTapIndex, int imageNumber, String text, Widget page) {
    return InkWell(
      onTap: () {
        if (whichTapIndex > 1) {
          pushNewScreen(
            context,
            screen: page,
            withNavBar: false,
            customPageRoute: PageRouteBuilder(
              pageBuilder: (c, a1, a2) => page,
              transitionsBuilder: (c, anim, a2, child) =>
                  FadeTransition(opacity: anim, child: child),
              transitionDuration: Duration(milliseconds: 1000),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 4,
                      color: whichTapIndex == whichTap
                          ? theme.primaryColor
                          : Colors.white))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                whichTapIndex == whichTap
                    ? "assets/images/${imageNumber + 20}.png"
                    : "assets/images/$imageNumber.png",
                fit: BoxFit.scaleDown,
                height: 20,
                width: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 2),
                child: Text(
                  text,
                  style: TextStyle(
                      color: whichTapIndex == whichTap
                          ? theme.primaryColor
                          : Color.fromRGBO(112, 112, 112, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getAllCatStores(String catId) {
    checkNetwork().then((value) {
      if (value) {
        showLoadingIcon(context);
        getCategoryStores(lang, catId, jwt).then((response) {
          Navigator.of(context, rootNavigator: true).pop();
          if (response["status"] == true) {
            if (!mounted) return null;
            setState(() {
              categoryStores = response["data"];
              showSubMenu = true;
              currentSubTab = catId;
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
    getUserJWT().then((dsa) {
      checkNetwork().then((value) {
        if (value) {
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
          getAllFlyers(lang, jwt).then((response) {
            if (response["status"] == true) {
              if (!mounted) return null;
              setState(() {
                flyers = response["data"];
              });
            } else {
              showErrorDialog(context, tr("global1"));
            }
          });
        } else {
          return showErrorDialog(context, tr("global2"));
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
        automaticallyImplyLeading: false,
        title: Text(
          tr("home1"),
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: height,
        width: width,
        color: Colors.grey.shade100,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Stack(
                  children: <Widget>[
                    CarouselSlider(
                        items: banners.map((e) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                print(prefs.getString("jwt"));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          e["image"],
                                        ),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                            height: height / 4,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            })),
                    banners.length < 1
                        ? SizedBox()
                        : Positioned(
                            bottom: 10,
                            right: (width / 2) - 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: banners.map((url) {
                                int index = banners.indexOf(url);
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Container(
                                    width: _current == index ? 12.0 : 8,
                                    height: _current == index ? 12.0 : 8,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 2.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _current == index
                                          ? Colors.white
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  height: 60,
                  width: width,
                  color: Colors.white,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: ScrollPhysics(parent: ScrollPhysics()),
                    shrinkWrap: true,
                    children: <Widget>[
                      buildListItems(
                          theme, width, height, 1, 1, tr("home1"), null),
                      buildListItems(
                          theme, width, height, 3, 3, tr("home3"), AllOffers()),
                      buildListItems(theme, width, height, 2, 2, tr("home2"),
                          AllCoupouns()),
                      buildListItems(
                          theme, width, height, 4, 4, tr("home4"), AllStores())
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: showSubMenu ? 160 : 90,
                child: Stack(
                  children: <Widget>[
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOutSine,
                      right: 0,
                      left: 0,
                      top: showSubMenu ? 70 : 0,
                      child: ClipPath(
                        clipper: CustomClipPath(),
                        child: Container(
                          height: 90,
                          width: width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            child: ListView.builder(
                              itemCount: categoryStores.length,
                              shrinkWrap: true,
                              physics: ScrollPhysics(parent: ScrollPhysics()),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                Map store = categoryStores[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: InkWell(
                                    onTap: () {
                                      pushNewScreen(
                                        context,
                                        screen: StoreFlyers("${store["id"]}",
                                            "${store["name"]} ${store["lastname"]}"),
                                        withNavBar: false,
                                        customPageRoute: PageRouteBuilder(
                                          pageBuilder: (c, a1, a2) => StoreFlyers(
                                              "${store["id"]}",
                                              "${store["name"]} ${store["lastname"]}"),
                                          transitionsBuilder:
                                              (c, anim, a2, child) =>
                                                  FadeTransition(
                                                      opacity: anim,
                                                      child: child),
                                          transitionDuration:
                                              Duration(milliseconds: 1000),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "${store["name"]} ${store["lastname"]}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: 14),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: ClipPath(
                        clipper: CustomClipPath(),
                        child: Container(
                          height: 90,
                          width: width,
                          decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 20),
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              physics: ScrollPhysics(parent: ScrollPhysics()),
                              children: <Widget>[
                                Text(
                                  tr("home5"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 14),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: ListView.builder(
                                    itemCount: categories.length,
                                    shrinkWrap: true,
                                    physics:
                                        ScrollPhysics(parent: ScrollPhysics()),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Map cat = categories[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: InkWell(
                                            onTap: () {
                                              if (showSubMenu == false) {
                                                if (currentSubTab ==
                                                    "${cat["id"]}") {
                                                  setState(() {
                                                    showSubMenu = true;
                                                  });
                                                } else {
                                                  getAllCatStores(
                                                      "${cat["id"]}");
                                                }
                                              } else {
                                                if (currentSubTab ==
                                                    "${cat["id"]}") {
                                                  setState(() {
                                                    showSubMenu = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    showSubMenu = false;
                                                  });
                                                  getAllCatStores(
                                                      "${cat["id"]}");
                                                }
                                              }
                                            },
                                            child: Text(
                                              "${cat["title"]}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 14),
                                            )),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(bottom: 50, left: 20, right: 20, top: 0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: flyers.length,
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(parent: ScrollPhysics()),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.9,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      itemBuilder: (context, int index) {
                        Map flyer = flyers[index];
                        return InkWell(
                          onTap: () {
                            pushNewScreen(
                              context,
                              screen: StoreFlyersFromHome("${flyer["id"]}",
                                  "${flyer["name"]} ${flyer["lastname"]}"),
                              withNavBar: false,
                              customPageRoute: PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => StoreFlyersFromHome(
                                    "${flyer["id"]}",
                                    "${flyer["name"]} ${flyer["lastname"]}"),
                                transitionsBuilder: (c, anim, a2, child) =>
                                    FadeTransition(opacity: anim, child: child),
                                transitionDuration:
                                    Duration(milliseconds: 1000),
                              ),
                            );
                          },
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "http://orody.com/project/public${flyer["image"]}"),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: theme.primaryColor,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Text(
                                        "${flyer["name"]} ${flyer["lastname"]}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, 0);

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);

    path.quadraticBezierTo(
        size.width - 10, size.height - 20, size.width - 30, size.height - 20);
    path.lineTo(30, size.height - 20);
    path.quadraticBezierTo(10, size.height - 20, 0, size.height);

    // path.arcToPoint(
    //   Offset(size.width - 20, size.height - 20),
    //   clockwise: false,
    //   radius: Radius.circular(3),
    // );

    path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
