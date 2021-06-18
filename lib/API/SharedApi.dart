import 'dart:io';

import 'package:dio/dio.dart';

Dio dio = Dio();

String host = "http://orody.com/project/public/api";

Future checkNetwork() async {
  try {
    List connection = await InternetAddress.lookup("google.com");
    if (connection.isNotEmpty && connection[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (e) {
    return false;
  }
}
