import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../global_widgets/loader/index.dart';
import '../../../../global_widgets/safearea/safearea.dart';
import 'controller.dart';

class UpdateMaterialPODialog extends StatelessWidget {
  final int jobId;
  final String materialPO;
  final Function(String?)? updateMaterialPOCallback;
  const UpdateMaterialPODialog({super.key,required this.jobId,required this.materialPO,this.updateMaterialPOCallback});

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: GetBuilder<UpdateMaterialPOController>(
          init: UpdateMaterialPOController(materialPO),
          global: false,
          builder: (UpdateMaterialPOController controller) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: JPColor.white,
            ),
            padding: const EdgeInsets.all(16),
            child: _updateMaterialPOWidget(controller),
          ),
        ),
      ),
    );
  }

  Widget _updateMaterialPOWidget(UpdateMaterialPOController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: JPText(
                text: "update_material_po".tr,
                fontFamily: JPFontFamily.montserrat,
                fontWeight: JPFontWeight.medium,
                textSize: JPTextSize.heading3,
                textAlign: TextAlign.start,
              ),
            ),

            JPTextButton(
              isDisabled: controller.isUpdatingMaterialPOStatus,
              icon: Icons.close,
              color: JPAppTheme.themeColors.text,
              iconSize: 22,
              padding: 2,
              onPressed: () {
                Get.back();
              },
            )
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: JPInputBox(
            label: 'purchase_order_number'.tr,
            hintText: 'purchase_order_number'.tr,
            type: JPInputBoxType.withLabel,
            fillColor: JPAppTheme.themeColors.base,
            controller: controller.materialPOController,
            validator: (val) {
              return '';
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: JPButton(
            text: controller.isUpdatingMaterialPOStatus ? null : 'update'.tr,
            size: JPButtonSize.small,
            disabled: controller.isUpdatingMaterialPOStatus,
            iconWidget: showJPConfirmationLoader(show: controller.isUpdatingMaterialPOStatus),
            onPressed: () => controller.updateMaterialPO(jobId,updateMaterialPOCallback),
          ),
        ),
      ],
    );
  }
}
