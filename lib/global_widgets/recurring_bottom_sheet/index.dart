import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/recurring.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/recurring_email.dart';
import 'package:jobprogress/core/constants/recurring_constant.dart';
import 'package:jobprogress/global_widgets/recurring_bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/recurring_bottom_sheet/widget/week_days.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class RecurringBottomSheet extends StatelessWidget {
  const RecurringBottomSheet({
    super.key,
    this.job,
    required this.onDone,
    required this.recurringEmaildata,
    this.type = RecurringType.salesAutomation,  
    this.defaultDurationValue,
    this.recurringText,
    this.recurringStartDate
  });

  final RecurringEmailModel recurringEmaildata;
  final JobModel? job;
  final Function onDone;
  final String? defaultDurationValue;
  final RecurringType? type;
  final String? recurringText;
  final String? recurringStartDate;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecurringBottomSheetController>(
        init: RecurringBottomSheetController(
          job, 
          recurringEmaildata,
          type,
          defaultDurationValue,
          recurringText,
          recurringStartDate
        ),
        builder: (RecurringBottomSheetController controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Container(
                    decoration: BoxDecoration(
                    borderRadius: JPResponsiveDesign.bottomSheetRadius,
                    color: JPAppTheme.themeColors.base,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: JPSafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                JPResponsiveBuilder(
                                  mobile: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 6),
                                        height: 4,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(2),
                                            color: JPAppTheme.themeColors.dimGray),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 14),
                                  child: JPText(
                                    text: 'recurring'.tr.toUpperCase(),
                                    textSize: JPTextSize.heading3,
                                    fontWeight: JPFontWeight.medium,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: JPText(
                                          text: '${'repeat'.tr.capitalize!} ${'every'.tr.capitalize!}'),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 30),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 78,
                                                  padding: const EdgeInsets.only(
                                                      right: 10),
                                                  child: JPInputBox(
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                    ],
                                                    onChanged: (value) {
                                                      controller.validateData(controller.durationCount.text, RecurringConstants.repeat);
                                                    }, 
                                                    borderColor: controller
                                                            .showRepeatValidateMessage
                                                        ? JPAppTheme
                                                            .themeColors.secondary
                                                        : null,
                                                    controller:
                                                        controller.durationCount,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    fillColor: JPColor.white,
                                                    type:
                                                        JPInputBoxType.withoutLabel,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(
                                                        right: 4, left: 5),
                                                    child: JPInputBox(
                                                      controller:
                                                          controller.duration,
                                                      onPressed: () => controller
                                                          .openSingleSelectForDuration(),
                                                      fillColor: JPAppTheme
                                                          .themeColors.base,
                                                      type: JPInputBoxType
                                                          .withoutLabel,
                                                      hintText: '',
                                                      readOnly: true,
                                                      suffixChild: const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Icon(
                                                            Icons
                                                                .keyboard_arrow_down,
                                                            size: 24),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Visibility(
                                              visible: controller.showRepeatValidateMessage,
                                              child: Container(
                                                width: double.infinity,
                                                margin: const EdgeInsets.only(top: 5),
                                                alignment: Alignment.bottomLeft,
                                                child: JPText(
                                                  textSize: JPTextSize.heading5,
                                                  text: 'enter_valid_value'.tr,
                                                  textColor: JPAppTheme.themeColors.secondary,
                                                )
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                if (controller.selectedDurationValue ==
                                    RecurringConstants.weekly) ...{
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: JPText(
                                        text: '${'repeat'.tr.capitalize!} ${'on'.tr}'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        for (int i = 0;i < controller.daysOfWeekList.length; i++)
                                          DayOfWeek(
                                            value: controller.daysOfWeekList[i].label,
                                            onTap: () {
                                              controller.toggleDayOfWeek(i);
                                            },
                                            isActive: controller.daysOfWeekList[i].isSelect,
                                          )
                                      ],
                                    ),
                                  ),
                                },
                                 (controller.selectedDurationValue ==
                                    RecurringConstants.monthly) ?
                                  (Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30, right: 4),
                                    child: JPInputBox(
                                      controller: controller.monthlyDuration,
                                      onPressed: () => controller.openSingleSelectForMonth(),
                                      fillColor: JPAppTheme.themeColors.base,
                                      type: JPInputBoxType.withoutLabel,
                                      hintText: '',
                                      readOnly: true,
                                      suffixChild: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.keyboard_arrow_down,
                                            size: 24),
                                      ),
                                    ),
                                  )) : const SizedBox.shrink(),

                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: JPText(text: 'ends'.tr.capitalize!),
                                ),

                               if(controller.type == RecurringType.salesAutomation) Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    runSpacing: 10,
                                    spacing: 10,
                                    children: [
                                      JPRadioBox(
                                        textColor: JPAppTheme.themeColors.tertiary,
                                        groupValue: controller.occuranceActive,
                                        onChanged: (value) {
                                          controller.toggleRadioButton(value);
                                        },
                                        activeColor: JPAppTheme.themeColors.themeGreen,
                                        radioData: [
                                          JPRadioData(
                                              value: false,
                                              label: '${'on'.tr.capitalize!} ${'completion'.tr} ${'of'.tr}  ${'stage'.tr.capitalize!}')
                                        ],
                                      ),
                                      
                                      InkWell(
                                        onTap: () {
                                          controller.openSingleSelectForStages();
                                        },
                                        child: Wrap(
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          children: [
                                            JPText(
                                              text: controller.selectedStageValue!,
                                              textColor:
                                                  controller.selectedStageColor!,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            const JPIcon(Icons.expand_more_outlined,
                                                size: 16)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              if(controller.type == RecurringType.appointment)    Padding(
                                  padding: const EdgeInsets.only(top: 23),
                                  child: JPRadioBox(
                                    textColor:
                                        JPAppTheme.themeColors.tertiary,
                                    groupValue: controller.occuranceNever,
                                    onChanged: (value) {
                                      controller.toggleNeverButton(value);
                                    },
                                    activeColor:
                                        JPAppTheme.themeColors.themeGreen,
                                    radioData: [
                                      JPRadioData(
                                          value: true,
                                          label: 'never'.tr.capitalize!)
                                    ],
                                  ),
                                ),
                              if (controller.type == RecurringType.appointment)  Padding(
                                      padding: const EdgeInsets.only(top: 23),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 14),
                                            child: JPRadioBox(
                                              textColor: JPAppTheme.themeColors.tertiary,
                                              groupValue: controller.occuranceOn,
                                              onChanged: (value) {
                                                controller.toggleOnButton(value);
                                              },
                                              activeColor:
                                                  JPAppTheme.themeColors.themeGreen,
                                              radioData: [
                                                JPRadioData(
                                                    value: true,
                                                    label: 'on'.tr.capitalize!)
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 50),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 120,
                                                  child: JPInputBox(
                                                      controller: controller.occuranceOnController,
                                                      disabled:!controller.occuranceOn,
                                                      type: JPInputBoxType.withoutLabel,
                                                      fillColor: JPAppTheme.themeColors.base,
                                                      readOnly: true,
                                                      onPressed:controller.openDatePicker,
                                                    ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),


                          Padding(
                            padding: const EdgeInsets.only(top: 23),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 14),
                                  child: JPRadioBox(
                                    textColor:
                                        JPAppTheme.themeColors.tertiary,
                                    groupValue: controller.occuranceActive,
                                    onChanged: (value) {
                                      controller.toggleRadioButton(value);
                                    },
                                    activeColor:
                                        JPAppTheme.themeColors.themeGreen,
                                    radioData: [
                                      JPRadioData(
                                          value: true,
                                          label: '${'after'.tr.capitalize!} ${'occurrence'.tr.capitalize!}')
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 68,
                                        child: JPInputBox(
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          onChanged: (value) {
                                            controller.validateData(controller.occuranceCount.text, RecurringConstants.occurrence);
                                            
                                          },
                                          borderColor: controller.showOccuranceValidateMessage 
                                              ? JPAppTheme.themeColors.secondary : null,
                                          keyboardType: TextInputType.number,
                                          disabled:!controller.occuranceActive,
                                          controller: controller.occuranceCount,
                                          fillColor: JPAppTheme.themeColors.base,
                                        ),
                                      ),
                                      Visibility(
                                        visible: controller.showOccuranceValidateMessage,
                                        child: Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(top: 5),
                                          alignment: Alignment.bottomLeft,
                                          child: JPText(
                                            textSize: JPTextSize.heading5,
                                            text: 'enter_valid_value'.tr,
                                            textColor: JPAppTheme.themeColors.secondary,
                                          )
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),

                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0, bottom: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: JPResponsiveDesign.popOverButtonFlex,
                                    child: JPButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      colorType: JPButtonColorType.lightGray,
                                      size: JPButtonSize.small,
                                      text: 'cancel'.tr.toUpperCase(),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    flex: JPResponsiveDesign.popOverButtonFlex,
                                    child: JPButton(
                                      onPressed: () {
                                        controller.saveData();
                                        if (controller.isDataValidate) {
                                          if(controller.type == RecurringType.salesAutomation) Get.back();
                                          onDone(controller.recurringEmailData);
                                        }
                                      },
                                      size: JPButtonSize.small,
                                      text: 'done'.tr.toUpperCase(),
                                    ),
                                  )
                                ],
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                  )),
            ),
          );
        });
  }
}