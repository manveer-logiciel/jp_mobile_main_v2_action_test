import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/job_count.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/global_widgets/secondary_drawer/index.dart';
import 'package:jobprogress/modules/job/job_summary/secondary_drawer/job_drawer_item_lists.dart';
import '../../../integration_test/core/test_helper.dart';

void main() {

  JobModel tempJob = JobModel(id: 1, customerId: 1);

  Widget buildWidget() {
    return TestHelper.buildWidget(
        JPSecondaryDrawer(
          title: 'Test Drawer',
          job: tempJob,
          itemList: JobDrawerItemLists().jobSummaryItemList,
          selectedItemSlug: '',
      )
    );
  }

  group("Estimates Folders should be displayed conditionally in drawer", () {
    group("Estimates Folders should be displayed", () {
      testWidgets("When LD Flag [${LDFlagKeyConstants.salesProForEstimate}] is not enabled or disabled", (widgetTester) async {
        LDFlags.salesProForEstimate.value = false;
        PermissionService.permissionList.add(PermissionConstants.manageEstimates);
        await widgetTester.pumpWidget(buildWidget());
        expect(find.byType(JPSecondaryDrawer), findsOneWidget);
        expect(find.byKey(const Key(FileUploadType.estimations)), findsOneWidget);
      });

      testWidgets("When LD Flag [${LDFlagKeyConstants.salesProForEstimate}] is enabled and estimate exists", (widgetTester) async {
        LDFlags.salesProForEstimate.value = true;
        tempJob.count = JobCountModel(
            estimates: 10
        );
        await widgetTester.pumpWidget(buildWidget());
        expect(find.byType(JPSecondaryDrawer), findsOneWidget);
        expect(find.byKey(const Key(FileUploadType.estimations)), findsOneWidget);
      });
    });

    group("Estimates Folders should not be displayed", () {
      testWidgets("When LD Flag [${LDFlagKeyConstants.salesProForEstimate}] is enabled", (widgetTester) async {
        LDFlags.salesProForEstimate.value = true;
        tempJob.count = null;
        await widgetTester.pumpWidget(buildWidget());
        expect(find.byType(JPSecondaryDrawer), findsOneWidget);
        expect(find.byKey(const Key(FileUploadType.estimations)), findsNothing);
      });

      testWidgets("When LD Flag [${LDFlagKeyConstants.salesProForEstimate}] is enabled and no estimate exists", (widgetTester) async {
        LDFlags.salesProForEstimate.value = true;
        tempJob.count = JobCountModel(
          estimates: 0
        );
        await widgetTester.pumpWidget(buildWidget());
        expect(find.byType(JPSecondaryDrawer), findsOneWidget);
        expect(find.byKey(const Key(FileUploadType.estimations)), findsNothing);
      });
    });
  });
}