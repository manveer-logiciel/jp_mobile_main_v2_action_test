import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../core/test_base.dart';
import '../../core/test_description.dart';

class ConnectivityPlusTestCase extends TestBase {
  @override
  void runTest({bool isMock = true}) {
    testConfig.runTestWidget(TestDescription.connectivityPlusTestDesc, (widgetTester) async {
      await runConnectivityPlusTestCase(widgetTester);
    }, isMock);
  }

  Future<void> runConnectivityPlusTestCase(WidgetTester widgetTester) async {
  testConfig.setTestDescription(
    TestDescription.connectivityPlusGroupDesc,
    TestDescription.connectivityPlusTestDesc,
  );

  List<ConnectivityResult> results = await Connectivity().checkConnectivity();

  // Check that the results contain at least one valid connection type
  expect(results.any((result) => result != ConnectivityResult.none),isTrue,);
}
}