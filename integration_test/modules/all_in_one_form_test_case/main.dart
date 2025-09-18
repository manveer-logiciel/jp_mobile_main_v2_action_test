import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/services/api_gateway/index.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/common/services/workflow_stages/workflow_service.dart';

import '../../config/test_config.dart';
import '../../core/test_description.dart';
import '../forms/company_contact_test.dart';
import '../../core/test_helper.dart';
import '../forms/customer_form_test.dart';
import '../forms/insurance_details_test.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/firebase_core/index.dart';
import 'package:jobprogress/common/services/shared_pref.dart';
import 'package:jobprogress/core/config/app_env.dart';
import 'package:jobprogress/core/constants/shared_pref_constants.dart';
import 'package:jobprogress/core/utils/file_helper.dart';

import '../forms/measurement_form.dart';

void main() {
  TestConfig testConfig = Get.put(TestConfig());

  testConfig.binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testConfig.binding?.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  runZonedGuarded(() {
    group('Initializing end-to-end form testing', () {
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

      testConfig.runTestWidget('All form test cases should be covered', (widgetTester) async {
        testConfig.setTestDescription(TestDescription.loginGroupDesc, TestDescription.correctCredentialLoginTestDesc);

        await testConfig.successLoginCase(widgetTester);

        await InsuranceDetailsTestCase().runInsuranceDetailsTestCase(widgetTester);

        await TestHelper.backToHomePage(widgetTester, testConfig);

        await CompanyContactTestCase().runCompanyContactTestCase(widgetTester);
        
        await TestHelper.backToHomePage(widgetTester, testConfig);

        await MeasurementFormTestCase().runMeasurementFormTestCase(widgetTester);

        await TestHelper.backToHomePage(widgetTester, testConfig);

        await CustomerFormTestCase().runCustomerFormTestCase(widgetTester);
        
      }, true);
      
    });
  }, (error, stack) {
    testConfig.binding?.printInfo(info:error.toString());
  });
}