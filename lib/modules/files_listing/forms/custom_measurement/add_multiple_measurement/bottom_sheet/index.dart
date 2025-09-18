
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_data.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/form_builder/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/add_multiple_measurement/controller.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/measurement_form/form/section/detail.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class EditMeasurementBottomSheet extends StatelessWidget {
  const EditMeasurementBottomSheet({
    super.key, 
    required this.controller, required this.index, 

  });
  
  final AddMultipleMeasurementController controller;
  final int index;
  @override
  Widget build(BuildContext context) {
    return JPWillPopScope(
      onWillPop:() => controller.onWillPopBottomSheet(MeasurementDataModel(attributes:controller.measurement.values![index])),
      child: GestureDetector(
        onTap: Helper.hideKeyboard,
        child: Material(
          color: JPColor.transparent,
          child: JPFormBuilder(
            onClose:()=> controller.onWillPopBottomSheet(MeasurementDataModel(attributes:controller.measurement.values![index])),
            backgroundColor: JPAppTheme.themeColors.base,
            inBottomSheet: true,
            title: 'update_measurement'.tr.toUpperCase(),
            titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            footerPadding: const EdgeInsets.symmetric(vertical: 16),
            form: Form(
              key: controller.formKey,
              child: MeasurementFormDetailsection(
                index: index,
                isEdit: false,
                isSavingForm: false, 
                isBottomSheet: true,
                validateForm:(val)=> controller.validateForm(),
                validateInputBox: controller.validateValue,
                measurement: MeasurementDataModel(attributes: controller.measurement.values![index]),
                controllerList: controller.controllerList,
              ),
            ),
            footer: JPButton(
              type: JPButtonType.solid,
              text: 'update'.tr.toUpperCase(),
              size: JPButtonSize.large,
              onPressed: (){
                controller.saveBottomSheetData(index);
              },
            ),
          ),
        )
      ),
    );
  }
}

