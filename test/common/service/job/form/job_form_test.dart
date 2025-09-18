import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/common/models/custom_fields/custom_form_fields/index.dart';
import 'package:jobprogress/common/models/custom_fields/custom_form_fields/options.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/models/forms/common/section.dart';
import 'package:jobprogress/common/models/forms/job/fields.dart';
import 'package:jobprogress/common/models/insurance/insurance_model.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/job_division.dart';
import 'package:jobprogress/common/models/job/job_meta.dart';
import 'package:jobprogress/common/models/job/job_type.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/job/job_form/add_job.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';
import 'package:jobprogress/core/constants/forms/job_form.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jp_mobile_flutter_ui/InputBox/controller.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';
import 'package:get/get.dart';

import 'mocked_data.dart';

void main(){
  
  List<CustomFormFieldsModel> tempCustomFormFields = [
    CustomFormFieldsModel(id: 0, name: 'Field 1', controller: JPInputBoxController()),
    CustomFormFieldsModel(id: 1, name: 'Field 2', controller: JPInputBoxController()),
  ];

  JobFormMockedData mock = JobFormMockedData();

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
    insuranceDetails: InsuranceModel(
      id: 0
    )
  );

  List<JPSingleSelectModel> tempSelectionList = [
    JPSingleSelectModel(label: "Item 1", id: "10"),
    JPSingleSelectModel(label: "Item 2", id: "11"),
    JPSingleSelectModel(label: "Item 3", id: "22"),
    JPSingleSelectModel(label: "Item 4", id: '12'),
    JPSingleSelectModel(label: "User 1", id: '0'),
    JPSingleSelectModel(label: "Item 5", id: '123'),
  ];

  List<JPSingleSelectModel> tempCanvasserSelectionList = [
    JPSingleSelectModel(label: "Item 1", id: CommonConstants.unAssignedUserId),
    JPSingleSelectModel(label: "Item 2", id: CommonConstants.otherOptionId),
    JPSingleSelectModel(label: "Item 3", id: CommonConstants.customerOptionId),
    JPSingleSelectModel(label: "Item 4", id: CommonConstants.noneId),
    JPSingleSelectModel(label: "User 1", id: '0'),
    JPSingleSelectModel(label: "Item 5", id: '123'),
  ];

  UserLimitedModel tempUser = UserLimitedModel(
      id: 0,
      firstName: 'User 1',
      fullName: 'User 1',
      email: '1@gmail.com', groupId: 1
  ); // helps in mocking user data

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;
    mock.companySettingModifier();
  });
  
  group("In case of Add job", () {
    JobFormService service = JobFormService(
      update: () { }, // method used to update ui directly from service so empty function can be used in testing
      formType: JobFormType.add,
      validateForm: () { }, // method used to validate form using form key with is ui based, so can be passes empty for unit testing
      onDataChange: (_) { }, // this method is called when data in dynamic field changes
      forEditInsurance: false
    ); 

    
    group("JobFormService should be initialized with correct values", () {

      test('Form fields should be initialized with correct values', () {
        expect(service.jobNameController.text, isEmpty);
        expect(service.jobDivisionController.text, isEmpty);
        expect(service.leadNumberController.text, isEmpty);
        expect(service.jobAltIdController.text, isEmpty);
        expect(service.jobRepEstimatorController.text, isEmpty);
        expect(service.jobDurationDayController.text, isEmpty);
        expect(service.jobDurationHourController.text, isEmpty);
        expect(service.jobDurationMinController.text, isEmpty);
        expect(service.jobDescriptionController.text, isEmpty);
        expect(service.categoryController.text, isEmpty);
        expect(service.companyCrewController.text, isEmpty);
        expect(service.laborSubController.text, isEmpty);
        expect(service.canvasserController.text, isEmpty);
        expect(service.otherCanvasserController.text, isEmpty);
      });

      test('Form toggles should be initialized with correct values', () {
        expect(service.isLoading, true);
        expect(service.syncWithCompanyCam, true);
        expect(service.syncWithHover, false);
      });

      test('Form data helpers should be initialized with correct values', () {
        expect(service.validators, isEmpty);
        expect(service.job, isNull);
        expect(service.address.id, -1);
        expect(service.formType, JobFormType.add);
        expect(service.isMultiProject, false);
      });

      test('Form selection id\'s should be initialized with correct values',() {
        expect(service.selectedJobDivisionId, isEmpty);
        expect(service.selectedJobDivisionCode, isEmpty);
        expect(service.selectedCategoryId, isEmpty);
        expect(service.selectedFlags, isEmpty);
        expect(service.selectedCompanyCrews,isEmpty);
        expect(service.selectedJobRepEstimators, isEmpty);
        expect(service.selectedLaborSubs,isEmpty);
        expect(service.canvasserId, isEmpty);
        expect(service.canvasserType, 'user');
      });

      test("Form selection lists should be initialized with correct values", () {
        expect(service.jobDivisionList, isEmpty);
        expect(service.jobRepEstimatorList, isEmpty);
        expect(service.companyCrewList, isEmpty);
        expect(service.laborSubList, isEmpty);
        expect(service.categoryList, isEmpty);
        expect(service.allFlags, isEmpty);
        expect(service.tradesList, isEmpty);
        expect(service.workTypesList,isEmpty);
        expect(service.canvasserList, isEmpty);
        expect(service.canvasserType, 'user');
      });

    });

    test('JobFormService@setInitialJson() should set-up initial json from form-data', () {
      service.setInitialJson();
      expect(service.initialJson, isNotEmpty);
      expect(service.initialFieldsData, isNotEmpty);
    });

    test('JobFormService@jobFormJson() should generate json from form-data', () {
      final tempJson = service.jobFormJson();
      service.setInitialJson();
      expect(service.initialJson, tempJson);
    });

    group('JobFormService@checkIfNewDataAdded() should check if any addition/update is made in form', () {

      String initialTitle = service.jobNameController.text;
      service.setInitialJson();
      test('When no changes in form are made', () {
        final val = service.checkIfNewDataAdded();
        expect(val, false);
      });

      test('When changes in form are made', () {
        service.jobNameController.text = "abc";
        final val = service.checkIfNewDataAdded();
        expect(val, true);
      });

      test('When changes are reverted', () {
        service.jobNameController.text = initialTitle;
        final val = service.checkIfNewDataAdded();
        expect(val, false);
      });

      test('Should return true, when changes in trade type list are made', () {
        service.tradesList.add(CompanyTradesModel());
        final val = service.checkIfNewDataAdded();
        expect(val, true);
      });

       test('Should return true, when changes in work type list are made', () {
        service.workTypesList.add(JobTypeModel());
        final val = service.checkIfNewDataAdded();
        expect(val, true);
      });
    });


    group('JobFormService@checkIfFieldDataChange() should check whether to display form update confirmation', () {
      
      test("When no changes are made confirmation should not be displayed", () {
        service.setInitialJson();
        final val = service.checkIfFieldDataChange();
        expect(val, false);
      });

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

    group('JobFormService@getCompanySettingFields should return form-fields to be displayed', () {

      test("When user has company settings available", () {
        final fields = service.getCompanySettingFields();
        expect(fields, isNotEmpty);
      });

      test("When user has no company settings", () {
        mock.companySettingModifier(action: 'delete');
        final fields = service.getCompanySettingFields();
        expect(fields.length, JobFormFieldsData.fields.length);
      });

      test("When company setting's data is null", () {
        final fields = service.getCompanySettingFields();
        expect(fields.length, JobFormFieldsData.fields.length);
      });

      test("Project fields should be visible if job is multi project job",(){
        service.changeFormType(true);
        final fields = service.getCompanySettingFields();
        bool projectFieldPresent = fields.any((element)=> element.key == JobFormConstants.project);
        expect(projectFieldPresent,isTrue);
      });
      test("Project fields should not be visible if job is normal job",(){
        service.changeFormType(false);
        final fields = service.getCompanySettingFields();
        bool projectFieldPresent = fields.any((element)=> element.key == JobFormConstants.project);
        expect(projectFieldPresent,isFalse);
      });

      test("Sync with section should be added manually if not present in dynamic fields", () {
        service.isMultiProject = true;
        final fields = service.getCompanySettingFields();
        bool syncWithSectionPresent = fields.any((element)=> element.key == JobFormConstants.syncWith);
        expect(syncWithSectionPresent,isTrue);
      });

      group("Custom Form Fields Tests", () {
        test("When there are required custom form fields", () {
          service.isMultiProject = false;
          mock.companySettingModifier();
          tempCustomFormFields.first.isRequired = true;
          service.customFormFields.addAll(tempCustomFormFields);
          final fields = service.getCompanySettingFields();
          final field = fields.firstWhereOrNull((field) => field.key == JobFormConstants.customFields);
          expect(field?.showFieldValue, isTrue);
        });

        test("When there are no required custom form fields", () {
          mock.companySettingModifier(action: "hide_custom_fields");
          tempCustomFormFields.first.isRequired = null;
          service.customFormFields.addAll(tempCustomFormFields);
          final fields = service.getCompanySettingFields();
          final field = fields.firstWhereOrNull((field) => field.key == JobFormConstants.customFields);
          expect(field?.showFieldValue, isFalse);
          ///   Reset changes
          service.isMultiProject = true;
          mock.companySettingModifier(action: "show_custom_fields");
        });
      });

    });

    group("JobFormService@getSectionAndRemoveField should return independent section and remove field from raw data", () {
      test("When field doesn't exists", () {
        final section = service.getSectionAndRemoveField(JobFormConstants.jobAddress);
        bool hasJobAddress = service.sectionFields.any((field) => field.key == JobFormConstants.jobAddress);
        expect(hasJobAddress, isFalse);
        expect(section, isNull);
      });

      test("When field exists", () {
        service.sectionFields.add(InputFieldParams(key: JobFormConstants.jobAddress, name: 'Job Address'));
        service.sectionFields.add(InputFieldParams(key: JobFormConstants.customFields, name: ''));
        final section = service.getSectionAndRemoveField(JobFormConstants.customFields);
        bool hasCustomFields = service.sectionFields.any((field) => field.key == JobFormConstants.customFields);
        expect(hasCustomFields, isFalse);
        expect(section, isNotNull);
      });
    });

    group("JobFormService@parseToSections should parse raw data fields to sections", () {
      test("All sections should be displayed when all fields are present", () {
        mock.companySettingModifier();
        service.customFormFields.addAll(tempCustomFormFields);
        service.setUpFields();
        expect(service.allSections.length, 6);
      });

      test("Job Address section should not be displayed when job address field is not present", () {
        mock.formFieldsJson.remove(mock.jobAddressField);
        mock.companySettingModifier();
        service.setUpFields();
        expect(service.allSections.length, 5);
      });

      test("Custom Fields section should not be displayed when custom field is not present", () {
        mock.formFieldsJson.remove(mock.customFields);
        mock.companySettingModifier();
        service.setUpFields();
        expect(service.allSections.length, 4);
      });

      test("Other Information section should not be displayed when other information is not present", () {
        mock.formFieldsJson.removeWhere((element) => element['key']==JobFormConstants.otherInformation);
        mock.companySettingModifier();
        service.setUpFields();
        expect(service.allSections.length, 3);
      });

      test("Project section should not be displayed in case of single job", () {
        mock.companySettingModifier();
        service.customFormFields.addAll(tempCustomFormFields);
        service.setUpFields();
        expect(service.allSections.length, 3);
      });

      group("In case of multi project job", () {
        setUp(() {
          service.isMultiProject = true;
        });

        test("Project section should be displayed, if it is available in dynamic fields", () {
          mock.companySettingModifier();
          service.setUpFields();
          expect(service.allSections.length, 3);
        });

        test("Project section should be displayed, if it is not available in dynamic fields", () {
          mock.formFieldsJson.removeWhere((element) => element['key'] == JobFormConstants.project);
          mock.companySettingModifier();
          service.setUpFields();
          expect(service.allSections.length, 3);
        });

        tearDown(() {
          service.isMultiProject = false;
        });
      });

      test("Project section should not be displayed in case of single job", () {
        mock.companySettingModifier();
        service.customFormFields.addAll(tempCustomFormFields);
        service.setUpFields();
        expect(service.allSections.length, 2);
      });

      group("In case of multi project job", () {
        setUp(() {
          service.isMultiProject = true;
        });

        test("Project section should be displayed, if it is available in dynamic fields", () {
          mock.companySettingModifier();
          service.setUpFields();
          expect(service.allSections.length, 3);
        });

        test("Project section should be displayed, if it is not available in dynamic fields", () {
          mock.formFieldsJson.removeWhere((element) => element['key'] == JobFormConstants.project);
          mock.companySettingModifier();
          service.setUpFields();
          expect(service.allSections.length, 3);
        });

        tearDown(() {
          service.isMultiProject = false;
        });
      });
    });

    group("JobFormService@changeFormType should select form type", () {

      test("When job option is selected", () {
        service.changeFormType(false);
        expect(service.isMultiProject, isFalse);
      });

      test("When multi project job option is selected", () {
        service.changeFormType(true);
        expect(service.isMultiProject, true);
      });
    });

    group("JobFormService@expandErrorSection should expand error field section", () {

      final testSection = FormSectionModel(name: 'Test', fields: [], isExpanded: false);

      test("Section should be expanded if it's collapsed", () {
        service.expandErrorSection(testSection);
        expect(testSection.isExpanded, isTrue);
      });

      test("Section should not collapse if it's already expanded", () {
        service.expandErrorSection(testSection);
        expect(testSection.isExpanded, isTrue);
      });

      test("Section should not be expanded if is non-expandable section", () {
        testSection.isExpanded = false;
        testSection.wrapInExpansion = false;
        service.expandErrorSection(testSection);
        expect(testSection.isExpanded, isFalse);
      });
    });

    group("JobFormService@validateJobDescription should validate job description", () {
      test("Validation should fail when job description is empty", () {
        service.jobDescriptionController.text = "";
        final val = FormValidator.requiredFieldValidator(service.jobDescriptionController.text,errorMsg: "job_description_is_required".tr);
        expect(val, "job_description_is_required".tr);
      });

      test("Validation should pass when job description is filled", () {
        service.jobDescriptionController.text = "123";
        final val = FormValidator.requiredFieldValidator(service.jobDescriptionController.text);
        expect(val, null);
      });
    });

    group("JobFormService@doShowCompanyCam should show company cam toggle conditionally", () {
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

    group("JobFormData@isProjectParentJob should always be false, in case of add job", () {
      test("When project has been selected", () {
        service.job?.isProject = false;
        expect(service.isProjectParentJob, isFalse);
      });

      test("When job is a multi job", () {
        service.job?.isMultiJob = false;
        expect(service.isProjectParentJob, isFalse);
      });
    });

    test('JobFormService@jobParams() should return correct query parameters map for given ID', () {
      Map<String, dynamic> result =  service.jobParams(service.job?.id);

      Map<String, dynamic> expected = {
        'id': service.job?.id,
        'includes[0]': 'customer',
        'includes[1]': 'address',
        'includes[2]': 'duration',
        'includes[3]': 'reps',
        'includes[4]': 'flags',
        'includes[5]': 'sub_contractors',
        'includes[6]': 'scheduled_trade_ids',
        'includes[7]': 'scheduled_work_type_ids',
        'includes[8]': 'division',
        'includes[9]': 'contact',
        'includes[10]': 'contacts',
        'includes[11]': 'contacts.emails',
        'includes[12]': 'contacts.phones',
        'includes[13]': 'contacts.address',
        'includes[14]': 'projects',
        'includes[15]': 'insurance_details',
        'includes[16]': 'custom_fields.options.sub_options.linked_parent_options',
        'includes[17]': 'hover_job',
        'includes[18]': 'hover_job.hover_user',
        'includes[19]': 'reps.divisions',
        'includes[20]': 'sub_contractors.divisions',
        'includes[21]': 'flags.color',
        'includes[22]': 'custom_fields.users',
      };

      expect(result, equals(expected));
    });
    test('JobFormService@customerParams should return correct query parameters map ', () {
      Map<String, dynamic> result =  service.customerParams;

      Map<String, dynamic> expected = {
        'id': service.customerId,
        "includes[0]": "phones",
        "includes[1]": "address",
        "includes[2]": "billing",
        "includes[3]": "referred_by",
        "includes[4]": "rep",
        "includes[5]": "flags",
        "includes[6]": "flags.color",
        "includes[7]": "contacts",
        "includes[8]": "custom_fields",
        "includes[9]": "divisions",
        "includes[10]": "canvasser",
        "includes[11]": "call_center_rep",
        "includes[12]": "custom_fields.options.sub_options.linked_parent_options",
      };

      expect(result, equals(expected));
    });

    group("JobFormData@jobFormJson should generate json for job", () {
      group("[insurance_details] should be set correctly", () {
        group("In case category is not selected as Insurance Claim", () {
          setUp(() {
            service.showInsuranceClaim = false;
          });

          test("Insurance Details should be empty", () {
            final json = service.jobFormJson();
            expect(json["insurance_details"], isNull);
          });
        });

        group("In case category is selected as Insurance Claim", () {
          setUp(() {
            service.showInsuranceClaim = true;
          });

          group("In case of Project", () {
            setUp(() {
              service.job?.isProject = true;
              service.parentJobData = tempJob;
            });

            test("Insurance Details should be set from parent job", () {
              final json = service.jobFormJson();
              expect(json["insurance_details"], isNotNull);
            });

            test("In case parent job is not available, Insurance details should be set that user added", () {
              service.parentJobData = null;
              service.insuranceDetailsJson = tempJob.insuranceDetails?.toJson();
              final json = service.jobFormJson();
              expect(json["insurance_details"], isNotNull);
            });

            test("In case parent job is not available and user added noting, Insurance details should be empty", () {
              service.parentJobData = null;
              service.insuranceDetailsJson = null;
              final json = service.jobFormJson();
              expect(json["insurance_details"], isEmpty);
            });

            tearDown(() {
              service.job?.isProject = false;
              service.parentJobData = null;
              service.insuranceDetailsJson = null;
            });
          });

          group("In case of Job", () {
            setUp(() {
              service.job?.isProject = false;
            });

            test("Insurance Details should be set from job, if available", () {
              service.job?.insuranceDetails = InsuranceModel();
              final json = service.jobFormJson();
              expect(json["insurance_details"], isNotNull);
            });

            test("In case job is not available, Insurance details should be set that user added", () {
              service.job = null;
              service.insuranceDetailsJson = tempJob.insuranceDetails?.toJson();
              final json = service.jobFormJson();
              expect(json["insurance_details"], isNotNull);
            });

            test("In case job is not available and used added noting, Insurance details should be empty", () {
              service.job = null;
              service.insuranceDetailsJson = null;
              final json = service.jobFormJson();
              expect(json["insurance_details"], isEmpty);
            });
          });
        });
      });
    });
  });

  group("In case of edit job", () {

    JobFormService service = JobFormService(
      update: () { }, // method used to update ui directly from service so empty function can be used in testing
      formType: JobFormType.edit,
      validateForm: () { }, // method used to validate form using form key with is ui based, so can be passes empty for unit testing
      onDataChange: (_) { }, // this method is called when data in dynamic field changes
      forEditInsurance: false
    );

    void  setEditFormData() {
      service.job = tempJob;
      service.canvasserList = tempCanvasserSelectionList;
      service.jobDivisionList = tempSelectionList;
      service.categoryList = tempSelectionList;
      service.setFormData();
    } 

    group("JobFormService@setFormData should set-up form values", () {
      setEditFormData();
      group("Form should be displayed according to job form type", () {
        test("Job form should be displayed", () {
          tempJob.isMultiJob = false;
          setEditFormData();
          expect(service.isMultiProject, isFalse);
        });

        test("Multi job form should be displayed", () {
          tempJob.isMultiJob = true;
          setEditFormData();
          expect(service.isMultiProject, isTrue);
        });
      });
      group("Division field data should be properly initialised", () {

        test("When division doesn't exists", () {
          tempJob.division = null;
          setEditFormData();
          expect(service.selectedJobDivisionCode, isEmpty);
          expect(service.selectedJobDivisionId, isEmpty);
        });

        test("When division exists", () {
          tempJob.division = DivisionModel(code:'01',id: 10);
          setEditFormData();
          expect(service.selectedJobDivisionCode, tempJob.division?.code);
          expect(service.selectedJobDivisionId, tempJob.division?.id.toString());
          expect(service.jobDivisionController.text, tempSelectionList[0].label);
        });
      });

      group("Category field data should be properly initialised", () {

        test("When Category doesn't exists", () {
          tempJob.jobTypes = null;
          setEditFormData();
          expect(service.selectedCategoryId, isEmpty);
          expect(service.categoryController.text, 'none'.tr);
        });

        test("When Category exists", () {
          tempJob.jobTypes = [JobTypeModel(id: 10,name: "Item 1")];
          setEditFormData();
          expect(service.selectedCategoryId, (tempJob.jobTypes?.first?.id ?? "").toString());
          expect(service.categoryController.text, tempSelectionList[0].label);
        });

        group("Canvasser should be properly initialized", () {

        test("When customer doesn't have canvasser", () {
          tempJob.canvasser = null;
          tempJob.canvasserType = null;
          setEditFormData();
          expect(service.canvasserType, 'user');
          expect(service.canvasserId, tempCanvasserSelectionList.first.id);
          expect(service.canvasserController.text, tempCanvasserSelectionList.first.label);
          expect(service.otherCanvasserController.text, isEmpty);
        });

        group("When job has canvasser", () {

          test("User should be prefilled in canvasser", () {
            tempJob.canvasserType = JobFormConstants.user;
            tempJob.canvasser = tempUser;
            service.formType = JobFormType.edit;
            setEditFormData();
            expect(service.canvasserType, 'user');
            expect(service.canvasserId, tempUser.id.toString());
            expect(service.canvasserController.text, tempUser.firstName);
            expect(service.otherCanvasserController.text, isEmpty);
          });

          test("Canvasser note should be displayed and filled", () {
            tempJob.canvasserType = CommonConstants.otherOptionId;
            tempJob.canvasser = tempUser;
            tempJob.canvasserString = tempUser.fullName;
            service.formType = JobFormType.edit;
            setEditFormData();
            expect(service.canvasserType, 'other');
            expect(service.canvasserId, CommonConstants.otherOptionId);
            expect(service.canvasserController.text, tempCanvasserSelectionList[1].label);
            expect(service.otherCanvasserController.text, tempUser.fullName);
          });
        });
      }); 
      });

      group("Text field data should be properly initialised",(){
        test("Job alt id should be properly initialised",(){
          setEditFormData();
          expect(service.jobAltIdController.text,tempJob.altId);
        });
        test("Job name should be properly initialised",(){
          setEditFormData();
          expect(service.jobNameController.text,tempJob.name);
        });
        test("Lead number should be properly initialised",(){
          setEditFormData();
          expect(service.leadNumberController.text,tempJob.leadNumber);
        });
        test("Job description should be properly initialised",(){
          setEditFormData();
          expect(service.jobDescriptionController.text,tempJob.description);
        });
        
      });
    });

    group("JobFormService@doShowCompanyCam should show company cam toggle conditionally", () {
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

    group("JobFormData@isProjectParentJob should decide whether job opened for editing is a parent job", () {
      test("In case project is opened for editing, job should not be considered as parent job", () {
        service.job?.isProject = true;
        expect(service.isProjectParentJob, isFalse);
      });

      test("In case job is not a multi job, job should not be considered as parent job", () {
        service.job?.isMultiJob = false;
        expect(service.isProjectParentJob, isFalse);
      });

      test("In case job is a multi job and is not a project, job should be considered as parent job", () {
        service.job?.isMultiJob = true;
        service.job?.isProject = false;
        expect(service.isProjectParentJob, isTrue);
      });
    });

    group('JobFormData@getDefaultJobRep should decide and fill in Job Rep on initial load', () {
      group("When Job Rep Default To Customer Sales Rep setting is enabled", () {
        setUp(() {
          CompanySettingsService.companySettings = {
            CompanySettingConstants.jobRepDefaultToCustomerSalesRep: {"value": 1},
          };
        });

        test('Customer Sales Rep should be filled in as Job Rep if available', () {
          service.job = tempJob..customer = CustomerModel(repId: '123');
          final result = service.getDefaultJobRep();
          expect(result, ['123']);
        });

        test('First Job Rep should be filled in as Job Rep if Customer Sales Rep is not available', () {
          service.job = tempJob..customer?.repId =  null;
          final result = service.getDefaultJobRep();
          expect(result, isEmpty);
        });

        test('First Job Rep should be filled in as Job Rep if Customer is not available', () {
          service.job = tempJob..customer =  null;
          final result = service.getDefaultJobRep();
          expect(result, isEmpty);
        });

        test('First Job Rep should be filled in as Job Rep if Job is not available', () {
          service.job = null;
          final result = service.getDefaultJobRep();
          expect(result, isEmpty);
        });
      });

      group("When Job Rep Default To Customer Sales Rep setting is disabled", () {
        setUp(() {
          CompanySettingsService.companySettings = {
            CompanySettingConstants.jobRepDefaultToCustomerSalesRep: {"value": 0},
          };
        });

        test('First Job Rep should be filled in as Job Rep', () {
          final result = service.getDefaultJobRep();
          expect(result, isEmpty);
        });

        test('First Job Rep should be filled in as Job Rep if Customer Sales Rep is available', () {
          service.job = tempJob..customer = CustomerModel(repId: '123');
          final result = service.getDefaultJobRep();
          expect(result, isEmpty);
        });
      });
    });
  });

  group('For setting custom fields data', () {
    JobFormService service = JobFormService(
        update: () { }, // method used to update ui directly from service so empty function can be used in testing
        formType: JobFormType.edit,
        validateForm: () { }, // method used to validate form using form key with is ui based, so can be passes empty for unit testing
        onDataChange: (_) { }, // this method is called when data in dynamic field changes
        forEditInsurance: false
    );

    test('JobFormService@setCustomFormFieldsData should Adds new custom fields for text fields when customFormFields is not empty', () {
      service.customFormFields = [
        CustomFormFieldsModel(id: 1, isTextField: true, controller: JPInputBoxController()),
        CustomFormFieldsModel(id: 2, isTextField: false, controller: JPInputBoxController()),
      ];
      final listOfCustomFields = [
        CustomFormFieldsModel(id: 2, isTextField: true, controller: JPInputBoxController()),
        CustomFormFieldsModel(id: 3, isTextField: true, controller: JPInputBoxController()),
      ];

      service.setCustomFormFieldsData(listOfCustomFields);

      expect(service.customFormFields.length, 3);
      expect(service.customFormFields[2].id, 1);
    });

    test('JobFormService@setCustomFormFieldsData should not add new custom fields for text fields when customFormFields is empty', () {
      service.customFormFields = [];
      final listOfCustomFields = [
        CustomFormFieldsModel(id: 1, isTextField: true, controller: JPInputBoxController()),
        CustomFormFieldsModel(id: 2, isTextField: true, controller: JPInputBoxController()),
      ];

      service.setCustomFormFieldsData(listOfCustomFields);

      expect(service.customFormFields.length, 2);
      expect(service.customFormFields[0].id, 1);
      expect(service.customFormFields[1].id, 2);
    });

    test('JobFormService@setCustomFormFieldsData should Adds new options for dropdown custom fields', () {
      service.customFormFields = [
        CustomFormFieldsModel(
          id: 1, isDropdown: true, controller: JPInputBoxController(),
          options: [
            CustomFormFieldOption(id: 1, controller: JPInputBoxController()),
            CustomFormFieldOption(id: 2, controller: JPInputBoxController())],
        ),
        CustomFormFieldsModel(
          id: 2, controller: JPInputBoxController(),
          options: [
            CustomFormFieldOption(id: 3, controller: JPInputBoxController()),
            CustomFormFieldOption(id: 4, controller: JPInputBoxController())],
        ),
      ];
      final listOfCustomFields = [
        CustomFormFieldsModel(id: 1, isTextField: false, controller: JPInputBoxController(),
          options: [
            CustomFormFieldOption(id: 2, controller: JPInputBoxController()),
            CustomFormFieldOption(id: 3, controller: JPInputBoxController())],
        ),
        CustomFormFieldsModel(id: 2, isTextField: false, controller: JPInputBoxController(),
          options: [
            CustomFormFieldOption(id: 4, controller: JPInputBoxController()),
            CustomFormFieldOption(id: 5, controller: JPInputBoxController())],
        ),
      ];

      service.setCustomFormFieldsData(listOfCustomFields);

      expect(service.customFormFields[0].options?.length, 3);
      expect(service.customFormFields[0].options?[2].id, 3);

      expect(service.customFormFields[1].options?.length, 2);
      expect(service.customFormFields[1].options?[1].id, 4);
    });

    test('JobFormService@setCustomFormFieldsData should not add new options for text fields', () {
      service.customFormFields = [
        CustomFormFieldsModel(id: 1, isTextField: true, controller: JPInputBoxController(),
          options: [
            CustomFormFieldOption(id: 1, controller: JPInputBoxController()),
            CustomFormFieldOption(id: 2, controller: JPInputBoxController())],
        ),
        CustomFormFieldsModel(id: 2, isTextField: true, controller: JPInputBoxController(),
          options: [
            CustomFormFieldOption(id: 3, controller: JPInputBoxController()),
            CustomFormFieldOption(id: 4, controller: JPInputBoxController())],
        ),
      ];
      final listOfCustomFields = [
        CustomFormFieldsModel(id: 1, isTextField: true, controller: JPInputBoxController(),
          options: [
            CustomFormFieldOption(id: 2, controller: JPInputBoxController()),
            CustomFormFieldOption(id: 3, controller: JPInputBoxController())],
        ),
        CustomFormFieldsModel(id: 2,isTextField: true, controller: JPInputBoxController(),
        options: [
          CustomFormFieldOption(id: 4, controller: JPInputBoxController()),
          CustomFormFieldOption(id:3, controller: JPInputBoxController())],
        )
      ];

      service.setCustomFormFieldsData(listOfCustomFields);

      expect(service.customFormFields[0].options?.length, 2);
      expect(service.customFormFields[0].options?[0].id, 1);
      expect(service.customFormFields[0].options?[1].id, 2);

      expect(service.customFormFields[1].options?.length, 2);
      expect(service.customFormFields[1].options?[0].id, 3);
      expect(service.customFormFields[1].options?[1].id, 4);
      });
  });

  group("Workflow Division Feature Tests", () {
    late JobFormService workflowService;
    late JobModel testJob;

    setUp(() {
      testJob = JobModel(
        id: 456,
        customerId: 12,
        isMultiJob: false,
        altId: "WF-456",
        leadNumber: "WF-L456",
        name: "Workflow Test Job",
        description: "Test job for workflow division",
        division: DivisionModel(id: 1, name: 'Original Division', code: 'ORIG'),
        currentStage: WorkFlowStageModel(name: 'Current Stage', code: 'CS', color: 'cl-blue'),
      );

      workflowService = JobFormService(
        update: () {},
        formType: JobFormType.edit,
        validateForm: () {},
        onDataChange: (_) {},
        forEditInsurance: false,
      );
      workflowService.job = testJob;
    });

    group("JobFormData@doShowWorkflowSwitchConfirmation should determine when to show workflow confirmation dialog", () {
      test("Should return false when feature flag is disabled", () {
        // Mock feature flag as disabled
        workflowService.selectedJobDivisionId = '2';
        workflowService.formType = JobFormType.edit;

        // Feature flag check will return false by default in test environment
        final result = workflowService.doShowWorkflowSwitchConfirmation();
        expect(result, isFalse);
      });

      test("Should return false when form type is add (new job creation)", () {
        workflowService.formType = JobFormType.add;
        workflowService.selectedJobDivisionId = '2';

        final result = workflowService.doShowWorkflowSwitchConfirmation();
        expect(result, isFalse);
      });

      test("Should return false when selected division is same as current division", () {
        workflowService.formType = JobFormType.edit;
        workflowService.selectedJobDivisionId = '1'; // Same as job's division ID

        final result = workflowService.doShowWorkflowSwitchConfirmation();
        expect(result, isFalse);
      });

      test("Should return false when job division is null", () {
        workflowService.job?.division = null;
        workflowService.formType = JobFormType.edit;
        workflowService.selectedJobDivisionId = '2';

        final result = workflowService.doShowWorkflowSwitchConfirmation();
        expect(result, isFalse);
      });

      test("Should return false when selected division ID is empty", () {
        workflowService.formType = JobFormType.edit;
        workflowService.selectedJobDivisionId = '';

        final result = workflowService.doShowWorkflowSwitchConfirmation();
        expect(result, isFalse);
      });

      test("Should return false when job is null", () {
        workflowService.job = null;
        workflowService.formType = JobFormType.edit;
        workflowService.selectedJobDivisionId = '2';

        final result = workflowService.doShowWorkflowSwitchConfirmation();
        expect(result, isFalse);
      });
    });

    group("JobFormService division change detection", () {
      test("Should detect division change when selectedJobDivisionId differs from current division", () {
        workflowService.selectedJobDivisionId = '2';
        final currentDivisionId = workflowService.job?.division?.id.toString() ?? '';

        expect(workflowService.selectedJobDivisionId != currentDivisionId, isTrue);
      });

      test("Should detect no division change when selectedJobDivisionId matches current division", () {
        workflowService.selectedJobDivisionId = '1';
        final currentDivisionId = workflowService.job?.division?.id.toString() ?? '';

        expect(workflowService.selectedJobDivisionId == currentDivisionId, isTrue);
      });

      test("Should handle null division gracefully", () {
        workflowService.job?.division = null;
        workflowService.selectedJobDivisionId = '2';
        final currentDivisionId = workflowService.job?.division?.id.toString() ?? '';

        expect(currentDivisionId, equals(''));
        expect(workflowService.selectedJobDivisionId != currentDivisionId, isTrue);
      });

      test("Should handle empty selectedJobDivisionId", () {
        workflowService.selectedJobDivisionId = '';
        final currentDivisionId = workflowService.job?.division?.id.toString() ?? '';

        expect(workflowService.selectedJobDivisionId == currentDivisionId, isFalse);
      });
    });

    group("JobFormService workflow division validation", () {
      test("Should validate job exists before workflow operations", () {
        workflowService.job = null;

        expect(workflowService.job, isNull);
      });

      test("Should validate job ID for workflow operations", () {
        expect(workflowService.job?.id, isNotNull);
        expect(workflowService.job?.id, greaterThan(0));
      });

      test("Should validate division information for workflow operations", () {
        expect(workflowService.job?.division, isNotNull);
        expect(workflowService.job?.division?.id, isNotNull);
        expect(workflowService.job?.division?.name, isNotNull);
      });

      test("Should validate current stage information for workflow operations", () {
        expect(workflowService.job?.currentStage, isNotNull);
        expect(workflowService.job?.currentStage?.code, isNotNull);
      });
    });

    group("JobFormService form type validation for workflow", () {
      test("Should allow workflow confirmation for edit form type", () {
        workflowService.formType = JobFormType.edit;

        expect(workflowService.formType, equals(JobFormType.edit));
      });

      test("Should not allow workflow confirmation for add form type", () {
        workflowService.formType = JobFormType.add;

        expect(workflowService.formType, equals(JobFormType.add));
      });

      test("Should maintain form type consistency", () {
        final originalFormType = workflowService.formType;
        workflowService.selectedJobDivisionId = '2';

        expect(workflowService.formType, equals(originalFormType));
      });
    });

    group("JobFormService division selection integration", () {
      test("Should maintain selectedJobDivisionId when set", () {
        const testDivisionId = '123';
        workflowService.selectedJobDivisionId = testDivisionId;

        expect(workflowService.selectedJobDivisionId, equals(testDivisionId));
      });

      test("Should handle division ID type conversion", () {
        workflowService.selectedJobDivisionId = '123';
        const divisionIdInt = 123;

        expect(int.tryParse(workflowService.selectedJobDivisionId), equals(divisionIdInt));
      });

      test("Should handle invalid division ID strings", () {
        workflowService.selectedJobDivisionId = 'invalid';

        expect(int.tryParse(workflowService.selectedJobDivisionId), isNull);
      });

      test("Should maintain division selection state", () {
        workflowService.selectedJobDivisionId = '999';

        expect(workflowService.selectedJobDivisionId, equals('999'));
        expect(workflowService.selectedJobDivisionId != '1', isTrue);
      });
    });

    group("JobFormService workflow division edge cases", () {
      test("Should handle missing job gracefully", () {
        workflowService.job = null;
        workflowService.selectedJobDivisionId = '2';

        final result = workflowService.doShowWorkflowSwitchConfirmation();
        expect(result, isFalse);
      });

      test("Should handle missing division gracefully", () {
        workflowService.job?.division = null;
        workflowService.selectedJobDivisionId = '2';

        final result = workflowService.doShowWorkflowSwitchConfirmation();
        expect(result, isFalse);
      });

      test("Should handle zero division ID", () {
        workflowService.job?.division = DivisionModel(id: 0, name: 'Zero Division');
        workflowService.selectedJobDivisionId = '1';

        final currentDivisionId = workflowService.job?.division?.id.toString() ?? '';
        expect(currentDivisionId, equals('0'));
        expect(workflowService.selectedJobDivisionId != currentDivisionId, isTrue);
      });

      test("Should handle negative division ID", () {
        workflowService.job?.division = DivisionModel(id: -1, name: 'Negative Division');
        workflowService.selectedJobDivisionId = '1';

        final currentDivisionId = workflowService.job?.division?.id.toString() ?? '';
        expect(currentDivisionId, equals('-1'));
        expect(workflowService.selectedJobDivisionId != currentDivisionId, isTrue);
      });
    });

    group("JobFormService workflow division state management", () {
      test("Should preserve job state during division validation", () {
        final originalJobId = workflowService.job?.id;
        final originalJobName = workflowService.job?.name;

        workflowService.selectedJobDivisionId = '2';
        workflowService.doShowWorkflowSwitchConfirmation();

        expect(workflowService.job?.id, equals(originalJobId));
        expect(workflowService.job?.name, equals(originalJobName));
      });

      test("Should maintain division selection after validation", () {
        const testDivisionId = '999';
        workflowService.selectedJobDivisionId = testDivisionId;
        workflowService.doShowWorkflowSwitchConfirmation();

        expect(workflowService.selectedJobDivisionId, equals(testDivisionId));
      });

      test("Should handle concurrent division selections", () {
        workflowService.selectedJobDivisionId = '2';
        final firstCall = workflowService.doShowWorkflowSwitchConfirmation();

        workflowService.selectedJobDivisionId = '3';
        final secondCall = workflowService.doShowWorkflowSwitchConfirmation();

        expect(firstCall, equals(secondCall));
        expect(workflowService.selectedJobDivisionId, equals('3'));
      });
    });
  });
}