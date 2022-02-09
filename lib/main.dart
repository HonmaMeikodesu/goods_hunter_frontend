import 'package:flutter/material.dart';
import 'package:goods_hunter/routers/table.dart';
import 'package:goods_hunter/utils/loginState.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HonmaMeiko\'s Goods Hunter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (settings) {
        var routeName = settings.name;
        var routeWidget = routeTable[routeName] ?? routeTable["/"]!;
        var routeWidgetWrapper = routeWidget;
        if (authRouteList.where((element) => element == routeName).isNotEmpty) {
          routeWidgetWrapper = FutureBuilder<bool>(
            future: checkLoginStateExist(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != true) {
                return routeTable["authentication"]!;
              } else {
                return routeWidget;
              }
            }
          );
        }
        return MaterialPageRoute(builder: (context) {
          return routeWidgetWrapper;
        });
      },
    );
  }
}