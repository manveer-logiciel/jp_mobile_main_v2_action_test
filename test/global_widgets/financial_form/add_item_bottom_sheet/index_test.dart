import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/global_widgets/financial_form/add_item_bottom_sheet/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {
  AddItemBottomSheetController controller = AddItemBottomSheetController();

  SheetLineItemModel tempItem = SheetLineItemModel(
      pageType: AddLineItemFormType.changeOrderForm,
      currentIndex: 1,
      productId: "321",
      title: "Title - 1 ",
      price: "10",
      qty: "5",
      totalPrice: "50",
      tradeType: JPSingleSelectModel(id: "1", label: "Trade - 1"),
      workType: JPSingleSelectModel(id: "5", label: "Work Type - 1"),
      isTaxable: true,
      productCategorySlug: null
  );

  setUpAll(() {
    controller.init();
  });

  test('In case of add item, AddItemBottomSheetController should be initialized with correct values', () {
    controller = AddItemBottomSheetController(
      pageType: AddLineItemFormType.changeOrderForm,
      isDefaultTaxable: true,
      sheetLineItemModel: null
    );
    controller.init();
    expect(controller.validateFormOnDataChange, false);
    expect(controller.isDefaultTaxable, true);
    expect(controller.sheetLineItemModel != null, false);
    expect(controller.pageType, AddLineItemFormType.changeOrderForm);
    expect(controller.getTitle, 'add_item'.tr.toUpperCase());
  });


  test('In case of edit item, AddItemBottomSheetController should be initialized with correct values', () {
    controller.pageType = AddLineItemFormType.changeOrderForm;
    controller.sheetLineItemModel = tempItem;
    controller.init();
    expect(controller.validateFormOnDataChange, false);
    expect(controller.isDefaultTaxable, true);
    expect(controller.sheetLineItemModel != null, true);
    expect(controller.pageType, AddLineItemFormType.changeOrderForm);
    expect(controller.getTitle, 'edit_item'.tr.toUpperCase());
  });
}