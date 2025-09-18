import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/job_financial_listing.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/email/email.dart';
import 'package:jobprogress/common/models/email/profile_detail.dart';
import 'package:jobprogress/common/models/email/suggestion.dart';
import 'package:jobprogress/common/models/email/template_list.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/company/company.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/repositories/company_files.dart';
import 'package:jobprogress/common/repositories/customer.dart';
import 'package:jobprogress/common/repositories/email.dart';
import 'package:jobprogress/common/repositories/estimations.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/common/repositories/job_photos.dart';
import 'package:jobprogress/common/repositories/job_proposal.dart';
import 'package:jobprogress/common/repositories/material_lists.dart';
import 'package:jobprogress/common/repositories/measurements.dart';
import 'package:jobprogress/common/repositories/work_order.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/email/handle_db_elements.dart';
import 'package:jobprogress/common/services/file_attachment/quick_actions.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/mix_panel/event/add_events.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/recurring_constant.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/email_editor/editor_controller.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/ChipsInput/index.dart';
import '../../../global_widgets/upload_progress_dialog/index.dart';


class EmailComposeController extends GetxController {
  
  CompanyModel? companyDetails;
  EmailSuggestionModel? emailSuggestionModel;
  JobModel? job;
  CustomerModel? customer;
  CompanyContactListingModel? companyContact;
  
  dynamic emailAction = Get.arguments?['action'];
  String loggedInUserEmail = AuthService.userDetails!.email!;
  List<AttachmentResourceModel>? routeParamsAttachments = Get.arguments?['attachment'];
  List<FilesListingModel>? files = Get.arguments?['files'];
  List<EmailProfileDetail>? routeParamsRecepientList = Get.arguments?['to_list'];
  List<String>? pathList = Get.arguments?[NavigationParams.filePaths];

  EmailTemplateListingModel? emailTemplateData = Get.arguments?['template'];
  EmailProfileDetail? routeParamsRecepient  = Get.arguments?['to'];
   
  bool  isEdit = Get.arguments?['isEdit'] ?? false;
  bool isThanksEmailActive = true;
  
  String? jobScheduleId = Get.arguments?['job_schedule_id'];
  
  int? financialFileId = Get.arguments?['financial_file_id'];
  int? jobId = Get.arguments?['jobId'];
  int newFormat = 0;
  int? customerId = Get.arguments?['customer_id'];
  int? contactId = Get.arguments?['contact_id'];
  int? replyForwardEmailId = Get.arguments?['email_id'];
  
  String attachLinkIndicator = '<hr id="attachment-link-indication" style="border:none;" />';
  String emailSignIndicator = '<hr id="email-sign-indication" style="border:none;" />';

  List<AttachmentResourceModel> attachments = [];
  List<AttachmentResourceModel> attachmentsForUpload = [];
  
  int allowedSizeForEmailInBytes = 7340032; // 7MB Size
 
  final suggestionBuilderKey = GlobalKey<JPChipsInputState<dynamic>>();
  
  bool showCustomerField = false;
  bool isAttachmentSizeOver = false;
  bool ccVisibilty = false;
  bool bccVisibilty = false;
  bool toVisibilty = false;
  bool userFilter = true;
  bool isUserSelected = true;
  bool isCustomerSelected = true;
  bool isContactSelected = true;
  bool isLabourSelected = true;
  bool canShowReplyForward = false;
  bool showCursor = true;

  List<String> to =[];
  List<String> cc =[];
  List<String> bcc=[];
  
  List<EmailProfileDetail> initialToValues = [];
  List<EmailProfileDetail> initialCcValues = [];
  List<EmailProfileDetail> initialBccValues = [];
  
  String subject = ''; 
  String actionFromTitle = '';
  String actionFromDetail = '';
  List<EmailProfileDetail>? suggestionList;

  ScrollController scrollController = ScrollController();

  late EditorController editorController;

  late EditorController replyEditorController;

  TextEditingController subjectController = TextEditingController();

  EmailListingModel? replyForwardEmail;

  void setAttachments() async {
    // Converting files to attachments so, they can be attached as links
    // when combined size is greater than 7MB
    final attachedFiles = files?.map((e) {
      return AttachmentResourceModel.fromFileModel(e, emailAction);
    }).toList();

    // Attaching files to email if any
    if (attachedFiles?.isNotEmpty ?? false) {
      handleAttachments(attachedFiles!);
    }
  }

  void toggleIsUserSelected(){
    isUserSelected = !isUserSelected;
    update();
  }

  void toggleIsCustomerSelected(){
    isCustomerSelected = !isCustomerSelected;
    update();
  }

  void toggleIsContactSelected(){
    isContactSelected = !isContactSelected;
    update();
  }

  void toggleIsLabourSelected(){
    isLabourSelected = !isLabourSelected;
    update();
  }

  void validateEmailFormat(String val) {
    if(!GetUtils.isEmail(val)) {
      Helper.showToastMessage('invalid_email'.tr);
    }
  }
  
  void openTemplateList() async {
    dynamic selectedTemplate = (await Get.toNamed(Routes.emaiTemplateList));
    if (selectedTemplate == null) return;
    newFormat = selectedTemplate.newFormat ? 1 : 0 ;
    clearPreFilledData(selectedTemplate);
    addEmailsAccordingToSetting(selectedTemplate);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    setDataForEmailCompose(emailTemplate: selectedTemplate);
    toVisibilty = true;
    // For Set DBelement in the template
    await Future<void>.delayed(const Duration(milliseconds: 500));
    editorController.webViewController.evaluateJavascript(source: EmailDbElementService.sourceString);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    editorController.setEditorHeight();
    update();
  }

  Future<AttachmentResourceModel> getAttachment(FilesListingModel file, FLModule emailAction)async{
    switch (emailAction) {
        case FLModule.companyFiles:
          return await  CompanyFilesRepository.getAttachment(file.id!);
        case FLModule.instantPhotoGallery:
          return  AttachmentResourceModel.fromJson(file.toJson());
        case FLModule.estimate:
          return await EstimatesRepository.getAttachment(file.id!);
        case FLModule.jobPhotos:
          return await JobPhotosRepository.getAttachment(file.id!);
        case FLModule.measurements:
          return await  MeasurementsRepository.getAttachment(file.id!);
        case FLModule.materialLists:
          return await MaterialListsRepository.getAttachment(file.id!);
        case FLModule.workOrder:
          return await WorkOrderRepository.getAttachment(file.id!);
        case FLModule.stageResources:
          return await JobPhotosRepository.getAttachment(file.id!);
        default:
        return await  CompanyFilesRepository.getAttachment(file.id!);
    }
  }

  Future<AttachmentResourceModel> getFinancialModuleAttachmentData()async{
    switch(emailAction){
      case JFListingType.paymentsReceived:
       return await getPaymentReceviedAttachment();
      case JFListingType.jobInvoicesWithoutThumb:
      return await getJobInvoiceAttachment();
      default:
      return await getPaymentReceviedAttachment();
    }
  }

  void hideCursorPointer() {
    showCursor = false;
    update();
  }

  void showCursorPointer() {
    showCursor = true;
    update();
  }

  Future<bool> saveValidateContent({bool forSaveData = false}) async {
    editorController.webViewController.addJavaScriptHandler(handlerName: "updateContent", callback: (dynamic args) async {
      if(forSaveData){
        validateEmail(args[0]);
      } else {
        if(isNewDataAdded(args[0])) {
          editorController.removeFocus();
          await Future<void>.delayed(const Duration(milliseconds: 200));

          Helper.showUnsavedChangesConfirmation();
        } else {
          Helper.hideKeyboard();
          Get.back();
        }
      }
    }
   );

    String replyHtml = '';

    if(canShowReplyForward) {
      replyHtml = await replyEditorController.getHtml();
      replyHtml = replyEditorController.processHtml(html: replyHtml);
    }
    String sourceString = '''
      var content = \$('#emailCompose').summernote('code');
      var cntr = \$("<div />");
      cntr.append(content);
      content = undefined;
      'content = content.replaceAll("<hr id="attchment-link-indication" style="border:none;" />", "");'
      cntr.find("*").removeAttr("contenteditable");

      \$.each(\$(cntr).find("a"), function (key, value) {
        var href = \$(this).attr("data-prop-url");
        var ref = \$(this).attr("ref");
        // data-prop-url is a property that is being added locally so that the links are not clickable
        // in edit or compose email mode. In case its not be replaced with the actual href using it directly from href
        if (!href) {
          href = \$(this).attr("href");
        }
        if ("$emailAction" == "${FLModule.jobProposal}" && ref == "public-button") {
          href += "?thank_you_email=" + "${isThanksEmailActive ? 1 : 0}";
        }
        \$(this).attr("href", href);
      });

      var messageContent = "<p>" + cntr.html() + "</p>";

      messageContent += "$replyHtml";

      window.flutter_inappwebview.callHandler("updateContent", messageContent);
    ''';

    editorController.webViewController.evaluateJavascript(source: sourceString);
    return false;
  }
  
  EmailComposeController() {
    editorController = EditorController(
      scrollController: scrollController,
    );

    replyEditorController = EditorController(
      scrollController: scrollController,
    );
    getAllData();
  }

  bool isNewDataAdded(String content) {
    String  parsedContent = Helper.parseHtmlToText(content);
    
    if(to.isNotEmpty || cc.isNotEmpty || bcc.isNotEmpty || subject.isNotEmpty ||
      parsedContent.isNotEmpty || attachments.isNotEmpty ) {
      return true;
    }
  
    return false;
  }


  Future<AttachmentResourceModel> getJobInvoiceAttachment() async{
    return await JobFinancialRepository.getInvoiceAttachment(financialFileId.toString());
  }
   
  Future<AttachmentResourceModel> getPaymentReceviedAttachment() async{
     Map<String, dynamic> query = {
      'id': financialFileId,
      'save_as_attachment': 1
    };
    return await JobFinancialRepository.getPaymentSlipAsAttachment(financialFileId.toString(), query);
    
  }

  Future <void> getDataFromJob() async {
    Map<String, dynamic> params = {
      'includes[0]': 'customer.contacts',
      'includes[1]': 'contact',
      'includes[2]': 'contacts.emails',
      'includes[3]': 'contacts.phones',
      'includes[4]': 'contacts.address',
      'includes[5]': 'financial_details',
      'includes[6]': 'insurance_details',
      'includes[7]': 'customer.referred_by',
      'includes[8]': 'delivery_dates',
      'includes[9]': 'division',
      'includes[10]': 'upcoming_appointment',
      'includes[11]': 'upcoming_schedule',
    };
    job = (await JobRepository.fetchJob(jobId!, params: params))['job'];
    if(!isEdit && routeParamsRecepient == null && routeParamsRecepientList == null) {
      if(job!.customer!.email != null && job!.customer!.email!.isNotEmpty){
        routeParamsRecepient = EmailProfileDetail(email: job!.customer!.email!, name: job!.customer!.fullName!);
      } else {
        Helper.showToastMessage('no_email_address_registered'.tr);
      }
            
    }
    
  }

  Future <void> getDataFromCustomer() async {
    Map<String, dynamic> params = {
      'id' : customerId,
      'includes[]': 'flags.color'
    }; 
    customer = (await CustomerRepository.getCustomer(params));
    if(customer!.email != null && customer!.email!.isNotEmpty ){
      routeParamsRecepient = EmailProfileDetail(name: customer!.fullName!, email: customer!.email!);
    } else {
      Helper.showToastMessage('no_email_address_registered'.tr);
    }
    
  }

  
  Future <void> getDataFromJobschedule() async {
    List<AttachmentResourceModel> tempAttachment =[];
      Map<String, dynamic> query = {
      'save_as_attachment': 1
    };
    AttachmentResourceModel attachment = await JobRepository.getAttachment(jobScheduleId.toString(),query);
    tempAttachment.add(attachment);
    routeParamsAttachments = tempAttachment;
  }

  Future<void> getAttachmentsFromFile() async {
    if(pathList != null) {
      if(emailAction == FLModule.cumulativeInvoices) {
        await showJPGeneralDialog(
          child: (_) => UploadProgressDialog<AttachmentResourceModel>(
            paths: pathList!,
            onAllFilesUploaded: (files) async {
              handleAttachments(files);
            },
          ),);
      } else if(emailAction != FLModule.jobProposal) {
        List<AttachmentResourceModel> attachments = [];
        for(FilesListingModel file in files!) {
          AttachmentResourceModel attachment =  await getAttachment(file, emailAction!);
          attachments.add(attachment);
        }
        routeParamsAttachments = attachments;
      } else {
        EmailTemplateListingModel tempData;
        Map<String,dynamic> queryParams = {
          'id': files![0].id, 
          'includes[0]': 'attachments'
        };
        tempData =  await JobProposalRepository.getEmailTemplate(files![0].id!, queryParams);  
        emailTemplateData = tempData;
      }
      
    }
    if(emailAction == FLModule.jobProposal){
      EmailTemplateListingModel tempData;
      Map<String,dynamic> queryParams = {
        'id': files![0].id, 
        'includes[0]': 'attachments'
      };
      tempData =  await JobProposalRepository.getEmailTemplate(files![0].id!, queryParams);  
      emailTemplateData = tempData;
    }
    if(financialFileId != null){
      List <AttachmentResourceModel>tempAttachmentList =[]; 
      AttachmentResourceModel attachment = await getFinancialModuleAttachmentData();
      tempAttachmentList.add(attachment);
      routeParamsAttachments = tempAttachmentList;
    }
  }

  void getAllData() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    setAttachments();
    showJPLoader();
    
    if(replyForwardEmailId != null) {
      canShowReplyForward = true;
      Map<String, dynamic> emailsParams = {
        'id': replyForwardEmailId,
        'includes[0]': 'createdBy',
        'includes[1]': 'attachments',
        'includes[2]': 'replies',
      };
      replyForwardEmail = await EmailListingRepository().fetchEmailReply(emailsParams);
      setReplyForwardData();
    } else {
      await getAttachmentsFromFile();
      if(jobId != null || customerId != null || contactId != null)  {
        showCustomerField = true;
      }
      if(jobId != null && replyForwardEmailId == null) {
        await getDataFromJob();
      }
      if(customerId != null && replyForwardEmailId == null) {
        await getDataFromCustomer();
      }
      if(jobScheduleId != null && replyForwardEmailId == null) {
        await getDataFromJobschedule();
      }
      
        
      await setDataForEmailCompose(emailTemplate: emailTemplateData);
    }

    toVisibilty  = true;
    update();
    Get.back();
  
    if(emailAction != FLModule.cumulativeInvoices) {
    EmailDbElementService.setSoucreString(customer: job?.customer, job: job, proposalUrl: emailTemplateData?.shareUrl);
    }
  }

  void setReplyForwardData() {
    String content;
    if (emailAction == "forward") {
      // Set Predefine Content
      routeParamsAttachments = replyForwardEmail!.attachments;
      content =
        "<br>$attachLinkIndicator$emailSignIndicator---------- Forwarded message ----------<br> From: ${replyForwardEmail!.from!} <br> Date: ${DateTimeHelper.formatDate(replyForwardEmail!.createdAt!, DateFormatConstants.dateTimeFormatWithoutSeconds)} <br> Subject: ${replyForwardEmail!.subject!} <br> To: ${replyForwardEmail!.to!.join("")} <br><br>${replyForwardEmail!.htmlFromApi!}";
    } else {
      content =
        "<br>$attachLinkIndicator${emailSignIndicator}On ${DateTimeHelper.formatDate(replyForwardEmail!.createdAt!, DateFormatConstants.dateTimeFormatWithoutSeconds)}, <<a href='mailto:${replyForwardEmail!.from!}'>${replyForwardEmail!.from!}</a>> wrote:<blockquote>${replyForwardEmail!.htmlFromApi!}</blockquote>";
    }
    newFormat = 1; 
    replyForwardEmail!.htmlFromApi = content;
    setDataForEmailCompose(emailTemplate: replyForwardEmail, isReply: true);
  }

  void validateEmail(String content) async {
    String parsedHtml = Helper.parseHtmlToText(content);
    if(to.isEmpty){
      Helper.showToastMessage('please_provide_at_least_one_recipient'.tr);  
      return;
    } 
    if(subject.isEmpty) {
      Helper.showToastMessage("email_subject_cant_be_blank".tr);
      return;
    }
    if(parsedHtml.isEmpty) {
      Helper.showToastMessage('message_cannot_be_empty'.tr);
      return;
    }
    if(isEdit){
      saveEditEmail(content);
      Get.back(result: emailTemplateData);
    } else {
      emailSentRequest(to, cc, bcc, subject, content);
    }
  }

  void saveEditEmail(String content){
    emailTemplateData!.cc = cc;
    emailTemplateData!.bcc =  bcc;
    emailTemplateData!.to = to;
    emailTemplateData!.subject = subject;
    emailTemplateData!.attachments = attachments;
    emailTemplateData!.actualTemplate = content;
  }
  
  Future<void> emailSentRequest(List<String>to, List<String>cc, List<String>bcc, String subject, String content) async {

    int? sentEmailId;
    try{
      showJPLoader();
          Map<String, dynamic> params = {
      'attachments' : List.generate(attachments.length, (index) => {
          "type": attachments[index].type,
          "value": attachments[index].id
        }).toList(),
      'from': loggedInUserEmail,
      'content': content,
      if(job != null)
      'customer_id': job!.customerId,
      if(emailAction == FLModule.jobProposal && files != null && files!.isNotEmpty)
      'proposal_id':files![0].id,
      'subject': subject,
      'to[]' : to,
      'cc[]' : cc,
      'bcc[]': bcc,
      'new_format': newFormat
    };
    params.addIf(jobId != null,'job_id', jobId);
    params.addIf(customerId != null,'customer_id', customerId);
    params.addIf(replyForwardEmailId != null && emailAction != 'forward', 'reply_to', replyForwardEmailId);
    sentEmailId = await EmailListingRepository.sentEmailData(params);
      Helper.showToastMessage('${'email'.tr.capitalize!} ${'sent'.tr.capitalize!}');
      MixPanelService.trackEvent(event: MixPanelAddEvent.emailComposeSuccess);
    } catch(e) {
      MixPanelService.trackEvent(event: MixPanelAddEvent.emailComposeFailure);
      rethrow;
    } finally {
      await Future<void>.delayed(const Duration(seconds: 2));
      Get.back();
      Get.back(
          result: sentEmailId == null ? <dynamic>{} : {
            'id' : sentEmailId
          }
      );
    }
  }


  void filterSuggestionList(){
    setSuggestionEmailData('');
  }

  Future<void> getSuggestionEmailData(String query) async {
    Map<String, dynamic> params = {
      'query': query
    };
    emailSuggestionModel = (await EmailListingRepository.fetchEmailSuggestion(params))['email_suggestion'];  
  }

  void setActionFromData() {
    if(replyForwardEmailId == null){
      if(jobId != null){
      actionFromTitle = '${'customer'.tr.capitalize!} / ${'job'.tr.capitalize!}';
      actionFromDetail = '${job!.customer!.fullName} / ${Helper.getJobName(job!)}';
    }
    if(customerId != null){
      actionFromTitle = 'customer'.tr.capitalize!;
      actionFromDetail = customer!.fullName!;
    }
    if(contactId != null){
      actionFromTitle = 'contact'.tr.capitalize!;
      actionFromDetail = routeParamsRecepient!.name.toUpperCase();
    }
    update();
    }
  }
  
  
  void setSuggestionEmailData(String? query){
    List<EmailProfileDetail> tempList =[];
    if(query != null && query.isNotEmpty){
      if(GetUtils.isEmail(query)){
        tempList.add(
          EmailProfileDetail(
          name: query,
          email: query,
          initial: query[0].toUpperCase()
          )
        );
      }
    }
    
    if(emailSuggestionModel!.users != null && isUserSelected){
      for (var element in emailSuggestionModel!.users!) {
        tempList.add(
        EmailProfileDetail(
          name:element.fullName,
          email:element.email!,
          imageUrl:element.profilePic,
          initial: element.intial,
          color: element.color,
          group: 'user'.tr.capitalizeFirst,
        )); 
      }
    }
    if(emailSuggestionModel!.labour != null && isLabourSelected){
      for (var element in emailSuggestionModel!.labour!) {
        tempList.add(
        EmailProfileDetail(
          name:element.fullName,
          email:element.email!,
          imageUrl:element.profilePic,
          initial: element.intial,
          color: element.color,
          group: 'labour'.tr,
        )); 
      }
    }
    if(emailSuggestionModel!.contacts != null && isContactSelected){
      for (var element in emailSuggestionModel!.contacts!) {
        if(element.emails!.isNotEmpty && element.emails![0].email.isNotEmpty){
          tempList.add(
            EmailProfileDetail(
              initial: element.intial,
              name:element.fullName!,
              email:element.emails![0].email,
              group: 'contact'.tr.capitalize!,
            )
          ); 
        }
      }
    }
    if(emailSuggestionModel!.customer != null && isCustomerSelected){
      for (var element in emailSuggestionModel!.customer!) {
        tempList.add(
        EmailProfileDetail(
          name:element.fullName!,
          initial:element.intial ,
          email:element.email!,
          group: 'customer'.tr.capitalize!,
        )); 
      }
      suggestionList = tempList;
    }
    update();
  }

  void addEmailInList(String actionFrom, EmailProfileDetail data){
    if(actionFrom == 'to'){
      to.add(data.email);
      initialToValues.add(data);
      
    }
    if(actionFrom == 'cc'){
      cc.add(data.email);
      initialCcValues.add(data);
    }
    if(actionFrom == 'bcc'){
      bcc.add(data.email);
      initialBccValues.add(data);
    }
    update();
  }

  void removeEmailInList( String actionFrom, EmailProfileDetail data){
    if(actionFrom == 'to'){
      to.remove(data.email);
      initialToValues.remove(data);
    }
    if(actionFrom == 'cc'){
      cc.remove(data.email);
      initialCcValues.remove(data);
    }
    if(actionFrom == 'bcc'){
      bcc.remove(data.email);
      initialBccValues.remove(data);
    }
    update();
  }

  void openAttachmentSheet() {
    FileAttachService.openQuickActions(
      jobId: jobId,
      customerId: customerId,
      maxSize: Helper.flagBasedUploadSize(fileSize: CommonConstants.maxAllowedFileSize),
      onFilesSelected: (files, {int? jobId}) {
        handleAttachments(files);
      }
    );
  }

  void handleAttachments(List<AttachmentResourceModel> files) {
    if(isAttachmentSizeOver) {
      attachmentsForUpload.addAll(files);
      getAttachmentUrl(0);
      return;
    }
    for (AttachmentResourceModel attachment in files) {
      int index = attachments.indexWhere((element) => attachment.id == element.id);
      if(index == -1) attachments.add(attachment);
    }

    if(attachments.isNotEmpty) {
      List<int?> sizes = attachments.map((e) => e.size).toList();
      var sum = sizes.reduce((a, b) => a! + b!);

      if(sum! > allowedSizeForEmailInBytes) {
        attachmentsForUpload = attachments;
        attachments = [];
        getAttachmentUrl(0);
      }
    }
    update();
  }

  void toggleCcBccVisibilty(){
    ccVisibilty = !ccVisibilty;
    if(bccVisibilty){
      bccVisibilty = false;
    }
    update();
  }

  void toggleBccVisibilty(){
    bccVisibilty = true;
    update();
  }

  void getAttachmentUrl(int index) async {
    if(index >= attachmentsForUpload.length) {
      attachmentsForUpload = [];
      return;
    }
    AttachmentResourceModel attachment = attachmentsForUpload[index];
    Map<String, dynamic> params = { 
      'file_id': attachment.id,
      'type': attachment.type
    };
    try {
      String url = await EmailListingRepository().getAttachmentUrl(params);
      insertUrl(url, attachment.name!);      
      isAttachmentSizeOver = true;
    } catch (e) {
      Helper.handleError(e);
    } finally {
      getAttachmentUrl(index + 1);
    }
  }


  void toggleThankEmailbool(bool value){
    isThanksEmailActive = value;
    update();
  }

  void insertUrl(String url, String fileName) async {
    String attachmentAnchorTag =
        '<a contentEditable="false" class="email-attachment-link email-s3-attachment-file" style="padding: 10px; margin: 0 8px; background: #f5f5f5; display: inline-block; border: 1px solid #ddd; position: relative; min-width: 240px; max-width: 240px" href="' +
        url +
        '"><img src="https://www.jobprogress.com/wp-content/uploads/2018/06/gmail-doc-icon.png" style="position: absolute; top: 50%; transform: translateY(-50%); -webkit-transform: translateY(-50%);"><span style="font-size: 18px; max-width: 96%; overflow: hidden; text-overflow: ellipsis; display: inline-block; white-space: nowrap; color: #4986e7; vertical-align: middle; padding-left: 22px; padding-top: 1px;" contentEditable="false" class="content-link-span">' +
        fileName +
        "</span></a>";

    String indicator = '<hr id="attachment-link-indication" style="border:none;" />';
    String newContent = "";

    String content = await editorController.getHtml();

    if (content.contains(indicator)) {
      List<String> c = content.split(indicator);
      newContent = "${c[0]}<p>&nbsp;</p>$attachmentAnchorTag$indicator${c[1]}";
    } else {
      newContent = content + attachmentAnchorTag;
    }

    editorController.setHtml(newContent);
  }

  void removeAttachment(int index) {
    attachments.removeAt(index);
    update();
  }


  Future<void> setDataForEmailCompose({bool isReply = false, dynamic emailTemplate}) async {
    if(emailTemplate != null) {
        if(isReply){
          if(emailAction != "forward") {
            if(emailAction == 'replyAll' || emailAction == 'reply') {
              setDataOnReplyToEmail(emailTemplate);
            } else if(emailAction != 'sent') {
              to.add(emailTemplate.from);
              initialToValues.add(
                EmailProfileDetail(
                  email: emailTemplate.from,
                  name: emailTemplate.from
                )
              );
            } else {
              if(emailTemplate.to.isNotEmpty) {
                for(int i = 0; i < emailTemplate.to!.length; i++) {
                  to.add(emailTemplate.to[i]);
                  initialToValues.add(
                    EmailProfileDetail(
                      email: emailTemplate.to[i], 
                      name: emailTemplate.to[i],
                    )
                  );
                }
              }
            }
          }
        } else {
          if(emailTemplate.to!.isNotEmpty){
            for(int i = 0; i < emailTemplate.to!.length; i++) {
              to.add(emailTemplate.to[i]);
              initialToValues.add(
                EmailProfileDetail(
                  email: emailTemplate.to[i], 
                  name: emailTemplate.to[i],
                )
              );
            }  
          } 
        
        if(emailTemplate.cc!.isNotEmpty) {
          ccVisibilty = true;
          update();
          for(int i = 0; i < emailTemplate.cc!.length; i++) {
            cc.add(emailTemplate.cc![i]);
            initialCcValues.add(
              EmailProfileDetail(
                email: emailTemplate.cc![i], 
                name: emailTemplate.cc![i],
              )
            );
          }
        }
        if(emailTemplate.bcc!.isNotEmpty) {
          ccVisibilty = true; 
          bccVisibilty = true;
          update();
          for(int i = 0; i < emailTemplate.bcc!.length; i++) {
            bcc.add(emailTemplate.bcc![i]);
            initialBccValues.add(
              EmailProfileDetail(
              email: emailTemplate.bcc![i], 
              name: emailTemplate.bcc![i],
              )
            );
          }
        }

        if (to.isEmpty && routeParamsRecepient != null && !isReply) {
          to.add(routeParamsRecepient!.email);
          initialToValues.add(
              EmailProfileDetail(
                email: routeParamsRecepient!.email,
                name: routeParamsRecepient!.name,
              )
          );
        }
      }
      attachments = emailTemplate.attachments!;
      subject = emailTemplate.subject ?? '';
      subjectController.text = emailTemplate.subject ?? '';
      String? modifiedHtml;
      await Future<void>.delayed(const Duration(milliseconds: 450));
      
      if(!isReply && Helper.isValueNullOrEmpty(emailTemplateData?.shareUrl)) {
        modifiedHtml = await removeAllPublicProposalLinks(emailTemplate.actualTemplate!);
      }
      await (isReply ? replyEditorController.setHtml(emailTemplate.htmlFromApi!) : editorController.setHtml(modifiedHtml ?? emailTemplate.actualTemplate!));

      if(isEdit){
        await Future<void>.delayed(const Duration(milliseconds: 500));
        await editorController.webViewController.evaluateJavascript(source: EmailDbElementService.sourceString);
        await Future<void>.delayed(const Duration(milliseconds: 250));
        await editorController.setEditorHeight();
        update(); 
      }
      
    } else {
      if(routeParamsRecepient != null && !isReply) {
      to.add(routeParamsRecepient!.email);
      initialToValues.add(
        EmailProfileDetail(
          email: routeParamsRecepient!.email, 
          name: routeParamsRecepient!.name,
        )
      );
    }
    if(job != null && !isReply && emailAction == 'job_detail'){
      if(job!.customer!.fullName != null && job!.customer!.fullName!.isNotEmpty){
        subject = '${job!.customer!.fullName}';
      } 
      if(job!.addressString != null && job!.addressString!.isNotEmpty){
        subject = '${job!.addressString}';
      }
      if(
        job!.customer!.fullName != null && 
        job!.customer!.fullName!.isNotEmpty &&
        job!.addressString != null && 
        job!.addressString!.isNotEmpty
      ){
        subject = '${job!.customer!.fullName} - ${job!.addressString}';
      }


      
      subjectController.text = subject;
    }
    
    if(routeParamsRecepientList != null && !isReply) {
      for(int i = 0; i < routeParamsRecepientList!.length; i++) {
        to.add(routeParamsRecepientList![i].email);
        initialToValues.add(
          EmailProfileDetail(
            email: routeParamsRecepientList![i].email, 
            name: routeParamsRecepientList![i].name,
          )
        );
      }
    }

    }
    if(routeParamsAttachments != null){
      handleAttachments(routeParamsAttachments!);
    }
    setActionFromData();
  }

  Future<String> removeAllPublicProposalLinks(String htmlContent) async {
  return await editorController.webViewController.evaluateJavascript(source: '''
    (function() {
      var container = document.createElement('div');
      container.innerHTML = `$htmlContent`;
      Array.from(container.querySelectorAll('a[filled-val="PUBLIC_PROPOSAL_LINK"]')).forEach(el => el.remove());
      return container.innerHTML;
    })();
  ''');
}

  void setDataOnReplyToEmail(EmailListingModel? emailTemplate) {
    canShowReplyForward = true;
    bool showCC = emailAction == 'replyAll';
    ccVisibilty = showCC && !Helper.isValueNullOrEmpty(emailTemplate?.cc);

    // Filling To field with email
    if (!Helper.isValueNullOrEmpty(emailTemplate?.from)) {
      emailTemplate?.to ??= <String>[];
      emailTemplate?.to?.add(emailTemplate.from ?? "");
    }

    // Excluding logged in users email from To section
    emailTemplate?.to?.remove(AuthService.userDetails?.email ?? "");

    // Filling in To emails
    for(int i = 0; i < (emailTemplate?.to?.length ?? 0); i++) {
      to.add(emailTemplate!.to![i]);
      initialToValues.add(
          EmailProfileDetail(
            email: emailTemplate.to![i],
            name: emailTemplate.to![i],
          )
      );
    }

    // CC will be displayed and filled only in case of Reply All
    if (showCC) {
      // Filling in CC emails
      for (int i = 0; i < (emailTemplate?.cc?.length ?? 0); i++) {
        cc.add(emailTemplate!.cc![i]);
        initialCcValues.add(
            EmailProfileDetail(
              email: emailTemplate.cc![i],
              name: emailTemplate.cc![i],
            )
        );
      }
    }

    update();
  }

  void addProposalButton() {
    String btnHtml =
      '''
        <p style="text-align:left; padding-top:10px; padding-bottom:10px; margin-top: 10px" contenteditable="true">
          <a ref="public-button" contenteditable="true" href="${emailTemplateData?.shareUrl}" data-prop-url="" style="text-decoration: none;color: #FFF;background-color: #26D07C;border: 1px solid #26D07C;border-radius: 4px;padding: 6px 12px;text-align: center;white-space: nowrap;">
            Click Here to View
          </a>
        </p>
      ''';

    editorController.pasteHtml(btnHtml);
  }

  void addUserSignature() async {
    dynamic sign = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.userEmailSign);
    if (sign is bool && !sign) {
      Helper.showToastMessage("no_signature_found".tr);
    } else {
      String signature1 = editorController.processHtml(html: "<p>&nbsp;</p><p>&nbsp;</p> ${sign['signature']} $emailSignIndicator");
      String signature2 = editorController.processHtml(html: "<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p> $attachLinkIndicator <div id='user-email-signatures'>${sign['signature']} </div>");

      editorController.webViewController.evaluateJavascript(source: '''
        var content = \$('#emailCompose').summernote('code');
        var userSignElem = \$("#user-email-signatures");

        if (userSignElem.length) {
          content += "$signature1";
        } else {
          content += "$signature2";
        }

        console.log(content)

        \$('#emailCompose').summernote('code', content)
      ''');

      editorController.setEditorHeight();
    } 
  }

  void clearPreFilledData(EmailTemplateListingModel emailTemplate) {
    bool doClearTo = !Helper.isValueNullOrEmpty(emailTemplate.to) || !Helper.isValueNullOrEmpty(emailTemplate.recipientSetting?.to);
    bool doClearCC = !Helper.isValueNullOrEmpty(emailTemplate.cc) || !Helper.isValueNullOrEmpty(emailTemplate.recipientSetting?.cc);
    bool doClearBCC = !Helper.isValueNullOrEmpty(emailTemplate.bcc) || !Helper.isValueNullOrEmpty(emailTemplate.recipientSetting?.bcc);

    if (doClearTo) {
      to.clear();
      initialToValues.clear();
      toVisibilty = false;
    }

    if (doClearCC) {
      cc.clear();
      initialCcValues.clear();
      ccVisibilty = false;
    }

    if (doClearBCC) {
      bcc.clear();
      initialBccValues.clear();
      bccVisibilty = false;
    }

    update();
  }

  void setEmailData(List<String>? customerType , List<String>? emailType) {
    customerType ??= [];
    emailType ??= [];
    for(String customer in customerType) {
      if(customer == RecurringConstants.customer) {
        if(!Helper.isValueNullOrEmpty(job?.customer?.email)) {
          emailType.add(job!.customer!.email!);
        }
      }
      if(customer == RecurringConstants.customerRep) {
        if(!Helper.isValueNullOrEmpty(job?.customer?.rep?.email)) {
          emailType.add(job!.customer!.rep!.email);
        }
      }
      if(customer == RecurringConstants.companyCrew) {
        for(UserLimitedModel user in (job?.reps ?? [])) {
          emailType.add(user.email);
        }
      }
      if(customer == RecurringConstants.sub) {
        for(UserLimitedModel user in (job?.subContractors ?? [])) {
          emailType.add(user.email);
        }
      }
      if(customer == RecurringConstants.estimate) {
        for(UserLimitedModel user in (job?.estimators ?? [])) {
          emailType.add(user.email);
        }
      }
    }
  }

  void addEmailsAccordingToSetting(EmailTemplateListingModel emailTemplate) {
    emailTemplate.to ??= [];
    emailTemplate.cc ??= [];
    emailTemplate.bcc ??= [];
    setEmailData(emailTemplate.recipientSetting?.to, emailTemplate.to);
    setEmailData(emailTemplate.recipientSetting?.bcc, emailTemplate.bcc);
    setEmailData(emailTemplate.recipientSetting?.cc, emailTemplate.cc);
    update();
  }
 
}