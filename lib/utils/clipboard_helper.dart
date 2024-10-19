import 'package:flutter/services.dart';

class ClipboardHelper {
  static Future<bool> copyToClipboard(String s) async {
    try {
      await Clipboard.setData(ClipboardData(text: s));
      return true;
    } catch (e) {
      return false;
    }
  }
}
