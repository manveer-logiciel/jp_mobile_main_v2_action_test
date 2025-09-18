import 'package:get/get.dart';
import 'package:jobprogress/common/models/drawing_tool/drawing_tool_quick_action_params.dart';
import 'package:jobprogress/common/services/drawing_tool/index.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/event/add_events.dart';
import 'package:jobprogress/core/constants/mix_panel/event/edit_events.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'index.dart';

class AddViewSignatureDialogController extends GetxController {

  AddViewSignatureDialogController(this.onAddSignature);

  final Function(String)? onAddSignature;

  bool isLoading = false; // helps in managing loading state
  bool showHint = true; // use to hide/show hint

  JPDrawingToolController drawingToolController = JPDrawingToolController();

  @override
  void onInit() {
    setUpDrawingToolController();
    super.onInit();
  }

  // setUpDrawingToolController() : will setup background for signature and enables pen selection by default
  void setUpDrawingToolController() {
    drawingToolController = JPDrawingToolController(
      settings: JPDrawingToolController.defaultSignatureSettings(),
    );

    drawingToolController.background = JPAppTheme.themeColors.base.backgroundDrawable;
    drawingToolController.freeStyleMode = FreeStyleMode.draw;
  }

  void onClear() {
    for (var _ in drawingToolController.drawables) {
      drawingToolController.undo();
    }
    toggleShowHint(true);
    update();
  }

  Future<void> onDone() async {
    if(drawingToolController.drawables.isEmpty) {
      Helper.showToastMessage('please_add_your_signatures'.tr);
      return;
    }

    try {

      MixPanelService.trackEvent(event: MixPanelAddEvent.profileSignature);

      toggleIsLoading();

      String? result = await DrawingToolService.optionToAction(
          value: onAddSignature == null ? 'save_signature' : 'base64_string',
          actionParams: DrawingToolQuickActionParams(
              id: 0,
              aspectRatio: 1.4,
              drawingToolController: drawingToolController,
              rotationAngle: 0,
          )
      );

      await onAddSignature?.call(result ?? "");

    } catch (e) {
      rethrow;
    } finally {
      toggleIsLoading();
      Get.back();
    }
  }

  void onEdit() {
    Get.back();
    MixPanelService.trackEvent(event: MixPanelEditEvent.profileSignature);
    showJPGeneralDialog(
      child: (_) => const AddViewSignatureDialog(
        viewOnly: false,
      ),
    );
  }

  void toggleIsLoading() {
    isLoading = !isLoading;
    update();
  }

  void toggleShowHint(bool val) {
    showHint = val;
    update();
  }

}