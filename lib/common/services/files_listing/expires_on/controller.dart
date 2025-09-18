
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/expires_on.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/repositories/company_files.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/event/add_events.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/DatePicker/index.dart';

class ExpiresOnController extends GetxController {

  ExpiresOnController(this.fileParams);

  final FilesListingQuickActionParams fileParams;

  TextEditingController expiresOnController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isUpdatingExpireOnStatus = false;
  bool isResettingExpireOn = false;

  String? selectedDate;
  DocumentExpiration? expiration;

  @override
  void onInit() {
    expiration = DocumentExpiration(
      id: fileParams.fileList.first.expirationId,
      description: fileParams.fileList.first.expirationDescription,
      expireDate: fileParams.fileList.first.expirationDate,
    );
    if(expiration?.expireDate != null){
      formatDate(DateTime.parse(expiration!.expireDate.toString()));
    }
    if(expiration?.description != null){
      descriptionController.text = expiration!.description.toString();
    }
    super.onInit();
  }

  String validateExpiresOn(String value) {
    if (value.isEmpty) {
      return "please_provide_expiry_date".tr;
    } else if(!isAFutureDate()){
      return 'expire_date_should_be_future'.tr;
    }
    return '';
  }

  void pickDate() async {

    DateTime firstDate = DateTime.now().add(const Duration(days: 1));

    DateTime? dateTime = await Get.dialog(
      JPDatePicker(
        initialDate: selectedDate == null ? firstDate : DateTime.parse(selectedDate!),
        firstDate: selectedDate == null ? firstDate : isAFutureDate() ? firstDate : DateTime.parse(selectedDate!),
      ),
    );

    if(dateTime != null){
      formatDate(dateTime);
    }

    validateForm();

  }

  Future<void> reset() async{
    if(fileParams.fileList.first.expirationId != null){
      await resetExpireOn();
    }

    selectedDate = null;
    expiresOnController.text = '';
    descriptionController.text = '';

    update();
  }

  bool validateForm() {
    return formKey.currentState!.validate();
  }

  Future<void> updateExpiresOn() async{

    if(validateForm()){

      try{
        toggleIsUpdatingExpireOn();

        Map<String, dynamic> params = {
          "description": descriptionController.text,
          "document_id": fileParams.fileList.first.id,
          "document_type": getFileType(),
          "expire_date": selectedDate,
        };

        ExpiresOnModel data = await CompanyFilesRepository.expiresOn(params);

        fileParams.fileList.first.expirationId = data.documentExpiration?.id;
        fileParams.fileList.first.expirationDescription = data.documentExpiration?.description;
        fileParams.fileList.first.expirationDate = data.documentExpiration?.expireDate;

        fileParams.onActionComplete(fileParams.fileList.first, FLQuickActions.expireOn);

        Helper.showToastMessage('document_expiry_date_saved'.tr);

        Get.back();

        MixPanelService.trackEvent(event: MixPanelAddEvent.documentExpiresSuccess);

      } catch(e) {
        Helper.handleError(e);
      } finally {
        toggleIsUpdatingExpireOn();
      }

    }


  }

  bool doShowResetButton() {
    return expiresOnController.text.isNotEmpty;
  }

  void formatDate(DateTime dateTime){
    String dateOnly = dateTime.toString().substring(0,10);
    String formattedDate = DateTimeHelper.convertHyphenIntoSlash(dateOnly);
    expiresOnController.text = formattedDate;
    selectedDate = dateOnly;
    update();
  }

  Future<void> resetExpireOn() async{
    try{
      toggleIsResettingExpireOn();

      Map<String, dynamic> params = {
        'id' : expiration!.id,
      };

      await CompanyFilesRepository.resetExpireOn(params);

      fileParams.fileList.first.expirationId = null;
      fileParams.fileList.first.expirationDescription = null;
      fileParams.fileList.first.expirationDate = null;

      Helper.showToastMessage('document_expiry_date_deleted'.tr);

      fileParams.onActionComplete(fileParams.fileList.first, FLQuickActions.expireOn);


    }catch(e){
      Helper.handleError(e);
    }finally{
      toggleIsResettingExpireOn();
    }
  }

  void toggleIsUpdatingExpireOn(){
    isUpdatingExpireOnStatus = !isUpdatingExpireOnStatus;
    update();
  }

  void toggleIsResettingExpireOn(){
    isResettingExpireOn = !isResettingExpireOn;
    update();
  }

  String getFileType(){
    switch(fileParams.type){
      case FLModule.companyFiles:
        return 'resource';
      case FLModule.estimate:
        return 'estimation';
      case FLModule.jobProposal:
        return 'proposal';
      case FLModule.workOrder:
        return 'work_order';
      case FLModule.jobPhotos:
        return 'resource';
      case FLModule.jobContracts:
        return 'contract';
      default:
        return 'resource';
    }
  }

  bool isAFutureDate() {
    return DateTime.now().compareTo(DateTime.parse(selectedDate!)) < 1;
  }

  void cancelOnGoingRequest() {
    Helper.cancelApiRequest();
  }

  @override
  void dispose() {
    cancelOnGoingRequest();
    super.dispose();
  }

}