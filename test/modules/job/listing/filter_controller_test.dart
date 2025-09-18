import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/models/customer_list/customer_listing_filter.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/modules/customer/filter_dialog/controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CustomerListingFilterModel filterModel = CustomerListingFilterModel();
  CustomerListingFilterDialogController? controller;

  setUpAll(() {
    RunModeService.setRunMode(RunMode.unitTesting);
    Get.testMode = true;
    controller = CustomerListingFilterDialogController(filterModel, filterModel);
  });

  group('CustomerListingFilterDialogController should be initialized with correct values', () {
    group('CustomerListingFilterDialogController@updateResetButtonDisable should toggle disability of reset button', () {
      test('Reset button should be disable when no changes are made in filter fields', () {
        controller?.updateResetButtonDisable();
        expect(controller?.isResetButtonDisable, true);
      });

      test('Reset button should not be disable when any change is made in filter fields', () {
        controller?.filterKeys.address = "Address Line 1, City, State";
        controller?.updateResetButtonDisable();
        expect(controller?.isResetButtonDisable, false);
      });
    });
  });
}