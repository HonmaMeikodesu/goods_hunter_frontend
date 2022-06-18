import 'package:flutter/material.dart';
import 'package:goods_hunter/pages/mercariHunter/hunterIdCard/ghost.dart';
import 'package:goods_hunter/pages/mercariHunter/hunterIdCard/goodsFilter.dart';
import 'package:goods_hunter/pages/mercariHunter/hunterIdCard/importDialog.dart';
import 'package:goods_hunter/utils/const.dart';
import '../../../models/index.dart' as model;
import "dart:math" as math;

class HunterIdCard extends StatefulWidget {

  final model.MercariHunter hunterInfo;

  final RelativeRect? transitionRect;
  final Animation<double>? transitionAnimation;

  const HunterIdCard({Key? key, required this.hunterInfo, this.transitionAnimation, this.transitionRect }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HunterIdCardState();
}

enum KeywordInputStatus {
  read,
  write
}

class _HunterIdCardState extends State<HunterIdCard>
    with TickerProviderStateMixin {
  late final AnimationController editKeywordAnimation;
  late bool pendingForTransition;
  final TextEditingController keywordInputController = TextEditingController();
  late String keyword;
  late String? goodsStatus;
  late String? salesStatus;
  late String? deliveryStatus;
  late String? minPrice;
  late String? maxPrice;
  late Map<String, String> extraParamsMap;

  bool resetExtraParams = false;

  KeywordInputStatus keywordInputStatus = KeywordInputStatus.read;

  @override
  initState() {
    super.initState();
    editKeywordAnimation = AnimationController(vsync: this, duration: const Duration(milliseconds: 500), lowerBound: 0, upperBound: 2);
    pendingForTransition = widget.transitionAnimation is Animation<double> && widget.transitionRect is RelativeRect;
    var uriObj = Uri.parse(widget.hunterInfo.url).queryParameters;
    keyword = uriObj["keyword"] ?? "";
    goodsStatus = uriObj["item_condition_id"];
    salesStatus = uriObj["status"];
    deliveryStatus= uriObj["shipping_payer_id"];
    minPrice = uriObj["price_min"];
    maxPrice = uriObj["price_max"];
    extraParamsMap = Map.fromEntries(uriObj.entries.toList().where((mapEntry) => ["keyword", "item_condition_id", "status", "shipping_payer_id", "price_min", "price_max"].every((element) => element != mapEntry.key)));
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
  }

  @override
  dispose() {
    super.dispose();
    editKeywordAnimation.dispose();
  }

  buildTransition() {
    return HunterIdCardGhost(rect: widget.transitionRect!, title: keyword, animation: widget.transitionAnimation!);
  }

  buildPage() {
    keywordInputController.text = keyword;
    List<Widget> expansionList = [
      ExpansionTile(
          maintainState: true,
          leading: Icon(Icons.filter_alt_rounded, color: Colors.green),
          title: Text("过滤器", style: TextStyle( fontWeight: FontWeight.w400, fontSize: 18)),
          subtitle: Text("指定搜索的筛选条件", style: TextStyle( fontWeight: FontWeight.w400, fontSize: 12, color: Colors.grey)),
          tilePadding: EdgeInsets.all(12),
          children: [
            ExpansionTile(
              maintainState: true,
              title: Text("商品状态"),
              trailing: Icon(Icons.category_outlined, color: Colors.deepOrangeAccent,),
              controlAffinity: ListTileControlAffinity.leading,
              children: [
                StatusFilter(paramValue: goodsStatus , statusAll: GoodsStatus.all, statusMap: GoodsStatusMap, onChange: (paramValue) {
                  setState(() {
                    goodsStatus = paramValue;
                  });
                })
              ],
            ),
            ExpansionTile(
              maintainState: true,
              title: Text("贩售状况"),
              trailing: Icon(Icons.shopping_cart, color: Colors.redAccent,),
              controlAffinity: ListTileControlAffinity.leading,
              children: [
                StatusFilter(paramValue: salesStatus , statusAll: SalesStatus.all, statusMap: SalesStatusMap, onChange: (paramValue) {
                  setState(() {
                    salesStatus = paramValue;
                  });
                })
              ],
            ),
            ExpansionTile(
              maintainState: true,
              title: Text("送料承担"),
              trailing: Icon(Icons.delivery_dining, color: Colors.orangeAccent,),
              controlAffinity: ListTileControlAffinity.leading,
              children: [
                StatusFilter(paramValue: deliveryStatus , statusAll: DeliveryStatus.all, statusMap: DeliveryStatusMap, onChange: (paramValue) {
                  setState(() {
                    deliveryStatus = paramValue;
                  });
                })
              ],
            ),
            ExpansionTile(
              maintainState: true,
              title: Text("价格范围"),
              trailing: Icon(Icons.attach_money, color: Colors.green,),
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
              title: Text("高级选项"),
              trailing: Icon(Icons.developer_mode, color: Colors.grey,),
              controlAffinity: ListTileControlAffinity.leading,
              children: [
                CustomFilter(paramsMap: extraParamsMap, onChange: ({required paramsMap}) {
                  setState(() {
                    extraParamsMap = paramsMap;
                  });
                }, resetComplete: () {
                  // no need to pick this update up immediately
                  resetExtraParams = false;
                }, needReset: resetExtraParams,)
              ],
            )
          ]),
    ];
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
                  height: 60,
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
                        child: keywordInputStatus == KeywordInputStatus.write ? Focus(
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
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            controller: keywordInputController,
                          ),
                        ) : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(keyword,
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                              padding: EdgeInsets.only(left: 16),
                              child: AnimatedBuilder(
                                animation: editKeywordAnimation,
                                builder: (context, child) {
                                  Matrix4 transformMatrix = Matrix4.identity();
                                  transformMatrix.setEntry(3, 2, 0.02);
                                  transformMatrix.rotateY(math.pi / 2 * math.sin(editKeywordAnimation.value * (math.pi / 2)));
                                  if (editKeywordAnimation.value < 0.5) {
                                    return Container(
                                      transform: transformMatrix,
                                      transformAlignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.orangeAccent,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      padding: EdgeInsets.all(4),
                                      child: Icon(Icons.edit_rounded, color: Colors.white,),
                                    );
                                  } else {
                                    return Container(
                                      transform: transformMatrix,
                                      transformAlignment: Alignment.center,
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
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    padding: EdgeInsets.all(12),
                    child: ListView.builder(
                        itemCount: expansionList.length,
                        itemBuilder: (context, index) {
                          return Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent), child: expansionList[index]);
                        }
                    ),
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
                onPressed: () {

                },
                child: Text("保存"),
              ),
              Padding(padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
              child: FloatingActionButton.extended(
                onPressed: () {
                  showDialog(context: context, builder: (context) {
                    return ImportDialog(onOk: (newUrl) {
                      setState(() {
                        var uriObj = Uri.parse(newUrl).queryParameters;
                        keyword = uriObj["keyword"] ?? "";
                        goodsStatus = uriObj["item_condition_id"];
                        salesStatus = uriObj["status"];
                        deliveryStatus= uriObj["shipping_payer_id"];
                        minPrice = uriObj["price_min"];
                        maxPrice = uriObj["price_max"];
                        extraParamsMap = Map.fromEntries(uriObj.entries.toList().where((mapEntry) => ["keyword", "item_condition_id", "status", "shipping_payer_id", "price_min", "price_max"].every((element) => element != mapEntry.key)));
                        resetExtraParams = true;
                      });
                    });
                  });
                },
                label: Text("导入配置"),
                icon: Icon(Icons.upload_rounded),
                backgroundColor: Colors.pink,

              ),),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("取消"),
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