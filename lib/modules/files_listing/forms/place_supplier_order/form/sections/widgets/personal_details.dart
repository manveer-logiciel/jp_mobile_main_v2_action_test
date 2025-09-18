
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/address_form_type.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/form_builder/index.dart';
import 'package:jobprogress/global_widgets/forms/address/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../../global_widgets/forms/phone/index.dart';

class PersonalDetailsForm extends StatelessWidget {
  const PersonalDetailsForm({
    super.key,
    required this.controller,
  });

  final PlaceSupplierOrderFormController controller;

  PlaceSupplierOrderFormService get service => controller.service;

  Widget get inputFieldSeparator => SizedBox(height: controller.formUiHelper.inputVerticalSeparator);
  EdgeInsets get horizonalPadding => EdgeInsets.symmetric(horizontal: controller.formUiHelper.verticalPadding);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: JPWillPopScope(
        onWillPop: controller.onWillPopPersonalDetails,
        child: Material(
          color: JPColor.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: JPFormBuilder(
              title: 'personal_details'.tr.toUpperCase(),
              onClose: controller.onWillPopPersonalDetails,
              backgroundColor: JPAppTheme.themeColors.base,
              inBottomSheet: true,
              form: Form(
                key: controller.personalDetailsFormKey,
                child: Material(
                  color: JPAppTheme.themeColors.base,
                  borderRadius: BorderRadius.circular(controller.formUiHelper.sectionBorderRadius),
                  child: Padding(
                    padding: horizonalPadding,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        JPInputBox(
                          inputBoxController: service.nameController,
                          label: 'name'.tr,
                          type: JPInputBoxType.withLabel,
                          fillColor: JPAppTheme.themeColors.base,
                          isRequired: true,
                          validator: (val) => FormValidator.requiredFieldValidator(val),
                        ),
                        inputFieldSeparator,
                        if(controller.service.type == MaterialSupplierType.abc) ...{
                          PhoneForm(
                            key: controller.phoneFormKey,
                            phoneField: [service.phoneField!],
                            isDisabled: controller.isSavingForm,
                            isRequired: true,
                            canBeMultiple: false,
                          )
                        } else ...{
                          JPInputBox(
                            inputBoxController: service.phoneController,
                            label: 'phone'.tr,
                            hintText: PhoneMasking.maskedPlaceHolder,
                            type: JPInputBoxType.withLabel,
                            fillColor: JPAppTheme.themeColors.base,
                            keyboardType: TextInputType.phone,
                            isRequired: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              PhoneMasking.inputFieldMask()
                            ],
                            validator: (val) =>
                                FormValidator.validatePhoneNumber(
                                    val, isRequired: true),
                            onChanged: controller.onDataChanged,
                          )
                        },
                        inputFieldSeparator,
                        JPInputBox(
                          inputBoxController: service.emailController,
                          label: 'email'.tr,
                          type: JPInputBoxType.withLabel,
                          fillColor: JPAppTheme.themeColors.base,
                          keyboardType: TextInputType.emailAddress,
                          isRequired: service.type != MaterialSupplierType.abc,
                          textCapitalization: TextCapitalization.none,
                          validator: (val) =>  FormValidator.validateEmail(val, isRequired: service.type != MaterialSupplierType.abc),
                          onChanged: controller.onDataChanged,
                        ),
                        if(service.type != MaterialSupplierType.abc) ...{
                          inputFieldSeparator,
                          AddressForm(
                            key: service.personalAddressFormKey,
                            title: 'address'.tr.toUpperCase(),
                            onDataChange: controller.onDataChanged,
                            address: service.personaladdress,
                            isRequired: true,
                            withoutSectionHeader: true,
                            hideCountryField: true,
                            hideAddressLine3Field: false,
                            type: AddressFormType.placeSrsOrder,
                          ),
                          inputFieldSeparator,
                        }
                      ],
                    ),
                  ),
                ),
              ),
              footer: Padding(
                padding: horizonalPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: JPResponsiveDesign.popOverButtonFlex,
                      child: JPButton(
                        text: 'cancel'.tr.toUpperCase(),
                        size: JPButtonSize.small,
                        type: JPButtonType.solid,
                        colorType: JPButtonColorType.lightGray,
                        onPressed: () {
                          Helper.hideKeyboard();
                          Get.back();
                        },
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      flex: JPResponsiveDesign.popOverButtonFlex,
                      child: JPButton(
                        text: 'save'.tr.toUpperCase(),
                        size: JPButtonSize.small,
                        type: JPButtonType.solid,
                        onPressed: controller.onSavePersonalDetails,
                      ),
                    )
                  ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
