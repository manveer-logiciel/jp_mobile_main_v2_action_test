import 'dart:ui';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/network_singleselect.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../core/constants/date_formats.dart';
import '../../../core/utils/date_time_helpers.dart';
import '../../../modules/job_financial/form/bill_form/controller.dart';
import '../../models/accounting_head/accounting_head_model.dart';
import '../../models/forms/bill/index.dart';
import '../../models/job/job.dart';
import '../../models/job_financial/financial_listing.dart';
import '../../models/sheet_line_item/sheet_line_item_model.dart';
import '../../repositories/job.dart';
import '../../repositories/job_financial.dart';
import '../forms/value_selector.dart';

class BillService extends BillFormData {
  final BillFormController controller;

  final int customerId;

  JobModel? job;

  final VoidCallback validateForm;

  BillService({
    required super.update,
    required this.controller,
    required this.customerId,
    required this.validateForm,
  });

  Future<void> init(int jobId, FinancialListingModel? model) async {
    try {
      this.jobId = jobId;
      await fetchJob();
      await fetchVendors();
      presetFormValues(model);
    } catch(e) {
      rethrow;
    }
  }

  Future<void> fetchJob() async {
    try {
      await JobRepository.fetchJob(jobId).then((Map<String, dynamic> response) {
        job = response["job"];
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchVendors() async {
    try {
      Map<String,String> params = {
        'includes[]': 'sub_accounts',
        'limit': '500'
      };
      final List<AccountingHeadModel> tempAccountingHeads = await JobRepository.fetchVendors(params);
      for(AccountingHeadModel accountingHead in tempAccountingHeads) {
        accountingHeads.add(
            JPSingleSelectModel(
                label: accountingHead.name.toString(),
                subLabel: accountingHead.accountSubType ?? '',
                id: accountingHead.id.toString()
            ));
      }
    } catch (e) {
      rethrow;
    }
  }

  void deleteItem(int index) {
    billItems.removeAt(index);
    calculateItemsPrice();
    update();
  }

  Future<void> scrollToErrorField() async {
    
    bool isVendorTitleError =   validateVendorTitle(vendorController.text) != null;
    
    if (isVendorTitleError) {
      vendorController.scrollAndFocus();
    } 
  }

  String? validateVendorTitle(dynamic val) {
    return FormValidator.requiredFieldValidator(val, errorMsg: 'vendor_is_required'.tr);
  }

  
  void openVendors() {
    FormValueSelectorService.openNetworkSingleSelect(
        title: 'select_vendor'.tr,
        controller: vendorController,
        networkListType: JPNetworkSingleSelectType.vendors,
        selectedItemId: selectVendor?.id ?? '',
        onValueSelected: (val) async {
          selectVendor = val;
          addressController.text = selectVendor?.subLabel ?? '';
          await Future<void>.delayed(const Duration(milliseconds: 200));
          validateForm.call();
        });
  }

  void onClickBillDateField() async {
    DateTime? selectedDate = await DateTimeHelper.openDatePicker(helpText: 'bill_date'.tr);
    if(selectedDate!=null) {
      billDateController.text = DateTimeHelper.format(selectedDate.toString(), DateFormatConstants.dateOnlyFormat);
      validateForm.call();
    }
  }

  void onClickDueDateField() async {
    DateTime? selectedDate = await DateTimeHelper.openDatePicker(helpText: 'due_date'.tr);
    if(selectedDate!=null) {
      dueDateController.text = DateTimeHelper.format(selectedDate.toString(), DateFormatConstants.dateOnlyFormat);
      validateForm.call();
    }
  }

  void addUpdateBillItem(SheetLineItemModel billItemModel, bool isUpdate) {
    billItemModel.price = JobFinancialHelper.initialZeroRemover(billItemModel.price ?? "");
    billItemModel.qty  = JobFinancialHelper.initialZeroRemover(billItemModel.qty ?? "");

    if(!isUpdate) {
      billItems.add(billItemModel);
    }
  }

  void calculateItemsPrice() {
    totalPrice = 0.0;
    for (SheetLineItemModel item in billItems) {
      totalPrice += double.parse(item.totalPrice ?? "");
    }
  }

  Future<void> saveOrUpdateBillForm() async {
    try {
      final Map<String, dynamic> params = createBillFormJson();
      if(billId == null) {
        final bool status = await JobFinancialRepository.saveBill(params);
        if(status) {
          Helper.showToastMessage('bill_saved'.tr);
        }
      } else {
        final bool status = await JobFinancialRepository.updateBill(params, billId!);
        if(status) {
          Helper.showToastMessage('bill_updated'.tr);
        }
      }
      Get.back(result: true);
    } catch (e) {
      rethrow;
    }
  }

  void reorderItem(int oldIndex, int newIndex) {
    final SheetLineItemModel temp = billItems.removeAt(oldIndex);
    billItems.insert(newIndex, temp);
  }

  void onNoteTextChange(String? val) {
    note = val?.trim() ?? "";
    update();
  }

  void showFileAttachmentSheet() {
    FormValueSelectorService.selectAttachments(
        attachments: attachments,
        jobId: job?.id,
        maxSize: Helper.flagBasedUploadSize(fileSize: CommonConstants.totalAttachmentMaxSize),
        onSelectionDone: () {
          update();
        });
  }

  void removeAttachedItem(int index) {
    Helper.hideKeyboard();
    attachments.removeAt(index);
    update();
  }

  void presetFormValues(FinancialListingModel? financialListingModel) {
    if(financialListingModel != null) {
      controller.service.totalPrice = double.parse(financialListingModel.totalAmount!);
      setFormData(financialListingModel);
    } else {
      initDate();
    }
    initializeJson();
  }

  void initDate() {
    billDateController.text = DateTimeHelper.format(DateTimeHelper.now(), DateFormatConstants.dateOnlyFormat);
    dueDateController.text = DateTimeHelper.format(DateTimeHelper.now(), DateFormatConstants.dateOnlyFormat);
  }

  void initializeJson() {
    initialJson = createBillFormJson();
  }
}