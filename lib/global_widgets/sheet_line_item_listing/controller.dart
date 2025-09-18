import 'package:get/get.dart';

import '../../common/models/sheet_line_item/sheet_line_item_model.dart';

class SheetLineItemListingController extends GetxController {

  int count = 0;
  final List<SheetLineItemModel>? items;

  SheetLineItemListingController({this.items}) {
    init();
  }

  void init() {
    count = 0;
    if(items?.isNotEmpty ?? false) {
      items?.forEach((element) => count = (element.isTaxable ?? false) ? count + 1 : count);
      update();
    }
  }

  bool get getIsTaxable => count != items?.length;

  void didUpdateWidget() => init();

}