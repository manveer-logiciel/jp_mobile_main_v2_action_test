import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/services/customer/customer_form/add_customer.dart';
import 'package:jobprogress/common/services/customer/customer_form/bind_validator.dart';
import 'package:jobprogress/core/constants/forms/customer_form.dart';

void main() {

  CustomerFormService service = CustomerFormService(
      update: () { }, // method used to update ui directly from service so empty function can be used in testing
      validateForm: () { }, // method used to validate form using form key with is ui based, so can be passes empty for unit testing
      onDataChange: (_) { } // this method is called when data in dynamic field changes
  );

  CustomerFormBindValidator bindValidator = CustomerFormBindValidator(service);

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group("CustomerFormBindValidator@bind should bind validators with fields", () {

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

  group("CustomerFormBindValidator should return validator from field key", () {

    test("When validator exists for a field", () {
      final result = bindValidator.getValidator(CustomerFormConstants.email);
      expect(result, isNotNull);
    });

    test("When validator does not exist", () {
      final result = bindValidator.getValidator(CustomerFormConstants.propertyName);
      expect(result, isNull);
    });

  });

}