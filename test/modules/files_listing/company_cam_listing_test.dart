import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FilesListingController controller = FilesListingController();

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

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({"user": jsonEncode(userJson),});
    PermissionService.permissionList = ['share_customer_web_page'];
    controller.type = FLModule.companyCamProjects;
    controller.initRequiredVariables();
  });


  group('In case of CompanyCam listing', () {
    WidgetsFlutterBinding.ensureInitialized();

    group('For refreshing CompanyCam projects list', () {
      test('CompanyCam projects list should refresh without showing shimmer', () async {
        await controller.initParam();
        controller.onRefresh();
        expect(controller.fileListingRequestParam?.page, 1);
        expect(controller.fileListingRequestParam?.nextPageToken, null);
        expect(controller.isLoading, false);
        expect(controller.isLoadMore, false);
      });

      test('CompanyCam projects list should refresh with showing shimmer', () async {
        await controller.initParam();
        controller.onRefresh(showLoading: true);
        expect(controller.fileListingRequestParam?.page, 1);
        expect(controller.fileListingRequestParam?.nextPageToken, null);
        expect(controller.isLoading, true);
        expect(controller.isLoadMore, false);
      });

      test('CompanyCam projects list should refresh with showing shimmer when search field is not empty', () async {
        final controller = FilesListingController();
        controller.initRequiredVariables();
        controller.searchController.text = "Search text sample";
        await controller.initParam();
        controller.onRefresh(showLoading: true);
        expect(controller.fileListingRequestParam?.page, 1);
        expect(controller.fileListingRequestParam?.nextPageToken, null);
        expect(controller.fileListingRequestParam?.query, "Search text sample");
        expect(controller.isLoading, true);
        expect(controller.isLoadMore, false);
      });

    });
  });
}