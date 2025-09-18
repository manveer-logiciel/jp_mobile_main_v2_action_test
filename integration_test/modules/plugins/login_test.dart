import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/core/constants/server_code.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/modules/login/page.dart';
import 'package:jp_mobile_flutter_ui/Button/index.dart';
import '../../core/test_base.dart';
import '../../core/test_description.dart';
import '../../mock_responses/login_mock_response.dart';

class LoginTestCase extends TestBase {

  Future<void> runLoginTestCase(WidgetTester widgetTester) async {
    testConfig.setTestDescription(TestDescription.loginGroupDesc,
        TestDescription.correctCredentialLoginTestDesc);

    await correctCredential(widgetTester);

    await testConfig.fakeDelay(3);
  }

  Future<void> withoutEmail(WidgetTester widgetTester) async {
    Finder? passwordField = find.byKey(testConfig.getKey(WidgetKeys.passwordKey));
    expect(passwordField, isNotNull);

    await widgetTester.enterText(passwordField, testConfig.password);

    testConfig.binding?.testTextInput.onCleared?.call();
    await testConfig.fakeDelay(1);

    Finder? signInButton = find.byType(JPButton);
    await widgetTester.ensureVisible(find.byType(JPButton));
    await widgetTester.pumpAndSettle();
    expect(signInButton, isNotNull);

    await widgetTester.tap(signInButton);

    await testConfig.fakeDelay(3);
    expect(find.text(testConfig.password), findsOneWidget);

    await widgetTester.idle();
  }

  Future<void> withoutPassword(WidgetTester widgetTester) async {
     Finder? emailField = find.byKey(testConfig.getKey(WidgetKeys.emailKey));
    expect(emailField, findsOneWidget);

    await widgetTester.enterText(emailField, testConfig.correctEmail);
    await testConfig.fakeDelay(1);

    testConfig.binding?.testTextInput.onCleared?.call();

    await testConfig.fakeDelay(1);

    Finder? signInButton = find.byType(JPButton);
    await widgetTester.ensureVisible(find.byType(JPButton));
    await widgetTester.pumpAndSettle();
    expect(signInButton, isNotNull);

    await widgetTester.tap(signInButton);
    await testConfig.fakeDelay(3);
    expect(find.text(testConfig.correctEmail), findsOneWidget);

    await widgetTester.idle();
  }

  Future<void> withoutCredential(WidgetTester widgetTester) async {
    Finder? signInButton = find.byType(JPButton);
    await widgetTester.ensureVisible(find.byType(JPButton));
    await widgetTester.pumpAndSettle();
    expect(signInButton, isNotNull);

    await widgetTester.tap(signInButton);
    await testConfig.fakeDelay(3);
    expect(find.byType(LoginView), findsOneWidget);

    await widgetTester.idle();
  }

  Future<void> inCorrectCredential(WidgetTester widgetTester) async {
    Finder? emailField = find.byKey(testConfig.getKey(WidgetKeys.emailKey));
    expect(emailField, isNotNull);

    await widgetTester.enterText(emailField, testConfig.incorrectEmail);
    await testConfig.fakeDelay(1);

    Finder? passwordField = find.byKey(testConfig.getKey(WidgetKeys.passwordKey));
    expect(passwordField, isNotNull);

    await widgetTester.enterText(passwordField, testConfig.password);
    await testConfig.fakeDelay(1);

    testConfig.binding?.testTextInput.onCleared?.call();
    await testConfig.fakeDelay(1);

    Finder? signInButton = find.byType(JPButton);
    await widgetTester.ensureVisible(find.byType(JPButton));
    await widgetTester.pumpAndSettle();
    expect(signInButton, isNotNull);

    testConfig.dioAdapter?.onPost(Urls.login, (server) =>
        server.reply(ServerCode.preconditionFailed,
            LoginMockResponse.incorrectCredentialResponse));

    await widgetTester.tap(signInButton);
    await widgetTester.pumpAndSettle();

    await testConfig.fakeDelay(3);
    expect(find.byType(LoginView), findsOneWidget);

    testConfig.dioAdapter?.reset();
  }

  Future<void> correctCredential(WidgetTester widgetTester) async {
    await testConfig.successLoginCase(widgetTester);
  }

  @override
  void runTest({bool isMock = true}) {
    group(TestDescription.loginGroupDesc, () {
      testConfig.runTestWidget(TestDescription.withoutEmailLoginTestDesc, (widgetTester) async {

        testConfig.setTestDescription(TestDescription.loginGroupDesc,
            TestDescription.withoutEmailLoginTestDesc);

        await widgetTester.pumpWidget(testConfig.createWidgetUnderTest());

        await withoutEmail(widgetTester);
      },isMock);

      testConfig.runTestWidget(TestDescription.withoutPasswordLoginTestDesc, (widgetTester) async {

        testConfig.setTestDescription(TestDescription.loginGroupDesc,
            TestDescription.withoutPasswordLoginTestDesc);

        await widgetTester.pumpWidget(testConfig.createWidgetUnderTest());

        await withoutPassword(widgetTester);
      },isMock);

      testConfig.runTestWidget(TestDescription.withoutCredentialLoginTestDesc, (widgetTester) async {

        testConfig.setTestDescription(TestDescription.loginGroupDesc,
            TestDescription.withoutCredentialLoginTestDesc);

        await widgetTester.pumpWidget(testConfig.createWidgetUnderTest());

        await withoutCredential(widgetTester);
      },isMock);

      testConfig.runTestWidget(TestDescription.incorrectCredentialLoginTestDesc, (widgetTester) async {

        testConfig.setTestDescription(TestDescription.loginGroupDesc,
            TestDescription.incorrectCredentialLoginTestDesc);

        await widgetTester.pumpWidget(testConfig.createWidgetUnderTest());

        await inCorrectCredential(widgetTester);
      },isMock);

      testConfig.runTestWidget(TestDescription.correctCredentialLoginTestDesc, (widgetTester) async {

        testConfig.setTestDescription(TestDescription.loginGroupDesc,
            TestDescription.correctCredentialLoginTestDesc);

        await correctCredential(widgetTester);
      },isMock);
    });
  }
}