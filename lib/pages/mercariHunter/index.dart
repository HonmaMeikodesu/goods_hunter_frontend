import 'package:flutter/cupertino.dart';
import 'package:goods_hunter/pages/mercariHunter/hunterList/index.dart';

class MercariHunter extends StatefulWidget {

  MercariHunter({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MercariHunterState();
}

class _MercariHunterState extends State<MercariHunter> {
  @override
  Widget build(BuildContext context) {
    return HunterList();
  }

}