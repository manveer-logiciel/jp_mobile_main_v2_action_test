import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_model.dart';
import 'package:jobprogress/common/models/financial_product/variants_model.dart';
import 'package:jobprogress/common/models/forms/worksheet/add_item.dart';
import 'package:jobprogress/common/models/forms/worksheet/add_item_params.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/suppliers/suppliers.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_detail_category_model.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_item_conditions.dart';
import 'package:jobprogress/core/config/app_env.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/financial_constants.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {

  late WorksheetAddItemData itemData;
  late WorksheetAddItemConditionsService service;

  JPSingleSelectModel selectionOptions = JPSingleSelectModel(
      id: '1',
      label: 'Test category 1'
  );

  WorksheetAddItemParams params = WorksheetAddItemParams(
    allCategories: [selectionOptions],
    allSuppliers: [selectionOptions],
    allTrade: [selectionOptions],
    settings: WorksheetSettingModel(),
    shipToSequenceId: "",
    worksheetType: WorksheetConstants.estimate,
    isSRSEnabled: false,
    lineItem: SheetLineItemModel(
      productId: "1",
      title: "Test Item",
      price: "200",
      qty: "5",
      totalPrice: "1000",
    ),
    srsBranchCode: ""
  );

  FinancialProductModel emptyProduct = FinancialProductModel();
  FinancialProductModel product = emptyProduct;
  FinancialProductModel productWithSupplier = FinancialProductModel(
    supplier: SuppliersModel(
      companyId: 1
    ),
    supplierId: 3
  );
  FinancialProductModel productWithCategory = FinancialProductModel(
      productCategory: WorksheetDetailCategoryModel()
  );
  FinancialProductModel productWithQBD = FinancialProductModel(
    qbDesktopId: '1'
  );

  void setEnv() {
    AppEnv.envConfig[CommonConstants.suppliersIds] = {
      CommonConstants.srsId: 3,
    };
  }

  void setUpService() {
    itemData.product = product;
    service = WorksheetAddItemConditionsService.forItem(itemData);
  }

  setUpAll(() {
    itemData = WorksheetAddItemData(params);
    setUpService();
  });

  test("WorksheetAddItemConditionsService's data extractors should be properly initialized", () {
    expect(service.worksheetType, WorksheetConstants.estimate);
    expect(service.product, isNotNull);
    expect(service.suppliers, isNotEmpty);
    expect(service.settings, isNotNull);
  });

  test("WorksheetAddItemConditionsService's condition helpers should be properly initialized", () {
    expect(service.hasProductCategory, isFalse);
    expect(service.hasProductSupplier, isFalse);
    expect(service.hasProductSupplierCompanyId, isTrue);
    expect(service.hasProductQBDesktopId, isFalse);
    expect(service.isMaterialWorksheet, isFalse);
    expect(service.isMaterialProduct, isFalse);
    expect(service.isNoChargeProduct, isFalse);
    expect(service.hasProductSupplierSRSId, isFalse);
    expect(service.hasProductSupplierBeaconId, isFalse);
    expect(service.isActionForSRSMaterialList, isFalse);
    expect(service.isActionForBeaconMaterialList, isFalse);
  });

  group("WorksheetAddItemConditionsService should properly decide which field to be displayed or not", () {
    group("WorksheetAddItemConditionsService@showCategoryField should decide whether to display category input or not", () {
      group("Category input should not be displayed", () {
        test("When worksheet is of type material", () {
          itemData.params.worksheetType = WorksheetConstants.materialList;
          setUpService();
          expect(service.showCategoryField, isFalse);
        });
      });

      group("Category input should be displayed", () {
        test("When worksheet is of type estimate", () {
          itemData.params.worksheetType = WorksheetConstants.estimate;
          setUpService();
          expect(service.showCategoryField, isTrue);
        });

        test("When worksheet is of type proposal", () {
          itemData.params.worksheetType = WorksheetConstants.proposal;
          setUpService();
          expect(service.showCategoryField, isTrue);
        });

        test("When worksheet is of type work order", () {
          itemData.params.worksheetType = WorksheetConstants.workOrder;
          setUpService();
          expect(service.showCategoryField, isTrue);
        });
      });
    });

    group("WorksheetAddItemConditionsService@disableCategory should conditionally disable category input", () {
      group("Category input should be disabled", () {
        test("When selected product is material and selected product has supplier available", () {
          product = productWithSupplier;
          itemData.selectedCategorySlug = FinancialConstant.material;
          setUpService();
          expect(service.disableCategory, isTrue);
        });
      });

      group("Category input should be enabled", () {
        test("When selected product is not material", () {
          product = productWithSupplier;
          itemData.selectedCategorySlug = FinancialConstant.labor;
          setUpService();
          expect(service.disableCategory, isFalse);
        });

        test("When selected product does not have a supplier", () {
          product = emptyProduct;
          itemData.selectedCategorySlug = FinancialConstant.material;
          setUpService();
          expect(service.disableCategory, isFalse);
        });

        test("When selected product is not material nor selected product has supplier available", () {
          product = emptyProduct;
          itemData.selectedCategorySlug = FinancialConstant.labor;
          setUpService();
          expect(service.disableCategory, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@disableNameField should conditionally disable name input", () {
      group("Name input should be disabled", () {
        test("When worksheet is not of type material or product does not have category available", () {
          itemData.params.worksheetType = WorksheetConstants.estimate;
          product = emptyProduct;
          setUpService();
          expect(service.disableNameField, isTrue);
        });

        test("When product has supplier", () {
          product = productWithSupplier;
          setUpService();
          expect(service.disableNameField, isTrue);
        });

        test("When product has QBD desktop connected", () {
          product = productWithQBD;
          setUpService();
          expect(service.disableNameField, isTrue);
        });
      });

      group("Name input should be enabled", () {
        test("When worksheet is of type material", () {
          itemData.params.worksheetType = WorksheetConstants.materialList;
          product = emptyProduct;
          setUpService();
          expect(service.disableNameField, isFalse);
        });

        test("When product has category available", () {
          product = productWithCategory;
          setUpService();
          expect(service.disableNameField, isFalse);
        });

        test("When product does not have supplier", () {
          product = emptyProduct;
          setUpService();
          expect(service.disableNameField, isFalse);
        });

        test("When product does not have QBD desktop connected", () {
          setUpService();
          expect(service.disableNameField, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@showSupplier should conditionally show supplier input", () {
      group("Supplier input should be shown", () {
        test("When suppliers exists and selected category is of type material", () {
          params.allSuppliers.add(selectionOptions);
          itemData.selectedCategorySlug = FinancialConstant.material;
          setUpService();
          expect(service.showSupplier, isTrue);
        });

        test("When product has supplier and selected category is of type material", () {
          params.allSuppliers.clear();
          product = productWithSupplier;
          itemData.selectedCategorySlug = FinancialConstant.material;
          setUpService();
          expect(service.showSupplier, isTrue);
        });

        test("When suppliers exists and selected worksheet of type material", () {
          params.allSuppliers.add(selectionOptions);
          params.worksheetType = WorksheetConstants.materialList;
          setUpService();
          expect(service.showSupplier, isTrue);
        });

        test("When product has supplier and worksheet is of type material", () {
          params.allSuppliers.clear();
          product = productWithSupplier;
          params.worksheetType = WorksheetConstants.materialList;
          setUpService();
          expect(service.showSupplier, isTrue);
        });
      });

      group("Supplier input should be hidden", () {
        test("When suppliers does not exists and product does not have supplier", () {
          product = emptyProduct;
          params.allSuppliers.clear();
          setUpService();
          expect(service.showSupplier, isFalse);
        });

        test("When worksheet is not of material type and selected category is other than material", () {
          params.worksheetType = WorksheetConstants.materialList;
          itemData.selectedCategorySlug = FinancialConstant.noCharge;
          setUpService();
          expect(service.showSupplier, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@disableSupplier should conditionally disable supplier input", () {
      group("Supplier input should be disabled", () {
        test("When worksheet is of type material and selected product has supplier", () {
          product = productWithSupplier;
          params.worksheetType = WorksheetConstants.materialList;
          setUpService();
          expect(service.disableSupplier, isTrue);
        });

        test("When selected product has category and selected product has supplier", () {
          product = FinancialProductModel(
            productCategory: productWithCategory.productCategory,
            supplier: productWithSupplier.supplier
          );
          setUpService();
          expect(service.disableSupplier, isTrue);
        });
      });

      group("Supplier input should be enabled", () {
        test("When worksheet is material and product does not have supplier", () {
          params.worksheetType = WorksheetConstants.materialList;
          product = emptyProduct;
          setUpService();
          expect(service.disableSupplier, isFalse);
        });

        test("When selected product has category and product does not have supplier", () {
          product = FinancialProductModel(
            productCategory: productWithCategory.productCategory
          );
          setUpService();
          expect(service.disableSupplier, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@disableTradeType should conditionally disable trade type input", () {
      group("Trade type input should be disabled", () {
        test("When worksheet is not material and product does not have category", () {
          params.worksheetType = WorksheetConstants.estimate;
          product = emptyProduct;
          setUpService();
          expect(service.disableTradeType, isTrue);
        });
      });

      group("Trade type input should be enabled", () {
        test("When worksheet is material", () {
          params.worksheetType = WorksheetConstants.materialList;
          product = emptyProduct;
          setUpService();
          expect(service.disableTradeType, isFalse);
        });

        test("When product has category", () {
          params.worksheetType = WorksheetConstants.materialList;
          product = productWithCategory;
          setUpService();
          expect(service.disableTradeType, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@showTypeStyle should conditionally display type style input", () {
      group("Type style input should be displayed", () {
        test("When worksheet is of type material and product supplier has company", () {
          params.worksheetType = WorksheetConstants.materialList;
          product = productWithSupplier;
          setUpService();
          expect(service.showTypeStyle, isTrue);
        });

        test("When selected product is of type material and product supplier has company", () {
          params.worksheetType = WorksheetConstants.estimate;
          itemData.selectedCategorySlug = FinancialConstant.material;
          product = productWithSupplier;
          setUpService();
          expect(service.showTypeStyle, isTrue);
        });

        test("When worksheet is of type material and product does not have supplier", () {
          params.worksheetType = WorksheetConstants.materialList;
          product = emptyProduct;
          setUpService();
          expect(service.showTypeStyle, isTrue);
        });

        test("When selected product is of type material and product does not have supplier", () {
          params.worksheetType = WorksheetConstants.estimate;
          itemData.selectedCategorySlug = FinancialConstant.material;
          product = emptyProduct;
          setUpService();
          expect(service.showTypeStyle, isTrue);
        });
      });

      group("Type type input should be hidden", () {
        test("When worksheet and selected product is not of type material", () {
          params.worksheetType = WorksheetConstants.estimate;
          itemData.selectedCategorySlug = FinancialConstant.overhead;
          product = productWithSupplier;
          setUpService();
          expect(service.showTypeStyle, isFalse);
        });

        test("When product supplier does not have company", () {
          params.worksheetType = WorksheetConstants.materialList;
          itemData.selectedCategorySlug = FinancialConstant.material;
          product = productWithSupplier
            ..supplier?.companyId = null;
          setUpService();
          expect(service.showTypeStyle, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@showColor should conditionally show color input", () {
      group("Color input should be displayed", () {
        test("When worksheet is of type material and product supplier has company", () {
          params.worksheetType = WorksheetConstants.materialList;
          product = productWithSupplier..supplier?.companyId = 2;
          setUpService();
          expect(service.showColor, isTrue);
        });

        test("When worksheet is of type material and product supplier has SRS", () {
          params.worksheetType = WorksheetConstants.materialList;
          setEnv();
          product = productWithSupplier
            ..supplier?.id= 3;
          setUpService();
          expect(service.showColor, isTrue);
        });

        test("When selected product is material and product supplier has company", () {
          params.worksheetType = WorksheetConstants.estimate;
          itemData.selectedCategorySlug = FinancialConstant.material;
          product = productWithSupplier;
          setUpService();
          expect(service.showColor, isTrue);
        });

        test("When selected product is material and product supplier has SRS", () {
          params.worksheetType = WorksheetConstants.estimate;
          itemData.selectedCategorySlug = FinancialConstant.material;
          setEnv();
          product = productWithSupplier
            ..supplier?.id = 3;
          setUpService();
          expect(service.showColor, isTrue);
        });

        test("When selected product is material and product supplier has Beacon", () {
          params.worksheetType = WorksheetConstants.estimate;
          itemData.selectedCategorySlug = FinancialConstant.material;
          setEnv();
          product = productWithSupplier
            ..supplier?.id = Helper.getSupplierId(key: CommonConstants.beaconId);
          setUpService();
          expect(service.showColor, isTrue);
        });
      });

      group("Color input should be hidden", () {
        test("When worksheet and selected product is not of type material", () {
          params.worksheetType = WorksheetConstants.workOrder;
          itemData.selectedCategorySlug = FinancialConstant.overhead;
          setUpService();
          expect(service.showColor, isFalse);
        });

        test("When product does not have supplier nor supplier do have company", () {
          product = emptyProduct;
          setUpService();
          expect(service.showColor, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@isColorRequired should check whether color is required", () {
      group("Color input should be required", () {
        test("When colors are available for selection and product supplier has SRS id and worksheet is of type material", () {
          setEnv();
          product = productWithSupplier
            ..supplier?.id = 3
            ..colors = ['red'];
          params.worksheetType = WorksheetConstants.materialList;
          setUpService();
          expect(service.isColorRequired, isTrue);
        });

        test("When colors are available for selection and product supplier has SRS id and action is for SRS material list", () {
          setEnv();
          product = productWithSupplier
            ..supplier?.id = 3
            ..colors = ['red'];
          params.worksheetType = WorksheetConstants.estimate;
          params.isSRSEnabled = true;
          setUpService();
          expect(service.isColorRequired, isTrue);
          params.isSRSEnabled = false;
        });

        test("When colors are available for selection and product supplier has Beacon id and worksheet is of type material", () {
          setEnv();
          product = productWithSupplier
            ..supplier?.id = Helper.getSupplierId(key: CommonConstants.beaconId)
            ..colors = ['red'];
          params.worksheetType = WorksheetConstants.materialList;
          setUpService();
          expect(service.isColorRequired, isTrue);
        });

        test("When colors are available for selection and product supplier has Beacon id and action is for Beacon material list", () {
          setEnv();
          product = productWithSupplier
            ..supplier?.id = Helper.getSupplierId(key: CommonConstants.beaconId)
            ..colors = ['red'];
          params.worksheetType = WorksheetConstants.estimate;
          params.isBeaconEnabled = true;
          setUpService();
          expect(service.isColorRequired, isTrue);
          params.isBeaconEnabled = false;
        });
      });

      group("Color input should not be required", () {
        test("When colors do not exist", () {
          product = emptyProduct;
          setUpService();
          expect(service.isColorRequired, isFalse);
        });

        test("When product does not have SRS supplier", () {
          product = emptyProduct;
          setUpService();
          expect(service.isColorRequired, isFalse);
        });

        test("When product SRS supplier does not have company", () {
          product = emptyProduct;
          setUpService();
          expect(service.isColorRequired, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@isColorDisabled should conditionally disable color field", () {
      group("Color input should be disabled", () {
        test("When selected product supplier has SRS", () {
          setEnv();
          product = productWithSupplier
            ..supplier?.id = 3;
          setUpService();
          expect(service.isColorDisabled, isTrue);
        });

        test("When selected product supplier has Beacon", () {
          setEnv();
          product = productWithSupplier
            ..supplier?.id = Helper.getSupplierId(key: CommonConstants.beaconId);
          setUpService();
          expect(service.isColorDisabled, isTrue);
        });
      });

      group("Color input should be enabled", () {
        test("When selected product supplier does not have SRS or Beacon", () {
          product = FinancialProductModel();
          setUpService();
          expect(service.isColorDisabled, isTrue);
        });
      });
    });

    group("WorksheetAddItemConditionsService@isColorSingleSelect should check whether color selecting options are available", () {
      group("Color selection options should be available", () {
        test("When pre-defined colors exist in product", () {
          product = productWithSupplier
            ..colors = ['red'];
          setUpService();
          expect(service.isColorSingleSelect, isTrue);
        });
      });

      group("Color selection options should not be available", () {
        test("When pre-defined colors does not exists in product", () {
          product = emptyProduct;
          setUpService();
          expect(service.isColorSingleSelect, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@isStyleSingleSelect should check whether style selecting options are available", () {
      group("Style selection options should be available", () {
        test("When pre-defined styles exist in product", () {
          product = productWithSupplier
            ..styles = ['fancy'];
          setUpService();
          expect(service.isStyleSingleSelect, isTrue);
        });
      });

      group("Style selection options should not be available", () {
        test("When pre-defined styles does not exists in product", () {
          product = emptyProduct;
          setUpService();
          expect(service.isStyleSingleSelect, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@showSize should conditionally display type size input", () {
      group("Size input should be displayed", () {
        test("When worksheet is of type material and product supplier has company", () {
          params.worksheetType = WorksheetConstants.materialList;
          product = productWithSupplier..supplier?.companyId = 3;
          setUpService();
          expect(service.showSize, isTrue);
        });

        test("When selected product is of type material and product supplier has company", () {
          params.worksheetType = WorksheetConstants.estimate;
          itemData.selectedCategorySlug = FinancialConstant.material;
          product = productWithSupplier;
          setUpService();
          expect(service.showSize, isTrue);
        });

        test("When worksheet is of type material and product does not have supplier", () {
          params.worksheetType = WorksheetConstants.materialList;
          product = emptyProduct;
          setUpService();
          expect(service.showSize, isTrue);
        });

        test("When selected product is of type material and product does not have supplier", () {
          params.worksheetType = WorksheetConstants.estimate;
          itemData.selectedCategorySlug = FinancialConstant.material;
          product = emptyProduct;
          setUpService();
          expect(service.showSize, isTrue);
        });
      });

      group("Size input should be hidden", () {
        test("When worksheet and selected product is not of type material", () {
          params.worksheetType = WorksheetConstants.estimate;
          itemData.selectedCategorySlug = FinancialConstant.overhead;
          product = productWithSupplier;
          setUpService();
          expect(service.showSize, isFalse);
        });

        test("When product supplier does not have company", () {
          params.worksheetType = WorksheetConstants.materialList;
          itemData.selectedCategorySlug = FinancialConstant.material;
          product = productWithSupplier
            ..supplier?.companyId = null;
          setUpService();
          expect(service.showSize, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@isSizeSingleSelect should check whether size selection options are available", () {
      group("Size selection options should be available", () {
        test("When pre-defined size exist in product", () {
          product = productWithSupplier
            ..sizes = ['small'];
          setUpService();
          expect(service.isSizeSingleSelect, isTrue);
        });
      });

      group("Size selection options should not be available", () {
        test("When pre-defined size does not exists in product", () {
          product = emptyProduct;
          setUpService();
          expect(service.isSizeSingleSelect, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@disableUnit should disable unit input conditionally", () {
      group("Unit input should be disabled", () {
        test("When worksheet is not of type material and does not have product category", () {
          params.worksheetType = WorksheetConstants.estimate;
          product = emptyProduct;
          setUpService();
          expect(service.disableUnit, isTrue);
        });

        test("When supplier has no variants with UOM", () {
          product = productWithSupplier;
          service.itemData.selectedVariant = VariantModel();
          setUpService();
          expect(service.disableUnit, isTrue);
        });
      });

      group("Unit input should be enabled", () {
        test("When worksheet is of type material and selected product does not have supplier", () {
          product = emptyProduct;
          params.worksheetType = WorksheetConstants.materialList;
          setUpService();
          expect(service.disableUnit, isFalse);
        });

        test("When selected product does not have supplier and category", () {
          product = emptyProduct;
          setUpService();
          expect(service.disableUnit, isFalse);
        });

        test("When selected product has supplier with multiple UOM", () {
          product = emptyProduct;
          service.itemData.selectedVariant = VariantModel(
            uom: ['B', 'C']
          );
          setUpService();
          expect(service.disableUnit, isFalse);
          service.itemData.selectedVariant = null;
        });
      });
    });

    group("WorksheetAddItemConditionsService@hidePrice should hide price input conditionally", () {
      group("Price input should be hidden", () {
        test("When show pricing is disabled from worksheet settings", () {
          params.settings.hidePricing = true;
          setUpService();
          expect(service.hidePrice, isTrue);
        });
      });

      group("Price input should be shown", () {
        test("When show pricing is enabled from worksheet settings", () {
          params.settings.hidePricing = false;
          setUpService();
          expect(service.hidePrice, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@disablePrice should disable price input conditionally", () {
      group("Price input should be disabled", () {
        test("When worksheet is not of type material and does not have product category", () {
          params.worksheetType = WorksheetConstants.estimate;
          product = emptyProduct;
          setUpService();
          expect(service.disablePrice, isTrue);
        });

        test("When product has supplier", () {
          product = productWithSupplier;
          setUpService();
          expect(service.disablePrice, isTrue);
        });
      });

      group("Price input should be enabled", () {
        test("When worksheet is of type material and selected product does not have supplier", () {
          product = emptyProduct;
          params.worksheetType = WorksheetConstants.materialList;
          setUpService();
          expect(service.disablePrice, isFalse);
        });

        test("When selected product does not have supplier and category", () {
          product = emptyProduct;
          setUpService();
          expect(service.disablePrice, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@disableQuantity should conditionally disable quantity input", () {
      group("Quantity input should be disabled", () {
        test("When worksheet is not material and product does not have category", () {
          params.worksheetType = WorksheetConstants.estimate;
          product = emptyProduct;
          setUpService();
          expect(service.disableQuantity, isTrue);
        });
      });

      group("Quantity input should be enabled", () {
        test("When worksheet is material", () {
          params.worksheetType = WorksheetConstants.materialList;
          product = emptyProduct;
          setUpService();
          expect(service.disableQuantity, isFalse);
        });

        test("When product has category", () {
          params.worksheetType = WorksheetConstants.materialList;
          product = productWithCategory;
          setUpService();
          expect(service.disableQuantity, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@showProfit should conditionally show profit input section", () {
      group("Profit input section should be displayed", () {
        test("When show pricing is enabled, line item profit is applied, worksheet is not material and product is chargeable", () {
          params.settings.hidePricing = false;
          params.settings.applyLineItemProfit = true;
          params.worksheetType = WorksheetConstants.workOrder;
          itemData.selectedCategorySlug = FinancialConstant.material;
          setUpService();
          expect(service.showProfit, isTrue);
        });
      });

      group("Profit input section should not be displayed", () {
        test("When show pricing is disabled", () {
          params.settings.hidePricing = true;
          params.settings.applyLineItemProfit = true;
          params.worksheetType = WorksheetConstants.workOrder;
          itemData.selectedCategorySlug = FinancialConstant.material;
          setUpService();
          expect(service.showProfit, isFalse);
        });

        test("When line item profit is not applied", () {
          params.settings.hidePricing = false;
          params.settings.applyLineItemProfit = false;
          params.worksheetType = WorksheetConstants.workOrder;
          itemData.selectedCategorySlug = FinancialConstant.material;
          setUpService();
          expect(service.showProfit, isFalse);
        });

        test("When worksheet is of type material", () {
          params.settings.hidePricing = false;
          params.settings.applyLineItemProfit = true;
          params.worksheetType = WorksheetConstants.materialList;
          itemData.selectedCategorySlug = FinancialConstant.material;
          setUpService();
          expect(service.showProfit, isFalse);
        });

        test("When product is not chargeable", () {
          params.settings.hidePricing = false;
          params.settings.applyLineItemProfit = true;
          params.worksheetType = WorksheetConstants.workOrder;
          itemData.selectedCategorySlug = FinancialConstant.noCharge;
          setUpService();
          expect(service.showProfit, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@disableProfit should conditionally disable profit input section", () {
      group("Profit input section should be disabled", () {
        test("When selected product does not have category", () {
          product = emptyProduct;
          setUpService();
          expect(service.disableProfit, isTrue);
        });
      });

      group("Profit input section should be enabled", () {
        test("When worksheet is material", () {
          product = productWithCategory;
          setUpService();
          expect(service.disableProfit, isFalse);
        });

        test("When product has category", () {
          params.worksheetType = WorksheetConstants.materialList;
          product = productWithCategory;
          setUpService();
          expect(service.disableQuantity, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@showTax should conditionally show tax input section", () {
      group("Tax input section should be displayed", () {
        test("When show pricing is enabled, line item tax is applied, worksheet is not material and product is chargeable", () {
          params.settings.hidePricing = false;
          params.settings.addLineItemTax = true;
          params.worksheetType = WorksheetConstants.workOrder;
          itemData.selectedCategorySlug = FinancialConstant.material;
          setUpService();
          expect(service.showTax, isTrue);
        });
      });

      group("Tax input section should not be displayed", () {
        test("When show pricing is disabled", () {
          params.settings.hidePricing = true;
          params.settings.addLineItemTax = true;
          params.worksheetType = WorksheetConstants.workOrder;
          itemData.selectedCategorySlug = FinancialConstant.material;
          setUpService();
          expect(service.showTax, isFalse);
        });

        test("When line item tax is not applied", () {
          params.settings.hidePricing = false;
          params.settings.addLineItemTax = false;
          params.worksheetType = WorksheetConstants.workOrder;
          itemData.selectedCategorySlug = FinancialConstant.material;
          setUpService();
          expect(service.showTax, isFalse);
        });

        test("When worksheet is of type material", () {
          params.settings.hidePricing = false;
          params.settings.addLineItemTax = true;
          params.worksheetType = WorksheetConstants.materialList;
          itemData.selectedCategorySlug = FinancialConstant.material;
          setUpService();
          expect(service.showTax, isFalse);
        });

        test("When product is not chargeable", () {
          params.settings.hidePricing = false;
          params.settings.addLineItemTax = true;
          params.worksheetType = WorksheetConstants.workOrder;
          itemData.selectedCategorySlug = FinancialConstant.noCharge;
          setUpService();
          expect(service.showTax, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@disableTax should conditionally disable tax input section", () {
      group("Tax input section should be disabled", () {
        test("When selected product does not have category", () {
          product = emptyProduct;
          setUpService();
          expect(service.disableTax, isTrue);
        });
      });

      group("Tax input section should be enabled", () {
        test("When worksheet is material", () {
          product = productWithCategory;
          setUpService();
          expect(service.disableTax, isFalse);
        });

        test("When product has category", () {
          params.worksheetType = WorksheetConstants.materialList;
          product = productWithCategory;
          setUpService();
          expect(service.disableTax, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@disableDescription should disable description input conditionally", () {
      group("Description input should be disabled", () {
        test("When worksheet is not of type material and does not have product category", () {
          params.worksheetType = WorksheetConstants.estimate;
          product = emptyProduct;
          setUpService();
          expect(service.disableDescription, isTrue);
        });

        test("When product has supplier", () {
          product = productWithSupplier;
          setUpService();
          expect(service.disableDescription, isTrue);
        });
      });

      group("Description input should be enabled", () {
        test("When worksheet is of type material and selected product does not have supplier", () {
          product = emptyProduct;
          params.worksheetType = WorksheetConstants.materialList;
          setUpService();
          expect(service.disableDescription, isFalse);
        });

        test("When selected product does not have supplier and category", () {
          product = emptyProduct;
          setUpService();
          expect(service.disableDescription, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@disableTypeStyle should disable type style input conditionally", () {
      group("Type style input should be disabled", () {
        test("When worksheet is not of type material and selected product is not material", () {
          params.worksheetType = WorksheetConstants.workOrder;
          itemData.selectedCategorySlug = FinancialConstant.overhead;
          setUpService();
          expect(service.disableTypeStyle, isTrue);
        });
      });

      group("Type style input should be enabled", () {
        test("When worksheet is of type material", () {
          params.worksheetType = WorksheetConstants.materialList;
          itemData.selectedCategorySlug = FinancialConstant.overhead;
          setUpService();
          expect(service.disableTypeStyle, isFalse);
        });

        test("When selected product is material", () {
          params.worksheetType = WorksheetConstants.workOrder;
          itemData.selectedCategorySlug = FinancialConstant.material;
          setUpService();
          expect(service.disableTypeStyle, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@disableSize should disable size input conditionally", () {
      group("Size input should be disabled", () {
        test("When worksheet is not of type material and selected product is not material", () {
          params.worksheetType = WorksheetConstants.workOrder;
          itemData.selectedCategorySlug = FinancialConstant.overhead;
          setUpService();
          expect(service.disableSize, isTrue);
        });
      });

      group("Size input should be enabled", () {
        test("When worksheet is of type material", () {
          params.worksheetType = WorksheetConstants.materialList;
          itemData.selectedCategorySlug = FinancialConstant.overhead;
          setUpService();
          expect(service.disableSize, isFalse);
        });

        test("When selected product is material", () {
          params.worksheetType = WorksheetConstants.workOrder;
          itemData.selectedCategorySlug = FinancialConstant.material;
          setUpService();
          expect(service.disableSize, isFalse);
        });
      });
    });

    group("WorksheetAddItemConditionsService@hasMultipleUOM should decide whether multiple UOM are available", () {
      test("Value should be false, when there are no selected variant", () {
        itemData.selectedVariant = null;
        setUpService();
        expect(service.hasMultipleUOM, isFalse);
      });

      group("When there is selected variant available", () {
        test("In case there are no UOM", () {
          itemData.selectedVariant = VariantModel();
          setUpService();
          expect(service.hasMultipleUOM, isFalse);
        });

        test("In case there are multiple UOM", () {
          itemData.selectedVariant = VariantModel(
            uom: ["KG", "LBS"],
          );
          setUpService();
          expect(service.hasMultipleUOM, isTrue);
        });
      });
    });

    group("WorksheetAddItemConditionsService@isUnitSingleSelect should check whether unit selection options are available", () {
      group("In case there are variants", () {
        test("Unit selection options should be available in case of UOM available", () {
          product.supplier = SuppliersModel(
              id: Helper.getSupplierId(key: CommonConstants.beaconId)
          );
          service.itemData.selectedVariant = VariantModel(
              id: 1,
              name: 'Variant 1',
              uom: ['kg']
          );
          setUpService();
          expect(service.isUnitSingleSelect, isTrue);
        });

        test("Unit selection options should not be available in case of UOM not available", () {
          service.itemData.selectedVariant = VariantModel(
            id: 1,
          );
          setUpService();
          expect(service.isUnitSingleSelect, isFalse);
        });

        tearDown(() {
          service.itemData.selectedVariant = null;
        });
      });

      group("In case there are no variants", () {
        group("Unit selection options should be available", () {
          test("When pre-defined units exist in product and product has SRS supplier", () {
            product = productWithSupplier
              ..supplier?.id = 3
              ..units = ['small'];
            setUpService();
            expect(service.isUnitSingleSelect, isTrue);
          });
        });

        group("Unit selection options should not be available", () {
          test("When pre-defined units does not exists in product", () {
            product = emptyProduct;
            setUpService();
            expect(service.isUnitSingleSelect, isFalse);
          });

          test("When product does not have SRS supplier", () {
            product = emptyProduct;
            setUpService();
            expect(service.isUnitSingleSelect, isFalse);
          });
        });
      });
    });

    group("WorksheetAddItemConditionsService@showVariants should conditionally display variants field", () {
      test("Variants input should not be displayed when there are no variants", () {
        product = productWithSupplier..variants = [];
        setUpService();
        expect(service.showVariants, isFalse);
      });

      test("Variants input should be displayed when there are variants", () {
        product = productWithSupplier..variants = [
          VariantModel()
        ];
        setUpService();
        expect(service.showVariants, isTrue);
      });
    });

  });

}