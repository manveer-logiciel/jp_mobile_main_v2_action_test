import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/extensions/color/index.dart';
import 'package:jobprogress/common/models/email/template_list.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/recurring_email.dart';
import 'package:jobprogress/common/models/job/request_params.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/repositories/automation.dart';
import 'package:jobprogress/common/repositories/email_template.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/email.dart';
import 'package:jobprogress/common/services/email/handle_db_elements.dart';
import 'package:jobprogress/core/constants/automation.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/recurring_constant.dart';
import 'package:jobprogress/core/constants/work_flow_stage_color.dart';
import 'package:jobprogress/core/utils/color_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/email_editor/editor_controller.dart';
import 'package:jobprogress/global_widgets/recurring_bottom_sheet/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class JobSaleAutomationEmailLisitingController extends GetxController {
  
  List<EmailTemplateListingModel> templateList = [];
  
  String? stageCode = Get.arguments?['stage_code'];

  bool createTask =  Get.arguments?['create_task'] ?? false;

  bool sendCustomerEmail = Get.arguments?['send_customer_email'] ?? false;

  String automationId = Get.arguments?[NavigationParams.automationId].toString() ?? '';
  
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int? jobId = Get.arguments?['jobId']; 

  JobModel? job;

  bool isLoading = true;
  bool isDataLoaded = false;
  bool buttonLoading = false;
  bool hideSendButton = false;
  bool allDataSend = false;
  bool maintainWebViewState = true;
  bool emailSentOrSkipped = false;
  
  late EditorController editorController;

  late InAppWebViewController webViewController;

  TextEditingController timeInput = TextEditingController();

   AutoScrollController scrollController = AutoScrollController(
    axis: Axis.vertical,
    initialScrollOffset: 0,
  ); 
  
  @override
  void onInit() async{
    editorController = EditorController();
    getAllData(); 
    super.onInit();
  }

  void scrollList(int index) {
    Timer(const Duration(milliseconds: 700), () async {
      scrollController.scrollToIndex(
        index,
        preferPosition: AutoScrollPosition.begin,
        duration: const Duration(milliseconds: 1000)
      );
    });
  }
  
  void openSaleAutomationBottomSheet(int index) async {
    showJPBottomSheet (
      ignoreSafeArea: false,
      isScrollControlled: true,
      isDismissible: true,
      enableInsets: true,
      child: (_) {
        return RecurringBottomSheet (
          recurringEmaildata: templateList[index].recurringEmailData?? RecurringEmailModel(),
          job: job!,
          onDone:(RecurringEmailModel? data) {
            templateList[index].recurringEmailData = data;
            templateList[index].isRepeatEnable = true;
            update();
          } ,
        );   
      },
    ); 
  }

  String  getEndStageName({required int index, JobModel? job, required List<EmailTemplateListingModel> templateList}) {
    return job!.stages!.firstWhere((element) => element.code == templateList[index].recurringEmailData!.endStageCode).name; 
  }

  Color getEndStageColor({required int index, required JobModel job, required List<EmailTemplateListingModel> templateList}) {
    String color =job.stages!.firstWhere((element) => element.code == templateList[index].recurringEmailData!.endStageCode).color;
    return ColorHelper.getHexColor(WorkFlowStageConstants.colors[color]!.toHex());
  }

  String getToEmails(int index) {
   return templateList[index].to!.map((user) => Helper.getEmailTo(user)).join(', ');
  }

  void toggleIsChecked(int index, List<EmailTemplateListingModel> templateList) {
    templateList[index].isChecked = !templateList[index].isChecked;
    templateList[index].hideSendButton = !templateList[index].hideSendButton; 
    if(templateList.every((element) => element.hideSendButton == true)){
      hideSendButton = true;
    } else {
      hideSendButton = false;
    }
    update();
  }

  void toggleRepeat(int index) {
    if(templateList[index].isRepeatEnable) {
      templateList[index].isRepeatEnable = false;
      update();
    } else {
      openSaleAutomationBottomSheet(index);
    }  
  }

  Future<void> getJobSummarydata() async {
    try {
      final jobSummaryParams = JobRequestParams.forJobSummary(jobId!);
      job = (await JobRepository.fetchJob(jobId!, params: jobSummaryParams))['job'];

    } catch (e) {
      rethrow;
    } 
  }

  void setEmailData(List<String> customerType , List<String> emailType) {
    for(String customer in customerType) {
      if(customer == RecurringConstants.customer) { 
        if(job!.customer!.email!.isNotEmpty) {
          emailType.add(job!.customer!.email!);  
        } 
      }
      if(customer == RecurringConstants.customerRep) {
        if(job!.customer!.rep != null) {
            emailType.add(job!.customer!.rep!.email);
        }
      }
      if(customer == RecurringConstants.companyCrew) {
        for(UserLimitedModel user in job!.reps!) {
          emailType.add(user.email);  
        }
      }
      if(customer == RecurringConstants.sub) {
        for(UserLimitedModel user in job!.subContractors!) {
          emailType.add(user.email);
        }
      }
      if(customer == RecurringConstants.estimate) {
        for(UserLimitedModel user in job!.estimators!) {
          emailType.add(user.email);
        }
      }
    } 
  }

  void filterAndSetEmailSettingBase() {
  for(EmailTemplateListingModel email in templateList)
    {
      if(Helper.isTrue(email.sendToCustomer)){
        email.recipientSetting!.to.add(RecurringConstants.customer);
      }
      setEmailData(email.recipientSetting!.to, email.to!);
      setEmailData(email.recipientSetting!.bcc, email.bcc!);
      setEmailData(email.recipientSetting!.cc, email.cc!);
      email.to = email.to?.toSet().toList();
      email.bcc = email.bcc?.toSet().toList();
      email.cc = email.cc?.toSet().toList();
    }
  }
  
  Future<void> getSaleAutomationData() async {
    try {
      final params = <String, dynamic> {
        'active': 1,
        'includes[]': ['attachments'],
        'limit': 0,
        'recurring': false,
        'stage_code': stageCode
      };
      Map<String, dynamic> response = await EmaiTemplatelListingRepository.fetchTemplateList(params,'sale_automation');
       List<EmailTemplateListingModel> list = response['list'];
       templateList = list;
    } catch (e) {
      rethrow;
    } 
  }

  String validationMessage(int i) {
    if(templateList[i].isToEmpty) {
      if(templateList[i].isSubjectEmpty) {
        return '${'recipients'.tr.capitalize!} ${'and'.tr} ${'subject'.tr.capitalize!} ${'can_t'.tr} ${'be'.tr} ${'empty'.tr}';
      } else {
        return '${'recipients'.tr.capitalize!} ${'can_t'.tr} ${'be'.tr} ${'empty'.tr}';
      }
    }
    if(templateList[i].isSubjectEmpty) {
      return '${'subject'.tr.capitalize!} ${'can_t'.tr} ${'be'.tr} ${'empty'.tr}'; 
    }
    return '';
  }

  void validateEmail(int i){
    if(templateList[i].to == null || templateList[i].to!.isEmpty) {
        templateList[i].isToEmpty = true;
    } else {
      templateList[i].isToEmpty = false;
    }

    if(templateList[i].subject == null || templateList[i].subject!.isEmpty) {
      templateList[i].isSubjectEmpty = true;
    }
    else{
      templateList[i].isSubjectEmpty = false;
    }
    update();
  }


  Future<void> validateAndSendEmail(int i) async {
    if(i<templateList.length){
      if(i == 0){
        buttonLoading = true;
        update();
      }
      validateEmail(i);
  /// template is set to repeat, it will send a recurring email. If not, it will
  /// send a normal email. If all the email templates have been sent, it will set
  /// have not been sent, it will set [allDataSend] to false and show the send button.
  /// [allDataSend] to true and hide the send button. If any of the email templates
      if(templateList[i].isChecked && templateList[i].isApiRequestFailed == null) {
        if(templateList[i].isToEmpty|| templateList[i].isSubjectEmpty) {
          if(templateList.length > 3) {
            scrollList(i);
          }
          templateList[i].dataSent = false;
          i++;
          validateAndSendEmail(i);
        } else {
          templateList[i].hideSendButton = true;
          
          if(templateList[i].isRepeatEnable) {
            RecurringEmailModel recurringEmailData = templateList[i].recurringEmailData!;
            
            // Process attachments for size and convert to URLs if needed
            final attachmentData =
                await processAttachmentsForEmail(i, isRecurring: true);
            
            final sendReccuringEmailParams = <String, dynamic> {
              if(
                recurringEmailData.repeat == 'weekly' || 
                recurringEmailData.repeat == 'monthly'
              )
              'by_days': [recurringEmailData.byDay],
              if(recurringEmailData.occurrence == 'job_end_stage_code')...{
                'job_end_stage_code': recurringEmailData.endStageCode
              } else...{
                'occurence': recurringEmailData.occurrence
              },
              'job_current_stage_code': job!.currentStage!.code,
              'interval': recurringEmailData.interval, 
              'repeat': recurringEmailData.repeat,
              'email_template_id': templateList[i].id,
              'job_id':  job!.id,
              'email': {
                'content': attachmentData['content'],
                'subject': templateList[i].subject,
                'recipients': getRecipientsForReccuringEmail(i),
                'attachments': attachmentData['attachments'],
              },
            };
            try {
              await EmaiTemplatelListingRepository.sendRecurringEmail(sendReccuringEmailParams);
              templateList[i].isApiRequestFailed = false;
              templateList[i].dataSent = true;
              update();
            } catch(e) {
              templateList[i].isApiRequestFailed = true;
              templateList[i].dataSent = false;
              update();
              rethrow;
            } finally {
              i++;
              await validateAndSendEmail(i);
            }
          } else {
            // Process attachments for size and convert to URLs if needed
            final attachmentData = await processAttachmentsForEmail(i);
            
            final sendEmailParams = <String, dynamic> {
              ...getRecipients(i),
              'content': attachmentData['content'],
              'customer_id': job!.customer!.id,
              'id': templateList[i].id,
              'job_id': [job!.id],
              'main_job_id': job!.id,
              'new_format': 1,
              'stage_code': job!.currentStage!.code,
              'subject': templateList[i].subject,
              'attachments': attachmentData['attachments'],
            };
            try {
              await EmaiTemplatelListingRepository.sendEmail(sendEmailParams);
              templateList[i].isApiRequestFailed = false;
              templateList[i].dataSent = true;
              update();
            } catch (e) {
              templateList[i].isApiRequestFailed = true;
              templateList[i].dataSent = false;
              update();
              rethrow;
            } finally {
              i++;
              await validateAndSendEmail(i);
            }    
          }
        }   
      } else {
        i++;
        await validateAndSendEmail(i);
      }
    } else {
      if(templateList.every((element) => element.dataSent == true)){
        allDataSend = true;
        update();
      } else {
        allDataSend = false;
        update();
      }
      buttonLoading = false;
      update();
      checkNeedToHideSendButton();
    }     
  }

  /// [getRecipients] gives the email recipients for the email to be sent
  /// [i] is the index of the email template
  Map<String, dynamic> getRecipients(int i) {
    return {
      'to[]': templateList[i].to,
      'cc[]': templateList[i].cc,
      'bcc[]': templateList[i].bcc,
    };
  }

  Map<String, dynamic> getRecipientsForReccuringEmail(int i) {
    return {
      'to': {
        for (int j = 0; j < (templateList[i].to?.length ?? 0); j++) 
          '$j': templateList[i].to![j]
      },
      'cc': {
        for (int j = 0; j < (templateList[i].cc?.length ?? 0); j++) 
          '$j': templateList[i].cc![j]
      },
      'bcc': {
        for (int j = 0; j < (templateList[i].bcc?.length ?? 0); j++) 
          '$j': templateList[i].bcc![j]
      }
    };
  }

  void navigateToNextScreen() {
    if(createTask) {
      Get.toNamed(
        Routes.jobSaleAutomationTaskListing,
        arguments:{
          'jobId': jobId,
          'stage_code': stageCode,
          'send_customer_email': sendCustomerEmail,
          NavigationParams.automationId: automationId
        }
      );  
    }
    else {
      Get.back(result: emailSentOrSkipped);
    }
  }

  Future<void> sendEmail() async {
    await validateAndSendEmail(0);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    emailSentOrSkipped = await automationStatusUpdate(automationId, emailStatus: AutomationConstants.sent);
    if(allDataSend) {
      navigateToNextScreen();
    }
  }


  Future<void> skippedEmail() async {
    emailSentOrSkipped = await automationStatusUpdate(automationId, emailStatus: AutomationConstants.skipped);
    navigateToNextScreen();
  }

  Future<bool> automationStatusUpdate(String id, {required String emailStatus}) async {
    if(Helper.isValueNullOrEmpty(id)) {
      return false;
    }
    try{
      final params = <String, dynamic> {
        'email_automation_status': emailStatus,
        'task_automation_status': emailStatus,
      };
      return  AutomationRepository().updateEmailTaskAutomationStatus(id:id, params: params);
    } catch(e) {
      rethrow;
    }
  }

  void getdataFromNextScreen(int i) async {
    EmailTemplateListingModel emailTemplateListingModel = await(
      Get.toNamed(Routes.composeEmail, arguments: {'jobId' : jobId, 'template': templateList[i], 'isEdit': true, 'action': 'sales_automation'})
    );  
    templateList[i] = emailTemplateListingModel;
    validateEmail(i);
    update();
  }

  void checkNeedToHideSendButton() {
    if(templateList.every((element) => element.hideSendButton == true)){
      hideSendButton = true;
    } else {
      hideSendButton = false;
    }
    update();
  }
 
  void refreshPage() {
    isLoading = true;
    update();
    getAllData();
  }
  
  Future<void> processJsData(int i) async {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      editorController.webViewController.addJavaScriptHandler(handlerName: "updateContent", callback: (dynamic args) {
        templateList[i-1].actualTemplate = args[0];
      }); 
    if(i < templateList.length){
      await setHtmlJs(i);  
      i++;
      await processJsData(i);
    }
    maintainWebViewState = false;
    update();
  }

  Future<void> setHtmlJs(int i) async {
    await editorController.setHtml(templateList[i].actualTemplate!);
    EmailDbElementService.setSoucreString(customer: job?.customer, job: job,content: templateList[i].actualTemplate);
    await editorController.webViewController.evaluateJavascript(source: EmailDbElementService.sourceString);
    update(); 
  }

  void getAllData() async {
    try {
      await Future.wait([
        getJobSummarydata(),
        getSaleAutomationData(),
      ]);
      isDataLoaded = true;
      update();
      await Future<void>.delayed(const Duration(milliseconds: 1000));
      await processJsData(0);
      filterAndSetEmailSettingBase();
    } catch(e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  /// Check if attachments exceed size limit and convert to URLs if needed
  Future<Map<String, dynamic>> processAttachmentsForEmail(int templateIndex,
      {bool isRecurring = false}) async {
    final template = templateList[templateIndex];

    if (template.attachments == null || template.attachments!.isEmpty) {
      return {
        'attachments': <Map<String, dynamic>>[],
        'content': template.actualTemplate
      };
    }

    // Calculate total attachment size
    int totalSize = 0;
    for (final attachment in template.attachments!) {
      totalSize += attachment.size ?? 0;
    }

    // If total size is within limit, return attachments as normal
    if (totalSize <= CommonConstants.maxAllowedEmailFileSize) {
      if (isRecurring) {
        return {
          'attachments': List.generate(
              template.attachments!.length,
              (index) => {
                    "ref_type": template.attachments![index].type,
                    "ref_id": template.attachments![index].id
                  }).toList(),
          'content': template.actualTemplate
        };
      } else {
        return {
          'attachments': List.generate(
              template.attachments!.length,
              (index) => {
                    "type": template.attachments![index].type,
                    "value": template.attachments![index].id
                  }).toList(),
          'content': template.actualTemplate
        };
      }
    }

    // If size exceeds limit, convert attachments to URLs and add to content
    String updatedContent = template.actualTemplate ?? '';

    // Add attachment links to the content
    String attachmentAnchorTag = '';
    final emailRepo = EmailListingRepository();

    for (final attachment in template.attachments!) {
      try {
        Map<String, dynamic> params = {
          'file_id': attachment.id,
          'type': attachment.type
        };
        String url = await emailRepo.getAttachmentUrl(params);

        attachmentAnchorTag +=
            '<a contentEditable="false" class="email-attachment-link email-s3-attachment-file" style="padding: 10px; margin: 0 8px; background: #f5f5f5; display: inline-block; border: 1px solid #ddd; position: relative; min-width: 240px; max-width: 240px" href="$url"><img src="https://www.jobprogress.com/wp-content/uploads/2018/06/gmail-doc-icon.png" style="position: absolute; top: 50%; transform: translateY(-50%); -webkit-transform: translateY(-50%);"><span style="font-size: 18px; max-width: 96%; overflow: hidden; text-overflow: ellipsis; display: inline-block; white-space: nowrap; color: #4986e7; vertical-align: middle; padding-left: 22px; padding-top: 1px;" contentEditable="false" class="content-link-span">${attachment.name ?? 'Attachment'}</span></a>';
      } catch (e) {
        Helper.handleError(e);
        // If URL generation fails, continue with the file as normal attachment
        Helper.showToastMessage(
            'Failed to process attachment: ${attachment.name}');
      }
    }

    // Insert attachment links into content
    if (attachmentAnchorTag.isNotEmpty) {
      String indicator =
          '<hr id="attachment-link-indication" style="border:none;" />';

      if (updatedContent.contains(indicator)) {
        List<String> contentParts = updatedContent.split(indicator);
        updatedContent =
            "${contentParts[0]}<p>&nbsp;</p>$attachmentAnchorTag$indicator${contentParts[1]}";
      } else {
        updatedContent = updatedContent + attachmentAnchorTag;
      }
    }

    return {
      'attachments':
          <Map<String, dynamic>>[], // Empty since we converted to URLs
      'content': updatedContent
    };
  }
}
