import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:orody/insidePages/Tabs/allCoupouns.dart';
import 'package:orody/insidePages/Tabs/allOffers.dart';
import 'package:orody/insidePages/shopList/shopList.dart';
import 'package:orody/insidePages/stores/allStores.dart';
import 'Tabs/contactUs.dart';
import 'Tabs/aboutOrody.dart';
import 'Tabs/loyalityCards.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:orody/insidePages/notifications.dart';
import 'package:orody/insidePages/offers.dart';
import 'package:orody/insidePages/settings.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../sharedInternet.dart';
import 'account.dart';
import 'home.dart';

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  bool drawerOpen = false;
  bool drawerFullWidth = false;
  bool drawerFullWidthAnimationDone = false;
  GlobalKey _bottomNavigationKey = GlobalKey();
  PersistentTabController _controller;

  int whichTap = 0;

  buildListItems(ThemeData theme, double width, double height,
      int whichTapIndex, int imageNumber, String text, Widget page) {
    return InkWell(
      onTap: () {
        if (whichTapIndex == 10) {
          logOut(context);
        } else if (whichTapIndex > 0 && whichTapIndex < 8) {
          setState(() {
            drawerFullWidth = false;
            drawerOpen = false;
          });
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
        // : setState(() {
        //     // whichTap = whichTapIndex;

        //   });
      },
      child: Container(
        width: width,
        color: whichTap == whichTapIndex ? theme.accentColor : Colors.white,
        child: Padding(
          padding: EdgeInsets.only(right: 15, left: 15, bottom: 5, top: 5),
          child: Container(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  whichTapIndex == whichTap
                      ? "assets/images/${imageNumber + 20}.png"
                      : "assets/images/$imageNumber.png",
                  fit: BoxFit.scaleDown,
                  height: 25,
                  width: 25,
                ),
                drawerFullWidth && drawerFullWidthAnimationDone
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 2),
                        child: Text(
                          text,
                          style: TextStyle(
                              color: whichTapIndex == whichTap
                                  ? theme.primaryColor
                                  : Color.fromRGBO(112, 112, 112, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 2);
  }

  List<Widget> _buildScreens() {
    return [
      Account(),
      Notifications(),
      Home(),
      Offers(),
      Settings(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(ThemeData theme) {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.person,
        ),
        title: ("d"),
        titleFontSize: 1,
        activeColor: theme.primaryColor,
        inactiveColor: theme.primaryColor.withOpacity(0.8),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.notifications,
        ),
        title: ("d"),
        titleFontSize: 1,
        activeColor: theme.primaryColor,
        inactiveColor: theme.primaryColor.withOpacity(0.8),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          FontAwesomeIcons.home,
        ),
        title: ("d"),
        titleFontSize: 1,
        activeColor: theme.primaryColor,
        inactiveColor: theme.primaryColor.withOpacity(0.8),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.bookmark,
        ),
        title: ("d"),
        titleFontSize: 1,
        activeColor: theme.primaryColor,
        inactiveColor: theme.primaryColor.withOpacity(0.8),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.settings,
        ),
        title: ("d"),
        titleFontSize: 1,
        activeColor: theme.primaryColor,
        inactiveColor: theme.primaryColor.withOpacity(0.8),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: <Widget>[
        PersistentTabView(
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(theme),
          confineInSafeArea: true,
          backgroundColor: Colors.white,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset:
              true, // This needs to be true if you want to move up the screen when keyboard appears.
          stateManagement: true,
          hideNavigationBarWhenKeyboardShows:
              true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: Colors.white,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          itemAnimationProperties: ItemAnimationProperties(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 600),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimation(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 600),
          ),
          navBarStyle: NavBarStyle
              .style3, // Choose the nav bar style with this property.
        ),

        //  tab to open drawer
        Positioned(
            right: context.locale.toString() == "ar" ? 13 : null,
            left: context.locale.toString() == "ar" ? null : 13,
            top: 42,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    drawerOpen = true;
                  });
                },
                child: Icon(
                  Icons.menu,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            )),
        !drawerOpen
            ? SizedBox()
            : Positioned(
                right: 0,
                left: 0,
                top: 85,
                bottom: 0,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        drawerFullWidth = false;
                        drawerOpen = false;
                      });
                    },
                    child: Container(
                      height: height,
                      width: width,
                      color: Colors.black12,
                    ),
                  ),
                )),
        AnimatedPositioned(
            duration: Duration(milliseconds: 350),
            curve: Curves.easeInOutSine,
            right: context.locale.toString() == "ar"
                ? !drawerOpen ? -(width / 6) : null
                : null,
            left: context.locale.toString() == "ar"
                ? null
                : !drawerOpen ? -(width / 6) : null,
            top: 85,
            bottom: 0,
            child: Material(
              color: Colors.transparent,
              child: AnimatedContainer(
                onEnd: () {
                  setState(() {
                    if (drawerFullWidth) {
                      drawerFullWidthAnimationDone = true;
                    } else {
                      drawerFullWidthAnimationDone = false;
                    }
                  });
                },
                duration: Duration(milliseconds: 350),
                height: height,
                width: drawerFullWidth ? width / 2 : width / 6,
                color: Colors.white,
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            drawerFullWidth = !drawerFullWidth;
                          });
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            drawerFullWidth
                                ? Icons.arrow_back_ios
                                : Icons.arrow_forward_ios,
                            size: 22,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    buildListItems(
                        theme, width, height, 0, 1, tr("tabs1"), null),
                    buildListItems(
                        theme, width, height, 2, 3, tr("tabs3"), AllOffers()),
                    buildListItems(
                        theme, width, height, 1, 2, tr("tabs2"), AllCoupouns()),
                    buildListItems(
                        theme, width, height, 3, 4, tr("tabs4"), AllStores()),
                    buildListItems(
                        theme, width, height, 4, 5, tr("tabs5"), ShopList()),
                    buildListItems(theme, width, height, 5, 6, tr("tabs6"),
                        LoyalityCard()),
                    buildListItems(
                        theme, width, height, 6, 7, tr("tabs7"), AboutOrody()),
                    buildListItems(
                        theme, width, height, 7, 9, tr("tabs8"), ContactUs()),
                    buildListItems(
                        theme, width, height, 8, 8, tr("tabs9"), null),
                    buildListItems(
                        theme, width, height, 9, 10, tr("tabs10"), null),
                    buildListItems(
                        theme, width, height, 10, 11, tr("tabs11"), null),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
