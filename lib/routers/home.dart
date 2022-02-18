import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(onPressed: (){
                  Navigator.pushNamed (context, "authentication");
                }, child: Text("123")),
                ElevatedButton(onPressed: (){
                  Navigator.pushNamed (context, "my");
                }, child: Text("456")),
                ElevatedButton(onPressed: (){
                  Navigator.pushNamed (context, "hunterPub");
                }, child: Text("789"))
              ],
            ),
          ),
        ));
  }
}