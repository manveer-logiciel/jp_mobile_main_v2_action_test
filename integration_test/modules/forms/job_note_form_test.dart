import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/note_list_tile/index.dart';
import 'package:jobprogress/modules/job_note/add_edit_dialog_box/index.dart';
import 'package:jp_mobile_flutter_ui/FlutterMention/flutter_mentions.dart';
import 'package:jp_mobile_flutter_ui/Thumb/index.dart';
import '../../config/test_config.dart';
import '../../core/test_base.dart';
import '../../core/test_description.dart';
import '../../core/test_helper.dart';


void main() {
  TestConfig.initialSetUpAll();
  JobNoteFormTestCase().runTest();
}

class JobNoteFormTestCase extends TestBase {
  @override
  void runTest({bool isMock = true}) {
    testConfig.runTestWidget(TestDescription.addEditJobNoteFormTestDesc, (widgetTester) async {
      testConfig.setTestDescription(TestDescription.jobNoteFormGroupDesc, TestDescription.correctCredentialLoginTestDesc);
      await testConfig.successLoginCase(widgetTester);
      await runJobNoteFormTestCase(widgetTester);
    }, isMock);
  }

  Future<void> runJobNoteFormTestCase(WidgetTester tester) async {
    if (PhasesVisibility.canShowSecondPhase) {
      testConfig.setTestDescription(
       TestDescription.jobNoteFormGroupDesc,
       TestDescription.addEditJobNoteFormTestDesc,
     );
 
      await tester.pumpAndSettle();
 
      await _goToJobNoteAddForm(tester);
 
      testConfig.setTestDescription(
        TestDescription.jobNoteFormGroupDesc,
        TestDescription.checkValidationOnSaveButtonTestDesc,
      );
      await testConfig.fakeDelay(2);
      TestHelper.tapOnWidget(tester, testConfig, key: WidgetKeys.saveJobNoteBtnKey);
 
      testConfig.setTestDescription(
        TestDescription.jobNoteFormGroupDesc,
        TestDescription.enterAtTheRateSignTestDesc,
      );

      testConfig.setTestDescription(TestDescription.insuranceDetailsGroupDesc, TestDescription.clickToAddJobDrawerItemTestDesc);
      Finder? noteField = find.byType(JPMention);
      await testConfig.fakeDelay(2);
      TestHelper.enterText(tester, testConfig, text: '@mo', finder: noteField);
      await testConfig.fakeDelay(3);
      await tester.pumpAndSettle();
      testConfig.setTestDescription(
        TestDescription.jobNoteFormGroupDesc,
        TestDescription.clickUserTestDesc,
      );
 
      Finder? jpOptionList = find.byType(JPMentionOptionList);
      TestHelper.tapOnWidget(tester, testConfig, tapFinder: jpOptionList.first);
      await testConfig.fakeDelay(2);
      await attachmentSelectFrom('measurements'.tr.capitalizeFirst!, tester);
      await attachmentSelectFrom('materials'.tr.capitalize!, tester);
 
      testConfig.setTestDescription(
        TestDescription.jobNoteFormGroupDesc,
        TestDescription.jobNoteSaveButtonClickDesc,
      );
      await testConfig.fakeDelay(2);
      TestHelper.tapOnWidget(tester, testConfig, key: WidgetKeys.saveJobNoteBtnKey);

      await testConfig.fakeDelay(2);
      await _goToJobNoteEditForm(tester);
  
      testConfig.setTestDescription(
        TestDescription.jobNoteFormGroupDesc,
        TestDescription.enterNewTextInFieldTestDesc,
      );
      await testConfig.fakeDelay(2);
      await TestHelper.enterText(
        tester,
        testConfig,
        text: 'Just Check the edit case',
        finder: find.byType(JPMention),
        isReplaceText: true,
      );

      testConfig.setTestDescription(
        TestDescription.jobNoteFormGroupDesc,
        TestDescription.removeAttachmentTestDesc,
      );
      await testConfig.fakeDelay(2);
      await TestHelper.tapOnWidget(tester, testConfig, key: '${WidgetKeys.attachmentListKey}[0]');
 
      await testConfig.fakeDelay(2);
      await attachmentSelectFrom('materials'.tr.capitalize!, tester);
 
      testConfig.setTestDescription(
        TestDescription.jobNoteFormGroupDesc,
        TestDescription.jobNoteUpdateButtonClickDesc,
      );
      await testConfig.fakeDelay(2);
      await TestHelper.tapOnWidget(tester, testConfig, key: WidgetKeys.saveJobNoteBtnKey);
   }
 }
 
  
  // Test Case for  Navigate to Job Note Add Form 
 Future<void> _goToJobNoteAddForm(WidgetTester widgetTester) async {
  testConfig.setTestDescription(TestDescription.jobNoteFormGroupDesc, TestDescription.openEndDrawerTestDesc);
  await testConfig.fakeDelay(2);
  await TestHelper.openEndDrawer(widgetTester, testConfig);

  testConfig.setTestDescription(TestDescription.jobNoteFormGroupDesc, TestDescription.clickToRecentJobsDrawerItemTestDesc);
  await testConfig.fakeDelay(2);
  await TestHelper.clickRecentJobsDrawerSection(widgetTester, testConfig);

  testConfig.setTestDescription(TestDescription.jobNoteFormGroupDesc, TestDescription.selectFirstJobFromListTestDesc);
  await testConfig.fakeDelay(2);
  await TestHelper.selectFirstJobFromRecentJobsSheet(widgetTester, testConfig);

  testConfig.setTestDescription(TestDescription.jobNoteFormGroupDesc, TestDescription.clickOnAddButton);
  await testConfig.fakeDelay(2);
  await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.addButtonKey);

  testConfig.setTestDescription(TestDescription.jobNoteFormGroupDesc, TestDescription.clickOnJobNotes);
  await testConfig.fakeDelay(2);
  await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.jobNotesCapitalizeKey);
}
 

  // Test Case for  Navigate to Job Note Edit Form
  Future<void> _goToJobNoteEditForm(WidgetTester tester) async {
    testConfig.setTestDescription(TestDescription.jobNoteFormGroupDesc, TestDescription.openEndDrawerTestDesc);
    await testConfig.fakeDelay(2);
    await TestHelper.openSecondaryDrawer(tester, testConfig);
  
    testConfig.setTestDescription(TestDescription.jobNoteFormGroupDesc, TestDescription.clickOnJobNoteTestDesc);
    await testConfig.fakeDelay(2);
    await TestHelper.tapOnWidget(tester, testConfig, key: WidgetKeys.jobNotes);
  
    testConfig.setTestDescription(TestDescription.jobNoteFormGroupDesc, TestDescription.longPressOnJobNoteItemTestDesc);
    await testConfig.fakeDelay(2);
    await TestHelper.longPressOnWidget(tester, testConfig, tapFinder: find.byType(NoteListTile).first);
    
    Finder? editOption = find.text('edit'.tr.capitalize!);
    await testConfig.fakeDelay(2);
    await TestHelper.tapOnWidget(tester, testConfig, tapFinder: editOption);
  }
  

  // Test Case for  Attachment Selection
  Future<void> attachmentSelectFrom(String attachmentTypeText, WidgetTester widgetTester) async {
    // Step 1: Find and tap the "Add" button
    Finder? addButton = find.descendant(of: find.byType(AddEditJobNoteDialogBox), matching: find.byType(SvgPicture));
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: addButton);
  
    // Step 2: Find and tap the specified option
    Finder? option = find.descendant(of: find.byType(JPPopUpBuilder), matching: find.text(attachmentTypeText));
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: option);
  
    await testConfig.fakeDelay(2);
    // Step 4: Select the second file item
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: find.byType(JPThumb).last);
  
    await testConfig.fakeDelay(3);
    // Step 5: Tap the confirmation button
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.flBottomSheetConfirmButtonKey);
  }
  
}