import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/enums/unsaved_resource_type.dart';
import 'package:jobprogress/common/enums/worksheet.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/common/models/files_listing/linked_material.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_model.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_price.dart';
import 'package:jobprogress/common/models/financial_product/variants_model.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement.dart';
import 'package:jobprogress/common/models/forms/worksheet/supplier_form_params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/common/models/macros/index.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/suppliers/beacon/account.dart';
import 'package:jobprogress/common/models/suppliers/beacon/job.dart';
import 'package:jobprogress/common/models/suppliers/branch.dart';
import 'package:jobprogress/common/models/suppliers/srs/srs_ship_to_address.dart';
import 'package:jobprogress/common/models/suppliers/suppliers.dart';
import 'package:jobprogress/common/models/worksheet/amounts.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/models/worksheet/settings/trade_type_default.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_detail_category_model.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_worksheet.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';
import 'package:jobprogress/core/constants/financial_constants.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';
import 'models/mocked_responses.dart';

void main() {

  SheetLineItemModel lineItem = SheetLineItemModel(
    productId: '1',
    title: 'Test',
    price: '100',
    qty: '2',
    totalPrice: '200',
  );

  SheetLineItemModel lineItem2 = SheetLineItemModel(
    productId: '1',
    title: 'Test',
    price: '100',
    qty: '2',
    totalPrice: '200',
  );

  SheetLineItemModel lineItem3 = SheetLineItemModel(
    productId: '1',
    title: 'Test',
    price: '100',
    qty: '2',
    totalPrice: '200',
  );

  SheetLineItemModel lineItem4 = SheetLineItemModel(
    price: '10', 
    productId: '1', 
    productCode: '12',
    qty: '',
    title: '', 
    totalPrice: '',
  );

  SheetLineItemModel tier1 = SheetLineItemModel.tier(
    title: 'Test 1',
    totalPrice: '200',
    tier: 1,
    workSheetSettings: WorksheetSettingModel(),
  );

  SheetLineItemModel tier2 = SheetLineItemModel.tier(
    title: 'Test 2',
    totalPrice: '200',
    tier: 2,
    workSheetSettings: WorksheetSettingModel(),
  );

  SheetLineItemModel tier3 = SheetLineItemModel.tier(
    title: 'Test 2',
    totalPrice: '200',
    tier: 3,
    workSheetSettings: WorksheetSettingModel(),
  );
      
  Map<String, FinancialProductPrice> productsPriceJson = {
    'productCode': FinancialProductPrice(
    ),
  };
  List<String> deletedProductIds = [];

  Map<String, FinancialProductModel> productsJson = {
    '12': FinancialProductModel(),
  };

  MacroListingModel macroItem = MacroListingModel(
    tradeId: 1,
    fixedPrice: 100,
    details: [
      tier1,
      tier2
    ],
  );

  FinancialProductModel financialProductModel = FinancialProductModel(
    id: 1,
    name: 'Sample Product',
    sellingPrice: '50.0',
    productCategory: WorksheetDetailCategoryModel(),
    supplier: SuppliersModel(),
    supplierId: 1001,
    unit: 'Unit',
    unitCost: '30.0',
    description: 'Product Description',
  );

  WorksheetFormService service = WorksheetFormService(
      hidePriceDialog: false,
      update: () {},
      worksheetType: WorksheetConstants.estimate,
      formType: WorksheetFormType.add,
  );

  WorksheetSettingModel settings = WorksheetSettingModel.fromJson({});

  WorksheetModel worksheet = WorksheetModel(
      id: 5,
      name: 'Test',
      materialTaxRate: '5',
      laborTaxRate: '5',
      taxRate: '5',
      overhead: '5',
      discount: '5',
      processingFee: '5'
  );

  JobModel jobModel = JobModel(id: 5, customerId: 1);

  WorksheetAmounts amounts = WorksheetAmounts(
    materialTax: 10,
    laborTax: 10,
    taxAll: 10,
  );

  List<JPSingleSelectModel> taxList = [
    JPSingleSelectModel(id: '1', label: 'Tax 1', additionalData: 5),
    JPSingleSelectModel(id: '2', label: 'Tax 1', additionalData: 2),
  ];

  final List<SheetLineItemModel> items = [
    SheetLineItemModel(
        title: 'Title',
        price: '',
        qty: '1',
        totalPrice: '1.0',
        product: FinancialProductModel(),
        productId: '1'
    )
  ];

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    RunModeService.setRunMode(RunMode.unitTesting);
    Get.testMode = true;
  });

  group("In case of add worksheet", () {
    group("WorksheetFormService should be initialized properly", () {
      test("Worksheet data value holders should be properly initialized", () {
        expect(service.jobId, isNull);
        expect(service.measurementId, isNull);
        expect(service.worksheetId, isNull);
        expect(service.dbUnsavedResourceId, isNull);
        expect(service.note, isEmpty);
        expect(service.selectedDivisionId, isEmpty);
      });

      test("Worksheet toggles should be properly initialized", () {
        expect(service.isSavedOnTheGo, false);
        expect(service.isSavingForm, false);
        expect(service.isLoading, true);
        expect(service.selectedFromFavourite, false);
        expect(service.isSRSEnable, false);
        expect(service.isColorAdded, false);
        expect(service.isDBResourceIdFromController, false);
      });

      test("Worksheet lists should be properly initialized", () {
        expect(service.allCategories, isEmpty);
        expect(service.allSuppliers, isEmpty);
        expect(service.allDivisions, isEmpty);
        expect(service.allTrades, isEmpty);
        expect(service.allTax, isEmpty);
        expect(service.lineItems, isEmpty);
        expect(service.allTiers, isEmpty);
        expect(service.attachments, isEmpty);
        expect(service.uploadedAttachments, isEmpty);
        expect(service.companyTemplates, isEmpty);
      });

      test("Worksheet controllers should be properly initialized", () {
        expect(service.titleController.text, isEmpty);
        expect(service.divisionController.text, isEmpty);
      });

      test("Worksheet additional data should be properly initialized", () {
        expect(service.selectedSrsShipToAddress, isNull);
        expect(service.selectedSrsBranch, isNull);
        expect(service.worksheetMeasurement, isNull);
        expect(service.settings, isNull);
        expect(service.workSheet, isNull);
        expect(service.job, isNull);
        expect(service.flModule, isNull);
      });

      test("Worksheet json holders should be properly initialized", () {
        expect(service.settingsJson, isNull);
        expect(service.initialJson, isEmpty);
        expect(service.unsavedResourceJson, isNull);
      });
    });

    group("Worksheet getters should give correct value", () {
      group("WorksheetFormService@hasTiers should decide whether worksheet has tiers or not", () {
        test("Value should be false when there are no tiers", () {
          service.lineItems.clear();
          expect(service.hasTiers, isFalse);
        });

        test("Value should be false when there are line items only", () {
          service.lineItems = [lineItem, lineItem2];
          expect(service.hasTiers, isFalse);
        });

        test("Value should be true when there are tiers", () {
          service.lineItems = [tier1];
          expect(service.hasTiers, isTrue);
        });

        test("Value should be true when there are tiers with items", () {
          service.lineItems = [tier1..subItems = [lineItem]];
          expect(service.hasTiers, isTrue);
        });
      });

      group("WorksheetFormService@isEditForm should decide whether worksheet is edit form or not", () {

        test("Value should be true when worksheet saved", () {
          service.worksheetId = 5;
          expect(service.isEditForm, isTrue);
          service.worksheetId = null;
        });

        test("Value should be true when worksheet is opened in edit mode", () {
          service.formType = WorksheetFormType.edit;
          expect(service.isEditForm, isTrue);
        });

        test("Value should be false when worksheet is opened in add mode", () {
          service.formType = WorksheetFormType.add;
          expect(service.isEditForm, isFalse);
        });
      });

      group("WorksheetFormService@isUnsavedForm should decide whether worksheet is opened from auto saved file", () {
        test("Value should be true when worksheet is opened from auto saved file", () {
          service.dbUnsavedResourceId = 5;
          expect(service.isUnsavedForm, isTrue);
        });

        test("Value should be false when worksheet is opened in normal mode", () {
          service.dbUnsavedResourceId = null;
          expect(service.isUnsavedForm, isFalse);
        });
      });
    });

    group("WorksheetFormService@worksheetJson should generate worksheet json properly", () {
      setUp(() {
        service.settings = settings;
      });

      group("[id] should be added conditionally", () {
        setUp(() {
          service.settings = settings;
        });

        test("[id] should be added when editing worksheet", () {
          service.workSheet = worksheet;
          final result = service.worksheetJson([]);
          expect(result["id"], equals(worksheet.id));
        });

        test("[id] should not be added when adding worksheet", () {
          service.workSheet = null;
          final result = service.worksheetJson([]);
          expect(result["id"], isNull);
        });

        test("[id] should not be added when creating new worksheet", () {
          service.workSheet = null;
          service.formType = WorksheetFormType.add;
          final result = service.worksheetJson([], name: 'ABC');
          expect(result["id"], isNull);
        });
      });

      test("[job_id] should be added correctly", () {
        service.jobId = jobModel.id;
        final result = service.worksheetJson([]);
        expect(result["job_id"], equals(jobModel.id));
      });

      test("[type] should be added correctly", () {
        service.worksheetType = WorksheetConstants.estimate;
        final result = service.worksheetJson([]);
        expect(result["type"], equals(WorksheetConstants.estimate));
      });

      group("[title] should be added conditionally", () {
        test("[title] should be added when title is not empty", () {
          service.titleController.text = 'ABC';
          final result = service.worksheetJson([]);
          expect(result["title"], equals('ABC'));
        });

        test("[title] should not be added when title is empty", () {
          service.titleController.text = '';
          final result = service.worksheetJson([]);
          expect(result["title"], isNull);
        });
      });

      group("[note] should be added conditionally", () {
        test("[note] should be added when note is not empty", () {
          service.note = 'ABC';
          final result = service.worksheetJson([]);
          expect(result["note"], equals('ABC'));
        });

        test("[note] should not be added when note is empty", () {
          service.note = '';
          final result = service.worksheetJson([]);
          expect(result["note"], isNull);
        });
      });

      test("[division_id] should be added correctly", () {
        service.selectedDivisionId = "1";
        final result = service.worksheetJson([]);
        expect(result["division_id"], equals("1"));
      });

      test('[re_calculate] should always be zero', () {
        final result = service.worksheetJson([]);
        expect(result["re_calculate"], equals("0"));
      });

      group("[name] should be added correctly", () {
        test("[name] in case of edit should be user from worksheet name", () {
          service.workSheet = worksheet;
          final result = service.worksheetJson([]);
          expect(result["name"], equals(worksheet.name));
        });

        test("[name] in case of add should be user input name", () {
          service.workSheet = null;
          final result = service.worksheetJson([], name: 'ABC');
          expect(result["name"], equals('ABC'));
        });
      });

      group("[is_qbd_worksheet] should be set correctly", () {
        test("[is_qbd_worksheet] should be set to true when worksheet type is qbd", () {
          service.workSheet = worksheet..isQbdWorksheet = true;
          final result = service.worksheetJson([]);
          expect(result["is_qbd_worksheet"], 1);
        });

        test("[is_qbd_worksheet] should be set to false when worksheet type is not qbd", () {
          service.workSheet = worksheet..isQbdWorksheet = false;
          final result = service.worksheetJson([]);
          expect(result["is_qbd_worksheet"], 0);
        });
      });

      test("[is_mobile] should always be equal to 1", () {
        final result = service.worksheetJson([]);
        expect(result["is_mobile"], 1);
      });

      group("[measurement_id] should be set correctly", () {
        test("[measurement_id] should be set when worksheet has measurement", () {
          service.worksheetMeasurement = MeasurementModel(id: 1);
          final result = service.worksheetJson([]);
          expect(result["measurement_id"], 1);
        });

        test("[measurement_id] should not be set when worksheet has no measurement", () {
          service.worksheetMeasurement = null;
          final result = service.worksheetJson([]);
          expect(result["measurement_id"], isNull);
        });
      });

      group("Material Tas should be added correctly", () {
        test("[material_tax_rate] should be empty is material can't be applied", () {
          service.settings?.applyTaxMaterial = false;
          final result = service.worksheetJson([]);
          expect(result["material_tax_rate"], isEmpty);
        });

        test("[material_tax_rate] should be filled with rate if can be applied", () {
          service.settings?.applyTaxMaterial = true;
          service.settings?.materialTaxRate = 5;
          final result = service.worksheetJson([]);
          expect(result["material_tax_rate"], 5);
        });

        test("[material_tax_amount] should be not exist if material tax can't be applied", () {
          service.settings?.applyTaxMaterial = false;
          service.calculatedAmounts = amounts;
          final result = service.worksheetJson([]);
          expect(result["material_tax_amount"], isNull);
        });

        test("[material_tax_amount] should be filled with calculated amount", () {
          service.settings?.applyTaxMaterial = true;
          service.calculatedAmounts = amounts;
          final result = service.worksheetJson([]);
          expect(result["material_tax_amount"], amounts.materialTax);
        });

        test("[material_custom_tax_id] should be not exist if material tax can't be applied", () {
          service.settings?.applyTaxMaterial = false;
          final result = service.worksheetJson([]);
          expect(result["material_custom_tax_id"], isNull);
        });

        test("[material_custom_tax_id] should be filled with custom tax id if material tax can be applied", () {
          service.settings?.applyTaxMaterial = true;
          service.settings?.selectedMaterialTaxRateId = '1';
          final result = service.worksheetJson([]);
          expect(result["material_custom_tax_id"], '1');
        });
      });

      group('Labor tax should be added correctly', () {
        test("[labor_tax_rate] should be filled with rate if can be applied", () {
          service.settings?.applyTaxLabor = true;
          service.settings?.laborTaxRate = 5;
          final result = service.worksheetJson([]);
          expect(result["labor_tax_rate"], 5);
        });

        test("[labor_tax_amount] should be filled with calculated amount", () {
          service.settings?.applyTaxLabor = true;
          service.calculatedAmounts = amounts;
          final result = service.worksheetJson([]);
          expect(result["labor_tax_amount"], amounts.laborTax);
        });

        test("[labor_custom_tax_id] should be filled with custom tax id if labor tax can be applied", () {
          service.settings?.applyTaxLabor = true;
          service.settings?.selectedLaborTaxRateId = '1';
          final result = service.worksheetJson([]);
          expect(result["labor_custom_tax_id"], '1');
        });

        test("[labor_custom_tax_id] should be not exist if labor tax can't be applied", () {
          service.settings?.applyTaxLabor = false;
          final result = service.worksheetJson([]);
          expect(result["labor_custom_tax_id"], isNull);
        });

        test("[labor_tax_rate] should be not exist if labor tax can't be applied", () {
          service.settings?.applyTaxLabor = false;
          final result = service.worksheetJson([]);
          expect(result["labor_tax_rate"], isEmpty);
        });

        test("[labor_tax_amount] should be not exist if labor tax can't be applied", () {
          service.settings?.applyTaxLabor = false;
          final result = service.worksheetJson([]);
          expect(result["labor_tax_amount"], isNull);
        });
      });

      group('Tax rate should be added correctly', () {
        test("[tax_rate] should be filled with rate if can be applied", () {
          service.settings?.applyTaxAll = true;
          service.settings?.taxRate = 5;
          final result = service.worksheetJson([]);
          expect(result["tax_rate"], '5');
        });

        test("[tax_amount] should be filled with calculated amount", () {
          service.settings?.applyTaxAll = true;
          service.calculatedAmounts = amounts;
          final result = service.worksheetJson([]);
          expect(result["tax_amount"], amounts.taxAll);
        });

        test("[custom_tax_id] should be filled with custom tax id if tax can be applied", () {
          service.settings?.applyTaxAll = true;
          service.settings?.selectedTaxRateId = '1';
          final result = service.worksheetJson([]);
          expect(result["custom_tax_id"], '1');
        });

        test("[custom_tax_id] should be not exist if tax can't be applied", () {
          service.settings?.applyTaxAll = false;
          final result = service.worksheetJson([]);
          expect(result["custom_tax_id"], isNull);
        });

        test("[tax_rate] should be not exist if tax can't be applied", () {
          service.settings?.applyTaxAll = false;
          final result = service.worksheetJson([]);
          expect(result["tax_rate"], isEmpty);
        });

        test("[tax_amount] should be not exist if tax can't be applied", () {
          service.settings?.applyTaxAll = false;
          final result = service.worksheetJson([]);
          expect(result["tax_amount"], isNull);
        });
      });

      group('[taxable] should set correctly', () {
        test("[taxable] should be set to true if tax can be applied", () {
          service.settings?.applyTaxAll = true;
          final result = service.worksheetJson([]);
          expect(result["taxable"], 1);
        });

        test("[taxable] should be set to false if tax can't be applied", () {
          service.settings?.applyTaxAll = false;
          final result = service.worksheetJson([]);
          expect(result["taxable"], 0);
        });
      });

      group('[line_tax] should set correctly', () {
        test("[line_tax] should be set to true if tax can be applied", () {
          service.settings?.addLineItemTax = true;
          final result = service.worksheetJson([]);
          expect(result["line_tax"], 1);
        });

        test("[line_tax] should be set to false if tax can't be applied", () {
          service.settings?.addLineItemTax = false;
          final result = service.worksheetJson([]);
          expect(result["line_tax"], 0);
        });
      });
      
      group("[overhead] should set correctly", () {
        test("[overhead] should be set to overhead rate if overhead can be applied", () {
          service.settings?.applyOverhead = true;
          service.settings?.overHeadRate = 1;
          final result = service.worksheetJson([]);
          expect(result["overhead"], 1);
        });

        test("[overhead] should be empty if overhead can't be applied", () {
          service.settings?.applyOverhead = false;
          final result = service.worksheetJson([]);
          expect(result["overhead"], isEmpty);
        });
      });

      group("[profit] should set correctly", () {
        test("[profit] should be set to profit rate if profit can be applied", () {
          service.settings?.applyProfit = true;
          service.settings?.overAllProfitPercent = 1;
          final result = service.worksheetJson([]);
          expect(result["profit"], 1);
        });

        test("[profit] should be empty if profit can't be applied", () {
          service.settings?.applyProfit = false;
          final result = service.worksheetJson([]);
          expect(result["profit"], isEmpty);
        });

        test("[profit_amount] should not exist if profit can't be applied", () {
          service.settings?.applyProfit = false;
          final result = service.worksheetJson([]);
          expect(result["profit_amount"], isNull);
        });

        test("[profit_amount] should be filled with calculated amount if profit can be applied", () {
          service.settings?.applyProfit = true;
          service.calculatedAmounts = amounts;
          final result = service.worksheetJson([]);
          expect(result["profit_amount"], amounts.profitMargin);
        });

        test("[margin] should not exist if profit can't be applied", () {
          service.settings?.applyProfit = false;
          final result = service.worksheetJson([]);
          expect(result["margin"], 0);
        });

        test("[margin] should be be 1 if margin profit is getting applied", () {
          service.settings?.applyProfit = true;
          service.settings?.isOverAllProfitMarkup = false;
          final result = service.worksheetJson([]);
          expect(result["margin"], '1');
        });

        test("[margin] should be be 0 if markup profit is getting applied", () {
          service.settings?.applyProfit = true;
          service.settings?.isOverAllProfitMarkup = true;
          final result = service.worksheetJson([]);
          expect(result["margin"], '0');
        });
      });

      group("[commission] should set correctly", () {
        test("[commission] should be set to commission rate if commission can be applied", () {
          service.settings?.applyCommission = true;
          service.settings?.commissionPercent = 1;
          final result = service.worksheetJson([]);
          expect(result["commission"], 1);
        });

        test("[commission] should be empty if commission can't be applied", () {
          service.settings?.applyCommission = false;
          final result = service.worksheetJson([]);
          expect(result["commission"], isEmpty);
        });

        test("[commission_amount] should not exist if commission can't be applied", () {
          service.settings?.applyCommission = false;
          final result = service.worksheetJson([]);
          expect(result["commission_amount"], isNull);
        });

        test("[commission_amount] should be filled with calculated amount if commission can be applied", () {
          service.settings?.applyCommission = true;
          service.calculatedAmounts = amounts;
          final result = service.worksheetJson([]);
          expect(result["commission_amount"], amounts.commission);
        });
      });

      group("[discount] should set correctly", () {
        test("[discount] should be set to discount if discount can be applied", () {
          service.settings?.applyDiscount = true;
          service.settings?.discountPercent = 1;
          final result = service.worksheetJson([]);
          expect(result["discount"], 1);
        });

        test("[discount] should be empty if discount can't be applied", () {
          service.settings?.applyDiscount = false;
          final result = service.worksheetJson([]);
          expect(result["discount"], isEmpty);
        }); 
        test("[discount_amount] should not exist if card fee can't be applied", () {
          service.settings?.applyDiscount = false;
          final result = service.worksheetJson([]);
          expect(result["discount_amount"], isNull);
        });
      });
      group("[processing_fee_percentage] should set correctly", () {
        test("[processing_fee_percentage] should be set to card fee rate if credit card fee can be applied", () {
          service.settings?.applyProcessingFee = true;
          service.settings?.creditCardFeePercent = 1;
          final result = service.worksheetJson([]);
          expect(result["processing_fee_percentage"], 1);
        });

        test("[processing_fee_percentage] should be empty if credit card fee can't be applied", () {
          service.settings?.applyProcessingFee = false;
          final result = service.worksheetJson([]);
          expect(result["processing_fee_percentage"], isEmpty);
        });

        test("[processing_fee_amount] should not exist if card fee can't be applied", () {
          service.settings?.applyProcessingFee = false;
          final result = service.worksheetJson([]);
          expect(result["processing_fee_amount"], isNull);
        });

        test("[processing_fee_amount] should be filled with calculated amount if card fee can be applied", () {
          service.settings?.applyProcessingFee = true;
          service.calculatedAmounts = amounts;
          final result = service.worksheetJson([]);
          expect(result["processing_fee_amount"], amounts.commission);
        });

        test("[contract_total] should not exist if card fee can't be applied", () {
          service.settings?.applyProcessingFee = false;
          final result = service.worksheetJson([]);
          expect(result["contract_total"], isNull);
        });

        test("[contract_total] should be filled with calculated contract total if card fee can be applied", () {
          service.settings?.applyProcessingFee = true;
          service.calculatedAmounts = amounts;
          final result = service.worksheetJson([]);
          expect(result["contract_total"], service.getContractTotal());
        });
      });

      group("Line item and tier settings should be saved correctly", () {
        test("[only_description] should set correctly from settings", () {
          service.settings?.descriptionOnly = true;
          Map<String, dynamic> result = service.worksheetJson([]);
          expect(result["only_description"], true);

          service.settings?.descriptionOnly = false;
          result = service.worksheetJson([]);
          expect(result["only_description"], false);
        });

        test("[description_only] should set correctly from settings", () {
          service.settings?.descriptionOnly = true;
          Map<String, dynamic> result = service.worksheetJson([]);
          expect(result["description_only"], 1);

          service.settings?.descriptionOnly = false;
          result = service.worksheetJson([]);
          expect(result["description_only"], 0);
        });

        test("Display settings should not exist if description only is disabled", () {
          service.settings?.descriptionOnly = false;
          final result = service.worksheetJson([]);
          expect(result['show_unit'], isNull);
          expect(result['show_quantity'], isNull);
          expect(result['show_style'], isNull);
          expect(result['show_size'], isNull);
          expect(result['show_color'], isNull);
          expect(result['show_supplier'], isNull);
          expect(result['show_trade_type'], isNull);
          expect(result['show_work_type'], isNull);
        });

        test("Display settings should exist if description only is enabled", () {
          service.settings?.descriptionOnly = true;
          final result = service.worksheetJson([]);
          expect(result['show_unit'], isNotNull);
          expect(result['show_quantity'], isNotNull);
          expect(result['show_style'], isNotNull);
          expect(result['show_size'], isNotNull);
          expect(result['show_color'], isNotNull);
          expect(result['show_supplier'], isNotNull);
          expect(result['show_trade_type'], isNotNull);
          expect(result['show_work_type'], isNotNull);
        });

        test("Other settings should exist even if description only is disabled", () {
          service.settings?.descriptionOnly = false;
          final result = service.worksheetJson([]);
          expect(result['show_pricing'], isNotNull);
          expect(result['hide_pricing'], isNotNull);
          expect(result['hide_customer_info'], isNotNull);
          expect(result['show_total'], isNotNull);
          expect(result['hide_total'], isNotNull);
          expect(result['only_tier_total'], isNotNull);
          expect(result['show_tier_total'], isNotNull);
          expect(result['show_calculation_summary'], isNotNull);
        });
      });

      group("[enable_selling_price] should set correctly", () {
        test("[enable_selling_price] should be set to true if selling price is enabled", () {
          service.settings?.enableSellingPrice = true;
          final result = service.worksheetJson([]);
          expect(result["enable_selling_price"], 1);
        });

        test("[enable_selling_price] should be set to false if selling price is disabled", () {
          service.settings?.enableSellingPrice = false;
          final result = service.worksheetJson([]);
          expect(result["enable_selling_price"], 0);
        });
      });

      group("[fixed_price] should set correctly", () {
        test("[fixed_price] should not exist if not applicable", () {
          service.settings?.isFixedPrice = false;
          final result = service.worksheetJson([]);
          expect(result["fixed_price"], isNull);
        });

        test("[fixed_price] should be filled with fixed price if applicable", () {
          service.settings?.isFixedPrice = true;
          service.calculatedAmounts = amounts;
          final result = service.worksheetJson([]);
          expect(result["fixed_price"], amounts.fixedPrice);
        });
      });

      test("[update_tax_order] should always be equal to 1", () {
        service.settings?.isFixedPrice = true;
        final result = service.worksheetJson([]);
        expect(result["update_tax_order"], 1);
      });

      group("[multi_tier] should set correctly", () {
        test("[multi_tier] should be set to true if worksheet has tiers available", () {
          service.lineItems = [tier1..subItems = [lineItem]];
          final result = service.worksheetJson([]);
          expect(result["multi_tier"], 1);
        });

        test("[multi_tier] should be set to false if worksheet has no tiers available", () {
          service.lineItems = [lineItem];
          final result = service.worksheetJson([]);
          expect(result["multi_tier"], 0);
        });
      });

      group('[details] should contain the parsed line items', () {
        test('Empty items should not be parsed', () {
          final result = service.worksheetJson([]);
          expect(result['details'], isEmpty);
        });

        test('Non-empty items should be parsed', () {
          final result = service.worksheetJson([lineItem]);
          expect(result['details'], hasLength(1));
        });
      });

      group("SRS details should be set correctly", () {
        setUp(() {
          service.isSRSEnable = true;
        });

        test("[branch_code] should be set to SRS branch code", () {
          service.selectedSrsBranch = SupplierBranchModel(
            branchCode: '123'
          );
          final result = service.worksheetJson([]);
          expect(result["branch_code"], '123');
        });

        test("[branch_id] should be set to SRS branch id", () {
          service.selectedSrsBranch = SupplierBranchModel(
            branchId: '123'
          );
          final result = service.worksheetJson([]);
          expect(result["branch_id"], '123');
        });

        test("[ship_to_sequence_number] should be set to SRS ship to address", () {
          service.selectedSrsShipToAddress = SrsShipToAddressModel(
            shipToSequenceId: '123'
          );
          final result = service.worksheetJson([]);
          expect(result["ship_to_sequence_number"], '123');
        });

        tearDown(() {
          service.isSRSEnable = false;
        });
      });

      group("Some details should be added only while auto saving worksheet", () {
        test("Details should be included", () {
          final result = service.worksheetJson([], isForUnsavedDB: true);
          expect(result['fixed_price'], isNotNull);
          expect(result['file'], isNull);
          expect(result['is_srs_enable'], isNotNull);
          expect(result['srs_branch_model'], isNotNull);
          expect(result['srs_branch_model'], isNotNull);
        });

        test("Details should not be included", () {
          final result = service.worksheetJson([]);
          expect(result['fixed_price'], 0);
          expect(result['file'], isNull);
          expect(result['is_srs_enable'], isNull);
          expect(result['srs_branch_model'], isNull);
          expect(result['srs_branch_model'], isNull);
        });
      });

      group('[show_tier_sub_totals] should be set properly while saving and updating worksheet', () {
        group("In case line item tax and profit is not applied", () {
          setUp(() {
            service.settings?.addLineItemTax = false;
            service.settings?.applyLineItemProfit = false;
          });

          test("[show_tier_sub_totals] should be set to false, when enabled", () {
            service.settings?.showTierSubTotals = true;
            final result = service.worksheetJson([]);
            expect(result["show_tier_sub_totals"], 0);
          });

          test("[show_tier_sub_totals] should be set to false, when disabled", () {
            service.settings?.showTierSubTotals = false;
            final result = service.worksheetJson([]);
            expect(result["show_tier_sub_totals"], 0);
          });
        });

        group("In case line item tax or profit is applied", () {
          test("[show_tier_sub_totals] should be set to true, when enabled and line tax is applied", () {
            service.settings?.addLineItemTax = true;
            service.settings?.showTierSubTotals = true;
            final result = service.worksheetJson([]);
            expect(result["show_tier_sub_totals"], 1);
          });

          test("[show_tier_sub_totals] should be set to false, when disabled and line tax is applied", () {
            service.settings?.addLineItemTax = true;
            service.settings?.showTierSubTotals = false;
            final result = service.worksheetJson([]);
            expect(result["show_tier_sub_totals"], 0);
          });

          test("[show_tier_sub_totals] should be set to true, when enabled and line profit is applied", () {
            service.settings?.applyProfit = true;
            service.settings?.showTierSubTotals = true;
            final result = service.worksheetJson([]);
            expect(result["show_tier_sub_totals"], 1);
          });

          test("[show_tier_sub_totals] should be set to false, when disabled and line profit is applied", () {
            service.settings?.applyProfit = true;
            service.settings?.showTierSubTotals = false;
            final result = service.worksheetJson([]);
            expect(result["show_tier_sub_totals"], 0);
          });
        });
      });

      test("Json should be empty if worksheet has no settings available", () {
        service.settings = null;
        final result = service.worksheetJson([]);
        expect(result, isEmpty);
      });

      test("Json should not be empty if worksheet has settings available", () {
        service.settings = settings;
        final result = service.worksheetJson([]);
        expect(result, isNotEmpty);
      });
    });

    group("WorksheetFormService@setInitialJson should set initial json", () {
      test("Initial json should be set while line items are empty", () {
        service.lineItems = [];
        service.settings = settings;
        service.setInitialJson();
        expect(service.initialJson, isNotEmpty);
      });

      test("Initial json should be set while line items are not empty", () {
        service.lineItems = [lineItem];
        service.setInitialJson();
        expect(service.initialJson, isNotEmpty);
      });
    });

    group("WorksheetFormService@checkIfNewDataAdded should check if new data is added", () {
      test("Value should be false when new data is not added", () {
        service.lineItems = [lineItem];
        service.settings = settings;
        service.setInitialJson();
        expect(service.checkIfNewDataAdded(), false);
      });

      test("Value should be true when new data is added", () {
        service.lineItems = [lineItem];
        service.settings = settings;
        service.setInitialJson();
        service.lineItems.clear();
        expect(service.checkIfNewDataAdded(), true);
      });
    });

    group("WorksheetFormService@checkIfAnyItemToSave should check if any line item is added or not", () {
      test("Value should be false when no line item is added", () {
        service.lineItems = [];
        expect(service.checkIfAnyItemToSave(), true);
      });

      test("Value should be true when line item is added", () {
        service.lineItems = [lineItem];
        expect(service.checkIfAnyItemToSave(), false);
      });

      test("Value should be false when tiers without item are added", () {
        service.lineItems = [tier1..subItems = []];
        expect(service.checkIfAnyItemToSave(), true);
      });

      test("Value should be true when tiers with item are added", () {
        service.lineItems = [tier1..subItems = [lineItem]];
        expect(service.checkIfAnyItemToSave(), false);
      });
    });

    group("WorksheetFormService@getWorksheetSettings should set correct worksheet settings", () {
      setUp(() {
        service.worksheetType = WorksheetConstants.estimate;
        CompanySettingsService.setCompanySettings([
          {
            "key": CompanySettingConstants.estimateWorksheet,
            "value": {
              "default_percentage": {
                'margin': 1
              }
            }
          }
        ]);
      });

      test("Worksheet settings should be used from company settings", () {
        service.getWorksheetSettings();
        expect(service.settings?.margin, '1');
      });

      test("While editing worksheet settings should be used from worksheet", () {
        service.settingsJson = {
          'enable_selling_price': '0'
        };
        service.workSheet = worksheet;
        service.formType = WorksheetFormType.edit;
        service.getWorksheetSettings();
        expect(service.settings?.enableSellingPrice, false);
      });

      test("On selecting favourite worksheet it's setting should be used", () {
        service.settingsJson = {
          'enable_selling_price': '1'
        };
        service.workSheet = worksheet..isEnableSellingPrice = true;
        service.formType = WorksheetFormType.add;
        service.getWorksheetSettings(forFavourite: true);
        expect(service.settings?.enableSellingPrice, true);
      });
    });

    group("WorksheetFormService@setDivision should set division", () {
      test("Division id should be set properly", () {
        service.setDivision("1");
        expect(service.selectedDivisionId, "1");
      });

      test("Division name should be set properly", () {
        service.allDivisions = [
          JPSingleSelectModel(id: '1', label: 'Test')
        ];
        service.setDivision("1");
        expect(service.divisionController.text, "Test");
      });
    });

    group('WorksheetFormService@typeToSettingsKey should extract settings as per worksheet type', () {
      test('Estimate settings settings should be extracted', () {
        service.worksheetType = WorksheetConstants.estimate;
        final result = service.typeToSettingsKey();
        expect(result, equals(CompanySettingConstants.estimateWorksheet));
      });

      test('Material list settings should be extracted', () {
        service.worksheetType = WorksheetConstants.materialList;
        final result = service.typeToSettingsKey();
        expect(result, equals(CompanySettingConstants.materialWorksheet));
      });

      test('Work order settings should be extracted', () {
        service.worksheetType = WorksheetConstants.workOrder;
        final result = service.typeToSettingsKey();
        expect(result, equals(CompanySettingConstants.workOrderWorksheet));
      });

      test('Proposal settings should be extracted', () {
        service.worksheetType = WorksheetConstants.proposal;
        final result = service.typeToSettingsKey();
        expect(result, equals(CompanySettingConstants.proposalWorksheet));
      });
    });

    group("WorksheetFormService@isPlaceSRSOrder should decide whether place SRS order action should be displayed or not", () {
      test("Action should not be displayed when worksheet is or type work order", () {
        service.worksheetType = WorksheetConstants.workOrder;
        expect(service.isPlaceSRSOrder(), false);
      });

      test("Action should not be displayed when SRS is not connected", () {
        ConnectedThirdPartyService.setConnectedParty({
          ConnectedThirdPartyConstants.srs : false
        });
        expect(service.isPlaceSRSOrder(), false);
      });

      test("Action should not be displayed when supplier id of material do not matches", () {
        service.workSheet = worksheet;
        service.workSheet?.materialList = LinkedMaterialModel(
          id: 5
        );
        expect(service.isPlaceSRSOrder(), false);
      });

      test("Action should not be displayed when adding a new worksheet", () {
        service.formType = WorksheetFormType.add;
        expect(service.isPlaceSRSOrder(), false);
      });

      test("Action should be displayed if all the above conditions are false", () {
        service.worksheetType = WorksheetConstants.materialList;
        service.isSRSEnable = true;
        ConnectedThirdPartyService.setConnectedParty({
          ConnectedThirdPartyConstants.srs : true
        });
        service.workSheet?.materialList = LinkedMaterialModel(
            forSupplierId: Helper.getSupplierId()
        );
        service.formType = WorksheetFormType.edit;
        expect(service.isPlaceSRSOrder(), true);
        service.isSRSEnable = false;
      });
    });

    group("WorksheetFormService@getParsedSheetLineItem should parse financial product to line item", () {
      test('Generates a line items with the correct productId', () {
        final result = service.getParsedSheetLineItem(financialProductModel);
        expect(result.productId, equals(financialProductModel.id.toString()));
      });

      test('Generates a line items with the correct title', () {
        final result = service.getParsedSheetLineItem(financialProductModel);
        expect(result.title, equals(financialProductModel.name));
      });

      test('Generates a line items with the correct price', () {
        final result = service.getParsedSheetLineItem(financialProductModel);
        expect(result.price, equals(financialProductModel.sellingPrice));
      });

      test('Generates a line items with the correct qty', () {
        final result = service.getParsedSheetLineItem(financialProductModel);
        expect(result.qty, equals('0'));
      });

      test('Generates a line items with the correct totalPrice', () {
        final result = service.getParsedSheetLineItem(financialProductModel);
        expect(result.totalPrice, equals('0'));
      });

      test('Generates a line items with the correct totalPrice', () {
        final result = service.getParsedSheetLineItem(financialProductModel);
        expect(result.totalPrice, equals('0'));
      });

      test('Generates a line items with the correct settings', () {
        final result = service.getParsedSheetLineItem(financialProductModel);
        expect(result.workSheetSettings, service.settings);
      });
    });
  });

  group('WorksheetFormService@setUnsavedResourceType should set unsaved resource type on the basis of worksheet', () {
    test('For estimate worksheet un saved resource type should be estimate', () {
      service.worksheetType = WorksheetConstants.estimate;
      service.setUnsavedResourceType();
      expect(service.unsavedResourcesType, equals(UnsavedResourceType.estimateWorksheet));
    });

    test('For material worksheet un saved resource type should be material', () {
      service.worksheetType = WorksheetConstants.materialList;
      service.setUnsavedResourceType();
      expect(service.unsavedResourcesType, equals(UnsavedResourceType.materialWorksheet));
    });

    test('For work order worksheet un saved resource type should be work order', () {
      service.worksheetType = WorksheetConstants.workOrder;
      service.setUnsavedResourceType();
      expect(service.unsavedResourcesType, equals(UnsavedResourceType.workOrderWorksheet));
    });

    test('For proposal worksheet un saved resource type should be proposal', () {
      service.worksheetType = WorksheetConstants.proposal;
      service.setUnsavedResourceType();
      expect(service.unsavedResourcesType, equals(UnsavedResourceType.proposalWorksheet));
    });
  });

  group('WorksheetFormService@typeToIncludes give extra includes on the basis on worksheet type', () {
    test('Includes for Estimate worksheet type should match', () {
      service.worksheetType = WorksheetConstants.estimate;
      final includes = service.typeToIncludes();
      expect(includes, equals({
        "includes[13]": "job_estimate.created_by",
        "includes[14]": "job_estimate.my_favourite_entity",
        "includes[15]": "job_estimate.linked_measurement",
      }));
    });

    test('Includes for Material List worksheet type should match', () {
      service.worksheetType = WorksheetConstants.materialList;
      final includes = service.typeToIncludes();
      expect(includes, equals({
        "includes[13]": "material_list.created_by",
        "includes[14]": "material_list.my_favourite_entity",
        "includes[15]": "material_list.linked_measurement",
      }));
    });

    test('Includes for Proposal worksheet type should match', () {
      service.worksheetType = WorksheetConstants.proposal;
      final includes = service.typeToIncludes();
      expect(includes, equals({
        "includes[13]": "job_proposal.created_by",
        "includes[14]": "job_proposal.my_favourite_entity",
        "includes[15]": "job_proposal.linked_measurement",
      }));
    });

    test('Includes for Work Order worksheet type should match', () {
      service.worksheetType = WorksheetConstants.workOrder;
      final includes = service.typeToIncludes();
      expect(includes, equals({
        "includes[13]": "work_order.created_by",
        "includes[14]": "work_order.my_favourite_entity",
        "includes[15]": "work_order.linked_measurement",
      }));
    });
  });

  group("WorksheetFormService@onCustomTaxRateSelected should set custom tax rate and recalculate amounts", () {
    setUp(() {
      service.lineItems = [lineItem];
      service.settings = settings..applyTaxAll = true;
      service.allTax = taxList;
    });

    test("Tax rate id should be replaced with selected tax id", () {
      service.onCustomTaxRateSelected(taxList[0].id);
      expect(service.settings?.selectedTaxRateId, taxList[0].id);
    });

    test("Existing tax rate should be replaced with selected tax rate", () {
      service.onCustomTaxRateSelected(taxList[0].id);
      expect(service.settings?.overriddenTaxRate, taxList[0].additionalData);
    });

    test("Revised tax application option should hide if visible", () {
      service.onCustomTaxRateSelected(taxList[0].id);
      expect(service.settings?.isRevisedTaxApplied, isFalse);
    });
  });

  group("WorksheetFormService@onCustomMaterialTaxRateSelected should set custom material tax rate and recalculate amounts", () {
    setUp(() {
      service.settings = settings;
      service.allTax = taxList;
    });

    test("Material tax rate id should be replaced with selected tax id", () {
      service.onCustomMaterialTaxRateSelected(taxList[0].id);
      expect(service.settings?.selectedMaterialTaxRateId, taxList[0].id);
    });

    test("Existing material tax rate should be replaced with selected tax rate", () {
      service.onCustomMaterialTaxRateSelected(taxList[0].id);
      expect(service.settings?.overriddenMaterialTaxRate, taxList[0].additionalData);
    });

    test("Revised material tax application option should hide if visible", () {
      service.onCustomMaterialTaxRateSelected(taxList[0].id);
      expect(service.settings?.isRevisedMaterialTaxApplied, isFalse);
    });
  });

  group("WorksheetFormService@onCustomLaborTaxRateSelected should set custom labor tax rate and recalculate amounts", () {
    setUp(() {
      service.settings = settings;
      service.allTax = taxList;
    });

    test("Labor tax rate id should be replaced with selected tax id", () {
      service.onCustomLaborTaxRateSelected(taxList[0].id);
      expect(service.settings?.selectedLaborTaxRateId, taxList[0].id);
    });

    test("Existing labor tax rate should be replaced with selected tax rate", () {
      service.onCustomLaborTaxRateSelected(taxList[0].id);
      expect(service.settings?.overriddenLaborTaxRate, taxList[0].additionalData);
    });

    test("Revised labor tax application option should hide if visible", () {
      service.onCustomLaborTaxRateSelected(taxList[0].id);
      expect(service.settings?.isRevisedLaborTaxApplied, isFalse);
    });
  });

  group("WorksheetFormService@getActions should return actions list", () {
    test("When no line items are selected", () {
      service.lineItems = [];
      expect(service.getActions(), hasLength(8));
    });

    test("When only line items are selected", () {
      service.lineItems = [lineItem];
      expect(service.getActions(), hasLength(11));
    });

    test("When only line items with tiers are selected", () {
      service.lineItems = [tier1..subItems = [lineItem]];
      expect(service.getActions(), hasLength(12));
    });
  });

  group("WorksheetFormService@onNoteChange should update worksheet note", () {
    test("Note should be updated when note is empty", () {
      service.workSheet = worksheet;
      service.onNoteChange('');
      expect(service.note, isEmpty);
    });

    test("Note should be updated when note is not empty", () {
      service.onNoteChange('test');
      expect(service.note, equals('test'));
    });
  });

  group("WorksheetFormService@setAmountRates worksheet rates", () {
    setUp(() {
      service.settings = settings;
    });

    test("By default all rates should be zero", () {
      service.setAmountRates();
      expect(service.settings?.laborTaxRate, 0);
      expect(service.settings?.materialTaxRate, 0);
      expect(service.settings?.taxRate, 0);
      expect(service.settings?.overHeadRate, 0);
    });

    test("Labor tax rate should be set correctly", () {
      CompanySettingsService.setCompanySettings([{
          'key': CompanySettingConstants.laborTaxRate,
          'value': 0.2,
      }]);
      service.setAmountRates();
      expect(service.settings?.laborTaxRate, 0.2);
    });

    test("Material tax rate should be set correctly", () {
      CompanySettingsService.setCompanySettings([{
          'key': CompanySettingConstants.materialTaxRate,
          'value': 0.2,
      }]);
      service.setAmountRates();
      expect(service.settings?.materialTaxRate, 0.2);
    });

    test("Tax rate should be set correctly", () {
      CompanySettingsService.setCompanySettings([{
          'key': CompanySettingConstants.taxRate,
          'value': 0.2,
      }]);
      service.setAmountRates();
      expect(service.settings?.taxRate, 0.2);
    });

    test("Overhead rate should be set correctly", () {
      CompanySettingsService.setCompanySettings([{
          'key': CompanySettingConstants.jobCostOverhead,
          'value': {'overhead': 0.2},
      }]);
      service.setAmountRates();
      expect(service.settings?.overHeadRate, 0.2);
    });
  });

  group("WorksheetFormService@toggleRevisedTax should toggle revised tax", () {
    setUp(() {
      service.settings = settings;
    });

    test("Revised tax should be applied", () {
      service.toggleRevisedTax(false);
      expect(service.settings?.isRevisedTaxApplied, isFalse);
    });

    test("Revised tax should be removed", () {
      service.toggleRevisedTax(true);
      expect(service.settings?.isRevisedTaxApplied, isFalse);
    });
  });

  group("WorksheetFormService@toggleRevisedMaterialTax should toggle revised material tax", () {
    setUp(() {
      service.settings = settings;
    });

    test("Revised material tax should be applied", () {
      service.toggleRevisedMaterialTax(false);
      expect(service.settings?.isRevisedMaterialTaxApplied, isFalse);
    });

    test("Revised material tax should be removed", () {
      service.toggleRevisedMaterialTax(true);
      expect(service.settings?.isRevisedMaterialTaxApplied, isFalse);
    });
  });

  group("WorksheetFormService@toggleRevisedLaborTax should toggle revised labor tax", () {
    setUp(() {
      service.settings = settings;
    });

    test("Revised labor tax should be applied", () {
      service.toggleRevisedLaborTax(false);
      expect(service.settings?.isRevisedLaborTaxApplied, isFalse);
    });

    test("Revised labor tax should be removed", () {
      service.toggleRevisedLaborTax(true);
      expect(service.settings?.isRevisedLaborTaxApplied, isFalse);
    });
  });

  group("WorksheetFormService@bindSettingsWithItems should bind settings with all the items", () {
    test("When there are no items, settings should not attached", () {
      service.lineItems = [];
      service.bindSettingsWithItems();
      expect(service.lineItems, hasLength(0));
    });

    test("When there are only line items, settings should be attached", () {
      service.lineItems = [lineItem];
      service.settings = settings;
      service.bindSettingsWithItems();
      expect(service.lineItems[0].workSheetSettings, settings);
    });

    test("When there are only line items with tiers, settings should be attached", () {
      service.lineItems = [tier1..subItems = [lineItem]];
      service.settings = settings;
      service.bindSettingsWithItems();
      expect(service.lineItems[0].subItems?[0].workSheetSettings, settings);
    });
  });

  group("WorksheetFormService@updateSettings should update worksheet settings from worksheet data", () {
    setUp(() {
      service.workSheet = worksheet;
      service.settings = settings;
    });

    test("QBD availability should reflect in worksheet settings", () {
      service.workSheet?.isQbdWorksheet = true;
      service.updateSettings([]);
      expect(service.workSheet?.isQbdWorksheet, isTrue);

      service.workSheet?.isQbdWorksheet = false;
      service.updateSettings([]);
      expect(service.workSheet?.isQbdWorksheet, isFalse);
    });

    test("Material worksheet settings should reflect in worksheet settings sections", () {
      service.worksheetType = WorksheetConstants.materialList;
      service.updateSettings([]);
      expect(service.worksheetType, WorksheetConstants.materialList);

      service.worksheetType = WorksheetConstants.estimate;
      service.updateSettings([]);
      expect(service.worksheetType, WorksheetConstants.estimate);
    });

    test("Work order worksheet settings should reflect in worksheet settings sections", () {
      service.worksheetType = WorksheetConstants.workOrder;
      service.updateSettings([]);
      expect(service.worksheetType, WorksheetConstants.workOrder);

      service.worksheetType = WorksheetConstants.estimate;
      service.updateSettings([]);
      expect(service.worksheetType, WorksheetConstants.estimate);
    });

    test("Proposal worksheet settings should reflect in worksheet settings tax", () {
      service.worksheetType = WorksheetConstants.proposal;
      service.updateSettings([]);
      expect(service.worksheetType, WorksheetConstants.proposal);

      service.worksheetType = WorksheetConstants.estimate;
      service.updateSettings([]);
      expect(service.worksheetType, WorksheetConstants.estimate);
    });

    test("Material tax should show/hide based on worksheet items", () {
      service.worksheetType = WorksheetConstants.estimate;
      lineItem.product = FinancialProductModel(
          productCategory: WorksheetDetailCategoryModel(
              slug: FinancialConstant.material,
          ),
      );
      service.updateSettings([lineItem]);
      expect(service.settings?.hasMaterialItem, isTrue);

      service.worksheetType = WorksheetConstants.estimate;
      service.updateSettings([]);
      expect(service.settings?.hasMaterialItem, isFalse);
    });

    test("Labor tax should show/hide based on worksheet items", () {
      service.worksheetType = WorksheetConstants.estimate;
      lineItem.product = FinancialProductModel(
        productCategory: WorksheetDetailCategoryModel(
          slug: FinancialConstant.labor,
        ),
      );
      service.updateSettings([lineItem]);
      expect(service.settings?.hasLaborItem, isTrue);

      service.worksheetType = WorksheetConstants.estimate;
      service.updateSettings([]);
      expect(service.settings?.hasLaborItem, isFalse);
    });

    test("Availability of No Charge Item should disable some settings", () {
      service.worksheetType = WorksheetConstants.estimate;
      lineItem.product = FinancialProductModel(
        productCategory: WorksheetDetailCategoryModel(
          slug: FinancialConstant.noCharge,
        ),
      );
      service.updateSettings([lineItem]);
      expect(service.settings?.hasNoChargeItem, isTrue);

      service.worksheetType = WorksheetConstants.estimate;
      service.updateSettings([]);
      expect(service.settings?.hasNoChargeItem, isFalse);
    });

    test("Tier settings should be displayed only when worksheet has tiers", () {
      service.lineItems = [tier1];
      service.updateSettings(service.lineItems);
      expect(service.settings?.hasTier, isTrue);

      service.lineItems = [];
      service.updateSettings(service.lineItems);
      expect(service.settings?.hasTier, isFalse);
    });
  });

  group("WorksheetFormService@onItemSaved should update worksheet with new item", () {
    setUp(() {
      service.settings = settings;
    });

    group("When tiers do not exist", () {
      test("Items should be added to worksheet line items", () {
        service.lineItems = [];
        service.onItemSaved(null, null, lineItem, null);
        expect(service.lineItems, hasLength(1));
      });

      test("Existing item should be edited", () {
        lineItem.qty = '5';
        service.onItemSaved(null, lineItem..currentIndex = 0, lineItem, null);
        expect(service.lineItems[0].qty, equals('5'));
      });
    });

    group("When tiers exist", () {
      test("Items should be added to worksheet line items", () {
        tier1.subItems = [];
        service.onItemSaved(tier1, null, lineItem, null);
        expect(tier1.subItems, hasLength(1));
      });

      test("Existing item should be edited", () {
        lineItem.qty = '5';
        service.onItemSaved(tier1, lineItem..currentIndex = 0, lineItem, null);
        expect(tier1.subItems?[0].qty, equals('5'));
      });
    });
  });

  group("WorksheetFormService@reorderItem should reorder line items", () {
    test("Line items should be reordered", () {
      final items = [lineItem, lineItem2];
      service.reorderItem(0, 1, items);
      expect(items, [
        lineItem2, lineItem
      ]);
    });

    test("Line items should not be reordered", () {
      final items = [lineItem, lineItem2];
      service.reorderItem(0, 0, items);
      expect(items, [
        lineItem, lineItem2
      ]);
    });
  });

  group("WorksheetFormService@calculateSummary should calculate worksheet summary amounts", () {
    setUp(() {
      service.workSheet = worksheet;
      service.settings = WorksheetSettingModel.fromJson({});
    });

    test("When line items are added amounts should be calculated accordingly", () {
      lineItem.isFixedPriceItem = false;
      service.lineItems = [lineItem];
      service.calculateSummary();
      expect(service.calculatedAmounts.subTotal, equals(0));
      expect(service.calculatedAmounts.listTotal, equals(0));
    });

    test("When no line items are added all amounts should be zero", () {
      service.calculateSummary();
      expect(service.calculatedAmounts.subTotal, equals(0));
      expect(service.calculatedAmounts.listTotal, equals(0));
      expect(service.calculatedAmounts.materialTax, equals(0));
      expect(service.calculatedAmounts.laborTax, equals(0));
      expect(service.calculatedAmounts.taxAll, equals(0));
      expect(service.calculatedAmounts.lineItemTax, equals(0));
      expect(service.calculatedAmounts.overhead, equals(0));
      expect(service.calculatedAmounts.profitMarkup, equals(0));
      expect(service.calculatedAmounts.profitMargin, equals(0));
      expect(service.calculatedAmounts.lineItemProfit, equals(0));
      expect(service.calculatedAmounts.commission, equals(0));
      expect(service.calculatedAmounts.noChargeAmount, equals(0));
      expect(service.calculatedAmounts.fixedPrice, equals(0));
      expect(service.calculatedAmounts.profitLossAmount, equals(0));
    });

  });

  group("WorksheetFormService@removeItem should remove item from index", () {
    test("Item should be removed when there are only line items", () {
      service.settings = settings;
      service.lineItems = [lineItem];
      service.removeItem(0);
      expect(service.lineItems, isEmpty);
    });

    test("Item should be removed when there are tiers with items", () {
      final items = [lineItem];
      service.lineItems = [tier1..subItems = items];
      service.removeItem(0, items: items);
      expect(service.lineItems[0].subItems, isEmpty);
    });
  });

  group('WorksheetFormService@onListItemReorder should verify the re-ordered indices and updates them accordingly', () {
    setUp(() {
      service.lineItems = [
        lineItem,
        lineItem2,
        lineItem3,
      ];
    });

    test('Items should be reorders when items is moved from top to bottom', () {
      service.onListItemReorder(1, 3);
      expect(service.lineItems[0], equals(lineItem));
      expect(service.lineItems[1], equals(lineItem3));
      expect(service.lineItems[2], equals(lineItem2));
    });

    test('Items should be reorders when item is moved from botton to top', () {
      service.onListItemReorder(2, 0);
      expect(service.lineItems[0], equals(lineItem3));
      expect(service.lineItems[1], equals(lineItem));
      expect(service.lineItems[2], equals(lineItem2));
    });

    test('Does not reorder items when oldIndex equals newIndex', () {
      service.onListItemReorder(2, 3);
      expect(service.lineItems[0], equals(lineItem));
      expect(service.lineItems[1], equals(lineItem2));
      expect(service.lineItems[2], equals(lineItem3));
    });
  });

  group("WorksheetFormService@onTierExpansionChanged should change tier expansion", () {
    test("Tier should be expanded if collapsed", () {
      tier1.isTierExpanded = false;
      service.onTierExpansionChanged(true, tier1);
      expect(tier1.isTierExpanded, isTrue);
    });

    test("Tier should be collapsed if expanded", () {
      tier1.isTierExpanded = true;
      service.onTierExpansionChanged(false, tier1);
      expect(tier1.isTierExpanded, isFalse);
    });

    test("Tier should not be collapsed if already collapsed", () {
      tier1.isTierExpanded = false;
      service.onTierExpansionChanged(false, tier1);
      expect(tier1.isTierExpanded, isFalse);
    });

    test("Tier should not be expanded if already expanded", () {
      tier1.isTierExpanded = true;
      service.onTierExpansionChanged(true, tier1);
      expect(tier1.isTierExpanded, isTrue);
    });
  });

  group("WorksheetFormService@toggleIsSavingForm should disable worksheet interaction", () {
    test("Worksheet interaction should be disabled", () {
      service.toggleIsSavingForm(true);
      expect(service.isSavingForm, isTrue);
    });

    test("Worksheet interaction should be enabled", () {
      service.toggleIsSavingForm(false);
      expect(service.isSavingForm, isFalse);
    });
  });

  group("WorksheetFormService@updateTierPrice should set tier price of single tier", () {
    test("Tier amounts should be zero when there are no line items in tier", () {
      service.lineItems = [tier1
        ..totalPrice = '0'
        ..tiersLineTotal = '0'
        ..lineProfitAmt = '0'
        ..lineTaxAmt = '0',
      ];
      service.updateTierPrice([tier1..subItems = []]);
      expect(tier1.totalPrice, equals('0'));
      expect(tier1.tiersLineTotal, equals('0'));
      expect(tier1.lineProfitAmt, equals('0'));
      expect(tier1.lineTaxAmt, equals('0'));
    });

    test("Tier amounts should be set when there are line items in tier", () {
      service.lineItems = [tier1..subItems = [lineItem
        ..totalPrice = '200'
        ..tiersLineTotal = '20'
        ..lineProfitAmt = '100'
        ..lineTaxAmt = '10',
      ]];
      service.updateTierPrice([lineItem], collectionIndex: 0);
      expect(tier1.totalPrice, equals('200'));
      expect(tier1.tiersLineTotal, equals('20'));
      expect(tier1.lineProfitAmt, equals('100'));
      expect(tier1.lineTaxAmt, equals('10'));
    });

    test("Tier amounts should be set when there are multiple line items in tier", () {
      service.lineItems = [tier1..subItems = [lineItem, lineItem]];
      service.updateTierPrice([lineItem, lineItem], collectionIndex: 0);
      expect(tier1.totalPrice, equals('400'));
      expect(tier1.tiersLineTotal, equals('40'));
      expect(tier1.lineProfitAmt, equals('200'));
      expect(tier1.lineTaxAmt, equals('20'));
    });
  });

  group("WorksheetFormService@updateAllTiersPrice should set all tiers price", () {
    test("All tiers price should be zero when there are no line items", () {
      service.lineItems = [
        tier1..subItems = [],
        tier2..subItems = [],
        tier3..subItems = [],
      ];

      service.updateAllTiersPrice();
      expect(tier1.totalPrice, equals('0'));
      expect(tier1.tiersLineTotal, equals('0'));
      expect(tier1.lineProfitAmt, equals('0'));
      expect(tier1.lineTaxAmt, equals('0'));

      expect(tier2.totalPrice, equals('0'));
      expect(tier2.tiersLineTotal, equals('0'));
      expect(tier2.lineProfitAmt, equals('0'));
      expect(tier2.lineTaxAmt, equals('0'));

      expect(tier3.totalPrice, equals('0'));
      expect(tier3.tiersLineTotal, equals('0'));
      expect(tier3.lineProfitAmt, equals('0'));
      expect(tier3.lineTaxAmt, equals('0'));
    });

    test("All tiers price should be set when there are line items", () {
      service.lineItems = [
        tier1..subItems = [lineItem],
        tier2..subItems = [lineItem],
        tier3..subItems = [lineItem],
      ];
      service.updateAllTiersPrice();
      expect(tier1.totalPrice, equals('200'));
      expect(tier1.tiersLineTotal, equals('20'));
      expect(tier1.lineProfitAmt, equals('100'));
      expect(tier1.lineTaxAmt, equals('10'));

      expect(tier2.totalPrice, equals('200'));
      expect(tier2.tiersLineTotal, equals('20'));
      expect(tier2.lineProfitAmt, equals('100'));
      expect(tier2.lineTaxAmt, equals('10'));

      expect(tier3.totalPrice, equals('200'));
      expect(tier3.tiersLineTotal, equals('20'));
      expect(tier3.lineProfitAmt, equals('100'));
      expect(tier3.lineTaxAmt, equals('10'));
    });

    test("Only tiers having item's price should be sets", () {
      service.lineItems = [
        tier1..subItems = [lineItem],
        tier2..subItems = [],
        tier3..subItems = [lineItem],
      ];
      service.updateAllTiersPrice();
      expect(tier1.totalPrice, equals('200'));
      expect(tier1.tiersLineTotal, equals('20'));
      expect(tier1.lineProfitAmt, equals('100'));
      expect(tier1.lineTaxAmt, equals('10'));

      expect(tier2.totalPrice, equals('0'));
      expect(tier2.tiersLineTotal, equals('0'));
      expect(tier2.lineProfitAmt, equals('0'));
      expect(tier2.lineTaxAmt, equals('0'));

      expect(tier3.totalPrice, equals('200'));
      expect(tier3.tiersLineTotal, equals('20'));
      expect(tier3.lineProfitAmt, equals('100'));
      expect(tier3.lineTaxAmt, equals('10'));
    });

    test("When there are no tiers nothing should happen", () {
      service.lineItems = [lineItem];
      service.updateAllTiersPrice();
      expect(tier1.totalPrice, equals('200'));
      expect(tier1.tiersLineTotal, equals('20'));
      expect(tier1.lineProfitAmt, equals('100'));
      expect(tier1.lineTaxAmt, equals('10'));
    });
  });

  group("WorksheetFormService@removeCollection should delete tier or line item from index", () {
    test("Line item should be removed", () {
      service.settings = settings;
      service.lineItems = [lineItem];
      service.removeCollection(0);
      expect(service.lineItems, isEmpty);
    });

    test("Tier should be removed", () {
      service.lineItems = [tier1..subItems = []];
      service.removeCollection(0);
      expect(service.lineItems, isEmpty);
    });

    test("When there is only single tier, it's line items should not be removed", () {
      service.lineItems = [tier1..subItems = [lineItem, lineItem]];
      service.removeCollection(0);
      expect(service.lineItems, hasLength(2));
    });

    test("When there are more than one tier, line items should be removed", () {
      service.lineItems = [
        tier1..subItems = [lineItem, lineItem],
        tier2
      ];
      service.removeCollection(0);
      expect(service.lineItems, hasLength(1));
    });
  });

  test("WorksheetFormService@removeAttachedItem should removed linked attachment", () {
    service.attachments = [
      AttachmentResourceModel(id: 1),
      AttachmentResourceModel(id: 2),
    ];
    service.removeAttachedItem(1);
    expect(service.attachments, hasLength(1));
  });

  group('WorksheetFormService@parseMacroToLineItems should properly parse macro\'s list to sheet line items', () {
    test('Empty macros list should not add line item', () {
      service.settings = settings;
      service.lineItems = [];
      service.parseMacroToLineItems([]);
      expect(service.lineItems, isEmpty);
    });

    test('Single macro with details should be parsed correctly', () {
      final macros = [macroItem];
      service.parseMacroToLineItems(macros);
      expect(service.lineItems, hasLength(2));
    });

    test('Fixed price should be accumulated correctly', () {
      service.parseMacroToLineItems([macroItem]);
      expect(settings.fixedPriceAmount, equals(200));
    });
  });

  group('WorksheetFormService@getSRSDetailsText should show SRS details', () {
    setUp(() {
      service.isSRSEnable = true;
    });
    test('SRS details with branch name and branch code should be displayed', () {
      service.selectedSrsBranch = SupplierBranchModel(name: 'BranchName', branchCode: 'B123');
      final result = service.getSupplierDetails;
      expect(result, equals('SRS branch: BranchName (B123)'));
    });

    test('SRS details with only branch name should be displayed', () {
      service.selectedSrsBranch = SupplierBranchModel(name: 'BranchName', branchCode: null);
      final result = service.getSupplierDetails;
      expect(result, equals('SRS branch: BranchName ()'));
    });

    test('SRS details with only branch code should be displayed', () {
      service.selectedSrsBranch = SupplierBranchModel(name: null, branchCode: '123');
      final result = service.getSupplierDetails;
      expect(result, equals('SRS branch:  (123)'));
    });

    tearDown(() {
      service.isSRSEnable = false;
    });
  });

  group("WorksheetFormService@removeSrsBranch should remove selected SRS branch", () {
    setUp(() {
      service.selectedSrsBranch = SupplierBranchModel(name: 'Branch', branchCode: '123');
      service.lineItems = [
        lineItem..product = FinancialProductModel(notAvailable: true, notAvailableInPriceList: true),
        lineItem..product = FinancialProductModel(notAvailable: false, notAvailableInPriceList: false),
      ];
      service.selectedSrsShipToAddress = SrsShipToAddressModel();
      service.removeSupplier();
    });

    test("Selected SRS branch should be removed", () {
      expect(service.selectedSrsBranch, isNull);
    });

    test("Selected SRS ship to address should be removed", () {
      expect(service.selectedSrsShipToAddress, isNull);
    });

    test("SRS toggle should be disabled", () {
      expect(service.isSRSEnable, isFalse);
    });

    test("SRS product availability should be removed from line items", () {
      expect(service.lineItems[0].product?.notAvailable, isFalse);
      expect(service.lineItems[0].product?.notAvailableInPriceList, isFalse);
    });
  });

  group("WorksheetFormService@getGrandTotal should decide and display grand total", () {
    test("Actual total should be displayed when there are no line item with fixed price", () {
      service.lineItems = [lineItem..isFixedPriceItem = false];
      service.settings?.isFixedPrice = false;
      service.calculatedAmounts.listTotal = 200;
      service.calculatedAmounts.fixedPrice = 100;
      expect(service.getGrandTotal(), equals(200));
    });

    test("Fixed price total should be displayed when there are line item with fixed price", () {
      service.lineItems = [lineItem..isFixedPriceItem = true];
      service.settings = settings;
      service.settings?.isFixedPrice = true;
      service.calculatedAmounts.listTotal = 200;
      service.calculatedAmounts.fixedPrice = 100;
      expect(service.getGrandTotal(), equals(100));
    });
  });

  group("WorksheetFormService@getContractTotal should decide and display contract total", () {
    group("In case Credit Card Fee is applied", () {
      test("Contract total should be displayed as sum of Grand Total and Credit Card Fee when there are no line item with fixed price", () {
        service.lineItems = [lineItem..isFixedPriceItem = false];
        service.settings?.isFixedPrice = false;
        service.settings?.applyProcessingFee = true;
        service.calculatedAmounts.listTotal = 200;
        service.calculatedAmounts.fixedPrice = 100;
        service.calculatedAmounts.creaditCardFee = 100;
        expect(service.getContractTotal(), service.getGrandTotal() + 100);
      });

      test("Contract total should be displayed as sum of Fixed Total and Credit Card Fee when there are line item with fixed price", () {
        service.lineItems = [lineItem..isFixedPriceItem = true];
        service.settings?.isFixedPrice = true;
        service.settings?.applyProcessingFee = true;
        service.calculatedAmounts.listTotal = 200;
        service.calculatedAmounts.fixedPrice = 100;
        service.calculatedAmounts.creaditCardFee = 100;
        expect(service.getContractTotal(), service.calculatedAmounts.fixedPrice + 100);
      });
    });

    group("In case Credit Card Fee is not applied", () {
      test("Contract total should be displayed as Grand Total when there are no line item with fixed price", () {
        service.lineItems = [lineItem..isFixedPriceItem = false];
        service.settings?.isFixedPrice = false;
        service.settings?.applyProcessingFee = false;
        service.calculatedAmounts.listTotal = 200;
        service.calculatedAmounts.fixedPrice = 100;
        service.calculatedAmounts.creaditCardFee = 100;
        expect(service.getContractTotal(), service.getGrandTotal());
      });

      test("Contract total should be displayed as Fixed Total when there are line item with fixed price", () {
        service.lineItems = [lineItem..isFixedPriceItem = true];
        service.settings?.isFixedPrice = true;
        service.settings?.applyProcessingFee = false;
        service.calculatedAmounts.listTotal = 200;
        service.calculatedAmounts.fixedPrice = 100;
        service.calculatedAmounts.creaditCardFee = 100;
        expect(service.getContractTotal(), service.calculatedAmounts.fixedPrice);
      });
    });
  });

  group("WorksheetFormService@checkColorIsSelected should check whether color is selected or not", () {
    test("Color should not be considered as added when product does not have color", () {
      service.isColorAdded = false;
      service.lineItems = [lineItem..product = FinancialProductModel(colors: null)];
      service.checkColorIsSelected(service.lineItems[0]);
      expect(service.isColorAdded, isFalse);
    });

    test("Color should not be considered as added when item color is not selected", () {
      service.lineItems = [lineItem..product = FinancialProductModel(colors: ['Red'])];
      service.lineItems[0].color = null;
      service.checkColorIsSelected(service.lineItems[0]);
      expect(service.isColorAdded, isFalse);
    });

    test("Color should be considered as added when product has color added and item color is selected", () {
      service.lineItems = [lineItem..product = FinancialProductModel(colors: ['Red'])];
      service.lineItems[0].color = 'Red';
      service.checkColorIsSelected(service.lineItems[0]);
      expect(service.isColorAdded, isTrue);
    });
  });

  group("In case of edit worksheet", () {

    setUp(() {
      worksheet = WorksheetModel.fromWorksheetJson(WorksheetMockedResponse.response1);
      service = WorksheetFormService(
          hidePriceDialog: false,
          formType: WorksheetFormType.edit,
          worksheetType: WorksheetConstants.estimate,
          jobId: worksheet.jobId,
          worksheetId: worksheet.id,
          flModule: FLModule.estimate,
          update: () {  });
      service.workSheet = worksheet;
      service.job = jobModel;
      service.settings = settings;
      service.setFormData();
      service.setInitialJson();
    });

    group("WorksheetFormService should be initialized properly", () {
      test("Worksheet data value holders should be properly initialized", () {
        expect(service.jobId, worksheet.jobId);
        expect(service.measurementId, worksheet.measurementId);
        expect(service.worksheetId, worksheet.id);
        expect(service.dbUnsavedResourceId, isNull);
        expect(service.note, worksheet.note ?? "");
        expect(service.selectedDivisionId, worksheet.division?.id ?? "");
      });

      test("Worksheet toggles should be properly initialized", () {
        expect(service.isSavedOnTheGo, false);
        expect(service.isSavingForm, false);
        expect(service.isLoading, true);
        expect(service.selectedFromFavourite, false);
        expect(service.isSRSEnable, false);
        expect(service.isColorAdded, false);
        expect(service.isDBResourceIdFromController, false);
      });

      test("Worksheet lists should be properly initialized", () {
        expect(service.allCategories, isEmpty);
        expect(service.allSuppliers, isEmpty);
        expect(service.allDivisions, isEmpty);
        expect(service.allTrades, isEmpty);
        expect(service.allTax, isEmpty);
        expect(service.lineItems, isNotEmpty);
        expect(service.allTiers, isEmpty);
        expect(service.attachments, worksheet.attachments);
        expect(service.uploadedAttachments, isEmpty);
        expect(service.companyTemplates, isEmpty);
      });

      test("Worksheet controllers should be properly initialized", () {
        expect(service.titleController.text, worksheet.title ?? "");
        expect(service.divisionController.text, worksheet.division?.name ?? "");
      });

      test("Worksheet additional data should be properly initialized", () {
        expect(service.selectedSrsShipToAddress, isNull);
        expect(service.selectedSrsBranch, isNull);
        expect(service.worksheetMeasurement, isNull);
        expect(service.settings, settings);
        expect(service.workSheet, worksheet);
        expect(service.job, jobModel);
        expect(service.flModule, FLModule.estimate);
      });

      test("Worksheet json holders should be properly initialized", () {
        expect(service.settingsJson, isNull);
        expect(service.initialJson, isNotEmpty);
        expect(service.unsavedResourceJson, isNull);
      });
    });

    group("Worksheet getters should give correct value", () {
      group("WorksheetFormService@hasTiers should decide whether worksheet has tiers or not", () {
        test("Value should be false when there are no tiers", () {
          service.lineItems.clear();
          expect(service.hasTiers, isFalse);
        });

        test("Value should be false when there are line items only", () {
          service.lineItems = [lineItem, lineItem2];
          expect(service.hasTiers, isFalse);
        });

        test("Value should be true when there are tiers", () {
          service.lineItems = [tier1];
          expect(service.hasTiers, isTrue);
        });

        test("Value should be true when there are tiers with items", () {
          service.lineItems = [tier1..subItems = [lineItem]];
          expect(service.hasTiers, isTrue);
        });
      });

      group("WorksheetFormService@isUnsavedForm should decide whether worksheet is opened from auto saved file", () {
        test("Value should be true when worksheet is opened from auto saved file", () {
          service.dbUnsavedResourceId = 5;
          expect(service.isUnsavedForm, isTrue);
        });

        test("Value should be false when worksheet is opened in normal mode", () {
          service.dbUnsavedResourceId = null;
          expect(service.isUnsavedForm, isFalse);
        });
      });
    });
  });

  group('setAllSrsProductDetails', () {
    setUp(() =>  service.settings = WorksheetSettingModel());
    test('should update product and notAvailable properties when productCode is found', () {
      productsJson = {
        '12': FinancialProductModel()
      };

      service.setAllSrsProductDetails(lineItem4, productsJson, productsPriceJson, deletedProductIds);

      expect(lineItem4.product, isNotNull);
      expect(lineItem4.product?.notAvailable, isFalse);
    });

    test('should update product.notAvailable property when productCode is not found', () {
      productsJson = {
        'prodCode': FinancialProductModel(),
      };
      lineItem4.product = FinancialProductModel();
      deletedProductIds.add('12');

      service.setAllSrsProductDetails(lineItem4, productsJson, productsPriceJson, deletedProductIds);
      expect(lineItem4.product?.notAvailable, isTrue);
      deletedProductIds.clear();
    });

    test('should set lineitem Unit Cost and Price from available products Price and Selling Price', () {
      productsPriceJson = {
        '12': FinancialProductPrice(
          selllingPrice: '10.99',
          price: '9.09'
        ),
      };
      service.setAllSrsProductDetails(lineItem4, productsJson, productsPriceJson, deletedProductIds);

      expect(lineItem4.unitCost, equals('9.09'));
      expect(lineItem4.price, equals('10.99'));
    });
  });

  group("WorksheetFormService@worksheetJson should set beacon payload correctly while saving worksheet", () {
    group("When beacon is enabled", () {
      setUp(() {
        service.isSRSEnable = false;
        service.settings = settings;
        service.isBeaconEnable = true;
        service.selectedBeaconBranch = SupplierBranchModel(
            branchCode: '123',
            branchId: '456'
        );
        service.selectedBeaconAccount = BeaconAccountModel(
          accountId: 123,
        );
        service.selectedBeaconJob = BeaconJobModel(
            jobNumber: '123'
        );
      });

      test('Beacon branch details should be added correctly', () {
        final payload = service.worksheetJson([]);
        expect(payload['branch_code'], '123');
        expect(payload['branch_id'], '456');
      });

      test('Beacon Account details should be added correctly', () {
        final payload = service.worksheetJson([]);
        expect(payload['beacon_account_id'], 123);
      });

      test('Beacon job details should be added correctly', () {
        final payload = service.worksheetJson([]);
        expect(payload['beacon_job_number'], '123');
      });

      test('For Auto Saved Beacon worksheet, additional details should be saved', () {
        service.dbUnsavedResourceId = 12;
        final payload = service.worksheetJson([], isForUnsavedDB: true);
        expect(payload['is_beacon_enable'], isTrue);
        expect(payload['beacon_branch_model'], isNotNull);
        expect(payload['beacon_job'], isNotNull);
        expect(payload['beacon_account'], isNotNull);
      });

      test('For Normal Beacon worksheet, additional details should not be saved', () {
        service.dbUnsavedResourceId = null;
        final payload = service.worksheetJson([], isForUnsavedDB: false);
        expect(payload['is_beacon_enable'], isNull);
        expect(payload['beacon_branch_model'], isNull);
        expect(payload['beacon_job'], isNull);
        expect(payload['beacon_account'], isNull);
      });
    });

    group("When beacon is not enabled", () {
      setUp(() {
        service.isSRSEnable = true;
        service.settings = settings;
        service.isBeaconEnable = false;
        service.selectedBeaconBranch = null;
        service.selectedBeaconAccount = null;
        service.selectedBeaconJob = null;
      });

      test('Beacon branch details should be added correctly', () {
        final payload = service.worksheetJson([]);
        expect(payload['branch_code'], isNull);
        expect(payload['branch_id'], isEmpty);
      });

      test('Beacon Account details should be added correctly', () {
        final payload = service.worksheetJson([]);
        expect(payload['beacon_account_id'], isNull);
      });

      test('Beacon job details should be added correctly', () {
        final payload = service.worksheetJson([]);
        expect(payload['beacon_job_number'], isNull);
      });
    });
  });

  group("WorksheetFormService@isPlaceBeaconOrder should decide whether place Beacon order action should be displayed or not", () {
    test("Action should not be displayed when worksheet is or type work order", () {
      service.worksheetType = WorksheetConstants.workOrder;
      expect(service.isPlaceBeaconOrder(), false);
    });

    test("Action should not be displayed when Beacon is not connected", () {
      ConnectedThirdPartyService.setConnectedParty({
        ConnectedThirdPartyConstants.beacon : false
      });
      expect(service.isPlaceBeaconOrder(), false);
    });

    test("Action should not be displayed when supplier id of material do not matches", () {
      service.workSheet = worksheet;
      service.workSheet?.materialList = LinkedMaterialModel(
          id: 5
      );
      expect(service.isPlaceBeaconOrder(), false);
    });

    test("Action should not be displayed when adding a new worksheet", () {
      service.formType = WorksheetFormType.add;
      expect(service.isPlaceBeaconOrder(), false);
    });

    test("Action should not be displayed when Beacon is not enabled", () {
      service.isBeaconEnable = false;
      expect(service.isPlaceBeaconOrder(), false);
    });

    test("Action should be displayed if all the above conditions are false", () {
      service.worksheetType = WorksheetConstants.materialList;
      service.isBeaconEnable = true;
      ConnectedThirdPartyService.setConnectedParty({
        ConnectedThirdPartyConstants.beacon : true
      });
      service.workSheet?.materialList = LinkedMaterialModel(
          forSupplierId: Helper.getSupplierId(key: CommonConstants.beaconId)
      );
      service.formType = WorksheetFormType.edit;
      expect(service.isPlaceBeaconOrder(), true);
      service.isBeaconEnable = false;
    });
  });

  group('WorksheetFormService@getSelectedBranch should give the branch as per active supplier', () {
    setUp(() {
      service.selectedSrsBranch = SupplierBranchModel();
      service.selectedBeaconBranch = SupplierBranchModel();
    });

    test('Returns selected SRS branch when SRS is enabled', () {
      service.isSRSEnable = true;
      SupplierBranchModel? branch = service.getSelectedBranch();
      expect(branch, equals(service.selectedSrsBranch));
      service.isSRSEnable = false;
    });

    test('Returns selected Beacon branch when Beacon is enabled', () {
      service.isBeaconEnable = true;
      SupplierBranchModel? branch = service.getSelectedBranch();
      expect(branch, equals(service.selectedBeaconBranch));
      service.isBeaconEnable = false;
    });

    test('Returns null when neither SRS nor Beacon is enabled', () {
      service.isSRSEnable = false;
      service.isBeaconEnable = false;
      SupplierBranchModel? branch = service.getSelectedBranch();
      expect(branch, isNull);
    });
  });

  group('WorksheetFormService@getSelectedSupplier should give the selected material supplier type based on the enabled supplier', () {
    test('Returns MaterialSupplierType.srs when SRS is enabled', () {
      service.isSRSEnable = true;
      MaterialSupplierType? supplier = service.getSelectedSupplier();
      expect(supplier, equals(MaterialSupplierType.srs));
      service.isSRSEnable = false;
    });

    test('Returns MaterialSupplierType.beacon when Beacon is enabled', () {
      service.isBeaconEnable = true;
      MaterialSupplierType? supplier = service.getSelectedSupplier();
      expect(supplier, equals(MaterialSupplierType.beacon));
      service.isBeaconEnable = false;
    });

    test('Returns MaterialSupplierType.abc when ABC is enabled', () {
      service.isAbcEnable = true;
      MaterialSupplierType? supplier = service.getSelectedSupplier();
      expect(supplier, equals(MaterialSupplierType.abc));
      service.isAbcEnable = false;
    });

    test('Returns null when neither SRS nor Beacon and ABC is enabled', () {
      service.isSRSEnable = false;
      service.isBeaconEnable = false;
      service.isAbcEnable = false;
      MaterialSupplierType? supplier = service.getSelectedSupplier();
      expect(supplier, isNull);
    });
  });

  group('WorksheetFormService@getActiveSupplierId should give the active supplier ID', () {
    test('Returns SRS supplier ID when SRS is enabled', () {
      service.isSRSEnable = true;
      service.isBeaconEnable = false;
      String? supplierId = service.getActiveSupplierId();
      expect(supplierId, equals(CommonConstants.srsId));
    });

    test('Returns Beacon supplier ID when Beacon is enabled', () {
      service.isSRSEnable = false;
      service.isBeaconEnable = true;
      String? supplierId = service.getActiveSupplierId();
      expect(supplierId, equals(CommonConstants.beaconId));
    });

    test('Returns null when neither SRS nor Beacon is enabled', () {
      service.isSRSEnable = false;
      service.isBeaconEnable = false;
      String? supplierId = service.getActiveSupplierId();
      expect(supplierId, isNull);
    });
  });

  group('WorksheetFormService@setSupplierDetails should set supplier details as per supplier type', () {
    setUp(() {
      worksheet.srsShipToAddressModel = SrsShipToAddressModel();
      worksheet.beaconAccountModel = BeaconAccountModel();
      worksheet.beaconJob = BeaconJobModel();
      worksheet.supplierBranch = SupplierBranchModel();
      service.workSheet = worksheet;
    });

    test('Does not set any details when neither SRS nor Beacon supplier is activated for worksheet', () {
      worksheet.supplierType = null;
      service.setSupplierDetails();
      expect(service.isSRSEnable, isFalse);
      expect(service.isBeaconEnable, isFalse);
      expect(service.selectedSrsBranch, isNull);
      expect(service.selectedSrsShipToAddress, isNull);
      expect(service.selectedBeaconBranch, isNull);
      expect(service.selectedBeaconAccount, isNull);
      expect(service.selectedBeaconJob, isNull);
    });

    test('Sets SRS details when SRS supplier is activated for worksheet', () {
      worksheet.supplierType = MaterialSupplierType.srs;
      service.setSupplierDetails();
      expect(service.isSRSEnable, isTrue);
      expect(service.selectedSrsBranch, equals(worksheet.supplierBranch));
      expect(service.selectedSrsShipToAddress, equals(worksheet.srsShipToAddressModel));
    });

    test('Sets Beacon details when Beacon supplier is activated for worksheet', () {
      worksheet.supplierType = MaterialSupplierType.beacon;
      service.setSupplierDetails();
      expect(service.isBeaconEnable, isTrue);
      expect(service.selectedBeaconBranch, equals(worksheet.supplierBranch));
      expect(service.selectedBeaconAccount, equals(worksheet.beaconAccountModel));
      expect(service.selectedBeaconJob, equals(worksheet.beaconJob));
    });
  });

  test('WorksheetFormService@resetSupplier should resets all supplier details when called', () {
    worksheet.srsShipToAddressModel = SrsShipToAddressModel();
    worksheet.beaconAccountModel = BeaconAccountModel();
    worksheet.beaconJob = BeaconJobModel();
    worksheet.supplierBranch = SupplierBranchModel();
    service.isSRSEnable = true;
    service.isBeaconEnable = true;

    service.resetSupplier();

    expect(service.selectedSrsShipToAddress, isNull);
    expect(service.selectedSrsBranch, isNull);
    expect(service.selectedBeaconAccount, isNull);
    expect(service.selectedBeaconBranch, isNull);
    expect(service.selectedBeaconJob, isNull);
    expect(service.isSRSEnable, isFalse);
    expect(service.isBeaconEnable, isFalse);
  });

  group('WorksheetFormService@setWorksheetSupplier should set worksheet supplier', () {
    test("Supplier type should be SRS when Ship To Address is available", () {
      worksheet.setWorksheetSupplier({
        'srs_ship_to_address': SrsShipToAddressModel().toJson(),
      });
      expect(worksheet.supplierType, MaterialSupplierType.srs);
    });

    test("Supplier type should be Beacon when Account is available", () {
      worksheet.setWorksheetSupplier({
        'beacon_account': BeaconAccountModel().toJson(),
      });
      expect(worksheet.supplierType, MaterialSupplierType.beacon);
    });

    test("Supplier type should be ABC when Account is available", () {
      worksheet.setWorksheetSupplier({
        'supplier_account': SrsShipToAddressModel().toJson(),
      });
      expect(worksheet.supplierType, MaterialSupplierType.abc);
    });

    test("Supplier type should be ABC when Supplier Account Id and ABC Suppliers are available", () {
      service.workSheet?.suppliers = [SuppliersModel(id: 188)];
      worksheet.setWorksheetSupplier({
        'supplier_account_id': 1233
      });
      expect(worksheet.supplierType, MaterialSupplierType.abc);
    });

    test("Supplier type should be null when neither SRS nor Beacon is available", () {
      service.workSheet?.suppliers = null;
      worksheet.setWorksheetSupplier({});
      expect(worksheet.supplierType, isNull);
    });
  });

  group("WorksheetFormService@getRemoveSupplierConfirmation should show remove supplier confirmation before removing all supplier products", () {
    test("Switching from SRS to Beacon when SRS products are added", () {
      service.isSRSEnable = true;
      service.lineItems = [
        lineItem..supplier = SuppliersModel(
            id: Helper.getSupplierId(key: CommonConstants.srsId)
        )
      ];
      final result = service.getRemoveSupplierConfirmation(makeProductCheck: true);
      expect(result, 'deactivate_srs_dialog_with_products_message'.tr);
      service.isSRSEnable = false;
    });

    test("Switching from SRS to Beacon when SRS products are not added", () {
      service.isSRSEnable = true;
      service.lineItems = [
        lineItem..supplier = SuppliersModel(id: null)
      ];
      final result = service.getRemoveSupplierConfirmation(makeProductCheck: true);
      expect(result, 'deactivate_srs_dialog_message'.tr);
      service.isSRSEnable = false;
    });

    test("Switching from Beacon to SRS when Beacon products are added", () {
      service.isBeaconEnable = true;
      service.lineItems = [
        lineItem..supplier = SuppliersModel(
            id: Helper.getSupplierId(key: CommonConstants.beaconId)
        )
      ];
      final result = service.getRemoveSupplierConfirmation(makeProductCheck: true);
      expect(result, 'deactivate_beacon_dialog_with_products_message'.tr);
      service.isBeaconEnable = false;
    });

    test("Switching from Beacon to SRS when Beacon products are not added", () {
      service.isBeaconEnable = true;
      service.lineItems = [
        lineItem..supplier = SuppliersModel(
            id: Helper.getSupplierId(key: null)
        )
      ];
      final result = service.getRemoveSupplierConfirmation(makeProductCheck: true);
      expect(result, 'deactivate_beacon_dialog_message'.tr);
      service.isBeaconEnable = false;
    });
  });

  group("WorksheetFormService@setUpSupplier should set up supplier when activated", () {
    group("When SRS supplier is activated", () {
      setUp(() {
        service.resetSupplier();
        service.settings = settings;
        service.setUpSupplier(MaterialSupplierType.srs, MaterialSupplierFormParams(
          type: MaterialSupplierType.srs,
          srsShipToAddress: SrsShipToAddressModel(),
          srsBranch: SupplierBranchModel(),
        ));
      });

      test("SRS should be enabled with SRS details", () {
        expect(service.isSRSEnable, isTrue);
        expect(service.selectedSrsShipToAddress, isNotNull);
        expect(service.selectedSrsBranch, isNotNull);
      });

      test("Beacon & ABC details should be removed", () {
        expect(service.selectedBeaconAccount, isNull);
        expect(service.selectedBeaconBranch, isNull);
        expect(service.selectedAbcAccount, isNull);
        expect(service.selectedAbcBranch, isNull);
      });
    });

    group("When Beacon supplier is activated", () {
      setUp(() {
        service.resetSupplier();
        service.settings = settings;
        service.setUpSupplier(MaterialSupplierType.beacon, MaterialSupplierFormParams(
          type: MaterialSupplierType.beacon,
          beaconAccount: BeaconAccountModel(),
          beaconBranch: SupplierBranchModel(),
          beaconJob: BeaconJobModel(),
        ));
      });

      test("Beacon should be enabled with Beacon details", () {
        expect(service.isBeaconEnable, isTrue);
        expect(service.selectedBeaconAccount, isNotNull);
        expect(service.selectedBeaconBranch, isNotNull);
        expect(service.selectedBeaconJob, isNotNull);
      });

      test("SRS & ABC details should be removed", () {
        expect(service.selectedSrsShipToAddress, isNull);
        expect(service.selectedSrsBranch, isNull);
        expect(service.selectedAbcAccount, isNull);
        expect(service.selectedAbcBranch, isNull);
      });
    });

    group("When ABC supplier is activated", () {
      setUp(() {
        service.resetSupplier();
        service.settings = settings;
        service.setUpSupplier(MaterialSupplierType.abc, MaterialSupplierFormParams(
          type: MaterialSupplierType.abc,
          abcAccount: SrsShipToAddressModel(),
          abcBranch: SupplierBranchModel(),
        ));
      });

      test("ABC should be enabled with ABC details", () {
        expect(service.isAbcEnable, isTrue);
        expect(service.selectedAbcAccount, isNotNull);
        expect(service.selectedAbcBranch, isNotNull);
      });

      test("SRS & Beacon details should be removed", () {
        expect(service.selectedSrsShipToAddress, isNull);
        expect(service.selectedSrsBranch, isNull);
        expect(service.selectedBeaconAccount, isNull);
        expect(service.selectedBeaconBranch, isNull);
      });
    });
  });

  group("WorksheetFormService@removeSupplierProducts should remove supplier products from the selected products", () {
    group("In case of there are no tiers", () {
      setUp(() {
        service.lineItems = [
          lineItem..supplier = null,
          lineItem2..supplier = SuppliersModel(id: Helper.getSupplierId(key: CommonConstants.srsId)),
          lineItem3..supplier = SuppliersModel(id: Helper.getSupplierId(key: CommonConstants.beaconId)),
          lineItem4..supplier = SuppliersModel(id: Helper.getSupplierId(key: CommonConstants.abcSupplierId)),
        ];
      });

      test("When SRS is enabled", () {
        service.isSRSEnable = true;
        service.isBeaconEnable = false;
        service.isAbcEnable = false;
        service.removeSupplierProducts();
        expect(service.lineItems.length, 2);
      });

      test("When Beacon is enabled", () {
        service.isSRSEnable = false;
        service.isBeaconEnable = true;
        service.isAbcEnable = false;
        service.removeSupplierProducts();
        expect(service.lineItems.length, 2);
      });

      test("When ABC is enabled", () {
        service.isSRSEnable = false;
        service.isBeaconEnable = false;
        service.isAbcEnable = true;
        service.removeSupplierProducts();
        expect(service.lineItems.length, 2);
      });
    });

    group("In case there are tiers", () {
      setUp(() {
        service.lineItems = [
          tier1..subItems = [
            lineItem,
            lineItem2..supplier = SuppliersModel(id: Helper.getSupplierId(key: CommonConstants.srsId)),
            lineItem3..supplier = SuppliersModel(id: Helper.getSupplierId(key: CommonConstants.beaconId)),
            lineItem4..supplier = SuppliersModel(id: Helper.getSupplierId(key: CommonConstants.abcSupplierId)),
          ],
        ];
      });

      test("When SRS is enabled", () {
        service.isSRSEnable = true;
        service.isBeaconEnable = false;
        service.isAbcEnable = false;
        service.removeSupplierProducts();
        expect(service.lineItems.length, 1);
        expect(service.lineItems[0].subItems?.length, 2);
      });

      test("When Beacon is enabled", () {
        service.isSRSEnable = false;
        service.isBeaconEnable = true;
        service.isAbcEnable = false;
        service.removeSupplierProducts();
        expect(service.lineItems.length, 1);
        expect(service.lineItems[0].subItems?.length, 2);
      });

      test("When ABC is enabled", () {
        service.isSRSEnable = false;
        service.isBeaconEnable = false;
        service.isAbcEnable = true;
        service.removeSupplierProducts();
        expect(service.lineItems.length, 1);
        expect(service.lineItems[0].subItems?.length, 2);
      });
    });
  });

  group("WorksheetFormService@getPriceListParams should generate correct payload for requesting product price", () {
    setUp(() {
      service.selectedSrsBranch = SupplierBranchModel(branchCode: '200');
      service.selectedBeaconBranch = SupplierBranchModel(branchCode: '300');
      service.selectedSrsShipToAddress = SrsShipToAddressModel(id: 1);
      service.selectedBeaconAccount = BeaconAccountModel(id: 1);
      service.selectedBeaconJob = BeaconJobModel(jobNumber: '123');
      service.srsSupplierId = null;
    });

    test('Price list payload for SRS should be generated correctly', () {
      service.isSRSEnable = true;
      List<FinancialProductModel> list = [FinancialProductModel(code: 'code1', unit: 'unit1')];
      Map<String, dynamic> params = service.getPriceListParams(list);
      expect(params['branch_code'], equals(service.selectedSrsBranch?.branchCode));
      expect(params['ship_to_sequence_number'], equals(service.selectedSrsShipToAddress?.id));
      expect(params['item_detail'], equals([{'item_code': 'code1', 'unit': 'unit1'}]));
      service.isSRSEnable = false;
    });

    test('Price list payload for SRS v2 should be generated correctly', () {
      final srsV2FlagDetails = LDFlags.allFlags[LDFlagKeyConstants.srsV2MaterialIntegration];
      service.isSRSEnable = true;
      service.srsSupplierId = 181; // SRS v2 id
      List<FinancialProductModel> list = [FinancialProductModel(code: 'code1', unit: 'unit1')];
      Map<String, dynamic> params = service.getPriceListParams(list);
      expect(params['branch_code'], equals(service.selectedSrsBranch?.branchCode));
      expect(params['ship_to_sequence_number'], equals(service.selectedSrsShipToAddress?.id));
      expect(params['product_detail'], equals([{'item_code': 'code1', 'unit': 'unit1'}]));
      service.isSRSEnable = false;
      srsV2FlagDetails?.value = null;
    });

    test('Price list payload for Beacon should be generated correctly', () {
      service.isBeaconEnable = true;
      List<FinancialProductModel> list = [FinancialProductModel(variants: [
        VariantModel(code: 'code2')
      ])];
      Map<String, dynamic> params = service.getPriceListParams(list);
      expect(params['branch_code'], equals(service.selectedBeaconBranch?.branchCode));
      expect(params['job_number'], equals(service.selectedBeaconJob?.jobNumber));
      expect(params['item_detail'], equals([{'item_code': 'code2'}]));
      service.isBeaconEnable = false;
    });
  });

  group("WorksheetFormService@onTapTierSubTotal should update selected Tier Sub Total", () {
    test("Default selected tier subtotals option should be [sub-total]", () {
      expect(service.selectedTierSubTotal, WorksheetConstants.tierSubTotal);
    });

    test("Tier sub totals option should update to selected option", () {
      service.onTapTierSubTotal(service.getTierSubTotalsActions()[2]);
      expect(service.selectedTierSubTotal, WorksheetConstants.tierProfit);
    });
  });

  group("WorksheetFormService@doShowTierSubTotals should decide whether subtotals should be displayed on tiers", () {
    group("Tier sub totals options should not be displayed", () {
      test("When [LDFlagKeyConstants.metroBathFeature] feature is not enabled", () {
        LDFlags.metroBathFeature.value = false;
        service.settings?.showTierSubTotals = true;
        service.settings?.hidePricing = true;
        service.settings?.addLineItemTax = false;
        service.settings?.applyLineItemProfit = false;
        expect(service.doShowTierSubTotals(), isFalse);
      });

      test("When [showTierSubtotals] property is false", () {
        LDFlags.metroBathFeature.value = true;
        service.settings?.showTierSubTotals = false;
        service.settings?.hidePricing = true;
        expect(service.doShowTierSubTotals(), isFalse);
      });

      test("When [hidePricing] property is true", () {
        LDFlags.metroBathFeature.value = true;
        service.settings?.showTierSubTotals = true;
        service.settings?.hidePricing = false;
        expect(service.doShowTierSubTotals(), isFalse);
      });

      test("When line item tax or profit property is true", () {
        LDFlags.metroBathFeature.value = true;
        service.settings?.showTierSubTotals = true;
        service.settings?.addLineItemTax = false;
        service.settings?.applyLineItemProfit = false;
        expect(service.doShowTierSubTotals(), isFalse);
      });
    });

    test('Tier sub total should be disabled when all of the required conditions are met', () {
      LDFlags.metroBathFeature.value = true;
      service.settings?.showTierSubTotals = true;
      service.settings?.hidePricing = false;
      service.settings?.applyLineItemProfit = true;
      expect(service.doShowTierSubTotals(), isTrue);
    });
  });

  group("WorksheetFormService@getTierSubtotalTitle should give tier subtotals title", () {
    group("In case of profit Margin/Markup should be appended with title", () {
      test("When Markup profit is applied", () {
        service.settings?.isLineItemProfitMarkup = true;
        final result = service.getTierSubtotalTitle(WorksheetConstants.tierProfit);
        expect(result, equals("${WorksheetConstants.tierProfit.tr} (${'markup'.tr}) :"));
      });

      test("When Margin profit is applied", () {
        service.settings?.isLineItemProfitMarkup = false;
        final result = service.getTierSubtotalTitle(WorksheetConstants.tierProfit);
        expect(result, equals("${WorksheetConstants.tierProfit.tr} (${'margin'.tr}) :"));
      });
    });

    test("In other cases title should be displayed as it is", () {
      final result1 = service.getTierSubtotalTitle(WorksheetConstants.tierSubTotal);
      final result2 = service.getTierSubtotalTitle(WorksheetConstants.tierLineTotal);
      final result3 = service.getTierSubtotalTitle(WorksheetConstants.tierTax);
      expect(result1, equals("${WorksheetConstants.tierSubTotal.tr}:"));
      expect(result2, equals("${WorksheetConstants.tierLineTotal.tr}:"));
      expect(result3, equals("${WorksheetConstants.tierTax.tr}:"));
    });
  });

  group("WorksheetFormService@getTierSubtotalTitle should give tier subtotal's amount", () {
    test("In case of profit, amount for profit should be given", () {
      final result = service.getTierSubTotalAmount(WorksheetConstants.tierProfit, lineItem
          ..lineProfitAmt = '100'
      );
      expect(result, equals("100"));
    });

    test("In case of tax, amount for tax should be given", () {
      final result = service.getTierSubTotalAmount(WorksheetConstants.tierTax, lineItem
        ..lineTaxAmt = '200'
      );
      expect(result, equals("200"));
    });

    test("In case of line total, amount for line total should be given", () {
      final result = service.getTierSubTotalAmount(WorksheetConstants.tierLineTotal, lineItem
        ..tiersLineTotal = '300'
      );
      expect(result, equals("300"));
    });

    test("In case of sub total, amount for sub total should be given", () {
      final result = service.getTierSubTotalAmount(WorksheetConstants.tierSubTotal, lineItem
        ..totalPrice = '400'
      );
      expect(result, equals("400"));
    });
  });

  group('WorksheetFormService@updateSellingPriceUnavailability', () {
    test('sets isSellingPriceNotAvailable to true if price is null', () {
      items[0].price = null;
      service.updateSellingPriceUnavailability(items);

      expect(items[0].product?.isSellingPriceNotAvailable, true);
    });

    test('sets isSellingPriceNotAvailable to true if price is empty', () {
      items[0].price = '';
      service.updateSellingPriceUnavailability(items);

      expect(items[0].product?.isSellingPriceNotAvailable, true);
    });

    test('sets isSellingPriceNotAvailable to true if price is equal to 0', () {
      items[0].price = '0';
      service.updateSellingPriceUnavailability(items);

      expect(items[0].product?.isSellingPriceNotAvailable, true);
    });

    test('sets isSellingPriceNotAvailable to false if price is > 0', () {
      items[0].price = '10';
      service.updateSellingPriceUnavailability(items);

      expect(items[0].product?.isSellingPriceNotAvailable, false);
    });

    test('sets isSellingPriceNotAvailable to false if price is less than 0', () {
      items[0].price = '-10';
      service.updateSellingPriceUnavailability(items);

      expect(items[0].product?.isSellingPriceNotAvailable, false);
    });

    test('updates isSellingPriceNotAvailable correctly for multiple items', () {
      var items = [
        SheetLineItemModel(
            title: 'Title',
            qty: '1',
            totalPrice: '1.0',
            productId: '1',
            product: FinancialProductModel(isSellingPriceNotAvailable: false),
            price: '1'
        ),
        SheetLineItemModel(
            title: 'Title',
            qty: '1',
            totalPrice: '1.0',
            productId: '1',
            product: FinancialProductModel(isSellingPriceNotAvailable: false),
            price: ''
        ),
        SheetLineItemModel(
            title: 'Title',
            qty: '1',
            totalPrice: '1.0',
            productId: '1',
            product: FinancialProductModel(isSellingPriceNotAvailable: true),
            price: '0'),
      ];

      service.updateSellingPriceUnavailability(items);

      expect(items[0].product?.isSellingPriceNotAvailable, false);
      expect(items[1].product?.isSellingPriceNotAvailable, true);
      expect(items[2].product?.isSellingPriceNotAvailable, true);
    });
  });

  group("WorksheetFormService@checkAnyTierWithWarning should help in displaying a warning in case Macro is missing from Tier", () {
    test("Warning message should not be displayed if there are no tiers", () {
      service.lineItems.clear();
      service.checkAnyTierWithWarning();
      expect(service.isAnyTierWithWarning, isFalse);
    });

    test("Warning message should not be displayed if there are no tiers missing macro", () {
      service.lineItems = [
        tier1
        ..type = WorksheetConstants.collection
        ..isMacroNotFound = false
        ..subItems = [lineItem]
      ];
      service.checkAnyTierWithWarning();
      expect(service.isAnyTierWithWarning, isFalse);
    });

    test("Warning message should be displayed if there are tiers missing macro and there are no sub-items", () {
      service.lineItems = [
        tier1
          ..type = WorksheetConstants.collection
          ..isMacroNotFound = true
          ..subItems = []
      ];
      service.checkAnyTierWithWarning();
      expect(service.isAnyTierWithWarning, isTrue);
    });

    test("Warning message should be displayed if there are tiers missing macro and there are no sub-tiers", () {
      service.lineItems = [
        tier1
          ..type = WorksheetConstants.collection
          ..isMacroNotFound = true
          ..subTiers = []
      ];
      service.checkAnyTierWithWarning();
      expect(service.isAnyTierWithWarning, isTrue);
    });

    test("Warning message should not be displayed if there are tiers missing macro and there are no sub-tiers or sub items", () {
      service.lineItems = [
        tier1
          ..type = WorksheetConstants.collection
          ..isMacroNotFound = true
          ..subTiers = [lineItem]
      ];
      service.checkAnyTierWithWarning();
      expect(service.isAnyTierWithWarning, isFalse);
    });
  });

  group("WorksheetFormService@isPlaceABCOrder should decide whether place ABC order action should be displayed or not", () {
    test("Action should not be displayed when worksheet is or type work order", () {
      service.worksheetType = WorksheetConstants.workOrder;
      expect(service.isPlaceABCOrder(), false);
    });

    test("Action should not be displayed when ABC is not connected", () {
      ConnectedThirdPartyService.setConnectedParty({
        ConnectedThirdPartyConstants.abc : false
      });
      expect(service.isPlaceABCOrder(), false);
    });

    test("Action should not be displayed when supplier id of material do not matches", () {
      service.workSheet = worksheet;
      service.workSheet?.materialList = LinkedMaterialModel(
          id: 5
      );
      expect(service.isPlaceABCOrder(), false);
    });

    test("Action should not be displayed when adding a new worksheet", () {
      service.formType = WorksheetFormType.add;
      expect(service.isPlaceABCOrder(), false);
    });

    test("Action should not be displayed when ABC is not enabled", () {
      service.isAbcEnable = false;
      expect(service.isPlaceABCOrder(), false);
    });

    test("Action should be displayed if all the above conditions are false", () {
      service.worksheetType = WorksheetConstants.materialList;
      service.isAbcEnable = true;
      ConnectedThirdPartyService.setConnectedParty({
        ConnectedThirdPartyConstants.abc : true
      });
      service.workSheet?.materialList = LinkedMaterialModel(
          forSupplierId: Helper.getSupplierId(key: CommonConstants.abcSupplierId)
      );
      service.formType = WorksheetFormType.edit;
      LDFlags.allFlags[LDFlagKeyConstants.abcMaterialIntegration]?.value = true;
      expect(service.isPlaceABCOrder(), true);
      service.isAbcEnable = false;
    });
  });

  group('WorksheetFormService@getStickySelectedTrade should give default trade type to be populated in add item sheet', () {
    setUp(() {
      service.job = jobModel;
      service.settings = settings;
    });

    group("When there is at least one line item added already", () {
      test("When there is only one line item, trade should be picked from it", () {
        lineItem.tradeType = JPSingleSelectModel(label: "Trade 1", id: "1");
        service.lineItems = [
          lineItem
        ];

        CompanyTradesModel? trade = service.getStickySelectedTrade();
        expect(trade?.name, lineItem.tradeType?.label);
        expect(trade?.id.toString(), lineItem.tradeType?.id);
      });

      test("When there are multiple line items, trade should be picked from last added line item", () {
        lineItem.tradeType = JPSingleSelectModel(label: "Trade 1", id: "1");
        lineItem2.tradeType = JPSingleSelectModel(label: "Trade 2", id: "2");
        service.lineItems = [
          lineItem,
          lineItem2,
        ];

        CompanyTradesModel? trade = service.getStickySelectedTrade();
        expect(trade?.name, lineItem2.tradeType?.label);
        expect(trade?.id.toString(), lineItem2.tradeType?.id);
      });

      test("When there is only one line item, trade should be picked from it, even if it is none", () {
        lineItem.tradeType = null;
        service.lineItems = [
          lineItem
        ];

        CompanyTradesModel? trade = service.getStickySelectedTrade();
        expect(trade?.name, null);
        expect(trade?.id.toString(), null);
      });

      test("When there are multiple line items, trade should be picked from the last trade type, even if it is none", () {
        lineItem.tradeType = JPSingleSelectModel(label: "Trade 1", id: "1");
        lineItem2.tradeType = null;
        service.lineItems = [
          lineItem,
          lineItem2,
        ];

        CompanyTradesModel? trade = service.getStickySelectedTrade();
        expect(trade?.name, null);
        expect(trade?.id.toString(), null);
      });
    });

    group("When there is no line item added yet", () {
      test("Trade type should not be populated if Default Trade Type is none", () {
        service.lineItems = [];
        service.settings?.tradeTypeDefaultDetails = WorksheetTradeTypeDefault(isNone: true);
        CompanyTradesModel? trade = service.getStickySelectedTrade();

        expect(trade, null);
      });

      group("Trade type should be populated if Default Trade Type is inherit from job", () {
        test("When Job has only one trade type, trade type should be populated", () {
          service.lineItems = [];
          service.job?.trades = [
            CompanyTradesModel(id: 1, name: "Trade 1")
          ];
          service.settings?.tradeTypeDefaultDetails = WorksheetTradeTypeDefault(inheritFromJob: true);
          CompanyTradesModel? trade = service.getStickySelectedTrade();

          expect(trade?.name, service.job?.trades?[0].name);
          expect(trade?.id, service.job?.trades?[0].id);
        });

        group("'ROOFING' trade type be prioritized over others", () {
          test("When Job has multiple trades, trade type should be picked from ROOFING if available", () {
            service.lineItems = [];
            service.job?.trades = [
              CompanyTradesModel(id: 1, name: "Trade 1"),
              CompanyTradesModel(id: 2, name: "ROOFING"),
              CompanyTradesModel(id: 3, name: "Trade 3"),
            ];
            service.settings?.tradeTypeDefaultDetails = WorksheetTradeTypeDefault(inheritFromJob: true);
            CompanyTradesModel? trade = service.getStickySelectedTrade();

            expect(trade?.name, service.job?.trades?[1].name);
            expect(trade?.id, service.job?.trades?[1].id);
          });

          test("When Job has multiple trades, trade type should not be picked from ROOFING & SIDING if available", () {
            service.lineItems = [];
            service.job?.trades = [
              CompanyTradesModel(id: 1, name: "Trade 1"),
              CompanyTradesModel(id: 2, name: "ROOFING & SIDING"),
              CompanyTradesModel(id: 3, name: "Trade 3"),
            ];
            service.settings?.tradeTypeDefaultDetails = WorksheetTradeTypeDefault(inheritFromJob: true);
            CompanyTradesModel? trade = service.getStickySelectedTrade();

            expect(trade?.name, service.job?.trades?[0].name);
            expect(trade?.id, service.job?.trades?[0].id);
          });

          test("In case ROOFING trade does not exist, trade type should be picked from first trade", () {
            service.lineItems = [];
            service.job?.trades = [
              CompanyTradesModel(id: 1, name: "Trade 1"),
              CompanyTradesModel(id: 2, name: "Trade 2"),
              CompanyTradesModel(id: 3, name: "Trade 3"),
            ];
            service.settings?.tradeTypeDefaultDetails = WorksheetTradeTypeDefault(inheritFromJob: true);
            CompanyTradesModel? trade = service.getStickySelectedTrade();

            expect(trade?.name, service.job?.trades?[0].name);
            expect(trade?.id, service.job?.trades?[0].id);
          });
        });
      });

      test("Trade type should be populated if Default Trade Type is set", () {
        service.lineItems = [];
        service.settings?.tradeTypeDefaultDetails = WorksheetTradeTypeDefault(trade: CompanyTradesModel(id: 1, name: "Trade 1"));
        CompanyTradesModel? trade = service.getStickySelectedTrade();

        expect(trade?.name, service.settings?.tradeTypeDefaultDetails?.trade?.name);
        expect(trade?.id, service.settings?.tradeTypeDefaultDetails?.trade?.id);
      });

      test("Trade type should be none if Default Trade Type is not set and job has no trades", () {
        service.lineItems = [];
        service.job?.trades = [];
        service.settings?.tradeTypeDefaultDetails = WorksheetTradeTypeDefault(inheritFromJob: true);
        CompanyTradesModel? trade = service.getStickySelectedTrade();

        expect(trade, null);
      });
    });
  });

  group('WorksheetFormData@setLineItemsFromWorSheet should set line items from worksheet', () {
    test('When removeIntegratedSupplierItems is set to false, line items should be set normally', () {
      service.removeIntegratedSupplierItems = false;
      service.setLineItemsFromWorkSheet(items);
      expect(service.lineItems.length, 1);
    });

    test('When removeIntegratedSupplierItems is set to true, Integrated supplier items should be removed', () {
      service.removeIntegratedSupplierItems = true;
      items[0].supplierId = '173'; // Integrated Beacon supplier id
      service.setLineItemsFromWorkSheet(items);
      expect(service.lineItems, isEmpty);
    });
  });

  group('WorksheetFormData@isPlaceSupplierOrder should decide whether place supplier order action should be displayed or not', () {
    setUpAll(() {
      service.workSheet = worksheet;
    });
    
    test('When supplier order is SRS', () {
      service.worksheetType = WorksheetConstants.materialList;
      service.isSRSEnable = true;
      ConnectedThirdPartyService.setConnectedParty({
        ConnectedThirdPartyConstants.srs : true
      });
      service.workSheet?.materialList = LinkedMaterialModel(
          forSupplierId: Helper.getSupplierId()
      );
      service.formType = WorksheetFormType.edit;
      expect(service.isPlaceSupplierOrder(), true);
    });

    test('When supplier order is QXO', () {
      service.worksheetType = WorksheetConstants.materialList;
      service.isBeaconEnable = true;
      ConnectedThirdPartyService.setConnectedParty({
        ConnectedThirdPartyConstants.beacon : true
      });
      service.workSheet?.materialList = LinkedMaterialModel(
          forSupplierId: Helper.getSupplierId(key: CommonConstants.beaconId)
      );
      service.formType = WorksheetFormType.edit;
      expect(service.isPlaceSupplierOrder(), true);
    });

    test('When supplier order is ABC', () {
      service.worksheetType = WorksheetConstants.materialList;
      service.isAbcEnable = true;
      ConnectedThirdPartyService.setConnectedParty({
        ConnectedThirdPartyConstants.abc : true
      });
      service.workSheet?.materialList = LinkedMaterialModel(
          forSupplierId: Helper.getSupplierId(key: CommonConstants.abcSupplierId)
      );
      service.formType = WorksheetFormType.edit;
      LDFlags.allFlags[LDFlagKeyConstants.abcMaterialIntegration]?.value = true;
      expect(service.isPlaceSupplierOrder(), true);
    });

    test('When supplier order is none', () {
      service.worksheetType = WorksheetConstants.workOrder;
      expect(service.isPlaceSupplierOrder(), false);
    });
  });

  group('Attachment Type Handling Tests', () {
      test('should use dynamic attachment type from attachment model', () {
        // Arrange
        final service = WorksheetFormService(
          update: () {},
          worksheetType: WorksheetConstants.estimate,
          formType: WorksheetFormType.add,
        );
        
        final attachment1 = AttachmentResourceModel(
          id: 1,
          type: 'image',
          name: 'test1.jpg',
        );
        final attachment2 = AttachmentResourceModel(
          id: 2,
          type: 'document',
          name: 'test2.pdf',
        );
        
        service.attachments = [attachment1, attachment2];
        service.getWorksheetSettings();
        
        // Act
        final result = service.worksheetJson([], isPreview: false);
        
        // Assert
        expect(result['attachments'], isA<List<dynamic>>());
        final attachments = result['attachments'] as List<dynamic>;
        expect(attachments.length, equals(2));
        expect(attachments[0]['type'], equals('image'));
        expect(attachments[0]['value'], equals(1));
        expect(attachments[1]['type'], equals('document'));
        expect(attachments[1]['value'], equals(2));
      });
      
      test('should fallback to "resource" when attachment type is null', () {
        // Arrange
        final service = WorksheetFormService(
          update: () {},
          worksheetType: WorksheetConstants.estimate,
          formType: WorksheetFormType.add,
        );
        
        final attachment = AttachmentResourceModel(
          id: 1,
          type: null, // null type should fallback to "resource"
          name: 'test.jpg',
        );
        
        service.attachments = [attachment];
        service.getWorksheetSettings();
        
        // Act
        final result = service.worksheetJson([], isPreview: false);
        
        // Assert
        expect(result['attachments'], isA<List<dynamic>>());
        final attachments = result['attachments'] as List<dynamic>;
        expect(attachments.length, equals(1));
        expect(attachments[0]['type'], equals('resource'));
        expect(attachments[0]['value'], equals(1));
      });
      
      test('should handle multiple attachments with mixed types', () {
        // Arrange
        final service = WorksheetFormService(
          update: () {},
          worksheetType: WorksheetConstants.estimate,
          formType: WorksheetFormType.add,
        );
        
        final attachments = [
          AttachmentResourceModel(id: 1, type: 'image', name: 'test1.jpg'),
          AttachmentResourceModel(id: 2, type: null, name: 'test2.pdf'), // should fallback to "resource"
          AttachmentResourceModel(id: 3, type: 'video', name: 'test3.mp4'),
        ];
        
        service.attachments = attachments;
        service.getWorksheetSettings();
        
        // Act
        final result = service.worksheetJson([], isPreview: false);
        
        // Assert
        expect(result['attachments'], isA<List<dynamic>>());
        final resultAttachments = result['attachments'] as List<dynamic>;
        expect(resultAttachments.length, equals(3));
        expect(resultAttachments[0]['type'], equals('image'));
        expect(resultAttachments[1]['type'], equals('resource')); // fallback
        expect(resultAttachments[2]['type'], equals('video'));
      });
    });
}
