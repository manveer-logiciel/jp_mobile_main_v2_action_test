import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/common/enums/parent_form_type.dart';
import 'package:jobprogress/common/services/project/project_form/add_project.dart';
import 'package:jobprogress/common/services/project/project_form/bind_validator.dart';
import 'package:jobprogress/core/constants/forms/project_form.dart';

void main() {
  ProjectFormService service = ProjectFormService(
      fields: [],
      update:
          () {}, // method used to update ui directly from service so empty function can be used in testing
      validateForm:
          () {}, // method used to validate form using form key with is ui based, so can be passes empty for unit testing
      onDataChange: (_) {},
      divisionCode: '',
      formType: JobFormType.add,
      parenrFormType: ParentFormType.individual,
      showCompanyCam: null // this method is called when data in dynamic field changes
      );

  ProjectFormBindValidator bindValidator = ProjectFormBindValidator(service);

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

  
  group("ProjectFormBindValidator should return validator from field key", () {
    test("When validator exists for a field", () {
      final result = bindValidator.getValidator(ProjectFormConstant.projectDescription);
      expect(result, isNotNull);
    });

    test("When validator does not exist", () {
      final result = bindValidator.getValidator(ProjectFormConstant.projectAltId);
      expect(result, isNull);
    });
  });
}
