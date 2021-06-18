import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'SharedApi.dart';

Future getAllOffers(String lang_id, String jwt) async {
  var data;
  bool status;

  await dio
      .get("${host}/offers",
          queryParameters: {
            "lang_id": lang_id,
          },
          options: Options(
            headers: {"Authorization": "Bearer $jwt"},
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

Future contactUs(
    String name, String email, String phone, String message) async {
  var data;

  await dio
      .post("${host}/contacts",
          data: {
            "name": name,
            "email": email,
            "phone": phone,
            "message": message,
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

Future getLoyalityCards(String jwt) async {
  var data;

  await dio
      .get("${host}/loyalty_cards/get",
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

Future addNewCard(String card_name, String person_name, String card_num,
    File front_image, File back_image, String jwt) async {
  String fileName = front_image.path.split('/').last;
  String fileName1 = back_image.path.split('/').last;

  FormData formData = FormData.fromMap({
    "front_image":
        await MultipartFile.fromFile(front_image.path, filename: fileName),
    "back_image":
        await MultipartFile.fromFile(back_image.path, filename: fileName),
    "card_num": card_num,
    "person_name": person_name,
    "card_name": card_name,
  });
  var data;

  await dio
      .post("${host}/loyalty_cards/store",
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

Future getAllShopLists(String lang_id, String jwt) async {
  var data;

  await dio
      .get("${host}/shopping_list_categories",
          queryParameters: {
            "lang_id": lang_id,
          },
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

Future getAllFlyers(String lang_id, String jwt) async {
  var data;

  await dio
      .get("${host}/stores",
          queryParameters: {
            "lang_id": lang_id,
          },
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

Future getshopListItems(String lang_id, String jwt, String shopId) async {
  var data;

  await dio
      .get("${host}/shopping_list_categories/$shopId/items",
          queryParameters: {
            "lang_id": lang_id,
          },
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

Future getAllStores(String lang_id, String jwt) async {
  var data;

  await dio
      .get("${host}/stores",
          queryParameters: {
            "lang_id": lang_id,
          },
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

Future getAllCategories(String lang_id, String jwt) async {
  var data;

  await dio
      .get("${host}/categories",
          queryParameters: {
            "lang_id": lang_id,
          },
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

Future getCategoryStores(String lang_id, String category_id, String jwt) async {
  var data;

  await dio
      .get("${host}/stores_by_category",
          queryParameters: {
            "lang_id": lang_id,
            "category_id": category_id,
          },
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

Future getAllStoreFlyer(String lang_id, String jwt, String storeId) async {
  var data;

  await dio
      .get("${host}/stores/$storeId/flyers",
          queryParameters: {
            "lang_id": lang_id,
          },
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

Future getAllStoreDiscounts(String lang_id, String jwt, String storeId) async {
  var data;

  await dio
      .get("${host}/stores/$storeId/discounts",
          queryParameters: {
            "lang_id": lang_id,
          },
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

Future getOneStoreFlyerImages(
    String lang_id, String jwt, String flyerId) async {
  var data;

  await dio
      .get("${host}/flyers/$flyerId",
          queryParameters: {
            "lang_id": lang_id,
          },
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

Future getAllCopouns(String lang_id, String jwt) async {
  var data;
  bool status;

  await dio
      .get("${host}/discounts",
          queryParameters: {
            "lang_id": lang_id,
          },
          options: Options(
            headers: {"Authorization": "Bearer $jwt"},
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

Future getAllFavs(String lang_id, String jwt) async {
  var data;
  bool status;

  await dio
      .get("${host}/favourites",
          queryParameters: {
            "lang_id": lang_id,
          },
          options: Options(
            headers: {"Authorization": "Bearer $jwt"},
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

Future addFlyersToFavourite(String flyer_id, String jwt) async {
  var data;

  await dio
      .post("${host}/add_flyers_to_favourite",
          data: {"flyer_id": flyer_id},
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

Future addCouponToFavourite(String discount_id, String jwt) async {
  var data;

  await dio
      .post("${host}/add_disounts_to_favourite",
          data: {"discount_id": discount_id},
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

Future addOfferToFavourite(String offer_id, String jwt) async {
  var data;

  await dio
      .post("${host}/add_offers_to_favourite",
          data: {"offer_id": offer_id},
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

Future settingsData() async {
  var data;

  await dio
      .get("${host}/settings",
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
