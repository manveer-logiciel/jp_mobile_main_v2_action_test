import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/email.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class EmailFormController extends GetxController {

  EmailFormController(this.emails);

  List<EmailModel> emails; // holds list of emails
  List<JPInputBoxController> emailControllers = []; // holds list of controllers

  FormUiHelper uiHelper = FormUiHelper(); // helps in building ui

  int maxEmails = 5; // contains max emails that can be taken as input

  int get displayingEmailField => emails.length; // holds the number of emails displaying

  bool validateFormOnDataChange = false;

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    init();
    super.onInit();
  }

  // init(): set-up email form data
  void init() {
    if (emails.isEmpty) {
      // if emails are empty manually pushing one fields
      addField();
    } else {
      // else pushing fields with data
      for (var email in emails) {
        addField(email: email.email);
      }
    }
  }

  // addField(): can be used to add new email field
  void addField({String? email}) {
    emailControllers.add(JPInputBoxController(text: email));
    int isPrimary = displayingEmailField == 0 ? 1 : 0;
    // static data push in case emails are empty
    if(email == null) {
      emails.add(EmailModel(email: "", isPrimary: isPrimary));
    }
    update();
  }

  // removeField(): removes email fields
  void removeField(int index) {
    emails.removeAt(index);
    emailControllers.removeAt(index);
    update();
  }

  // validateForm(): helps in performing validation
  bool validateForm({bool scrollOnValidate = true}) {
    validateFormOnDataChange = true;
    bool validationFailed = formKey.currentState?.validate() ?? false;
    if (!validationFailed && scrollOnValidate) scrollToErrorField();
    return !validationFailed;
  }

  void scrollToErrorField() {
    // validating each fields
    for (var field in emailControllers) {
      if(FormValidator.validateEmail(field.text) != null) {
        field.scrollAndFocus();
        break;
      }
    }

  }

  // onValueChanges(): updated data on the go
  void onValueChanges(int index) {
    emails[index].email = emailControllers[index].text;

    if(validateFormOnDataChange) {
      Future.delayed(const Duration(milliseconds: 100), () => formKey.currentState?.validate());
    }
  }

  Future<void> updateFields(List<EmailModel> updatedEmails) async {
    emails.clear();
    emailControllers.clear();
    update();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    emails.addAll(updatedEmails);
    init();
  }

}