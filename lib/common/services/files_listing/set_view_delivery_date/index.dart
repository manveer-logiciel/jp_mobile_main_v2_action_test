import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/services/files_listing/set_view_delivery_date/controller.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class SetViewDeliveryDateDialog extends StatelessWidget {

  const SetViewDeliveryDateDialog(
      {super.key,
      required this.fileParams,
      required this.action,
      this.materialList,
      this.isSRSOrder = false
      });

  final FilesListingQuickActionParams fileParams;
  final FLQuickActions action;
  final List<JPSingleSelectModel>? materialList;

  final bool isSRSOrder;

  String get noteText => isSRSOrder ? 'note_for_internal_reference'.tr : 'note'.tr;

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: GetBuilder<SetViewDeliveryDateController>(
          init: SetViewDeliveryDateController(fileParams, action, materialList, isSRSOrder),
          global: false,
          builder: (SetViewDeliveryDateController controller) => Padding(
            padding: const EdgeInsets.all(10),
            child: Builder(builder: (context) {
              return Form(
                key: controller.formKey,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: JPColor.white,
                  ),
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(16),
                  child: actionToDialogContent(controller),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget titleAndSubtitle(
          {String title = '',
          String subTitle = '',
          IconData? icon,
          VoidCallback? onTapIcon}) =>
      Visibility(
        visible: subTitle.isNotEmpty,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    JPText(
                      text: title,
                      textSize: JPTextSize.heading4,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    JPText(
                      text: subTitle,
                      textSize: JPTextSize.heading5,
                      textColor: JPAppTheme.themeColors.darkGray,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Material(
                    color: JPAppTheme.themeColors.lightBlue,
                    borderRadius: BorderRadius.circular(6),
                    child: InkWell(
                      onTap: onTapIcon,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: JPIcon(
                          icon,
                          color: JPAppTheme.themeColors.primary,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      );

  Widget actionToDialogContent(SetViewDeliveryDateController controller) {
    switch (action) {
      case FLQuickActions.setDeliveryDate:
        return setDeliveryDate(controller);
      case FLQuickActions.viewDeliveryDate:
        return viewDeliveryDate(controller);
      case FLQuickActions.placeSRSOrder:
        return setDeliveryDate(controller);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget setDeliveryDate(SetViewDeliveryDateController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: JPText(
                text: controller.getTitle(),
                fontFamily: JPFontFamily.montserrat,
                fontWeight: JPFontWeight.medium,
                textSize: JPTextSize.heading3,
                textAlign: TextAlign.start,
              ),
            ),
            JPButton(
              text: controller.isUpdatingDeliveryDateStatus
                  ? ""
                  : 'Save'.tr.toUpperCase(),
              size: JPButtonSize.extraSmall,
              disabled: controller.isUpdatingDeliveryDateStatus,
              iconWidget: showJPConfirmationLoader(
                  show: controller.isUpdatingDeliveryDateStatus),
              onPressed: () {
                controller.updateDeliveryDate();
              },
            ),
            const SizedBox(
              width: 10,
            ),
            JPTextButton(
              isDisabled: controller.isUpdatingDeliveryDateStatus,
              icon: Icons.close,
              color: JPAppTheme.themeColors.text,
              iconSize: 22,
              padding: 2,
              onPressed: () {
                controller.cancelOnGoingApiRequest();
                Get.back();
                controller.onCancelEditDeliveryDateDialog();
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
            isRequired: true,
            label: 'material_delivery_date'.tr,
            hintText: 'MM/DD/YYYY',
            controller: controller.materialDateController,
            readOnly: true,
            type: JPInputBoxType.withLabel,
            fillColor: JPAppTheme.themeColors.base,
            onPressed: () {
              controller.pickDate();
            },
            validator: (val) {
              return controller.validateExpiresOn(val);
            },
            suffixChild: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    controller.pickDate();
                  },
                  icon: JPIcon(
                    Icons.calendar_today_outlined,
                    size: 20,
                    color: JPAppTheme.themeColors.secondaryText,
                  ),
                )
              ],
            ),
            onChanged: (val) {
              controller.validateForm();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: JPInputBox(
            label: noteText,
            hintText: 'write_a_note'.tr,
            type: JPInputBoxType.withLabel,
            fillColor: JPAppTheme.themeColors.base,
            controller: controller.noteController,
            maxLength: 500,
            maxLines: 4,
            validator: (val) {
              return '';
            },
          ),
        ),
        if(materialList?.isNotEmpty ?? false) ...{
          const SizedBox(
            height: 10,
          ),
          Transform.translate(
            offset: const Offset(-5, 0),
            child: JPCheckbox(
              selected: controller.isMaterialSheetLinked,
              onTap: controller.toggleIsMaterialSheetLinked,
              padding: EdgeInsets.zero,
              borderColor: JPAppTheme.themeColors.themeGreen,
              text: 'link_material_worksheet'.tr,
              separatorWidth: 4,
            ),
          ),
          Visibility(
            visible: controller.isMaterialSheetLinked,
            child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: JPInputBox(
              label: 'material_list_name'.tr,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              controller: controller.linkedListNameController,
              maxLines: 1,
              readOnly: true,
              onPressed: controller.selectMaterialList,
              suffixChild: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8
                ),
                child: JPIcon(Icons.keyboard_arrow_down_outlined, color: JPAppTheme.themeColors.secondaryText,),
              ),
              validator: (val) {
                return '';
              },
            ),
          ),
          ),

        }
      ],
    );
  }

  Widget viewDeliveryDate(SetViewDeliveryDateController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: JPText(
                text: 'view_delivery_date'.tr,
                fontFamily: JPFontFamily.montserrat,
                fontWeight: JPFontWeight.medium,
                textSize: JPTextSize.heading3,
                textAlign: TextAlign.start,
              ),
            ),
            if(!controller.isPastDeliveryDate)
              JPButton(
                text: 'edit'.tr.toUpperCase(),
                size: JPButtonSize.extraSmall,
                onPressed: () {
                  controller.onTapEdit();
                },
              ),
              const SizedBox(
                width: 10,
              ),
            JPTextButton(
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
        titleAndSubtitle(
            title: 'material_delivery_date'.tr,
            subTitle: DateTimeHelper.convertHyphenIntoSlash(
                controller.deliveryDate?.deliveryDate ?? '')),
        titleAndSubtitle(
            title: noteText,
            subTitle: controller.deliveryDate?.note ?? ''),
        if (fileParams.fileList.isNotEmpty) ...{
          titleAndSubtitle(
              title: 'linked_material_worksheet'.tr,
              subTitle: fileParams.fileList.first.name ?? '',
              icon: Icons.remove_red_eye_outlined,
              onTapIcon: controller.typeToOpenFile),
        }
      ],
    );
  }
}