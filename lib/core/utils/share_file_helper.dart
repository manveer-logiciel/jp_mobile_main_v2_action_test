import 'dart:typed_data';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:printing/printing.dart';

class ShareFileHelper {

  //Sharing files to other apps(Sms, gmail)
  static shareFile(String filePath) async {
    Uint8List bytes = await FileHelper.readFileAsByte(filePath);

    String fileName = FileHelper.getFileName(filePath);
    await Printing.sharePdf(bytes: bytes, filename: fileName);
  }

}
