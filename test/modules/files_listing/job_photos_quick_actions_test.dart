import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_options.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions_list.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';

import 'file_listing_test.dart';


void main() {

    group('For job photos and documents', (){

      final controller = FilesListingController();
      controller.resourceList = tempResourceList;

      group('In case of directory', () {

        test('When folder is not locked only rename and delete options should be displayed', () {

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobPhotosActionsList(
              FilesListingQuickActionParams(
                fileList: [controller.resourceList[4]],
                onActionComplete: (_, __) { },
              )
          );

          final tempResult = result[FileListingQuickActionsList.folderActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.delete), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rename), true);

        });

        test('When folder is locked no options should be displayed', () {

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobPhotosActionsList(
              FilesListingQuickActionParams(
                fileList: [controller.resourceList[5]],
                onActionComplete: (_, __) { },
              )
          );

          final tempResult = result[FileListingQuickActionsList.folderActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.delete), false);
          expect(tempResult.contains(FileListingQuickActionOptions.rename), false);

        });

      });

      group('In case of file', () {

        test('When file is an image file rotate option should be displayed', () {

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobPhotosActionsList(
              FilesListingQuickActionParams(
                fileList: [controller.resourceList[2]],
                onActionComplete: (_, __) { },
                isInSelectionMode: false,
              )
          );

          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.delete), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rename), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rotate), true);
          expect(tempResult.contains(FileListingQuickActionOptions.expiresOn), true);
          expect(tempResult.contains(FileListingQuickActionOptions.info), true);
          expect(tempResult.contains(FileListingQuickActionOptions.move), true);
          expect(tempResult.contains(FileListingQuickActionOptions.print), true);
          expect(tempResult.contains(FileListingQuickActionOptions.showOnCustomerWebPage), false);
          expect(tempResult.contains(FileListingQuickActionOptions.sendViaText), true);
        });

        test('When file is not an image file rotate option should be hidden', () {

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobPhotosActionsList(
              FilesListingQuickActionParams(
                fileList: [controller.resourceList[3]],
                onActionComplete: (_, __) { },
                isInSelectionMode: false,
              )
          );

          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.delete), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rename), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rotate), false);
          expect(tempResult.contains(FileListingQuickActionOptions.expiresOn), true);
          expect(tempResult.contains(FileListingQuickActionOptions.info), true);
          expect(tempResult.contains(FileListingQuickActionOptions.move), true);
          expect(tempResult.contains(FileListingQuickActionOptions.print), true);
          expect(tempResult.contains(FileListingQuickActionOptions.showOnCustomerWebPage), false);
          expect(tempResult.contains(FileListingQuickActionOptions.sendViaJobProgress), true);

        });

        test('When file multiple files are selected common options should be displayed', () {

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobPhotosActionsList(
              FilesListingQuickActionParams(
                isInSelectionMode: true,
                fileList: [controller.resourceList[3], controller.resourceList[2]],
                onActionComplete: (_, __) { },
              )
          );

          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.delete), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rename), false);
          expect(tempResult.contains(FileListingQuickActionOptions.rotate), false);
          expect(tempResult.contains(FileListingQuickActionOptions.expiresOn), false);
          expect(tempResult.contains(FileListingQuickActionOptions.info), false);
          expect(tempResult.contains(FileListingQuickActionOptions.move), true);
          expect(tempResult.contains(FileListingQuickActionOptions.print), false);
          expect(tempResult.contains(FileListingQuickActionOptions.sendViaJobProgress), false);
          expect(tempResult.contains(FileListingQuickActionOptions.showOnCustomerWebPage), false);
          expect(tempResult.contains(FileListingQuickActionOptions.removeFromCustomerWebPage), false);

        });

        test('When file multiple images are selected common options should be displayed', () {

          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobPhotosActionsList(
              FilesListingQuickActionParams(
                isInSelectionMode: true,
                fileList: [controller.resourceList[2], controller.resourceList[2]],
                onActionComplete: (_, __) { },
              )
          );

          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.delete), true);
          expect(tempResult.contains(FileListingQuickActionOptions.rename), false);
          expect(tempResult.contains(FileListingQuickActionOptions.rotate), true);
          expect(tempResult.contains(FileListingQuickActionOptions.expiresOn), false);
          expect(tempResult.contains(FileListingQuickActionOptions.info), false);
          expect(tempResult.contains(FileListingQuickActionOptions.move), true);
          expect(tempResult.contains(FileListingQuickActionOptions.print), false);
          expect(tempResult.contains(FileListingQuickActionOptions.sendViaText), false);
          expect(tempResult.contains(FileListingQuickActionOptions.showOnCustomerWebPage), false);
          expect(tempResult.contains(FileListingQuickActionOptions.removeFromCustomerWebPage), false);
        });

        test('When multiple file is selected and one of them is share on customer web page Show on customer web page and remove from customer web page option should be displayed', () {
          PermissionService.permissionList = [PermissionConstants.manageShareCustomerWebPage];
          FeatureFlagService.featureFlagList = {FeatureFlagConstant.customerJobFeatures:1};
          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobPhotosActionsList(
              FilesListingQuickActionParams(
                isInSelectionMode: true,
                fileList: [controller.resourceList[2], controller.resourceList[9]],
                onActionComplete: (_, __) { },
                jobModel: JobModel(id: 1, customerId: 1, bidCustomer: 0)
              )
          );

          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.showOnCustomerWebPage), true);
          expect(tempResult.contains(FileListingQuickActionOptions.removeFromCustomerWebPage), true);
          
        });

        test('When multiple file is selected and both of them is share on customer web page Remove from customer web page option should be displayed', () {
          PermissionService.permissionList = [PermissionConstants.manageShareCustomerWebPage];
          FeatureFlagService.featureFlagList = {FeatureFlagConstant.customerJobFeatures:1};
          controller.resourceList[2].isShownOnCustomerWebPage = true;
          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobPhotosActionsList(
              FilesListingQuickActionParams(
                isInSelectionMode: true,
                fileList: [controller.resourceList[2], controller.resourceList[9]],
                onActionComplete: (_, __) { },
                jobModel: JobModel(id: 1, customerId: 1, bidCustomer: 0)
              )
          );

          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.showOnCustomerWebPage), false);
          expect(tempResult.contains(FileListingQuickActionOptions.removeFromCustomerWebPage), true);
          
        });

        test('When multiple file is selected Send via text option should not be displayed', () {
          PermissionService.permissionList = [PermissionConstants.manageShareCustomerWebPage];
          FeatureFlagService.featureFlagList = {FeatureFlagConstant.customerJobFeatures:1};
          controller.resourceList[2].isSelected = true;
          controller.resourceList[9].isSelected = true;
          Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getJobPhotosActionsList(
              FilesListingQuickActionParams(
                isInSelectionMode: true,
                fileList: [controller.resourceList[2], controller.resourceList[9]],
                onActionComplete: (_, __) { },
                jobModel: JobModel(id: 1, customerId: 1, bidCustomer: 0)
              )
          );

          final tempResult = result[FileListingQuickActionsList.fileActions]!;

          expect(tempResult.contains(FileListingQuickActionOptions.sendViaJobProgress), false);
          expect(tempResult.contains(FileListingQuickActionOptions.sendViaText), false);
          
        });
      });
    });
}

