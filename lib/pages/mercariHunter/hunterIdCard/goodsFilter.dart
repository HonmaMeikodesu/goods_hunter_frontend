import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../utils/const.dart';

class StatusFilter extends StatefulWidget {
  final String? paramValue;

  final void Function(String paramValue)? onChange;

  final Enum statusAll;

  final Map<dynamic, StatusValue> statusMap;

  const StatusFilter({Key? key, this.paramValue, this.onChange, required this.statusAll, required this.statusMap}): super(key: key);

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
        value: isAll ? paramValue.split(",").toList().every((item) => selectedStatus.any((element) => element == item)) : selectedStatus.any((element) => element == paramValue),
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

  const PriceFilter({Key? key, this.minPrice, this.maxPrice}): super(key: key);

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
    minController.text = minPrice ?? "";
    maxController.text = maxPrice ?? "";
    return Container(
      height: 60,
      child: Row(
        children: [
          Expanded(child: TextField(
            keyboardType: TextInputType.number,
            controller: minController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),),
          Text("~", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Expanded(child: TextField(
            keyboardType: TextInputType.number,
            controller: maxController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          )) ,
        ],
      ),
    );
  }
}