import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/services/project/project_form/add_project.dart';
import 'package:jobprogress/core/constants/forms/project_form.dart';

/// [ProjectFormBindValidator] helps in binding validators with dynamic fields
/// This class is useful as order of the field is not predictable
/// and binding validator with fields help in executing validation
/// in a serial order as fields are rendered
class ProjectFormBindValidator {
  /// [service] is base form service that provides access to validators
  ProjectFormService service;

  ProjectFormBindValidator(this.service);

  /// [bind] scans all the fields and bind validators with them
  void bind() {
    for (var field in service.allFields) {
      final validator = getValidator(field.key);
      if (validator != null) {
        service.validators.putIfAbsent(field.key, () => validator);
      }
    }
  }

  /// [getValidator] returns corresponding validator to key type
  bool Function(InputFieldParams)? getValidator(String key) {
    switch (key) {
      case ProjectFormConstant.projectDescription:
        return service.validateProjectDescription;

      case ProjectFormConstant.projectTradeWorkType:
        return service.validateTradeWorkTypes;

      case ProjectFormConstant.projectRepEstimator:
        return service.validateProjectRepEstimator;
    }

    return null;
  }
}
