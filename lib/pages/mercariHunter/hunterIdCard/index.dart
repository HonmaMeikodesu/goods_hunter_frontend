import 'package:flutter/material.dart';
import 'package:goods_hunter/api/index.dart';
import 'package:goods_hunter/pages/mercariHunter/hunterIdCard/ghost.dart';
import 'package:goods_hunter/pages/mercariHunter/hunterIdCard/goodsFilter.dart';
import 'package:goods_hunter/pages/mercariHunter/hunterIdCard/importDialog.dart';
import 'package:goods_hunter/utils/const.dart';
import '../../../models/index.dart' as model;
import "dart:math" as math;
import 'package:cron_form_field/cron_form_field.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:time_range_picker/time_range_picker.dart';

class HunterIdCard extends StatefulWidget {
  final model.MercariHunter hunterInfo;

  final RelativeRect? transitionRect;
  final Animation<double>? transitionAnimation;

  const HunterIdCard(
      {Key? key,
      required this.hunterInfo,
      this.transitionAnimation,
      this.transitionRect})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _HunterIdCardState();
}

enum KeywordInputStatus { read, write }

class _HunterIdCardState extends State<HunterIdCard>
    with TickerProviderStateMixin {
  late final AnimationController editKeywordAnimation;
  late bool pendingForTransition;
  final TextEditingController keywordInputController = TextEditingController();
  late String? keyword;
  late String? goodsStatus;
  late String? salesStatus;
  late String? deliveryStatus;
  late String? minPrice;
  late String? maxPrice;
  late Map<String, String> extraParamsMap;
  final TextEditingController cronExpressionController =
      TextEditingController();
  final TextEditingController freezingController = TextEditingController();
  String? freezingStart;
  String? freezingEnd;
  bool useFreezing = false;

  bool scheduleManual = true;

  bool resetExtraParams = false;

  KeywordInputStatus keywordInputStatus = KeywordInputStatus.read;

  @override
  initState() {
    super.initState();
    editKeywordAnimation = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        lowerBound: 0,
        upperBound: 2);
    pendingForTransition = widget.transitionAnimation is Animation<double> &&
        widget.transitionRect is RelativeRect;

    var uriObj = Uri.parse(widget.hunterInfo.url).queryParameters;
    keyword = uriObj["keyword"] ?? "";
    goodsStatus = uriObj["item_condition_id"];
    salesStatus = uriObj["status"];
    deliveryStatus = uriObj["shipping_payer_id"];
    minPrice = uriObj["price_min"];
    maxPrice = uriObj["price_max"];
    extraParamsMap =
        Map.fromEntries(uriObj.entries.toList().where((mapEntry) => [
              "keyword",
              "item_condition_id",
              "status",
              "shipping_payer_id",
              "price_min",
              "price_max"
            ].every((element) => element != mapEntry.key)));

    widget.transitionAnimation!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          pendingForTransition = false;
        });
      } else {
        setState(() {
          pendingForTransition = true;
        });
      }
    });

    cronExpressionController.text = widget.hunterInfo.schedule;

    if (widget.hunterInfo.freezingStart.isNotEmpty &&
        widget.hunterInfo.freezingEnd.isNotEmpty) {
      useFreezing = true;
      freezingStart = "${widget.hunterInfo.freezingStart.split(":")[0]}:${widget.hunterInfo.freezingStart.split(":")[1]}";
      freezingEnd = "${widget.hunterInfo.freezingEnd.split(":")[0]}:${widget.hunterInfo.freezingEnd.split(":")[1]}";
    }
  }

  @override
  dispose() {
    super.dispose();
    editKeywordAnimation.dispose();
  }

  buildTransition() {
    return HunterIdCardGhost(
        rect: widget.transitionRect!,
        title: keyword ?? "",
        animation: widget.transitionAnimation!);
  }

  Uri buildHunterUrl(String host, [String? path]) {
    List<MapEntry<String, String>> mapEntryList = [];
    if (keyword is String) {
      mapEntryList.add(MapEntry("keyword", keyword!));
    }
    if (goodsStatus is String) {
      mapEntryList.add(MapEntry("item_condition_id", goodsStatus!));
    }
    if (salesStatus is String) {
      mapEntryList.add(MapEntry("status", salesStatus!));
    }
    if (deliveryStatus is String) {
      mapEntryList.add(MapEntry("shipping_payer_id", deliveryStatus!));
    }
    if (minPrice is String) {
      mapEntryList.add(MapEntry("price_min", minPrice!));
    }
    if (maxPrice is String) {
      mapEntryList.add(MapEntry("price_max", maxPrice!));
    }
    Uri uri = Uri(
        scheme: "https",
        host: host,
        path: path ?? "",
        queryParameters: Map.fromEntries(
            [...mapEntryList, ...extraParamsMap.entries.toList()]));
    return uri;
  }

  buildPage() {
    if (keyword is String) {
      keywordInputController.text = keyword!;
    }
    if (freezingStart is String && freezingEnd is String) {
      freezingController.text = "$freezingStart ~ $freezingEnd";
    }
    List<Widget> expansionList = [
      ExpansionTile(
          maintainState: true,
          leading: const Icon(Icons.filter_alt_rounded, color: Colors.green),
          title: const Text("过滤器",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
          subtitle: const Text("指定搜索的筛选条件",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.grey)),
          tilePadding: const EdgeInsets.all(12),
          children: [
            ExpansionTile(
              maintainState: true,
              title: const Text("商品状态"),
              trailing: const Icon(
                Icons.category_outlined,
                color: Colors.deepOrangeAccent,
              ),
              controlAffinity: ListTileControlAffinity.leading,
              children: [
                StatusFilter(
                    paramValue: goodsStatus,
                    statusAll: GoodsStatus.all,
                    statusMap: GoodsStatusMap,
                    onChange: (paramValue) {
                      setState(() {
                        goodsStatus = paramValue;
                      });
                    })
              ],
            ),
            ExpansionTile(
              maintainState: true,
              title: const Text("贩售状况"),
              trailing: const Icon(
                Icons.shopping_cart,
                color: Colors.redAccent,
              ),
              controlAffinity: ListTileControlAffinity.leading,
              children: [
                StatusFilter(
                    paramValue: salesStatus,
                    statusAll: SalesStatus.all,
                    statusMap: SalesStatusMap,
                    onChange: (paramValue) {
                      setState(() {
                        salesStatus = paramValue;
                      });
                    })
              ],
            ),
            ExpansionTile(
              maintainState: true,
              title: const Text("送料承担"),
              trailing: const Icon(
                Icons.delivery_dining,
                color: Colors.orangeAccent,
              ),
              controlAffinity: ListTileControlAffinity.leading,
              children: [
                StatusFilter(
                    paramValue: deliveryStatus,
                    statusAll: DeliveryStatus.all,
                    statusMap: DeliveryStatusMap,
                    onChange: (paramValue) {
                      setState(() {
                        deliveryStatus = paramValue;
                      });
                    })
              ],
            ),
            ExpansionTile(
              maintainState: true,
              title: const Text("价格范围"),
              trailing: const Icon(
                Icons.attach_money,
                color: Colors.green,
              ),
              controlAffinity: ListTileControlAffinity.leading,
              children: [
                PriceFilter(
                  minPrice: minPrice,
                  maxPrice: maxPrice,
                  onChange: ({minPrice, maxPrice}) {
                    setState(() {
                      this.minPrice = minPrice;
                      this.maxPrice = maxPrice;
                    });
                  },
                )
              ],
            ),
            ExpansionTile(
              maintainState: true,
              title: const Text("高级选项"),
              trailing: const Icon(
                Icons.developer_mode,
                color: Colors.grey,
              ),
              controlAffinity: ListTileControlAffinity.leading,
              children: [
                CustomFilter(
                  paramsMap: extraParamsMap,
                  onChange: ({required paramsMap}) {
                    setState(() {
                      extraParamsMap = paramsMap;
                    });
                  },
                  resetComplete: () {
                    // no need to pick this update up immediately
                    resetExtraParams = false;
                  },
                  needReset: resetExtraParams,
                )
              ],
            )
          ]),
      ExpansionTile(
        leading: const Icon(Icons.schedule, color: Colors.blueAccent),
        title: const Text("频率",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
        subtitle: const Text("指定爬取谷子信息的频率",
            style: const TextStyle(
                fontWeight: FontWeight.w400, fontSize: 12, color: Colors.grey)),
        children: [
          Form(
            child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24, top: 24),
                        child: FlutterSwitch(
                          value: scheduleManual,
                          onToggle: (value) {
                            setState(() {
                              scheduleManual = value;
                            });
                          },
                          inactiveColor: Colors.orangeAccent,
                          activeColor: Colors.greenAccent,
                          inactiveIcon:
                              const Icon(Icons.precision_manufacturing),
                          activeIcon: const Icon(Icons.handyman),
                          inactiveText: "辅助生成",
                          activeText: "手动输入",
                          duration: const Duration(milliseconds: 500),
                          toggleSize: 48,
                          height: 48,
                          borderRadius: 24,
                          width: 128,
                        ),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  Row(
                    children: [
                      scheduleManual
                          ? Flexible(
                              child: TextFormField(
                              autofocus: true,
                              controller: cronExpressionController,
                              decoration: const InputDecoration(
                                helperText: "请输入cron表达式",
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18)),
                                ),
                                filled: true,
                                fillColor: Color.fromRGBO(236, 238, 239, .6),
                              ),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic),
                            ))
                          : Flexible(
                              child: CronFormField(
                              autofocus: true,
                              controller: cronExpressionController,
                            ))
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
      ExpansionTile(
        leading: const Icon(Icons.nights_stay, color: Colors.yellowAccent),
        childrenPadding: EdgeInsets.all(12),
        title: const Text("勿扰模式",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
        subtitle: const Text("设置休眠时间段",
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 12, color: Colors.grey)),
        trailing: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 60),
          child: Builder(builder: (context){
            return FlutterSwitch(
              value: useFreezing,
              onToggle: (value) {
                setState(() {
                  var widget = context.findAncestorWidgetOfExactType<ListTile>()!;
                  widget.onTap!();
                  useFreezing = value;
                });
              },
            );
    },) ,
        ),
        controlAffinity: ListTileControlAffinity.trailing,
        onExpansionChanged: (value) {
          setState(() {
            useFreezing = value;
          });
        },
        initiallyExpanded: useFreezing,
        children: [
          Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                        child: TextField(
                      readOnly: true,
                      textAlign: TextAlign.center,
                      controller: freezingController,
                      onTap: () async {
                        TimeRange result = await showTimeRangePicker(
                          context: context,
                          start: freezingStart is String
                              ? TimeOfDay(
                                  hour: int.parse(freezingStart!.split(":")[0]),
                                  minute:
                                      int.parse(freezingStart!.split(":")[1]))
                              : null,
                          end: freezingEnd is String
                              ? TimeOfDay(
                                  hour: int.parse(freezingEnd!.split(":")[0]),
                                  minute: int.parse(freezingEnd!.split(":")[1]))
                              : null,
                          fromText: "起始",
                          toText: "结束",
                          ticks: 8,
                          labelOffset: -20,
                          labels: [
                            ClockLabel.fromDegree(deg: -90, text: "12 h"),
                            ClockLabel.fromDegree(deg: -45, text: "15 h"),
                            ClockLabel.fromDegree(deg: 0, text: "18 h"),
                            ClockLabel.fromDegree(deg: 45, text: "21 h"),
                            ClockLabel.fromDegree(deg: 90, text: "24 h"),
                            ClockLabel.fromDegree(deg: 135, text: "3 h"),
                            ClockLabel.fromDegree(deg: 180, text: "6 h"),
                            ClockLabel.fromDegree(deg: 225, text: "9 h"),
                          ],
                        );
                        setState(() {
                          freezingStart = "${result.startTime.hour.toString().padLeft(2, "0")}:${result.startTime.minute.toString().padLeft(2, "0")}";
                          freezingEnd = "${result.endTime.hour.toString().padLeft(2, "0")}:${result.endTime.minute.toString().padLeft(2, "0")}";
                        });
                      },
                    ))
                  ],
                )
              ],
            ),
          ),
        ],
      )
    ];
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(191, 192, 194, 0.3),
        ),
        child: Column(
          children: [
            Container(
              height: 60,
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Flex(
                direction: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: keywordInputStatus == KeywordInputStatus.write
                        ? Focus(
                            onFocusChange: (flag) {
                              if (!flag) {
                                setState(() {
                                  keywordInputStatus = KeywordInputStatus.read;
                                });
                              }
                            },
                            child: TextField(
                              autofocus: true,
                              textAlignVertical: TextAlignVertical.top,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                              controller: keywordInputController,
                            ),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(keyword ?? "",
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                          ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        if (keywordInputStatus == KeywordInputStatus.read) {
                          setState(() {
                            keywordInputStatus = KeywordInputStatus.write;
                            editKeywordAnimation.forward();
                          });
                        } else {
                          setState(() {
                            keyword = keywordInputController.text;
                            keywordInputStatus = KeywordInputStatus.read;
                            editKeywordAnimation.reverse();
                          });
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.only(left: 16),
                          child: AnimatedBuilder(
                            animation: editKeywordAnimation,
                            builder: (context, child) {
                              Matrix4 transformMatrix = Matrix4.identity();
                              transformMatrix.setEntry(3, 2, 0.02);
                              transformMatrix.rotateY(math.pi /
                                  2 *
                                  math.sin(editKeywordAnimation.value *
                                      (math.pi / 2)));
                              if (editKeywordAnimation.value < 0.5) {
                                return Container(
                                  transform: transformMatrix,
                                  transformAlignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: Colors.orangeAccent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(
                                    Icons.edit_rounded,
                                    color: Colors.white,
                                  ),
                                );
                              } else {
                                return Container(
                                  transform: transformMatrix,
                                  transformAlignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: const BorderRadius.all(
                                        const Radius.circular(20)),
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          )),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                padding: const EdgeInsets.all(12),
                child: ListView.builder(
                    itemCount: expansionList.length,
                    itemBuilder: (context, index) {
                      return Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: expansionList[index]);
                    }),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              var hunterInfoToUpload = MercariHunterInfoToUpload.from(
                  id: widget.hunterInfo.hunterInstanceId,
                  url: buildHunterUrl("api.mercari.jp", "search_index/search").toString(),
                  schedule: cronExpressionController.text,
                  freezeEnd: freezingEnd,
                  freezeStart: freezingStart
              );
              await updateMercariHunterWatcherInfo(context: context, hunterInfoToRegister: hunterInfoToUpload);
              Future.delayed(Duration(milliseconds: 500), () {
                Navigator.of(context).pop();
              });
            },
            child: const Text("保存"),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
            child: FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ImportDialog(
                          previousUrl: Uri.decodeComponent(
                              buildHunterUrl("jp.mercari.com").toString()),
                          onOk: (newUrl) {
                            setState(() {
                              var uriObj = Uri.parse(newUrl).queryParameters;
                              keyword = uriObj["keyword"] ?? "";
                              goodsStatus = uriObj["item_condition_id"];
                              salesStatus = uriObj["status"];
                              deliveryStatus = uriObj["shipping_payer_id"];
                              minPrice = uriObj["price_min"];
                              maxPrice = uriObj["price_max"];
                              extraParamsMap = Map.fromEntries(uriObj.entries
                                  .toList()
                                  .where((mapEntry) => [
                                        "keyword",
                                        "item_condition_id",
                                        "status",
                                        "shipping_payer_id",
                                        "price_min",
                                        "price_max"
                                      ].every((element) =>
                                          element != mapEntry.key)));
                              resetExtraParams = true;
                            });
                          });
                    });
              },
              label: const Text("导入配置"),
              icon: const Icon(Icons.upload_rounded),
              backgroundColor: Colors.pink,
            ),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("取消"),
          )
        ],
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
