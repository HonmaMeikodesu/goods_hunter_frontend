import 'package:flutter/material.dart';

class HunterPubRoute extends StatefulWidget {
  const HunterPubRoute({Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _HunterPubRouteState();
}

class PubTab extends StatelessWidget {
  final String imageUrl;
  final String content;
  const PubTab({Key? key, required this.imageUrl, required this.content}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 400,
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imageUrl),
          Text(content)
        ],
      ),
    );
  }
}

class PubHeader extends StatelessWidget {
  const PubHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Flex(
          direction: Axis.horizontal,
          children: const [
            PubTab(imageUrl: "assets/images/mercari.png", content: "Mercari"),
            PubTab(imageUrl: "assets/images/mercari.png", content: "Mercari"),
            PubTab(imageUrl: "assets/images/mercari.png", content: "Mercari"),
            PubTab(imageUrl: "assets/images/mercari.png", content: "Mercari")
          ],
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
          Stack(
            children: [
              IconButton(
                  onPressed: () {
                    Overlay.of(context)?.insert(OverlayEntry(builder: (context) {
                      return Positioned(
                        top: 92,
                        child: Column(
                          children: [
                            Text("1234")
                          ],
                        ),
                      );
                    }));
                  },
                  icon: const Icon(Icons.arrow_downward)
              )
            ],
          )
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