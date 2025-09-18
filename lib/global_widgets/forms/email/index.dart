import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/email.dart';
import 'package:jobprogress/global_widgets/forms/email/fields/index.dart';

import 'controller.dart';

class EmailsForm extends StatefulWidget {
  const EmailsForm({
    this.isDisabled = false,
    this.isRequired = false,
    this.onDataChange,
    required this.emails,
    super.key
  });

  /// [isDisabled] helps in disabling form fields
  final bool isDisabled;

  /// [isRequired] decides whether fields is required
  /// and performs validation accordingly
  final bool isRequired;

  /// [onDataChange] performs validation on the go
  final Function(String)? onDataChange;

  /// [emails] contains list of email
  final List<EmailModel> emails;

  @override
  State<EmailsForm> createState() => EmailsFormState();
}

class EmailsFormState extends State<EmailsForm> {
  late EmailFormController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmailFormController>(
      init: EmailFormController(widget.emails),
      didChangeDependencies: (state) {
        controller = state.controller!;
      },
      global: false,
      builder: (controller) {
        return Form(
          key: controller.formKey,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (_, index) {
              return EmailFormField(
                index: index,
                controller: controller,
                isDisabled: widget.isDisabled,
                isRequired: widget.isRequired,
                onDataChange: (val) {
                  controller.onValueChanges(index);
                  widget.onDataChange?.call(val);
                },
              );
            },
            separatorBuilder: (_, index) {
              return SizedBox(
                height: controller.uiHelper.verticalPadding,
              );
            },
            itemCount: controller.emails.length,
          ),
        );
      },
    );
  }

  bool validate({bool scrollOnValidate = true}) {
    return controller.validateForm(scrollOnValidate: scrollOnValidate);
  }

  void updateFields(List<EmailModel> emails) {
    controller.updateFields(emails);
  }
}
