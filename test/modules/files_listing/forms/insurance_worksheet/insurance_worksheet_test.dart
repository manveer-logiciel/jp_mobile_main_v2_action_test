import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/modules/files_listing/forms/insurance/controller.dart';

void main() {

  InsuranceFormController controller = InsuranceFormController();

    List<SheetLineItemModel> insuranceItem = [];

  void addInsuranceItem(){
    for(int i=0; i<3; i++) {
      insuranceItem.add(SheetLineItemModel(
        productId: i.toString(), title: 'Product($i)', price: i.toString(), qty: i.toString(), totalPrice: (i*i).toString()));
    }
  }
  
  setUpAll(() {
    controller.init();
  });


  group('InsuranceFormController@onListItemReorder() should check reorder of list item', () {
    addInsuranceItem();

    test('When list item is reordered', () {
      controller.service.insuranceItems = insuranceItem;
      final beforeReorderFirstItem = controller.service.insuranceItems.first.productId;
      controller.onListItemReorder(0, 2);
      final afterReorderFirstItem = controller.service.insuranceItems.first.productId;
      expect(beforeReorderFirstItem == afterReorderFirstItem, isFalse);
    });

    test('When list item is not reordered', () {
      final beforeReorderFirstItem = controller.service.insuranceItems.first.productId;
      controller.onListItemReorder(0, 1);
      final afterReorderFirstItem = controller.service.insuranceItems.first.productId;
      expect(beforeReorderFirstItem == afterReorderFirstItem, isTrue);
    });
  });  
}