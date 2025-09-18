

import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/services/job/job_form/add_job.dart';
import 'package:jobprogress/core/constants/forms/job_form.dart';

/// [JobFormBindValidator] helps in binding validators with dynamic fields
/// This class is useful as order of the field is not predictable
/// and binding validator with fields help in executing validation
/// in a serial order as fields are rendered
class JobFormBindValidator {
  /// [service] is base form service that provides access to validators
  JobFormService service;

  JobFormBindValidator(this.service);

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
      case JobFormConstants.jobDescription:
        return service.validateJobDescription;

      case JobFormConstants.tradeWorkType:
        return service.validateTradeWorkTypes;

      case JobFormConstants.project:
        return service.formType == JobFormType.edit ? null : service.validateProjectFields;
      
      case JobFormConstants.customFields:
        return service.validateCustomFields;

      case JobFormConstants.canvasser:
        return service.validateCanvasserNote;

      case JobFormConstants.jobRepEstimator:
        return service.validateJobRepEstimator;
    }

    return null;
  }
}
