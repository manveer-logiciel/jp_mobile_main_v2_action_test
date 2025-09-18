import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import '../../../../common/models/sheet_line_item/sheet_line_item_model.dart';
import '../../../../common/services/refund/index.dart';
import '../../../../core/utils/form/dialog_helper.dart';
import '../../../../core/utils/form/validators.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../global_widgets/bottom_sheet/index.dart';
import '../../../../global_widgets/loader/index.dart';
import 'bottom_sheet/refund_add_item_bottom_sheet/index.dart';

class RefundFormController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey();

  late RefundService service;

  bool isLoading = true;
  bool isSavingForm = false;

  int? jobId;
  int? customerId;


  @override
  void onInit() {
    initForm();
    super.onInit();
  }

  Future<void> initForm() async {
    jobId = Get.arguments?[NavigationParams.jobId] ?? -1;
    customerId = Get.arguments?[NavigationParams.customerId] ?? -1;

    service = RefundService(
        controller: this,
        jobId: jobId.toString(),
        customerId: customerId.toString(),
        validateForm: onDataChanged
    );
    await Future<void>.delayed(const Duration(milliseconds: 200));
    showJPLoader();

    try {
      await Future.wait([
        service.init()
      ]);
    } catch(e) {
      rethrow;
    } finally {
      isLoading = false;
      Get.back();
      update();
    }
  }

  Future<void> saveRefundForm() async {
    if(formKey.currentState?.validate() ?? false) {
      try {
        if(service.refundItems.isEmpty) {
          Helper.showToastMessage('please_add_item_first'.tr);
        } else if(service.totalPrice <= 0.0) {
          Helper.showToastMessage('total_amount_should_be_greater_than_0'.tr);
        } else {
          isSavingForm = true;
          update();
          formKey.currentState?.save();
          await service.saveRefundForm(customerId, jobId);
        }
      } catch (e) {
        rethrow;
      } finally {
        isSavingForm = false;
        update();
      }
    } else {
      service.scrollToRefundFrom();
    }
  }

  Future<void> showAddItemBottomSheet({SheetLineItemModel? item}) async {
    Helper.hideKeyboard();
    showJPBottomSheet(child: (controller) =>
        RefundAddItemBottomSheet(
            onAddUpdate: (SheetLineItemModel refundItem, bool isUpdate) {
              service.addUpdateRefundItem(refundItem, isUpdate);
              service.calculateItemsPrice();

              update();
              Get.back();
            },
            refundItemModel: item),
        isScrollControlled: true,
    );
  }

  String? validateRefundFrom(dynamic refundFrom) {
    return FormValidator.requiredFieldValidator(refundFrom, errorMsg: 'accounting_head_is_required'.tr);
  }

  void onListItemReorder(int oldIndex, int newIndex) {
    if (oldIndex <= newIndex) {
      newIndex -= 1;
    }
    if(oldIndex == newIndex) return;

    service.reorderItem(oldIndex, newIndex);
    update();
  }

  Future<bool> onWillPop() async {

    bool isNewDataAdded = service.checkIfNewDataAdded();

    if(isNewDataAdded) {
      FormDialogHelper.showUnsavedChangesConfirmation();
    } else {
      Helper.hideKeyboard();
      Get.back();
    }

    return false;
  }

  void onDataChanged() {
    formKey.currentState?.validate();
  }
}