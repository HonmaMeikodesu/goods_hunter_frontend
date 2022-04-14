import 'package:flutter/material.dart';
import 'dart:math' as math;

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

  const PubTab({Key? key, required this.imageUrl, required this.content})
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
            child: Image.asset(imageUrl)),
        Text(
          content,
        )
      ],
    );
  }
}

List<Tab> buildTabs(BuildContext context) {
  return hunterRoundTables.keys
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
      .toList();
}

class _HunterPubRouteState extends State with TickerProviderStateMixin {

  double bannerHeight = 0;

  bool expanded = false;

  Animation<double>? arrowAnimation;
  Animation<double>? overlayAnimation;
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Overlay(
      initialEntries: [
        OverlayEntry(builder: (context) {
          return DefaultTabController(
              length: 4,
              child: Scaffold(
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
                      isScrollable: true,
                      tabs: buildTabs(context),
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      unselectedLabelStyle: const TextStyle(
                          color: Color.fromRGBO(203, 203, 207, 0.5)),
                    );
                  }),
                  actions: [
                    Builder(builder: (context) {
                      return IconButton(
                          onPressed: () {},
                          icon: GestureDetector(
                            child: Container(
                                alignment: Alignment.center,
                                child: Transform.rotate(
                                  angle: arrowAnimation is Animation ? arrowAnimation!.value : 0,
                                  child: const Icon(Icons.arrow_downward),
                                )
                            ),
                            onTap: () {
                              setState(() {
                                final size = MediaQuery.of(context).size;
                                final _bannerHeight = context
                                    !.findAncestorWidgetOfExactType<
                                    AppBar>()
                                    !.preferredSize
                                    .height;
                                bannerHeight = _bannerHeight;
                                expanded = !expanded;
                                arrowAnimation = Tween(begin: 0.0, end: math.pi).animate(animationController)..addListener(() {setState(() {
                                });});
                                overlayAnimation = Tween(begin: 0.0, end: size.height-(bannerHeight ?? 0)).animate(animationController)..addListener(() {setState(() {
                                });});
                                if (!expanded) {
                                  animationController.forward();
                                } else {
                                  animationController.reverse();
                                }
                              });
                            },
                          ));
                    })
                  ],
                ),
                body: const TabBarView(children: [
                  Text("123"),
                  Text("123"),
                  Text("123"),
                  Text("123"),
                ]),
                floatingActionButton: FloatingActionButton(
                  tooltip: 'todo',
                  onPressed: () {},
                  child: const Icon(Icons.add),
                ),
              ));
        }),
        OverlayEntry(builder: (context) {
          return Positioned(
            width: MediaQuery.of(context).size.width,
            height: overlayAnimation is Animation ? overlayAnimation!.value : 0,
            top: bannerHeight,
            child: Container(
              decoration: const BoxDecoration(color: Color.fromRGBO(225, 225, 225, 0.5)),
              child: Text("hahahaha")
              ,
            )
          );
        })
      ],
    ));
  }
}