import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/upload_file_options_bottomsheet/controller.dart';
import 'package:jp_mobile_flutter_ui/Button/index.dart';
import '../../core/test_base.dart';
import '../../core/test_description.dart';
import '../../core/test_helper.dart';

class FilePickerTestCase extends TestBase {

  Future<void> pickMultipleFileFromStorage(WidgetTester widgetTester) async {
    Finder uploadBtnFinder = find.byType(JPButton);
    expect(uploadBtnFinder, findsOneWidget);

    await widgetTester.tap(uploadBtnFinder);
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(2);

    final uploadFilePopupController = Get.find<UploadFilePopUpController>();
    await uploadFilePopupController.pickPhotosAndAddToQueue();
    await testConfig.fakeDelay(2);
  }

  Future<void> pickDocFromStorage(WidgetTester widgetTester) async {
    Finder uploadBtnFinder = find.byType(JPButton);
    expect(uploadBtnFinder, findsOneWidget);

    await widgetTester.tap(uploadBtnFinder);
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(2);

    final uploadFilePopupController = Get.find<UploadFilePopUpController>();
    await uploadFilePopupController.pickDocsAndAddToQueue();
    await testConfig.fakeDelay(2);
  }

  Future<void> scanDocument(WidgetTester widgetTester) async {
    Finder uploadBtnFinder = find.byType(JPButton);
    expect(uploadBtnFinder, findsOneWidget);

    await widgetTester.tap(uploadBtnFinder);
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(2);

    final uploadFilePopupController = Get.find<UploadFilePopUpController>();
    String? scanDocument = await uploadFilePopupController.scanDocAndAddToQueue();

    bool isScanDocumentNotNull = scanDocument != null;
    expect(isScanDocumentNotNull, isTrue);

    await testConfig.fakeDelay(2);
  }

  Future<void> runFilePickerTestCase(WidgetTester widgetTester) async {
    await testConfig.fakeDelay(3);

    testConfig.initializeDioAdapter(false);

    testConfig.setTestDescription(TestDescription.filePickerGroupDesc,
        TestDescription.pickImageFileTestDesc);

    Finder menuIconFinder = find.byIcon(Icons.menu_open);
    expect(menuIconFinder, findsOneWidget);

    await widgetTester.tap(menuIconFinder);
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(3);

    Finder photosDocFinder = find.byIcon(Icons.perm_media_outlined);
    expect(photosDocFinder, findsOneWidget);

    await widgetTester.tap(photosDocFinder);
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(3);

    await pickMultipleFileFromStorage(widgetTester);

    testConfig.setTestDescription(TestDescription.filePickerGroupDesc,
        TestDescription.pickDocumentFileTestDesc);

    await pickDocFromStorage(widgetTester);

    testConfig.setTestDescription(TestDescription.filePickerGroupDesc,
        TestDescription.pickScannedDocumentFileTestDesc);

    // await scanDocument(widgetTester);

    testConfig.initializeDioAdapter(true);
  }

  @override
  void runTest({bool isMock = false}) {
    group(TestDescription.filePickerGroupDesc, () {
      testConfig.runTestWidget(TestDescription.pickImageFileTestDesc,(widgetTester) async {

        testConfig.setTestDescription(TestDescription.filePickerGroupDesc,
            TestDescription.pickImageFileTestDesc);

        await redirectToRecentJobs(widgetTester);

        await pickMultipleFileFromStorage(widgetTester);
      },isMock);

      testConfig.runTestWidget(TestDescription.pickDocumentFileTestDesc,(widgetTester) async {

        testConfig.setTestDescription(TestDescription.filePickerGroupDesc,
            TestDescription.pickDocumentFileTestDesc);

        await redirectToRecentJobs(widgetTester);

        await pickDocFromStorage(widgetTester);
      },isMock);

      testConfig.runTestWidget(TestDescription.pickScannedDocumentFileTestDesc,(widgetTester) async {

        testConfig.setTestDescription(TestDescription.filePickerGroupDesc,
            TestDescription.pickScannedDocumentFileTestDesc);

        await redirectToRecentJobs(widgetTester);

     //  await scanDocument(widgetTester);
      },isMock);
    });
  }

  Future<void> redirectToRecentJobs(WidgetTester widgetTester) async {
    await testConfig.successLoginCase(widgetTester);

    Finder menuFinder = find.byIcon(Icons.menu);
    await widgetTester.ensureVisible(menuFinder);
    await widgetTester.pumpAndSettle();

    expect(menuFinder, findsOneWidget);

    await widgetTester.tap(menuFinder);
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(2);

    await TestHelper.clickRecentJobsDrawerSection(widgetTester, testConfig);

    await widgetTester.pumpAndSettle();

    Finder recentJobListViewFinder = find.byKey(testConfig.getKey(WidgetKeys.recentJobs));
    expect(recentJobListViewFinder, findsOneWidget);

    await widgetTester.tap(recentJobListViewFinder.first);
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(3);

    Finder menuIconFinder = find.byIcon(Icons.menu_open);
    expect(menuIconFinder, findsOneWidget);

    await widgetTester.tap(menuIconFinder);
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(3);

    Finder photosDocFinder = find.byIcon(Icons.perm_media_outlined);
    expect(photosDocFinder, findsOneWidget);

    await widgetTester.tap(photosDocFinder);
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(3);
  }
}