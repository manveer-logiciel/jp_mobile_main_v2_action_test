import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/bread_crumb.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'file_listing_test.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async{
    SharedPreferences.setMockInitialValues({
      "user": jsonEncode(userJson),
    });
    PermissionService.permissionList = ['share_customer_web_page'];
  });

 test('DropboxListing should be constructed with default values', () async {
    final controller = FilesListingController();
    controller.initRequiredVariables();
    await controller.initParam();
    expect(controller.fileListingRequestParam?.keyword, '');
    expect(controller.fileListingRequestParam?.page, 1);
    expect(controller.fileListingRequestParam?.limit, '20');
    expect(controller.fileListingRequestParam?.parent, null);
    expect(controller.fileListingRequestParam?.nextPageToken, null);
    }
  );

  test('DropboxListing should refresh list without showing shimmer', (){
    final controller = FilesListingController();
    controller.initRequiredVariables();
    controller.type = FLModule.dropBoxListing;
    controller.onRefresh(showLoading: true);
    expect(controller.fileListingRequestParam?.page, 1);
    expect(controller.fileListingRequestParam?.nextPageToken, null);
    expect(controller.isLoading, true);
    expect(controller.isLoadMore, false);
    }
  );

  test('DropboxListing should refresh list without showing without shimmer', (){
    final controller = FilesListingController();
    controller.initRequiredVariables();
    controller.type = FLModule.dropBoxListing;
    controller.onRefresh();
    expect(controller.fileListingRequestParam?.page, 1);
    expect(controller.fileListingRequestParam?.nextPageToken, null);
    expect(controller.isLoading, false);
    expect(controller.isLoadMore, false);
    }
  );

  test('DropboxListing should load more when api request for data', (){
    final controller = FilesListingController();
    controller.initRequiredVariables();
    controller.type = FLModule.dropBoxListing;
    controller.onLoadMore();
    expect(controller.fileListingRequestParam?.page, 1);
    expect(controller.fileListingRequestParam?.nextPageToken, controller.nextPageToken);
    expect(controller.isLoading, true);
    expect(controller.isLoadMore, true);
    }
  );

  test('DropboxListing should search when api request for data', (){
    final controller = FilesListingController();
    controller.initRequiredVariables();
    controller.type = FLModule.dropBoxListing;
    controller.fetchResources(search: true);
    String val = 'test';
    controller.onSearchChanged(val);
    expect(controller.fileListingRequestParam?.page, 1);
    expect(controller.fileListingRequestParam?.keyword, val);
    expect(controller.fileListingRequestParam?.nextPageToken, null);
    expect(controller.isLoading, true);
    }
  );

  test('DropboxListing should open a new directory', () async{
    final controller = FilesListingController();
    controller.initRequiredVariables();
    controller.type = FLModule.dropBoxListing;
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
    expect(controller.fileListingRequestParam?.parent, '2');
    expect(controller.isLoading, true);
    expect(controller.searchController.text, '');
  });

    test('DropboxListing should make an api call on tap of bread crumb item', () async{

    final controller = FilesListingController();
    controller.initRequiredVariables();
    controller.type = FLModule.dropBoxListing;
    await controller.initParam();

    controller.folderPath = [
      BreadCrumbModel(
          id: '1',
          name: 'Root'
      ),
      BreadCrumbModel(
          id: '2',
          name: 'folder'
      ),
      BreadCrumbModel(
          id: '3',
          name: 'file'
      )
    ];

    controller.onTapBreadCrumbItem(2);

    expect(controller.fileListingRequestParam?.page, 1);
    expect(controller.fileListingRequestParam!.parent, null);
    expect(controller.folderPath.length, 3);
    expect(controller.isLoading, true);
  });
}
