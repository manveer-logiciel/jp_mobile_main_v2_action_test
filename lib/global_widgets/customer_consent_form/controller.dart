
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/repositories/customer.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';

import '../../common/models/phone_consents.dart';
import '../../common/repositories/consent.dart';
import '../../core/constants/consent_status_constants.dart';

class ConsentFormDialogController extends GetxController {
  
  ConsentFormDialogController({
    this.emailList,
    this.previousEmail,
    this.phoneNumber,
    this.customerId,
    this.contactPersonId,
    this.updateScreen,
    this.obtainedConsent,
  }){
    if(!Helper.isValueNullOrEmpty(previousEmail)){
      emailController.text = previousEmail ?? '';
    }
    setEmailList();
  }
  
  final List<String?>? emailList;
  final String? previousEmail;
  final String? phoneNumber;
  final int? customerId;
  final int? contactPersonId;
  final VoidCallback? updateScreen;
  final String? obtainedConsent;

  bool isLoading = false;
  bool showSuccessMessage = false;
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? selectedEmail;
  List<JPSingleSelectModel> emailLists = [];
  PhoneConsentModel? phoneConsentModel;

  bool get isTwilioTextingEnabled => ConsentHelper.isTwilioTextingEnabled();
  bool get canActiveUserSendConsent => ConsentHelper.canActiveUserSendConsent();
  bool get isSoleProprietorMissing => Helper.isValueNullOrEmpty(ConsentHelper.lastSoleProprietorUser);

  bool get showEmailField => isTwilioTextingEnabled
      && !showSuccessMessage
      && canActiveUserSendConsent;

  String get title {
    if (isTwilioTextingEnabled) {
      return showSuccessMessage
          ? 'customer_consent'.tr.toUpperCase()
          : 'customer_consent_form'.tr.toUpperCase();
    } else {
      return 'you_have_not_yet_registered'.tr.toUpperCase();
    }
  }

  void getEmailList(){
    SingleSelectHelper.openSingleSelect(
      emailLists,
      selectedEmail ?? previousEmail,
      'select_contact'.tr.capitalize.toString(), (value) {
        selectedEmail = value;
        update();
        emailController.text = value;
        Get.back();
      }, 
    );
  }

  String get consentMessage {
    if (showSuccessMessage) {
      return '${'success_message'.tr}${emailController.text}.';
    }
    if (Helper.isValueNullOrEmpty(emailList)) {
      return 'consent_form_message_without_dropdown'.tr;
    }
    return 'consent_form_message'.tr;
  }

  void setEmailList(){
    List<String>? filterEmailList  = emailList?.whereType<String>().toList();
    if(!Helper.isValueNullOrEmpty(filterEmailList)){
      for (String email in filterEmailList!) {
        emailLists.add(
          JPSingleSelectModel(
          id: email, 
          label: email
        )
        );
      }
    }
    selectedEmail = emailList?.firstOrNull;
    emailController.text = selectedEmail ?? "";
  }

  Future<void> sendEmail() async {
    Map<String, dynamic> params = {
      'phone_number': phoneNumber,
      'email': emailController.text,
      'type': contactPersonId == null ? 'customer': 'job_contact',
      'type_id': customerId ?? contactPersonId,
    };
    try {
      if(obtainedConsent != ConsentStatusConstants.transactionalMessage) {
        phoneConsentModel = await ConsentRepository.setExpressConsent(params: params);
      }
      phoneConsentModel = await CustomerRepository.sendConsentEmail(params);
      if(phoneConsentModel != null) showSuccessMessage = true;
    } catch(e){
      rethrow; 
    } finally {
      isLoading = false;
      update();
    }
  }


  void updateSelectedValue(String value) {
    selectedEmail = value;
  }

  void onPressedBackButton() {
     Get.back(result: phoneConsentModel);
    if(showSuccessMessage && updateScreen != null) {
      updateScreen!();
    }
   
  }

  String? validateEmail(String val) {
    if (val.trim().isEmpty) {
      return 'this_field_is_required'.tr;
    } else if (val.isNotEmpty && !GetUtils.isEmail(val.trim())) {
      return 'please_enter_valid_email'.tr;
    }
    return null;
  }
  
  void onValidate() {
    Helper.hideKeyboard();
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    isLoading = true;
    update();
    formKey.currentState!.save();
    sendEmail();
  }
}

 