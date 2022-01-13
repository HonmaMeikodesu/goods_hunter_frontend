import 'dart:io';

import "package:dio/dio.dart";
import "package:cookie_jar/cookie_jar.dart";
import "package:dio_cookie_manager/dio_cookie_manager.dart";
import 'package:path_provider/path_provider.dart';
import "../models/index.dart" as Model;

class HonmaMeikoInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Model.Response resp = Model.Response.fromJson(response.data);
    if (resp.code != "200") {
      return handler.reject(DioError(requestOptions: response.requestOptions, error: resp.data));
    }
    return handler.resolve(response);
  }
}

class Request {
  static late final Dio _dio;
  static Future<void> init() async {
    BaseOptions baseOptions = BaseOptions(
      baseUrl: "http://127.0.0.1:7001",
      connectTimeout: 5000,
      receiveTimeout: 10000,
      sendTimeout: 5000,
    );
    _dio = Dio(baseOptions);
    Directory dir = await getTemporaryDirectory();
    var path = dir.path;
    var cookieJar=PersistCookieJar(storage: FileStorage(path));
    _dio.interceptors..add(HonmaMeikoInterceptor())..add(CookieManager(cookieJar));
  }
  static Future<void> initPromise = init();
  static Future<Dio> getInstance() {
    return initPromise.then((value) => _dio);
  }
  static Future<T> fetch<T>(String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    var requestInstance = await Request.getInstance();
    var rawResponse = await requestInstance.request<T>(path, data: data, options: options, queryParameters: queryParameters);
    return rawResponse.data!;
  }
}