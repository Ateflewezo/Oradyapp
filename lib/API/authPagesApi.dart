import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'SharedApi.dart';

Future getAllCountries(String lang_id) async {
  var data;
  bool status;
  await dio
      .get("${host}/countries",
          queryParameters: {"lang_id": lang_id},
          options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            },
          ))
      .then((response) {
    print(response.data);
    data = response.data["data"];
    status = response.data["status"];
  });
  return [status, data];
}

Future getAllCountryCities(String lang_id, String countryId) async {
  var data;
  bool status;
  await dio
      .get("${host}/countries/$countryId/cities",
          queryParameters: {"lang_id": lang_id},
          options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            },
          ))
      .then((response) {
    data = response.data["data"];
    status = response.data["status"];
  });
  return [status, data];
}

Future register(String name, String email, String password, String birth_date,
    String country_id, String city_id) async {
  var data;

  await dio
      .post("${host}/register",
          data: {
            "name": name,
            "email": email,
            "password": password,
            "birth_date": birth_date,
            "country_id": country_id,
            "city_id": city_id,
          },
          options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            },
          ))
      .then((response) {
    data = response.data;
  });
  return data;
}

Future sendMePasswordAgain(String email) async {
  var data;

  await dio
      .post("${host}/password/reset",
          data: {
            "email": email,
          },
          options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            },
          ))
      .then((response) {
    data = response.data;
  });
  return data;
}

Future login(String username, String password) async {
  var data;

  await dio
      .post("${host}/login",
          data: {
            "username": username,
            "password": password,
          },
          options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            },
          ))
      .then((response) {
    data = response.data;
  });
  return data;
}

Future updateAccountFields(String field, String jwt, var value) async {
  String fileName = value is File ? value.path.split('/').last : value;
  FormData formData = FormData.fromMap({
    field: value is File
        ? await MultipartFile.fromFile(value.path, filename: fileName)
        : value,
  });
  var data;

  await dio
      .post("${host}/update_profile",
          data: formData,
          options: Options(
            headers: {"Authorization": "Bearer $jwt"},
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            },
          ))
      .then((response) {
    data = response.data;
  });
  return data;
}

// Future sendRoomMessageImage(File body, String type, String user_id,
//     String company_id, String jwt, String recieverType) async {
//   var response;
//   int statuscode;
//   String recviver = recieverType == "driver_id" ? "driver" : "company";
//   String link = "${host}/chat/user/$recviver/store";

//   String fileName = body.path.split('/').last;
//   FormData formData = FormData.fromMap({
//     "user_id": user_id,
//     recieverType: company_id,
//     "type": type,
//     "body": await MultipartFile.fromFile(body.path, filename: fileName),
//   });
//   await dio
//       .post(link,
//           data: formData,
//           options: Options(
//               followRedirects: false,
//               validateStatus: (status) {
//                 return status < 500;
//               },
//               headers: {"jwt": jwt}))
//       .then((data) {
//     response = data.data;
//     statuscode = data.statusCode;
//   });
//   return [response, statuscode];
// }
