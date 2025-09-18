import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/services/job_financial/forms/add_item_bottom_sheet/add_item_bottom_sheet.dart';
import 'package:jobprogress/global_widgets/financial_form/add_item_bottom_sheet/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {

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

  List<JPSingleSelectModel> tempTradesList = [
    JPSingleSelectModel(id: "1", label: "Trade 1", additionalData: [
      JPSingleSelectModel(id: "10", label: "Work Type 1"),
      JPSingleSelectModel(id: "11", label: "Work Type 2")]),
    JPSingleSelectModel(id: "2", label: "Trade 2", additionalData: [JPSingleSelectModel(id: "12", label: "Work Type 3")]),
    JPSingleSelectModel(id: "3", label: "Trade 3", additionalData: [
      JPSingleSelectModel(id: "13", label: "Work Type 4"),
      JPSingleSelectModel(id: "14", label: "Work Type 5"),
      JPSingleSelectModel(id: "15", label: "Work Type 6")]),
    // ignore: inference_failure_on_collection_literal
    JPSingleSelectModel(id: "4", label: "Trade 4", additionalData: []),
  ];

  late Map<String, dynamic> tempInitialJson;

  group('In case of add item', () {
    AddItemBottomSheetService service = AddItemBottomSheetService(
      update: () {},
      validateForm: () {},
      pageType: AddLineItemFormType.changeOrderForm,
      sheetLineItemModel: null,
      isDefaultTaxable: true
    );

    setUpAll(() {
      service.controller = AddItemBottomSheetController();
      service.tradesList = tempTradesList;
      service.initFormData();
      tempInitialJson = service.addItemFormJson();
    });

    group('AddItemBottomSheetService should be initialized with correct value', () {
      test('Form data helpers should be initialized with correct values', () {
        service.initFormData();
        tempInitialJson = service.addItemFormJson();
        expect(service.pageType, AddLineItemFormType.changeOrderForm);
        expect(service.sheetLineItemModel != null, false);
        expect(service.selectedTrade != null, false);
        expect(service.selectedWorkType != null, false);
        expect(service.selectedActivityProduct != null, false);
        expect(service.selectedTrade != null, false);
        expect(service.tradesList.isEmpty, false);
        expect(service.workTypeList.isEmpty, true);
      });

      test('Form fields should be initialized with correct values', () {
        expect(service.activityController.text, "");
        expect(service.tradeController.text, "");
        expect(service.workTypeController.text, "");
        expect(service.priceController.text, "");
        expect(service.qtyController.text, "");
      });

      test('Form tax helpers should be initialized with correct values', () {
        expect(service.isDefaultTaxable, true);
        expect(service.isDefaultTaxableCopy, true);
        expect(service.isTaxable, true);
      });

      test('AddItemBottomSheetService@calculateItemsPrice should get initialized item price', () {
        service.calculatePriceChange();
        expect(service.priceController.text, "");
        expect(service.qtyController.text, "");
        expect(service.itemTotalPrice, 0);
      });
    });

    group('AddItemBottomSheetService@checkIfNewDataAdded() should check if any addition/update is made in form', () {
      JPSingleSelectModel? initialSelectedTrade;
      test('When no changes in form are made', () {
        final val = service.checkIfNewDataAdded();
        expect(val, false);
      });

      test('When changes in form are made', () {
        service.selectedTrade = tempTradesList[0];
        final val = service.checkIfNewDataAdded();
        expect(val, true);
      });

      test('When changes are reverted', () {
        service.selectedTrade = initialSelectedTrade;
        final val = service.checkIfNewDataAdded();
        expect(val, false);
      });
    });

    group('AddItemBottomSheetService@getDataFromTrade should change selected trade and update work type list', () {
      test('should not select any trade and should not contain any work type item when there is wrong selection of trade', () {
        service.getDataFromTrade("7");
        expect(service.selectedTrade != null, false);
        expect(service.tradeController.text, "");
        expect(service.workTypeList.isNotEmpty, false);
      });
      test('should select the selected trade and should not contain any work type item when there no work type for the selected trade', () {
        service.getDataFromTrade(tempTradesList[3].id);
        expect(service.selectedTrade != null, true);
        expect(service.tradeController.text, tempTradesList[3].label);
        expect(service.workTypeList.isNotEmpty, false);
      });
      test('should select the selected trade and should contain work type items', () {
        service.getDataFromTrade(tempTradesList[2].id);
        expect(service.selectedTrade != null, true);
        expect(service.tradeController.text, tempTradesList[2].label);
        expect(service.workTypeList.isNotEmpty, true);
      });
    });

    group('AddItemBottomSheetService@updateWorkType should change order change selected work type', () {
      test('should not select any work type when there is wrong selection of work type', () {
        service.updateWorkType("20");
        expect(service.selectedWorkType != null, false);
        expect(service.workTypeController.text, "");
      });
      test('should select the selected work type', () {
        service.updateWorkType(tempTradesList[2].additionalData[1].id);
        expect(service.selectedWorkType != null, true);
        expect(service.workTypeController.text, tempTradesList[2].additionalData[1].label);
      });
    });

    group('AddItemBottomSheetService@calculatePriceChange should calculate the total price of the item', () {
      test('should not calculate some value when there is quantity field data is missing', () {
        service.priceController.text = "15";
        service.qtyController.text = "";
        service.calculatePriceChange();
        expect(service.itemTotalPrice, 0);
      });
      test('should not calculate some value when there is price field data is missing', () {
        service.priceController.text = "";
        service.qtyController.text = "5";
        service.calculatePriceChange();
        expect(service.itemTotalPrice, 0);
      });
      test('should calculate when both price & quantity are valid', () {
        service.priceController.text = "15";
        service.qtyController.text = "5";
        service.calculatePriceChange();
        expect(service.itemTotalPrice, 75);
      });
    });

    group('AddItemBottomSheetService@toggleIsTaxable should update is item tax able or not', () {
      test('Initially it should be based as or the job is taxable or not', () {
        service.isTaxable = service.isDefaultTaxable;
        expect(service.isTaxable, true);
      });
      test('should not calculate some value when there is price field data is missing', () {
        service.toggleIsTaxable(false);
        expect(service.isTaxable, false);
      });
      test('should calculate some value when there is some value in price and quantity field', () {
        service.toggleIsTaxable(true);
        expect(service.isTaxable, true);
      });
    });

  });

  group('In case of Edit item', () {

    AddItemBottomSheetService service = AddItemBottomSheetService(
        update: () {},
        validateForm: () {},
        pageType: AddLineItemFormType.changeOrderForm,
        sheetLineItemModel: tempItem,
        isDefaultTaxable: true
    );

    setUpAll(() {
      service.controller = AddItemBottomSheetController();
      service.tradesList = tempTradesList;
    });

    group('AddItemBottomSheetService should be initialized with current value', () {
      test('Form data helpers should be initialized with correct values', () {
        service.sheetLineItemModel = tempItem;
        service.initFormData();
        tempInitialJson = service.addItemFormJson();
        expect(service.pageType, AddLineItemFormType.changeOrderForm);
        expect(service.sheetLineItemModel != null, true);
        expect(service.selectedTrade != null, true);
        expect(service.selectedWorkType != null, true);
        expect(service.selectedActivityProduct != null, true);
        expect(service.selectedTrade != null, true);
        expect(service.tradesList.isEmpty, false);
        expect(service.workTypeList.isEmpty, false);
      });

      test('Form tax helpers should be initialized with correct values', () {
        expect(service.isDefaultTaxable, true);
        expect(service.isDefaultTaxableCopy, true);
        expect(service.isTaxable, true);
      });

      test('Form fields should be initialized with correct values', () {
        expect(service.activityController.text, "Title - 1 ");
        expect(service.tradeController.text, "Trade 1");
        expect(service.workTypeController.text, "Work Type - 1");
        expect(service.priceController.text, "10");
        expect(service.qtyController.text, "5");
      });

      test('AddItemBottomSheetService@calculateItemsPrice should get initialized item price', () {
        service.calculatePriceChange();
        expect(service.priceController.text, "10");
        expect(service.qtyController.text, "5");
        expect(service.itemTotalPrice, 50);
      });

      test('InvoiceFormService@setFormData() should set-up form values', () {
        service.initFormData();
        expect(service.initialJson, tempInitialJson);
      });
    });
  });
}