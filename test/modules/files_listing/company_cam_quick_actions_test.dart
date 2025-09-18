
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_options.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions_list.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'file_listing_test.dart';

void main() {

  group('For company cam', (){

    final controller = FilesListingController();
    controller.resourceList = tempResourceList;



    group('In case of file', () {

     

      test('When file single images are selected common options should be displayed', () {

        Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getCompanyCamActionsList(
            FilesListingQuickActionParams(
              isInSelectionMode: true,
              fileList: [controller.resourceList[3], controller.resourceList[2]],
              onActionComplete: (_, __) { },
            )
        );

        final tempResult = result[FileListingQuickActionsList.fileActions]!;

        expect(tempResult.contains(FileListingQuickActionOptions.print), false);
        expect(tempResult.contains(FileListingQuickActionOptions.copyToJob), true);
        expect(tempResult.contains(FileListingQuickActionOptions.view), false);
        expect(tempResult.contains(FileListingQuickActionOptions.sendViaText), false);

      });

            test('When file sing images are selected common options should be displayed', () {

        Map<String, List<JPQuickActionModel>> result = FileListingQuickActionsList.getCompanyCamActionsList(
            FilesListingQuickActionParams(
              isInSelectionMode: true,
              fileList: [controller.resourceList[3]],
              onActionComplete: (_, __) { },
            )
        );

        final tempResult = result[FileListingQuickActionsList.fileActions]!;

        expect(tempResult.contains(FileListingQuickActionOptions.print), false);
        expect(tempResult.contains(FileListingQuickActionOptions.copyToJob), true);
        expect(tempResult.contains(FileListingQuickActionOptions.view), false);
        expect(tempResult.contains(FileListingQuickActionOptions.sendViaText), false);

      });
    });

  });

}