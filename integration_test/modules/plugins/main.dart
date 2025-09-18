import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
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
import 'connectivity_plus_test.dart';
import 'device_info_plus_test.dart';
import 'easy_mask_test.dart';
import 'file_picker_test.dart';
import 'flutter_inappwebview_test.dart';
import 'flutter_toast_test.dart';
import 'flutter_widget_from_html_core_test.dart';
import 'geolocation_test.dart';
import 'image_picker_test.dart';
import 'login_test.dart';
import 'open_file_test.dart';
import 'printing_test.dart';
import 'scroll_to_index.dart';
import 'shared_pref_test.dart';
import 'sqflite_test.dart';
import 'url_launcher_test.dart';

void main() {
  TestConfig testConfig = Get.put(TestConfig());

  testConfig.binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testConfig.binding?.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  runZonedGuarded(() {
    group('Initializing end-to-end-testing', () {
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

      LoginTestCase().runTest();

      UrlLauncherTestCase().runTest();

      SharedPreferenceTestCase().runTest();

      FlutterToastTestCase().runTest();

      /// path_provider test cases covered in open_file test cases.
      OpenFileTestCase().runTest(isMock: false);

      PrintingTestCase().runTest(isMock: false);

      ImagePickerTestCase().runTest();

      /// flutter_image_compress test cases covered in file_picker test cases.
      /// sqflite test cases covered in file picker test cases as well.
      FilePickerTestCase().runTest(isMock: false);

      DeviceInfoPlusTestCase().runTest();

      FlutterWidgetFromHtmlCoreTestCase().runTest();

      FlutterInAppWebViewTestCase().runTest();

      EasyMaskTestCase().runTest();

      ScrollToIndexTestCase().runTest();

      GeoLocationTestCase().runTest();

      SqfLiteTestCase().runTest();

      ConnectivityPlusTestCase().runTest();
    });
  }, (error, stack) {
    testConfig.binding?.printInfo(info:error.toString());
  });
}