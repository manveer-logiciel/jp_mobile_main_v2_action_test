import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/delete_dialog/index.dart';
import 'package:jobprogress/modules/appointments/create_appointment/index.dart';
import 'package:jobprogress/modules/calendar/event/page.dart';
import 'package:jobprogress/modules/email/compose/page.dart';
import 'package:jobprogress/modules/job/job_form/index.dart';
import 'package:jobprogress/modules/job/listing/page.dart';
import 'package:jobprogress/modules/job_financial/widgets/job_price_dialog/index.dart';
import 'package:jobprogress/modules/job_note/listing/page.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/Constants/widget_keys.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../config/test_config.dart';
import '../../../../core/test_base.dart';
import '../../../../core/test_description.dart';
import '../../../../core/test_helper.dart';

void main() {
  TestConfig.initialSetUpAll();
  JobListingQuickActionsTestCase().runTest();
}

class JobListingQuickActionsTestCase extends TestBase {
  @override
  void runTest({bool isMock = true}) {
    testConfig.runTestWidget(TestDescription.jobListingTestDesc, (widgetTester) async {
      testConfig.setTestDescription(TestDescription.jobListingTestDesc, TestDescription.correctCredentialLoginTestDesc);
      await testConfig.successLoginCase(widgetTester);
      await runJobListingQuickActionsTestCase(widgetTester);
    }, isMock);
  }

  Future<void> runJobListingQuickActionsTestCase(WidgetTester widgetTester) async {
    ///   Goto job listing
    await _goToJobListing(widgetTester);
    await testConfig.fakeDelay(2);

    ///   Edit Job
    await _openQuickActions(widgetTester);
    await _onTapQuickActions(widgetTester, TestDescription.openJobEditFormTestDesc, 0);
    await testConfig.fakeDelay(2);
    expect(find.byType(JobFormView),findsOneWidget);
    testConfig.setTestDescription(TestDescription.jobListingTestDesc, TestDescription.backToJobListingTestDesc);
    await TestHelper.unsavedChangesMadeTestCase(widgetTester, testConfig, currentPage: JobFormView, previousPage: JobListingView, tapOnDontSave: true);
    await testConfig.fakeDelay(1);

    ///   View
    await _reopenQuickActions(widgetTester);
    await _onTapQuickActions(widgetTester, TestDescription.openJobDetailTestDesc, 1);
    await TestHelper.clickSystemBackButton(widgetTester);
    await testConfig.fakeDelay(1);

    ///   Email
    await _reopenQuickActions(widgetTester);
    await _onTapQuickActions(widgetTester, TestDescription.openEmailComposeViewTestDesc, 2);
    testConfig.setTestDescription(TestDescription.jobListingTestDesc, TestDescription.backToJobListingTestDesc);
    await TestHelper.unsavedChangesMadeTestCase(widgetTester, testConfig, currentPage: EmailComposeView, previousPage: JobListingView, tapOnDontSave: true);
    await testConfig.fakeDelay(1);

    ///   follow-up notes
    await _reopenQuickActions(widgetTester);
    await _onTapQuickActions(widgetTester, TestDescription.openFollowupNotesListTestDesc, 3);
    await TestHelper.clickSystemBackButton(widgetTester);

    ///   Add to progress board
    await _reopenQuickActions(widgetTester);
    await _onTapQuickActions(widgetTester, TestDescription.openAddToProgressBoardTestDesc, 5);
    await TestHelper.selectMultiSelectDropDown(widgetTester, testConfig, find.byKey(testConfig.getKey(WidgetKeys.multiselect)));
    await testConfig.fakeDelay(1);

    ///   Schedule job
    await _reopenQuickActions(widgetTester);
    await _onTapQuickActions(widgetTester, TestDescription.openJobScheduleFormTestDesc, 6);
    expect(find.byType(EventFormView),findsOneWidget);
    await TestHelper.unsavedChangesMadeTestCase(widgetTester, testConfig, currentPage: EventFormView, previousPage: JobListingView, tapOnDontSave: true);
    await testConfig.fakeDelay(1);

    ///   Job notes
    await _reopenQuickActions(widgetTester);
    await _onTapQuickActions(widgetTester, TestDescription.openJobNoteListTestDesc, 7);
    expect(find.byType(JobNoteListingView),findsOneWidget);
    await TestHelper.clickSystemBackButton(widgetTester);
    await testConfig.fakeDelay(1);

    ///   Appointment
    await _reopenQuickActions(widgetTester);
    await _onTapQuickActions(widgetTester, TestDescription.openAppointmentFormTestDesc, 8);
    expect(find.byType(CreateAppointmentFormView),findsOneWidget);
    await TestHelper.clickSystemBackButton(widgetTester);
    await testConfig.fakeDelay(1);

    ///   Job price
    await _reopenQuickActions(widgetTester);
    await _onTapQuickActions(widgetTester, TestDescription.openUpdateJobPriceTestDesc, 9);
    expect(find.byType(JobPriceDialog),findsOneWidget);
    await TestHelper.cancelButtonClick(widgetTester, testConfig);
    await testConfig.fakeDelay(1);

    ///   Archive
    await _reopenQuickActions(widgetTester);
    await _onTapQuickActions(widgetTester, TestDescription.openJobArchiveDialogueTestDesc, 10);
    expect(find.byType(JPConfirmationDialogWithSwitch),findsOneWidget);
    await TestHelper.cancelButtonClick(widgetTester, testConfig, btnText: "no".tr.toUpperCase());
    await testConfig.fakeDelay(1);

    ///   Mark as lost job
    await _reopenQuickActions(widgetTester);
    await _onTapQuickActions(widgetTester, TestDescription.openMarkAsLostJobTestDesc, 11);
    expect(find.byType(JPQuickEditDialog),findsOneWidget);
    await TestHelper.cancelButtonClick(widgetTester, testConfig);
    await testConfig.fakeDelay(1);

    ///   Delete job
    await _reopenQuickActions(widgetTester);
    await _onTapQuickActions(widgetTester, TestDescription.openDeleteJobTestDesc, 12);
    expect(find.byType(DeleteDialogWithPassword),findsOneWidget);
    await TestHelper.cancelButtonClick(widgetTester, testConfig);
    await testConfig.fakeDelay(2);
  }

  Future<void> _goToJobListing(WidgetTester widgetTester) async {
    ///   select workflow stage from home screen
    testConfig.setTestDescription(TestDescription.jobListingTestDesc, TestDescription.clickOnWorkFlowStagesTestDesc);
    await TestHelper.selectFirstWorkflowStageFromHomePage(widgetTester, testConfig);
    await testConfig.fakeDelay(2);
    expect(find.byType(JobListingView),findsOneWidget);
  }

  Future<void> _openQuickActions(WidgetTester widgetTester) async {
    testConfig.setTestDescription(TestDescription.jobListingTestDesc, TestDescription.openJobListingQuickActionsTestDesc);
    await testConfig.fakeDelay(2);
    await TestHelper.longPressOnWidget(widgetTester, testConfig, key: WidgetKeys.jobKey);
    expect(find.byType(JPQuickAction),findsOneWidget);
  }

  Future<void> _reopenQuickActions(WidgetTester widgetTester) async {
    Get.back();
    await testConfig.fakeDelay(1);
    await _goToJobListing(widgetTester);
    await testConfig.fakeDelay(1);
    await _openQuickActions(widgetTester);
  }

  Future<void> _onTapQuickActions(WidgetTester widgetTester, String testDesc, int index) async {
    testConfig.setTestDescription(TestDescription.jobListingTestDesc, testDesc);
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: '${JPWidgetKeys.quickActionsKey}[$index]');
    await testConfig.fakeDelay(2);
  }
}