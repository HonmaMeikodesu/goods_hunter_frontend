import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:goods_hunter/models/index.dart';

import "./request.dart";

Future<void> loginApi({required String email, required String password, BuildContext? context}) {
  return Request.fetch<void>("/login", data: {
    "email": email,
    "password": password,
  }, options: Options(
    method: "POST",
    contentType: Headers.formUrlEncodedContentType,
  ), context: context);
}

Future<void> registerApi({required String email, required String password, BuildContext? context}) {
  return Request.fetch<void>("/register", data: {
    "email": email,
    "password": password,
  }, options: Options(
    method: "POST",
    contentType: Headers.formUrlEncodedContentType,
  ), context: context);
}

Future<List<MercariHunter>> getMercariHunterListApi({BuildContext? context}) {
  return Request.fetch("/goods/listGoodsWatcher", options: Options(method: "GET"), queryParameters: { "type": "Mercari" }, context: context).then((value) {
    var iterableList = (value["data"] as List<dynamic>).map((val) => MercariHunter.fromJson(val));
    return iterableList.toList();
  });
}