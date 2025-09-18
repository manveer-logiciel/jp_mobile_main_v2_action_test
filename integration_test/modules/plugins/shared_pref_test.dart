import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import '../../core/test_base.dart';
import '../../core/test_description.dart';

class SharedPreferenceTestCase extends TestBase {

  Future<void> savedAndGetLoginModel(WidgetTester widgetTester) async {
    expect(await AuthService.getLoggedInUser(),isA<UserModel>());
  }

  Future<void> runSharedPreferenceTestCase(WidgetTester widgetTester) async {

    testConfig.setTestDescription(TestDescription.sharedPrefGroupDesc, TestDescription.sharedPrefTestDesc);

    await widgetTester.pumpAndSettle();

    await testConfig.successLoginCase(widgetTester);

    await savedAndGetLoginModel(widgetTester);

    await testConfig.fakeDelay(2);
  }

  @override
   void runTest({bool isMock = true}) {
    testConfig.runTestWidget(TestDescription.sharedPrefTestDesc, (widgetTester) async {

      testConfig.setTestDescription(TestDescription.sharedPrefGroupDesc, TestDescription.sharedPrefTestDesc);

      await testConfig.successLoginCase(widgetTester);

      await savedAndGetLoginModel(widgetTester);
    },isMock);
  }
}