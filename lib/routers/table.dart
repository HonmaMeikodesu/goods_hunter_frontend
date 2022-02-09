import 'package:flutter/material.dart';
import 'package:goods_hunter/routers/authentication.dart';
import 'package:goods_hunter/routers/home.dart';
import 'package:goods_hunter/routers/my.dart';

Map<String, Widget> routeTable = {
  "/": const HomePage(title: 'HonmaMeiko\'s Goods Hunter'),
  "authentication": const AuthenticationRoute(),
  "my": const MyPage(),
};

List<String> authRouteList = ["my"];