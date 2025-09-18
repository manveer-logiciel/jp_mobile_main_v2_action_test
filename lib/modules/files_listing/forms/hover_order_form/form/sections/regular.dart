
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/files_listing/forms/hover_order_form/index.dart';
import 'package:jobprogress/modules/files_listing/forms/hover_order_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class HoverOrderFormRegular extends StatelessWidget {
  const HoverOrderFormRegular({
    super.key,
    required this.controller
  });

  final HoverOrderFormController controller;

  Widget get inputFieldSeparator => SizedBox(
    height: controller.formUiHelper.inputVerticalSeparator,
    width: controller.formUiHelper.horizontalPadding,
  );

  HoverOrderFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JPText(
          text: "synch_on_hover".tr.toUpperCase(),
          fontWeight: JPFontWeight.medium,
          textColor: JPAppTheme.themeColors.darkGray,
        ),

        inputFieldSeparator,

        /// radio buttons for selecting request type
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 10,
          spacing: 10,
          children: [
            JPRadioBox(
              groupValue: service.withCaptureRequest,
              onChanged: service.updateHoverRequest,
              isTextClickable: true,
              radioData: [
                JPRadioData(
                    value: false,
                    label: 'as_regular'.tr,
                    disabled: controller.isSavingForm
                ),
              ],
            ),
            JPRadioBox(
              groupValue: service.withCaptureRequest,
              onChanged: service.updateHoverRequest,
              isTextClickable: true,
              radioData: [
                JPRadioData(
                    value: true,
                    label: 'with_capture_request'.tr,
                    disabled: controller.isSavingForm
                )
              ],
            )
          ],
        ),

        inputFieldSeparator,

        /// hover user
        JPInputBox(
          inputBoxController: service.usersController,
          label: 'hover_user'.tr,
          isRequired: true,
          disabled: controller.isSavingForm,
          type: JPInputBoxType.withLabel,
          fillColor: JPAppTheme.themeColors.base,
          readOnly: true,
          onPressed: service.selectHoverUser,
          suffixChild: Padding(
            padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.suffixPadding),
            child: JPIcon(
              Icons.expand_more,
              color: JPAppTheme.themeColors.text,
            ),
          ),
          onChanged: controller.onDataChanged,
          validator: (val) => service.validateUser(val),
        ),

        inputFieldSeparator,

        /// hover deliverable
        JPInputBox(
          inputBoxController: service.deliverableController,
          label: 'hover_deliverable'.tr,
          isRequired: true,
          disabled: controller.isSavingForm,
          type: JPInputBoxType.withLabel,
          fillColor: JPAppTheme.themeColors.base,
          readOnly: true,
          onPressed: service.selectHoverDeliverables,
          suffixChild: Padding(
            padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.suffixPadding),
            child: JPIcon(
              Icons.expand_more,
              color: JPAppTheme.themeColors.text,
            ),
          ),
          onChanged: controller.onDataChanged,
          validator: (val) => service.validateDeliverable(val),
        ),

      ],
    );
  }
}
