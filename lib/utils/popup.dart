import 'package:flutter/material.dart';

void showLoading(BuildContext context, String title) {
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

void showMessage({required BuildContext context,required String title, required void callback()}) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(title), duration: const Duration(milliseconds: 1500),))
      .closed.then((value) => callback());
}