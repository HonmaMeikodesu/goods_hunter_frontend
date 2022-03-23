import 'package:flutter/material.dart';

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

class _HunterPubRouteState extends State {
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
                    Builder(builder: (topContext) {
                      return IconButton(
                          onPressed: () {
                            Overlay.of(context)
                                ?.insert(OverlayEntry(builder: (context) {
                              return Stack(
                                children: [
                                  Positioned(
                                    top: topContext
                                        .findAncestorWidgetOfExactType<
                                        AppBar>()
                                        ?.preferredSize
                                        .height,
                                    child: Row(
                                      children: [Text("123")],
                                    ),
                                  )
                                ],
                              );
                            }));
                          },
                          icon: const Icon(Icons.arrow_downward));
                    })
                  ],
                ),
                body: TabBarView(children: [
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
        })
      ],
    ));
  }
}
