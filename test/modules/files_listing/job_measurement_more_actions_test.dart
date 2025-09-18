import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/create_file_actions.dart';
import 'package:jobprogress/common/models/files_listing/hover/job.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/subscriber/hover_client.dart';
import 'package:jobprogress/common/models/subscriber/subscriber_details.dart';
import 'package:jobprogress/common/services/files_listing/add_more_actions/more_actions_list.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_options.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';

void main() {
  final JobModel job = JobModel(id: 0, customerId: 0, isMultiJob: true,
    hoverJob: HoverJob(ownerId: 1, state: 'lead'),
  );

  final SubscriberDetailsModel subscriberDetails = SubscriberDetailsModel(id: 0, hoverClient: HoverClient(ownerId: 0));

  group('FileListingMoreActionsList@getAddMoreMeasurementListActions Should manage list of quick actions', () {
    test('Should show the measurement form option when the job is available and is a multi job', () {
      final Map<String, List<JPQuickActionModel>> results = FileListingMoreActionsList.getActions(
        CreateFileActions(
          fileList: [],
          jobModel: job,
          subscriberDetails: subscriberDetails,
          type: FLModule.measurements,
          onActionComplete: (_, __) {},
        ),
      );

      final List<JPQuickActionModel> tempResult = results[FileListingMoreActionsList.fileActions]!;
      expect(tempResult.contains(FileListingQuickActionOptions.measurementForm), isFalse);
    });
    test('Should hide the measurement form option when the job is available and is not a multi job', () {
      final Map<String, List<JPQuickActionModel>> results = FileListingMoreActionsList.getActions(
        CreateFileActions(
          fileList: [],
          jobModel: job..isMultiJob = false,
          subscriberDetails: subscriberDetails,
          type: FLModule.measurements,
          onActionComplete: (_, __) {},
        ),
      );

      final List<JPQuickActionModel> tempResult = results[FileListingMoreActionsList.fileActions]!;
      expect(tempResult.contains(FileListingQuickActionOptions.measurementForm), isTrue);
    });


    test('Should hide the measurement form option when the job is not available', () {
      Map<String, List<JPQuickActionModel>> results = FileListingMoreActionsList.getActions(
        CreateFileActions(
          fileList: [],
          jobModel: null,
          type: FLModule.measurements,
          onActionComplete: (_, __) {},
        ),
      );

      final tempResult = results[FileListingMoreActionsList.fileActions]!;

      expect(tempResult.contains(FileListingQuickActionOptions.measurementForm), isTrue);
      expect(tempResult.contains(FileListingQuickActionOptions.hover), isFalse);
    });
  });
}