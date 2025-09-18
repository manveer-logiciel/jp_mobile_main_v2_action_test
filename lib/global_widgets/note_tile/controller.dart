import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/position.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../routes/pages.dart';
import '../bottom_sheet/index.dart';

class NoteTileController extends GetxController {

  NoteTileController({this.noteText = "", this.isWithSnippets = false});

  String noteText = "";
  bool isWithSnippets;

  void openJobNote(Function(String? note) callback) {
    final bool isEdit = noteText.isNotEmpty;
    Helper.hideKeyboard();
    showJPGeneralDialog(
      child: (_){
        return JPQuickEditDialog(
          title: isEdit ? 'update_note'.tr.toUpperCase() : 'add_note'.tr.toUpperCase(),
          label: 'note'.tr,
          fillValue: noteText,
          position: JPQuickEditDialogPosition.center,
          type: JPQuickEditDialogType.textArea,
          suffixTitle: isEdit ? 'update'.tr : 'save'.tr,
          prefixTitle: 'cancel'.tr.toUpperCase(),
          moreHeaderActions: [
            if(isWithSnippets)...{
              JPButton(
                text: 'snippets'.tr,
                type: JPButtonType.outline,
                size: JPButtonSize.extraSmall,
                onPressed: navigateToSnippets,
              ),
            }
          ],
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

  /////////////////////////     NAVIGATE TO SNIPPET     ////////////////////////

  void navigateToSnippets() => Get.toNamed(Routes.snippetsListing);

}