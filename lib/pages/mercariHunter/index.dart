import 'package:flutter/material.dart';
import 'package:goods_hunter/api/index.dart';
import 'package:goods_hunter/pages/mercariHunter/hunterList/index.dart';
import "package:goods_hunter/models/index.dart" as models;

class MercariHunter extends StatefulWidget {

  const MercariHunter({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MercariHunterState();
}

class _MercariHunterState extends State<MercariHunter> {

  List<models.MercariHunter> mercariHunterList = [];

  initState() {
    getMercariHunterListApi().then((value) => setState(() {
      mercariHunterList = value;
    }));
  }
  Widget build(BuildContext context) {
    return HunterList(mercariHunterList: mercariHunterList);
  }

}