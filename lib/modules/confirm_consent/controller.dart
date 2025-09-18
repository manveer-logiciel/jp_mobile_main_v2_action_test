import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/consent_status/consent_status_params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';

import '../../common/models/customer/customer.dart';
import '../../common/models/phone.dart';
import '../../common/models/phone_consents.dart';
import '../../common/repositories/consent.dart';
import '../../common/services/run_mode/index.dart';
import '../../core/constants/consent_status_constants.dart';
import '../../core/constants/navigation_parms_constants.dart';
import '../../core/utils/consent_helper.dart';
import '../../global_widgets/bottom_sheet/index.dart';
import 'widgets/conformation_dialogue/index.dart';

class ConfirmConsentController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool isSavingForm = false; // used to disable user interaction with ui
  bool isEdit = false;

  String selectedConsent = "";
  String? previouslySelectedConsent = Get.arguments?[NavigationParams.consentStatusConstants];

  CustomerModel? customer = Get.arguments?[NavigationParams.customer];
  JobModel? job = Get.arguments?[NavigationParams.jobModel];
  CompanyContactListingModel? contactPerson = Get.arguments?[NavigationParams.contactPerson];
  PhoneModel? phone = Get.arguments?[NavigationParams.phone];
  ConsentStatusParams? params = Get.arguments?[NavigationParams.consentStatusParams];

  String? get customerName {
    if (contactPerson != null) {
      return contactPerson?.fullName;
    } else if(customer != null) {
      return customer?.fullName;
    } else if (job != null) {
      return job?.customer?.fullName;
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    previouslySelectedConsent ??= phone?.consentStatus;
    if(!Helper.isValueNullOrEmpty(previouslySelectedConsent)) {
      selectedConsent = previouslySelectedConsent!;
      isEdit = true;
    }
    update();
  }

  void updateSelectedConsent(String consent) {
    selectedConsent = consent;
    if(!RunModeService.isUnitTestMode) saveConsent();
    update();
  }

  void saveConsent() {
    switch(selectedConsent) {
      case ConsentStatusConstants.noMessage:
        if(isEdit) {
          showConformationBottomSheet(isRemoveConsentDialogue : true);
        } else {
          saveOnServer();
        }
        break;
      case ConsentStatusConstants.transactionalMessage:
        if(previouslySelectedConsent == ConsentStatusConstants.promotionalMessage) {
          showConformationBottomSheet(isRemoveConsentDialogue : true);
        } else {
          showConformationBottomSheet();
        }
        break;
      case ConsentStatusConstants.promotionalMessage:
        if(Helper.isValueNullOrEmpty(previouslySelectedConsent) || previouslySelectedConsent == ConsentStatusConstants.noMessage) {
          showConformationBottomSheet();
        } else {
          obtainConsent();
        }
        break;
    }
  }

  Future<void> showConformationBottomSheet({bool isRemoveConsentDialogue = false}) async {
    Helper.hideKeyboard();
    var result = await showJPBottomSheet(child: (controller) => ConsentConformationDialogue(
        consentStatusConstants: selectedConsent,
        isRemoveConsentDialogue: isRemoveConsentDialogue,
        previouslySelectedConsent: previouslySelectedConsent,
        phone: phone,
      ),
      isScrollControlled: true,
      isDismissible: false,
    );

    if(result is PhoneConsentModel) {
      switch(selectedConsent) {
        case ConsentStatusConstants.transactionalMessage:
        case ConsentStatusConstants.noMessage:
          Get.back(result: result);
          break;
        case ConsentStatusConstants.promotionalMessage:
          if(Helper.isValueNullOrEmpty(previouslySelectedConsent) || previouslySelectedConsent == ConsentStatusConstants.noMessage) {
            obtainConsent();
          }
          break;
      }
    }
  }

  Future<void> obtainConsent() async {
    int? customerId;

    if (contactPerson != null) {
      customerId = contactPerson?.id;
    } else if(customer != null) {
      customerId = customer?.id;
    } else if (job != null) {
      customerId = job?.customer?.id;
    }

    PhoneConsentModel? phoneConsentModel = await ConsentHelper.openConsentFormDialog(
      phoneNumber: phone?.number,
      additionalEmails: params?.getEmails(),
      customerId: customerId,
      contactPersonId: contactPerson?.id,
      obtainedConsent: previouslySelectedConsent,
    );

    if(phoneConsentModel != null) Get.back(result: phoneConsentModel);
  }

  Future<void> saveOnServer() async {
    try {
      showJPLoader();
      Map<String, dynamic> params = {
        "phone_number": phone?.number,
      };

      PhoneConsentModel? response;

      switch (selectedConsent) {
        case ConsentStatusConstants.noMessage:
          response = await ConsentRepository.setNoMessageConsent(params: params);
          if (Helper.isValueNullOrEmpty(response.status)) {
            response = PhoneConsentModel(status: ConsentStatusConstants.noMessage);
          }
          break;
        case ConsentStatusConstants.transactionalMessage:
          response = await ConsentRepository.setExpressConsent(params: params);
          break;
      }
      if (!Helper.isValueNullOrEmpty(response?.status)) {
        Get.back();
        Get.back(result: response);
      }
    } catch (e) {
      Get.back();
      rethrow;
    }
  }
}