import 'package:flutter/material.dart';
import 'package:goods_hunter/models/index.dart' as models;

import 'hunterDogTag.dart';

class HunterListItem extends StatefulWidget {
  final models.MercariHunter hunter;

  final void Function(String hunterId) onDeleteHunter;


  const HunterListItem({Key? key, required this.hunter, required this.onDeleteHunter }): super(key: key);

  @override
  State<StatefulWidget> createState() => _HunterListItemState();
}

class _HunterListItemState extends State<HunterListItem> {

  double localDragStartPos = 0;
  double dragDelta = 0;
  bool isExpand = false;
  double positionOffset = 0;

  @override
  Widget build(BuildContext context) {
    models.MercariHunter hunter = widget.hunter;

    return (
        GestureDetector(
            onHorizontalDragStart: (DragStartDetails details) {
              setState(() {
                localDragStartPos = details.localPosition.dx;
                dragDelta = 0;
              });
            },
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              double delta = details.localPosition.dx - localDragStartPos;
              setState(() {
                if (isExpand) {
                  if (delta < 0) {
                    dragDelta = 0;
                  } else if (delta > 96) {
                    dragDelta = 96;
                  } else {
                    dragDelta = delta;
                  }
                } else {
                  if (delta < -96) {
                    dragDelta = -96;
                  } else if (delta > 0) {
                    dragDelta = 0;
                  } else {
                    dragDelta = delta;
                  }
                }
              });
            },
            onHorizontalDragEnd: (DragEndDetails _details) {
              setState(() {
                if (isExpand && dragDelta == 96) {
                  isExpand = false;
                  positionOffset = 0;
                } else if (!isExpand && dragDelta == -96) {
                  isExpand = true;
                  positionOffset = 96;
                }
                dragDelta = 0;
              });
            },
            child: Container(
                height: 100,
                margin: EdgeInsets.only(bottom: 16),
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      child: Container(
                        width: 96,
                        height: 100,
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            IconButton(
                              color: Color.fromRGBO(132, 132, 132, 1),
                                onPressed: () {},
                                icon: Icon(Icons.stop_circle_outlined)
                            ),
                            IconButton(
                                color: Colors.redAccent,
                                onPressed: () {
                                  widget.onDeleteHunter(hunter.hunterInstanceId);
                                },
                                icon: Icon(Icons.delete_forever)
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        left:  dragDelta - positionOffset,
                        right: -dragDelta + positionOffset,
                        child: HunterDogTag(keyword: hunter.url, lastUpdatedAt: hunter.lastShotAt, status: HunterStatus.hunting, schedule: hunter.schedule),
                    )
                  ],
                )
            )));
  }
}