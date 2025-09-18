import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import '../../../../common/models/sheet_line_item/sheet_line_item_model.dart';
import '../../../../common/services/bill/index.dart';
import '../../../../core/utils/form/dialog_helper.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../global_widgets/bottom_sheet/index.dart';
import '../../../../global_widgets/loader/index.dart';
import 'bottom_sheet/index.dart';

class BillFormController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey();

  int customerId = Get.arguments?[NavigationParams.customerId] ?? -1;
  int jobId = Get.arguments?[NavigationParams.jobId] ?? -1;

  FinancialListingModel? model = Get.arguments?[NavigationParams.bill];

  bool isLoading = true;
  bool isSavingForm = false;
  bool validateFormOnDataChange = false;

  late BillService service;

  @override
  void onInit() {
    initForm();
    super.onInit();
  }

  Future<void> initForm() async {
    service = BillService(
        update: update,
        controller: this,
        customerId: customerId,
        validateForm: () => onDataChanged('')
     );

    await Future<void>.delayed(const Duration(milliseconds: 200));
    showJPLoader();

    try {
    await service.init(jobId, model);
    } catch(e) {
    rethrow;
    } finally {
    isLoading = false;
    Get.back();
    update();
    }
  }

  String  getSaveButtonText() {
    if(isSavingForm){
      return '';
    }

    if(model == null) {
      return 'save'.tr.toUpperCase();
    }

    return 'update'.tr.toUpperCase();
  }

  Future<void> saveOrUpdateBillForm() async {
    if(service.billId != null) {
      if(!service.checkIfNewDataAdded()) {
        Helper.showToastMessage('no_changes_made'.tr);
        return;
      }
    }
    validateFormOnDataChange = true;
    if(formKey.currentState?.validate() ?? false) {
      try {
        toggleSavingForm();
        if(service.billItems.isEmpty) {
          Helper.showToastMessage('please_add_item_first'.tr);
        } else if(service.totalPrice <= 0.0) {
          Helper.showToastMessage('total_amount_should_be_greater_than_0'.tr);
        } else {
          formKey.currentState?.save();
          await service.saveOrUpdateBillForm();
        }
      } catch(e) {
        rethrow;
      } finally {
        toggleSavingForm();
      }
    } else {
      service.scrollToErrorField();
    }
  }

  Future<bool> onWillPop() async {

    bool isNewDataAdded = service.checkIfNewDataAdded();

    if(isNewDataAdded) {
      FormDialogHelper.showUnsavedChangesConfirmation();
    } else {
      Helper.hideKeyboard();
      Get.back(result: null);
    }

    return false;
  }

  Future<void> showAddItemBottomSheet(SheetLineItemModel? item) async {
    Helper.hideKeyboard();
    showJPBottomSheet(child: (controller) =>
        BillAddItemBottomSheet(
            billItemModel: item,
            accountingHeads: service.accountingHeads,
            onAddUpdate: (SheetLineItemModel itemModel, bool isUpdate) {
              service.addUpdateBillItem(itemModel, isUpdate);
              service.calculateItemsPrice();

              update();
              Get.back();
            }),
        isScrollControlled: true,
    );
  }

  void onDataChanged(dynamic val) {
    if(validateFormOnDataChange) {
      formKey.currentState?.validate();
    }
  }

  void toggleSavingForm() {
    isSavingForm = !isSavingForm;
    update();
  }

  void onListItemReorder(int oldIndex, int newIndex) {
    if (oldIndex <= newIndex) {
      newIndex -= 1;
    }
    if(oldIndex == newIndex) return;

    service.reorderItem(oldIndex, newIndex);
    update();
  }
}