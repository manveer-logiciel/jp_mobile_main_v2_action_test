import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class SnippetDetailDialogController extends GetxController {
  copyText(String msg, String text) async {
    String htmlFreeText = Helper.parseHtmlToText(text);
    Helper.copyToClipBoard(htmlFreeText).whenComplete(() {
      Helper.showToastMessage(msg);
    });
    Get.back(result: true);
  }
}
