
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/forms/common/section.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';

void main() {

  PlaceSupplierOrderFormController controller = PlaceSupplierOrderFormController();

  FormSectionModel tempSection = FormSectionModel(
    name: "Test Section",
    fields: [],
  );

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('In case of create place srs order', () {

    test('PlaceSrsOrderFormController should be initialized with correct values', () {
      expect(controller.isSavingForm, false);
      expect(controller.pageTitle, 'place_srs_order'.tr.toUpperCase());
      expect(controller.saveButtonText, 'place_order'.tr.toUpperCase());
    });

    group('PlaceSrsOrderFormController@toggleIsSavingForm should toggle form\'s saving state', () {

      test('Form editing should be disabled', () {
        controller.toggleIsSavingForm();
        expect(controller.isSavingForm, true);
      });

      test('Form editing should be allowed', () {
        controller.toggleIsSavingForm();
        expect(controller.isSavingForm, false);
      });

    });

    group('PlaceSrsOrderFormController@onSectionExpansionChanged should toggle section\'s expansion', () {

      test('Section should be expanded', () {
        controller.onSectionExpansionChanged(tempSection, true);
        expect(tempSection.isExpanded, true);
      });

      test('Section should be collapsed', () {
        controller.onSectionExpansionChanged(tempSection, false);
        expect(tempSection.isExpanded, false);
      });
    });
  });

  group("PlaceSupplierOrderFormController@pageTitle should give page title as per type", () {
    test("In case of SRS order form", () {
      controller.type = MaterialSupplierType.srs;
      expect(controller.pageTitle, "place_srs_order".tr.toUpperCase());
    });

    test("In case of Beacon order form", () {
      controller.type = MaterialSupplierType.beacon;
      expect(controller.pageTitle, "place_beacon_order".tr.toUpperCase());
    });
  });
  
}