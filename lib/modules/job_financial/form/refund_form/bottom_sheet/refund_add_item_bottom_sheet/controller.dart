import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/financial_product_search/financial_product_search.dart';
import 'package:jp_mobile_flutter_ui/InputBox/controller.dart';

import '../../../../../../common/enums/sheet_line_item_type.dart';
import '../../../../../../common/models/financial_product/financial_product_model.dart';
import '../../../../../../common/models/sheet_line_item/sheet_line_item_model.dart';
import '../../../../../../core/constants/navigation_parms_constants.dart';
import '../../../../../../core/utils/form/validators.dart';
import '../../../../../../routes/pages.dart';

class RefundAddItemController extends GetxController {
  final GlobalKey<FormState> itemFormKey = GlobalKey();

  JPInputBoxController activityController = JPInputBoxController();
  JPInputBoxController priceController = JPInputBoxController();
  JPInputBoxController qtyController = JPInputBoxController();
  JPInputBoxController totalPriceController = JPInputBoxController();

  double itemTotalPrice = 0.00;

  String productId = '';

  bool validateItemFormOnDataChange = false;

  RefundAddItemController({SheetLineItemModel? item}) {
    if(item != null) {
      setRefundItemData(item);
    }
  }

  bool validateItemForm() => itemFormKey.currentState?.validate() ?? false;

  Future<void> openFinancialProductSearch() async {
    final result =  await Get.toNamed(Routes.financialProductSearch,arguments: {
      NavigationParams.filterParams : FinancialProductSearchModel(name: activityController.text.toString())
    });
    if(result != null) {
      saveRefundItemValues(result);
      if(validateItemFormOnDataChange) {
        validateItemForm();
      }
      update();
    }
  }

  String? validateActivityTitle(dynamic val) {
    return FormValidator.requiredFieldValidator(val,
        errorMsg: 'activity_is_required'.tr);
  }

  void onChangePriceOrQty() {
    double price = 0.0;
    double qty = 0.0;
    if(priceController.text != '.' && priceController.text.isNotEmpty) {
      price = double.tryParse(priceController.text.toString()) ?? 0;
    }
    if(qtyController.text != '.' && qtyController.text.isNotEmpty) {
      qty = double.parse(qtyController.text.toString());
    }
    itemTotalPrice = price * qty;
  }

  void setRefundItemData(SheetLineItemModel item) {
    productId = item.productId!;
    activityController.text = item.title!;
    priceController.text = item.price!;
    qtyController.text = item.qty!;
    itemTotalPrice = double.parse(item.totalPrice!);
  }

  void scrollToErrorField() {
    if(activityController.text.isEmpty) {
      activityController.scrollAndFocus();
    } else if(FormValidator.validatePrice(priceController.text) != null) {
      priceController.scrollAndFocus();
    } else if(FormValidator.validateQty(qtyController.text) != null) {
      qtyController.scrollAndFocus();
    }
  }

  void saveRefundItemValues(FinancialProductModel financialProductModel) {
    productId = financialProductModel.id == null ? '' : financialProductModel.id.toString();
    activityController.text = financialProductModel.name.toString();

    if((financialProductModel.sellingPrice ?? '').isNotEmpty) {
      priceController.text = financialProductModel.sellingPrice!;
    }
    onChangePriceOrQty();
  }

  void addUpdateRefundItem(SheetLineItemModel? refundItemModel, Function(SheetLineItemModel itemModel, bool isUpdate) onAddUpdate) {
    validateItemFormOnDataChange = true;
    if(validateItemForm()) {
      itemFormKey.currentState?.save();

      bool isUpdate = refundItemModel != null;

      if(isUpdate) {
        refundItemModel.productId = productId;
        refundItemModel.title = activityController.text;
        refundItemModel.price = num.parse(priceController.text).toString() ;
        refundItemModel.qty = double.parse(qtyController.text).toString();
        refundItemModel.totalPrice = itemTotalPrice.toString();
      } else {
        refundItemModel = SheetLineItemModel(
          pageType: AddLineItemFormType.refundForm,
            productId: productId,
            title: activityController.text,
            price: num.parse(priceController.text).toString(),
            qty: num.parse(qtyController.text).toString(),
            totalPrice: itemTotalPrice.toString(),
        );
      }
      onAddUpdate.call(refundItemModel, isUpdate);
    } else {
      scrollToErrorField();
    }
  }

  void onItemDataChanged(dynamic val) {
    if (validateItemFormOnDataChange) {
      validateItemForm();
    }
    onChangePriceOrQty();
    update();
  }
}