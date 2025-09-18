import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/common/models/forms/common/section.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/modules/job/job_form/controller.dart';

void main(){
  late JobFormController controller;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    controller = JobFormController();
    controller.init();
  });

  FormSectionModel tempSection = FormSectionModel(
      name: "Test Section",
      fields: [],
  );

  JobModel tempJob = JobModel(
    id: 0,
    customerId: 12,
    isMultiJob: false,
    altId: "p1",
    leadNumber: "j1",
    name: "job",
    description: "test desc",
    duration: "12:22:11",
    reps: [
      UserLimitedModel(id: 12, firstName: "temp", fullName: "temp name", email: "email", groupId: 1),
      UserLimitedModel(id: 12, firstName: "temp", fullName: "temp name", email: "email", groupId: 1)
    ],
  );

  group('In case of add job', () {

    test('JobFormController should be initialized with correct values', () {
      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.job, isNull);
      expect(controller.type, JobFormType.add);
      expect(controller.fieldsSubscription, isNull);
      expect(controller.saveButtonText, 'save'.tr.toUpperCase());
      expect(controller.pageTitle, 'add_job'.tr.toUpperCase());
    });

    group('JobFormController@onSectionExpansionChanged should toggle section\'s expansion', () {

      test('Section should be expanded', () {
        controller.onSectionExpansionChanged(tempSection, true);
        expect(tempSection.isExpanded, true);
      });

      test('Section should be collapsed', () {
        controller.onSectionExpansionChanged(tempSection, false);
        expect(tempSection.isExpanded, false);
      });
      
    });

    group('JobFormController@toggleIsSavingForm should toggle form\'s saving state', () {

      test('Form editing should be disabled', () {
        controller.toggleIsSavingForm();
        expect(controller.isSavingForm, true);
      });

      test('Form editing should be allowed', () {
        controller.toggleIsSavingForm();
        expect(controller.isSavingForm, false);
      });
    });

    test("JobFormController@addFieldsListener should bind a realtime listener for listening field changes", () async {
      controller.addFieldsListener();
      expect(controller.fieldsSubscription, isNotNull);
    });

    test("JobFormController@removeFieldsListener should remove realtime listener for listening field changes", () async {
      controller.removeFieldsListener();
      expect(controller.fieldsSubscription, isNull);
    });
  });

  group('In case of edit/update job', () {

    test('JobFormController should be initialized with correct values', () {

      controller.job = tempJob;
      controller.type = JobFormType.edit;
      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.job, tempJob);
      expect(controller.fieldsSubscription, isNull);
      expect(controller.saveButtonText, 'update'.tr.toUpperCase());
      expect(controller.pageTitle, 'update_job'.tr.toUpperCase());
    });
  });
}