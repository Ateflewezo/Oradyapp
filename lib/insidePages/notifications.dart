import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'funkyPopUp.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int selectedNotification;

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
          tr("notifications1"),
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      tr("notifications2"),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      tr("notifications3"),
                      style: TextStyle(
                          color: theme.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(parent: ScrollPhysics()),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedNotification = index;

                        showDialog(
                          context: context,
                          builder: (_) => FunkyOverlay([
                            "https://images.pexels.com/photos/421129/pexels-photo-421129.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"
                          ]),
                        );
                      });
                    },
                    child: Container(
                      height: 100,
                      width: width,
                      color: selectedNotification == index
                          ? theme.accentColor
                          : Colors.white,
                      child: ListTile(
                        leading: Container(
                          width: 60,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.accentColor,
                              image: DecorationImage(
                                  image: NetworkImage(
                                    "https://images.pexels.com/photos/2602451/pexels-photo-2602451.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                                  ),
                                  fit: BoxFit.cover)),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "هايبر بندة",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            ),
                            Container(
                              child: Text(
                                "منذ ساعتين",
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          "خصم 20% على الشراء لأول مرة من هايبر",
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
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
