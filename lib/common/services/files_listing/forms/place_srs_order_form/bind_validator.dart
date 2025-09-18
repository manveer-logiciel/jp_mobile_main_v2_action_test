

import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/core/constants/forms/place_srs_order.dart';

/// [PlaceSupplierOrderFormBindValidator] helps in binding validators with dynamic fields
/// This class is useful as order of the field is not predictable
/// and binding validator with fields help in executing validation
/// in a serial order as fields are rendered
class PlaceSupplierOrderFormBindValidator {

  /// [service] is base form service that provides access to validators
  PlaceSupplierOrderFormService service;

  PlaceSupplierOrderFormBindValidator(this.service);

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
  bool Function(InputFieldParams field)? getValidator(String key) {

    switch (key) {
      case PlaceSrsOrderFormConstants.companyContact:
        return service.validateCompanyContact;

      case PlaceSrsOrderFormConstants.shippingAddress:
        return service.validateShippingAddress;

      case PlaceSrsOrderFormConstants.deliveryType:
        return service.validateDeliveryType;

      case PlaceSrsOrderFormConstants.timezone:
        return service.validateTimezone;

      case PlaceSrsOrderFormConstants.materialDate:
        return service.validateMaterialDeliveryDate;

      case PlaceSrsOrderFormConstants.requestedDeliveryTime:
        return service.validateDeliveryTime;

      case PlaceSrsOrderFormConstants.poJobName:
        return service.validatePOJobName;

      case PlaceSrsOrderFormConstants.estimateBranchArrivalTime:
        return service.validateEstimateBranchArrivalTime;
    }

    return null;
  }
}