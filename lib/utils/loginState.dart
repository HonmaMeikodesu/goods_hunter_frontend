import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import '../private.dart';

Future<bool> checkLoginStateExist() async {
  Directory dir = await getTemporaryDirectory();
  var path = dir.path;
  var cookieJar=PersistCookieJar(storage: FileStorage(path));
  return cookieJar.loadForRequest(Uri(host: serverIp)).then((value) {
    var loginState = value.where((cookie) => cookie.name == "loginState").first;
    return loginState is Cookie;
  });
}