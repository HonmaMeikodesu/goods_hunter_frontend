import 'package:flutter/material.dart';
import '../../../utils/const.dart';

class GoodsStatusFilter extends StatefulWidget {
  final String? paramValue;

  final void Function(String paramValue)? onChange;

  const GoodsStatusFilter({Key? key, this.paramValue, this.onChange}): super(key: key);

  @override
  State<StatefulWidget> createState() => _GoodsStatusFilterState();
}

class _GoodsStatusFilterState extends State<GoodsStatusFilter> {
  
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
    List<Widget> list = GoodsStatusMap.keys.toList().map((key) {
      var displayName = GoodsStatusMap[key]!.displayName;
      var paramValue = GoodsStatusMap[key]!.paramValue;
      bool isAll = displayName == GoodsStatusMap[GoodsStatus.all]!.displayName;
      return CheckboxListTile(
        title: Text(displayName),
        controlAffinity: ListTileControlAffinity.leading,
        value: isAll ? paramValue.split(",").toList().every((item) => selectedStatus.any((element) => element == item)) : selectedStatus.any((element) => element == paramValue),
        onChanged: (flag) {
          if (flag is bool && flag) {
            if (displayName == GoodsStatusMap[GoodsStatus.all]!.displayName) {
              paramValue.split(",").toList().forEach((element) {
                addSelected(element);
              });
            } else {
              addSelected(paramValue);
            }
          } else {
            if (displayName == GoodsStatusMap[GoodsStatus.all]!.displayName) {
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