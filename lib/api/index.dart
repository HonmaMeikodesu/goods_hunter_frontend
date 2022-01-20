import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

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