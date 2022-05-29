import 'package:flutter/material.dart';
import 'package:goods_hunter/models/index.dart';
import 'package:goods_hunter/pages/mercariHunter/hunterList/hunterDogTag.dart';

class HunterList extends StatefulWidget {

  HunterList({Key? key, required this.mercariHunterList}): super(key: key);

  late List<MercariHunter> mercariHunterList = [];

  @override
  State<StatefulWidget> createState() => _HunterListState();
}

class _HunterListState extends State<HunterList> {
  @override
  Widget build(BuildContext context) {
    List<Widget> listItems = widget.mercariHunterList.map((hunter) => Container(
      margin: EdgeInsets.only(bottom: 16),
      child: HunterDogTag(keyword: hunter.url, lastUpdatedAt: hunter.lastShotAt, status: HunterStatus.hunting, schedule: hunter.schedule),
    )).toList();
    return ListView(
      padding: EdgeInsets.all(16),
      children: listItems
    );
  }
}