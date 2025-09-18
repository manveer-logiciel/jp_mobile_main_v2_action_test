import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/files_listing/instant_photo_gallery_filter.dart';
import 'package:jobprogress/global_widgets/custom_date_dialog/controller.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CustomDateDialog extends StatelessWidget {
   const CustomDateDialog({super.key, required this.selectedFilters, required this.onApply, required this.onBack});

  final InstantPhotoGalleryFilterModel selectedFilters;
  final void Function(InstantPhotoGalleryFilterModel params) onApply;
  final void Function() onBack;
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomDateController(selectedFilters));

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: JPSafeArea(
        child: GetBuilder<CustomDateController>(
            builder: (_) => AlertDialog(
              scrollable: true,
              insetPadding: const EdgeInsets.only(left: 10, right: 10),
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Builder(
                builder: (context) {
                  return Container(
                    width: Get.width,
                    padding: const EdgeInsets.only(
                        right: 16, top: 20, bottom: 16),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.only(bottom: 10, left: 16),
                            child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  JPText(
                                    text: "select_date".tr.toUpperCase(),
                                    textSize: JPTextSize.heading3,
                                    fontWeight: JPFontWeight.medium,
                                  ),
                                  JPTextButton(
                                    onPressed: () {
                                    onBack();
                                    Get.back();
                                    },
                                    color: JPAppTheme.themeColors.text,
                                    icon: Icons.clear,
                                    iconSize: 24,
                                  )
                                ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: JPInputBox(
                              label: 'start_date'.tr,
                              maxLength: 50,
                              hintText: 'MM/DD/YYYY',
                              type: JPInputBoxType.withLabel,
                              fillColor: JPAppTheme.themeColors.base,
                              readOnly: true,
                              controller: controller.startDateController,
                              onPressed: () {
                                controller.pickStartDate(); 
                              },
                              validator:(value)=> controller.validateStartDate(value),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                           Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: JPInputBox(
                              label: 'end_date'.tr,
                              maxLength: 50,
                              hintText: 'MM/DD/YYYY',
                              type: JPInputBoxType.withLabel,
                              fillColor: JPAppTheme.themeColors.base,
                              readOnly: true,
                              controller: controller.endDateController,
                              onPressed: () {
                                controller.pickEndDate();
                                 
                              },
                              validator:(value)=> controller.validateEndDate(value),
                              ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 16, left: 16),
                            child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: JPButton(
                                      disabled: controller.isResetButtonDisable(),
                                      text: 'reset'.tr,
                                      onPressed: () {
                                       controller.reset();
                                      },
                                      fontWeight: JPFontWeight.medium,
                                      size: JPButtonSize.small,
                                      colorType:
                                      JPButtonColorType.lightGray,
                                      textColor:
                                      JPAppTheme.themeColors.tertiary,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    flex: 1,
                                    child: JPButton(
                                      onPressed: () {
                                        if(!controller.validateForm()) {
                                          controller.isValidate = true;
                                        }
                                        else {
                                          controller.saveData();
                                          onApply(controller.filterKey);
                                          Get.back();  
                                        }   
                                      },
                                      text:'apply'.tr,
                                      fontWeight: JPFontWeight.medium,
                                      size: JPButtonSize.small,
                                      colorType: JPButtonColorType.tertiary,
                                      textColor:
                                      JPAppTheme.themeColors.base,
                                     
                                    ),
                                  )
                                ]
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )),
      ),
    );
  }
}
