import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../core/test_base.dart';
import '../../core/test_description.dart';

class GeoLocationTestCase extends TestBase {

  Future<void> geoLocationTestCase(WidgetTester widgetTester) async {
    Finder menuFinder = find.byIcon(Icons.menu);
    await widgetTester.ensureVisible(menuFinder);
    await widgetTester.pumpAndSettle();

    expect(menuFinder, findsOneWidget);

    await widgetTester.tap(menuFinder);
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(2);

    final clockInFinder = find.byIcon(Icons.timer_outlined);
    expect(clockInFinder, findsOneWidget);

    await widgetTester.ensureVisible(clockInFinder);
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(clockInFinder);
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(3);
  }

  Future<void> runGeoLocationTestCase(WidgetTester widgetTester) async {

    testConfig.setTestDescription(TestDescription.geoLocationGroupDesc, TestDescription.geoLocationTestDesc);

    await testConfig.fakeDelay(2);

    await geoLocationTestCase(widgetTester);
  }
  @override
  void runTest({bool isMock = true}) {

    testConfig.runTestWidget(TestDescription.geoLocationTestDesc,(widgetTester) async {

      testConfig.setTestDescription(TestDescription.geoLocationGroupDesc, TestDescription.geoLocationTestDesc);

      await testConfig.successLoginCase(widgetTester);

      await geoLocationTestCase(widgetTester);
    },isMock);
  }
}