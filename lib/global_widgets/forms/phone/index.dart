import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';
import 'fields/index.dart';

class PhoneForm extends StatefulWidget {
  const PhoneForm({
    super.key,
    this.isDisabled = false,
    required this.phoneField,
    this.label,
    this.isRequired = true,
    this.showSufixIcon = true,
    this.doShowPhoneBook = false,
    this.canBeMultiple = true
  });
  final bool isDisabled;
  final List<PhoneModel> phoneField;
  final String? label;
  final bool isRequired;
  final bool showSufixIcon;
  final bool doShowPhoneBook;
  final bool canBeMultiple;

  @override
  State<PhoneForm> createState() => PhoneFormState();
}

class PhoneFormState extends State<PhoneForm> {

  late PhoneFormController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PhoneFormController>(
      global: false,
      init: PhoneFormController(widget.phoneField, widget.canBeMultiple),
      didChangeDependencies: (state) {
        controller = state.controller!;
      },
      builder: (_) {
        return Material(
          color: JPAppTheme.themeColors.base,
          borderRadius: BorderRadius.circular(8),
          child: Form(
            key: controller.formKey,
            child: PhoneFormFields(
              controller: controller,
              isDisabled: widget.isDisabled,
              label: widget.label,
              isRequired: widget.isRequired,
              showSufixIcon: widget.showSufixIcon,
              doShowPhoneBook: widget.doShowPhoneBook,
            ),
          ),
        );
      }
    );
  }

  bool validate({bool scrollOnValidate = true}) {
    return controller.validateForm(scrollOnValidation: scrollOnValidate);
  }

  void updateFields(List<PhoneModel> phones) {
    controller.updateFields(phones);
  }
}
