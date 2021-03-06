import 'package:flutter/material.dart';
import 'package:goods_hunter/pages/mercariHunter/hunterIdCard/index.dart';
import 'dart:math' as math;

import 'package:goods_hunter/pages/mercariHunter/index.dart';

import '../models/index.dart' as model;

class HunterPubRoute extends StatefulWidget {
  const HunterPubRoute({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HunterPubRouteState();
}

Map<String, String> hunterRoundTables = {
  "mercari": "煤炉",
  "suruga": "骏河屋",
  "yahoo": "雅虎拍卖",
  "amazon": "日亚"
};

class PubTab extends StatelessWidget {
  final String imageUrl;
  final String content;

  const PubTab({Key? key, required this.imageUrl, required this.content })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 54),
            child: Image.asset(imageUrl)
        ),
        Text(
          content,
        )
      ],
    );
  }
}

class _HunterPubRouteState extends State with TickerProviderStateMixin {

  double bannerHeight = 0;

  bool expanded = false;
  String currentSelectedTab = "mercari";

  Animation<double>? arrowAnimation;
  Animation<double>? overlayAnimation;
  late AnimationController animationController;
  late CurvedAnimation curvedAnimation;
  late TabController tabController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
    );
    curvedAnimation = CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    tabController = TabController(length: 4, vsync: this);
  }

  hireNewMercariHunter() {
    Navigator.of(context).push(
        PageRouteBuilder(
            pageBuilder: (ctx, animation, secondAnimation) {
              return HunterIdCard(
                savePurpose: "create",
                hunterInfo: model.MercariHunter.fromJson({}),
                autoFocusOnKeywordEdit: true,
              );
            },
            transitionDuration: Duration(milliseconds: 800),
            reverseTransitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (ctx, animation, secondAnimation, child) {
              return FadeTransition (
                  opacity: animation,
                  child: child);
            }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Overlay(
      initialEntries: [
        OverlayEntry(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
                padding: const EdgeInsets.all(16),
              ),
              title: Builder(builder: (context) {
                return TabBar(
                  controller: tabController,
                  isScrollable: true,
                  onTap: (idx) {
                    tabController.index = idx;
                    setState(() {
                      currentSelectedTab = hunterRoundTables.keys.toList()[idx];
                    });
                  },
                  tabs: hunterRoundTables.keys
                      .map((key) => Tab(
                    height: context
                        .findAncestorWidgetOfExactType<AppBar>()!
                        .preferredSize
                        .height -
                        2.0,
                    child: PubTab(
                        imageUrl: "assets/images/$key.png",
                        content: hunterRoundTables[key]!),
                  ))
                      .toList(),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle: const TextStyle(
                      color: Color.fromRGBO(203, 203, 207, 0.5)),
                );
              }),
              actions: [
                Builder(builder: (context) {
                  return IconButton(
                      onPressed: () {
                        setState(() {
                          final size = MediaQuery.of(context).size;
                          final _bannerHeight = context
                          !.findAncestorWidgetOfExactType<
                              AppBar>()
                          !.preferredSize
                              .height;
                          bannerHeight = _bannerHeight;
                          bool nextExpanded = !expanded;
                          arrowAnimation = Tween(begin: 0.0, end: math.pi).animate(curvedAnimation)..addListener(() {setState(() {
                          });});
                          overlayAnimation = Tween(begin: 0.0, end: size.height-(bannerHeight ?? 0)).animate(curvedAnimation)..addListener(() {setState(() {
                          });});
                          if (!expanded) {
                            animationController.forward();
                          } else {
                            animationController.reverse();
                          }
                          expanded = nextExpanded;
                        });
                      },
                      icon: Container(
                          alignment: Alignment.center,
                          child: Transform.rotate(
                            angle: arrowAnimation is Animation ? arrowAnimation!.value : 0,
                            child: const Icon(Icons.arrow_downward),
                          )
                      ));
                })
              ],
            ),
            body: TabBarView(
                controller: tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  MercariHunter(),
                  Text("123"),
                  Text("123"),
                  Text("123"),
                ]),
            floatingActionButton: FloatingActionButton(
              tooltip: 'todo',
              onPressed: () {
                if (currentSelectedTab == "mercari") {
                  hireNewMercariHunter();
                }
              },
              child: const Icon(Icons.add),
            ),
          );
        }),
        OverlayEntry(builder: (context) {
          return Positioned(
            top: bannerHeight,
              width: MediaQuery.of(context).size.width,
              height: overlayAnimation is Animation ? overlayAnimation!.value : 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  expanded = false;
                  animationController.reverse();
                });
              },
              child: Container(
                decoration: const BoxDecoration(color: Color.fromRGBO(50, 50, 50, 0.5)),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      // do nothing
                    },
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      width: MediaQuery.of(context).size.width,
                      height: overlayAnimation is Animation ? overlayAnimation!.value / 8 : 0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: hunterRoundTables.keys.map((hunterKey) => PubBadge(
                            active: currentSelectedTab == hunterKey,
                            title: hunterRoundTables[hunterKey]!,
                            setTitle: () {
                              tabController.index = hunterRoundTables.keys.toList().indexOf(hunterKey);
                              setState(() {
                                currentSelectedTab = hunterKey;
                              });
                            }
                        )).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        })
      ],
    ));
  }
}

class PubBadge extends StatelessWidget {
  final bool active;
  final String title;
  final void Function() setTitle;
  const PubBadge({required this.active, required this.title, required this.setTitle, Key? key,}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: OutlinedButton(
          style: active ? ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ) : ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
          ),
          onPressed: () {
            setTitle();
          },
          child: Text(title)
      ),
      padding: EdgeInsets.all(5.0),
    );
  }
}