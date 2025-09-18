import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/phone/index.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/global_widgets/add_remove_icon/index.dart';
import 'package:jobprogress/global_widgets/forms/phone/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class PhoneFormTile extends StatelessWidget {
  const PhoneFormTile({
    super.key,
    required this.data,
    this.onDataChanged,
    this.onTapPhoneType,
    this.selectedPhoneType,
    this.canShowError = false,
    this.isDisabled = false,
    this.doShowPhoneBook = false,
    required this.index,
    required this.controller,
    this.label,
    required this.isRequired,
    required this.showSufixIcon,
  });

  final PhoneFormData data;
  final VoidCallback? onDataChanged;
  final VoidCallback? onTapPhoneType;
  final String? selectedPhoneType;
  final bool canShowError;
  final bool isDisabled;
  final bool doShowPhoneBook;
  final int index;
  final PhoneFormController controller;
  final String? label;
  final bool isRequired;
  final bool showSufixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: JPInputBox(
                inputBoxController: data.phoneController,
                extInputBoxController: data.phoneExtController,
                label: label ?? 'phone'.tr,
                hintText: PhoneMasking.maskedPlaceHolder,
                disabled: isDisabled,
                isRequired: isRequired,
                type: JPInputBoxType.withLabel,
                fillColor: JPAppTheme.themeColors.base,
                onChanged: (_) {
                    onDataChanged?.call();
                  },
                borderColor: (error != null && canShowError) ? JPAppTheme.themeColors.red : null,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    PhoneMasking.inputFieldMask()
                  ],
                maxLength: 20,
                isExtWidget: true,
                prefixIconConstraints: const BoxConstraints(
                  maxHeight: 40
                ),
                prefixChild: IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      JPTextButton(
                          onPressed: onTapPhoneType,
                          textSize: JPTextSize.heading5,
                          text: data.phoneTypes,
                          padding: 0,
                          isExpanded: false,
                          icon: Icons.keyboard_arrow_down_outlined
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                        color: JPAppTheme.themeColors.dimGray,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            if (showSufixIcon) getSuffixIcon()
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        if(error != null && canShowError)
          JPText(
          text: error!,
          textSize: JPTextSize.heading5,
          textColor: JPAppTheme.themeColors.red,
        ),
      ],
    );
  }

    Widget getSuffixIcon() {

         final addBtn = FormAddRemoveButton(onTap: controller.addPhoneField, isDisabled: isDisabled,doShowPhoneBook: doShowPhoneBook,);
         final removeBtn = FormAddRemoveButton(onTap: () => controller.removePhoneField(index), isDisabled: isDisabled, isAddBtn: false, doShowPhoneBook: doShowPhoneBook,);

        bool doShowAddBtn = index == controller.displayingPhoneField - 1 && index < controller.maxPhoneFields - 1 && controller.canBeMultiple;
        bool doShowRemoveBtn = index != 0 && index < controller.displayingPhoneField;

        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(doShowPhoneBook)...{
              const SizedBox(width: 7,),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: JPTextButton(
                  icon: Icons.contact_page_outlined,
                  iconSize: 24,
                  padding: 3,
                  onPressed: () => controller.fetchContactFromPhone(index),
                ),
              ),
            },
            if(doShowRemoveBtn)  removeBtn,
            if(doShowAddBtn)  addBtn
          ],
        );
      }

  String? get error => FormValidator.validatePhoneNumber(data.phoneController.text, errorMsg: 'phone_number_is_required'.tr, isRequired: isRequired);

}
