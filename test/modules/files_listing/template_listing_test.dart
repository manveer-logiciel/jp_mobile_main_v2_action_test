import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_request_param.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/dropdown_list_constants.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = FilesListingController();

  List<JPSingleSelectModel> tradeList = [
    JPSingleSelectModel(id: "all", label: "ALL"),
    JPSingleSelectModel(id: "57", label: "AIR QUALITY SERVICES"),
    JPSingleSelectModel(id: "60", label: "APPLIANCES"),
    JPSingleSelectModel(id: "31", label: "AUTOMOTIVE"),
    JPSingleSelectModel(id: "29", label: "AWNINGS & CANOPIES"),
    JPSingleSelectModel(id: "31", label: "AUTOMOTIVE"),
  ];

  setUpAll(() async{
    RunModeService.setRunMode(RunMode.unitTesting);
    controller.type = FLModule.templatesListing;
    controller.parentModule = FLModule.estimate;
    controller.initRequiredVariables();
  });

  group("Initializing data for template listing", () {

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

    test("FilesListingRequestParam is initialized properly", () async {
      await controller.initParam();
      expect(controller.fileListingRequestParam?.parentId, null);
      expect(controller.fileListingRequestParam?.keyword, '');
      expect(controller.fileListingRequestParam?.page, 1);
      expect(controller.fileListingRequestParam?.limit, '20');
      expect(controller.folderPath.length, 1);
    });
  });

  group("For template listing", () {

    group("For template listing type", () {
      test("FilesListingController should load hand written templates", () async {
        controller.templateListType = DropdownListConstants.templateTypeList[0].id;
        var params = controller.fileListingRequestParam!.templateListingtoJson(templateType: controller.templateListType);
        expect(params["type"], DropdownListConstants.templateTypeList[0].id);
        expect(controller.fileListingRequestParam?.page, 1);
        expect(controller.isLoading, true);
        expect(controller.showListView, false);
      });

      test("FilesListingController should load form proposal templates", () async {
        controller.templateListType = DropdownListConstants.templateTypeList[1].id;
        var params = controller.fileListingRequestParam!.templateListingtoJson(templateType: controller.templateListType);
        expect(params["type"], DropdownListConstants.templateTypeList[1].id);
        expect(controller.fileListingRequestParam?.page, 1);
        expect(controller.isLoading, true);
        expect(controller.showListView, false);
      });
    });

    group("For template listing filter by trades", () {
      controller.filterByList = tradeList;
      test("FilesListingController should load all templates of all trades", () async {
        controller.onSelectingFilter(controller.filterByList[0].id);
        Map<String, dynamic> params = FilesListingRequestParam.getTemplateListingParams(controller.selectedFilterByOptions);
        expect(params["trades"], "");
        expect(controller.fileListingRequestParam?.keyword, "");
        expect(controller.fileListingRequestParam?.page, 1);
        expect(controller.isLoading, true);
        expect(controller.showListView, false);
      });

      test("FilesListingController should load templates of selected trade", () async {
        controller.onSelectingFilter(controller.filterByList[1].id);
        Map<String, dynamic> params = FilesListingRequestParam.getTemplateListingParams(controller.selectedFilterByOptions);
        expect(params["trades"], controller.filterByList[1].id);
        expect(controller.fileListingRequestParam?.keyword, "");
        expect(controller.fileListingRequestParam?.page, 1);
        expect(controller.isLoading, true);
        expect(controller.showListView, false);
      });
    });

    group("For template listing refresh", () {
      test("Template listing should refresh when api request for data", (){
        controller.onRefresh();
        expect(controller.fileListingRequestParam?.page, 1);
        expect(controller.isLoading, false);
        expect(controller.isLoadMore, false);
      });

      test("Template listing should show loader while refresh when api request for data", (){
        controller.onRefresh(showLoading: true);
        expect(controller.fileListingRequestParam?.page, 1);
        expect(controller.isLoading, true);
        expect(controller.isLoadMore, false);
      });
    });

    test("Template listing should load more when api request for data", () {
      final currentPage = controller.fileListingRequestParam?.page;
      controller.onLoadMore();
      expect(controller.fileListingRequestParam?.page, currentPage! + 1);
      expect(controller.isLoadMore, true);
    });

    test("Template listing should search when api request for data", (){
      controller.onSearchChanged("val");
      expect(controller.fileListingRequestParam?.page, 1);
      expect(controller.fileListingRequestParam?.keyword, "val");
      expect(controller.isLoading, true);
      expect(controller.showListView, false);
    });

    test("Template listing should open a new directory", () {
      controller.resourceList = [FilesListingModel(id: "10", name: "Source item")];
      controller.openDirectory(0);
      expect(controller.fileListingRequestParam?.page, 1);
      expect(controller.fileListingRequestParam?.keyword, '');
      expect(controller.fileListingRequestParam?.parentId, 10);
      expect(controller.isLoading, true);
      expect(controller.searchController.text, '');
    });

    group("Template listing should switch between listview and grid view", () {
      test("Template listing should be shown in grid view", () {
        final val = controller.showListView;
        controller.toggleView();
        expect(controller.showListView, !val);
      });

      test("Template listing should be shown in list view", () {
        final val = controller.showListView;
        controller.toggleView();
        expect(controller.showListView, !val);
      });
    });
  });
}