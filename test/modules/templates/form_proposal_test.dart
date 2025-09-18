import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/templates.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';
import 'package:jobprogress/core/utils/form/db_helper.dart';
import 'package:jobprogress/modules/files_listing/templates/form_proposal/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';

void main() {

  final controller = FormProposalTemplateController();

  final controllerForMerge = FormProposalTemplateController.merge();

  CustomerModel customerModel = CustomerModel(
      fullName: "Test Customer",
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

  List<AttachmentResourceModel> tempAttachments = [
    AttachmentResourceModel(id: 1),
    AttachmentResourceModel(id: 2),
  ];

  FilesListingModel tempProposal = FilesListingModel(
    proposalTemplatePages: [FormProposalTemplateModel()],
    pageType: 'pageType',
    name: 'Proposal Name',
    proposalSerialNumber: '123',
    attachments: tempAttachments,
  );

  final unsavedTemplateJson = {
    'data': jsonEncode({
      "pages[0]": {
        "id": 1,
        "image": "image_url",
        "thumb": "thumb_url",
        "is_proposal_page": true,
        "template": "template_content",
        "tables": <String, dynamic>{},
      },
      "template_id": '123',
      "isEditForm": true,
      "page_type": "page_type_value",
      "title": "Form Title",
      "attachments": [
        {"id": 1, "name": "attachment1"},
        {"id": 2, "name": "attachment2"},
      ],
      "delete_attachments": [
        {"id": 3, "name": "attachment3"},
        {"id": 4, "name": "attachment4"},
      ],
    })
  };

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group("FormProposalController should be initialized with correct data", () {
    group("When independent of merge template", () {
      test("Form Template toggles should be initialized properly", () {
        expect(controller.isSavingForm, isFalse);
        expect(controller.isSavedOnTheGo, isFalse);
        expect(controller.isMergeTemplate, isFalse);
      });

      test("Form Template helpers should be initialized properly", () {
        expect(controller.job, isNull);
        expect(controller.template, isNull);
        expect(controller.service, isNull);
        expect(controller.jobId, isNull);
        expect(controller.dbUnsavedResourceId, isNull);
        expect(controller.templateId, isNull);
        expect(controller.unsavedResourceJson, isNull);
        expect(controller.type, ProposalTemplateFormType.add);
      });

      test("Form Template lists should be initialized properly", () {
        expect(controller.clickableElements, isNotEmpty);
        expect(controller.clickableElements.length, 5);
      });
    });

    group("When extended from Merge Template", () {
      test("Form Template toggles should be initialized properly", () {
        expect(controllerForMerge.isSavingForm, isFalse);
        expect(controllerForMerge.isSavedOnTheGo, isFalse);
        expect(controllerForMerge.isMergeTemplate, isTrue);
      });

      test("Form Template helpers should be initialized properly", () {
        expect(controller.job, isNull);
        expect(controller.template, isNull);
        expect(controller.service, isNull);
        expect(controller.jobId, isNull);
        expect(controller.dbUnsavedResourceId, isNull);
        expect(controller.templateId, isNull);
        expect(controller.unsavedResourceJson, isNull);
        expect(controller.type, ProposalTemplateFormType.add);
      });

      test("Form Template lists should be initialized properly", () {
        expect(controller.clickableElements, isNotEmpty);
        expect(controller.clickableElements.length, 5);
      });
    });
  });

  group('FormProposalTemplateController@customerName should give appropriate page title', () {
    test('Page title should be Customer Name, when customer name is available', () {
      controller.job = tempJob..customer = customerModel;
      expect(controller.customerName, customerModel.fullName);
    });

    test('Page title should be Job Name, if customer name is not available', () {
      controller.job = tempJob..customer = null;
      expect(controller.customerName, tempJob.name);
    });

    test('Default page title should be used when both job and customer name does not exists', () {
      controller.job = null;
      expect(controller.customerName, 'template'.tr.capitalizeFirst);
    });
  });

  group('FormProposalTemplateController@canShowAttachmentIcon should display attachment icon conditionally', () {
    setUp(() {
      controller.jobId = tempJob.id;
      controller.initService();
    });

    test('Icon should be displayed when html is available and attachments are not empty', () {
      controller.requestParams.attachments = tempAttachments;
      controller.html = '';
      expect(controller.canShowAttachmentIcon, isTrue);
    });

    test('Icon should not be displayed when html is available and attachments are empty', () {
      controller.requestParams.attachments = [];
      controller.html = '';
      expect(controller.canShowAttachmentIcon, isFalse);
    });

    test('Icon should not be displayed when html is not available and attachments are not empty', () {
      controller.requestParams.attachments = tempAttachments;
      controller.html = null;
      expect(controller.canShowAttachmentIcon, isFalse);
    });

    test('Icon should not be displayed when html is not available and attachments are empty', () {
      controller.requestParams.attachments = [];
      controller.html = null;
      expect(controller.canShowAttachmentIcon, isFalse);
    });
  });

  group("FormProposalTemplateController@isEditForm should decide whether its an edit form or not", () {
    test("Edit form should be displayed when type is edit", () {
      controller.type = ProposalTemplateFormType.edit;
      expect(controller.isEditForm, isTrue);
    });

    test("Add form should be displayed when type is add", () {
      controller.type = ProposalTemplateFormType.add;
      expect(controller.isEditForm, isFalse);
    });
  });
  
  group("FormProposalTemplateController@hasError should decide whether there is an error or not", () {
    test('Error should be displayed when loading is completed and form html is not loaded', () {
      controller.isLoading = false;
      controller.html = null;
      expect(controller.hasError, isTrue);
    });

    test('Error should be displayed when form html is available but not job', () {
      controller.isLoading = false;
      controller.html = 'Some HTML';
      expect(controller.hasError, isTrue);
    });

    test('Error should be displayed when job is available but not HTML', () {
      controller.isLoading = false;
      controller.html = null;
      controller.job = tempJob;
      expect(controller.hasError, isTrue);
    });

    test('Error should not be displayed when loading is not completed', () {
      controller.isLoading = true;
      expect(controller.hasError, isFalse);
    });

    test('Error should not be displayed when both job and html are available', () {
      controller.isLoading = false;
      controller.job = tempJob;
      controller.html = 'Some HTML';
      expect(controller.hasError, isFalse);
    });
  });

  group("FormProposalTemplateController@onElementTapped should update selected element details", () {
    test("Element details should be initialized to default", () {
      expect(controller.selectedIndex, 0);
      expect(controller.selectedClassName, '');
    });

    group("Element details should be updated when element is clicked", () {
      setUp(() {
        controller.onElementTapped(4, 'Table');
      });

      test("Selected element index should be updated", () {
        expect(controller.selectedIndex, 4);
      });

      test("Selected element class name should be updated", () {
        expect(controller.selectedClassName, 'Table');
      });
    });
  });

  group("FormProposalTemplateController@initService should set form request params and service", () {
    setUp(() {
      controller.jobId = tempJob.id;
      controller.templateId = "10";
      controller.type = ProposalTemplateFormType.add;
    });

    test("Request params should be initialized properly", () {
      controller.initService();
      expect(controller.requestParams.jobId, tempJob.id);
      expect(controller.requestParams.templateId, "10");
      expect(controller.requestParams.isEditForm, isFalse);
    });

    test("Service should be initialized properly", () {
      controller.initService();
      expect(controller.service, isNotNull);
    });
  });

  group("FormProposalTemplateController@determineFetchTemplateType decides which api request to be made to save template", () {
    group('In case of Add', () {
      setUp(() {
        controller.type = ProposalTemplateFormType.add;
        controller.isMergeTemplate = false;
        controller.jobId = tempJob.id;
      });

      test('Request should be made to save worksheet template', () {
        controller.initService();
        controller.requestParams.tempTemplateId = null;
        final result = controller.determineFetchTemplateType(isWorksheet: true);
        expect(result, equals(FetchTemplateType.worksheetTemplate));
      });

      test('Request should be made to save default template', () {
        controller.initService();
        controller.requestParams.tempTemplateId = 10;
        final result = controller.determineFetchTemplateType();
        expect(result, equals(FetchTemplateType.defaultTemplate));
      });
    });

    group("In case of edit", () {
      setUp(() {
        controller.type = ProposalTemplateFormType.edit;
        controller.isMergeTemplate = false;
        controller.jobId = tempJob.id;
      });

      test('Request should be made to save worksheet template', () {
        controller.initService();
        controller.requestParams.tempTemplateId = 10;
        final result = controller.determineFetchTemplateType();
        expect(result, equals(FetchTemplateType.worksheetTemplate));
      });

      test('Request should be made to save proposal template', () {
        controller.initService();
        controller.requestParams.tempTemplateId = null;
        final result = controller.determineFetchTemplateType();
        expect(result, equals(FetchTemplateType.proposalTemplate));
      });
    });
  });

  group("FormProposalTemplateController@setTemplateFromProposal should set template data from proposal", () {
    setUp(() {
      controller.jobId = tempJob.id;
      controller.initService();
    });

    test("Template details should set properly", () {
      controller.setTemplateFromProposal(tempProposal);
      expect(controller.template, tempProposal.proposalTemplatePages?.first);
      expect(controller.template?.pageType, tempProposal.pageType);
      expect(controller.template?.title, tempProposal.name);
      expect(controller.template?.proposalSerialNumber, int.tryParse(tempProposal.proposalSerialNumber ?? ""));
    });

    test("Request params should be set properly", () {
      controller.setTemplateFromProposal(tempProposal);
      expect(controller.requestParams.uploadedAttachments, tempProposal.attachments);
      expect(controller.requestParams.attachments, tempProposal.attachments);
    });

    test("Empty or null data should be handled properly", () {
      controller.setTemplateFromProposal(FilesListingModel());
      expect(controller.template, isNull);
      expect(controller.template?.pageType, isNull);
      expect(controller.template?.title, isNull);
      expect(controller.template?.proposalSerialNumber, isNull);
    });
  });

  group('FormProposalTemplateController@parseSingleSelectToDropDown should convert single select to JSON data', () {
    test('JPSingleSelectModel should be encoded to JSON string', () {
      List<JPSingleSelectModel> testList = [
        JPSingleSelectModel(label: 'Option 1', id: '1'),
        JPSingleSelectModel(label: 'Option 2', id: '2'),
      ];

      final result = controller.parseSingleSelectToDropDown(testList);
      final expected = jsonEncode(['Option 1', 'Option 2']);
      expect(result, expected);
    });

    test('Empty list to be encoded to an empty JSON array', () {
      final List<JPSingleSelectModel> testList = [];
      final result = controller.parseSingleSelectToDropDown(testList);
      expect(result, '[]');
    });
  });

  group('FormProposalTemplateController@parseMultiSelectToMultiChoice should convert multi-select list to JSON data', () {
    test('JPMultiSelectModel should be encoded to JSON string', () {
      final List<JPMultiSelectModel> testList = [
        JPMultiSelectModel(label: 'Option 1', isSelect: true, id: '1'),
        JPMultiSelectModel(label: 'Option 2', isSelect: false, id: '2'),
      ];
      final result = controller.parseMultiSelectToMultiChoice(testList);
      final expected = jsonEncode([
        {"name": "Option 1", "checked": true},
        {"name": "Option 2", "checked": false},
      ]);
      expect(result, expected);
    });

    test('Empty list to be encoded to an empty JSON array', () {
      final List<JPMultiSelectModel> testList = [];
      final result = controller.parseMultiSelectToMultiChoice(testList);
      expect(result, '[]');
    });
  });

  group("FormProposalTemplateController@toggleIsSavingForm should enable disable form loading", () {
    test("Form loading should be enabled", () {
      controller.isSavingForm = false;
      controller.toggleIsSavingForm();
      expect(controller.isSavingForm, isTrue);
    });

    test("Form loading should be disabled", () {
      controller.isSavingForm = true;
      controller.toggleIsSavingForm();
      expect(controller.isSavingForm, isFalse);
    });
  });

  group("FormProposalTemplateController@setUnsavedFromProposal should set template data from unsaved json", () {
    test("Unsaved JSON should be decoded correctly", () {
      controller.setUnsavedFromProposal(unsavedTemplateJson);
      expect(controller.unsavedResourceJson, FormsDBHelper.getUnsavedResourcesJsonData(unsavedTemplateJson));
    });

    test("Template details should be parsed correctly", () {
      controller.setUnsavedFromProposal(unsavedTemplateJson);
      expect(controller.templateId, '123');
      expect(controller.template, isNotNull);
      expect(controller.template?.id, 1);
      expect(controller.template?.image, "image_url");
      expect(controller.template?.thumb, "thumb_url");
      expect(controller.template?.isProposalPage, true);
      expect(controller.template?.content, "template_content");
      expect(controller.template?.tables, <String, dynamic>{});
    });

    test("Template type and content should be set parsed correctly", () {
      controller.setUnsavedFromProposal(unsavedTemplateJson);
      expect(controller.type, ProposalTemplateFormType.edit);
      expect(controller.html, "template_content");
    });
  });

  group("FormProposalTemplateController@setUnsavedAttachments should set attachments for unsaved template", () {
    setUp(() {
      controller.jobId = tempJob.id;
      controller.initService();
    });

    test('Attachments and uploaded attachments should be populated correctly', () {
      controller.setUnsavedFromProposal(unsavedTemplateJson);
      controller.setUnsavedAttachments();

      expect(controller.requestParams.attachments.length, 2);
      expect(controller.requestParams.attachments[0].id, 1);
      expect(controller.requestParams.attachments[0].name, "attachment1");
      expect(controller.requestParams.attachments[1].id, 2);
      expect(controller.requestParams.attachments[1].name, "attachment2");

      expect(controller.requestParams.uploadedAttachments.length, 2);
      expect(controller.requestParams.uploadedAttachments[0].id, 3);
      expect(controller.requestParams.uploadedAttachments[0].name, "attachment3");
      expect(controller.requestParams.uploadedAttachments[1].id, 4);
      expect(controller.requestParams.uploadedAttachments[1].name, "attachment4");
    });

    test('Attachments should be not set if unsaved from proposal data not exists', () {
      controller.unsavedResourceJson = null;
      controller.setUnsavedAttachments();
      expect(controller.requestParams.attachments, isEmpty);
      expect(controller.requestParams.uploadedAttachments, isEmpty);
    });

    test('Attachments should be empty set if unsaved from proposal data has not attachments', () {
      controller.unsavedResourceJson = {};
      controller.setUnsavedAttachments();
      expect(controller.requestParams.attachments, isEmpty);
      expect(controller.requestParams.uploadedAttachments, isEmpty);
    });
  });

  group('FormProposalTemplateController@decodeDropDownList should decode a JSON list to single select', () {
    test('When data is available it should be decoded correctly', () {
      Map<String, dynamic> value = {
        'options': ['Option 1', 'Option 2', 'Option 3'],
        'index': 1,
      };

      final result = controller.decodeDropDownList(value);

      expect(result.length, 3);
      expect(result[0], isA<JPSingleSelectModel>());
      expect(result[0].id, '0');
      expect(result[0].label, 'Option 1');
      expect(result[0].isEditable, false); // Non-editable item

      expect(result[1].id, '1');
      expect(result[1].label, 'Option 2');
      expect(result[1].isEditable, false); // Non-editable item

      expect(result[2].id, '2');
      expect(result[2].label, 'Option 3');
      expect(result[2].isEditable, true);
    });

    test('When data is not available it should be handled correctly', () {
      final result = controller.decodeDropDownList(null);
      expect(result, isEmpty);
    });

    test('Missing options should be handled correctly', () {
      final value = {'index': 1};
      final result = controller.decodeDropDownList(value);
      expect(result, isEmpty);
    });
  });

  group('FormProposalTemplateController attachment type handling - verifies dynamic attachment type usage with fallback to "resource"', () {
    late FormProposalTemplateController testController;

    setUp(() {
      testController = FormProposalTemplateController();
      testController.jobId = tempJob.id;
      testController.initService();
    });

    test('should use attachment type from model when available in getAttachmentsJson', () {
      // Arrange
      testController.requestParams.attachments = [
        AttachmentResourceModel(id: 1, type: 'image'),
        AttachmentResourceModel(id: 2, type: 'document'),
      ];

      // Act
      final attachmentsJson = testController.requestParams.getAttachmentsJson(false);

      // Assert
      expect(attachmentsJson['attachments'], isA<List<dynamic>>());
      final attachments = attachmentsJson['attachments'] as List<dynamic>;
      expect(attachments.length, 2);
      expect(attachments[0]['type'], 'image');
      expect(attachments[0]['value'], 1);
      expect(attachments[1]['type'], 'document');
      expect(attachments[1]['value'], 2);
    });

    test('should fallback to "resource" when attachment type is null in getAttachmentsJson', () {
      // Arrange
      testController.requestParams.attachments = [
        AttachmentResourceModel(id: 1, type: null),
        AttachmentResourceModel(id: 2), // type defaults to null
      ];

      // Act
      final attachmentsJson = testController.requestParams.getAttachmentsJson(false);

      // Assert
      expect(attachmentsJson['attachments'], isA<List<dynamic>>());
      final attachments = attachmentsJson['attachments'] as List<dynamic>;
      expect(attachments.length, 2);
      expect(attachments[0]['type'], 'resource');
      expect(attachments[0]['value'], 1);
      expect(attachments[1]['type'], 'resource');
      expect(attachments[1]['value'], 2);
    });

    test('should handle multiple attachments with different types in getAttachmentsJson', () {
      // Arrange
      testController.requestParams.attachments = [
        AttachmentResourceModel(id: 1, type: 'image'),
        AttachmentResourceModel(id: 2, type: null),
        AttachmentResourceModel(id: 3, type: 'video'),
        AttachmentResourceModel(id: 4), // type defaults to null
      ];

      // Act
      final attachmentsJson = testController.requestParams.getAttachmentsJson(false);

      // Assert
      expect(attachmentsJson['attachments'], isA<List<dynamic>>());
      final attachments = attachmentsJson['attachments'] as List<dynamic>;
      expect(attachments.length, 4);
      expect(attachments[0]['type'], 'image');
      expect(attachments[1]['type'], 'resource');
      expect(attachments[2]['type'], 'video');
      expect(attachments[3]['type'], 'resource');
    });
  });

}