import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/common/enums/parent_form_type.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/job_meta.dart';
import 'package:jobprogress/common/models/project/fields.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/project/project_form/add_project.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';

import 'mocked_data.dart';

void main() {
  ProjectFormMockData mock = ProjectFormMockData();

  JobModel tempProject = JobModel(
    id: 0,
    customerId: 12,
    altId: "p1",
    description: "test desc",
    duration: "12:22:11",
    reps: [
      UserLimitedModel(id: 12, firstName: "temp", fullName: "temp name", email: "email", groupId: 1),
      UserLimitedModel(id: 12, firstName: "temp", fullName: "temp name", email: "email", groupId: 1)
    ],
  );


  List<JPSingleSelectModel> tempSelectionList = [
    JPSingleSelectModel(label: "stage 1", id: '1'),
    JPSingleSelectModel(label: "Item 2", id: CommonConstants.otherOptionId),
    JPSingleSelectModel(label: "Item 3", id: CommonConstants.customerOptionId),
    JPSingleSelectModel(label: "Item 4", id: '12'),
    JPSingleSelectModel(label: "User 1", id: '0'),
    JPSingleSelectModel(label: "Item 5", id: '123'),
  ];

  List<JPMultiSelectModel> tempMultiSelectionList = [
    JPMultiSelectModel(label: "Item 1", id: '12', isSelect: false),
    JPMultiSelectModel(label: "Item 2", id: CommonConstants.otherOptionId, isSelect: false),
    JPMultiSelectModel(label: "Item 3", id: CommonConstants.customerOptionId, isSelect: false),
    JPMultiSelectModel(label: "Item 4", id: '12', isSelect: false),
    JPMultiSelectModel(label: "User 1", id: '0', isSelect: false),
    JPMultiSelectModel(label: "Item 5", id: '123', isSelect: false),
  ];

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mock.companySettingModifier();
  });

  group("In case of Add project", () {
    ProjectFormService service = ProjectFormService(
        fields: [],
        update: () {}, // method used to update ui directly from service so empty function can be used in testing
        validateForm: () {}, // method used to validate form using form key with is ui based, so can be passes empty for unit testing
        onDataChange: (_) {},
        divisionCode: '',
        formType: JobFormType.add,
        parenrFormType: ParentFormType.individual,
        showCompanyCam: null // this method is called when data in dynamic field changes
        );
    group("ProjectFormService should be initialized with correct values", () {
      test('Form fields should be initialized with correct values', () {
        expect(service.projectAltIdController.text, isEmpty);
        expect(service.projectRepEstimatorController.text, isEmpty);
        expect(service.projectDurationDayController.text, isEmpty);
        expect(service.projectDurationHourController.text, isEmpty);
        expect(service.projectDurationMinController.text, isEmpty);
        expect(service.projectDescriptionController.text, isEmpty);
        expect(service.projectStatusController.text, isEmpty);
      });

      test('Form toggles should be initialized with correct values', () {
        expect(service.isLoading, true);
        expect(service.syncWithCompanyCam, true);
        expect(service.syncWithHover, false);
      });

      test('Form data helpers should be initialized with correct values', () {
        expect(service.validators, isEmpty);
        expect(service.job, isNull);
        expect(service.formType, JobFormType.add);
        expect(service.parenrFormType, ParentFormType.individual);
      });

      test('Form selection id\'s should be initialized with correct values',() {
        service.projectStatusList = tempSelectionList;
        final selectedId = tempSelectionList.first.id;
        final selectedLabel = tempSelectionList.first.label;
        service.selectedProjectStatus = "1";
        service.projectStatusController.text = "stage 1";
        expect(service.selectedProjectStatus, selectedId);
        expect(service.projectStatusController.text, selectedLabel);
        expect(service.selectedJobDivisionCode, isEmpty);
      });

      test('Form selection lists should be initialized with correct values',
          () {
        expect(service.workTypesList, isEmpty);
        expect(service.tradesList, isEmpty);
        expect(service.projectRepEstimatorList, isEmpty);
        expect(service.projectStatusList, isNotEmpty);
      });

      test('ProjectFormService@setInitialJson() should set-up initial json from form-data',() {
        service.setInitialJson();
        expect(service.initialDataJson, isNotEmpty);
      });

      test('ProjectFormService@projectFormJson() should generate json from form-data',() {
        final tempJson = service.projectFormJson();
        service.setInitialJson();
        expect(service.initialDataJson, tempJson);
      });

      group('ProjectFormService@checkIfNewDataAdded() should check if any addition/update is made in form',() {
        String initialTitle = service.projectAltIdController.text;
        service.setInitialJson();
        test('When no changes in form are made', () {
          final val = service.checkIfNewDataAdded();
          expect(val, false);
        });

        test('When changes in form are made', () {
          service.projectAltIdController.text = "12";
          final val = service.checkIfNewDataAdded();
          expect(val, true);
        });

        test('When changes are reverted', () {
          service.projectAltIdController.text = initialTitle;
          final val = service.checkIfNewDataAdded();
          expect(val, false);
        });
      });

      group('ProjectFormService@checkIfFieldDataChange() should check whether to display form update confirmation',() {
        test("When visibility of field is changed confirmation should be displayed", () {
          mock.companySettingModifier(action: 'visibility');
          final val = service.checkIfFieldDataChange();
          expect(val, true);
        });

        test("When order of field is changed confirmation should be displayed", () {
          mock.companySettingModifier(action: 'reorder');
          final val = service.checkIfFieldDataChange();
          expect(val, true);
        });

        test("When field is removed confirmation should be displayed", () {
          mock.companySettingModifier(action: 'remove');
          final val = service.checkIfFieldDataChange();
          expect(val, true);
        });
      });

      group('ProjectFormService@getCompanySettingProjectFields should return form-fields to be displayed', () {

        test("When user has company settings available", () {
          final fields = service.getCompanySettingProjectFields();
          expect(fields, isNotEmpty);
        });

        test("When user has no company settings", () {
          mock.companySettingModifier(action: 'delete');
          final fields = service.getCompanySettingProjectFields();
          expect(fields.length, ProjectFormFieldsData.fields.length);
        });

        test("When company setting's data is null", () {
          final fields = service.getCompanySettingProjectFields();
          expect(fields.length, ProjectFormFieldsData.fields.length);
        });
      });
    });

    group("ProjectFormService@doShowCompanyCam should show company cam toggle conditionally", () {
      test("CompanyCam toggle should be displayed if company cam is enabled for active account", () {
        ConnectedThirdPartyService.setConnectedParty({
          ConnectedThirdPartyConstants.companyCam: true
        });
        bool result = service.doShowCompanyCam();
        expect(result, isTrue);
      });

      test("CompanyCam toggle should not be displayed if company cam is not enabled for active account", () {
        ConnectedThirdPartyService.connectedThirdParty.clear();
        bool result = service.doShowCompanyCam();
        expect(result, isFalse);
      });
    });

    group('ProjectFormData@getDefaultProjectRep should decide and fill in Project Rep on initial load', () {
      group("When Job Rep Default To Customer Sales Rep setting is enabled", () {
        setUp(() {
          CompanySettingsService.companySettings = {
            CompanySettingConstants.jobRepDefaultToCustomerSalesRep: {"value": 1},
          };
        });

        test('Customer Sales Rep should be filled in as Project Rep if available', () {
          service.job = tempProject..customer = CustomerModel(repId: '123');
          final result = service.getDefaultProjectRep();
          expect(result, ['123']);
        });

        test('First Project Rep should be filled in as Project Rep if Customer Sales Rep is not available', () {
          service.job = tempProject..customer?.repId = null;
          final result = service.getDefaultProjectRep();
          expect(result, isEmpty);
        });

        test('First Project Rep should be filled in as Project Rep if Customer is not available', () {
          service.job = tempProject..customer = null;
          final result = service.getDefaultProjectRep();
          expect(result, isEmpty);
        });

        test('First Project Rep should be filled in as Project Rep if Job is not available', () {
          service.job = null;
          final result = service.getDefaultProjectRep();
          expect(result, isEmpty);
        });
      });

      group("When Job Rep Default To Customer Sales Rep setting is disabled", () {
        setUp(() {
          CompanySettingsService.companySettings = {
            CompanySettingConstants.jobRepDefaultToCustomerSalesRep: {"value": 0},
          };
        });

        test('First Project Rep should be filled in as Project Rep', () {
          final result = service.getDefaultProjectRep();
          expect(result, isEmpty);
        });

        test('First Project Rep should be filled in as Project Rep if Customer Sales Rep is available', () {
          service.job = tempProject..customer = CustomerModel(repId: '123');
          final result = service.getDefaultProjectRep();
          expect(result, isEmpty);
        });
      });
    });
  });

  group("In case of edit project", () {
    ProjectFormService service = ProjectFormService(
        fields: [],
        update: () {}, // method used to update ui directly from service so empty function can be used in testing
        validateForm: () {}, // method used to validate form using form key with is ui based, so can be passes empty for unit testing
        onDataChange: (_) {},
        divisionCode: '',
        formType: JobFormType.edit,
        parenrFormType: ParentFormType.individual,
        showCompanyCam: null // this method is called when data in dynamic field changes
        );

    void setEditFormData() {
      service.job = tempProject;
      service.projectRepEstimatorList = tempMultiSelectionList;
      service.setFormData();
    }

    group("ProjectFormService@setFormData should set-up form values", () {
      test("Text field values should be properly initialized", () {
        final days = Helper.splitDurationintoMap('day', tempProject.duration ?? "");
        final hours = Helper.splitDurationintoMap('hour', days['remainingData']!);
        final minutes = Helper.splitDurationintoMap('minute', hours['remainingData']!);
        setEditFormData();
        expect(service.projectAltIdController.text, tempProject.altId);
        expect(service.projectDescriptionController.text, tempProject.description);
        expect(service.projectDurationDayController.text, days['result']);
        expect(service.projectDurationHourController.text, hours['result']);
        expect(service.projectDurationMinController.text, minutes['result']);
      });
    });

    group("ProjectFormService@doShowCompanyCam should show company cam toggle conditionally", () {
      group("Company cam toggle not should be displayed", () {
        test("When company cam is not enabled for active account and is not linked with job", () {
          ConnectedThirdPartyService.connectedThirdParty.clear();
          service.job?.meta = null;
          bool result = service.doShowCompanyCam();
          expect(result, isFalse);
        });

        test("When company cam is already linked with job and company cam is enabled for active account", () {
          ConnectedThirdPartyService.setConnectedParty({
            ConnectedThirdPartyConstants.companyCam: true
          });
          service.job?.meta = JobMetaModel(
              companyCamId: '123'
          );
          bool result = service.doShowCompanyCam();
          expect(result, isFalse);
        });

        test("When company cam is linked with job and is not enabled for active account", () {
          ConnectedThirdPartyService.connectedThirdParty.clear();
          service.job?.meta = JobMetaModel(
              companyCamId: '123'
          );
          bool result = service.doShowCompanyCam();
          expect(result, isFalse);
        });
      });

      test("Company cam toggle should be displayed, When company cam is not linked with job and is enabled for active account", () {
        ConnectedThirdPartyService.setConnectedParty({
          ConnectedThirdPartyConstants.companyCam: true
        });
        service.job?.meta = null;
        bool result = service.doShowCompanyCam();
        expect(result, isTrue);
      });
    });
  });
}
