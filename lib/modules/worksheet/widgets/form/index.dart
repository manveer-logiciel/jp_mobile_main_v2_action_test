import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_worksheet.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/modules/worksheet/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class WorksheetFormDetails extends StatelessWidget {

  const WorksheetFormDetails({
    super.key,
    required this.controller
  });

  final WorksheetFormController controller;

  WorksheetFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 18),
      width: double.infinity,
      decoration: BoxDecoration(color: JPAppTheme.themeColors.base, borderRadius: BorderRadius.circular(18)),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JPText(
              text: controller.typeToTitle.toUpperCase(),
              fontWeight: JPFontWeight.medium,
              textSize: JPTextSize.heading4,
            ),
            Padding(
              padding: EdgeInsets.only(top: controller.formUiHelper.verticalPadding),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: JPInputBox(
                      inputBoxController: service.titleController,
                      label: 'title'.tr.capitalize,
                      type: JPInputBoxType.withLabel,
                      fillColor: JPAppTheme.themeColors.base,
                      disabled: service.isSavingForm,
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    flex: 1,
                    child: JPInputBox(
                      inputBoxController: service.divisionController,
                      hintText: 'default'.tr.capitalize,
                      type: JPInputBoxType.withLabel,
                      label: 'division'.tr.capitalize,
                      fillColor: JPAppTheme.themeColors.base,
                      disabled: service.isSavingForm,
                      readOnly: true,
                      onPressed: service.selectDivision,
                      suffixChild: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: JPIcon(
                          Icons.keyboard_arrow_down_outlined,
                          color: JPAppTheme.themeColors.darkGray,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /// Supplier Branch
            if (!Helper.isValueNullOrEmpty(service.getSupplierDetails))
              Padding(
                padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator, bottom: 3),
                child: InkWell(
                  onTap: service.openSupplierSelector,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: JPText(
                          text: service.getSupplierDetails,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const JPIcon(Icons.edit_outlined, size: 18),
                    ],
                  ),
                ),
              ) 
            else 
              const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
