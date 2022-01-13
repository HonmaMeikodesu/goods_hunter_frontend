import 'package:dio/dio.dart';

import "./request.dart";

Future<void> loginApi({required String email, required String password}) {
  return Request.fetch<void>("/login", data: {
    email,
    password,
  }, options: Options(
    method: "POST",
    contentType: Headers.formUrlEncodedContentType,
  ));
}

Future<void> registerApi({required String email, required String password}) {
  return Request.fetch<void>("/register", data: {
    email,
    password,
  }, options: Options(
    method: "POST",
    contentType: Headers.formUrlEncodedContentType,
  ));
}