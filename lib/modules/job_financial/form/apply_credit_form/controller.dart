
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_request_param.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/common/services/credit/apply_credit_form.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ApplyCreditFormController extends GetxController {

  final formKey = GlobalKey<FormState>(); // used to validate form
  
  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing
  
  late ApplyCreditFormService service;

  
  DateTime dueOnDate = DateTime.now();
  
  List<JPSingleSelectModel> singleSelectInvoiceList = [];
  


  bool validateFormOnDataChange = false;
  bool isLoading = true;

  int? jobId;
  int? invoiceId;
  JobModel? job;
  List<FilesListingModel>? invoiceList;
  
  @override
  void onInit() {
    initForm();
    super.onInit();
  }

  Future<void> initForm() async {
    
    jobId = Get.arguments?[NavigationParams.jobId];
    invoiceId = Get.arguments?[NavigationParams.invoiceId];
   
    service = ApplyCreditFormService(
      validateForm:() => onDataChanged(''),
      update: update,
      job: job,
      invoiceId: invoiceId,
      invoiceList: invoiceList
    ); 
    service.controller  = this;
    await Future<void>.delayed(const Duration(milliseconds: 200));
    showJPLoader();
    try {
      await Future.wait([
        fetchJob(),
        fetchInvoiceListing()
      ]);
      
      service.initForm();
    } catch(e) {
      rethrow;
    } finally {
      isLoading = false;
      Get.back();
      update();
    }
  }

  Future<void> fetchJob() async {
    try {
      await JobRepository.fetchJob(jobId!).then((Map<String, dynamic> response) {
       service.job = response["job"];
      });
    } catch (e) {
      rethrow;
    } 
  }

  Future<void> fetchInvoiceListing() async {
    try {
      Map<String, dynamic> params = {
        'id': jobId.toString(),
        'limit': 0,
        'page': 1,
        ...FilesListingRequestParam.getFinancialInvoiceParams(),
      };

      await JobFinancialRepository.fetchFiles(params).then(
        (Map<String, dynamic> response) {
          service.invoiceList = response["list"];
        }
      );
    } catch (e) {
      rethrow;
    } 
  }

 

  bool validateForm() {
    bool isValid = formKey.currentState?.validate() ?? false;
    return isValid;
  }

  void onDataChanged(dynamic val) {
    // realtime changes will take place only once after user tried to submit form
    if (validateFormOnDataChange) {
      validateForm();
    }
    update();
  }


  void onSave() {
    bool isValid = validateForm();
    validateFormOnDataChange = true;
    if(isValid){
      service.saveForm();
    } else {
      service.scrollToErrorField();
    }
  }  
}

  

