import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/email/template_list.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/recurring_email.dart';
import 'package:jobprogress/common/models/job/recurring_email_scheduler.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/work_flow_stage_color.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/email/template_listing/detail_dialog/index.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/index.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/position.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/type.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class JobRecurringEmailController extends GetxController {
  int? jobId = Get.arguments == null ? null : Get.arguments['job_id'];
  int customerId = Get.arguments == null ? -1 : Get.arguments['customer_id'];
  bool isLoading = true;
  List <RecurringEmailModel>? recurringEmail;
  JobModel? job;
  EmailTemplateListingModel? template;

  @override
  void onInit() async {
    await getRecurringEmailData();
    super.onInit();
  }

  Future<void> fetchJob() async {
    try {
      // getting request params
      Map<String, dynamic> params = {
        'id': jobId,
        'includes[1]': 'workflow',
      };
      // calling api to load job
      job = (await JobRepository.fetchJob(jobId!,params: params))['job'];
    } catch (e) {
      rethrow;
    } 
  }
 
  Future<void> fetchRecurringEmailList() async {
    try {
      // getting request params
      Map<String, dynamic> params = {
        'customer_id': customerId,
        'include_canceled_campaign': 1,
        'job_id': jobId,
        'include[0]': 'email',
        'includes[1]': 'drip_campaign_schedulers',
        'includes[2]': 'email.attachments',
        'includes[3]': 'canceled_by',
      };
      // calling api to load job
      recurringEmail = await JobRepository.fetchRecurringEmailList(params: params);
      setData(recurringEmail!);
    } catch (e) {
      rethrow;
    } 
  }

  Future<void> getRecurringEmailData() async {
    try{
      await Future.wait([
        fetchJob(),
        fetchRecurringEmailList(),
      ]);
    } catch(e) {
      rethrow;
    } finally {
      isLoading = false;
       update();
    }
  }
 
 Future<void> refreshData() async{
    isLoading = true;
    update();
    await getRecurringEmailData();
    isLoading = false;
    update();
  }  

  String getStageName({required String stageCode, required JobModel job}){
    WorkFlowStageModel stage= job.stages!.firstWhere((element) => element.code == stageCode);
    return stage.name;
  }
  
  Color ? getStageColor({required String stageCode, required JobModel job}){
    WorkFlowStageModel stage= job.stages!.firstWhere((element) => element.code == stageCode);
    return WorkFlowStageConstants.colors[stage.color];
  }

  toggleshowHistory(int index){
    recurringEmail![index].showHistory = !recurringEmail![index].showHistory;
    update();
  }

  void setData(List <RecurringEmailModel> recurringEmail){
    for(int i = 0; i < recurringEmail.length; i++){
      List<RecurringEmailSchedulerModel> tempEmails = [];
      List<RecurringEmailSchedulerModel> tempSuccessEmails = [];
      List<RecurringEmailSchedulerModel> tempReadyEmail = [];
      List<RecurringEmailSchedulerModel> tempCanceledEmail = [];
      List<RecurringEmailSchedulerModel> tempClosedEmail = [];

      for(int j = 0; j < recurringEmail[i].scheduleEmail!.length; j++){
        if(recurringEmail[i].scheduleEmail![j].status == 'success'){
          tempSuccessEmails.add(recurringEmail[i].scheduleEmail![j]);
        }
        if(recurringEmail[i].scheduleEmail![j].status == 'ready'){
          tempReadyEmail.add(recurringEmail[i].scheduleEmail![j]);
        }
        if(recurringEmail[i].scheduleEmail![j].status == 'canceled'){
          tempCanceledEmail.add(recurringEmail[i].scheduleEmail![j]);
        }
        if(recurringEmail[i].scheduleEmail![j].status == 'closed'){
          tempClosedEmail.add(recurringEmail[i].scheduleEmail![j]);
        }
      }

      tempSuccessEmails.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
      tempReadyEmail.sort((a, b) => a.scheduleDate!.compareTo(b.scheduleDate!));
      tempClosedEmail.sort((a, b) => a.statusUpdatedAt!.compareTo(b.statusUpdatedAt!));
      tempCanceledEmail.sort((a, b) => a.statusUpdatedAt!.compareTo(b.statusUpdatedAt!));

      for(int j = 0; j < tempSuccessEmails.length; j++) {
        if(j == 0){
          tempSuccessEmails[j].isFirstEmail = true;
        }
        if(j == tempSuccessEmails.length-1){
          tempSuccessEmails[j].isLastEmail = true;
        }
        if(!tempSuccessEmails[j].isLastEmail &&  !tempSuccessEmails[j].isFirstEmail){
          recurringEmail[i].showHistoryButton = true;
        }
      }
      if(tempSuccessEmails.isNotEmpty){
        tempEmails.addAll(tempSuccessEmails);
      }
      if(tempReadyEmail.isNotEmpty){
        tempEmails.add(tempReadyEmail[0]);
      }
      if(tempClosedEmail.isNotEmpty){
        tempEmails.add(tempClosedEmail[0]);
      }
      if(tempCanceledEmail.isNotEmpty){
        tempEmails.add(tempCanceledEmail[0]);
      }
      recurringEmail[i].scheduleEmail = tempEmails;
    }
  }

  String getEmailSchedulerTitle({required RecurringEmailSchedulerModel item, String? name}){
    if(item.isFirstEmail){
      return '${'first'.tr.capitalize!} ${'email'.tr.capitalize!} ${'sent'.tr} ${'on'.tr} ';
    }
    if(item.isLastEmail){
      return '${'last'.tr.capitalize!} ${'email'.tr.capitalize!} ${'sent'.tr} ${'on'.tr} ';
    }
    if(item.status == 'closed'){
      return '${'closed'.tr.capitalize!} ${'on'.tr} ';
    }
    if(item.status == 'canceled'){
      return '${'recurring'.tr.capitalize!} ${'email'.tr.capitalize!} ${'cancelled'.tr} ${'by'.tr} ${name!} ${'on'.tr} ';
    }
    if(item.status == 'ready'){
      return '${'next'.tr.capitalize!} ${'email'.tr.capitalize!} ${'scheduled'.tr} ${'for'.tr} ';
    }
    if(!item.isFirstEmail && !item.isLastEmail && item.status == 'success'){
      return '${'email'.tr.capitalize!} ${'sent'.tr.capitalize!} ${'on'.tr} ';
    }
    return '';
  }

  String getEmailSchedulerDate({required RecurringEmailSchedulerModel item}){
    if(item.status == 'success'){
      return DateTimeHelper.formatDate(item.createdAt!, DateFormatConstants.dayDateFormat);
    }
    if(item.status == 'closed' || item.status == 'canceled'){
      return DateTimeHelper.formatDate(item.statusUpdatedAt!, DateFormatConstants.dayDateFormat);
    }
    if(item.status == 'ready'){
      return DateTimeHelper.convertHyphenIntoSlash(item.scheduleDate!);
    }
    return '';
  }
  
  Color getEmailSchedulerProcessDotColor(RecurringEmailSchedulerModel item){
     if(item.status == 'success' || item.status == 'closed'){
      return JPAppTheme.themeColors.primary;
    }
    
    if(item.status == 'canceled'){
      return JPAppTheme.themeColors.secondary;
    }

    if(item.status == 'ready'){
      return JPAppTheme.themeColors.warning;
    }
    return JPAppTheme.themeColors.text;
  }

  Color getEmailSchedulerProcessSpreadRadiusColor(RecurringEmailSchedulerModel item){
    if(item.status == 'success' || item.status == 'closed'){
      return JPAppTheme.themeColors.lightBlue;
    }
    if(item.status == 'canceled'){
      return JPAppTheme.themeColors.lightRed;
    }
    if(item.status == 'ready'){
      return JPAppTheme.themeColors.lightYellow;
    }
    return JPAppTheme.themeColors.text;
  }

  void openCancelNotesDialog(int id) {
    showJPGeneralDialog(
    child: (controller){
      return JPQuickEditDialog(
        title: 'confirmation'.tr.toUpperCase(),
        label: 'reason'.tr,
        type: JPQuickEditDialogType.textArea,
        maxLength: 250,
        confirmationMessage:'', 
        errorText: 'please_enter_cancellation_reason'.tr,
        suffixIcon: showJPConfirmationLoader(show: controller.isLoading),
        disableButton: controller.isLoading,
        suffixTitle: controller.isLoading ? '' : 'proceed'.tr,
        prefixTitle: 'CANCEL'.tr,
        position: JPQuickEditDialogPosition.center,
        onSuffixTap: (val) {
          cancelReccuringEmail(id: id, val: val, controller: controller);    
        },
          onPrefixTap: (value) {
          Get.back();
        },
      );
    });
  }

  void cancelReccuringEmail({required int id , required String val,required JPBottomSheetController controller}) async { 
    try{
      Map<String, dynamic> params = {
        'cancel_note': val,
      };
      controller.toggleIsLoading();
      await JobRepository().cancelRecurringEmail(params, id);
      Get.back();
      refreshData();
      Helper.showToastMessage('${'email'.tr} ${'recurring'.tr} ${'cancelled'.tr}'); 
    } catch(e) {
      rethrow;
    } finally {
      controller.toggleIsLoading();
    }     
  }

  Future<void> fetchEmailViewDetail(int id) async {
    Map<String, dynamic> params = {
      'include[0]': 'replies',
    };
    template = (await JobRepository.fetchEmailDetailView(id, params: params))['email_detail'];
  }

  void openEmailDetailView(int id) async {
    await fetchEmailViewDetail(id);
    openTemplateInDialog(template!);
  }

  void openTemplateInDialog(EmailTemplateListingModel template) {
    showJPBottomSheet(child: (controller) {
      return EmailTemplateViewDialog(
        showSelectButton: false,
        data: template, onSelect: () {
        Get.back();
      });
    }, isScrollControlled: true);
  }  
}
