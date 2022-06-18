import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goods_hunter/common/myError.dart';
import 'package:goods_hunter/utils/generateRandomString.dart';
import '../../../utils/const.dart';

class StatusFilter extends StatefulWidget {
  final String? paramValue;

  final void Function(String paramValue)? onChange;

  final Enum statusAll;

  final Map<dynamic, StatusValue> statusMap;

  const StatusFilter(
      {Key? key,
      this.paramValue,
      this.onChange,
      required this.statusAll,
      required this.statusMap})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StatusFilterState();
}

class _StatusFilterState extends State<StatusFilter> {
  List<String> selectedStatus = [];

  initState() {
    String? paramValue = widget.paramValue;
    if (paramValue is String) {
      setState(() {
        selectedStatus = paramValue.split(",").toList();
      });
    }
  }

  addSelected(String paramValue) {
    Function? onChange = widget.onChange;
    if (selectedStatus.any((element) => element == paramValue)) {
      return;
    }
    setState(() {
      selectedStatus.add(paramValue);
      if (onChange is Function) {
        onChange(selectedStatus.join(","));
      }
    });
  }

  removeSelected(String paramValue) {
    Function? onChange = widget.onChange;
    if (selectedStatus.any((element) => element == paramValue)) {
      setState(() {
        selectedStatus.remove(paramValue);
        if (onChange is Function) {
          onChange(selectedStatus.join(","));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var statusMap = widget.statusMap;
    var statusAll = widget.statusAll;
    List<Widget> list = statusMap.keys.toList().map((key) {
      var displayName = statusMap[key]!.displayName;
      var paramValue = statusMap[key]!.paramValue;
      bool isAll = displayName == statusMap[statusAll]!.displayName;
      return CheckboxListTile(
        title: Text(displayName),
        controlAffinity: ListTileControlAffinity.leading,
        value: isAll
            ? paramValue.split(",").toList().every(
                (item) => selectedStatus.any((element) => element == item))
            : selectedStatus.any((element) => element == paramValue),
        onChanged: (flag) {
          if (flag is bool && flag) {
            if (displayName == statusMap[statusAll]!.displayName) {
              paramValue.split(",").toList().forEach((element) {
                addSelected(element);
              });
            } else {
              addSelected(paramValue);
            }
          } else {
            if (displayName == statusMap[statusAll]!.displayName) {
              paramValue.split(",").toList().forEach((element) {
                removeSelected(element);
              });
            } else {
              removeSelected(paramValue);
            }
          }
        },
      );
    }).toList();
    return Column(
      children: list,
    );
  }
}

class PriceFilter extends StatefulWidget {
  final String? minPrice;
  final String? maxPrice;
  final void Function({String? minPrice, String? maxPrice}) onChange;

  const PriceFilter(
      {Key? key, this.minPrice, this.maxPrice, required this.onChange})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PriceFilterState();
}

class _PriceFilterState extends State<PriceFilter> {
  TextEditingController minController = TextEditingController();

  TextEditingController maxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.minPrice is String) {
      var currentOffset = minController.selection.base.offset;
      minController.text = widget.minPrice!;
      minController.selection = TextSelection.collapsed(offset: currentOffset);
    }
    if (widget.maxPrice is String) {
      var currentOffset = maxController.selection.base.offset;
      maxController.text = widget.maxPrice!;
      maxController.selection = TextSelection.collapsed(offset: currentOffset);
    }
    return Row(
      children: [
        Expanded(
          child: Padding(
              padding: EdgeInsets.all(12),
              child: TextField(
                onChanged: (value) {
                  String? nextMinPrice;
                  if (value.isNotEmpty) {
                    nextMinPrice = value;
                  }
                  widget.onChange(
                      minPrice: nextMinPrice, maxPrice: widget.maxPrice);
                },
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    hintText: "最小金额",
                    hintStyle: TextStyle(color: Colors.black26),
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Theme.of(context).primaryColor))),
                keyboardType: TextInputType.number,
                controller: minController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              )),
        ),
        const Text("~",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Expanded(
          child: Padding(
              padding: EdgeInsets.all(12),
              child: TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  String? nextMaxPrice;
                  if (value.isNotEmpty) {
                    nextMaxPrice = value;
                  }
                  widget.onChange(
                      minPrice: widget.minPrice, maxPrice: nextMaxPrice);
                },
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    hintText: "最大金额",
                    hintStyle: TextStyle(color: Colors.black26),
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Theme.of(context).primaryColor))),
                keyboardType: TextInputType.number,
                controller: maxController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              )),
        ),
      ],
    );
  }
}

enum paramObj {
  paramNameController,
  paramValueController,
}

class CustomFilter extends StatefulWidget {
  final Map<String, String> paramsMap;

  final void Function({required Map<String, String> paramsMap}) onChange;

  final void Function() resetComplete;

  final bool needReset;

  const CustomFilter({Key? key, required this.paramsMap, required this.onChange, required this.resetComplete, required this.needReset}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomFilter();
}

class _CustomFilter extends State<CustomFilter> {
  late List<String> paramNameList;
  late List<String> paramValueList;
  late List<Map<paramObj, TextEditingController>> controllerList;

  @override
  void initState() {
    super.initState();
    resetData();
  }

  @override
  didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.needReset) {
      resetData();
      widget.resetComplete();
    }
  }

  resetData() {
    controllerList = [];
    paramNameList = widget.paramsMap.keys.toList();
    paramValueList = widget.paramsMap.values.toList();
    for (var key in paramNameList) {
      controllerList.add({
        paramObj.paramNameController: TextEditingController(),
        paramObj.paramValueController: TextEditingController()
      });
    }
  }

  get paramsMap {
    Map<String, String> _map = {};
    List<MapEntry<String, String>> _mapEntrys = [];
    for (int i = 0; i < paramNameList.length; i++) {
      _mapEntrys.add(MapEntry(paramNameList[i], paramValueList[i]));
    }
    _map.addEntries(_mapEntrys);
    return _map;
  }

  push() {
    setState(() {
      paramNameList.add(getRandomString(8));
      paramValueList.add("");
      controllerList.add({
        paramObj.paramNameController: TextEditingController(),
        paramObj.paramValueController: TextEditingController()
      });
      widget.onChange(paramsMap: paramsMap);
    });
  }

  change(
      {required int index,
      required String nextParamName,
      required String nextParamValue}) {
    setState(() {
      paramNameList[index] = nextParamName;
      paramValueList[index] = nextParamValue;
      widget.onChange(paramsMap: paramsMap);
    });
  }

  delete({required int index}) {
    setState(() {
      paramNameList.removeAt(index);
      paramValueList.removeAt(index);
      controllerList.removeAt(index);
      widget.onChange(paramsMap: paramsMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listWidgets = [];
    for (var i = 0; i < paramNameList.length; i++) {
      var key = paramNameList[i];
      var value = paramValueList[i];
      var paramNameController = controllerList[i][paramObj.paramNameController];
      var paramValueController =
          controllerList[i][paramObj.paramValueController];
      var nameCurrentOffset = paramNameController!.selection.base.offset;
      var valueCurrentOffset = paramValueController!.selection.base.offset;
      paramNameController?.text = key;
      paramNameController?.selection = TextSelection.collapsed(offset: nameCurrentOffset);
      paramValueController?.text = value;
      paramValueController.selection = TextSelection.collapsed(offset: valueCurrentOffset);
      listWidgets.add(Row(
        children: [
          Flexible(
              flex: 4,
              child: Builder(
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.all(12),
                    child: TextFormField(
                      controller: paramNameController,
                      validator: (value) {
                        if (value is String && value.isNotEmpty) {
                          return null;
                        } else {
                          return "参数名不能为空";
                        }
                      },
                      // controller: paramNameController,
                      onChanged: (nextName) {
                        var result = Form.of(context)?.validate();
                        if (result is bool && result) {
                          change(
                              index: i,
                              nextParamName: nextName,
                              nextParamValue: paramValueList[i]);
                        }
                      },
                    ),
                  );
                },
              )),
          Flexible(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: TextFormField(
                  controller: paramValueController,
                  // controller: paramValueController,
                  onChanged: (nextValue) {
                    change(
                        index: i,
                        nextParamName: paramNameList[i],
                        nextParamValue: nextValue);
                  },
                ),
              )),
          Flexible(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () {
                  delete(index: i);
                },
              )),
        ],
      ));
    }
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("参数名",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        )),
                  ),
                )),
            Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("参数值",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        )),
                  ),
                )),
            Flexible(
                flex: 1,
                child: IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.transparent,
                  ),
                  onPressed: () {},
                )),
          ],
        ),
        Form(
          child: Column(
            children: listWidgets,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.add_box,
            color: Colors.green,
          ),
          onPressed: () {
            push();
          },
        )
      ],
    );
  }
}
