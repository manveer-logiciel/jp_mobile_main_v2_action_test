import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/enums/templates.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/templates/html.dart';
import 'package:jobprogress/core/constants/templates/page_type.dart';
import 'package:jobprogress/modules/files_listing/templates/merge/controller.dart';

void main() {

  late FormProposalTemplateModel sellingPriceTemplate;
  late FormProposalTemplateModel imageTemplate;

  List<FormProposalTemplateModel> tempPages = [];

  FilesListingModel tempFile = FilesListingModel(name: 'File 1', groupId: 'group1', id: '2');

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

  final controller = FormProposalMergeTemplateController();

  void setTempPages() {
    sellingPriceTemplate = FormProposalTemplateModel(title: 'SP', id: -2, content: null, isVisitRequired: true);
    imageTemplate = FormProposalTemplateModel(title: 'SP', id: -1, content: 'Test content', isVisitRequired: true);

    tempPages = [
      FormProposalTemplateModel(title: 'Page 1', pageType: 'a4', id: 1),
      FormProposalTemplateModel(title: 'Page 2', pageType: 'legal', id: 2),
      FormProposalTemplateModel(title: 'Page 3', pageType: 'a4', id: 3, isVisitRequired: true),
    ];
  }

  setUpAll(() {
    setTempPages();
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;
    Get.locale = const Locale('en_US');
    RunModeService.setRunMode(RunMode.unitTesting);
  });

  group("FormProposalMergeTemplateController should be initialized with correct data", () {
    test("Template toggles should be initialized properly", () {
      expect(controller.changesMade, isFalse);
      expect(controller.isMergeTemplate, isTrue);
      expect(controller.worksheetPagesExists, isFalse);
    });

    test("Template lists should be initialized properly", () {
      expect(controller.pages, isEmpty);
      expect(controller.files, isEmpty);
    });

    test("Template helpers should be initialized properly", () {
      expect(controller.selectedPageIndex, 0);
      expect(controller.proposalId, isNull);
      expect(controller.selectedTemplateTitle, isNull);
      expect(controller.selectedPageType, isNull);
      expect(controller.workSheet, isNull);
      expect(controller.worksheetId, isNull);
      expect(controller.groupPages, isEmpty);
    });
  });

  group("FormProposalMergeTemplateController@disableNextButton should conditionally disable go to next page button", () {
    test('Next button should be disabled if pages list is empty', () {
      controller.pages = [];
      controller.selectedPageIndex = 0;
      expect(controller.disableNextButton, isTrue);
    });

    test('Next button should be disabled if active page is the last page', () {
      controller.pages = tempPages;
      controller.selectedPageIndex = 2;
      expect(controller.disableNextButton, isTrue);
    });

    test('Next button should not be disabled if active page is the other than last page', () {
      controller.pages = tempPages;
      controller.selectedPageIndex = 1;
      expect(controller.disableNextButton, isFalse);
    });

    test('Next button should be disabled if selected page is out of bounds', () {
      controller.pages = [];
      controller.selectedPageIndex = 1;
      expect(controller.disableNextButton, isTrue);
    });
  });
  
  group("FormProposalMergeTemplateController@disablePrevButton should conditionally disable go to previous page button", () {
    test('Prev button should be disabled if pages list is empty', () {
      controller.pages = [];
      controller.selectedPageIndex = 0;
      expect(controller.disablePrevButton, isTrue);
    });

    test('Prev button should be disabled if active page is the first page', () {
      controller.pages = tempPages;
      controller.selectedPageIndex = 0;
      expect(controller.disablePrevButton, isTrue);
    });

    test('Prev button should not be disabled if active page is the other than first page', () {
      controller.pages = tempPages;
      controller.selectedPageIndex = 1;
      expect(controller.disablePrevButton, isFalse);
    });

    test('Prev button should be disabled if selected page is out of bounds', () {
      controller.pages = [];
      controller.selectedPageIndex = 1;
      expect(controller.disablePrevButton, isTrue);
    });
  });

  group("FormProposalMergeTemplateController@isWorksheetTemplate should decide whether its a worksheet template or not", () {
    test("Template should be considered as a worksheet template if worksheet id exists", () {
      controller.worksheetId = 10;
      expect(controller.isWorksheetTemplate, isTrue);
    });

    test("Template should not be considered as a worksheet template if worksheet id does not exists", () {
      controller.worksheetId = null;
      expect(controller.isWorksheetTemplate, isFalse);
    });
  });

  group("FormProposalMergeTemplateController@isEditForm should decide whether its an edit form or not", () {
    test("Edit form should be displayed when type is edit", () {
      controller.type = ProposalTemplateFormType.edit;
      expect(controller.isEditForm, isTrue);
    });

    test("Add form should be displayed when type is add", () {
      controller.type = ProposalTemplateFormType.add;
      expect(controller.isEditForm, isFalse);
    });
  });

  group("FormProposalMergeTemplateController@hasError should decide whether there is an error or not", () {
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

  group("FormProposalMergeTemplateController@onElementTapped should update selected element details", () {
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

  group("FormProposalMergeTemplateController@skipLoadProposal should decide whether to skip loading proposal", () {
    test('Loading proposal should be skipped if proposal and worksheet id is not available', () {
      controller.proposalId = null;
      controller.worksheetId = null;
      expect(controller.skipLoadProposal, isTrue);
    });

    test('Loading proposal should not be skipped if proposal id exists', () {
      controller.proposalId = 10;
      controller.worksheetId = null;
      expect(controller.skipLoadProposal, isFalse);
    });

    test('Loading proposal should not be skipped if worksheet id exists', () {
      controller.proposalId = null;
      controller.worksheetId = 10;
      expect(controller.skipLoadProposal, isFalse);
    });
  });

  group("FormProposalMergeTemplateController@FormProposalMergeTemplateController should extract groupIds from selected files", () {
    test('Group Ids should be empty when no file is grouped', () {
      controller.files = [
        FilesListingModel(name: 'File 1', groupId: null),
        FilesListingModel(name: 'File 2', groupId: null),
      ];
      List<String?> groupIds = controller.getGroupIdsFromFiles();
      expect(groupIds, isEmpty);
    });

    test('Group Ids should be generated when all files are grouped', () {
      controller.files = [
        FilesListingModel(name: 'File 1', groupId: 'group1'),
        FilesListingModel(name: 'File 2', groupId: 'group2'),
      ];
      List<String?> groupIds = controller.getGroupIdsFromFiles();
      expect(groupIds, equals(['group1', 'group2']));
    });

    test('Group Ids should be generated when some files are grouped', () {
      controller.files = [
        FilesListingModel(name: 'File 1', groupId: null),
        FilesListingModel(name: 'File 2', groupId: 'group2'),
      ];
      List<String?> groupIds = controller.getGroupIdsFromFiles();
      expect(groupIds, equals(['group2']));
    });
  });

  group("FormProposalMergeTemplateController@addProposalTemplatePagesToFile should add pages to grouped files", () {
    test('Pages should be added to grouped files, when group exists', () {
      controller.files = [
        FilesListingModel(name: 'File 1', groupId: 'group1'),
        FilesListingModel(name: 'File 2', groupId: null),
      ];
      tempFile
        ..groupId = 'group1'
        ..proposalTemplatePages = tempPages;
      controller.addProposalTemplatePagesToFile([tempFile]);
      expect(controller.files[0].proposalTemplatePages?.length, 3);
    });

    test('Pages should not be added to grouped files, when group does not exists', () {
      controller.files = [
        FilesListingModel(name: 'File 1', groupId: 'group1'),
        FilesListingModel(name: 'File 2', groupId: null),
      ];
      tempFile
        ..groupId = 'group2'
        ..proposalTemplatePages = tempPages;
      controller.addProposalTemplatePagesToFile([tempFile]);
      expect(controller.files[0].proposalTemplatePages, isNull);
    });

    test('Pages should not be added to grouped files, when pages does not exists', () {
      controller.files = [
        FilesListingModel(name: 'File 1', groupId: 'group1'),
        FilesListingModel(name: 'File 2', groupId: null),
      ];
      tempFile
        ..groupId = 'group1'
        ..proposalTemplatePages = [];
      controller.addProposalTemplatePagesToFile([tempFile]);
      expect(controller.files[0].proposalTemplatePages, isEmpty);
    });
  });

  group("FormProposalMergeTemplateController@fetchSelectedPage should update selected template and load it", () {
    setUp(() {
      controller.jobId = 10;
      controller.selectedPageIndex = 0;
      controller.job = tempJob;
      controller.pages = tempPages;
    });

    group("Template title should be updated on the basis of selected page", () {
      test("Initially first pages title should be displayed", () {
        controller.fetchSelectedPage();
        expect(controller.selectedTemplateTitle, tempPages[0].title);
      });

      test("On updating the page, title should also update", () {
        controller.selectedPageIndex = 1;
        controller.fetchSelectedPage();
        expect(controller.selectedTemplateTitle, tempPages[1].title);
      });
    });

    group("Template page type should be updated on the basis of selected page", () {
      test("Initially first pages type should be used", () {
        controller.selectedPageIndex = 0;
        controller.fetchSelectedPage();
        expect(controller.selectedPageType, tempPages[0].pageType);
      });

      test("On updating the page, type should remain same as initial", () {
        controller.selectedPageIndex = 1;
        controller.fetchSelectedPage();
        expect(controller.selectedPageType, tempPages[0].pageType);
      });
    });

    test("In case of empty selling price sheet, default HTML should be loaded", () {
      controller.pages = [sellingPriceTemplate];
      controller.selectedPageIndex = 0;
      controller.fetchSelectedPage();
      expect(controller.html, TemplateFormHtmlConstants.getSellingPriceSheet(tempJob, null));
    });

    test("In case of empty image, default HTML should be loaded", () {
      controller.pages = [imageTemplate];
      controller.selectedPageIndex = 0;
      controller.dbUnsavedResourceId = 0;
      controller.fetchSelectedPage();
      expect(controller.html, imageTemplate.content);
    });

    test("Template id should updated to selected switched template", () {
      controller.pages = tempPages;
      controller.selectedPageIndex = 0;
      controller.fetchSelectedPage();
      expect(controller.templateId, tempPages[0].id.toString());

      controller.selectedPageIndex = 1;
      controller.fetchSelectedPage();
      expect(controller.templateId, tempPages[1].id.toString());
    });

    group("On visiting a page that is required-visit page, It should not remain required anymore", () {
      test("Page visit should be required until it's not visited", () {
        controller.pages = tempPages;
        controller.selectedPageIndex = 2;
        expect(tempPages[2].isVisitRequired, isTrue);
      });

      test("Page visit should not be required anymore once it's visited", () {
        controller.pages = tempPages;
        controller.selectedPageIndex = 2;
        controller.fetchSelectedPage();
        expect(tempPages[2].isVisitRequired, isFalse);
      });
    });
  });

  group("FormProposalMergeTemplateController@onProposalSaved should update controllers data", () {
    setUp(() {
      controller.onProposalSaved(tempFile);
    });

    test("Should enable Saved On The Go to refresh previous page", () {
      expect(controller.isSavedOnTheGo, isTrue);
    });

    test("Should not display unsaved changes dialog once saved on the go", () {
      expect(controller.changesMade, isFalse);
    });

    test("Proposal Id should be updated", () {
      expect(controller.proposalId.toString(), tempFile.id);
    });
  });

  group("FormProposalMergeTemplateController@updatePagesList should update pages list when new pages are added", () {
    setUp(() {
      controller.updatePagesList(tempFile);
    });

    test("Existing files list should be cleared and new file should be added", () {
      expect(controller.files.length, equals(1));
    });

    test("Existing pages list should be cleared", () {
      expect(controller.pages, isEmpty);
    });
  });

  group("FormProposalMergeTemplateController@onPagesEdited should set new order of the pages and also remove them", () {
    setUp(() {
      setTempPages();
      controller.pages = tempPages;
    });

    group('When selected page exists in list', () {
      test("Selected page index should not be updated if it's at same place in new order", () {
        List<FormProposalTemplateModel> modifiedPages = [
          tempPages[0]..title = 'Modified Page 1',
          ...tempPages.skip(1),
        ];
        controller.selectedPageIndex = 0;
        controller.onPagesEdited(modifiedPages);

        expect(controller.selectedPageIndex, equals(0));
        expect(controller.pages[0].title, equals('Modified Page 1'));
        expect(controller.changesMade, isTrue);
      });

      test("Selected page index should be updated if it's not at same place in new order", () {
        List<FormProposalTemplateModel> modifiedPages = [
          tempPages[1],
          tempPages[0]..title = 'Modified Page 1',
          tempPages[2],
        ];
        controller.selectedPageIndex = 0;
        controller.onPagesEdited(modifiedPages);

        expect(controller.selectedPageIndex, equals(1));
        expect(controller.pages[1].title, equals('Modified Page 1'));
        expect(controller.changesMade, isTrue);
      });
    });

    test("When selected page is removed by default first page should be selected", () {
      List<FormProposalTemplateModel> tempTemplates = [
        FormProposalTemplateModel(id: 4, title: 'New Page 4'),
        FormProposalTemplateModel(id: 5, title: 'New Page 5'),
      ];

      controller.onPagesEdited(tempTemplates);

      expect(controller.selectedPageIndex, equals(0));
      expect(controller.pages[0].title, equals('New Page 4'));
      expect(controller.changesMade, isTrue);
    });

    test('On updating page order changes made dialog should be displayed on moving back', () {
      List<FormProposalTemplateModel> modifiedPages = [
        tempPages[1],
        tempPages[0]..title = 'Modified Page 1',
        tempPages[2],
      ];

      controller.onPagesEdited(modifiedPages);
      expect(controller.changesMade, isTrue);
    });

    test('On removing page changes made dialog should be displayed on moving back', () {
      List<FormProposalTemplateModel> tempTemplates = [
        FormProposalTemplateModel(id: 4, title: 'New Page 4'),
        FormProposalTemplateModel(id: 5, title: 'New Page 5'),
      ];

      controller.onPagesEdited(tempTemplates);
      expect(controller.changesMade, isTrue);
    });
  });

  group("FormProposalMergeTemplateController should handle selected template correctly", () {
    group("Selected selling price sheet should be handled correctly", () {
      test("Selling price sheet should be considered as an empty sheet", () {
        controller.pages = [sellingPriceTemplate..content = null];
        controller.selectedPageIndex = 0;
        expect(controller.pages[0].isEmptySellingPriceSheet, isTrue);
      });

      test('When sheet has content available it should not be considered as empty sheet', () {
        controller.pages = [sellingPriceTemplate..content = 'some content'];
        controller.selectedPageIndex = 0;
        expect(controller.pages[0].isEmptySellingPriceSheet, isFalse);
      });

      test('When sheet is temporarily saved, it should not be considered as empty sheet', () {
        controller.pages = [sellingPriceTemplate..id = 1];
        controller.selectedPageIndex = 0;
        expect(controller.pages[0].isEmptySellingPriceSheet, isFalse);
      });
    });

    group("Selected image template should be handled correctly", () {
      test("Image template should be considered as non-filled", () {
        controller.pages = [imageTemplate];
        controller.selectedPageIndex = 0;
        expect(controller.pages[0].isImageTemplate, isTrue);
      });

      test("Image template should be considered as loaded from temporary saved templates", () {
        controller.pages = [imageTemplate..id = 2];
        controller.selectedPageIndex = 0;
        expect(controller.pages[0].isImageTemplate, isFalse);
      });

      test("A template with title 'Image' should be considered as image template", () {
        controller.pages = [imageTemplate..title = TemplatePageType.image];
        controller.selectedPageIndex = 0;
        expect(controller.pages[0].isImageTemplate, isTrue);
      });
    });
  });
  
  group("FormProposalMergeTemplateController@checkIfVisitRequired should check if template visit is required", () {
    setUp(() {
      controller.jobId = 10;
      controller.job = tempJob;
      setTempPages();
    });

    test("Visit on page should be required if has required signature to filled in", () {
      controller.pages = [tempPages[0]];
      bool isVisitRequired = controller.pages[0].checkIfVisitRequired({
        'signature': true
      });
      expect(isVisitRequired, isTrue);
    });

    test("Visit on page should be required if has required table to filled in", () {
      controller.pages = [tempPages[0]];
      bool isVisitRequired = controller.pages[0].checkIfVisitRequired({
        'table': true
      });
      expect(isVisitRequired, isTrue);
    });

    test("Visit on page should not be required if has not required or empty pages", () {
      controller.pages = [tempPages[0]];
      bool isVisitRequired = controller.pages[0].checkIfVisitRequired({});
      expect(isVisitRequired, isFalse);
    });

    test("Visit on page should be required if is an empty selling price sheet", () {
      controller.fetchSelectedPage();
      controller.pages = [sellingPriceTemplate..id = -2];
      controller.selectedPageIndex = 0;
      expect(controller.pages[0].isVisitRequired, isTrue);
    });

    test("Visit on page should not be required if is a filled selling price sheet", () {
      controller.pages = [sellingPriceTemplate..id = 12];
      controller.selectedPageIndex = 0;
      controller.fetchSelectedPage();
      expect(controller.pages[0].isVisitRequired, isFalse);
    });

    test("Visit on page should be required if is an empty image template", () {
      controller.pages = [imageTemplate..id = -1];
      controller.selectedPageIndex = 0;
      expect(controller.pages[0].isVisitRequired, isTrue);
    });

    test("Visit on page should not be required if is a filled image template", () {
      controller.pages = [imageTemplate..id = 33];
      controller.selectedPageIndex = 0;
      controller.fetchSelectedPage();
      expect(controller.pages[0].isVisitRequired, isFalse);
    });
  });
}