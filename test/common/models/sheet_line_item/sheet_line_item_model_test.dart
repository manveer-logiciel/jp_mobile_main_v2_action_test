import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';

void main() {

  SheetLineItemModel model = SheetLineItemModel(
    productId: '',
    title: '',
    price: '',
    qty: '',
    totalPrice: '',
    unit: '0',
    unitCost: '',
    emptyTier: true,
  );

  test("Empty line item should be created, with correct values", () {
    final emptyLineItem = model.emptyTierItem;
    expect(emptyLineItem.productId, '');
    expect(emptyLineItem.title, '');
    expect(emptyLineItem.price, '');
    expect(emptyLineItem.qty, '');
    expect(emptyLineItem.totalPrice, '');
    expect(emptyLineItem.unit, '0');
    expect(emptyLineItem.unitCost, '');
    expect(emptyLineItem.emptyTier, true);
    expect(emptyLineItem.product?.id, 0);
    expect(emptyLineItem.product?.categoryId, 0);
  });
}