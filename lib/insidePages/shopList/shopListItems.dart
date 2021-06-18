import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:orody/API/SharedApi.dart';
import 'package:orody/API/insideApi.dart';
import 'package:orody/sharedInternet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopListItems extends StatefulWidget {
  final String shopId;

  const ShopListItems(this.shopId);
  @override
  _ShopListItemsState createState() => _ShopListItemsState();
}

class _ShopListItemsState extends State<ShopListItems> {
  String jwt;
  String lang;
  List shopListItems = [];

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
          getshopListItems(lang, jwt, widget.shopId).then((response) {
            if (response["status"] == true) {
              if (!mounted) return null;
              setState(() {
                shopListItems = response["data"];
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
          tr("shopList1"),
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: height,
        width: width,
        color: Colors.grey.shade200,
        child: ListView.builder(
          itemCount: shopListItems.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: ScrollPhysics(parent: ScrollPhysics()),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(
                    "${shopListItems[index]["title"]}",
                    style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: theme.primaryColor,
                    size: 25,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
