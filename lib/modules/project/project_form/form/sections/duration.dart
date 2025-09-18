import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:jobprogress/common/services/project/project_form/add_project.dart';
import 'package:jobprogress/modules/project/project_form/controller.dart';
import 'package:jp_mobile_flutter_ui/Icon/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/index.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import 'package:jp_mobile_flutter_ui/ToolTip/index.dart';

import '../../../../../core/utils/form/validators.dart';

class ProjectFormDuration extends StatefulWidget {
  const ProjectFormDuration({
    super.key,
    required this.controller,
    required this.isSaving,
  });

  final ProjectFormController controller;
  final bool isSaving;

  @override
  State<ProjectFormDuration> createState() => _ProjectFormDurationState();
}

class _ProjectFormDurationState extends State<ProjectFormDuration> {
  ProjectFormService get service => widget.controller.service;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///   Job Duration title
        Row(
          children: [
            JPText(
              text: 'project_duration'.tr,
            ),
            const SizedBox(
              width: 5,
            ),
            JPToolTip(
              message: "job_duration_tooltip".tr,
              child: JPIcon(
                Icons.info_outline,
                size: 20,
                color: JPAppTheme.themeColors.primary,
              ),
            )
          ],
        ),

        const SizedBox(
          height: 10,
        ),

        ///   Job Duration Fields
        Row(
          children: [
            Expanded(
              child: JPInputBox(
                inputBoxController: service.projectDurationDayController,
                fillColor: JPAppTheme.themeColors.base,
                hintText: 'days'.tr,
                keyboardType: TextInputType.number,
                disabled: widget.isSaving,
                onChanged: onValueChanged,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(
                      FormValidator.typeToFrequencyValidator('day'),
                      replacementString:
                          service.projectDurationDayController.text),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: JPInputBox(
                inputBoxController: service.projectDurationHourController,
                fillColor: JPAppTheme.themeColors.base,
                hintText: 'hours'.tr,
                disabled: widget.isSaving,
                keyboardType: TextInputType.number,
                onChanged: onValueChanged,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(
                      FormValidator.typeToFrequencyValidator('hour'),
                      replacementString:
                          service.projectDurationHourController.text),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: JPInputBox(
                inputBoxController: service.projectDurationMinController,
                fillColor: JPAppTheme.themeColors.base,
                hintText: 'minutes'.tr,
                disabled: widget.isSaving,
                keyboardType: TextInputType.number,
                onChanged: onValueChanged,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(
                      FormValidator.typeToFrequencyValidator('minute'),
                      replacementString:
                          service.projectDurationMinController.text),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  void onValueChanged(String val) {
    setState(() {});
    widget.controller.onDataChanged(val);
  }
}
