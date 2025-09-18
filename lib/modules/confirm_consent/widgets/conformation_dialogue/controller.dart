import 'package:get/get.dart';
import 'package:jobprogress/common/models/phone.dart';

import '../../../../common/models/phone_consents.dart';
import '../../../../common/repositories/consent.dart';
import '../../../../core/constants/consent_status_constants.dart';
import '../../../../core/utils/helpers.dart';

class ConsentConformationDialogueController extends GetxController {

  bool isRemoveConsentDialogue = false;
  bool isExpressConsentCheckBoxSelected = false;
  bool isSkipDisable = false;
  bool isSaveDisable = false;
  bool isLoading = false;

  final String? consentStatusConstants;
  final String? previouslySelectedConsent;

  final PhoneModel? phone;

  ConsentConformationDialogueController({
    this.consentStatusConstants,
    this.phone,
    this.isRemoveConsentDialogue = false,
    this.previouslySelectedConsent
  });

  String get title {
    if(Helper.isTrue(isRemoveConsentDialogue)) {
      if(previouslySelectedConsent == ConsentStatusConstants.promotionalMessage) {
        return "remove_express_consent".tr.toUpperCase();
      } else {
        return "remove_consent".tr.toUpperCase();
      }
    } else {
      return "confirm_express_consent".tr.toUpperCase();
    }
  }

  String get description {
    if(Helper.isTrue(isRemoveConsentDialogue)) {
      if(previouslySelectedConsent == ConsentStatusConstants.promotionalMessage) {
        return "remove_express_consent_message".tr;
      } else {
        return "remove_consent_message".tr;
      }
    } else {
      return "express_consent_conformation_message".tr;
    }
  }

  String get checkBoxText {
    if(Helper.isTrue(isRemoveConsentDialogue)) {
      if(previouslySelectedConsent == ConsentStatusConstants.promotionalMessage) {
        return "remove_express_consent_checkbox_message".tr;
      } else {
        return "remove_consent_checkbox_message".tr;
      }
    } else {
      return "express_consent_conformation_checkbox_message".tr;
    }
  }

  String get saveButtonText => Helper.isTrue(isRemoveConsentDialogue) ? "remove_consent".tr.toUpperCase() : "save".tr.toUpperCase();

  bool get isSkipVisible {
    switch(consentStatusConstants) {
      case ConsentStatusConstants.promotionalMessage:
        return true;
        default:
          return false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    updateButtonsDisability();
  }

  Future<void> save() async {
    switch(consentStatusConstants) {
      case ConsentStatusConstants.noMessage:
      case ConsentStatusConstants.transactionalMessage:
        await saveOnServer();
        break;
      case ConsentStatusConstants.promotionalMessage:
        Get.back(result: PhoneConsentModel());
        break;
    }
  }

  void onExpressConsentCheckBoxToggle(bool value) {
    isExpressConsentCheckBoxSelected = !isExpressConsentCheckBoxSelected;
    updateButtonsDisability();
  }

  void updateButtonsDisability() {
    if(isExpressConsentCheckBoxSelected) {
      isSkipDisable = true;
      isSaveDisable = false;
    } else {
      isSkipDisable = false;
      isSaveDisable = true;
    }
    update();
  }

  Future<void> saveOnServer() async {
    try {
      toggleIsLoading();
      Map<String, dynamic> params = {
        "phone_number": phone?.number,
      };

      PhoneConsentModel? response;

      if(consentStatusConstants == ConsentStatusConstants.noMessage) {
        response = await ConsentRepository.setNoMessageConsent(params: params);
        if (Helper.isValueNullOrEmpty(response.status)) {
          response = PhoneConsentModel(status: ConsentStatusConstants.noMessage);
        }
      } else {
        response = await ConsentRepository.setExpressConsent(params: params);
      }

      Get.back(result: response);
    } catch (e) {
      rethrow;
    } finally {
      toggleIsLoading();
    }

  }

  void toggleIsLoading () {
    isLoading = !isLoading;
    update();
  }
}
