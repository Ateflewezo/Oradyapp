import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:orody/API/SharedApi.dart';
import 'package:orody/API/insideApi.dart';
import 'package:orody/insidePages/shopList/shopListItems.dart';
import 'package:orody/insidePages/stores/storeFlyer.dart';
import 'package:orody/sharedInternet.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllStoresByCategory extends StatefulWidget {
  final String categoryId;

  const AllStoresByCategory(this.categoryId);
  @override
  _AllStoresByCategoryState createState() => _AllStoresByCategoryState();
}

class _AllStoresByCategoryState extends State<AllStoresByCategory> {
  String jwt;
  String lang;
  List allStoresByCategory = [];

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
          getCategoryStores(lang, widget.categoryId, jwt).then((response) {
            if (response["status"] == true) {
              if (!mounted) return null;
              setState(() {
                allStoresByCategory = response["data"];
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
          tr("stores1"),
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: height,
        width: width,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(parent: ScrollPhysics()),
              itemCount: allStoresByCategory.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5),
              itemBuilder: (BuildContext context, index) {
                Map store = allStoresByCategory[index];
                return InkWell(
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
                        transitionsBuilder: (c, anim, a2, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration: Duration(milliseconds: 1000),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                                "http://orody.com/project/public${store['image']}"))),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
