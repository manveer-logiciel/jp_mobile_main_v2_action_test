import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/file_attachment/quick_actions.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../core/constants/urls.dart';

class SupportFormController extends GetxController{
  final formKey = GlobalKey<FormState>();
  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing

  JPInputBoxController subjectController = JPInputBoxController();
  JPInputBoxController messageController = JPInputBoxController();

  List<AttachmentResourceModel> attachments = []; // contains attachments being displayed to user

  Map<String, dynamic> initialJson = {}; // helps in data changes comparison

  int totalAttachedFileSize = 0;

  bool isSavingForm = false;
  bool validateFormOnDataChange = false;

  @override
  void onInit() {
    initialJson = supportFormJson();
    super.onInit();
  }

  Map<String, dynamic> supportFormJson() {
    final Map<String, dynamic> data = {};
    data['subject'] = subjectController.text;
    data['content'] = messageController.text;
    if(attachments.isNotEmpty){
      data['attachments[]'] = attachments.map((attachment) => attachment.id).toList();
    }else{
      data['attachments[]'] = attachments;
    } 
    return data;
  }  

  Future<void> onSave() async{
    validateFormOnDataChange = true;
    bool isValid = validate();

    if(isValid){
      saveForm();
    }
  }

  Future<void> saveForm() async{
    try {
      toggleIsSavingForm();
      final params = supportFormJson();
      final response = await sendSupportRequest(params);
      if(response['status'] == 200){
        Get.back();
        Helper.showToastMessage("support_request_submitted".tr);
      }else{
        Get.back();
      }
    } catch (e) {
      rethrow;
    } finally {
      toggleIsSavingForm();
    }
   
  }

  void toggleIsSavingForm() {
    isSavingForm = !isSavingForm;
    update();
  }

  // onDataChanged() : will validate form as soon as data in input field changes
  void onDataChanged(dynamic val, {bool doUpdate = false}) {
    // realtime changes will take place only once after user tried to submit form
    if (validateFormOnDataChange) {
      validate();
    }

    if(doUpdate) update();
  }

  bool validate(){
    bool isValid = formKey.currentState?.validate() ?? false;
    return isValid;
  }

  // checkIfNewDataAdded(): used to compare form data changes
  bool checkIfNewDataAdded() {
    final currentJson = supportFormJson();
    return initialJson.toString() != currentJson.toString() || attachments.isNotEmpty;
  }

  // showFileAttachmentSheet() : displays quick actions sheet to select files from
  void showFileAttachmentSheet() {
    Helper.hideKeyboard();
    FileAttachService.uploadFiles<AttachmentResourceModel>(
      onFilesUploaded: (seletecedFiles) {
        int currentSize = seletecedFiles.first.size! + totalAttachedFileSize;
        if(currentSize < CommonConstants.totalAttachmentMaxSize){
          FormValueSelectorService.addSelectedFilesToAttachment(
            seletecedFiles,
            attachments: attachments,
          );
          getAttachedFileSize(seletecedFiles);
          update();
        }else{
          Helper.showToastMessage('max_file_size'.tr + ' ' + FileHelper.fileInMegaBytes(CommonConstants.singleAttachmentMaxSize).toString() + ' ' + 'mb'.tr);
        }
      },
      maxSize: CommonConstants.singleAttachmentMaxSize,
      onlyImages: false,
      allowMultiple: false,
      fromCamera: false,
    );
  }

  int getAttachedFileSize(List<AttachmentResourceModel> files){
    for(int i = 0;i<files.length;i++){
      totalAttachedFileSize += files[i].size!;
    }
    return totalAttachedFileSize;
  }

  String? validateSubject(String val) {
    return FormValidator.requiredFieldValidator(val,errorMsg: "subject_is_required".tr);
  }

  String? validateMessage(String val) {
    return FormValidator.requiredFieldValidator(val,errorMsg: "message_is_required".tr);
  }

  void removeAttachedItem(int index) {
    attachments.removeAt(index);
    totalAttachedFileSize = 0;
    getAttachedFileSize(attachments);
    update();
  }

  Future<Map<String, dynamic>> sendSupportRequest(Map<String, dynamic> params) async {
    try {

      final formData = FormData.fromMap(params);
      final response = await dio.post(Urls.supportRequest, data: formData);
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  // onWillPop(): will check if any new data is added to form and takes decisions
  //              accordingly whether to show confirmation or navigate back directly
  Future<bool> onWillPop() async {
    bool isNewDataAdded = checkIfNewDataAdded();

    if (isNewDataAdded) {
      Helper.showUnsavedChangesConfirmation();
    } else {
      Helper.hideKeyboard();
      Get.back();
    }

    return false;
  }
}