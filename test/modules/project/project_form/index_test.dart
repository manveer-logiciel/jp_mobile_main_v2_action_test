import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/common/enums/parent_form_type.dart';
import 'package:jobprogress/modules/project/project_form/controller.dart';

void main() {
  ProjectFormController controller = ProjectFormController([], '01', false, false, ParentFormType.individual);
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    controller.init();
  });

  group('In case of add project', () {
    
    test('ProjectFormController should be initialized with correct values', () {
      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.type, JobFormType.add);
      expect(controller.fieldsSubscription, isNull);
      expect(controller.pageTitle, 'add_project'.tr.toUpperCase());
    });
    group('ProjectFormController@toggleIsSavingForm should toggle form\'s saving state', () {

      test('Form editing should be disabled', () {
        controller.toggleIsSavingForm();
        expect(controller.isSavingForm, true);
      });

      test('Form editing should be allowed', () {
        controller.toggleIsSavingForm();
        expect(controller.isSavingForm, false);
      });
    });
    test("ProjectFormController@addFieldsListener should bind a realtime listener for listening field changes", () async {
      controller.addFieldsListener();
      expect(controller.fieldsSubscription, isNotNull);
    });

    test("ProjectFormController@removeFieldsListener should remove realtime listener for listening field changes", () async {
      controller.removeFieldsListener();
      expect(controller.fieldsSubscription, isNull);
    });

  });

  group('In case of edit/update project', () {
    
    test('ProjectFormController should be initialized with correct values', () {

      controller.type = JobFormType.edit;
      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.type, JobFormType.edit);
      expect(controller.fieldsSubscription, isNull);
      expect(controller.pageTitle, 'edit_project'.tr.toUpperCase());

    });
  });
}
