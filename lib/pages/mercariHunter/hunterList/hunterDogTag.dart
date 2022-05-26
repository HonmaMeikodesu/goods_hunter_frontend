import 'package:flutter/material.dart';

enum HunterStatus { sleeping, hunting }

class HunterDogTag extends StatelessWidget {

  final String keyword;

  final String schedule;

  final String lastUpdatedAt;

  final HunterStatus status;

  const HunterDogTag({Key? key, required this.keyword, required this.lastUpdatedAt, required this.status, required this.schedule  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return (
      DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow:[
            BoxShadow(
              color: Color.fromRGBO(255, 255, 255, 1),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(keyword, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Container(
                    margin: const EdgeInsets.only(left: 24),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromRGBO(0, 108, 255, 1),
                    ),
                  child: Text("最后更新于$lastUpdatedAt", style: TextStyle(fontWeight: FontWeight.w500, color:  Colors.white)),
                )
              ],
            ),
            Row(
              children: [
                Text("频率: $schedule", style: const TextStyle(color: Color.fromRGBO(201, 201, 205, 1)))
              ],
            ),
            Positioned(
                child: Text(status.name),
                right: 0,
            )
          ],
        ),
      )
    );
  }
}