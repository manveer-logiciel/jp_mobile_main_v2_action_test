import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/InputBox/controller.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';

import '../../../../../common/enums/sheet_line_item_type.dart';
import '../../../../../common/models/sheet_line_item/sheet_line_item_model.dart';
import '../../../../../common/services/forms/value_selector.dart';
import '../../../../../core/constants/common_constants.dart';
import '../../../../../core/utils/form/validators.dart';

class BillAddItemController extends GetxController {
  final GlobalKey<FormState> itemFormKey = GlobalKey();

  JPInputBoxController descriptionController = JPInputBoxController();
  JPInputBoxController priceController = JPInputBoxController();
  JPInputBoxController qtyController = JPInputBoxController();
  JPInputBoxController accountingHeadController = JPInputBoxController();

  List<JPSingleSelectModel> accountingHeads = [];

  bool validateItemFormOnDataChange = false;

  double itemTotalPrice = 0.0;

  JPSingleSelectModel selectAccountingHead = JPSingleSelectModel(label: '', id: CommonConstants.noneId);

  BillAddItemController(this.accountingHeads, {SheetLineItemModel? item}) {
    if(item != null) {
      setBillAddItemData(item);
    }
  }

  void setBillAddItemData(SheetLineItemModel item) {
    selectAccountingHead = item.accountingHeadModel!;
    accountingHeadController.text = selectAccountingHead.label;
    descriptionController.text = item.title!;
    priceController.text = item.price!;
    qtyController.text = item.qty!;
    itemTotalPrice = double.parse(item.totalPrice!);
  }

  bool validateItemForm() => itemFormKey.currentState?.validate() ?? false;

  void addUpdateBillItem(SheetLineItemModel? billItemModel, Function(SheetLineItemModel billItemModel, bool isUpdate) onAddUpdate) {
    validateItemFormOnDataChange = true;
    if(validateItemForm()) {
      itemFormKey.currentState?.save();
      final bool isUpdate = billItemModel != null;

      if(!isUpdate) {
       billItemModel = SheetLineItemModel(
         pageType: AddLineItemFormType.billForm,
           productId: selectAccountingHead.id,
           title: descriptionController.text,
           price: num.parse(priceController.text).toString(),
           qty: num.parse(qtyController.text).toString(),
           totalPrice: itemTotalPrice.toString(),
           accountingHeadModel: selectAccountingHead,
       );
      } else {
        billItemModel.productId = selectAccountingHead.id;
        billItemModel.title = descriptionController.text;
        billItemModel.price =  num.parse(priceController.text).toString();
        billItemModel.qty =  num.parse(qtyController.text).toString();
        billItemModel.totalPrice = itemTotalPrice.toString();
        billItemModel.accountingHeadModel = selectAccountingHead;
      }

      onAddUpdate.call(billItemModel, isUpdate);

    } else {
      scrollToErrorField();
    }
    update();
  }

  void scrollToErrorField() {
    if(FormValidator.requiredFieldValidator(accountingHeadController.text) != null) {
      accountingHeadController.scrollAndFocus();
    } else if(FormValidator.validatePrice(priceController.text) != null) {
      priceController.scrollAndFocus();
    } else if(FormValidator.validateQty(qtyController.text) != null) {
      qtyController.scrollAndFocus();
    }
  }

  void openAccountingHead() {
    FormValueSelectorService.openAccountingHeadSingleSelect(
        title: 'select_accounting_head'.tr,
        list: accountingHeads,
        controller: accountingHeadController,
        selectedItemId: selectAccountingHead.id,
        onValueSelected: (val) async {
          setSelectedAccountingHead(val);
          await Future<void>.delayed(const Duration(milliseconds: 200));
          onItemDataChanged('');
        });
  }

  void setSelectedAccountingHead(String id) {
    selectAccountingHead = accountingHeads.firstWhereOrNull((element) => element.id == id)!;
  }

  String? validateAccountingHead(dynamic val) {
    return FormValidator.requiredFieldValidator(
        val,
        errorMsg: 'accounting_head_is_required'.tr);
  }

  void onItemDataChanged(dynamic val) {
    if (validateItemFormOnDataChange) {
      validateItemForm();
    }
    if(val.toString().isNotEmpty) {
      onChangePriceOrQty();
    }
    update();
  }

  void onChangePriceOrQty() {
    double price = 0.0;
    double qty = 0.0;
    if(priceController.text != '.' && priceController.text.isNotEmpty) {
      price = double.tryParse(priceController.text) ?? 0;
    }
    if(qtyController.text != '.' && qtyController.text.isNotEmpty) {
      qty = double.parse(qtyController.text);
    }
    itemTotalPrice = price * qty;
  }
}