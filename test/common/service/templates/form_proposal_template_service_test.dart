
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/templates/form_proposal/more_action.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';
import 'package:jobprogress/common/services/templates/form_proposal/index.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';

void main() {

  FormProposalParamsModel params = FormProposalParamsModel(
    jobId: 1,
    isEditForm: false,
    templateId: '10',
    onTapSaveAs: () {}, // callback to handle save as tap
  );

  final service = FormProposalTemplateService(
    params,
    dbUnsavedResourceId: 1,
    stream: null, // local db save stream
    update: () {}, // helps in updating the ui from with in service
  );

  List<AttachmentResourceModel> tempAttachments = [
    AttachmentResourceModel(id: 1, name: 'Attachment 1'),
    AttachmentResourceModel(id: 2, name: 'Attachment 2'),
    AttachmentResourceModel(id: 3, name: 'Attachment 3'),
  ];

  List<AttachmentResourceModel> tempAttachments2 = [
    AttachmentResourceModel(id: 1, name: 'Attachment 1'),
    AttachmentResourceModel(id: 2, name: 'Attachment 2'),
    AttachmentResourceModel(id: 3, name: 'Attachment 3'),
  ];

  FormProposalTemplateModel tempTemplate = FormProposalTemplateModel(
    tempSaveId: 123,
    autoFillRequired: 'true',
    content: 'Template content',
    pageType: 'Page type',
    title: 'Template title',
    tables: {},
    id: 12,
    isVisitRequired: false,
  );

  JobModel tempJob = JobModel(
      id: 1,
      customerId: 1,
      number: '123',
      parent: null,
      trades: [],
  );

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;
  });

  test("FormProposalTemplateService should be initialised properly", () {
    expect(service, isA<FormProposalTemplateService>());
    expect(service.params, params);
    expect(service.dbUnsavedResourceId, 1);
    expect(service.stream, isNull);
  });

  group("FormProposalTemplateService@getMoreActionList should show header action on the basis of template type", () {
    group('In case of Add Template form', () {
      test('Only two actions should be available to select from', () {
        final result = FormProposalTemplateService.getMoreActionList();
        expect(result.length, 2);
      });

      test("Actions should be displayed in correct order", () {
        final result = FormProposalTemplateService.getMoreActionList();
        expect(result[0], isA<JPQuickActionModel>());
        expect(result[0].id, 'attach');
        expect(result[1], isA<JPQuickActionModel>());
        expect(result[1].id, 'snippet');
      });

      test("'Save As' action should not be available", () {
        final result = FormProposalTemplateService.getMoreActionList();
        final isSaveAsAvailable = result.any((action) => action.id == 'save_as');
        expect(isSaveAsAvailable, isFalse);
      });

    });

    group("In case of Edit Template Form", () {
      test('All actions should be available to select from', () {
        final result = FormProposalTemplateService.getMoreActionList(isEditForm: true);
        expect(result.length, 3);
      });

      test("Actions should be displayed in correct order", () {
        final result = FormProposalTemplateService.getMoreActionList(isEditForm: true);
        expect(result[0].id, 'attach');
        expect(result[1].id, 'snippet');
        expect(result[2].id, 'save_as');
      });

      test("'Save As' action should be available", () {
        final result = FormProposalTemplateService.getMoreActionList(isEditForm: true);
        final isSaveAsAvailable = result.any((action) => action.id == 'save_as');
        expect(isSaveAsAvailable, isTrue);
      });
    });
  });

  group("FormProposalTemplateService@getMergeTemplateActionList should display actions for merge template", () {
    test('All actions should be available to select from', () {
      final result = FormProposalTemplateService.getMergeTemplateActionList(true, true);
      expect(result.length, 6);
      expect(result[0].id, 'add_images');
      expect(result[1].id, 'add_pages');
      expect(result[2].id, 'manage_pages');
      expect(result[3].id, 'snippet');
      expect(result[4].id, 'reload');
      expect(result[5].id, 'save');
    });

    test('"Add images" action should not be available', () {
      final result = FormProposalTemplateService.getMergeTemplateActionList(false, true);
      final isAddImagesAvailable = result.any((action) => action.id == 'add_images');
      expect(result.length, 5);
      expect(isAddImagesAvailable, isFalse);
    });

    test('"Add pages" action should not be available', () {
      final result = FormProposalTemplateService.getMergeTemplateActionList(true, false);
      final isAddPagesAvailable = result.any((action) => action.id == 'add_pages');
      expect(result.length, 5);
      expect(isAddPagesAvailable, isFalse);
    });

    test('Add images" & "Add pages" actions should not be available', () {
      final result = FormProposalTemplateService.getMergeTemplateActionList(false, false);
      final isAddImagesAvailable = result.any((action) => action.id == 'add_images');
      final isAddPagesAvailable = result.any((action) => action.id == 'add_pages');
      expect(result.length, 4);
      expect(isAddPagesAvailable, isFalse);
      expect(isAddImagesAvailable, isFalse);
    });
  });

  group("FormProposalTemplateService@removeAttachedItem should remove selected or uploaded attachment", () {
    setUp(() {
      service.params.attachments = tempAttachments2;
    });

    test("Attachment should be removed, when attachment falls with in available items", () {
      expect(service.params.attachments.length, 3);
      service.removeAttachedItem(2);
      expect(service.params.attachments.length, 2);
    });

    test("Attachment should not be removed, when attachment does not fall with in available items", () {
      service.removeAttachedItem(4);
      expect(service.params.attachments.length, 2);
    });

    test("Attachment should not be removed, when attachments are empty", () {
      service.removeAttachedItem(1);
      service.removeAttachedItem(0);
      expect(service.params.attachments.length, 0);
      service.removeAttachedItem(1);
      expect(service.params.attachments.length, 0);
    });
  });

  group("FormProposalTemplateService@getImageTitle should return correct template image title", () {
    test('When image is selected from company files', () {
      String title = service.getImageTitle(FLModule.companyFiles, null);
      expect(title, equals('company_files'.tr));
    });

    test('When image is selected from stage resources', () {
      String title = service.getImageTitle(FLModule.stageResources, null);
      expect(title, equals('resource_viewer'.tr));
    });

    test('When job is available with empty trades', () {
      String title = service.getImageTitle(null, tempJob);
      expect(title, equals('123'));
    });

    test('When job is available with parent job and non-empty trades', () {
      tempJob = tempJob
        ..parent = tempJob
        ..trades = [
        CompanyTradesModel(name: 'Trade 1'),
        CompanyTradesModel(name: 'Trade 2')
      ];

      String title = service.getImageTitle(null, tempJob);
      expect(title, equals('123 - Trade 1/Trade 2'));
    });

    test('When job is available and file is selected from company files', () {
      String title = service.getImageTitle(FLModule.companyFiles, tempJob);
      expect(title, equals('company_files'.tr));
    });

    test('When job and selection module is not available', () {
      String title = service.getImageTitle(null, null);
      expect(title, equals(''));
    });
  });

  group("FormProposalTemplateService.param@getTemplateParams should give appropriate params", () {
    group("In case of merge template", () {
      test('Saved template should be loaded', () {
        bool isMergeTemplate = true;
        service.params.templateId = '123';
        service.params.tempTemplateId = 456;

        Map<String, dynamic> params = service.params.getTemplateParams(isMergeTemplate);

        expect(params, equals({
          "includes[]": "tables",
          "page_id": '123',
          "id": 456,
        }));
      });

      test('Actual empty template should be loaded', () {
        bool isMergeTemplate = true;
        service.params.templateId = '123';
        service.params.tempTemplateId = null;

        Map<String, dynamic> params = service.params.getTemplateParams(isMergeTemplate);

        expect(params, equals({
          "includes[]": "tables",
          "page_id": '123',
        }));
      });
    });

    group("In case of Form/Proposal Template", () {
      test('Fresh empty template should be loaded', () {
        bool isMergeTemplate = false;
        service.params.templateId = '123';

        Map<String, dynamic> params = service.params.getTemplateParams(isMergeTemplate);

        expect(params, equals({
          'id': '123',
          'includes[0]': 'pages',
          'includes[1]': 'pages.tables',
          'includes[2]': 'with_proposal_serial_number',
          'multi_page': '1',
        }));
      });

      test('Saved template should be loaded', () {
        bool isMergeTemplate = false;
        service.params.templateId = '123';
        service.params.isEditForm = true;

        Map<String, dynamic> params = service.params.getTemplateParams(isMergeTemplate);

        expect(params, equals({
          'id': '123',
          'includes[0]': 'pages',
          'includes[1]': 'pages.tables',
          'includes[2]': 'with_proposal_serial_number',
          'multi_page': '1',
          'includes[3]': 'attachments'
        }));
      });
    });
  });

  group("FormProposalTemplateService.param@getTemporarySaveParams should give correct params to load temporary saved template", () {
    test('Temporary saved template should be loaded', () {
      Map<String, dynamic> params = service.params.getTemporarySaveParams(tempTemplate);

      expect(params, equals({
        "temp_id": tempTemplate.tempSaveId,
        "auto_fill_required": tempTemplate.autoFillRequired,
        "content": tempTemplate.content,
        "page_type": tempTemplate.pageType,
        "title": tempTemplate.title,
        "tables": tempTemplate.tables,
        "id": tempTemplate.id,
        "is_visit_required": tempTemplate.isVisitRequired,
      }));
    });

    test('Original template should be loaded', () {
      tempTemplate.tempSaveId = null;
      Map<String, dynamic> params = service.params.getTemporarySaveParams(tempTemplate);

      expect(params, equals({
        "auto_fill_required": tempTemplate.autoFillRequired,
        "content": tempTemplate.content,
        "page_type": tempTemplate.pageType,
        "title": tempTemplate.title,
        "tables": tempTemplate.tables,
        "id": tempTemplate.id,
        "temp_id": null,
        "is_visit_required": tempTemplate.isVisitRequired,
      }));
    });
  });

  group("FormProposalTemplateService.param@getMergeTemplateSaveParams should give correct params to save merge template", () {
    test('Should give default params', () {
      List<FormProposalTemplateModel> pages = [];
      Map<String, dynamic> params = service.params.getMergeTemplateSaveParams("proposal_page", pages);
      expect(params, equals({
        'job_id': 1,
        'page_type': 'proposal_page',
        'pages': <dynamic>[],
        'insurance_estimate': 1,
        'is_mobile': 1,
        'includes[]': 'pages'
      }));
    });

    test("Should give correct params for worksheet template", () {
      List<FormProposalTemplateModel> pages = [];
      Map<String, dynamic> params = service.params.getMergeTemplateSaveParams("proposal_page", pages, isForWorksheet: true);
      expect(params, equals({
        'job_id': 1,
        'page_type': 'proposal_page',
        'template_pages': <dynamic>[],
        'insurance_estimate': 1,
        'is_mobile': 1,
        'includes[]': 'pages'
      }));
    });

    group('Page type should be set correctly', () {
      test("In case of edit merge template", () {
        final params = service.params.getMergeTemplateSaveParams("proposal_page", [], forEdit: true);
        expect(params['page_type'], equals('proposal_page'));
      });

      test("In case of edit merge template from worksheet", () {
        final params = service.params.getMergeTemplateSaveParams("proposal_page", [], forEdit: true, isForWorksheet: true);
        expect(params['page_type'], equals('proposal_page'));
      });

      test("In case of add merge template", () {
        final params = service.params.getMergeTemplateSaveParams("proposal_page", []);
        expect(params['page_type'], equals('proposal_page'));
      });
    });

    group("Template pages should be prepared correctly", () {
      test("In case of add merge template", () {
        List<FormProposalTemplateModel> pages = [tempTemplate..tempSaveId = null];
        Map<String, dynamic> params = service.params.getMergeTemplateSaveParams("proposal_page", pages);

        expect(params['pages'], equals([{'type': 'template_page', 'id': 12}]));
        expect(params['template_pages'], isNull);
      });

      test("In case of edit merge template", () {
        List<FormProposalTemplateModel> pages = [tempTemplate..tempSaveId = null];
        Map<String, dynamic> params = service.params.getMergeTemplateSaveParams("proposal_page", pages, forEdit: true);

        expect(params['pages'], equals([{'type': 'template_page', 'id': 12}]));
        expect(params['template_pages'], isNull);
      });

      test("In case of temporary merge template", () {
        List<FormProposalTemplateModel> pages = [tempTemplate..tempSaveId = 10];
        Map<String, dynamic> params = service.params.getMergeTemplateSaveParams("proposal_page", pages);

        expect(params['pages'], equals([{'type': 'temp_proposal_page', 'id': 10}]));
        expect(params['template_pages'], isNull);
      });

      test("In case of worksheet merge template", () {
        List<FormProposalTemplateModel> pages = [tempTemplate..tempSaveId = 10];
        Map<String, dynamic> params = service.params.getMergeTemplateSaveParams("proposal_page", pages, isForWorksheet: true);

        expect(params['template_pages'], equals([{'type': 'temp_proposal_page', 'id': 10}]));
        expect(params['pages'], isNull);
      });
    });
  });

  group("FormProposalTemplateService.param@getAttachmentsJson should give correct params for attachments", () {
    test("When attachments are attached for the first time", () {
      service.params.attachments = tempAttachments;
      service.params.uploadedAttachments = [];

      Map<String, dynamic> result = service.params.getAttachmentsJson(false);

      expect(result['attachments'].length, 3);
      expect(result['delete_attachments[]'].length, 0);
    });

    test("When more attachments are added", () {
      service.params.attachments = service.params.attachments + tempAttachments;
      service.params.uploadedAttachments = [];

      Map<String, dynamic> result = service.params.getAttachmentsJson(false);

      expect(result['attachments'].length, 6);
      expect(result['delete_attachments[]'].length, 0);
    });

    test('When empty attachments are loaded from local db', () {
      service.params.attachments = [];
      service.params.uploadedAttachments = [];

      Map<String, dynamic> result = service.params.getAttachmentsJson(true);

      expect(result, equals({}));
    });

    test('When attachments are loaded from local db', () {
      service.params.attachments = [tempAttachments[2]];
      service.params.uploadedAttachments = [tempAttachments[0]];

      Map<String, dynamic> result = service.params.getAttachmentsJson(true);

      expect(result['attachments'].length, 1);
      expect(result['delete_attachments'].length, 1);
    });
  });

  group("FormProposalTemplateService.param@getApiParams should give api params to save template", () {
    group("While saving template at server", () {
      test('In case of add template', () {
        final params = service.params.getApiParams(tempTemplate, title: 'abc', content: 'test');
        expect(params, equals({
          'job_id': 1,
          'page_type': 'Page type',
          'is_mobile': 1,
          'title': 'abc',
          'pages[0]': {'template': 'test'},
          'attachments': [{'type': 'resource', 'value': 3}],
          'delete_attachments[]': [1],
          'id': '123'
        }));
      });

      test('In case of edit template', () {
        final params = service.params.getApiParams(tempTemplate, title: 'abc', content: 'test', saveAs: true);
        expect(params, equals({
          'job_id': 1,
          'page_type': 'Page type',
          'is_mobile': 1,
          'title': 'abc',
          'pages[0]': {'template': 'test'},
          'attachments': [{'type': 'resource', 'value': 3}],
          'delete_attachments[]': [1],
          'save_as': '123'
        }));
      });
    });

    group("While saving template in local DB", () {
      test('In case of add template', () {
        service.params.attachments = [];
        service.params.uploadedAttachments = [];
        final params = service.params.getApiParams(tempTemplate, title: 'abc', content: 'test', isForUnsavedDB: true);
        expect(params, equals({
          'job_id': 1,
          'page_type': 'Page type',
          'is_mobile': 1,
          'title': 'abc',
          'pages[0]': {
            'template': 'test',
            'id': 12,
            'image': null,
            'thumb': null,
            'is_proposal_page': false
          },
          'id': '123'
        }));
      });

      test('In case of edit template', () {
        final params = service.params.getApiParams(tempTemplate, title: 'abc', content: 'test', saveAs: true, isForUnsavedDB: true);
        expect(params, equals({
          'job_id': 1,
          'page_type': 'Page type',
          'is_mobile': 1,
          'title': 'abc',
          'pages[0]': {
            'template': 'test',
            'id': 12,
            'image': null,
            'thumb': null,
            'is_proposal_page': false
          },
          'save_as': '123'
        }));
      });
    });
  });

  group("FormProposalTemplateService.param@proposalPagesParams should give correct params to load proposal page", () {
    test("Should give correct params to load proposal page", () {
      final params = service.params.proposalPagesParams(proposalId: 1);
      expect(params, equals({
        "id": 1,
        "includes[]": "pages",
        "without_content": 1,
      }));
    });

    group("Should give correct params in case of loading page for worksheet proposal", () {
      test('When worksheet page exists', () {
        final params = service.params.proposalPagesParams(proposalId: 1, worksheetId: 2, worksheetPagesExist: true);
        expect(params, equals({
          "id": 2,
          "limit": PaginationConstants.pageLimit50,
          "worksheet_id": 2,
        }));
      });

      test('When worksheet page does not exist', () {
        final params = service.params.proposalPagesParams(proposalId: 1, worksheetId: 2);
        expect(params, equals({
          'includes[]': 'pages_detail',
          'limit': PaginationConstants.pageLimit50,
        }));
      });
    });
  });

  test("FormProposalTemplateService.param@templateByGroup should give params to load template group", () {
    final params = service.params.templateByGroup([]);
    expect(params, equals({
      "group_ids[]": <String>[],
      "includes[]": "pages",
      "insurance_estimate": 1,
      "limit": 0,
      "type": "proposal",
      "without_content": 1,
    }));
  });
}