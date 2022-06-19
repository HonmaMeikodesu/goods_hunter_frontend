import 'package:flutter/material.dart';
import 'package:goods_hunter/models/index.dart';
import 'package:goods_hunter/pages/mercariHunter/hunterList/hunterListItem.dart';

class HunterList extends StatefulWidget {

  HunterList({Key? key, required this.mercariHunterList, required this.onDeleteHunter }): super(key: key);

  late List<MercariHunter> mercariHunterList = [];

  final void Function(String hunterId) onDeleteHunter;

  @override
  State<StatefulWidget> createState() => _HunterListState();
}

class _HunterListState extends State<HunterList> {
  @override
  Widget build(BuildContext context) {
    List<Widget> listItems = widget.mercariHunterList.map((hunter) => HunterListItem(key: Key(hunter.hunterInstanceId!), hunter: hunter ,onDeleteHunter: widget.onDeleteHunter)).toList();
    return ListView.builder(
      itemCount: listItems.length,
      itemBuilder: (BuildContext context, int index) {
        if (index < listItems.length) {
          return listItems[index];
        } else {
          return Container(
              alignment: Alignment.center,
              height: 100,
              padding: EdgeInsets.all(16.0),
              child: Text(
              "我是有底线的",
              style: TextStyle(color: Colors.grey),
              )
          );
        }
      },
      itemExtent: 116,
      padding: EdgeInsets.all(16),
    );
  }
}