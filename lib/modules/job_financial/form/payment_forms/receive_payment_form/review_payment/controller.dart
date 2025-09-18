import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/payment_status.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/models/justifi/sync_status.dart';
import 'package:jobprogress/common/repositories/leap_pay.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/payment/payment_form.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class ReviewPaymentDetailsController extends GetxController {

  bool isLoading = false; // helps in managing loading state

  bool isFeePassOverEnabledForInvoice = false; // helps to checked if fee passover enabled or not

  /// [syncStatusTotalInterval] is the max time in seconds
  /// for which the user can wait for payment status
  int syncStatusTotalInterval = 45;

  /// [syncStatusAfter] is the time in seconds after which
  /// payment status will be re-fetched
  int syncStatusAfter = 5;

  Timer? processPaymentTimer; // used to sync payment status
  FinancialListingModel? paymentDetails; // stores the processed payment details
  CancelToken? cancelToken; // used to cancel requests
  PaymentStatus? paymentStatus; // used to track payment status
  String? paymentStatusDesc; // used to display payment status description

  Map<String, String> paymentToProcessDetails = {}; // stores the payment details to be processed

  PaymentFormService? service = Get.arguments?[NavigationParams.paymentFormData];

  /// [isSyncingStatus] returns [True] if payment status is syncing and [False] otherwise
  bool get isSyncingStatus => processPaymentTimer?.isActive ?? false;

  /// Returns true if both conditions are met; otherwise, returns false.  
  bool get isFeePassOverEnabledAndNotRecordPayment => isFeePassOverEnabledForInvoice && !(service?.isRecordPaymentForm ?? false);

  @override
  void onInit() {
    // setting up payment details for confirmation
    setUpPaymentDetails();
    super.onInit();
  }

  /// [setUpPaymentDetails] Sets up the payment details for confirmation.
  void setUpPaymentDetails() {
    // Constructs the payment details map.
    paymentToProcessDetails = {
      // If there is only one selected invoice, use 'invoice' as the key, otherwise use 'invoices'.
      service?.filterInvoiceList.length == 1 ? 'invoice' : 'invoices': getLinkedInvoice(),
      ...getPaymentDetails(),
    };
  }

  String getLinkedInvoice() {
    // Retrieves the selected invoices based on the filter.
    List<FilesListingModel> selectedInvoice = service?.apiInvoiceList?.where((invoice) {
      return service?.filterInvoiceList.any((selectedInvoice) => selectedInvoice.id == invoice.id) ?? false;
    }).toList() ?? [];

    if(selectedInvoice.isNotEmpty) {
      isFeePassOverEnabledForInvoice = selectedInvoice[0].isFeePassoverEnabled ?? false;
    } else {
      isFeePassOverEnabledForInvoice = Helper.isTrue(service?.feePassover ?? false);
    }

    // Joins the titles of the selected invoices into a comma-separated string.
    String invoices = selectedInvoice.map((e) => '${e.title}').join(', ');

    return invoices.isEmpty ? '-' : invoices;
  }

  /// [getPaymentDetails] Retrieves the payment details based on the selected payment method.
  ///
  /// Returns a [Map<String, dynamic>] containing the payment details.
  Map<String, dynamic> getPaymentDetails() {
    if (service == null) return {};
      // Get the bank account details and card details
      final bankAccountDetails = service!.tokenizationDetails?.bankAccountDetails;
      final cardDetails = service!.tokenizationDetails?.cardDetails;
  
      // Prepare the bank account data
      final bankAccountData = {
        'account_type': service!.isSavingAccount ? 'savings'.tr : 'checking'.tr,
        'account_number': '************${bankAccountDetails?.acctLastFour}',
        'account_owner': service!.accountOwnerController.text,
        'email_receipt_to': service!.emailReceiptController.text,
      };
  
      // Prepare the card data
      final cardData = {
        if (service?.nameController.text.isNotEmpty ?? false) 'name_on_card'.tr : service!.nameController.text,
        'card_number': '************${cardDetails?.acctLastFour}',
        'email_receipt_to': service!.emailReceiptController.text,
      };
  
      // Get the reference number from the service
      final refNumber = service!.checkRefernceNumberController.text;
  
      // Prepare the record payment data
      final recordPaymentData = {
        'payment_type': service!.paymentMethodController.text,
        'date': service!.dateController.text,
        'reference#': refNumber.isEmpty ? '-' : refNumber,
      };
  
      // Check if the record payment form is active
      if (service!.isRecordPaymentForm) {
        // Return the record payment data.
        return recordPaymentData;
      } else {
        // Check if the card form is active
        if (service!.isCardForm) {
          // Return the card data.
          return cardData;
        } else {
          // Return the bank account data
          return bankAccountData;
        }
      }
  }

  /// [startPaymentProcessing] Starts the payment processing.
  void startPaymentProcessing() {
    if (paymentDetails?.id == null) return;
    paymentStatus = PaymentStatus.inProgress;
    // Calculate the maximum number of ticks based on the sync status interval
    final maxTicks = syncStatusTotalInterval ~/ syncStatusAfter;

    // Set up a periodic timer to process the payment
    processPaymentTimer = Timer.periodic(Duration(seconds: syncStatusAfter), (timer) {
      // Get the sync status
      getSyncStatus();

      // If the timer has reached the maximum number of ticks, stop processing the payment
      if (timer.tick == maxTicks) {
        paymentStatus = PaymentStatus.pending;
        paymentStatusDesc = paymentStatusToMessage(paymentStatus ?? PaymentStatus.pending);
        stopProcessingPayment(doPop: false);
      }
    });
    update();
  }

  /// [onTapPay] handles the tap event for the pay button
  void onTapPay() {
    proceedPayment();
  }

  /// [stopProcessingPayment] Stops the processing of payment
  ///
  /// [doPop] - Whether to pop the current screen from the navigation stack. Defaults to true.
  void stopProcessingPayment({bool doPop = true}) {
    // Pop the current screen from the navigation stack twice if [doPop] is true
    if (doPop) {
      Get.back();
      Get.back(result: true);
    }
    // Cancel any ongoing HTTP requests
    cancelToken?.cancel();
    // Cancel the process payment timer
    processPaymentTimer?.cancel();
    update();
  }

  /// [getSyncStatus] Retrieves the sync status of the payment.
  ///
  /// If the payment details are not available, the function returns without doing anything.
  /// Otherwise, it makes an API call to fetch the sync status of the payment and updates the status
  /// using the [onStatusSynced] callback.
  Future<void> getSyncStatus() async {
    if (paymentDetails?.id == null) return;
  
    try {
      // Create a cancel token to cancel the API request if needed
      cancelToken = CancelToken();
      // Fetch the sync status of the payment
      final syncStatus = await LeapPayRepository
          .syncPaymentStatus(paymentDetails!.id.toString(), cancelToken);
      // Update the sync status using the onStatusSynced callback
      onStatusSynced(syncStatus);
    } catch (e) {
      rethrow;
    }
  }

  /// Callback function called when the payment status is synced.
  void onStatusSynced(PaymentStatusSyncModel status) {
    // Check if the status indicates that the payment is succeeded or failed.
    if (status.isSucceeded || status.isFailed) {
      if(status.isSucceeded) {
        paymentStatus = PaymentStatus.success;
      } else {
        paymentStatus = PaymentStatus.fail;
      }
      // Determine the message based on the payment status.
      String msg = paymentStatusToMsg(status: status);

      paymentStatusDesc = paymentStatusToMessage(paymentStatus!, status: status);
      
      // Show a toast message with the payment status message
      if(status.isFailed && service!.isCardForm){
        Helper.showToastMessage(msg);
      }
      // Cancel the payment timer
      processPaymentTimer?.cancel();
      service?.justifiFormController = null;
      // Navigate back to the previous screen if payment type is Debit/Credit card
      if(status.isFailed && service!.isCardForm) Get.back();
      update();
    } else{
      paymentStatus = PaymentStatus.inProgress;
      update();
    }
  }

  String paymentStatusToMsg({PaymentStatusSyncModel? status, bool isPending = false}) {
    if (isPending) {
      return 'payment_process_pending_message'.tr;
    } else if (status?.isSucceeded ?? false) {
      return 'payment_successful'.tr;
    } else if (status?.isFailed ?? false) {
      return (status?.failedReason ?? 'payment_failed_message'.tr);
    }
    return '';
  }

  String paymentStatusToMessage(PaymentStatus paymentStatus,{PaymentStatusSyncModel? status}) {
    switch(paymentStatus){
      case PaymentStatus.success:
        return 'payment_process_success_message'.tr;
      case PaymentStatus.fail:
        return (status?.failedReason ?? 'payment_failed_message'.tr);
      case PaymentStatus.pending:
        return "";
      case PaymentStatus.inProgress:
        return 'payment_process_in_progress_message'.tr;
    }
  }

  /// [proceedPayment] Proceeds with the payment processing or recording
  ///
  /// This method is responsible for handling the payment process. It toggles the loading state,
  /// saves the form if it is a record payment form, or processes the payment otherwise.
  Future<void> proceedPayment() async {
    if (service == null) return;
    try {
      toggleIsLoading(true);
      // If it is a record payment form, save the form
      if (service!.isRecordPaymentForm) {
        await service!.saveForm();
      } else {
        // Otherwise, process the payment
        final params = service!.paymentFormJson();

        if(LDService.hasFeatureEnabled(LDFlagKeyConstants.leappayPaymentFeePassoverToggle)) {
          params['is_leap_pay_fee_passover_enabled'] = Helper.isTrueReverse(service?.feePassover);
        }

        paymentDetails = await LeapPayRepository.processPayment(params);
        startPaymentProcessing();
      }
    } catch (e) {
      // In case of an error, go back and rethrow the exception
      Get.back();
      rethrow;
    } finally {
      // Toggle the loading state back to false
      toggleIsLoading(false);
    }
  }

  void toggleIsLoading(bool val) {
    isLoading = val;
    update();
  }

  Future<bool> onWillPop() async {
    if (isSyncingStatus) return false;
    stopProcessingPayment();
    return true;
  }

  void onDispose() {
    if (isSyncingStatus) {
      stopProcessingPayment(doPop: false);
    }
    processPaymentTimer?.cancel();
  }
}