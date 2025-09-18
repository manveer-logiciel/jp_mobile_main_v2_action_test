import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/details_listing_tile/customer.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import '../../../../config/test_config.dart';
import '../../../../core/enum/url_matcher_mode.dart';
import '../../../../core/test_base.dart';
import '../../../../core/test_description.dart';
import '../../../../core/test_helper.dart';
import '../filter_dialog/index.dart';

void main() {
  TestConfig.initialSetUpAll();
  CustomerListingTestCase().runTest();
}

class CustomerListingTestCase extends TestBase {
  @override
  void runTest({bool isMock = true}) {
    testConfig.runTestWidget(TestDescription.customerListingGroupDesc, (widgetTester) async {
      testConfig.setTestDescription(TestDescription.customerListingGroupDesc, TestDescription.correctCredentialLoginTestDesc);
      await testConfig.successLoginCase(widgetTester);

      await runCustomerListingTestCase(widgetTester);
    }, isMock);
  }

  Future<void> runCustomerListingTestCase(WidgetTester widgetTester) async {
    testConfig.changeUrlMatcher(JPUrlMatcherMode.fullRequestMatch);

    testConfig.setTestDescription(TestDescription.customerListingGroupDesc, TestDescription.goToCustomerListingTestDesc);

    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: find.byKey(testConfig.getKey(WidgetKeys.customerManager)));

    await testConfig.fakeDelay(5);

    await loadMoreTestCase(widgetTester);

    await widgetTester.pumpAndSettle();

    await noLoadMoreTestCase(widgetTester);

    await widgetTester.pumpAndSettle();

    await testConfig.fakeDelay(3);

    await sortTestCases(widgetTester);

    await widgetTester.pumpAndSettle();

    testConfig.setTestDescription(TestDescription.customerListingGroupDesc, TestDescription.pullToRefreshTestDesc);
    await TestHelper.pullToRefresh(widgetTester, testConfig, find.byType(CustomerListTile));

    await widgetTester.pumpAndSettle();

    await FilterDialogTestCase().runFilterTestCase(widgetTester);

    await widgetTester.pumpAndSettle();

    await noDataTestCases(widgetTester);

    await widgetTester.pumpAndSettle();
  }

  Future<void> loadMoreTestCase(WidgetTester widgetTester) async {
    testConfig.setTestDescription(TestDescription.customerListingGroupDesc, TestDescription.loadMoreTestCaseDesc);
    await TestHelper.scrollToLast(widgetTester, testConfig, testConfig.getKey('${WidgetKeys.customerListingKey}[9]'));

    expect(find.byType(FadingCircle), findsOneWidget);
  }

  Future<void> noLoadMoreTestCase(WidgetTester widgetTester) async {
    testConfig.setTestDescription(TestDescription.customerListingGroupDesc, TestDescription.noLoadMoreTestCaseDesc);
    await TestHelper.scrollToLast(widgetTester, testConfig, testConfig.getKey('${WidgetKeys.customerListingKey}[19]'));

    expect(find.byType(FadingCircle), findsNothing);
  }

  Future<void> sortTestCases(WidgetTester widgetTester) async {
    testConfig.setTestDescription(TestDescription.customerListingGroupDesc, TestDescription.customerListingSortOrderTestDesc);
    await testConfig.fakeDelay(2);

    await TestHelper.selectDropDown(widgetTester, testConfig, find.byKey(testConfig.getKey(WidgetKeys.customerListingSortFilterKey)));
    await testConfig.fakeDelay(3);
  }

  Future<void> noDataTestCases(WidgetTester widgetTester) async {
    testConfig.setTestDescription(TestDescription.customerListingGroupDesc, TestDescription.noDataTestDesc);
    await testConfig.fakeDelay(2);

    await TestHelper.selectDropDown(widgetTester, testConfig, find.byKey(testConfig.getKey(WidgetKeys.customerListingSortFilterKey)), index: 2);
    await testConfig.fakeDelay(2);
  }
}