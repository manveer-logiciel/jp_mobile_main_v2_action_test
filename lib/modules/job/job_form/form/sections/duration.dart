
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/job/job_form/add_job.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/modules/job/job_form/controller.dart';
import 'package:jp_mobile_flutter_ui/ToolTip/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFormDuration extends StatefulWidget {
  const JobFormDuration({
    super.key,
    required this.controller
  });

  final JobFormController controller;

  @override
  State<JobFormDuration> createState() => _JobFormDurationState();
}

class _JobFormDurationState extends State<JobFormDuration> {
  JobFormService get service => widget.controller.service;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        ///   Job Duration title
        Row(
          children: [
            JPText(
                text: 'job_duration'.tr,
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
                key: const Key(WidgetKeys.jobDaysDuration),
                inputBoxController: service.jobDurationDayController,
                fillColor: JPAppTheme.themeColors.base,
                hintText: 'days'.tr,
                keyboardType: TextInputType.number,
                disabled: widget.controller.isSavingForm,
                onChanged: onValueChanged,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(FormValidator.typeToFrequencyValidator('day'),
                      replacementString: service.jobDurationDayController.text),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: JPInputBox(
                key: const Key(WidgetKeys.jobHoursDuration),
                inputBoxController: service.jobDurationHourController,
                fillColor: JPAppTheme.themeColors.base,
                hintText: 'hours'.tr,
                disabled: widget.controller.isSavingForm,
                keyboardType: TextInputType.number,
                onChanged: onValueChanged,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(FormValidator.typeToFrequencyValidator('hour'),
                      replacementString: service.jobDurationHourController.text),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: JPInputBox(
                key: const Key(WidgetKeys.jobMinutesDuration),
                inputBoxController: service.jobDurationMinController,
                fillColor: JPAppTheme.themeColors.base,
                hintText: 'minutes'.tr,
                disabled: widget.controller.isSavingForm,
                keyboardType: TextInputType.number,
                onChanged: onValueChanged,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(FormValidator.typeToFrequencyValidator('minute'),
                      replacementString: service.jobDurationMinController.text),
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
