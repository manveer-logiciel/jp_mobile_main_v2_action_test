import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/active_login_session_model.dart';
import 'package:jobprogress/core/constants/platform_constants.dart';
// import 'package:jobprogress/core/constants/quick_login_user_details.dart';
import 'package:jobprogress/modules/login/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final controller = LoginController();
  final List<JPMultiSelectModel> sessions = [
    JPMultiSelectModel(id: '1', isSelect: false, label: 'Session 1'),
    JPMultiSelectModel(id: '2', isSelect: false, label: 'Session 2'),
  ];

  group('LoginController@validateEmail function Cases', () {
    String? value;
    test('Should return blank string, In Case of User enter a valid E-mail address', () {
      value = controller.validateEmail('Test@test.com');
      expect(value, '');
    });

    test('Should return please_enter_email, In Case of User Do not enter any value', () {
      value = controller.validateEmail('');
      expect(value, 'please_enter_email');
    });

    test('Should return please_enter_valid_email, In Case User enter a value without using @gmail.com', () {
      value = controller.validateEmail('test1234');
      expect(value, 'please_enter_valid_email');
    });

    test('Should return please_enter_valid_email, In Case User forget to use .com',() {
      value = controller.validateEmail('test1234@test');
      expect(value, 'please_enter_valid_email');
    });

    test('Should return please_enter_valid_email, In Case User do not use @gmail', () {
      value = controller.validateEmail('@test.com');
      expect(value, 'please_enter_valid_email');
    });

    test('Should return please_enter_valid_email, In Case User do not use @ Sign', () {
      value = controller.validateEmail('test@.com');
      expect(value, 'please_enter_valid_email');
    });

    test('Should return please_enter_valid_email, In case User Trying to Enter only Spaces', () {
      value = controller.validateEmail('   ');
      expect(value, 'please_enter_valid_email');
    });

    test('Should return please_enter_valid_email, In case User Trying to Use Spaces Between email', () {
      value = controller.validateEmail('test @gmail .com');
      expect(value, 'please_enter_valid_email');
    });

    test('Should return please_enter_valid_email, In case User trying to enter multiple E-mail address', () {
      value = controller.validateEmail('test1@gmail.com test2@gmail.com');
      expect(value, 'please_enter_valid_email');
    });
  });

  group('LoginController@validatePassword Function Cases', () {
    test('Should return please_enter_password, In Case of User not enter any Value', () {
      String? value = controller.validatePassword('');
      expect(value, 'please_enter_password');
    });

    test('Should return blank string,In case User of User enter a Value ', () {
      String? value = controller.validatePassword('test123');
      expect(value, '');
    });
  });

  group('LoginController@toggleIsLoading Function Cases', () {
    controller.toggleIsLoading();
    test('Should  change isLoading false into true ,On call of  toggleIsLoading Function', () {
      expect(controller.isLoading, true);
    });

    test('Should  change isLoading true into false,On again call of toggleIsLoading Function', () {
      controller.toggleIsLoading();
      expect(controller.isLoading, false);
    });
  });

  group('LoginController@togglePasswordVisibilty Function Cases', () {
    controller.togglePasswordVisibilty();
    test('Should change isPasswordVisbile false into true, On call of togglePasswordVisibilty Function', () {
      expect(controller.isPasswordVisbile, true);
    });

    test('Should change isPasswordVisbile true into false, On again call of togglePasswordVisibilty Function',() {
      controller.togglePasswordVisibilty();
      expect(controller.isPasswordVisbile, false);
    });
  });
  
  group('LoginController@getDeviceIcon should get device icon', () {

    testWidgets('When platform is Android', (widgetTester) async {
      final Widget icon = controller.getDeviceIcon(PlatformConstants.android);
      await widgetTester.pumpWidget(getIcon(icon));
      final iconFinder = find.byType(Icon);
      final Icon iconWidget = widgetTester.widget(iconFinder);
      expect(iconWidget.icon, Icons.phone_android_outlined);
    });

    testWidgets('When platform is IOS', (widgetTester) async {
      final Widget icon = controller.getDeviceIcon(PlatformConstants.ios);
      await widgetTester.pumpWidget(getIcon(icon));
      final iconFinder = find.byType(Icon);
      final Icon iconWidget = widgetTester.widget(iconFinder);
      expect(iconWidget.icon, Icons.phone_iphone_outlined);
    });

    testWidgets('When platform neither Android nor be IOS', (widgetTester) async {
      final Widget icon = controller.getDeviceIcon('other');
      await widgetTester.pumpWidget(getIcon(icon));
      final iconFinder = find.byType(Icon);
      final Icon iconWidget = widgetTester.widget(iconFinder);
      expect(iconWidget.icon, Icons.computer_outlined);
    });
  });

  group('LoginController@setSessionSelection should set all session', () {
    test('When selection is true', () {
      sessions[0].isSelect = true;
      sessions[1].isSelect = true;
      controller.setSessionSelection(true, sessions);
      expect(sessions.every((s) => s.isSelect), isTrue);
    });

    test('When selection is false', () {
      sessions[0].isSelect = false;
      sessions[1].isSelect = false;
      controller.setSessionSelection(false, sessions);
      expect(sessions.every((s) => !s.isSelect), isTrue);
    });
  });

  group('LoginController@getSessionIds should get session ids', () {
    test('When no sessions are selected', () {
      sessions[0].isSelect = false;
      sessions[1].isSelect = false;
      expect(controller.getSessionIds(sessions), isEmpty);
    });

    test('When one session is selected', () {
      sessions[0].isSelect = true;
      sessions[1].isSelect = false;
      expect(controller.getSessionIds(sessions), [1]);
    });

    test('When multiple sessions are selected', () {
      sessions[0].isSelect = true;
      sessions[1].isSelect = true;
      expect(controller.getSessionIds(sessions), [1, 2]);
    });
  });

  group('LoginController@getActiveUserSessionList should get session list', () {
    test('When given list is empty', () {
      final result = controller.getActiveUserSessionList([]);
      expect(result, isEmpty);
    });

    test('When one session is available', () {
      final session = ActiveLoginSessionModel(
        id: 1,
        platform: 'Android',
        os: 'Android',
        lastActivityAt: '2024-06-01T12:00:00Z',
        userId: 42,
      );
      final result = controller.getActiveUserSessionList([session]);
      expect(result.length, 1);
      expect(result.first.id, '1');
      expect(result.first.label, 'Android on Android');
      expect(result.first.isSelect, false);
      expect(result.first.additionData, '42');
    });

    test('When session highlighted for Android/ios', () {
      final androidSession = ActiveLoginSessionModel(id: 1, platform: 'Android', os: 'Android');
      final iosSession = ActiveLoginSessionModel(id: 2, platform: 'iOS', os: 'iOS');
      final webSession = ActiveLoginSessionModel(id: 3, platform: 'Web', os: 'Web');
      final result = controller.getActiveUserSessionList([androidSession, iosSession, webSession]);
      expect(result[0].isHighlighted, true);
      expect(result[1].isHighlighted, true);
      expect(result[2].isHighlighted, false);
    });
  });
}

Widget getIcon(Widget icon) => Directionality(textDirection: TextDirection.ltr, child: icon);
