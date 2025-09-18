
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/services/customer/customer_form/add_customer.dart';
import 'package:jobprogress/core/constants/forms/customer_form.dart';

/// [CustomerFormBindValidator] helps in binding validators with dynamic fields
/// This class is useful as order of the field is not predictable
/// and binding validator with fields help in executing validation
/// in a serial order as fields are rendered
class CustomerFormBindValidator {

  /// [service] is base form service that provides access to validators
  CustomerFormService service;

  CustomerFormBindValidator(this.service);

  /// [bind] scans all the fields and bind validators with them
  void bind() {
    for (var field in service.allFields) {
      final validator = getValidator(field.key);
      if(validator != null) {
        service.validators.putIfAbsent(field.key, () => validator);
      }
    }
  }

  /// [getValidator] returns corresponding validator to key type
  bool Function(InputFieldParams)? getValidator(String key) {

    switch (key) {
      case CustomerFormConstants.customerName:
        return service.validateCustomerCompanyName;

      case CustomerFormConstants.email:
        return service.validateEmail;

      case CustomerFormConstants.customFields:
        return service.validateCustomFields;

      case CustomerFormConstants.companyName:
        return service.validateCompanyName;

      case CustomerFormConstants.customerAddress:
        return service.validateCustomerAddress;

      case CustomerFormConstants.referredBy:
        return service.validateReferredByNote;

      case CustomerFormConstants.canvasser:
        return service.validateCanvasserNote;

      case CustomerFormConstants.callCenterRep:
        return service.validateCallCenterRepNote;

      case CustomerFormConstants.phone:
        return service.validatePhone;
      
      case CustomerFormConstants.commercialCompanyName:
        return service.validateCompanyName;

      case CustomerFormConstants.salesManCustomerRep:
        return service.validateSalesManCustomerRep;
    }

    return null;
  }
}