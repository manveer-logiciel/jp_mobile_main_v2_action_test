import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_options.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions_list.dart';

void main() {

  FilesListingModel tempFile = FilesListingModel(
    isShownOnCustomerWebPage: false
  );

  JobModel jobModel = JobModel(
    id: 1,
    customerId: 1,
    bidCustomer: 0
  );

  final params = FilesListingQuickActionParams(
      fileList: [tempFile],
      jobModel: jobModel,
      onActionComplete: (FilesListingModel model, action) {  }
  );

  group("FileListingQuickActionsList@getContractsActionsList should give actions to be displayed on contract files", () {
    test("[Rename] action should be displayed", () {
      final actions = FileListingQuickActionsList.getContractsActionsList(params);
      expect(actions[FileListingQuickActionsList.fileActions]!.contains(FileListingQuickActionOptions.rename), isTrue);
    });

    test("[Delete] action should be displayed", () {
      final actions = FileListingQuickActionsList.getContractsActionsList(params);
      expect(actions[FileListingQuickActionsList.fileActions]!.contains(FileListingQuickActionOptions.delete), isTrue);
    });

    test("[Print] action should be displayed", () {
      final actions = FileListingQuickActionsList.getContractsActionsList(params);
      expect(actions[FileListingQuickActionsList.fileActions]!.contains(FileListingQuickActionOptions.print), isTrue);
    });

    test("[Info] action should be displayed", () {
      final actions = FileListingQuickActionsList.getContractsActionsList(params);
      expect(actions[FileListingQuickActionsList.fileActions]!.contains(FileListingQuickActionOptions.info), isTrue);
    });

    test("[Email] action should be displayed", () {
      final actions = FileListingQuickActionsList.getContractsActionsList(params);
      expect(actions[FileListingQuickActionsList.fileActions]!.contains(FileListingQuickActionOptions.email), isTrue);
    });

    test("[MakeACopy] action should be displayed", () {
      final actions = FileListingQuickActionsList.getContractsActionsList(params);
      expect(actions[FileListingQuickActionsList.fileActions]!.contains(FileListingQuickActionOptions.makeACopy), isTrue);
    });

    test("[ExpiresOn] action should be displayed", () {
      final actions = FileListingQuickActionsList.getContractsActionsList(params);
      expect(actions[FileListingQuickActionsList.fileActions]!.contains(FileListingQuickActionOptions.expiresOn), isTrue);
    });

    test("[SendViaText] action should be displayed", () {
      final actions = FileListingQuickActionsList.getContractsActionsList(params);
      expect(actions[FileListingQuickActionsList.fileActions]!.contains(FileListingQuickActionOptions.sendViaText), isTrue);
    });

    group("[ShowOnCustomerWebPage] should be displayed conditionally", () {
      test("Quick Action should not be displayed, If file is already shared on customer web page", () {
        params.fileList[0].isShownOnCustomerWebPage = true;
        final actions = FileListingQuickActionsList.getContractsActionsList(params);
        expect(actions[FileListingQuickActionsList.fileActions]!.contains(FileListingQuickActionOptions.showOnCustomerWebPage), isFalse);
      });

      test("Quick Action should be displayed, If file is not shared on customer web page", () {
        params.fileList[0].isShownOnCustomerWebPage = false;
        final actions = FileListingQuickActionsList.getContractsActionsList(params);
        expect(actions[FileListingQuickActionsList.fileActions]!.contains(FileListingQuickActionOptions.showOnCustomerWebPage), isTrue);
      });
    });

    group("[RemoveFromCustomerWebPage] should be displayed conditionally", () {
      test("Quick Action should not be displayed, If file is not shared on customer web page", () {
        params.fileList[0].isShownOnCustomerWebPage = false;
        final actions = FileListingQuickActionsList.getContractsActionsList(params);
        expect(actions[FileListingQuickActionsList.fileActions]!.contains(FileListingQuickActionOptions.removeFromCustomerWebPage), isFalse);
      });

      test("Quick Action should be displayed, If file is shared on customer web page", () {
        params.fileList[0].isShownOnCustomerWebPage = true;
        final actions = FileListingQuickActionsList.getContractsActionsList(params);
        expect(actions[FileListingQuickActionsList.fileActions]!.contains(FileListingQuickActionOptions.removeFromCustomerWebPage), isTrue);
      });
    });
  });
}