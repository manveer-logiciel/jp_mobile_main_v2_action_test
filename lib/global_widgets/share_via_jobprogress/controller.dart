import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/twilio_text_status.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/phone_consents.dart';
import 'package:jobprogress/common/repositories/customer.dart';
import 'package:jobprogress/common/repositories/job_photos.dart';
import 'package:jobprogress/common/services/file_attachment/quick_actions.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/consent_status_constants.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class SendViaJobProgressController extends GetxController {

  SendViaJobProgressController({
    this.model,
    this.jobModel,
    this.type,
    this.phone,
    this.customerModel,
    this.onTextSent,
    this.phoneModel,
    this.consentStatus,
  });

  List<AttachmentResourceModel> attachments = []; // used to store and display selected attachmentss
  TextEditingController phoneController = TextEditingController();
  final messageController = TextEditingController();
  String? phone;
  bool isLoading = false;
  bool isLoadingTextStatus = true;
  bool haveConsent = true;
  bool validateMessageBox = false;

  /// [hasValidNumber] helps in enabling the Text filed only when
  /// number entered by user to send text on is valid one
  bool hasValidNumber = false;

  FilesListingModel? model;
  JobModel? jobModel;
  CustomerModel? customerModel;
  PhoneModel? phoneModel;
  String? consentStatus;
  FLModule? type;
  VoidCallback? onTextSent;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? message;
  int? jobId;
  int? customerId;
  String? mediaFileId;
  String? selectedContact;

  PhoneConsentModel? phoneConsent;
  List<JPSingleSelectModel> customerNumber = [];
  List<JPSingleSelectModel> jobContactPerson = [];

  /// [selectedContactDetails] is used tos store Customer Or Contact Person
  /// details as per type of number selected
  dynamic selectedContactDetails;

  TwilioTextStatus? twilioTextStatus = ConsentHelper.lastTwilioTextStatus;

  bool get isTwilioTextingEnabled => twilioTextStatus == TwilioTextStatus.enabled
      && !isLoadingTextStatus;

  bool get doShowConsentStatus => hasValidNumber && !isLoadingTextStatus && phoneController.text.isNotEmpty && ConsentHelper.isTransactionalConsent();

  /// [phoneNumberOptions] gives options list that will be available to select options from
  List<JPSingleSelectModel> get phoneNumberOptions => (customerModel != null) ? customerNumber : (customerNumber + jobContactPerson);

  String? validateMessage(String value) {
    if (value.isEmpty && validateMessageBox) {
      return 'please_enter_message'.tr;
    }
    return null;
  }

  String? validatePhone(String value) {
    String unMaskedPhone = PhoneMasking.unmaskPhoneNumber(value);
    if (unMaskedPhone.length < 10) {
      return 'please_enter_valid_phone_number'.tr;
    }
    return null;
  }

  String? get warningText {
    String? consentStatus = getConsentStatus();
    switch (consentStatus) {
      case ConsentStatusConstants.byPass:
      case ConsentStatusConstants.optedIn:
        return '';
      
      default:
        return 'default_consent_warning'.tr;
    }
  }

  String? get warningButtonText {
    String? consentStatus = getConsentStatus();
    
    if(consentStatus == ConsentStatusConstants.resend){
      return 'resend_consent_form'.tr;
    }
    if(consentStatus == null){
      return 'click_here'.tr;
    }
    return '';
  }
 
  void openConsentForm() {
    String? consentStatus = getConsentStatus();
    String? consentEmail = getConsentEmail();
    if(consentStatus == null || consentStatus == ConsentStatusConstants.resend){
      ConsentHelper.openConsentFormDialog(
        phoneNumber: selectedContact,
        customerId:  customerId,
        email: customerModel?.email,
        previousEmail: consentEmail ?? '',
        additionalEmails:  customerModel?.additionalEmails,
        updateScreen: (){
           validateConsent(phoneController.text);
        }
      );  
    } 
  }

  bool get showWarningMessage{
    return !Helper.isValueNullOrEmpty(warningText) || 
      !Helper.isValueNullOrEmpty(warningButtonText) || 
      !Helper.isValueNullOrEmpty(warningSuffixText); 
  }

  String? get warningSuffixText {
    String? consentStatus = getConsentStatus();
    if (consentStatus == ConsentStatusConstants.pending) {
      return 'consent_form_has_been_sent'.tr;
    }
    return consentStatus != null ? '' : 'to_send_consent_form'.tr;
  }

  void onValidate() {
    validateMessageBox = true;
    Helper.hideKeyboard();
    final isValid = validateForm(formKey);
    if (!isValid) {
      return;
    }
    validateForm(formKey);
    sendText();
  }

  bool validateForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  String mediaType() {
    switch (type) {
      case FLModule.companyFiles:
        return 'company-resources';
      case FLModule.estimate:
        return 'estimate';
      case FLModule.jobProposal:
        return 'proposal';
      case FLModule.jobContracts:
        return 'contract';
      default:
        return 'resource';
    }
  }

  Map<String, dynamic> params() {
    // Base parameters that are always needed
    Map<String, dynamic> baseParams = {
      'phone_number': PhoneMasking.unmaskPhoneNumber(phoneController.text),
      'message': messageController.text,
    };

    // If phone is not null, return only the base parameters
    if (phone != null) {
      return baseParams;
    }

    // Only add additional parameters if they have valid values
    if (mediaFileId != null) {
      baseParams['media[0][type]'] = mediaType();
      baseParams['media[0][value]'] = mediaFileId;
    }

    if (jobId != null) {
      baseParams['job_id'] = jobId;
    }

    if (customerId != null) {
      baseParams['customer_id'] = customerId;
    }

    return baseParams;
  }

  void sendText() async {
    isLoading = true;
    update();
    try {
      await JobPhotosRepository.sendTextMessage(params());
      Get.back();
      Helper.showToastMessage('text_sent'.tr);
      onTextSent?.call();
    } catch (e) {
      Helper.handleError(e);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<PhoneConsentModel> fetchPhoneConsent(String val, {bool showLoader = true}) async {
    Map<String, dynamic> params = {
      'number': val,
    };
    try {
      PhoneConsentModel phoneConsent  = await CustomerRepository.fetchPhoneConsent(params);
      return phoneConsent;
    } catch (e) {
      rethrow;
    } finally {
      if(showLoader){
        Get.back();  
      }
    }
  }

  Future<void> validateConsent(String val, {bool numberFromSheet = false}) async {
    validateMessageBox = false;
    String unmaskedNumber = PhoneMasking.unmaskPhoneNumber(val);
    // updating selected contact details
    selectedContactDetails = phoneNumberOptions.firstWhereOrNull((element) => element.id == unmaskedNumber)?.additionalData;

    if(val.isEmpty) {
      if(numberFromSheet){
        Get.back();
      }
      return;
    }
    selectedContact = unmaskedNumber;
    bool validate = hasValidNumber = validateForm(formKey);
    if (!validate) {
      // In case of invalid number or number not found
      // consent should be assumed as not give
      haveConsent = false;
      update();
      return;
    }

    if(numberFromSheet){
      phoneController.text = PhoneMasking.maskPhoneNumber(unmaskedNumber);
    }

    if (unmaskedNumber.length > 8) {
      if (numberFromSheet) {
        showJPLoader();
      }
      phoneConsent = await fetchPhoneConsent(unmaskedNumber,showLoader: numberFromSheet);
      haveConsent = FilesListingService.haveConsent(phoneConsent?.status, overrideConsentStatus: false);

      if (numberFromSheet) {
        Get.back();
      }

      if (!ConsentHelper.isTransactionalConsent() && phoneConsent?.status == ConsentStatusConstants.optedOut) {
        ConsentHelper.openOptedOutDialog();
        phoneController.clear();
        selectedContact = '';
        unmaskedNumber =  '';
      }
    }

    if (unmaskedNumber.isEmpty) {
      haveConsent = true;
    }

    update();
  }

  // showFileAttachmentSheet() : displays quick actions sheet to select files from
  void showFileAttachmentSheet() {
    Helper.hideKeyboard();

    if (attachments.isEmpty) {
      FileAttachService.openQuickActions(
        maxSize: CommonConstants.maxAllowedFileSize,
          jobId: jobId,
          onFilesSelected: addSelectedFilesToAttachment,
          allowMultiple: false);
    }
  }

  //removeAttachment() : will remove attachment
  void removeAttachment(int index) {
    removeAttachedItem(index);
  }

  // removeAttachedItem() : will remove items from selected attachments
  void removeAttachedItem(int index) {
    attachments.removeAt(index);
    update();
  }

  // addSelectedFilesToAttachment() : add files to attachment list
  void addSelectedFilesToAttachment(List<AttachmentResourceModel> files,
      {int? jobId}) {
    for (var file in files) {
      // checking whether file is already attached
      if (!attachments.any((element) => element.id == file.id)) {
        mediaFileId = file.id.toString();
        attachments.add(AttachmentResourceModel(
          id: int.parse(file.id.toString()),
          extensionName: FileHelper.getFileExtension(file.path!),
          name: file.name,
          url: file.url,
          filePath: file.path,
        ));
      }
    }
    update();
  }

  void setContacts() {
    bool isSingleCustomerPhoneNumber = jobModel?.customer?.phones?.length == 1;
    bool isSingleContactPersonPhoneNumber = 
      jobModel?.contactPerson?.length == 1 && 
      jobModel?.contactPerson?[0].phones?.length == 1;
    
    if (jobModel?.customer?.phones != null) {
      customerNumber.add(
        JPSingleSelectModel(
          label: isSingleCustomerPhoneNumber ? 
            'customer_number'.tr.capitalize.toString() :
            'customer_numbers'.tr.capitalize.toString(),
          id: 'sub_title',
        )
      );
      for (int i = 0; i < jobModel!.customer!.phones!.length; i++) {
        customerNumber.add(JPSingleSelectModel(
            label: PhoneMasking.maskPhoneNumber(
                jobModel!.customer!.phones![i].number.toString()),
            id: jobModel!.customer!.phones![i].number.toString(),
            additionalData: jobModel!.customer
        ));
      }
    }
    if (jobModel?.contactPerson != null) {
      jobContactPerson.add(
        JPSingleSelectModel(
          label: isSingleContactPersonPhoneNumber ?
            'job_contact_person_number'.tr.capitalize.toString() :
            'job_contact_person_numbers'.tr.capitalize.toString(), 
          id: 'sub_title'
        )
      );
      for (int j = 0; j < jobModel!.contactPerson!.length; j++) {
        if (jobModel?.contactPerson![j].phones != null) {
          for (int i = 0; i < jobModel!.contactPerson![j].phones!.length; i++) {

            String contactPersonPhone = jobModel!.contactPerson![j].phones![i].number.toString();

            bool isContactPersonAlreadyInCustomer = customerNumber.any((customer) => customer.id == contactPersonPhone);

            if(isContactPersonAlreadyInCustomer) continue;

            jobContactPerson.add(JPSingleSelectModel(
                label: PhoneMasking.maskPhoneNumber(contactPersonPhone),
                id: contactPersonPhone,
                additionalData: jobModel!.contactPerson![j],
              ),
            );
          }
        }
      }
    }

    setSelectedContact();

    update();
    setDefaultInputNumber();
  }

  void setSelectedContact() {

    if(jobContactPerson.length <= 1) {
      jobContactPerson.clear();
    }

    if (phone?.isNotEmpty ?? false) {
      final combinedData = customerNumber + jobContactPerson;

      combinedData.removeWhere((element) => element.id == 'sub_title');

      selectedContact = combinedData
          .firstWhere(
              (data) => data.label == PhoneMasking.maskPhoneNumber(phone!))
          .id;

      phoneController.text = PhoneMasking.maskPhoneNumber(selectedContact!);
    } else if(customerNumber.length > 1){
      selectedContact = customerNumber[1].id;
    } else if(jobContactPerson.length > 1) {
      selectedContact = jobContactPerson[1].id;
    }
  }

  void setCustomerContacts() {
    if (customerModel?.phones != null) {
      for (int i = 0; i < customerModel!.phones!.length; i++) {
        customerNumber.add(JPSingleSelectModel(
            label: PhoneMasking.maskPhoneNumber(
                customerModel!.phones![i].number.toString()),
            id: customerModel!.phones![i].number.toString()));
      }
    }
    selectedContact = phone;
    update();
  }

// set input box with first no. from list
  setDefaultInputNumber() {
    if (customerNumber.length > 1) {
      phoneController.text = PhoneMasking.maskPhoneNumber(
          jobModel!.customer!.phones![0].number.toString());
    } else if (jobContactPerson.length > 1) {
      phoneController.text = PhoneMasking.maskPhoneNumber(
          jobModel!.contactPerson![0].phones![1].number.toString());
    } else {
      phoneController.text = '(XXX) XXX-XXXX';
    }
  }

//open contacts list
  void getContactsLists() {
    selectedContact = PhoneMasking.unmaskPhoneNumber(phoneController.text);
    SingleSelectHelper.openSingleSelect(
        phoneNumberOptions,
        selectedContact,
        'select_contact'.tr.capitalize.toString(), (value) async {
      await validateConsent(value, numberFromSheet: true);
    }, isFilterSheet: true);
  }

  bool checkConsent(String phoneNumber) {
    PhoneModel? selectedPhone = customerModel?.phones?.firstWhere(
      (phone) => phone.number == phoneNumber 
    );
    if(selectedPhone != null) {
      return FilesListingService.haveConsent(selectedPhone.consentStatus ?? '', overrideConsentStatus: false);
    }
    return true;
  }

  String? getConsentStatus() {
      PhoneModel? firstPhone = customerModel?.phones?.firstWhereOrNull(
        (phone) => phone.number == selectedContact,
      );
      return firstPhone?.consentStatus ?? phoneConsent?.status;   
  }

  String? getConsentCreatedAt() {
    PhoneModel? firstPhone = customerModel?.phones?.firstWhereOrNull(
      (phone) => phone.number == selectedContact, 
    );
    
    return firstPhone?.consentCreatedAt ?? phoneConsent?.createdAt;
  }

  String? getConsentEmail(){
    PhoneModel? firstPhone = customerModel?.phones?.firstWhereOrNull(
      (phone) => phone.number == selectedContact, 
    );
    
    return firstPhone?.consentEmail ?? phoneConsent?.email;
  }
    
  void selectedFile() {
    attachments.add(AttachmentResourceModel.fromJson(model!.toJson())
    ..type = Helper.resourceType(type)
  );
    addSelectedFilesToAttachment(attachments);
  }

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    try {
      twilioTextStatus = await ConsentHelper.getTwilioTextStatus();
      if (twilioTextStatus != TwilioTextStatus.enabled) return;

      if (customerModel != null) {
        setCustomerContacts();
      }
      if (jobModel != null) {
        jobId = jobModel!.id;
        customerId = jobModel!.customerId;
        setContacts();
      }
      if (model != null) {
        mediaFileId = model!.id ?? '';
        selectedFile();
      }
      if (phone != null && phone != '') {
        phoneController.text = PhoneMasking.maskPhoneNumber(phone ?? '');
      }
      await validateConsent(phoneController.text);
    } catch (e) {
      rethrow;
    } finally {
      isLoadingTextStatus = false;
      update();
    }
  }

  /// [getSelectedContactByType] compares the type of data requested. It matches and
  /// then returns the data otherwise it returns null.
  T? getSelectedContactByType<T>() {
    if (selectedContactDetails is T) {
      return selectedContactDetails as T;
    }
    return null;
  }

  /// Updates the consent status for a phone number
  ///
  /// This method updates the consent status in both phoneModel and the local consentStatus variable,
  /// and triggers validation of the consent status for the current phone number.
  ///
  /// [status] - The new consent status to set
  Future<void> updateConsentStatus(String status) async {
    await validateConsent(phoneController.text);
    phoneModel?.consentStatus = consentStatus = status;
    // Forcing Update to reflect changes all over in tha app
    if (RunModeService.isAppMode) Get.forceAppUpdate();
  }
}
