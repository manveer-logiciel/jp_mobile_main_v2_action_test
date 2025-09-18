import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/files_listing/create_file_actions.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/services/files_listing/add_more_actions/more_actions_list.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_options.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';

void main() {

  CreateFileActions actionParams = CreateFileActions(
      fileList: [],
      jobModel: JobModel(
        id: 1,
        customerId: 1,
      ),
      onActionComplete: (_, __) {  },
  );

  List<JPQuickActionModel>? getActions(CreateFileActions params) {
    return FileListingMoreActionsList.getAddMoreMeasurementListActions(params)[FileListingMoreActionsList.fileActions];
  }

  group("FileListingMoreActionsList@getAddMoreMeasurementListActions should give create measurement actions", () {
    group("Measurement Form action should be displayed conditionally", () {
      test("Action should not be displayed in case of Multi Project Job", () {
        actionParams.jobModel?.isMultiJob = true;
        final result = getActions(actionParams);
        expect(result?.contains(FileListingQuickActionOptions.measurementForm), isFalse);
      });

      test("Action should not be displayed in case of Normal Job", () {
        actionParams.jobModel?.isMultiJob = false;
        final result = getActions(actionParams);
        expect(result?.contains(FileListingQuickActionOptions.measurementForm), isTrue);
      });

      test("Action should not be displayed in case of Project", () {
        actionParams.jobModel?.isProject = true;
        final result = getActions(actionParams);
        expect(result?.contains(FileListingQuickActionOptions.measurementForm), isTrue);
      });
    });
  });
}