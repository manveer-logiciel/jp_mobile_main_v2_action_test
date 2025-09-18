import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/common/services/job/job_form/add_job.dart';
import 'package:jobprogress/common/services/job/job_form/bind_validator.dart';
import 'package:jobprogress/core/constants/forms/job_form.dart';

void main(){
  JobFormService service = JobFormService(
      update: () { }, // method used to update ui directly from service so empty function can be used in testing
      formType: JobFormType.add,
      validateForm: () { }, // method used to validate form using form key with is ui based, so can be passes empty for unit testing
      onDataChange: (_) { }, // this method is called when data in dynamic field changes
      forEditInsurance: false 
  );

  JobFormBindValidator bindValidator = JobFormBindValidator(service);

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group("JobFormBindValidator@bind should bind validators with fields", () {

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

   group("JobFormBindValidator should return validator from field key", () {
    test("When validator exists for a field", () {
      final result = bindValidator.getValidator(JobFormConstants.jobDescription);
      expect(result, isNotNull);
    });

    test("When validator does not exist", () {
      final result = bindValidator.getValidator(JobFormConstants.jobAltId);
      expect(result, isNull);
    });
  });
}