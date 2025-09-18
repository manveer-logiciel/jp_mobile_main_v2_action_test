import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:jobprogress/common/enums/payment_form_type.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/forms/payment/invoice_payment_detail.dart';
import 'package:jobprogress/common/models/forms/payment/method.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/models/justifi/tokenization.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/leap_pay_payment_method.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/modules/job_financial/form/leappay_preferences/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// PaymentFormData is responsible for providing data to be used by form
/// - Helps in setting up form data
/// - Helps in proving json to be used while making api request
class PaymentFormData {
  PaymentFormData({
    required this.update,
    this.jobId,
    this.invoiceId,
    this.financialDetails,
    this.actionFrom,
    required this.type,
    required this.receivePaymentFormType,
  });

  // form field controllers
  JPInputBoxController dateController = JPInputBoxController(validateInRealTime: true);
  JPInputBoxController paymentMethodController = JPInputBoxController(validateInRealTime: true);
  JPInputBoxController paymentAmountController = JPInputBoxController(validateInRealTime: true);
  JPInputBoxController checkRefernceNumberController = JPInputBoxController(validateInRealTime: true);
  JPInputBoxController zipController = JPInputBoxController(validateInRealTime: true);
  JPInputBoxController accountOwnerController = JPInputBoxController(validateInRealTime: true);
  JPInputBoxController nameController = JPInputBoxController(validateInRealTime: true);
  JPInputBoxController emailReceiptController = JPInputBoxController(validateInRealTime: true);

  LeapPayPreferencesController leapPayPreferencesController = LeapPayPreferencesController();

  final VoidCallback update; // update method from respective controller to refresh ui from service itself

  PaymentFormType type;
  
  JobModel? job;  // used to store selected job data

  String justifiFilePath = "assets/justifi/index.html";

  String? selectedPaymentMethodId;

  String? defaultPaymentMethod;
  String? selectedEmailReceipt;
  String? actionFrom;

  DateTime date = DateTime.now(); // used to select task due date

  bool showLinkInvoiceField = true;

  List<JPSingleSelectModel> emailReceiptList = [];
  List<JPSingleSelectModel> paymentMethodList = [];
  List<JPMultiSelectModel> filterInvoiceList = [];
  List<JPMultiSelectModel> invoiceList = [];
  List<JPInputBoxController> invoiceFieldControllerList = [];
  List<InvoicePaymentDetailModel> paramInvoiceList = [];

  List<MethodModel>? apiMethodList;
  List<FilesListingModel>? apiInvoiceList;

  FinancialListingModel? financialDetails;
  
  int? invoiceId;
  int? jobId;

  /// helps in differentiating process payment and record payment form
  /// [True] - means record payment & [False] - means process payment is selected
  bool isRecordPaymentForm = false;

  /// helps in differentiating card form and bank form
  /// [True] - means card form & [False] - means bank form is selected
  bool isCardForm = true;

  /// helps in differentiating invoice amount and custom amount
  /// [True] - means invoice amount & [False] - means custom amount is selected
  bool isInvoiceAmount = true;

  /// helps in differentiating saving account and checking account
  /// [True] - means saving account & [False] - means checking account is selected
  bool isSavingAccount = false;

  /// [isCardForm] & [isBankFormLoaded] helps in displaying loader in place of
  /// card and bank form until they are loaded from justifi server
  bool isCardFormLoaded = false;
  bool isBankFormLoaded = false;

  /// [isLeapPayEnabled] helps in displaying and executing process payment
  bool isLeapPayEnabled = ConnectedThirdPartyService.isLeapPayEnabled();

  /// [justifiFormController] used to interact with justifi by
  /// executing javascript and listening to events
  InAppWebViewController? justifiFormController;

  /// [receivePaymentFormType] helps in differentiating
  /// between process payment and record payment
  ReceivePaymentFormType? receivePaymentFormType;

  /// [tokenizationDetails] stores the justifi payment method token details
  JustifiTokenizationModel? tokenizationDetails;

  double pendingInvoiceAmount = 0;
  double invoicesAmount = 0;
  double unApplidAmount = 0;
  double calculatedUnappliedAmount = 0;

  /// [justifySectionHeight] helps in adjusting the flutter frame
  /// as per the rendered justifi HTML form
  double justifySectionHeight = 160;

  Map<String, dynamic> initialapplyFormJson = {};
  Map<String, dynamic> initialpaymentReceiveFormJson = {};

  bool get showLeapPreferenceStatus => actionFrom == 'quick_action'
      && (!isLeapPayEnabled || (!(financialDetails?.isAcceptingLeapPay ?? true)));

  // initDefaultValue(): set-up form data to be pre-filled in form

  void initDefaultValue({String? tempDate}) {
    // setting default email receipt
    if (emailReceiptList.isNotEmpty) {
      selectedEmailReceipt = emailReceiptList.first.id;
      emailReceiptController.text = emailReceiptList.first.label;
    }
    dateController.text = tempDate ?? DateTimeHelper.formatDate(
        date.toString(), DateFormatConstants.dateOnlyFormat);
    paymentMethodController.text = paymentMethodList.first.label;
    selectedPaymentMethodId = paymentMethodList.first.id;
    if (invoiceId != null) {
      int index = invoiceList.indexWhere((element) => element.id == invoiceId.toString());
      invoiceList[index].isSelect = true;
      filterInvoiceList.add(invoiceList[index]);
    }
    // displaying invoice amount by default if invoice list is not empty
    // otherwise giving option to user to enter custom amount
    isInvoiceAmount = filterInvoiceList.isNotEmpty;
    if(type == PaymentFormType.receivePayment){
      initialpaymentReceiveFormJson = paymentFormJson();
    }
    setPaymentMethodFromInvoice();
    // setting default leap pay preferences
    leapPayPreferencesController.setLeapPayPreferences(
      isAcceptingLeapPay: financialDetails?.isAcceptingLeapPay,
      defaultPaymentMethod: financialDetails?.defaultPaymentMethod,
      isFeePassoverEnabledForInvoice: financialDetails?.isFeePassoverEnabled,
    );
  }
 
  Map<String, dynamic> applyPaymentFormJson(List<InvoicePaymentDetailModel> paramInvoiceList) {
   
    final Map<String, dynamic> data = {};
      data["job_id"] = jobId;
      data["method"] = 'cash';
      data["unapplied_payment"] = 1;
      for (int i = 0; i < paramInvoiceList.length; i++){
        data['invoice_payments[$i][invoice_id]'] = paramInvoiceList[i].invoiceId;
        data['invoice_payments[$i][amount]'] = paramInvoiceList[i].amount;
      }
    return data;
  }

  Map<String, dynamic> paymentFormJson() {
    double paymentAmount = double.tryParse(getPayableAmount()) ?? 0;

    List<InvoicePaymentDetailModel> paramInvoiceList = [];

    for (JPMultiSelectModel file in filterInvoiceList) {
      if (double.parse(file.additionData) >= paymentAmount) {
        paramInvoiceList.add(InvoicePaymentDetailModel(
            invoiceId: file.id, amount: paymentAmount.toString()));
        break;
      } else {
        paramInvoiceList.add(InvoicePaymentDetailModel(
            invoiceId: file.id, amount: file.additionData));
        paymentAmount = paymentAmount - double.parse(file.additionData);
      }
    }

    final Map<String, dynamic> data = {};
    data["job_id"] = jobId;
    data["unapplied_payment"] = 0;
    data['payment'] = getPayableAmount();

    if (isRecordPaymentForm) {
      data["method"] = selectedPaymentMethodId;
      data['date'] = DateTimeHelper.convertSlashIntoHyphen(dateController.text);
      if (paymentMethodController.text != 'Cash') {
        data['echeque_number'] = checkRefernceNumberController.text;
      }
    } else {
      data["payment_token"] = tokenizationDetails?.paymentToken;
      data["email"] = emailReceiptController.text;
    }

    if (paramInvoiceList.isNotEmpty) {
      for (int i = 0; i < paramInvoiceList.length; i++) {
        data['invoice_payments[$i][invoice_id]'] = paramInvoiceList[i].invoiceId;
        data['invoice_payments[$i][amount]'] = paramInvoiceList[i].amount;
      }
    }
    return data;
  }

  /// [getPayableAmount] Returns the payable amount based on the payment scenario
  /// If it's a record payment, returns the Payment Amount
  /// If it's an invoice amount, returns the Invoice Amount
  /// If it's custom payment, returns the Payment Amount
  String getPayableAmount({bool? isFeePassOverEnabled}) {
    String amount = '';

    if (isRecordPaymentForm) {
      amount = paymentAmountController.text;
    } else if (isInvoiceAmount) {
      amount = invoicesAmount.toString();
    } else {
      amount = paymentAmountController.text;
    }

    if ((isFeePassOverEnabled ?? false) && !isRecordPaymentForm) {
      String method = isCardForm ? LeapPayPaymentMethod.card : LeapPayPaymentMethod.achOnly;
      double actualAmount = double.parse(amount);
      amount = (actualAmount + JobFinancialHelper.calculateLeapPayFee(method, actualAmount)).toString();
    }

    return amount;
  }

  void setPaymentMethodFromInvoice() {
    if (financialDetails != null) {
      defaultPaymentMethod = financialDetails?.defaultPaymentMethod ?? LeapPayPaymentMethod.both;
    }
  }
}
