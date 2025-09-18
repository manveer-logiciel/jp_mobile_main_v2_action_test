import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_handlers.dart';

void main() {
  final tempWorksheet = WorksheetModel();

  final tempLineItem = SheetLineItemModel(
    productId: "",
    title: "",
    price: "100",
    qty: "1",
    totalPrice: "100",
  );

  group("FileListQuickActionHandlers@getGenerateInvoiceLineItems should convert worksheet line items to api payload for generating invoice", () {
    test("When worksheet has no line items", () {
      tempWorksheet.lineItems = [];
      final result = FileListQuickActionHandlers.getGenerateInvoiceLineItems(tempWorksheet);
      expect(result, <dynamic>[]);
    });

    test("When worksheet has line items", () {
      tempWorksheet.lineItems = [tempLineItem];
      final result = FileListQuickActionHandlers.getGenerateInvoiceLineItems(tempWorksheet);
      expect(result, hasLength(1));
      expect(result, <dynamic>[tempLineItem.toJobProposeQuickActionJson()]);
    });

    test("When worksheet has multiple line items", () {
      tempWorksheet.lineItems = [tempLineItem, tempLineItem];
      final result = FileListQuickActionHandlers.getGenerateInvoiceLineItems(tempWorksheet);
      expect(result, hasLength(2));
      expect(result, <dynamic>[
        tempLineItem.toJobProposeQuickActionJson(),
        tempLineItem.toJobProposeQuickActionJson()
      ]);
    });

    group("When worksheet has processing fee enabled", () {
      test("Extra line item should not be added when [metro-bath] feature is not enabled", () {
        tempWorksheet.processingFeeAmount = "5";
        tempWorksheet.lineItems = [tempLineItem];
        final result = FileListQuickActionHandlers.getGenerateInvoiceLineItems(tempWorksheet);
        expect(result, hasLength(1));
      });

      test("Extra line item should be added when [metro-bath] feature is enabled", () {
        LDFlags.metroBathFeature.value = true;
        tempWorksheet.processingFeeAmount = "5";
        tempWorksheet.lineItems = [tempLineItem];
        final result = FileListQuickActionHandlers.getGenerateInvoiceLineItems(tempWorksheet);
        expect(result, hasLength(2));
      });
    });
  });

  group('FileListQuickActionHandlers@getSupplierFlQuickActionType should get type', () {
    test('When SRS order is placed', () {
      expect(FileListQuickActionHandlers.getSupplierFlQuickActionType(MaterialSupplierType.srs), FLQuickActions.placeSRSOrder);
    });

    test('When Beacon order is placed', () {
      expect(FileListQuickActionHandlers.getSupplierFlQuickActionType(MaterialSupplierType.beacon), FLQuickActions.placeBeaconOrder);
    });

    test('When ABC order is placed', () {
      expect(FileListQuickActionHandlers.getSupplierFlQuickActionType(MaterialSupplierType.abc), FLQuickActions.placeABCOrder);
    });
  });
}