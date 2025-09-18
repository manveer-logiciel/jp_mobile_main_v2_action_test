import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/job/job_detail/update_duration/controller.dart';
import 'package:jp_mobile_flutter_ui/Button/index.dart';
import 'package:jp_mobile_flutter_ui/Button/size.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/font_family.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/font_weight.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_size.dart';
import 'package:jp_mobile_flutter_ui/InputBox/index.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';
import 'package:jp_mobile_flutter_ui/TextButton/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class DurationDialog extends StatelessWidget {
  final int jobId;
  final UpdateDurationController controller;
  final Function(String?)? updateDurationCallback;
  const DurationDialog({super.key,required this.jobId,required this.controller,this.updateDurationCallback});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: JPText(
                text: "update_job_duration".tr.toUpperCase(),
                fontWeight: JPFontWeight.medium,
                textSize: JPTextSize.heading3,
                textAlign: TextAlign.start,
              ),
            ),

            JPTextButton(
              isDisabled: controller.isUpdatingDurationStatus,
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
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              getTitle("days".tr),
              getspacer(),
              Expanded(
                flex: 30,
                child: JPInputBox(
                  padding: const EdgeInsets.all(5.0),
                  inputBoxController: controller.daysController,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                ),
              ),
              getspacer(),
              getTitle("hrs".tr.capitalizeFirst.toString()),
              getspacer(),
              Expanded(
                flex: 30,
                child: JPInputBox(
                  padding: const EdgeInsets.all(5.0),
                  onChanged: (value){
                    controller.update();
                  },
                  inputBoxController: controller.hoursController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(FormValidator.typeToFrequencyValidator('hour'), replacementString: controller.hoursController.text),
                  ],
                ),
              ),
              getspacer(),
              getTitle("mins".tr.capitalizeFirst.toString()),
              getspacer(),
              Expanded(
                flex: 30,
                child: JPInputBox(
                  padding: const EdgeInsets.all(5.0),
                  onChanged: (value){
                    controller.update();
                  },
                  inputBoxController: controller.minutesController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(FormValidator.typeToFrequencyValidator('minute'), replacementString: controller.minutesController.text),
                  ],
                ),
            ),
            ],
          )
        ),

        const SizedBox(
          height: 20,
        ),

        Align(
          alignment: Alignment.centerRight,
          child: JPText(
            text:'note_day_hours'.tr,
            fontFamily: JPFontFamily.montserrat,
            fontWeight: JPFontWeight.regular,
            textSize: JPTextSize.heading3,
            textAlign: TextAlign.end,
            textColor: JPAppTheme.themeColors.tertiary,
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        Align(
          alignment: Alignment.center,
          child: JPButton(
            text: controller.isUpdatingDurationStatus ? null : 'update'.tr.toUpperCase(),
            size: JPButtonSize.small,
            disabled: controller.isUpdatingDurationStatus,
            iconWidget: showJPConfirmationLoader(show: controller.isUpdatingDurationStatus),
            onPressed: () => controller.updateDuration(jobId,updateDurationCallback),
          ),
        ),
      ],
    );
    }

  Widget getTitle(String title){
    return JPText(
      text: title,
      fontFamily: JPFontFamily.montserrat,
      fontWeight: JPFontWeight.medium,
      textSize: JPTextSize.heading3,
      textAlign: TextAlign.start,
    );
  }

  Widget getspacer(){
    return  const SizedBox(
      width: 10,
    );
  }
}
