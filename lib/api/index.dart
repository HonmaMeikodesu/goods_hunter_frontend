import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:goods_hunter/models/index.dart';
import 'package:goods_hunter/utils/popup.dart';

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

Future<void> deleteMercariHunterApi({required BuildContext context, required String hunterId}) {

  return Request.fetch("/goods/unregisterGoodsWatcher", options: Options(method: "GET"), queryParameters: { "id": hunterId }, context: context).then((value) {
    showToast(context: context, content: "删除成功", type: toastType.success, closeAfter: 2);
  });
}

class MercariHunterInfoToUpload {
  final String? id;
  final String url;
  final String schedule;
  final String? freezeStart;
  final String? freezeEnd;
  MercariHunterInfoToUpload.from({required this.url, required this.schedule, this.freezeEnd, this.freezeStart, this.id});
}

Future<void> registerMercariHunterWatcherInfo({required BuildContext context, required MercariHunterInfoToUpload hunterInfoToRegister}) {
  return Request.fetch("/goods/registerGoodsWatcher",
      options: Options(method: "POST"),
      data: {
        "url": hunterInfoToRegister.url,
        "schedule": hunterInfoToRegister.schedule,
        "freezeStart": hunterInfoToRegister.freezeStart,
        "freezeEnd": hunterInfoToRegister.freezeEnd,
      }, context: context).then((value) {
    showToast(context: context, content: "新增成功", type: toastType.success, closeAfter: 2);
  });
}

Future<void> updateMercariHunterWatcherInfo({required BuildContext context, required MercariHunterInfoToUpload hunterInfoToRegister}) {
  return Request.fetch("/goods/updateGoodsWatcher",
      options: Options(method: "POST"),
      data: {
        "id": hunterInfoToRegister.id,
        "url": hunterInfoToRegister.url,
        "schedule": hunterInfoToRegister.schedule,
        "freezeStart": hunterInfoToRegister.freezeStart,
        "freezeEnd": hunterInfoToRegister.freezeEnd,
      }, context: context).then((value) {
    showToast(context: context, content: "更新成功", type: toastType.success, closeAfter: 2);
  });
}