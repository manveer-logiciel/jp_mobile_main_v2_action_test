import 'dart:ui';

import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/refund/index.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';
import '../../../core/constants/date_formats.dart';
import '../../../core/utils/job_financial_helper.dart';
import '../../../modules/job_financial/form/refund_form/controller.dart';
import '../../models/forms/payment/method.dart';
import '../../repositories/job.dart';
import '../forms/value_selector.dart';


class RefundService extends RefundFormData {
  final RefundFormController controller;

  final String customerId;
  final String jobId;
  JobModel? job;
  final VoidCallback validateForm;

  RefundService({
    required this.controller,
    required this.customerId,
    required this.jobId,
    required this.validateForm
  });

  Future<void> getRefunds() async {
    refunds = await JobFinancialRepository.getRefunds();
    for (var element in refunds) {
      refundFromList.add(
          JPSingleSelectModel(label: element.name!,
              id: element.id.toString(),
              subLabel: element.accountSubType.toString()));
    }
  }

  Future<void> init() async {
    await fetchJob();
    await getRefunds();
    await getPaymentMethods();
    setAddress();
    initialJson = createRefundFormJson(customerId, jobId); 
  }

  void setAddress() {
    String addressString = job?.customer?.addressString ?? '';
    String billingAddressString = job?.customer?.billingAddressString ?? '';
    addressController.text = Helper.isValueNullOrEmpty(billingAddressString) ? addressString : billingAddressString;
  }

  bool checkIfNewDataAdded() {
    final currentJson = createRefundFormJson(customerId, jobId);
    return initialJson.toString() != currentJson.toString();
  }

  Future<void> getPaymentMethods() async {
    final apiMethodList = await JobFinancialRepository.fetchMethodList();
    setPaymentMethods(apiMethodList);
  }

  void setPaymentMethods(List<MethodModel> apiMethodList) {
    paymentMethods.add(JPSingleSelectModel(label: 'none'.tr, id:''));
    for (MethodModel method in apiMethodList) {
      paymentMethods.add(JPSingleSelectModel(label: method.label!, id: method.method.toString()));
    }
    selectedPaymentMethod = JPSingleSelectModel(label: paymentMethods.first.label, id: paymentMethods.first.id);

    paymentMethodController.text = selectedPaymentMethod!.label;
  }

  Future<void> fetchJob() async {
    try {
      await JobRepository.fetchJob(int.parse(jobId)).then((Map<String, dynamic> response) {
        job = response["job"];
      });
    } catch (e) {
      rethrow;
    }
  }

  void deleteItem(int index) {
    refundItems.removeAt(index);
    calculateItemsPrice();
    controller.update();
  }

  void addUpdateRefundItem(SheetLineItemModel refundItemModel, bool isUpdate) {
    refundItemModel.price = JobFinancialHelper.initialZeroRemover(refundItemModel.price ?? "");
    refundItemModel.qty = JobFinancialHelper.initialZeroRemover(refundItemModel.qty ?? "");

    if(!isUpdate) {
      refundItems.add(refundItemModel);
    }
  }

  Future<void> saveRefundForm(int? customerId,int? jobId) async {
    try {
      final bool status = await JobFinancialRepository.saveRefund(
          createRefundFormJson(
              customerId.toString(),
              jobId.toString()));

      if(status) {
        Get.back(result: true);
        Helper.showToastMessage('refund_saved'.tr);
      }
    } catch (e) {
      rethrow;
    }
  }

  void onNoteTextChange(String? val) {
    note = val?.trim() ?? "";
    controller.update();
  }

  void reorderItem(int oldIndex, int newIndex) {
    final SheetLineItemModel temp = refundItems.removeAt(oldIndex);
    refundItems.insert(newIndex, temp);
  }

  void onClickDateField() async {
    DateTime? selectedDate = await DateTimeHelper.openDatePicker(helpText: 'receipt_date'.tr);
    if(selectedDate!=null) {
      receiptDateController.text = DateTimeHelper.format(selectedDate.toString(), DateFormatConstants.dateOnlyFormat);
    }
  }

  void scrollToRefundFrom() {
    refundFromController.scrollAndFocus();
  }

  void openPaymentMethod() {
    FormValueSelectorService.openSingleSelect(
        title: 'select_payment_method'.tr,
        list: paymentMethods,
        controller: paymentMethodController,
        selectedItemId: selectedPaymentMethod!.id,
        onValueSelected: (val) {
          selectedPaymentMethod?.id = val;
        });
  }

  void openRefundFrom() {
    FormValueSelectorService.openAccountingHeadSingleSelect(
        title: 'select_accounting_head'.tr,
        list:refundFromList,
        controller:refundFromController,
        selectedItemId:selectedRefundFrom.id,
        onValueSelected: (val) async {
          selectedRefundFrom.id = val;
          await Future<void>.delayed(const Duration(milliseconds: 200));
          validateForm.call();
        });
  }

  void calculateItemsPrice() {
    totalPrice = 0.0;
    for (var item in refundItems) {
      totalPrice += double.parse(item.totalPrice ?? "");
    }
  }
}