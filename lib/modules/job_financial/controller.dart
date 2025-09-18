import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/job_financial_listing.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_financial/financial_data.dart';
import 'package:jobprogress/common/models/job_financial/financial_job_price_detail.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/repositories/company_settings.dart';
import 'package:jobprogress/common/repositories/connected_third_party.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/files_listing/page.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/index.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/position.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/type.dart';
import '../../common/models/job_financial/plus_button_actions.dart';
import '../../common/services/job_financial/plus_button_quick_action.dart';
import '../../common/services/worksheet/helpers.dart';
import '../../core/constants/navigation_parms_constants.dart';
import 'widgets/job_price_dialog/index.dart';

class JobFinancialController extends GetxController {
  
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  int? jobId = Get.arguments == null ? -1 : Get.arguments['jobId'];
  int customerId = Get.arguments == null ? -1 : Get.arguments['customerId'] ?? -1; 
  
  JobModel? job;
  FinancialJobPriceRequestDetail? jobPriceRequestedUpdate;
  FinancialDataModel financialDataModel = FinancialDataModel();
  
  bool isLoading = true; 
  bool isEdit = false;
  bool isJobPriceRequestSubmitFeatureEnabled = Helper.isTrue(CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.enableJobPriceRequestSubmitFeature));
  
  String note = '';
  String controllerTag = '';

  get navigateToCreateAppointment => openJobFinancialPlusButtonAction;

  bool get disableFinancial => job?.financialDetails?.canBlockFinancial ?? true;


  Future<void> getJobSummarydata() async {
    try {
      final jobSummaryParams = <String, dynamic> {
        'id': jobId,
        'includes[0]': 'payment_receive',
        'includes[1]': 'financial_details',
        "includes[2]": "change_order",
        "includes[3]": "change_order_history",
        "includes[4]": "change_order_history.invoice",
        'track_job': 1,
      };
     
      job = (await JobRepository.fetchJob(jobId!, params: jobSummaryParams, loadJobWithCounts: true))['job'];

      if(LDService.hasFeatureEnabled(LDFlagKeyConstants.leapPayWithDivision)) {
        fetchConnectedThirdParties(job);
        fetchSettingsByDivision(job);
      }
      note = await JobFinancialRepository.fetchjobFinancialNote(id: jobId!);
    } catch (e) {
      rethrow;
    }
  }

  List<PopoverActionModel> getActionList() {
    List<PopoverActionModel> actionList = 
    [
      if(!(job?.isMultiJob ?? false) && PermissionService.hasUserPermissions([PermissionConstants.manageFinancial, PermissionConstants.updateJobPrice]))
      PopoverActionModel(label: job?.isProject ?? false ? 'update_project_price'.tr : 'update_job_price'.tr, value: 'update_job_price'),
      
      PopoverActionModel(label: job?.isProject ?? false ? 'project_price_history'.tr : 'job_price_history'.tr, value: 'job_price_history'),

      if(!(job?.financialDetails?.canBlockFinancial?? false)) PopoverActionModel(label: 'view_invoice'.tr, value: 'view_invoice'),
      
      if(!(job?.hasProfitLossWorksheet?.isBlank ?? true)
          && PermissionService.hasUserPermissions([PermissionConstants.manageProfitLossSheets, PermissionConstants.viewProfitLossSheets]))
        PopoverActionModel(label: 'P/L Summary', value: 'pl_summary'),
    ];

    return actionList;

  }

   void openEditNote() {
      if(note.isNotEmpty) {
        openAddEditNotesDialog(isEdit: true);
      } else {
        openAddEditNotesDialog();
      }
  }

  bool isNoteEnable() {
    return PermissionService.hasUserPermissions([PermissionConstants.manageFinancial]);
  }
  
  Future <void> getJobPriceRequestedData() async {
    jobPriceRequestedUpdate = null;
    if(isJobPriceRequestSubmitFeatureEnabled) {
      try {
        final jobRequestedParams = <String, dynamic> {
          'includes[]': ['requested_by'],
          'job_id': jobId,
          'limit': 1,
          'only_recent': 1,
        };
        List<FinancialJobPriceRequestDetail> data = await JobRepository.fetchJobPriceUpdateRequest(params: jobRequestedParams);
        if(data.isNotEmpty){
          jobPriceRequestedUpdate = data[0];
        } 
      } catch (e) {
        rethrow;
      }
    }    
  }

  String? get getRefundAdjustedAmount {
    num refundAdjustedPayment = job?.financialDetails?.pendingPaymentRefundAdjusted ?? 0;
    num refund = job?.financialDetails?.totalRefunds ?? 0;
    if(refundAdjustedPayment != 0 && !disableFinancial && refund > 0) {
      return JobFinancialHelper.getCurrencyFormattedValue(value: refundAdjustedPayment);
    }
    return null;
  }

  void updateJobPrice(bool isJobPriceUpdated)async {
    try{
      final jobPriceUpdatedParams = <String, dynamic>{
        'approve': isJobPriceUpdated ? 1 : 0,
      };
      isLoading = true;
      update();
      await JobFinancialRepository().jobPriceApproveRejectRequest(jobPriceUpdatedParams, jobPriceRequestedUpdate!.id!);
    } catch(e) {
      rethrow;
    } finally {
      await getAllFinancialData();
      isLoading = false;
      update();
      jobPriceRequestedUpdate = null;
    }
  }
  
  Future<void> getAllFinancialData() async {
    try{
      await Future.wait([
        getJobPriceRequestedData(),
        getJobSummarydata(),
      ]);
      getAllCalculatedData(job: job!,jobPriceRequestedUpdate: jobPriceRequestedUpdate);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  void fetchConnectedThirdParties(JobModel? job) {
    try {
      final connectedThirdPartyParam = <String, dynamic>{
        'name[0]': 'quickbook',
        'name[1]': 'quickbook_pay',
        'name[2]': 'quickbook_desktop',
        'name[3]': 'quickmeasure',
        'name[4]': 'eagleview',
        'name[5]': 'companycam',
        'name[6]': 'hover',
        'name[7]': 'srs',
        'name[8]': 'leappay',
        'name[9]': 'beacon',
        'name[10]': 'abc',
        'includes[0]': 'company_rate'
      };

      if(!Helper.isValueNullOrEmpty(job?.division?.id)) {
        connectedThirdPartyParam['division_id'] = job?.division?.id;
      }

      ConnectedThirdPartyRepository.fetchConnectedThirdParty(connectedThirdPartyParam);
    } catch (e) {
      rethrow;
    }
  }

  void fetchSettingsByDivision(JobModel? job) {
    try {
      final querParams = <String, dynamic>{};

      if(!Helper.isValueNullOrEmpty(job?.division?.id)) {
        querParams['division_id'] = job?.division?.id;
      }

      CompanySettingRepository.fetchCompanySettingsByDivision(querParams);
    } catch (e) {
      rethrow;
    }
  }
  
   Future<void> refreshScreen() async {
    isLoading = true;
    update();
    await getAllFinancialData();
  }

  Future<void> addJobFinancialNotes({bool isEdit = false, required VoidCallback toggleIsLoading}) async {
    try {
      final addJobFinancialNoteParams = <String, dynamic>{
        'job_id': jobId,
        'note': note,
      };
      await JobFinancialRepository().addJobFinancialNote(jobId!, addJobFinancialNoteParams);
      note = await JobFinancialRepository.fetchjobFinancialNote(id:jobId!);
      Get.back();
      if(isEdit) {
        Helper.showToastMessage('note_updated'.tr);
      } else {
        Helper.showToastMessage('note_added'.tr);
      }
    } catch (e) {
      rethrow;
    } finally {
      toggleIsLoading();
    }
  }

  void openAddEditNotesDialog({bool isEdit = false}) {
    showJPGeneralDialog(
      child: (controller){
        return AbsorbPointer(
          absorbing: controller.isLoading,
          child: JPQuickEditDialog(
            title: isEdit ? 'update_note'.tr.toUpperCase() : 'add_note'.tr.toUpperCase(),
            label: 'note'.tr,
            fillValue: isEdit ? note : null,
            disableButton: controller.isLoading,
            maxLength: 230,
            suffixIcon: showJPConfirmationLoader(show: controller.isLoading),
            position: JPQuickEditDialogPosition.center,
            type: JPQuickEditDialogType.textArea,
            suffixTitle: controller.isLoading ? '' : isEdit ? 'update'.tr : 'save'.tr,
            prefixTitle: 'CANCEL'.tr,
            onPrefixTap: (value) {
              Get.back();
            },
            onSuffixTap: (value) async {  
              controller.toggleIsLoading();
              note = value.trim();
              await addJobFinancialNotes(isEdit: isEdit, toggleIsLoading: controller.toggleIsLoading);
              update();
            }
          ),
        );
      }     
    );
  }

  bool isRequestSubmittedByLoggedInUser() {
    return (jobPriceRequestedUpdate != null &&
        jobPriceRequestedUpdate!.requestedBy!.id == AuthService.userDetails!.id &&
        !PermissionService.hasUserPermissions([PermissionConstants.approveJobPriceRequest]) &&
        isJobPriceRequestSubmitFeatureEnabled);
  }

  FinancialDataModel getAllCalculatedData({required JobModel job, FinancialJobPriceRequestDetail? jobPriceRequestedUpdate}) {
  
    financialDataModel.paymentReceivedAmount =
      job.financialDetails != null ? 
      job.financialDetails!.totalReceivedPayemnt! :
      job.paymentReceivedTotalAmount!;

    financialDataModel.paymentReceivedProgressbarValue = 
      job.financialDetails!.appliedPayment! / financialDataModel.paymentReceivedAmount;
    
    financialDataModel.creditProgressbarValue = 
      job.financialDetails!.appliedCredits! / job.financialDetails!.totalCredits! ;
    
    if(job.amount != null && job.taxRate != null && job.taxRate!.isNotEmpty) {
      financialDataModel.estimateTax = 
        getTaxAmount(amount: double.parse(job.amount!), taxRate: double.parse(job.taxRate!));
    } else {
      financialDataModel.estimateTax = 0.0;
    }
    
    financialDataModel.jobPrice = 
    job.isMultiJob ? financialDataModel.totalPrice : double.parse(job.amount!);
    
    if(job.amount != null && job.taxRate != null && job.taxRate!.isNotEmpty) {
      financialDataModel.totalPrice = 
        getTotalAmount(
          amount : double.parse(job.amount!), taxRate : double.parse(job.taxRate!)
        );
    } else {
      financialDataModel.totalPrice = double.parse(job.amount!);
    } 
      
    if (job.financialDetails!.pendingPayment == null) {
      financialDataModel.amountOwned = 
        financialDataModel.totalPrice+ job.financialDetails!.totalChangeOrderAmount! -
        job.financialDetails!.totalReceivedPayemnt! +job.financialDetails!.totalCredits! + 
        job.financialDetails!.totalRefunds!;
    } else {
      financialDataModel.amountOwned = job.financialDetails!.pendingPayment!;
    }
    
    if(jobPriceRequestedUpdate != null && jobPriceRequestedUpdate.taxRate != null){
      
      financialDataModel.updatRequestedestimateTax = 
        getTaxAmount(
          amount: double.parse(jobPriceRequestedUpdate.amount!),
          taxRate: jobPriceRequestedUpdate.taxRate!.toDouble()
        );
   
      financialDataModel.updateRequestedJobPrice = 
        getTotalAmount(
          amount: double.parse(jobPriceRequestedUpdate.amount!) , 
          taxRate: jobPriceRequestedUpdate.taxRate!.toDouble()
        );
    }   
    return financialDataModel;
  }

  String getCircularProgressBarPercentageValue(double value){
    value = value *100;
    int intValue = value.toInt();
    String stringValue = '$intValue%';
    return stringValue;
  }
  
  double getTaxAmount({required double amount , required double taxRate}){
    return (amount  * taxRate) / 100;
  }

  double getTotalAmount({required double amount, required double taxRate}){
    return ((amount * taxRate) / 100) + amount;
  }

  void handleChangeJob(int id) async {
    isLoading = true;
    jobId = id;
    update();
    await getAllFinancialData();
  }

  /////////////////////////    POP UP MENU HANDLING    /////////////////////////

  void onPopUpMenuItemTap(PopoverActionModel selected) async{
    switch (selected.value) {
      case "update_job_price":
        fetchJobDetailForPriceUpdation();
        break;
      case "job_price_history":
        navigateToJobHistoryPage();
        break;
      case "view_invoice":
        await Get.toNamed(Routes.jobfinancialListingModule, arguments: {'listing': JFListingType.jobInvoicesWithoutThumb, 'jobId':jobId, 'job':job, 'customer_id':customerId});
        refreshScreen();
        break;
      case "pl_summary":
        navigateToPlSummary();
        break;
    }
  }

  Future<void> navigateToInvoiceScreenWithThumb() async {
    await Get.to(() => FilesListingView(
      refTag: "${FLModule.financialInvoice}${(job?.id)}",
    ), arguments: {
        NavigationParams.type: FLModule.financialInvoice, 
        'jobId' : jobId,
        'customerId' : customerId
      },
      preventDuplicates: false
    );
    refreshScreen();
  }

  void navigateToJobHistoryPage() async {
    await  Get.toNamed(Routes.jobfinancialListingModule, arguments: {'listing': JFListingType.jobPriceHistory, 'jobId':jobId, 'job':job, 'customer_id':customerId});
    refreshScreen();
  }

  void fetchJobDetailForPriceUpdation() {

    showJPLoader();

    final jobSummaryParams = <String, dynamic> {
      "id": jobId,
      "includes[0]":"address.state_tax",
      "includes[1]":"parent.address.state_tax",
      "includes[2]":"custom_tax",
      "includes[3]":"financial_details",
      "includes[4]":"job_invoices",
      "includes[5]":"flags.color",
    };
    JobRepository.fetchJob(jobId!, params: jobSummaryParams).then((value) {
      Get.back();
      updateJobPriceDialog(value["job"]);
    }).catchError((_) {Get.back();});
  }

  void updateJobPriceDialog(JobModel jobModel) {
    showJPGeneralDialog(
      isDismissible: false,
      child: (dialogController) {
        return AbsorbPointer(
          absorbing: dialogController.isLoading,
          child: JobPriceDialog(
            onApply: () {
              Get.back();
              refreshScreen();
            },
            jobModel: jobModel,
          ),
        );
      }
    );
  }

  /////////////////////////    OPEN JOB FINANCIAL QUICK ACTIONS   /////////////////////////

  void openJobFinancialPlusButtonAction() {
   JobFinancialPlusButtonService.openQuickActions(
      PlusButtonActions(
        job: job,
        customerId: customerId, 
        jobId: jobId!, 
        onActionComplete: () { 
        refreshScreen();
      }),
    );
  }

  @override
  void onInit() async {
    super.onInit();
    await getAllFinancialData(); 
  }

  Future<void> navigateToPlSummary() async {
    WorksheetModel? worksheetModel = await WorksheetHelpers.fetchWorksheet(job?.hasProfitLossWorksheet);
    WorksheetHelpers.checkIsNotBeaconOrBeaconAccountExist(
        worksheetModel?.beaconAccountId, (isNotBeaconOrBeaconAccountExist) async {
      if (isNotBeaconOrBeaconAccountExist) {
        Get.toNamed(Routes.jobProfitLossSummary, arguments: {
          NavigationParams.worksheetId: job?.hasProfitLossWorksheet,
          NavigationParams.jobModel: job,
        });
      }
    });
  }
  
}
