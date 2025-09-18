import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/extensions/get_navigation/extension.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/api_gateway/index.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/firebase_core/index.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/common/services/shared_pref.dart';
import 'package:jobprogress/common/services/workflow_stages/workflow_service.dart';
import 'package:jobprogress/core/config/app_env.dart';
import 'package:jobprogress/core/constants/shared_pref_constants.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import '../../config/test_config.dart';
import '../plugins/connectivity_plus_test.dart';
import '../plugins/device_info_plus_test.dart';
import '../plugins/easy_mask_test.dart';
import '../plugins/file_picker_test.dart';
import '../plugins/flutter_inappwebview_test.dart';
import '../plugins/flutter_toast_test.dart';
import '../plugins/flutter_widget_from_html_core_test.dart';
import '../plugins/geolocation_test.dart';
import '../plugins/image_picker_test.dart';
import '../plugins/printing_test.dart';
import '../plugins/shared_pref_test.dart';
import '../plugins/sqflite_test.dart';
import '../plugins/url_launcher_test.dart';

void main() {
    TestConfig testConfig = Get.put(TestConfig());

    testConfig.binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testConfig.binding?.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    runZonedGuarded(() {
      group('Executing test cases for all plugin & packages', () {
        setUpAll(() async {

          Get.testMode = true;

          RunModeService.setRunMode(RunMode.integrationTesting);

          AppEnv.setEnvironment(Environment.dev);

          JPFirebase.setUp();

          SharedPrefService preferences = SharedPrefService();
          final isUserLoggedIn = await preferences.read(PrefConstants.accessToken);

          if(isUserLoggedIn != null) await AuthService.getLoggedInUser();

          ApiProvider.setAuthInterceptor();

          FileHelper.setLocalStoragePath();

          WorkFlowService.setUp();

          ApiGatewayService.setUp();
        });
        testConfig.initializeDioAdapter(true);

        testWidgets('Executing test cases for all plugin & packages', (widgetTester) async {
          await SharedPreferenceTestCase().runSharedPreferenceTestCase(widgetTester);

          await SqfLiteTestCase().runSqfLiteTestCase(widgetTester);

          await GeoLocationTestCase().runGeoLocationTestCase(widgetTester);

          // return back to home page
          Get.back();

          await UrlLauncherTestCase().runUrlLauncherTestCases(widgetTester);

          await DeviceInfoPlusTestCase().runDeviceInfoTestCase(widgetTester);

          await EasyMaskTestCase().runEasyMaskTestCase(widgetTester);

          await PrintingTestCase().runPrintingTestCase(widgetTester);

          await FilePickerTestCase().runFilePickerTestCase(widgetTester);

          // return back to home page
          Get.back();

          await ImagePickerTestCase().runImagePickerTestCase(widgetTester);

          // // return back to home page
          Get.offAllToFirst();

          await FlutterWidgetFromHtmlCoreTestCase().runFlutterWidgetFromHtmlCoreTestCase(widgetTester);

          await FlutterInAppWebViewTestCase().runFlutterInAppWebViewTestCase(widgetTester);
          
          await ConnectivityPlusTestCase().runConnectivityPlusTestCase(widgetTester);

          await FlutterToastTestCase().showToast(widgetTester);
        });

      });
    }, (error, stack) {
      testConfig.binding?.printInfo(info:error.toString());
    });
  }
