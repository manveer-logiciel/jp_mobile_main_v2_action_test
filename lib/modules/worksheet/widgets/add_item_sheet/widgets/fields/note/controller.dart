import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/position.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../../global_widgets/bottom_sheet/index.dart';

class WorksheetAddItemAddNoteFieldController extends GetxController {

  WorksheetAddItemAddNoteFieldController({this.noteText = ""});

  String noteText = "";

  void openNote(Function(String? note) callback) {
    final bool isEdit = noteText.isNotEmpty;
    Helper.hideKeyboard();
    showJPGeneralDialog(
        child: (_) {
        return JPQuickEditDialog(
          title: isEdit ? 'update_note'.tr.toUpperCase() : 'add_note'.tr.toUpperCase(),
          label: 'note'.tr,
          hintText: 'line_note_hint'.tr,
          maxLength: 500,
          position: JPQuickEditDialogPosition.center,
          type: JPQuickEditDialogType.textArea,
          fillValue: noteText,
          suffixTitle: isEdit ? 'update'.tr : 'save'.tr,
          prefixTitle: 'cancel'.tr.toUpperCase(),
          onPrefixTap: (value) => Get.back(),
          onSuffixTap: (value) {
            noteText = value.trim();
            callback.call(value.trim());
            update();
            Get.back();
          }
        );
      }
    );
  }
}