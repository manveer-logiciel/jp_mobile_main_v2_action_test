import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/bread_crumb.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/job_count.dart';
import 'package:jobprogress/common/models/job/job_invoices.dart';
import 'package:jobprogress/common/models/job_financial/financial_details.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/locale.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jobprogress/translations/index.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final FilesListingController controller = FilesListingController();

  setUpAll(() async{
    Get.addTranslations(JPTranslations().keys);
    Get.locale = LocaleConst.usa;

    SharedPreferences.setMockInitialValues({
      "user": jsonEncode(userJson),
    });
    PermissionService.permissionList = ['share_customer_web_page'];
  });


  group('In view mode', () {
    setUpAll(() {
      controller.initRequiredVariables();
    });
    test("FilesListingController should be initialized with these values", () {
      expect(controller.isLoading, true);
      expect(controller.isLoadMore, false);
      expect(controller.showListView, false);
      expect(controller.searchController.text, "");
      expect(controller.resourceList.isEmpty, true);
      expect(controller.folderPath.isEmpty, true);
      expect(controller.isInSelectionMode, false);
      expect(controller.selectedFileCount, 0);
      expect(controller.isInMoveFileMode, false);
      expect(controller.lastSelectedDir, null);
      expect(controller.jobModel, null);
      expect(controller.currentGoal, null);
      expect(controller.mode, FLViewMode.view);
    });

    test('FilesListingRequestParam is initialized properly', () async {

      await controller.initParam();
      expect(controller.fileListingRequestParam?.parentId, 9);
      expect(controller.fileListingRequestParam?.keyword, '');
      expect(controller.fileListingRequestParam?.page, 1);
      expect(controller.fileListingRequestParam?.limit, '20');
      expect(controller.folderPath.length, 1);
    });

    test('FilesListing should switch between listview and grid view', (){
      final val = controller.showListView;
      controller.toggleView();
      expect(controller.showListView, !val);
    });

    test('FilesListing should refresh when api request for data', (){
      controller.onRefresh(showLoading: true);
      expect(controller.fileListingRequestParam?.page, 1);
      expect(controller.isLoading, true);
      expect(controller.isLoadMore, false);
    });

    test('FilesListing should refresh when api request for data', (){
      controller.onRefresh();
      expect(controller.fileListingRequestParam?.page, 1);
      expect(controller.isLoading, false);
      expect(controller.isLoadMore, false);
    });

    test('FilesListing should load more when api request for data', () async{
      final currentPage = controller.fileListingRequestParam?.page;
      controller.onLoadMore();
      expect(controller.fileListingRequestParam?.page, currentPage! + 1);
      expect(controller.isLoadMore, true);
    });

    test('FilesListing should search when api request for data', (){
      controller.onSearchChanged('val');
      expect(controller.fileListingRequestParam?.page, 1);
      expect(controller.fileListingRequestParam?.keyword, 'val');
      expect(controller.isLoading, true);
      expect(controller.showListView, true);
    });

  });

  test('FilesListing should open a new directory', () async{
    final controller = FilesListingController();
    controller.initRequiredVariables();
    await controller.initParam();

    controller.resourceList = [
      FilesListingModel(
          id: '2',
          name: 'Source item'
      )
    ];
    controller.openDirectory(0);
    expect(controller.fileListingRequestParam?.page, 1);
    expect(controller.fileListingRequestParam?.keyword, '');
    expect(controller.fileListingRequestParam?.parentId, 2);
    expect(controller.isLoading, true);
    expect(controller.searchController.text, '');
  });

  test('FilesListing should make an api call on tap of bread crumb item', () async{

    final controller = FilesListingController();
    controller.initRequiredVariables();
    await controller.initParam();

    controller.folderPath = [
      BreadCrumbModel(
          id: '9',
          name: 'Root'
      ),
      BreadCrumbModel(
          id: '4',
          name: 'folder'
      )
    ];

    controller.onTapBreadCrumbItem(1);

    expect(controller.fileListingRequestParam?.page, 1);
    expect(controller.fileListingRequestParam?.parentId, 9);
    expect(controller.folderPath.length, 2);
    expect(controller.isLoading, true);
    expect(controller.searchController.text, '');
    expect(controller.lastSelectedDir, null);
  });

  group('Selecting/Unselecting a file', (){

    final controller = FilesListingController();

    controller.resourceList = [
      FilesListingModel(
          isDir: 1
      ),
      FilesListingModel(
          isDir: 0,
        isSelected: false,
      ),
      FilesListingModel(
          isDir: 0,
        isSelected: false,
      ),
    ];

    test('When resource is a directory', (){
      controller.addToSelectedFiles(0);
      expect(controller.resourceList[0].isSelected, null);
      expect(controller.selectedFileCount, 0);
    });

    test('When resource is a file', (){
      controller.addToSelectedFiles(1);
      expect(controller.resourceList[1].isSelected, true);
      expect(controller.selectedFileCount, 1);
    });

    test('When only single file is selected, on selecting is again should unselect', (){
      controller.removeOnSingleAddOnMultiple(1);
      expect(controller.resourceList[1].isSelected, false);
      expect(controller.selectedFileCount, 0);
    });

    test('When only single file is selected, on selecting other file it should be selected', (){
      controller.addToSelectedFiles(1);
      controller.removeOnSingleAddOnMultiple(2);
      expect(controller.resourceList[2].isSelected, true);
    });

  });

  test('FilesListing should cancel selection', () async{
    final controller = FilesListingController();
    controller.onCancelSelection();
    expect(controller.isInSelectionMode, false);
    expect(controller.selectedFileCount, 0);
  });

  test('FliesListing should show create folder icon only when type is FLModule.stageResource', (){
    List<String> permissionList = ["manage_company_files"];
    PermissionService.permissionList = permissionList;
    final controller = FilesListingController();
    controller.type = FLModule.stageResources;
    expect(controller.doShowCreateFolder(), false);
    controller.type = FLModule.companyFiles;
    expect(controller.doShowCreateFolder(), true);
  });

  test('FliesListing should toggle isGoalSelected', (){
    List<String> permissionList = ["manage_company_files"];
    PermissionService.permissionList = permissionList;
    final controller = FilesListingController();
    expect(controller.isGoalSelected, false);
    controller.type = FLModule.companyFiles;
    expect(controller.doShowCreateFolder(), true);
  });


  // group('In Attach mode', () {
  //
  //   SharedPreferences.setMockInitialValues({
  //     "user": jsonEncode(userJson),
  //   });
  //
  //   final controller = FilesListingController();
  //   controller.mode = FLViewMode.attach;
  //   controller.onInit();
  //
  //   test(
  //       "FilesListingController should be initialized with these values",
  //           () {
  //         expect(controller.isLoading, true);
  //         expect(controller.isLoadMore, false);
  //         expect(controller.showListView, false);
  //         expect(controller.searchController.text, "");
  //         expect(controller.resourceList.isEmpty, true);
  //         expect(controller.folderPath.isEmpty, false);
  //         expect(controller.isInSelectionMode, true);
  //         expect(controller.selectedFileCount, 0);
  //         expect(controller.isInMoveFileMode, false);
  //         expect(controller.lastSelectedDir, null);
  //         expect(controller.mode, FLViewMode.attach);
  //         expect(controller.companyCamphotoCount, 0);
  //         expect(controller.projectId, null);
  //       });
  // });
  //
  //
  // group('In Move File mode', () {
  //
  //   SharedPreferences.setMockInitialValues({
  //     "user": jsonEncode(userJson),
  //   });
  //
  //   final controller = FilesListingController(mode: FLViewMode.move);
  //   controller.initRequiredVariables();
  //
  //   test(
  //       "FilesListingController should be initialized with these values",
  //           () {
  //         expect(controller.isLoading, true);
  //         expect(controller.isLoadMore, false);
  //         expect(controller.showListView, false);
  //         expect(controller.searchController.text, "");
  //         expect(controller.resourceList.isEmpty, true);
  //         expect(controller.folderPath.isEmpty, true);
  //         expect(controller.isInSelectionMode, false);
  //         expect(controller.selectedFileCount, 0);
  //         expect(controller.isInMoveFileMode, true);
  //         expect(controller.lastSelectedDir, null);
  //         expect(controller.mode, FLViewMode.move);
  //         expect(controller.companyCamphotoCount, 0);
  //         expect(controller.projectId, null);
  //       });
  // });


   group('FilesListingModel@getClassType should identify the type of file from available mime types', () {
     final filesListingModel = FilesListingModel();

     test("File should be an unsupported file, when any one mime type is available without data", () {
       final result = filesListingModel.getClassType({
         'mime_type': null,
       });

       expect(result, "unknown");
       expect(filesListingModel.isUnSupportedFile, isTrue);
       expect(filesListingModel.mimeType, isNull);
       expect(filesListingModel.fileMimeType, isNull);
     });

     test("File should be an unsupported file, when both mime types are available without data", () {
       final result = filesListingModel.getClassType({
         'mime_type': null,
         'file_mime_type': null,
       });

       expect(result, "unknown");
       expect(filesListingModel.isUnSupportedFile, isTrue);
       expect(filesListingModel.mimeType, isNull);
       expect(filesListingModel.fileMimeType, isNull);
     });

     test("File should be a supported pdf file, when no mime types are available", () {
       final result = filesListingModel.getClassType({});

       expect(result, "pdf");
       expect(filesListingModel.isUnSupportedFile, isFalse);
       expect(filesListingModel.mimeType, 'application/pdf');
       expect(filesListingModel.fileMimeType, isNull);
     });

     test("File should be a supported file, when mime type is available with data", () {
       final result = filesListingModel.getClassType({
         'mime_type': 'image/jpeg',
       });

       expect(result, "png");
       expect(filesListingModel.isUnSupportedFile, isFalse);
       expect(filesListingModel.mimeType, 'image/jpeg');
       expect(filesListingModel.fileMimeType, isNull);
     });

     group("File's class type should be decided based on available mime types correctly", () {
       test("Class type should depend on 'mime type' when available", () {
         final result = filesListingModel.getClassType({
           'mime_type': 'image/jpeg',
         });

         expect(result, "png");
         expect(filesListingModel.isUnSupportedFile, isFalse);
         expect(filesListingModel.mimeType, 'image/jpeg');
         expect(filesListingModel.fileMimeType, isNull);
       });

       test("Class type should depend on 'file mime type' when available and 'mime type' is not available", () {
         final result = filesListingModel.getClassType({
           'file_mime_type': 'image/png',
         });

         expect(result, "png");
         expect(filesListingModel.isUnSupportedFile, isFalse);
         expect(filesListingModel.mimeType, isNull);
         expect(filesListingModel.fileMimeType, 'image/png');
       });

       test("Class type should depend on 'mime type' when both 'file mime type' and 'mime type' are available", () {
         final result = filesListingModel.getClassType({
           'mime_type': 'image/jpeg',
           'file_mime_type': 'application/pdf',
         });
         expect(result, "png");
         expect(filesListingModel.isUnSupportedFile, isFalse);
         expect(filesListingModel.mimeType, 'image/jpeg');
         expect(filesListingModel.fileMimeType, 'application/pdf');
       });
     });

     test("Class type should be 'png' even when available mime type is 'image/jpeg'", () {
       final result = filesListingModel.getClassType({
         'mime_type': 'image/jpeg',
       });

       expect(result, "png");
       expect(filesListingModel.isUnSupportedFile, isFalse);
       expect(filesListingModel.mimeType, 'image/jpeg');
       expect(filesListingModel.fileMimeType, isNull);
     });
   });

   test('FileListingController@resetAllSelections should reset values', () {
     FilesListingController controller = FilesListingController();
     controller.resetAllSelections();
     bool isAllItemsNotSelected = controller.resourceList.any((element) => element.isSelected ?? false);

     bool isModeAttachORApply = controller.mode == FLViewMode.attach || controller.mode == FLViewMode.apply;

     expect(isAllItemsNotSelected, isFalse);
     expect(controller.selectedFileCount, isZero);
     expect(controller.isInSelectionMode, isModeAttachORApply);
     expect(controller.selectedPageType, isNull);
   });

   group("FileListingController@getModuleNameWithCount should give module name along with number of files", () {
     test("In case job is not available only name should be given", () {
       FilesListingController controller = FilesListingController();
       controller.jobModel = null;
       controller.type = FLModule.jobContracts;
       final result = controller.getModuleNameWithCount();
       expect(result, 'contracts'.tr.toUpperCase());
     });

     test("In case job is available name along with number of files should be given", () {
       FilesListingController controller = FilesListingController();
       controller.jobModel = tempJob..count = JobCountModel(
         contracts: 5
       );
       controller.isLoading = false;
       controller.type = FLModule.jobContracts;
       final result = controller.getModuleNameWithCount();
       expect(result, "${'contracts'.tr.toUpperCase()} (5)");
     });

     test("When count is 0 it should not be displayed", () {
       FilesListingController controller = FilesListingController();
       controller.jobModel = tempJob..count = JobCountModel(
           contracts: 0
       );
       controller.isLoading = false;
       controller.type = FLModule.jobContracts;
       final result = controller.getModuleNameWithCount();
       expect(result, 'contracts'.tr.toUpperCase());
     });
   });

   group("FileListingController@getTitle should be title of modules are per type", () {
     test("In case of Contracts Module", () {
       FilesListingController controller = FilesListingController();
       controller.type = FLModule.jobContracts;
       final result = controller.getTitle();
       expect(result, 'contracts'.tr);
     });
   });

   group("FileListingController@isAddOrUploadButtonEnable should decide whether to display create file button", () {
     test("Create File button should not be displayed on case of Contracts module", () {
       FilesListingController controller = FilesListingController();
       controller.type = FLModule.jobContracts;
       final result = controller.isAddOrUploadButtonEnable('');
       expect(result, isTrue);
     });
   });

   group("FileListingController@canFilterByModule should decide whether show selector on module name", () {
     test("Selector should be shown in case of template listing", () {
       LDFlags.salesProForEstimate.value = false;
       final controller = FilesListingController();
       controller.type = FLModule.templatesListing;
       expect(controller.canFilterByModule, isTrue);
     });

     test("Selector should not be shown in case of any other module than template listing", () {
       LDFlags.salesProForEstimate.value = false;
       final controller = FilesListingController();
       controller.type = FLModule.instantPhotoGallery;
       expect(controller.canFilterByModule, isFalse);
     });

     test("Selector should not be shown in case of template listing and [${LDFlagKeyConstants.salesProForEstimate}] is enabled", () {
       LDFlags.salesProForEstimate.value = true;
       final controller = FilesListingController();
       controller.type = FLModule.templatesListing;
       expect(controller.canFilterByModule, isFalse);
     });
   });

   group("FileListingController@setTemplatesListingType should decide which template listing to be loaded initially", () {
     test("Template listing type should be 'estimate' in case [${LDFlagKeyConstants.salesProForEstimate}] is disabled or turned off", () {
       LDFlags.salesProForEstimate.value = false;
       final controller = FilesListingController();
       controller.type = FLModule.templatesListing;
       controller.setTemplatesListingType();
       expect(controller.templateListType, 'estimate');
     });

     test("Template listing type should be 'proposal' in case [${LDFlagKeyConstants.salesProForEstimate}] is enabled", () {
       LDFlags.salesProForEstimate.value = true;
       final controller = FilesListingController();
       controller.type = FLModule.templatesListing;
       controller.setTemplatesListingType();
       expect(controller.templateListType, 'proposal');
     });
   });
   
   group("FileListingController@isAddOrUploadButtonEnable should decide whether to show create file button", () {
     group("In case of estimates", () {
       test("Create file button should be show, when [${LDFlagKeyConstants.salesProForEstimate}] is disabled", () {
         LDFlags.salesProForEstimate.value = false;
         final controller = FilesListingController();
         controller.type = FLModule.estimate;
         expect(controller.isAddOrUploadButtonEnable("estimate"), isFalse);
       });

       test("Create file button should not be show, when [${LDFlagKeyConstants.salesProForEstimate}] is enabled", () {
         LDFlags.salesProForEstimate.value = true;
         final controller = FilesListingController();
         controller.type = FLModule.estimate;
         expect(controller.isAddOrUploadButtonEnable("estimate"), isTrue);
       });
     });
   });

   group("FileListingController@getModuleNameWithCount should 'DOCUMENTS' label instead of 'FORM / PROPOSAL'", () {
     test("'FORM / PROPOSAL' label should not be displayed", () {
       FilesListingController controller = FilesListingController();
       controller.jobModel = tempJob;
       controller.isLoading = false;
       controller.type = FLModule.jobProposal;
       final result = controller.getModuleNameWithCount();
       expect(result.contains('FORM / PROPOSAL'), isFalse);
     });

     test("'DOCUMENTS' label should be displayed in place of 'FORM / PROPOSAL'", () {
       FilesListingController controller = FilesListingController();
       controller.jobModel = tempJob;
       controller.isLoading = false;
       controller.type = FLModule.jobProposal;
       final result = controller.getModuleNameWithCount();
       expect(result.contains('DOCUMENTS'), isTrue);
     });
   });

   group("FileListingController@getModuleNameWithCount should 'PHOTOS & FILES' label instead of 'PHOTOS & DOCUMENTS'", () {
     test("'PHOTOS & DOCUMENTS' label should not be displayed", () {
       FilesListingController controller = FilesListingController();
       controller.jobModel = tempJob;
       controller.isLoading = false;
       controller.type = FLModule.jobPhotos;
       final result = controller.getModuleNameWithCount();
       expect(result.contains('PHOTOS & DOCUMENTS'), isFalse);
     });

     test("'PHOTOS & FILES' label should be displayed in place of 'PHOTOS & DOCUMENTS'", () {
       FilesListingController controller = FilesListingController();
       controller.jobModel = tempJob;
       controller.isLoading = false;
       controller.type = FLModule.jobPhotos;
       final result = controller.getModuleNameWithCount();
       expect(result.contains('PHOTOS & FILES'), isTrue);
     });
   });

   group("FilesListingModel@getRelativeTime should convert last modified time to relative time", () {
     setUp(() {
       DateTimeHelper.setUpTimeZone();
     });

     test("Last modified time should be converted to relative time", () {
       final model = FilesListingModel(
         updatedAt: DateTime.now().subtract(const Duration(days: 5)).toString(),
       );
       final result = model.getRelativeTime();
       expect(result, isNotEmpty);
       expect(result, '5 days ago');
     });

     group("Last modified time should not be converted to relative time", () {
       test("When last modified time is not available", () {
         final model = FilesListingModel();
         final result = model.getRelativeTime();
         expect(result, isNull);
       });

       test("When last modified time is empty", () {
         final model = FilesListingModel(
           updatedAt: "",
         );
         final result = model.getRelativeTime();
         expect(result, isNull);
       });

       test("When selected file is folder", () {
         final model = FilesListingModel(
           updatedAt: DateTime.now().subtract(const Duration(days: 5)).toString(),
         )..jpThumbType = JPThumbType.folder;
         final result = model.getRelativeTime();
         expect(result, isNull);
       });
     });
   });

  group('FilesListingController@isSelectedWorksheetSame should check selected fav worksheet is same as parent worksheet', () {
    setUpAll(() {
      controller.resourceList = [
        FilesListingModel(
          favouriteFile: FilesListingModel(
            worksheetId: '1'
          )
        )
      ];
    });
    test('When selected fav worksheet matches the parent worksheet', () {
      // Mock or set up the state where the selected worksheet matches the parent worksheet
      controller.lastSelectedFile = 0;
      controller.parentWorksheetId = 1;

      final result = controller.isSelectedWorksheetSame();

      expect(result, isTrue);
    });

    test('When selected fav worksheet does not match the parent worksheet', () {
      // Mock or set up the state where the selected worksheet does not match the parent worksheet
      controller.lastSelectedFile = 0;
      controller.parentWorksheetId = 2;

      final result = controller.isSelectedWorksheetSame();

      expect(result, isFalse);
    });

    test('When fav worksheet is not selected', () {
      // Mock or set up the state where the selected worksheet is null
      controller.lastSelectedFile = null;
      controller.parentWorksheetId = 1;

      final result = controller.isSelectedWorksheetSame();

      expect(result, isFalse);
    });

    test('When parent worksheet is not available', () {
      // Mock or set up the state where the parent worksheet is null
      controller.lastSelectedFile = 0;
      controller.parentWorksheetId = null;

      final result = controller.isSelectedWorksheetSame();

      expect(result, isFalse);
    });

    test('When both selected and parent worksheets are not available', () {
      // Mock or set up the state where both selected and parent worksheets are null
      controller.lastSelectedFile = null;
      controller.parentWorksheetId = null;

      final result = controller.isSelectedWorksheetSame();

      expect(result, isFalse);
    });
  });

  group('Testing locked directory handling and tooltip display in file listing', () {
    setUpAll(() {
      controller.initRequiredVariables();
      controller.resourceList = tempResourceList;
    });

    test('FilesListingController@isResourceLocked should return true for directories with locked=1', () {
      // Index 1 is a locked directory in tempResourceList
      expect(controller.isResourceLocked(tempResourceList[1]), isTrue);
    });

    test('FilesListingController@isResourceLocked should return false for directories with locked=0', () {
      // Index 0 is an unlocked directory in tempResourceList
      expect(controller.isResourceLocked(tempResourceList[0]), isFalse);
    });

    test('FilesListingController@isResourceLocked should return false for files even when locked=1', () {
      // Create a file with locked=1
      final lockedFile = FilesListingModel(
        isDir: 0,
        locked: 1,
        isFile: true,
      );
      expect(controller.isResourceLocked(lockedFile), isFalse);
    });

    test('FilesListingController@isResourceLocked should return true for directories with isRestricted=true', () {
      // Create a restricted directory
      final restrictedDir = FilesListingModel(
        isDir: 1,
        locked: 0,
        isRestricted: true,
      );
      expect(controller.isResourceLocked(restrictedDir), isTrue);
    });

    // Testing the behavior of locked directories with quick actions
    // Since we can't easily mock the showQuickAction method, we'll test the core logic
    // that determines whether quick actions should be shown
    
    test('FilesListingController@isResourceLocked should correctly identify locked directories for UI handling', () {
      // Index 1 is a locked directory in tempResourceList
      final lockedDir = tempResourceList[1];
      
      // Verify it's a directory and it's locked
      expect(lockedDir.isDir, 1);
      expect(lockedDir.locked, 1);
      
      // Verify the controller identifies it as locked
      expect(controller.isResourceLocked(lockedDir), isTrue);
    });
    
    test('FilesListingController@isResourceLocked should correctly identify unlocked directories for UI handling', () {
      // Index 0 is an unlocked directory in tempResourceList
      final unlockedDir = tempResourceList[0];
      
      // Verify it's a directory and it's not locked
      expect(unlockedDir.isDir, 1);
      expect(unlockedDir.locked, 0);
      
      // Verify the controller doesn't identify it as locked
      expect(controller.isResourceLocked(unlockedDir), isFalse);
    });
  });
}

Map<String, dynamic> userJson = {
  "id": 1,
  "first_name": "Anuj",
  "last_name": "Singh QA",
  "full_name": "Anuj Singh QA",
  "full_name_mobile": "Anuj Singh QA",
  "email": "anuj.singh@logicielsolutions.co.in",
  "group_id": null,
  "group": {
    'id': 5,
    'name': "owner"
  },
  "profile_pic":
      "https://www.google.com/url?sa=i&url=http%3A%2F%2Fwww.goodmorningimagesdownload.com%2Fgirlfriend-whatsapp-dp%2F&psig=AOvVaw1AAIEUa8fFSx2tjpnHgR99&ust=1648804135617000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCOiVkJqA8PYCFQAAAAAdAAAAABAD",
  "color": "#1c36ee",
  "company_id": 1,
  "company_name": "",
  "total_commission": null,
  "paid_commission": null,
  "unpaid_commission": null,
  "all_divisions_access": true,
  "company_details": {
    "company_name": "AS constructions",
    "office_state_id" : 1,
    "office_country_id" : 1,
    "id": 1,
    "logo":
        "https://pcdn.jobprog.net/public%2Fuploads%2Fcompany%2Flogos%2F1_1643299505.jpg",
    "subscriber_resource_id": 9,
    "office_additional_phone" : ['2'],
    "office_additional_email" : ['2'],
    "office_state" : {
      "name" : "",
      "code" : "",
    },
    "office_country" : {
      "name" : "",
      "code" : "",
      "phone_code" : "",
      "currency_symbol" : ""
    },
  }
};

List<FilesListingModel> tempResourceList = [
  /// Company files
  // Unlocked directory
  FilesListingModel(
      isDir: 1,
      locked: 0,
      isShownOnCustomerWebPage: false
  ),

  // Locked directory
  FilesListingModel(
      isDir: 1,
      locked: 1,
      isShownOnCustomerWebPage: false
  ),

  // Photo file
  FilesListingModel(
      isDir: 0,
      isFile: true,
      jpThumbType: JPThumbType.image,
      path: "https://abc.png",
      isGoogleDriveLink: false,
      isShownOnCustomerWebPage: false,
      isHoverJobCompleted: false,
      isMeasurement: false,
      isMaterialList: false
  ),

  // Document
  FilesListingModel(
      isDir: 0,
      isFile: true,
      jpThumbType: JPThumbType.icon,
      isGoogleDriveLink: false,
      isShownOnCustomerWebPage: false,
      isHoverJobCompleted: false,
      isMeasurement: false,
      isMaterialList: false
  ),

  /// Job estimations
  // Unlocked directory
  FilesListingModel(
    isDir: 1,
    locked: 0,
    isWorkSheet: true,
    isShownOnCustomerWebPage: false,
    isGoogleSheet: false,
    isGoogleDriveLink: true,
    isMaterialList: false,
    isWorkOrder: false,
  ),

  // Locked directory
  FilesListingModel(
    isDir: 1,
    locked: 1,
    isWorkSheet: false,
    isShownOnCustomerWebPage: false,
    isGoogleSheet: false,
    isGoogleDriveLink: true,
    isMaterialList: false,
    isWorkOrder: false,
  ),

  // Image file
  FilesListingModel(
    isDir: 0,
    isFile: true,
    jpThumbType: JPThumbType.image,
    isShownOnCustomerWebPage: false,
    isGoogleSheet: false,
    isWorkSheet: false,
    isMaterialList: false,
    isWorkOrder: false,
  ),

  // Document
  FilesListingModel(
    isDir: 0,
    isFile: true,
    jpThumbType: JPThumbType.icon,
    isShownOnCustomerWebPage: false,
    isGoogleSheet: false,
    isWorkSheet: false,
    isMaterialList: false,
    isWorkOrder: false,
  ),

  // File shown on customer web page
  FilesListingModel(
    isDir: 0,
    isFile: true,
    jpThumbType: JPThumbType.icon,
    isShownOnCustomerWebPage: true,
    isGoogleSheet: false,
    isWorkSheet: false,
  ),

  FilesListingModel(
      isDir: 0,
      isFile: true,
      jpThumbType: JPThumbType.image,
      path: "https://abc.png",
      isGoogleDriveLink: false,
      isShownOnCustomerWebPage: true,
      isHoverJobCompleted: false,
      isMeasurement: false,
      isMaterialList: false
  )

];

JobModel tempJob = JobModel(
  id: -1,
  customerId: -1,
  jobInvoices: [
    JobInvoices(),
    JobInvoices()
  ],
  financialDetails: FinancialDetailModel(canBlockFinancial: false),
  isMultiJob: false,
);


