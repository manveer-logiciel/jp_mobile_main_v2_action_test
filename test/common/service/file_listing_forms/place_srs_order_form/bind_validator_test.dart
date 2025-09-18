import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/bind_validator.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/core/constants/forms/place_srs_order.dart';

void main() {

  PlaceSupplierOrderFormService service = PlaceSupplierOrderFormService(
    update: () {}, 
    validateForm: () {}, 
    onDataChange: (_) {}, 
    worksheetId: "1",
  );

  PlaceSupplierOrderFormBindValidator bindValidator = PlaceSupplierOrderFormBindValidator(service);

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group("PlaceSrsOrderFormBindValidator@bind should bind validators with fields", () {

    test("When no fields are there, no validator should bind", () {
      bindValidator.bind();
      expect(service.validators, isEmpty);
    });

    test("When fields are there, validator should bind", () {
      service.setUpFields();
      bindValidator.bind();
      expect(service.validators, isNotEmpty);
    });
  });

  group("PlaceSrsOrderFormBindValidator should return validator from field key", () {

    test("When validator exists for a field", () {
      expect(bindValidator.getValidator(PlaceSrsOrderFormConstants.companyContact), isNotNull);
      expect(bindValidator.getValidator(PlaceSrsOrderFormConstants.shippingAddress), isNotNull);
      expect(bindValidator.getValidator(PlaceSrsOrderFormConstants.deliveryType), isNotNull);
      expect(bindValidator.getValidator(PlaceSrsOrderFormConstants.timezone), isNotNull);
      expect(bindValidator.getValidator(PlaceSrsOrderFormConstants.materialDate), isNotNull);
      expect(bindValidator.getValidator(PlaceSrsOrderFormConstants.requestedDeliveryTime), isNotNull);
      expect(bindValidator.getValidator(PlaceSrsOrderFormConstants.poJobName), isNotNull);
    });

    test("When validator does not exist", () {
      expect(bindValidator.getValidator(PlaceSrsOrderFormConstants.billingAddress), isNull);
      expect(bindValidator.getValidator(PlaceSrsOrderFormConstants.placeOrderDetails), isNull);
      expect(bindValidator.getValidator(PlaceSrsOrderFormConstants.requestedDeliveryDateLabel), isNull);
      expect(bindValidator.getValidator(PlaceSrsOrderFormConstants.materialDeliveryNote), isNull);
      expect(bindValidator.getValidator(PlaceSrsOrderFormConstants.shippingMethod), isNull);
      expect(bindValidator.getValidator(PlaceSrsOrderFormConstants.note), isNull);
    });

  });

}