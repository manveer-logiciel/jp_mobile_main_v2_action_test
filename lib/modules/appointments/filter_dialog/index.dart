import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/clock_summary.dart';
import 'package:jobprogress/common/models/appointment/appointment_param.dart';
import 'package:jobprogress/common/models/appointment/appointment_result/appointment_result_options.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class AppointmentsFilterDialog extends StatelessWidget {
  const AppointmentsFilterDialog({
    required this.selectedFilters,
    required this.onApply,
    this.userList,
    this.appointmentResultList,
    super.key,});

  final List<UserModel>? userList;
  final List<AppointmentResultOptionsModel>? appointmentResultList;
  final AppointmentListingParamModel selectedFilters;
  final void Function(AppointmentListingParamModel params) onApply;

  @override
  Widget build(BuildContext context) {

    AppointmentsFilterController controller = Get.put(AppointmentsFilterController(selectedFilters, userList: userList, appointmentResultList: appointmentResultList));

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: JPSafeArea(
        child: GetBuilder<AppointmentsFilterController>(
            builder: (_) => AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Builder(
                builder: (context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [                       
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              JPText(
                                text: "filters".tr,
                                textSize: JPTextSize.heading3,
                                fontWeight: JPFontWeight.medium,
                              ),
                              JPTextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                color: JPAppTheme.themeColors.text,
                                icon: Icons.clear,
                                iconSize: 24,
                              ),
                            ],
                          ),
                        ),                            
                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(children: [
                            /// title filter
                            JPInputBox(
                              label: "title".tr,
                              type: JPInputBoxType.withLabel,
                              fillColor: JPAppTheme.themeColors.base,
                              hintText: 'title'.tr,
                              controller: controller.titleController,
                              onPressed: (){},
                               onChanged: (val) => controller.updateResetButtonDisable(),
                            ),
                          
                            const SizedBox(
                              height: 15,
                            ),
                            /// job id filter
                            JPInputBox(
                              label: "job_id".tr,
                              type: JPInputBoxType.withLabel,
                              fillColor: JPAppTheme.themeColors.base,
                              controller: controller.jobNumberController,
                              onPressed: () {},
                              onChanged: (val) => controller.updateResetButtonDisable(),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            /// job# filter                           
                            JPInputBox(
                              label: "job_#".tr,
                              type: JPInputBoxType.withLabel,
                              fillColor: JPAppTheme.themeColors.base,
                              controller: controller.jobAltIdController,
                              onPressed: () {},
                              onChanged: (val) => controller.updateResetButtonDisable(),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            /// location filter
                            JPInputBox(
                              label: "location".tr,
                              type: JPInputBoxType.withLabel,
                              fillColor: JPAppTheme.themeColors.base,
                              controller: controller.locationController,
                              onPressed: () {},
                              onChanged: (val) => controller.updateResetButtonDisable(),
                            ),
                          
                            const SizedBox(
                              height: 15,
                            ),

                            /// assigned to filter
                            JPInputBox(
                              label: "assigned_to".tr,
                              type: JPInputBoxType.withLabel,
                              fillColor: JPAppTheme.themeColors.base,
                              readOnly: true,
                              hintText: 'select'.tr,
                              controller: controller.assignedToController,
                              onPressed: () {
                                controller.filterByAssigneeTO();
                              },
                              onChanged: (val) => controller.updateResetButtonDisable(),
                              suffixChild: selectedFilters.canSelectOtherUser! ? const Padding(
                                  padding: EdgeInsets.only(right: 9),
                                  child: JPIcon(Icons.keyboard_arrow_down),
                              ) : null,
                              disabled: !selectedFilters.canSelectOtherUser!,
                            ),
                            /// duration type to filter
                            Visibility(
                              visible: controller.selectedDuration != DurationType.upcoming.toString(),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: JPInputBox(
                                  label: "date_to_filter_by".tr.capitalize!,
                                  type: JPInputBoxType.withLabel,
                                  fillColor: JPAppTheme.themeColors.base,
                                  readOnly: true,
                                  hintText: 'select'.tr,
                                  controller: controller.durationTypeController,
                                  onPressed: () {
                                    controller.filterByDurationType();
                                  },
                                  onChanged: (val) => controller.updateResetButtonDisable(),
                                  suffixChild: const Padding(
                                      padding: EdgeInsets.only(right: 9),
                                      child: JPIcon(Icons.keyboard_arrow_down))
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                           /// duration filter
                              JPInputBox(
                                label: "date_filter".tr.capitalize,
                                hintText: 'select'.tr,
                                type: JPInputBoxType.withLabel,
                                fillColor: JPAppTheme.themeColors.base,
                                readOnly: true,
                                onPressed: () {
                                  controller.showDurationSelector();
                                },
                                onChanged: (val) => controller.updateResetButtonDisable(),
                                controller: TextEditingController(text: SingleSelectHelper.getSelectedSingleSelectValue(controller.durationsList, controller.selectedDuration)),
                                suffixChild: controller.selectedDuration == DurationType.custom.toString() ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if(selectedFilters.startDate != null)
                                    JPButton(
                                      text: DateTimeHelper.convertHyphenIntoSlash(selectedFilters.startDate!),
                                      size: JPButtonSize.extraSmall,
                                      colorType: JPButtonColorType.lightGray,
                                      onPressed: () => controller.pickStartDate(),
                                    ),
                                    const JPText(text: ' - '),
                                    if(selectedFilters.endDate != null)
                                    JPButton(
                                      text: DateTimeHelper.convertHyphenIntoSlash(selectedFilters.endDate!),
                                      size: JPButtonSize.extraSmall,
                                      colorType: JPButtonColorType.lightGray,
                                      onPressed: () => controller.pickEndDate(),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ) : const Padding(
                                  padding: EdgeInsets.only(right: 9),
                                  child: JPIcon(Icons.keyboard_arrow_down),
                                ),
                              ),
                            const SizedBox(
                              height: 15,
                            ),
                            /// created by filter
                            JPInputBox(
                              label: "created_by".tr,
                              type: JPInputBoxType.withLabel,
                              fillColor: JPAppTheme.themeColors.base,
                              readOnly: true,
                              hintText: 'select'.tr,
                              controller: controller.createdByController,
                              onPressed: () {
                                controller.filterByCreatedBy();
                              },
                              onChanged: (val) => controller.updateResetButtonDisable(),
                              suffixChild: const Padding(
                                padding: EdgeInsets.only(right: 9),
                                child: JPIcon(Icons.keyboard_arrow_down))),
                          
                            const SizedBox(
                              height: 15,
                            ),
                            /// appointments result filter
                            JPInputBox(
                              label: "appointment_result".tr,
                              hintText: 'select'.tr,
                              type: JPInputBoxType.withLabel,
                              fillColor: JPAppTheme.themeColors.base,
                              readOnly: true,
                              controller:controller.appointmentResultController,
                              onPressed: () {
                                controller.filterByAppointmentresult(); 
                              },
                              onChanged: (val) => controller.updateResetButtonDisable(),
                              disabled: false,
                              suffixChild: const Padding(
                                padding: EdgeInsets.only(right: 9),
                                child: JPIcon(Icons.keyboard_arrow_down))),  
                                   
                            const SizedBox(
                              height: 15,
                            ),
                            /// include recurring
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                JPText(
                                  text: 'include_recurring'.tr.capitalize!,
                                  textSize: JPTextSize.heading4,
                                  textColor: JPAppTheme.themeColors.text,
                                ),
                                const SizedBox(width: 10),
                                JPToggle(
                                  value: controller.isExcludeRecurringSelected,
                                  onToggle: controller.onExcludeRecurringChanged,
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 15,
                            ),                     
                              ]
                            ),
                          ),
                        ),                            
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: JPResponsiveDesign.popOverButtonFlex,
                              child: JPButton(
                                text: 'reset'.tr,
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  controller.resetFilterKeys();                                    
                                },
                                disabled: controller.isResetButtonDisable,
                                fontWeight: JPFontWeight.medium,
                                size: JPButtonSize.small,
                                colorType: JPButtonColorType.lightGray,
                                textColor: JPAppTheme.themeColors.tertiary,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              flex: JPResponsiveDesign.popOverButtonFlex,
                              child: JPButton(
                                onPressed: () {
                                  controller.applyFilter();
                                  onApply(controller.filterKeys);
                                },
                                text: 'apply'.tr,
                                fontWeight: JPFontWeight.medium,
                                size: JPButtonSize.small,
                                colorType: JPButtonColorType.tertiary,
                                textColor: JPAppTheme.themeColors.base,
                              ),
                            ),
                           ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ),
      ),
    );
  }
}
