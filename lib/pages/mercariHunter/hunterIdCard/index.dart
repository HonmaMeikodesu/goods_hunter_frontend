import 'package:flutter/material.dart';
import 'package:goods_hunter/pages/mercariHunter/hunterIdCard/ghost.dart';
import '../../../models/index.dart' as model;

class HunterIdCard extends StatefulWidget {

  final model.MercariHunter hunterInfo;

  final RelativeRect? transitionRect;
  final Animation<double>? transitionAnimation;

  HunterIdCard({Key? key, required this.hunterInfo, this.transitionAnimation, this.transitionRect }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HunterIdCardState();
}

class _HunterIdCardState extends State<HunterIdCard>
    with TickerProviderStateMixin {
  late final AnimationController editKeywordAnimation;
  late bool pendingForTransition;
  
  String keywordInputStatus = "read";

  @override
  initState() {
    super.initState();
    editKeywordAnimation = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    pendingForTransition = widget.transitionAnimation is Animation<double> && widget.transitionRect is RelativeRect;
  }

  @override
  dispose() {
    super.dispose();
    editKeywordAnimation.dispose();
  }

  buildTransition() {
    String keyword = Uri.parse(widget.hunterInfo.url).queryParameters["keyword"] ?? "";
    widget.transitionAnimation!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          pendingForTransition = false;
        });
      }
    });
    return HunterIdCardGhost(rect: widget.transitionRect!, title: keyword, animation: widget.transitionAnimation!);
  }

  buildPage() {
    String keyword = Uri.parse(widget.hunterInfo.url).queryParameters["keyword"] ?? "";
    return SafeArea(
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color.fromRGBO(191, 192, 194, 0.3),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Flex(
                    direction: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(keyword,
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            if (keywordInputStatus == "read") {
                              setState(() {
                                keywordInputStatus = "write";
                                editKeywordAnimation.forward();
                              });
                            } else {
                              setState(() {
                                keywordInputStatus = "read";
                                editKeywordAnimation.reverse();
                              });
                            }
                          },
                          child: Container(
                              padding: EdgeInsets.only(left: 16),
                              child: AnimatedBuilder(
                                animation: editKeywordAnimation,
                                builder: (context, child) {
                                  if (editKeywordAnimation.value < 0.5) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.orangeAccent,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      padding: EdgeInsets.all(4),
                                      child: Icon(Icons.edit_rounded, color: Colors.white,),
                                    );
                                  } else {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      padding: EdgeInsets.all(4),
                                      child: Icon(Icons.check, color: Colors.white,),
                                    );
                                  }
                                },
                              )
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (pendingForTransition) {
      return buildTransition();
    } else {
      return buildPage();
    }
  }
}