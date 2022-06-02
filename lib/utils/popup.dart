import 'package:flutter/material.dart';

void showLoading({required BuildContext context, required String title}) {
  showDialog(context: context, barrierDismissible: false, builder: (context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(top: 26.0),
            child: Text(title),
          )
        ],
      ),
    );
  });
}

enum toastType {
  success,
  error,
}

void showToast({required BuildContext context, required String content, toastType type = toastType.success, int? closeAfter}) {
  Icon icon;
  Color containerBgColor;
  Color textColor;
  switch (type) {
    case toastType.success:
      icon = Icon(Icons.check_circle, color: Colors.green);
      containerBgColor = Color.fromRGBO(162, 238, 166, 0.8);
      textColor = Colors.black;
      break;
    case toastType.error:
      icon = Icon(Icons.error, color: Colors.red);
      containerBgColor = Color.fromRGBO(248, 148, 139, 0.8);
      textColor = Colors.black87;
  }
  showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (pageBuildercontext, anim1, anim2) {
          if (closeAfter is int) {
            Future.delayed(Duration(seconds: closeAfter), () {
                Navigator.of(context).maybePop();
            });
          }
          return SafeArea(child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: containerBgColor,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Flex(
                mainAxisSize: MainAxisSize.min,
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  DefaultTextStyle(
                    style: TextStyle(color: textColor),
                    child: Text(content),
                  )
                ],
              ),
            ),
          ));
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, -1), end: Offset(0, 0.01)).chain(CurveTween(curve: Curves.bounceIn)).animate(anim1),
          child: child,
        );
      },
  );
}

void showMessage({required BuildContext context,required String title, required void callback()}) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(title), duration: const Duration(milliseconds: 1500),))
      .closed.then((value) => callback());
}
