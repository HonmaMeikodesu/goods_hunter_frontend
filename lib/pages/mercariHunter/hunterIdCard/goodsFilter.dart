import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  const PriceFilter({Key? key, this.minPrice, this.maxPrice}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PriceFilterState();
}

class _PriceFilterState extends State<PriceFilter> {
  String? minPrice;

  String? maxPrice;

  TextEditingController minController = TextEditingController();

  TextEditingController maxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    minPrice = widget.minPrice;
    maxPrice = widget.maxPrice;
  }

  @override
  Widget build(BuildContext context) {
    if (minPrice is String) {
      minController.text = minPrice!;
    } else {
      minController.clear();
    }
    if (maxPrice is String) {
      maxController.text = maxPrice!;
    } else {
      maxController.clear();
    }
    return Row(
      children: [
        Expanded(
          child: Padding(
              padding: EdgeInsets.all(12),
              child: TextField(
                onChanged: (value) {
                  minPrice = value;
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
                  maxPrice = value;
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

  const CustomFilter({Key? key, required this.paramsMap}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomFilter();
}

class _CustomFilter extends State<CustomFilter> {
  late Map<String, String> paramsMap;
  late List<Map<paramObj, TextEditingController>> controllerList;
  late List<GlobalKey<FormState>> formKeyList;

  @override
  void initState() {
    super.initState();
    controllerList = [];
    paramsMap = {};
    formKeyList = [];
    refreshData(widget.paramsMap);
  }

  refreshData(Map<String, String> newParamsMap) {
    setState(() {
      paramsMap = newParamsMap;
      paramsMap.keys.toList().forEach((key) {
        controllerList.add({
          paramObj.paramNameController: TextEditingController(),
          paramObj.paramValueController: TextEditingController()
        });
        formKeyList.add(GlobalKey());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int idx = 0;
    var listWidgets = paramsMap.keys.toList().map((key) {
      int index = idx;
      idx = idx + 1;
      var key = paramsMap.keys.toList()[index];
      var paramNameController =
          controllerList[index][paramObj.paramNameController];
      var paramValueController =
          controllerList[index][paramObj.paramValueController];
      paramNameController?.text = key;
      var value = paramsMap![key];
      if (value is String) {
        paramValueController?.text = value;
      }
      return Form(
          key: formKeyList[index],
          child: Row(
            children: [
              Flexible(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: TextFormField(
                      validator: (value) {
                        if (value is String && value.isNotEmpty) {
                          return null;
                        } else {
                          return "参数名不能为空";
                        }
                      },
                      controller: paramNameController,
                      onChanged: (value) {
                        var result =
                            formKeyList[index].currentState?.validate();
                        if (result is bool && result) {
                          var newParamsMap = {...paramsMap};
                          String prevValue = newParamsMap[key]!;
                          newParamsMap.remove(key);
                          newParamsMap[value] = prevValue;
                          refreshData(newParamsMap);
                        }
                      },
                    ),
                  )),
              Flexible(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: TextFormField(
                      controller: paramValueController,
                      onChanged: (value) {
                        var newParamsMap = {...paramsMap};
                        newParamsMap[key] = value;
                        refreshData(newParamsMap);
                      },
                    ),
                  )),
              Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.delete_outline),
                    onPressed: () {
                      var newParamsMap = {...paramsMap};
                      newParamsMap.remove(key);
                      refreshData(newParamsMap);
                    },
                  )),
            ],
          ));
    });
    return Column(
      children: [
        ...listWidgets,
        IconButton(
          icon: Icon(
            Icons.add_box,
            color: Colors.green,
          ),
          onPressed: () {
            var newParamsMap = {...paramsMap};
            newParamsMap.addEntries([MapEntry(getRandomString(8), "")]);
            print(newParamsMap);
            refreshData(newParamsMap);
          },
        )
      ],
    );
  }
}
