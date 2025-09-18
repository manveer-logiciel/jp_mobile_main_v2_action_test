import 'dart:convert';
import 'dart:ui';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/payment_form_type.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/forms/payment/index.dart';
import 'package:jobprogress/common/models/forms/payment/invoice_payment_detail.dart';
import 'package:jobprogress/common/models/forms/payment/method.dart';
import 'package:jobprogress/common/models/justifi/tokenization.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';
import 'package:jobprogress/core/constants/justifi/functions.dart';
import 'package:jobprogress/core/constants/leap_pay_payment_method.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/payment_method.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/job_financial/form/leappay_preferences/controller.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/apply_payment_form/controller.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/receive_payment_form/controller.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/receive_payment_form/widget/total_amount.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/InputBox/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';

/// PaymentFormService used to manage form data. It is responsible for all the data additions, deletions and updates
/// - This service directly deal with form data independent of controller
class PaymentFormService extends PaymentFormData {
  PaymentFormService({
    required super.update,
    required super.type,
    required this.validateForm,
    super.invoiceId,
    super.jobId,
    super.receivePaymentFormType,
    super.financialDetails,
    super.actionFrom
  });

  final VoidCallback validateForm; // helps in validating form when form data updates
  
  ReceivePaymentFormController? _receivePaymentFormController; // helps in managing controller without passing object

  ReceivePaymentFormController get receivePaymentFormController =>  _receivePaymentFormController ?? ReceivePaymentFormController();

  set receivePaymentFormController(ReceivePaymentFormController value) {
    _receivePaymentFormController = value;
  }

  ApplyPaymentFormController? _applyPaymentFormcontroller; // helps in managing controller without passing object

  ApplyPaymentFormController get applyPaymentFormcontroller => _applyPaymentFormcontroller ?? ApplyPaymentFormController();

  /// [showPaymentAmountSection] is used to show/hide payment amount section
  bool get showPaymentAmountSection => filterInvoiceList.isNotEmpty;

  /// [showPaymentAmountField] is used to show/hide payment amount
  /// field in case of Process Payment
  bool get showPaymentAmountField => filterInvoiceList.isEmpty || !isInvoiceAmount;

  /// [isLoadingJustifiForm] helps in displaying loader
  /// in place of justifi form in case of Process Payment
  bool get isLoadingJustifiForm => !isRecordPaymentForm && !isCardFormLoaded && !isBankFormLoaded;

  /// [showFormSelection] helps deciding whether to allow
  /// switch between Process Payment and Record Payment
  bool get showFormSelection => receivePaymentFormType == null;

  /// [hasInvoiceSelected] helps in disabling invoice editing if already selected
  bool get hasInvoiceSelected => invoiceId != null;

  /// [feePassover] helps in deciding whether to show/hide fee passover
  bool feePassover = false;

  bool isGlobalFeePassoverSettingEnabled = false;

  set applyPaymentFormcontroller(ApplyPaymentFormController value) {
    _applyPaymentFormcontroller = value;
  }

  Future<void> initReceivePaymentForm() async {
    dynamic setting = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.defaultLeapPayPaymentMethod);
    dynamic globalFeePassoverSetting = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.leapPayFeePassOverEnabled);

    feePassover = Helper.isTrue(globalFeePassoverSetting);
    isGlobalFeePassoverSettingEnabled = Helper.isTrue(globalFeePassoverSetting);

    defaultPaymentMethod = setting is bool || setting == null ? LeapPayPaymentMethod.both : setting;
    // deciding type of receive payment form
    setIsRecordPayment();

    if (!RunModeService.isUnitTestMode){
      // delay to prevent navigation animation lags
      await Future<void>.delayed(const Duration(milliseconds: 200));
      showJPLoader();
      try {
        await Future.wait([
          fetchJob(), 
          fetchPaymentMethodList(),
          fetchInvoiceListing()
        ]);

        setPaymentMethodList();
        setEmailReceiptList(); // setting email receipt list
        setInvoiceList();
        initDefaultValue();
        setDefaultPaymentForm(); // set payment form type i.e. Credit/Debit Card or Bank Account
        calculatePendingInvoiceAmount(); // filling form data
      } catch (e) {
        rethrow;
      } finally {
        Get.back();
        update();
      }           
    }
  }

  void toggleFeePassover() {
    feePassover = !feePassover;
    update();
  }

  Future<void> initApplyPaymentForm() async {
    // delay to prevent navigation animation lags
    await Future<void>.delayed(const Duration(milliseconds: 200));
    showJPLoader();
    try {
      await Future.wait([
        fetchJob(),
        fetchInvoiceListing()
      ]);
      initApplyPaymentInputField();
    } catch(e) {
      rethrow;
    } finally {
      Get.back();
      update();
    }
  }

  void initApplyPaymentInputField(){
    invoiceFieldControllerList =
      List.generate(apiInvoiceList!.length, (i) => JPInputBoxController());
    unApplidAmount =  (job!.customer!.unappliedAmount!).toDouble();
  }

  void setDefaultPaymentForm(){
    isCardForm = !(defaultPaymentMethod == LeapPayPaymentMethod.achOnly);
    changePaymentMethod(isCardForm);
  }

  void calculateUnappliedAmount(){
    double inputFieldTotalAmount = 0;
    for(int i= 0; i < invoiceFieldControllerList.length; i++){
      double inputFieldAmount = invoiceFieldControllerList[i].text.isEmpty ? 0.0: 
      double.parse(invoiceFieldControllerList[i].text); 
      inputFieldTotalAmount += inputFieldAmount;
    }
    calculatedUnappliedAmount =  unApplidAmount - inputFieldTotalAmount;
  }
   
  Future<void> fetchJob() async {
    try {
      Map<String, dynamic> params = {
        'includes[0]': 'contacts.emails',
      };
      await JobRepository.fetchJob(jobId!, params: params).then((Map<String, dynamic> response) {
        job = response["job"];
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchPaymentMethodList() async {
    try {
      apiMethodList = await JobFinancialRepository.fetchMethodList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchInvoiceListing() async {
    try {
      Map<String, dynamic> params = {'id': jobId.toString()};
      await JobFinancialRepository.fetchFiles(params).then((Map<String, dynamic> response) {
        apiInvoiceList = response["list"];
      });
    } catch (e) {
      rethrow;
    }
  }

  /// [setIsRecordPayment] decides the receive payment form type
  void setIsRecordPayment() {
    if (receivePaymentFormType == null) {
      // If payment form is not opened from quick-actions 
      // If leap pay is enabled, default selected form 
      // will be Process Payment otherwise Record Payment
      isRecordPaymentForm = !isLeapPayEnabled;
    } else {
      // If payment form is opened from quick actions, then deciding whether to
      // display Process Payment or Record Payment form only
      isRecordPaymentForm = receivePaymentFormType == ReceivePaymentFormType.recordPayment;
    }
  }

  void setPaymentMethodList() {
    if (apiMethodList != null) {
      for (MethodModel method in apiMethodList!) {
        paymentMethodList.add(JPSingleSelectModel(label: method.label!, id: method.method!));
      }
    }
  }

  /// [setEmailReceiptList] Sets the email receipt list.
  ///
  /// Retrieves emails from various sources: job customer, additional customer emails,
  /// and contact persons' emails. Removes duplicates and adds them to the
  /// [emailReceiptList] as [JPSingleSelectModel].
  void setEmailReceiptList() {
    List<String> tempEmails = [];
    // Add customer email
    if (job?.customer != null) {
      if (!Helper.isValueNullOrEmpty(job?.customer?.email)) {
        tempEmails.add(job!.customer!.email!);
      }
      // Add additional customer emails
      job?.customer?.additionalEmails?.forEach((email) {
        if (email != null) tempEmails.add(email);
      });
    }
    // Add contact persons' emails
    job?.contactPerson?.forEach((person) {
      person.emails?.forEach((data) {
        tempEmails.add(data.email);
      });
    });
    // Remove duplicates and add to email receipt list
    for (String email in tempEmails.toSet().toList()) {
      emailReceiptList.add(JPSingleSelectModel(label: email, id: email));
    }
  }

  void setInvoiceList({String? getLocale}) {
    filterInvoiceList.clear();
    invoiceList.clear();
    defaultPaymentMethod = LeapPayPaymentMethod.both;
    if (apiInvoiceList != null) {
      for (FilesListingModel invoice in apiInvoiceList!) {
        final option = JPMultiSelectModel(
            label: '${invoice.name!} - ${JobFinancialHelper.getCurrencyFormattedValue(value: invoice.openBalance!, locale: getLocale)}' ,
            id: invoice.id!,
            additionData: invoice.openBalance,
            isSelect: false,
        );

        if (!isRecordPaymentForm) {
          option.isDisabled = !(invoice.isAcceptingLeapPay ?? true);
          option.disableMessage = 'leap_pay_disabled'.tr;
          option.additionalDetails = invoice;
        }

        invoiceList.add(option);
      }
    }
  }

  // scrollToErrorField(): confirms which validation is failed and scrolls to that field in view & focuses it
    void scrollToErrorField() {
      if(type == PaymentFormType.receivePayment){
        if (isRecordPaymentForm) {
          bool isPaymentAmountError = validateAmount(paymentAmountController.text) != null;
          bool isReferenceNumberError = validateCheckReferenceNumber(checkRefernceNumberController.text) != null;

          if (isPaymentAmountError) {
            paymentAmountController.scrollAndFocus();
          } else if (isReferenceNumberError && selectedPaymentMethodId != PaymentMethodId.cash) {
            checkRefernceNumberController.scrollAndFocus();
          }
        } else {
          bool isPaymentAmountError = validateAmount(getPayableAmount()) != null;
          bool isZipCodeError = FormValidator.requiredFieldValidator(zipController.text) != null;
          bool isAccOwnerError = FormValidator.requiredFieldValidator(accountOwnerController.text) != null;
          bool isNameOnCardError = FormValidator.requiredFieldValidator(nameController.text) != null;
          bool isEmailError = FormValidator.requiredFieldValidator(emailReceiptController.text) != null;
          if (isPaymentAmountError) {
            paymentAmountController.scrollAndFocus();
          } else if (isCardForm && isZipCodeError) {
            zipController.scrollAndFocus();
          } else if (isCardForm && isNameOnCardError) {
            nameController.scrollAndFocus();
          } else if (!isCardForm && isAccOwnerError) {
            accountOwnerController.scrollAndFocus();
          } else if (isEmailError) {
            emailReceiptController.scrollAndFocus();
          }
        }

      } else {
        for(int i = 0; i < invoiceFieldControllerList.length; i++) {
          bool isInvoiceAmountValidate = validateApplyPaymentFormAmounts(invoiceFieldControllerList[i].text, i) != null;
          if(isInvoiceAmountValidate) {
            invoiceFieldControllerList[i].scrollAndFocus();
          }
        }
      }
    }
  

  void openPaymentMethodList() {
    SingleSelectHelper.openSingleSelect(paymentMethodList, selectedPaymentMethodId, 'select_method'.tr,(value) {
      paymentMethodController.text = SingleSelectHelper.getSelectedSingleSelectValue(paymentMethodList, value);
      selectedPaymentMethodId = value;
      Get.back();
      update();
      checkRefernceNumberController.validate();
    },
    inputHintText: 'search'.tr);
  }

  /// [selectEmailReceipt] helps in selecting an email receipt from a list of options.
  void selectEmailReceipt() {
    // Hide the keyboard
    Helper.hideKeyboard();
    // Set the selected email receipt to the value in the emailReceiptController
    selectedEmailReceipt = emailReceiptController.text;
    // Open a single select to choose an email receipt
    FormValueSelectorService.openSingleSelect(
      list: emailReceiptList,
      title: 'select_email'.tr,
      selectedItemId: selectedEmailReceipt ?? "",
      onValueSelected: onEmailReceiptSelected,
    );
  }

  Future<dynamic> openInvoiceList() {
    hideKeyboard();
    calculatePendingInvoiceAmount();

    return showJPBottomSheet(
      child: (controller) => 
      JPMultiSelect(
        totalAmount: TotalAmount(controller: receivePaymentFormController),
        updateTotalAmount: ({int? index, bool? isSelect, bool? isSelectAll}) => calculateTotalInBottomSheet(
          isSelect: isSelect, 
          index: index, 
          isSelectAll: isSelectAll
        ),
        mainList: invoiceList,
        inputHintText: 'search_here'.tr,
        title: 'select_invoice'.tr.toUpperCase(),
        disableButtons: controller.isLoading,
        hideSelectAll: true,
        onDone: onInvoicesSelected,
        onTapItem: disableLinkedInvoices,
      ),
      isScrollControlled: true,
    );
  }

  /// [onInvoicesSelected] selects the invoices and updates the invoice amount
  void onInvoicesSelected(List<JPMultiSelectModel> list) {
    List<JPMultiSelectModel> tempFilterInvoiceList = [];
    // Loop through each item in the list
    for (JPMultiSelectModel item in list) {
      // If the item is selected, add it to the temporary filter list
      if (item.isSelect) {
        tempFilterInvoiceList.add(item);
      }
    }
    // Checks that there no invoices were selected before
    // If no invoice was selected previously, then auto selected Invoice Amount
    // as the Payment Amount in case Custom Payment Amount is not been added
    if (filterInvoiceList.isEmpty) {
      isInvoiceAmount = paymentAmountController.text.trim().isEmpty;
    }
    // Update the invoiceList and filterInvoiceList
    invoiceList = list;
    filterInvoiceList = tempFilterInvoiceList;
    // Fetching first selected option
    if (invoiceList.isNotEmpty && !isRecordPaymentForm) {
      // disabling invoices in main list
      int index = invoiceList.indexWhere((element) => element.isSelect);
      if (index > -1) {
        disableLinkedInvoices(invoiceList, index);
        final invoice = invoiceList[index].additionalDetails as FilesListingModel?;
        defaultPaymentMethod = invoice?.defaultPaymentMethod ?? LeapPayPaymentMethod.both;
      } else {
        setInvoiceList();
      }
      setDefaultPaymentForm();
    }

    // Calculate the invoice amount
    calculatePendingInvoiceAmount();
    Get.back();
    update();
  }

  void calculatePendingInvoiceAmount() {
    invoicesAmount = 0;
    for (JPMultiSelectModel model in filterInvoiceList) {
      invoicesAmount = invoicesAmount + double.parse(model.additionData!);
    }

    double paymentAmount = double.tryParse(getPayableAmount()) ?? 0;

    pendingInvoiceAmount = paymentAmount - invoicesAmount;
    // restricting pending amount to get above 0
    if (pendingInvoiceAmount > 0) {
      pendingInvoiceAmount = 0;
    }
  }

  void calculateTotalInBottomSheet({int? index, bool? isSelect, bool? isSelectAll}) {
    
    double paymentAmount = paymentAmountController.text.isEmpty ? 0.00 : double.parse(paymentAmountController.text);

    if (isSelectAll != null) {
      if (isSelectAll) {
        for (JPMultiSelectModel model in invoiceList) {
          invoicesAmount = invoicesAmount + double.parse(model.additionData);
        }
      } else {
        invoicesAmount = 0;
      }
    }

    if (isSelect != null && index != null) {
      if (isSelect) {
        invoicesAmount = invoicesAmount + double.parse(invoiceList[index].additionData);
      } else {
        invoicesAmount = invoicesAmount - double.parse(invoiceList[index].additionData);
      }
    }

    pendingInvoiceAmount = paymentAmount - invoicesAmount;
    update();
  }

  String? validateAmount(dynamic val) {
    if (isRecordPaymentForm) {
      return FormValidator.requiredAmountValidator(val,
          errorMsg: 'please_enter_valid_amount'.tr.capitalizeFirst);
    } else {
      final parsedAmount = double.tryParse(val);

      if (parsedAmount == null) {
        return 'please_enter_valid_amount'.tr.capitalizeFirst;
      } else if (parsedAmount < 0.50) {
        return 'minimum_amount_should_be_50'.tr.capitalizeFirst;
      } else if (parsedAmount > 999999.99) {
        return 'maximum_payment_cant_be_greater_than_999999'.tr.capitalizeFirst;
      } else if (filterInvoiceList.isNotEmpty && parsedAmount > invoicesAmount) {
        return 'payment_cant_be_greater_than_invoices_amount'.tr.capitalizeFirst;
      }
    }

    return null;
  }

  String? validateApplyPaymentFormAmounts(dynamic val, int i) {
    return FormValidator.validateAmount(val, apiInvoiceList![i].id, apiInvoiceList);
  }


  String? validateCheckReferenceNumber(dynamic val) {
    // Keeping Reference Number optional in for other payment methods then check
    if (selectedPaymentMethodId != PaymentMethodId.check) return null;
    return FormValidator.requiredFieldValidator(val,
        errorMsg: 'please_enter_reference_number'.tr.capitalizeFirst);
  }

  void selectDueOnDate() {
    FormValueSelectorService.selectDate(
      isPreviousDateSelectionAllowed: true,
      date: date,
      controller: dateController,
      initialDate: date.toString(),
      onDateSelected: (value) {
        date = value;
      }
    );
  }

   void setParamInvoiceList(){
    paramInvoiceList = [];
    for(int i = 0; i < apiInvoiceList!.length; i++) {
      if(invoiceFieldControllerList[i].text.isNotEmpty && double.parse(invoiceFieldControllerList[i].text) > 0) {
        paramInvoiceList.add(InvoicePaymentDetailModel(
          invoiceId: apiInvoiceList![i].id,
          amount: invoiceFieldControllerList[i].text
        ));
      }
    }
  }

  Future<dynamic> saveForm() async {

    Map<String, dynamic> params = type == PaymentFormType.receivePayment ?
      paymentFormJson() :
      applyPaymentFormJson(paramInvoiceList);
    
    try {
      
      bool success = await JobFinancialRepository.applyPayment(params);
      
      if (success) {
        // Closing pay screen with extra back in case of Record Payment
        if (type == PaymentFormType.receivePayment) Get.back();
        Get.back(result: success);

        final message = type == PaymentFormType.receivePayment
            ? 'payment_recorded'.tr.capitalizeFirst!
            : 'payment_applied'.tr.capitalizeFirst!;
        Helper.showToastMessage(message);
      }
      return success;
    } catch (e) {
      rethrow;
    }
  }

  void removeInvoice(int i) {
    if (invoiceList.isEmpty || filterInvoiceList.isEmpty) return;
    invoiceList.firstWhere((element) => element.id == filterInvoiceList[i].id).isSelect = false;
    filterInvoiceList.removeAt(i);
    validateForm();
    // keeping the invoice amount selected if selected invoice list is not empty
    // & user previously selected invoice amount
    // otherwise switching to custom payment
    isInvoiceAmount = isInvoiceAmount && filterInvoiceList.isNotEmpty;
    calculatePendingInvoiceAmount();
    if (filterInvoiceList.isEmpty && !isRecordPaymentForm) {
      setInvoiceList();
    }
    update();
  }

 dynamic showValidationToastMessage(){
    if(invoiceFieldControllerList.every((element) => element.text.isEmpty || double.parse(element.text) == 0)){
        return Helper.showToastMessage('please_ajust_balance_amount'.tr);
    }
    if(calculatedUnappliedAmount.isNegative){
      return Helper.showToastMessage('please_maintain_sufficent_fund_for_adjustment'.tr);
    }
    return null;
  }

  // checkIfNewDataAdded(): used to compare form data changes
  bool checkIfNewDataAdded() {
    if(type == PaymentFormType.receivePayment){
      final currentJson = paymentFormJson();
      return initialpaymentReceiveFormJson.toString() != currentJson.toString();
    } else {
     return  invoiceFieldControllerList.any((element) => element.text.isNotEmpty);
    }
  }

  /// [changePaymentType] is used to change payment type
  void changePaymentType(dynamic value) {
    Helper.hideKeyboard();
    isRecordPaymentForm = value;
    // helps in reloading justifi form by displaying loader
    if (!isRecordPaymentForm) {
      isCardFormLoaded = isBankFormLoaded = false;
      justifySectionHeight = 160;
    }
    setInvoiceList();
    validateForm();
    update();
  }

  /// [changePaymentMethod] is used to change payment method
  Future<void> changePaymentMethod(dynamic value) async {
    isCardForm = value;
    // displaying loader in place of justifi form
    isCardFormLoaded = isBankFormLoaded = false;
    update();
    // setting up justify form content on the basis of payment method
    String function = JustifiFunctionConstants.setContent(isCardForm);
    await justifiFormController?.evaluateJavascript(source: function);
  }

  /// [changePaymentAmount] is used to change payment amount
  void changePaymentAmount(dynamic value) {
    isInvoiceAmount = value;
    calculatePendingInvoiceAmount();
    update();
  }

  /// [changeAccountType] is used to change account type b/w [Savings] & [Checking]
  void changeAccountType(dynamic value) {
    isSavingAccount = value;
    update();
  }

  void onEmailReceiptSelected(String value) {
    emailReceiptController.text = FormValueSelectorService
        .getSelectedSingleSelect(emailReceiptList, value).label;
    selectedEmailReceipt = value;
    emailReceiptController.validate();
    validateForm();
    update();
  }

  /// [onJustifiViewLoaded] helps in setting up justifi form
  /// - sets up payment method content
  /// - sets up form load listener
  /// - sets up tokenize listener
  Future<void> onJustifiViewLoaded(InAppWebViewController controller, _) async {
    changePaymentMethod(isCardForm);
    await justifiFormController?.evaluateJavascript(source: JustifiFunctionConstants.setContent(isCardForm));
    addJustifiFormLoadListener();
    addJustiFiHeightListener();
    justifiFormTokenizeListener();
  }

  /// [addJustifiFormLoadListener] Adds a listener for the Justifi form load event
  void addJustifiFormLoadListener() {
    // Add a JavaScript handler to the Justifi form controller
    justifiFormController?.addJavaScriptHandler(
      handlerName: 'paymentMethodLoaded',
      // Define a callback function that gets executed when the event is triggered
      callback: onPaymentMethodLoaded,
    );
  }

  /// [onPaymentMethodLoaded] performs necessary tasks when the payment method is loaded
  void onPaymentMethodLoaded(List<dynamic> arguments) {
    // Get the payment method from the arguments
    String method = arguments[0];
    // Check if the payment method is 'card'. Considering that card form is loaded
    if (method == 'card') isCardFormLoaded = true;
    // Check if the payment method is 'bank'. Considering that bank form is loaded
    if (method == 'bank') isBankFormLoaded = true;
  }

  /// [addJustiFiHeightListener] listens to height changes in justifi form in realtime
  void addJustiFiHeightListener() {
    justifiFormController?.addJavaScriptHandler(
        handlerName: "onHeightChanged",
        callback: onHeightUpdate,
    );
  }

  /// [onHeightUpdate] helps in updating the flutter content height on the basis of justifi form
  Future<void> onHeightUpdate(List<dynamic> arguments) async {
    // Parse the height as a double, or use the default height of 140 if parsing fails.
    // Add 20 to the height to provide some extra space.
    final tempHeight = (double.tryParse(arguments[0].toString()) ?? 140) + 20;
    justifySectionHeight = isLoadingJustifiForm ? 160 : tempHeight;
    update();
  }

  /// [justifiFormTokenizeListener] Adds a listener for the Justifi tokenize event
  void justifiFormTokenizeListener() {
    justifiFormController?.addJavaScriptHandler(
      handlerName: 'tokenize',
      callback: tokenizationHandler,
    );
  }

  /// [tokenizationHandler] Handles the tokenization process.
  ///
  /// [argument] - The argument passed to the tokenization handler.
  void tokenizationHandler(dynamic argument) {
    if (argument[0] is bool) {
      // If the argument is a boolean value,
      // used to disable form and display tokenization loading
      receivePaymentFormController.isSavingForm = Helper.isTrue(argument[0]);
    } else if (argument[0] is String) {
      // If the argument is a string,
      // display a toast message using
      Helper.showToastMessage(argument[0]);
    } else if (argument[0] is Map) {
      // If the argument is a map,
      // set up the tokenization details
      tokenizationDetails = JustifiTokenizationModel.fromJson(argument[0]);
      // proceed to pay if tokenization is successful
      proceedToPay();
    }
    update();
  }

  /// [validateJustifiForm] validates the justifi form fields
  Future<void> validateJustifiForm(bool isOtherFieldsValid) async {
  // No need to validate justifi payment in case of Record Payment
  if (isRecordPaymentForm) return;

  final errorMsg = validateAmount(getPayableAmount());
  // If the invoice amount is invalid and user is processing payment with invoice
  // show payment error message as a toast message
  if (errorMsg != null && isInvoiceAmount) {
    Helper.showToastMessage(errorMsg);
    // as Invoice Payment is not valid so marking [isOtherFieldsValid] as invalid
    isOtherFieldsValid = false;
  }
  final data = getTokenizationParams();
  // Construct the JavaScript source code for validation and tokenization
  final source = JustifiFunctionConstants.validateAndTokenize(
    isCardForm,
    isOtherFieldsValid,
    data: jsonEncode(data),
  );
  await justifiFormController?.evaluateJavascript(source: source);
}

  /// [getTokenizationParams] Retrieves the tokenization parameters based on the form input.
  ///
  /// Returns a [Map] containing the necessary data for tokenization.
  Map<String, dynamic> getTokenizationParams() {
      // Get the leapPay details using the connected party key
      final leapPayDetails = ConnectedThirdPartyService.getConnectedPartyKey(ConnectedThirdPartyConstants.leapPay);
      // Create the bank account form parameters
      Map<String, dynamic> bankAccountFormParams = {
        'account_owner_name': accountOwnerController.text,
        'account_type': isSavingAccount ? 'savings' : 'checking',
      };
      // Create the card form parameters
      Map<String, dynamic> cardFormParams = {
        'name': nameController.text,
        'address_postal_code': zipController.text,
      };
      // Create the data object with the necessary parameters
      Map<String, dynamic> data = {
        'client_id': Helper.getJustifiClientId(),
        'account_id': leapPayDetails?['account_id'],
        'params': isCardForm ? cardFormParams : bankAccountFormParams,
      };
      // Return the data for tokenization
      return data;
  }

  void unFocusJustifiForm() {
    if (isRecordPaymentForm) return;
    justifiFormController?.evaluateJavascript(source: JustifiFunctionConstants.unFocus);
  }

  void hideKeyboard() {
    Helper.hideKeyboard();
    unFocusJustifiForm();
  }

  Future<void> proceedToPay() async {
    await Get.toNamed(Routes.reviewPaymentDetails, arguments: {
      NavigationParams.paymentFormData: this
    });
    if (!isRecordPaymentForm) changePaymentMethod(isCardForm);
  }

  void dispose() {
    justifiFormController = null;
  }

  Future<void> onUpdatePreferences(LeapPayPreferencesController result) async {
    leapPayPreferencesController = result;
    await saveSetting();
    setPaymentMethodFromInvoice();
    setDefaultPaymentForm();
  }

  Future<void> saveSetting() async {
    if (financialDetails?.id == null) return;
    try{
      showJPLoader();

      Map<String,dynamic> params = {
        'leap_pay_enabled' : Helper.isTrueReverse(leapPayPreferencesController.acceptingLeapPay),
        'payment_method' : leapPayPreferencesController.getEnabledPaymentMethod(),
        'fee_passover_enabled': Helper.isTrueReverse(leapPayPreferencesController.isFeePassoverEnabled)
      };

      financialDetails = await JobFinancialRepository.updateLeapPayPreferences(id: financialDetails!.id!, params: params);

      if(apiInvoiceList != null && apiInvoiceList!.isNotEmpty) {
        int index = apiInvoiceList!.indexWhere((element) => element.id == (financialDetails?.id.toString() ?? ''));

        if(index > -1) {
          apiInvoiceList![index].isFeePassoverEnabled = financialDetails?.isFeePassoverEnabled ?? false;
        }
      }

      leapPayPreferencesController.setLeapPayPreferences(
        defaultPaymentMethod: financialDetails?.defaultPaymentMethod,
        isAcceptingLeapPay: financialDetails?.isAcceptingLeapPay,
        isFeePassoverEnabledForInvoice: financialDetails?.isFeePassoverEnabled
      );
    } catch(e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  void disableLinkedInvoices(List<JPMultiSelectModel> options, int index) {
    final tempInvoice = options[index].additionalDetails;
    final selectionCount = options.where((element) => element.isSelect).length;
    if (tempInvoice is FilesListingModel) {
      for (var invoice in options) {
        final optionInvoice = invoice.additionalDetails as FilesListingModel;
        if (selectionCount >= 1) {
          if (optionInvoice.isAcceptingLeapPay ?? false) {
            invoice.isDisabled = (tempInvoice.defaultPaymentMethod != optionInvoice.defaultPaymentMethod
            || tempInvoice.isFeePassoverEnabled != optionInvoice.isFeePassoverEnabled);
            
            invoice.disableMessage = 'payment_setting_doesnt_match_selection'.tr;
          }
        } else {
          if (optionInvoice.isAcceptingLeapPay ?? false) {
            invoice.isDisabled = false;
            invoice.disableMessage = null;
          }
        }
      }
    }
  }

  (String, String) getLeapPayPreferenceStatusMessage() {
    dynamic leapPayDetails = ConnectedThirdPartyService.getConnectedPartyKey(ConnectedThirdPartyConstants.leapPay);

    bool isLeapPayStatusEnabled = leapPayDetails?['status'] == 'enabled';
   
    if (isLeapPayEnabled && !(financialDetails?.isAcceptingLeapPay ?? false)) {
      return ('leap_pay_is_disabled_for_this_invoice'.tr, 'update_invoice_settings'.tr);
    }

    if(!isLeapPayStatusEnabled) {
      if(AuthService.isAdmin()){
        return ('leap_pay_is_not_setup'.tr, 'update_leap_pay_settings'.tr);
      } else {
        return ('your_leap_pay_is_not_setup'.tr, 'reach_out_to_your_admin_if_needed'.tr);
      }
    }

    if(isLeapPayStatusEnabled && CompanySettingsService.getDefaultPaymentOption() != 'leappay') {
      if(AuthService.isAdmin()) {
        return ('leap_pay_is_not_set_as_default_payment_processor'.tr, 'update_leap_pay_settings'.tr);
      } else {
        return ('leap_pay_is_not_set_as_default_payment_processor'.tr, 'reach_out_to_your_admin'.tr);
      }
    }

    return ("", "");
  }

  double calculateFees(String method) {
    double amount = showPaymentAmountField ? (double.tryParse(paymentAmountController.text) ?? 0) : invoicesAmount;
    return JobFinancialHelper.calculateLeapPayFee(method, amount);
  }

}
