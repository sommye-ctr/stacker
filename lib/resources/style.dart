import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Style {
  static const Color primaryColor = Color.fromRGBO(87, 204, 153, 1);
  static const double stackTileImageRatio = 16 / 9;

  static void showLoadingDialog({
    required BuildContext context,
    String? text,
  }) {
    AwesomeDialog(
      context: context,
      autoDismiss: false,
      dismissOnBackKeyPress: false,
      dialogType: DialogType.noHeader,
      dialogBackgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: CircularProgressIndicator(),
          ),
          if (text != null)
            Text(
              text,
              textAlign: TextAlign.center,
            ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      useRootNavigator: true,
      onDismissCallback: (DismissType type) {},
    ).show();
  }

  static void dismisLoadingDialog({
    required BuildContext context,
  }) {
    Navigator.pop(context);
  }

  static void showToast(
      {required BuildContext context,
      required String text,
      bool long = false}) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: long ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      fontSize: 16.0,
    );
  }
}
