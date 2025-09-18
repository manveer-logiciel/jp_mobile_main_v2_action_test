import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/job_count.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/global_widgets/secondary_drawer/controller.dart';

void main() {

  final tempJob = JobModel(id: 1, customerId: 1);
  final controller = JPSecondaryDrawerController(tempJob);

  group("JPSecondaryDrawerController@slugToType should return correct type", () {
    test("Contracts slug should be converted to correct type", () {
      expect(controller.slugToType( FileUploadType.contracts), FLModule.jobContracts);
    });
  });

  group("JPSecondaryDrawerController@getCount should give count to be displayed in secondary menu", () {
    test("In case job is not available count should be 0", () {
      controller.job = null;
      expect(controller.getCount(FileUploadType.contracts, null), 0);
    });

    test("In case job is available but counts are not available, count should be 0", () {
      controller.job = tempJob;
      expect(controller.getCount(FileUploadType.contracts, tempJob), 0);
    });

    test("In case job is available and counts are available, count should be set", () {
      controller.job = tempJob..count = JobCountModel(contracts: 1);
      expect(controller.getCount(FileUploadType.contracts, tempJob), 1);
    });
  });
}