import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:multiple_result/multiple_result.dart';

class FileHelper {
  static Future<Result<File, String>> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );

    if (result != null) {
      return Success(File(result.files.single.path!));
    }
    return const Error("");
  }
}
