import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/event/common_events.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'helpers.dart';

class PrintingHelper {

  //Printing files according to extension
  static printFile(String filePath) {
    String? ext = FileHelper.getFileExtension(filePath);

    switch (ext) {
      case 'pdf':
        printPdf(filePath);
        break;

      case 'jpeg':
      case 'png':
      case 'jpg':
        printImage(filePath);
        break;
      
      case 'txt':
        printText(filePath);
        break;

      default:
        Helper.showToastMessage('unsupported_file_for_print'.tr);
        break;
    }
    MixPanelService.trackEvent(event: MixPanelCommonEvent.print);
  }

  //For print pdf files(.pdf)
  static printPdf(String filePath) async {
    Uint8List bytes = await FileHelper.readFileAsByte(filePath);
    await Printing.layoutPdf(onLayout: (_) => bytes);
  }

  //For print image files(.jpeg, .jpg, .png)
  static printImage(String filePath) async {
    final doc = pw.Document();
    Uint8List bytes = await FileHelper.readFileAsByte(filePath);

    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Image(pw.MemoryImage(bytes));
        }
      )
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save());
  }

  //For print text files(.txt)
  static printText(String filePath) async {
    final doc = pw.Document();
    String text = await FileHelper.readFileAsString(filePath);

    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Text(text);
        }
      )
    ); 

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save());
  }
}