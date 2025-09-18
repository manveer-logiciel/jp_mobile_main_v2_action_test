import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/models/suppliers/beacon/account.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/models/sheet_line_item/sheet_line_item_model.dart';
import '../../../common/services/job_financial/forms/add_item_bottom_sheet/add_item_bottom_sheet.dart';
import '../../../core/utils/helpers.dart';

class AddItemBottomSheetController extends GetxController {

  AddItemBottomSheetController({
    this.pageType = AddLineItemFormType.refundForm,
    this.sheetLineItemModel,
    this.isDefaultTaxable = true,
    this.categoryId,
    this.srsBranchCode,
    this.shipToSequenceId,
    this.beaconAccount,
    this.beaconBranchCode,
    this.beaconJobNumber,
    this.forSupplierId,
    this.abcBranchCode,
    this.supplierAccountId
  });

  final GlobalKey<FormState> formKey = GlobalKey();

  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing

  late AddItemBottomSheetService service;

  final String? categoryId;
  final String? srsBranchCode;
  final String? shipToSequenceId;
  final String? beaconBranchCode;
  final String? beaconJobNumber;
  final int? forSupplierId;
  final BeaconAccountModel? beaconAccount;

  SheetLineItemModel? sheetLineItemModel;
  AddLineItemFormType pageType;

  bool validateFormOnDataChange = false;
  bool isDefaultTaxable = true;

  final String? abcBranchCode;
  final String? supplierAccountId;

  get getTitle => service.sheetLineItemModel?.title?.trim().isEmpty ?? true
      ? 'add_item'.tr.toUpperCase() : 'edit_item'.tr.toUpperCase();

  @override
  Future<void> onInit() async {
    super.onInit();
    await init();
  }

  Future<void> init() async {

    /////   setting up service    /////
    service = AddItemBottomSheetService(
      update: update,
      validateForm: () => onDataChanged(''),
      pageType: pageType,
      sheetLineItemModel: sheetLineItemModel,
      isDefaultTaxable: isDefaultTaxable,
      categoryId: categoryId,
      srsBranchCode: srsBranchCode,
      shipToSequenceId: shipToSequenceId,
      beaconBranchCode: beaconBranchCode,
      beaconJobNumber: beaconJobNumber,
      forSupplierId: forSupplierId,
      beaconAccount: beaconAccount,
      abcBranchCode: abcBranchCode,
      supplierAccountId: supplierAccountId
    );

    service.controller = this;
    await service.initForm(); // setting up form data
  }

  //////////////////////////     SELECT ACTIVITY     ///////////////////////////

  void selectActivity() => service.selectActivity();

  ///////////////////////////     SAVE ITEM     //////////////////////////

  void onItemDataChanged(dynamic val) {
    if (validateFormOnDataChange) {
      validateForm();
    }
    service.onChangePriceOrQty();
  }

  /////////////////////////     UPDATE CHANGE ORDER    /////////////////////////

  void addUpdateItem(Function(SheetLineItemModel p1)? onSave) {

    validateFormOnDataChange = true; // setting up form validation as soon as user updates field data
    if (validateForm()) {
      saveForm(onSave: onSave);
    } else {
      service.scrollToErrorField();
    }
  }

  ////////////////////////////    FORM VALIDATION    ///////////////////////////

  /////   onDataChanged() : will validate form as soon as data in input field changes   /////
  void onDataChanged(dynamic val) {
    // realtime changes will take place only once after user tried to submit form
    if (validateFormOnDataChange) {
      validateForm();
    }
  }

  bool validateForm() => formKey.currentState?.validate() ?? false;

  //////////////////////////////////////////////////////////////////////////////

  Future<void> saveForm({Function(SheetLineItemModel p1)? onSave}) async {

    bool isNewDataAdded = service.checkIfNewDataAdded(); // checking for changes

    if(!isNewDataAdded) {
      Helper.showToastMessage('no_changes_made'.tr);
    } else {
      await service.saveForm(onSave: onSave);
    }
  }

}