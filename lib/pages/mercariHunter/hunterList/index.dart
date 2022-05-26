import 'package:flutter/material.dart';
import 'package:goods_hunter/pages/mercariHunter/hunterList/hunterDogTag.dart';

class HunterList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HunterListState();
}

class _HunterListState extends State<HunterList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HunterDogTag(keyword: "123", lastUpdatedAt: "123", status: HunterStatus.hunting, schedule: "1234"),
        HunterDogTag(keyword: "123", lastUpdatedAt: "123", status: HunterStatus.hunting, schedule: "1234"),
        HunterDogTag(keyword: "123", lastUpdatedAt: "123", status: HunterStatus.hunting, schedule: "1234"),
        HunterDogTag(keyword: "123", lastUpdatedAt: "123", status: HunterStatus.hunting, schedule: "1234")
      ]
    );
  }
}