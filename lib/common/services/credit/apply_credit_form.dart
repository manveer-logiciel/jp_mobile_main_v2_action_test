import 'dart:ui';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/forms/apply_credit/credit_detail.dart';
import 'package:jobprogress/common/models/forms/apply_credit/index.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/modules/job_financial/form/apply_credit_form/controller.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';



/// ApplyCreditFormService used to manage form data. It is responsible for all the data additions, deletions and updates
/// - This service directly deal with form data independent of controller
class ApplyCreditFormService extends ApplyCreditFormData {
  ApplyCreditFormService({
    required this.update,
    required this.validateForm,
    this.invoiceId,
    List<FilesListingModel>? invoiceList,
    super.selectedInvoiceId,
    super.job,
  });

  final VoidCallback validateForm; // helps in validating form when form data updates

  final VoidCallback update;

  int? invoiceId;
  bool isSavingForm = false;
  
  ApplyCreditFormController? _controller; // helps in managing controller without passing object
  
  ApplyCreditFormController get controller => _controller ?? ApplyCreditFormController();

  set controller(ApplyCreditFormController value) {
    _controller = value;
  }

  // initForm(): initializes form data
  void initForm(){
    addDataInLinkInvoiceList();
    initFormDefaultData();
  }

  void initFormDefaultData({String? date}) {
    dateController.text = date ?? DateTimeHelper.formatDate(dueOnDate.toString(), DateFormatConstants.dateOnlyFormat);
    if(linkInvoiceList.length != 1) {
      if(invoiceId != null) {
        linkInvoiceListController.text = linkInvoiceList.firstWhere(
          (element) => element.id == invoiceId.toString()
        ).label;
        selectedInvoiceId = invoiceId.toString();
      } else {
        linkInvoiceListController.text =  linkInvoiceList[1].label;
        selectedInvoiceId = linkInvoiceList[1].id;
      }
    } else {
      showLinkInvoiceField = false;
    }
  }

  void selectDueOnDate() {
    FormValueSelectorService.selectDate(
      isPreviousDateSelectionAllowed: true,
      date: dueOnDate,
      controller: dateController,
      initialDate: dueOnDate.toString(),
      onDateSelected: (date) {
        dueOnDate = date;
      }
    );
  }

  void addDataInLinkInvoiceList(){
    linkInvoiceList.add( 
      JPSingleSelectModel(id: '', label: 'none'.tr.capitalize!)
    );
    if(invoiceList != null){
      for(FilesListingModel invoice in invoiceList!){
        if(double.parse(invoice.openBalance!) > 0.00){
          linkInvoiceList.add(
            JPSingleSelectModel(
              id: invoice.id! , 
              label: 
                '${invoice.name!} - ${JobFinancialHelper.getCurrencyFormattedValue(
                  value:invoice.openBalance
                )}',
          ));
        }  
      }
    }}

    String? validateNote(String val) {
      return FormValidator.requiredFieldValidator(
        val, errorMsg: 'please_enter_note'.tr
      );
    }

    String? validateCredit(String val) {
      return FormValidator.validateCreditAmount(val, selectedInvoiceId, invoiceList);
    }

    void openLinkListBottomsheet(){
      SingleSelectHelper.openSingleSelect(
        linkInvoiceList, 
        selectedInvoiceId, 
        'select_invoice'.tr.toUpperCase(), 
        (value) {
          selectedInvoiceId = value;
          linkInvoiceListController.text = 
          SingleSelectHelper.getSelectedSingleSelectValue(
            linkInvoiceList, 
            selectedInvoiceId
          );
          Get.back();
          if(controller.validateFormOnDataChange){
            validateForm();
          }
        }
      );
    }

    void saveForm() {
      final params = applyCreditFormJson();
      applyCreditRequest(params);
    }

    void toggleIsSavingForm() {
      isSavingForm = !isSavingForm;
      update();
    }

    void applyCreditRequest(Map<String,dynamic> params) async {    
      try{
        toggleIsSavingForm();
        bool status = await JobFinancialRepository().applyCredit(params);  
        if(status) {
          Helper.showToastMessage('${'credit'.tr.capitalize!} ${'added'.tr}');
          Get.back(result: status);
        }
      } catch(e) {
        rethrow;
      } finally {
        toggleIsSavingForm();
      }
    }

    // scrollToErrorField(): confirms which validation is failed and scrolls to that field in view & focuses it
    void scrollToErrorField() {
      bool isCreditAmountError = validateCredit(creditAmountController.text) != null;
      bool isNoteError = validateNote(noteController.text) != null;
      
      if (isCreditAmountError) {
        creditAmountController.scrollAndFocus();
      } else if (isNoteError) {
        noteController.scrollAndFocus();
      }
    }

    static Map<String, dynamic> getApplyCreditBottomSheetParams(FinancialListingModel invoiceDetail, List<FinancialListingModel> unAppliedCreditList){ 
    
      List<CreditDetailModel> unappliedCreditListModel = []; 
      
      num invoiceAmount = num.parse(invoiceDetail.openBalance!);
      
      for(FinancialListingModel unappliedCredit in unAppliedCreditList){
        if(invoiceAmount <= double.parse(unappliedCredit.unAppliedAmount!)){
          unappliedCreditListModel.add(
            CreditDetailModel(
            creditId: unappliedCredit.id,
            amount: invoiceAmount
          ));
          break;
        } else {
          unappliedCreditListModel.add(
            CreditDetailModel(
              creditId: unappliedCredit.id,
              amount: num.parse(unappliedCredit.unAppliedAmount!)
            )
          );
          invoiceAmount = invoiceAmount - num.parse(unappliedCredit.unAppliedAmount!);
        }
      }
      
      Map<String, dynamic> params = {
        'invoice_id':invoiceDetail.id,
        'credit_details': List.generate(unappliedCreditListModel.length, (index)=>
          unappliedCreditListModel[index].toJson()
        ).toList()
      };
      return params;
    }
  }

