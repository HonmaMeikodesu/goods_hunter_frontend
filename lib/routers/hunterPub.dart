import 'package:flutter/material.dart';

class HunterPubRoute extends StatefulWidget {
  const HunterPubRoute({Key? key}): super(key: key);

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
  final bool? active;
  final String site;
  final void Function(String key)? onClick;
  const PubTab({Key? key, required this.site, required this.imageUrl, required this.content, this.active, this.onClick }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        constraints: const BoxConstraints(
            minWidth: 200
        ),
        decoration: BoxDecoration(border: active == true ? const Border(bottom: BorderSide()) : null),
        child: Flex(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imageUrl),
            Text(
              content,
              style: active == true ?
              const TextStyle(fontWeight: FontWeight.bold) :
              const TextStyle(color: Color.fromRGBO(203, 203, 207, 0.5)),
            )
          ],
        ),
      ),
      onPanDown: (event) {
        onClick!(site);
      },
    );
  }
}

class PubHeader extends StatefulWidget {
  const PubHeader({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PubHeaderState();
}

class _PubHeaderState extends State {
  String selected = hunterRoundTables["mercari"]!;

  @override
  Widget build(BuildContext context) {
    var pubTabs = hunterRoundTables.keys.map((key) => PubTab(
        site: key,
        imageUrl: "assets/images/$key.png",
        content: hunterRoundTables[key]!,
        active: selected == key,
        onClick: (key) { setState(() {
          selected = key;
        });},
    ));
    return SizedBox(
      height: 48,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Flex(
          direction: Axis.horizontal,
          children: pubTabs.toList(),
        ),
      ),
    );
  }

}
class _HunterPubRouteState extends State {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () { Navigator.of(context).maybePop();},
          padding: const EdgeInsets.all(16),
        ),
        title: const PubHeader(),
        actions: [
          Builder(builder: (topContext) {
            return IconButton(
                onPressed: () {
                  Overlay.of(context)?.insert(OverlayEntry(builder: (context) {
                    return Positioned(
                      top: topContext.findAncestorWidgetOfExactType<AppBar>()?.preferredSize.height,
                      child: Row(
                        children: [

                        ],
                      ),
                    );
                  }));
                },
                icon: const Icon(Icons.arrow_downward)
            );
          })
        ],
      ),
      body: Column(
        children: const [
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'todo',
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}