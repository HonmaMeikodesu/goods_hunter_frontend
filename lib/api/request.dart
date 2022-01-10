import 'dart:io';

import "package:dio/dio.dart";
import "package:cookie_jar/cookie_jar.dart";
import "package:dio_cookie_manager/dio_cookie_manager.dart";
import 'package:path_provider/path_provider.dart';

class Request {
  static late final Dio _dio;
  static Future<void> init() async {
    BaseOptions baseOptions = BaseOptions(
      baseUrl: "http://127.0.0.1",
      connectTimeout: 5000,
      receiveTimeout: 10000,
      sendTimeout: 5000,
    );
    _dio = Dio(baseOptions);
    Directory dir = await getTemporaryDirectory();
    var path = dir.path;
    var cookieJar=PersistCookieJar(storage: FileStorage(path));
    _dio.interceptors.add(CookieManager(cookieJar));
  }
  Future<void> initPromise = init();
  Future<Dio> getInstance() {
    return initPromise.then((value) => _dio);
  }
}