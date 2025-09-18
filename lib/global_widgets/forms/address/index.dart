import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/address_form_type.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/global_widgets/forms/address/widgets/index.dart';
import 'controller.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({
    super.key,
    this.isDisabled = false,
    required this.onDataChange,
    this.title = 'address',
    this.isRequired = false,
    required this.address,
    this.billingAddress,
    this.type = AddressFormType.customer,
    this.isInitialSectionExpanded = false,
    this.withoutSectionHeader = false,
    this.hideAddressLine3Field = true,
    this.hideCountryField = false, 
    this.showBillingName = false,
    this.isAbcOrder = false
  });

  /// [title] can be used to give title to address form section
  final String title;

  /// [isDisabled] helps in disabling fields
  final bool isDisabled;

  /// [isRequired] decides whether fields are required and performs
  /// validations accordingly
  final bool isRequired;

  /// [address] holds the address data
  final AddressModel address;

  /// [billingAddress] holds billing address data
  final AddressModel? billingAddress;

  /// [onDataChange] helps in reflecting realtime changes
  final Function(String)? onDataChange;

  /// [type] helps in rendering element accordingly
  final AddressFormType type;

  /// [isInitialSectionExpanded] helps in section to expandable on initial rendering
  final bool isInitialSectionExpanded;

  /// [withoutSectionHeader] used to show form fields without section
  final bool withoutSectionHeader;

  /// [hideAddressLine3Field] used to hide address line 3 field
  final bool hideAddressLine3Field;

  /// [hideCountryField] used to hide country field
  final bool hideCountryField;

  final bool  showBillingName;

  final bool  isAbcOrder;

  @override
  State<AddressForm> createState() => AddressFormState();
}

class AddressFormState extends State<AddressForm> {

  late AddressFormController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressFormController>(
        init: AddressFormController(
            isRequired: widget.isRequired,
            address: widget.address,
            billingAddress: widget.billingAddress,
            isInitialSectionExpanded: widget.isInitialSectionExpanded,
        ),
        didChangeDependencies: (state) {
          controller = state.controller!;
        },
        didUpdateWidget: (oldWidget, state) => controller.didUpdateAddress(state.controller?.address, widget.address),
        global: false,
        builder: (controller) {
          return Form(
            key: controller.formKey,
            child: Column(
              children: [
                ///   address
                if(controller.addressData != null)
                  AddressSection(
                  controller: controller,
                  data: controller.addressData!,
                  title: widget.title,
                  isDisabled: widget.isDisabled,
                  type: widget.type,
                  withoutSectionHeader: widget.withoutSectionHeader,
                  hideAddressLine3Field: widget.hideAddressLine3Field,
                  hideCountryField: widget.hideCountryField,
                  isAbcOrder: widget.isAbcOrder
                ),

                ///   billing address
                if(controller.billingAddressData != null) ...{
                  SizedBox(
                    height: controller.formUiHelper.inputVerticalSeparator,
                  ),
                  AddressSection(
                    showName: widget.showBillingName,
                    controller: controller,
                    data: controller.billingAddressData!,
                    title: 'billing_address'.tr.toUpperCase(),
                    isDisabled: widget.isDisabled,
                    type: widget.type,
                    withoutSectionHeader: widget.withoutSectionHeader,
                    hideAddressLine3Field: widget.hideAddressLine3Field,
                    hideCountryField: widget.hideCountryField,
                  ),
                }
              ],
            )
            );
        });
  }

  /// [validate] helps in validating form externally
  bool validate({bool scrollOnValidation = true}) {
    controller.validateFormOnDataChange = true;
    return controller.validateForm(scrollOnValidation: scrollOnValidation);
  }
}
