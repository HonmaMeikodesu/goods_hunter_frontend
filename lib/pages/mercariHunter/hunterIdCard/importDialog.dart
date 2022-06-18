import 'package:flutter/material.dart';

class ImportDialog extends StatefulWidget {
  final void Function(String url) onOk;

  const ImportDialog({Key? key, required this.onOk, this.previousUrl}) : super(key: key);

  final String? previousUrl;

  @override
  State<StatefulWidget> createState() => _ImportDialogState();
}

class _ImportDialogState extends State<ImportDialog> {

  bool urlValid = false;

  TextEditingController textFieldController = TextEditingController();

  initState() {
    super.initState();
    if (widget.previousUrl is String) {
      url = widget.previousUrl!;
      urlValid = true;
      textFieldController.text = url;
      textFieldController.selection = TextSelection(baseOffset: 0, extentOffset: url.length);
    }
  }

  late String url;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Text("请输入煤炉链接地址"),
          Padding(padding: EdgeInsets.only(left: 12)),
          Tooltip(
            child: Icon(Icons.help_outline, color: Colors.lightGreen),
            richMessage: TextSpan(children: [
              TextSpan(text: "例如:\n"),
              TextSpan(
                  text: "https://jp.mercari.com/search?keyword=anohana",
                  style: TextStyle(fontFamily: "caveat"))
            ]),
            triggerMode: TooltipTriggerMode.tap,
            showDuration: Duration(seconds: 10),
          )
        ],
      ),
      content: Form(
        child: Builder(builder: (context) {
          return TextFormField(
            autofocus: true,
            controller: textFieldController,
            onChanged: (value) {
              Form.of(context)?.validate();
              setState(() {
                url = value;
              });
            },
            validator: (value) {
              if (value is String) {
                final uri = Uri.tryParse(value);
                final isValid = uri != null && uri.scheme.startsWith('https') && uri.host == "jp.mercari.com";
                if (isValid) {
                  setState(() {
                    urlValid = true;
                  });
                  return null;
                }
              }
              setState(() {
                urlValid = false;
              });
              return "非法的链接格式";
            },
          );
        },),
      ),
      actions: [
        TextButton(onPressed: () {
          if (urlValid) {
            widget.onOk(url);
            Navigator.of(context).pop();
          }
        }, child: Text("确认")),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("取消"))
      ],
    );
  }
}
