import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/invoice_form_type.dart';
import 'package:jobprogress/common/enums/job_financial_listing.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/common/services/job_financial/quick_action.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/modules/job_financial/listing/listing_tile/commission.dart';
import 'package:jobprogress/modules/job_financial/listing/listing_tile/commission_payment.dart';
import 'package:jobprogress/core/constants/financial_quick_actions.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/modules/job_financial/listing/listing_tile/job_price_history.dart';
import 'package:jobprogress/modules/job_financial/listing/listing_tile/accounts_payable.dart';
import 'package:jobprogress/modules/job_financial/listing/listing_tile/credits.dart';
import 'package:jobprogress/modules/job_financial/listing/listing_tile/refunds.dart';
import 'package:jobprogress/modules/job_financial/listing/shimmer/shimmer.dart';
import 'package:jobprogress/modules/job_financial/listing/shimmer/credits_shimmer.dart';
import 'package:jobprogress/modules/job_financial/listing/shimmer/job_invoices_shimmer.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/routes/pages.dart';
import '../../../common/enums/beacon_access_denied_type.dart';
import '../../../common/enums/unsaved_resource_type.dart';
import '../../../core/utils/form/db_helper.dart';
import '../../../core/utils/job_price_update_helper.dart';
import 'listing_tile/change_order.dart';
import 'listing_tile/invoices.dart';
import 'listing_tile/payments_received.dart';

class JobFinancialListingModuleController extends GetxController {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = true;
  bool isAddingCancelNote = false;
  bool showApplyPaymentButton = false;
  double totalAmount = 0;
  String paymentReceivedType ='';
  double taxIncludeAmount = 0;

  int? jobId = Get.arguments == null ? null : Get.arguments['jobId'];
  int? customerId = Get.arguments == null ? null : Get.arguments['customer_id'];
  int? commissionId = Get.arguments == null ? null : Get.arguments['commission_id'];
  String? commissionUser = Get.arguments == null ? null : Get.arguments['commission_user'];

  JobModel? job ;

  JFListingType listingType = Get.arguments == null ? JFListingType.paymentsReceived  : Get.arguments['listing'] ?? JFListingType.paymentsReceived;
  String cancelNote ='';
  List<FinancialListingModel> financialList = [];

  bool get canManagePriceHistory => listingType == JFListingType.jobPriceHistory
      && PermissionService.hasUserPermissions([PermissionConstants.manageFinancial, PermissionConstants.updateJobPrice])
      && !isLoading
      && job != null
      && !(job?.isMultiJob ?? false);

  @override
  void onInit() {
    getAllData();
    super.onInit();
  }

  String getTitle() {
    switch(listingType) {
      case JFListingType.jobPriceHistory:
        return job?.isProject ?? false ? '${'project_price'.tr} ${'history'.tr}' : '${'job_price'.tr} ${'history'.tr}';
      case JFListingType.changeOrders:
        return 'change_orders'.tr;
      case JFListingType.paymentsReceived:
        return 'payments'.tr;
      case JFListingType.credits:
        return 'credits'.tr;
      case JFListingType.refunds:
        return 'refunds'.tr;
      case JFListingType.accountspayable:
        return 'accounts_payable'.tr;
      case JFListingType.jobInvoicesWithoutThumb:
        return 'job_invoices'.tr;
      case JFListingType.commission:
        return 'commissions'.tr;
      case JFListingType.commissionPayment:
        return '${'commission'.tr} ${'history'.tr}';
      default:
        return '';

    }
  }

  String getNoDataMessage(){
    switch(listingType) {
      case JFListingType.jobPriceHistory:
        return '${'history'.tr.capitalize!} ${'found'.tr.capitalize!}';
      case JFListingType.changeOrders:
        return '${'change_order'.tr.capitalize!} ${'found'.tr.capitalize!}';
      case JFListingType.paymentsReceived:
        return '${'payments'.tr.capitalize!} ${'found'.tr.capitalize!}';
      case JFListingType.credits:
        return '${'credit'.tr.capitalize!} ${'found'.tr.capitalize!}';
      case JFListingType.refunds:
        return '${'refund'.tr.capitalize!} ${'found'.tr.capitalize!}';
      case JFListingType.accountspayable:
        return '${'account_payable'.tr.capitalize!} ${'found'.tr.capitalize!}';
      case JFListingType.jobInvoicesWithoutThumb:
        return '${'job_invoice'.tr.capitalize!} ${'found'.tr.capitalize!}';
      case JFListingType.commission:
        return '${'commisson'.tr.capitalize!} ${'found'.tr.capitalize!}';
      case JFListingType.commissionPayment:
        return '${'commission'.tr.capitalize!} ${'history'.tr.capitalize!} ${'found'.tr.capitalize!}';
      default:
        return '';
    }
  }

  Future<void> refreshList() async {
    isLoading = true;
    update();
    await getAllData();
    isLoading = false;
    update();
  }

  Future<void> showQuickAction({required int index}) async {

    if(financialList[index].canceled != null || (job?.isMultiJob ?? false)) {
      return ;
    }

    FinancialListingModel model = financialList[index];

    JobFinancialService.openQuickActions(
      customerId: customerId!,
      job: job!,
      model: model,
      type: listingType,
      onActionComplete: (dynamic model, action){
        switch(action){
          case FinancialQuickAction.edit:
          case FinancialQuickAction.attachments:
            navigateToEditScreen(model);
            break;
          case FinancialQuickAction.cancel:
            int index = financialList.indexWhere((element) => element.id == model.id && element.unsavedResourceId == null);
            if(index != -1) {
              financialList[index].canceled = ' ';
              financialList[index].cancelNote = model.cancelNote;
              totalAmount = getSumOfAmount(financialList: financialList);
            }
            update();
            break;
          case FinancialQuickAction.deleteInvoice:
            financialList.removeWhere((element) => element.id == model.id && element.unsavedResourceId == null);
            update();
            break;
          case FinancialQuickAction.linkProposal:
            int index = financialList.indexWhere((element) => element.id == model.id && element.unsavedResourceId == null);
            if(index != -1) {
              for(int i=0; i <= financialList.length-1; i++) {
                financialList[i].proposalUrl = model.proposalUrl;
                financialList[i].proposalId = model.proposalId;
              }
            }
            break;
          case FinancialQuickAction.unlinkProposal:
            int index = financialList.indexWhere((element) => element.id == model.id && element.unsavedResourceId == null);
            if(index != -1) {
              for(int i=0; i <= financialList.length-1; i++) {
                financialList[i].proposalId = null;
              }
            }
            update();
            break;

          case FinancialQuickAction.delete:
            financialList.removeWhere((element) => element.id == model.id && element.unsavedResourceId == null);
            totalAmount = getSumOfAmount(financialList: financialList);
            update();
            break;

          case FinancialQuickAction.payCommission:
          case FinancialQuickAction.recordPayment:
          case FinancialQuickAction.accountPayable:
          case FinancialQuickAction.unsavedResourceEdit:
          case FinancialQuickAction.unsavedResourceDelete:
            refreshList();
            break;

          default:
            break;
        }
      },
    );
  }

  Widget getListTile({required int index,required JobFinancialListingModuleController controller}){
    switch(listingType){
      case JFListingType.changeOrders:
        return JobFinancialChangeOrderListingTile(index: index, controller: this);
      case JFListingType.paymentsReceived:
        return JobFinancialPaymentsReceivedListingTile(index: index, controller: this);
      case JFListingType.jobInvoicesWithoutThumb:
        return JobFinancialInvoicesListingTile(index: index, controller: this);
      case JFListingType.jobPriceHistory:
        return JobFinancialJobPriceHistoryListingTile(index: index, controller: this);
      case JFListingType.accountspayable:
        return JobFinancialAccountsPayableTile(index: index, controller: controller);
      case JFListingType.credits:
        return JobFinancialCreditsListingTile(index:index, controller: this,);
      case JFListingType.refunds:
        return JobFinancialRefundsListingTile(index: index, controller:this);
      case JFListingType.commission:
        return JobFinancialCommissionListingTile(index:index, controller:this);
      case JFListingType.commissionPayment:
        return JobFinancialCommissionPaymentListingTile(index:index, controller:this);

      default:
        return const SizedBox.shrink();
    }
  }

  Widget getShimmer() {
    switch(listingType) {
      case JFListingType.jobPriceHistory:
        return const JobFinancialListingCommonShimmer(showInclusiveTax: true);
      case JFListingType.changeOrders:
        return const JobFinancialListingCommonShimmer(showInclusiveTax: true);
      case JFListingType.accountspayable:
        return const JobFinancialListingCommonShimmer(showIcon: true);
      case JFListingType.credits:
        return const JobFinancialListingCreditsShimmer();
      case JFListingType.jobInvoicesWithoutThumb:
        return const JobFinancialListingJobInvoicesShimmer();

      default:
        return const JobFinancialListingCommonShimmer();
    }
  }



 bool isShowList(JFListingType listingType) {
  switch(listingType) {
    case JFListingType.commission:
    case JFListingType.commissionPayment:
    case JFListingType.jobInvoicesWithoutThumb:
    case JFListingType.jobPriceHistory:
      return false;
    default:
      return true;
  }
}

  bool showFloatingActionButton() {
    bool hideFloatingActionButton = job == null
        || isLoading
        || (job?.isMultiJob ?? false);

    if (hideFloatingActionButton) {
      return false;
    }

    bool hasManageFinancialPermission = PermissionService.hasUserPermissions([PermissionConstants.manageFinancial]);
    if(hasManageFinancialPermission) {
      if(PhasesVisibility.canShowSecondPhase && job?.financialDetails?.canBlockFinancial == false) {
        return isShowList(listingType);
      }
      if(listingType == JFListingType.accountspayable) {
        return true;
      }
    }

    return false;
  }

  Future<void>getListFromApi(){
    switch(listingType){
      case JFListingType.changeOrders:
        return getChangeOrderListfromApi();
      case JFListingType.paymentsReceived:
        return getPaymentReceivedListFromApi();
      case JFListingType.jobInvoicesWithoutThumb:
        return getJobInvoicesListfromApi();
      case JFListingType.credits:
        return getCreditsListfromApi();
      case JFListingType.refunds:
        return getRefundsListfromApi();
      case JFListingType.jobPriceHistory:
        return getJobHistoryListfromApi();
      case JFListingType.accountspayable:
        return getAccountsPayableListfromApi();
      case JFListingType.commission:
        return getCommisionListfromApi();
      case JFListingType.commissionPayment:
        return getCommissionPaymentList();

      default:
        return getChangeOrderListfromApi();
    }
  }

  Future<void> handleFloatingActionButtonClick() async {
    switch(listingType){
      case JFListingType.paymentsReceived:
        return navigateToPaymentReceiveScreen();
      case JFListingType.credits:
        return  navigateToCreditForm();
      case JFListingType.refunds:
        return  navigateToRefundScreen();
      case JFListingType.changeOrders:
      case JFListingType.jobInvoicesWithoutThumb:
        return  checkBeaconAccountExistOrNavigateToInvoiceForm();
      case JFListingType.accountspayable:
        return  navigateToBillScreen();

      default:
        return;
    }
  }

  Future<void> navigateToPaymentReceiveScreen() async {
    final result = await Get.toNamed(Routes.receivePaymentForm,  arguments: {NavigationParams.jobId: jobId});
    if(result != null && result) {
      refreshList();
    }
  }

  Future<void> getChangeOrderListfromApi() async {
    final  Map<String, dynamic> params = {
      'includes[0]': ['job'],
      'includes[1]': ['invoice'],
      'includes[2]': ['custom_tax'],
      'includes[3]': ['division'],
      'includes[4]': ['division.address'],
      'job_id': jobId,
    };
    try {
      financialList = await JobFinancialRepository.fetchChangeOrderList(params);
      var unsavedResources = (await FormsDBHelper.getMultipleTypesOfUnsavedResources<FinancialListingModel>(types: [UnsavedResourceType.changeOrder], jobId: jobId!));
      financialList.insertAll(0, unsavedResources);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> navigateToCreditForm() async {
    final result = await Get.toNamed(Routes.applyCreditForm, arguments: {NavigationParams.jobId : jobId});
    if(result != null && result) {
      refreshList();
    }
  }

  Future<void> getJobSummarydata() async {
    try {
      final jobSummaryParams = <String, dynamic> {
        'id': jobId,
        'includes[0]': ['financial_details'],
        "includes[1]":"job_invoices",
        'track_job': 1,
      };
      job = (await JobRepository.fetchJob(jobId!, params: jobSummaryParams))['job'];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getPaymentReceivedListFromApi() async {
    final  Map<String, dynamic> params = {
      'includes[0]': ['transfer_to_payment'],
      'includes[1]': ['transfer_from_payment'],
      'includes[2]': ['transfer_to_payment.ref_job'],
      'includes[3]': ['transfer_from_payment.ref_job'],
    };
    try {
      financialList = await JobFinancialRepository.fetchpaymentsReceivedList(jobId!,params);

      List<FinancialListingModel> tempFinancialList = await JobFinancialRepository.fetchpaymentsReceivedList(jobId!, params);
      financialList = tempFinancialList.toList();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getCreditsListfromApi() async {
    final  Map<String, dynamic> params = {
      'customer_id': customerId,
      'job_id': jobId,
      'includes[0]': ['job'],
      'includes[1]': ['invoice'],
      'limit': 0
    };
    try {
      financialList = await JobFinancialRepository.fetchCreditList(params);

      List<FinancialListingModel> tempFinancialList = await JobFinancialRepository.fetchCreditList(params);
      financialList = tempFinancialList.reversed.toList();

    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getJobInvoicesListfromApi() async {
    final  Map<String, dynamic> params = {
      "includes[1]": "job_invoices",
      "includes[2]": "job_invoices.proposal",
      "id": jobId,
      "track_job": 1,
    };
    try {
      List<FinancialListingModel> tempfinancialList = await JobFinancialRepository.fetchJobInvoiceList(jobId!, params);
      financialList = tempfinancialList.reversed.toList();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getJobHistoryListfromApi() async {
    final  Map<String, dynamic> params = {
      'includes[0]': ['created_by'],
    };
    try {
      financialList = await JobFinancialRepository.fetchJobPriceHistoryList(jobId!, params);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getAccountsPayableListfromApi() async {
    final  Map<String, dynamic> params = {
      'includes[0]': ['vendor'],
      'includes[1]': ['attachments'],
      'includes[2]': ['lines'],
      'includes[3]': ['lines.financial_account'],
      'job_id': jobId,
      'limit': 500,
    };
    try {
      financialList = await JobFinancialRepository.fetchAccountsPayableList(params);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getCommisionListfromApi() async {
    final  Map<String, dynamic> params = {
      'includes[0]': ['job'],
      'job_id': jobId,
      'limit': 0,
    };
    try {
      List<FinancialListingModel> tempfinancialList = await JobFinancialRepository.fetchCommisionsList(params,);
      financialList = tempfinancialList.reversed.toList();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getCommissionPaymentList() async {
    final  Map<String, dynamic> params = {
      'includes[0]': ['commission'],
      'limit': 0,
    };
    try {
      List<FinancialListingModel> tempfinancialList = await JobFinancialRepository.fetchCommisionPaymentList(params,commissionId!);
      financialList = tempfinancialList.reversed.toList();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getRefundsListfromApi() async {
    final  Map<String, dynamic> params = {
      'job_id': jobId,
      'includes[0]': ['lines'],
      'includes[1]': ['financial_account'],
      'limit': 200
    };
    try {
      financialList = await JobFinancialRepository.fetchRefundsList(params);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  double getTaxableAmount(FinancialListingModel financialListingmodel){
    double amount = double.parse(financialListingmodel.taxableAmount ?? "0");
    double taxRate = double.parse(financialListingmodel.taxRate!);
    return (taxRate * amount) / 100 ;
  }

  double getPendingAmount(JobModel job){
    double totalAmount = job.financialDetails!.jobInvoiceAmount!.toDouble();
    double jobAmount =  double.parse(job.amount!);
    return jobAmount - totalAmount;
  }

  Future<void> getAllData() async {
    await Future.wait([
      getJobSummarydata(),
      getListFromApi(),
    ]);
    totalAmount = getSumOfAmount(financialList: financialList);
    showApplyPaymentButton = isShowApplyButton();
    isLoading = false;
    update();
  }

  bool isShowApplyButton(){
    if(listingType == JFListingType.paymentsReceived &&
        job != null &&
        job!.customer!.unappliedAmount! > 0 &&
        job!.jobInvoices != null &&
        job!.jobInvoices!.isNotEmpty &&
        job!.jobInvoices!.any((element) => double.parse(element.openBalance!) > 0)
    ) {
      return true;
    }
    return false;
  }

  void navigateToApplyForm() async {
    dynamic success =  await Get.toNamed(Routes.applyPaymentForm, arguments: {NavigationParams.jobId:jobId});
    if(success != null && success){
      refreshList();
    }
  }

  double getSumOfAmount({required List<FinancialListingModel> financialList}){
    double total = 0;
    double amount = 0;
    for(int i =0; i <= financialList.length-1; i++) {
      if(financialList[i].canceled == null && financialList[i].unsavedResourceId == null){
        if (financialList[i].taxRate != null) {
          amount = JobFinancialHelper.getTaxableTotalAmount(financialList[i]);
        } else {
          amount = double.parse(financialList[i].totalAmount!);
        }
        total = total + amount;
      }
    }
    return total;
  }

  void handleChangeJob(int id) async {
    jobId = id;
    job = null;
    isLoading = true;
    update();
    await getAllData();
  }

  String getPaymentReceivedTypeNote({required FinancialListingModel paymentsReceived}) {
    if(paymentsReceived.method == 'echeque') {
      return 'check_number'.tr;
    } else {
      return 'reference_number'.tr;
    }
  }
  double getSumOfAmountForAccountPayable({required List<FinancialListingModel> financialList}){
    double total = 0;
    double amount = 0;
    for(int i = 0; i <= financialList.length-1; i++) {
      if(financialList[i].canceled == null){
        amount = financialList[i].amount!.toDouble();
        total = total + amount;
      }
    }
    return total;
  }

  ///////////////////////    UPDATE JOB PRICE   ///////////////////////////

  void onTapTotalJobPrice() => JobPriceUpdateHelper.openJobPriceDialog(
    jobId: jobId!,
    onApply: () {
      Get.back();
      refreshList();
    },
  );

  ///////////////////////////     NAVIGATION'S     /////////////////////////////

  void navigateToEditScreen(dynamic model) {
    switch(listingType){
      case JFListingType.changeOrders:
      case JFListingType.jobInvoicesWithoutThumb:
        checkBeaconAccountExistOrNavigateToInvoiceForm(beaconAccountId: model.beaconAccountId, orderId: model.id, unsavedResourceId: model.unsavedResourceId, isEdit: true);
        break;
      default:
        break;
    }
  }

  void checkBeaconAccountExistOrNavigateToInvoiceForm({int? beaconAccountId, int? orderId, int? unsavedResourceId, bool isEdit = false}) {
    if (isEdit) {
      WorksheetHelpers.checkIsNotBeaconOrBeaconAccountExist(beaconAccountId.toString(), (isNotBeaconOrBeaconAccountExist) async {
            if(isNotBeaconOrBeaconAccountExist) {
              navigateToInvoiceForm(orderId: orderId, unsavedResourceId: unsavedResourceId, isEdit: isEdit);
            }
      }, type: listingType == JFListingType.changeOrders ?
      BeaconAccessDeniedType.changeOrder : BeaconAccessDeniedType.invoice);
    } else {
      navigateToInvoiceForm(orderId: orderId, unsavedResourceId: unsavedResourceId, isEdit: isEdit);
    }
  }

  Future<void> navigateToInvoiceForm({int? orderId, int? unsavedResourceId, bool isEdit = false}) async {
    final result = await Get.toNamed(Routes.invoiceForm, arguments: {
      NavigationParams.jobId : jobId,
      NavigationParams.id : orderId,
      NavigationParams.dbUnsavedResourceId : unsavedResourceId,
      NavigationParams.pageType : listingType == JFListingType.changeOrders
          ? isEdit ? InvoiceFormType.changeOrderEditForm : InvoiceFormType.changeOrderCreateForm
          : isEdit ? InvoiceFormType.invoiceEditForm : null});
    if(result != null) {
      refreshList();
    }
  }

  Future<void> navigateToRefundScreen() async {
    final result = await Get.toNamed(Routes.refundForm,  arguments: {
      NavigationParams.jobId: jobId,
      NavigationParams.customerId: customerId
    });
    if(result != null && result) {
      refreshList();
    }
  }

  Future<void> navigateToBillScreen() async {
    final result = await Get.toNamed(Routes.billForm,  arguments: {
      NavigationParams.jobId: jobId,
      NavigationParams.customerId: customerId
    });
    if(result != null && result) {
      refreshList();
    }
  }
}
