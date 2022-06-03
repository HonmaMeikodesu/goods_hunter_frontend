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

class _ToastPopup extends StatefulWidget {
  final Color containerBgColor;
  final Icon icon;
  final Color textColor;
  final String content;
  const _ToastPopup({Key? key, required this.content, required this.containerBgColor, required this.icon, required this.textColor}): super(key: key);

  @override
  State<StatefulWidget> createState() => _ToastPopupState();
}

class _ToastPopupState extends State<_ToastPopup> with TickerProviderStateMixin {

  late AnimationController controller;

  @override
  initState(){
    controller = AnimationController(
        vsync: this,
        duration: const Duration( milliseconds: 100),
    );
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      controller.forward();
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 80,
        right: 80,
        top: 20,
        child: SlideTransition(
          position: Tween(begin: Offset(0, -2), end: Offset(0, 0)).animate(controller),
          child: Container(
            height: 48,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.containerBgColor,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Flex(
              mainAxisSize: MainAxisSize.min,
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.icon,
                DefaultTextStyle(
                  style: TextStyle(color: widget.textColor),
                  child: Text(widget.content),
                )
              ],
            ),
          ),
        )
    );
  }
}

void showToast({required BuildContext context, required String content, toastType type = toastType.success, required int closeAfter}) {
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
  OverlayState? overlayContainer = Overlay.of(context);
  if ( overlayContainer is OverlayState ) {
    OverlayEntry dialog = OverlayEntry(
        builder: (context) {
      return _ToastPopup(content: content, containerBgColor: containerBgColor, icon: icon, textColor: textColor);
    });
    overlayContainer.insert(dialog);
    if (closeAfter is int) {
      Future.delayed(Duration(seconds: closeAfter), () {
        dialog.remove();
      });
    }
  } else {
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
          position: anim1.drive(Tween(begin: Offset(0, -1), end: Offset(0, 0.01)).chain(CurveTween(curve: Curves.bounceIn))),
          child: child,
        );
      },
    );
  }
}

void showMessage({required BuildContext context,required String title, required void callback()}) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(title), duration: const Duration(milliseconds: 1500),))
      .closed.then((value) => callback());
}
