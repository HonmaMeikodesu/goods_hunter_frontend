import 'package:flutter/material.dart';
import 'dart:math' as math;

class HunterIdCardGhost extends StatelessWidget {

  final RelativeRect rect;

  final String title;

  final Animation<double> animation;

  const HunterIdCardGhost({Key? key, required this.rect, required this.title, required this.animation }): super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    EdgeInsets padding = data.padding;
    double left = math.max(padding.left, 0);
    double top =  math.max(padding.top, 0);
    double right = math.max(padding.right, 0);
    double bottom = math.max(padding.bottom, 0);
    RelativeRect convertedRect = RelativeRect.fromLTRB(rect.left - left, rect.top - top, rect.right - right, rect.bottom - bottom);
    return SafeArea(
        child: DefaultTextStyle(
          style: TextStyle(),
          child:Stack(
            children: [
              PositionedTransition(
                  rect: RelativeRectTween(begin: convertedRect, end: RelativeRect.fill).animate(animation),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    padding: EdgeInsets.only(left: 24, top: 16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 120,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                      ) ,
                    ),
                  )
              )
            ],
          ) ,
        ));
  }
}
