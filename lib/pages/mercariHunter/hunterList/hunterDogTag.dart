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
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color.fromRGBO(218,218,220, 0.7)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow:[
            BoxShadow(
              color: Color.fromRGBO(142, 142, 142, 1.0),
              offset: Offset(2, 2),
              blurRadius: 5,
              spreadRadius: 2,
            )
          ],
        ),
        child: Container(
          height: 100,
          padding: EdgeInsets.only(top: 8, bottom: 8, left: 24, right: 0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 8,
                child: Row(
                  children: [
                    Text(keyword, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                    Container(
                      margin: const EdgeInsets.only(left: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color.fromRGBO(0, 108, 255, 1)),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 4),
                        child: Text("最后更新于$lastUpdatedAt", style: TextStyle(fontWeight: FontWeight.w500, color:  Color.fromRGBO(0, 108, 255, 1))),
                      )
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 8,
                child: Text("频率: $schedule", style: const TextStyle(color: Color.fromRGBO(201, 201, 205, 1))),
              ),
              Stack(
                alignment: Alignment(1, 0),
                children: [
                  Positioned(
                      right: 0,
                      child: Stack(
                    children: [
                      Positioned(
                          right: 0,
                          child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                          ),
                          width: 70,
                          height: 24,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(status.name, style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white
                              )),
                              Container(
                                width: 6,
                              )
                            ],
                          )
                      )),
                      Container(
                        width: 71,
                        height: 24,
                        decoration: const BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    width: 12,
                                    color: Colors.transparent
                                ),
                                right: BorderSide(
                                    width: 0,
                                    color: Colors.transparent
                                ),
                                bottom: BorderSide(
                                    width: 12,
                                    color: Colors.transparent
                                ),
                                left: BorderSide(
                                    width: 12,
                                    color: Colors.white
                                )
                            )
                        ),
                      )
                    ],
                  )
                  )

                ],
              )
            ],
          ),
        )
      )
    );
  }
}