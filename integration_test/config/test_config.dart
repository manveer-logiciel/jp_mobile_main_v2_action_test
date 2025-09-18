import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/api_gateway/index.dart';
import 'package:jobprogress/common/services/firebase_core/index.dart';
import 'package:jobprogress/common/services/workflow_stages/workflow_service.dart';
import 'package:jobprogress/core/config/app_env.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/server_code.dart';
import 'package:jobprogress/core/constants/shared_pref_constants.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/modules/home/page.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jobprogress/translations/index.dart';
import 'package:jp_mobile_flutter_ui/Button/index.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/Constants/screen.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/font_weight.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_size.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import '../core/enum/url_matcher_mode.dart';
import '../core/url_matcher.dart';
import '../mock_responses/appointment_count_mock_response.dart';
import '../mock_responses/common/mock_duration.dart';
import '../mock_responses/company_contact_list_mock_response.dart';
import '../mock_responses/company_google_account_mock_response.dart';
import '../mock_responses/add_to_progress_board_mock_response.dart';
import '../mock_responses/company_list_mock_response.dart';
import '../mock_responses/company_settings_mock_response.dart';
import '../mock_responses/company_states_mock_response.dart';
import '../mock_responses/company_trades_mock_response.dart';
import '../mock_responses/connected_third_party_mock_response.dart';
import '../mock_responses/countries_mock_response.dart';
import '../mock_responses/create_company_contact_mock_response.dart';
import '../mock_responses/custom_fields_mock_response.dart';
import '../mock_responses/customer_form_mock_response.dart';
import '../mock_responses/customer_listing_mock_response.dart';
import '../mock_responses/customer_meta_data_mock_response.dart';
import '../mock_responses/customers_mock_response.dart';
import '../mock_responses/daily_plan_count_mock_response.dart';
import '../mock_responses/device_mock_response.dart';
import '../mock_responses/division_mock_response.dart';
import '../mock_responses/drip_campaigns_mock_response.dart';
import '../mock_responses/edit_measurement_form_mock_response.dart';
import '../mock_responses/edit_measurement_success_mock_response.dart';
import '../mock_responses/email_template_mock_response.dart';
import '../mock_responses/estimate_mock_response.dart';
import '../mock_responses/feature_flag_mock_response.dart';
import '../mock_responses/flags_mock_response.dart';
import '../mock_responses/followup_notes_mock_response.dart';
import '../mock_responses/generate_serial_number_mock_response.dart';
import '../mock_responses/job_awarded_stage_mock_response.dart';
import '../mock_responses/job_listing_meta_data_mock_response.dart';
import '../mock_responses/job_listing_mock_response.dart';
import '../mock_responses/job_mock_response.dart';
import '../mock_responses/job_note_listing_mock_response.dart';
import '../mock_responses/job_types_mock_response.dart';
import '../mock_responses/jp_cookie_response.dart';
import '../mock_responses/last_entity_update_mock_response.dart';
import '../mock_responses/latest_update_mock_response.dart';
import '../mock_responses/login_mock_response.dart';
import '../mock_responses/material_lisitng_mock_response.dart';
import '../mock_responses/measurement_form_mock_response.dart';
import '../mock_responses/measurement_lisitng_mock_response.dart';
import '../mock_responses/notification_list_mock_response.dart';
import '../mock_responses/permissions_mock_response.dart';
import '../mock_responses/place_autocomplete_mock_response.dart';
import '../mock_responses/place_detail_mock_response.dart';
import '../mock_responses/progress_boards_mock_response.dart';
import '../mock_responses/proposals_mock_response.dart';
import '../mock_responses/recent_viewed_mock_response.dart';
import '../mock_responses/referrals_mock_response.dart';
import '../mock_responses/resources_recent_mock_response.dart';
import '../mock_responses/set_cookies_mock_response.dart';
import '../mock_responses/states_mock_response.dart';
import '../mock_responses/sub_contractors_mock_response.dart';
import '../mock_responses/subscriber_details_mock_response.dart';
import '../mock_responses/tags_mock_response.dart';
import '../mock_responses/update_job_note_mock_response.dart';
import '../mock_responses/task_listing_mock_response.dart';
import '../mock_responses/user_company_mock_response.dart';
import '../mock_responses/work_flow_stages_mock_response.dart';

class TestConfig{
   IntegrationTestWidgetsFlutterBinding? binding;
   
   DioAdapter? dioAdapter;
   JPHttpUrlMatcher urlMatcher = JPHttpUrlMatcher();
   
   /// Incorrect Credential
   String incorrectEmail = "zaid1@logiciel.io";

   /// Correct Credential
   String correctEmail = "zaid@logiciel.io";
   
   String password = "owner123";

   Rx<String> testDescription = ''.obs;

   Rx<String> groupTestDescription = ''.obs;

   static void initialSetUpAll({Future<void> Function()? onSetUpAll}) {
    TestConfig testConfig = Get.put(TestConfig());
    testConfig.binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testConfig.binding?.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
    setUpAll(() async {
      Get.testMode = true;
      AppEnv.setEnvironment(Environment.dev);
      JPFirebase.setUp();
      ApiProvider.setAuthInterceptor();
      FileHelper.setLocalStoragePath();
      WorkFlowService.setUp();
      ApiGatewayService.setUp();
      await onSetUpAll?.call();
    });
   }

   void runTestWidget(String desc,Function(WidgetTester) callback,bool isMock) {
    testWidgets(desc, (widgetTester) async {
      initializeDioAdapter(isMock);
      
      await callback.call(widgetTester);
    });
    }

  void initializeDioAdapter(bool isMock) {
    if(isMock) {

      dioAdapter ??= DioAdapter(dio: dio,matcher: urlMatcher);
      createApiMockResponses();
    } else {
      destroyDioAdapter();
    }
  }

   void destroyDioAdapter() {
      dioAdapter = null;
      dio.httpClientAdapter = IOHttpClientAdapter();
    }

   Widget createWidgetUnderTest() {
     if(JPScreen.isMobile) {
       SystemChrome.setPreferredOrientations([
         DeviceOrientation.portraitUp,
         DeviceOrientation.portraitDown,
       ]);
     } else {
       SystemChrome.setPreferredOrientations([
         DeviceOrientation.portraitUp,
         DeviceOrientation.portraitDown,
         DeviceOrientation.landscapeLeft,
         DeviceOrientation.landscapeRight,
       ]);
     }

    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Leap',
        defaultTransition: Transition.rightToLeft,
        translations: JPTranslations(),
        locale: const Locale('en', 'US'),
        getPages: AppPages.pages,
        initialRoute: Routes.login,
        builder: (context,widget) => JPSafeArea(
          bottom: false,
          child: Stack(
            children: [
            Positioned.fill(child: widget ?? const SizedBox.shrink()),

            Align(
              alignment: Alignment.topLeft,
              child: IgnorePointer(
                child: Material(
                  color: Colors.black.withValues(alpha: 0.6),
                  child: Container(
                      padding: const EdgeInsets.all(10.0),
                      width: double.infinity,
                       child: Obx(() => Column(
                         mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            JPText(text: groupTestDescription.value,
                                textColor: JPAppTheme.themeColors.yellow,
                                textSize: JPTextSize.heading4,
                                fontWeight: JPFontWeight.medium,
                                textAlign: TextAlign.start),

                            const  SizedBox(height: 5,),

                            JPText(text: testDescription.value,
                                textColor: JPAppTheme.themeColors.base,
                                textSize: JPTextSize.heading5,
                                textAlign: TextAlign.start
                            )
                          ]))
                  )),
              ),)
          ],),
        ),
    );
    }

   Key getKey(String key) => Key(key);

   Future<void> fakeDelay(int sec) async => await Future.delayed(Duration(seconds: sec));

   Future<void> successLoginCase(WidgetTester widgetTester, {String? validEmail, String? validPassword}) async {
     await widgetTester.pumpWidget(createWidgetUnderTest());

     Finder? emailField = find.byKey(getKey(WidgetKeys.emailKey));
     expect(emailField, isNotNull);

     await widgetTester.enterText(emailField, validEmail ?? correctEmail);
     await fakeDelay(1);

     Finder? passwordField = find.byKey(getKey(WidgetKeys.passwordKey));
     expect(passwordField, isNotNull);

     await widgetTester.enterText(passwordField, validPassword ?? password);
     await fakeDelay(1);

     binding?.testTextInput.onCleared?.call();
     await fakeDelay(1);

     Finder? signInButton = find.byType(JPButton);

     await widgetTester.ensureVisible(find.byType(JPButton));
     await widgetTester.pumpAndSettle();
     await fakeDelay(1);
     expect(signInButton, isNotNull);


     await widgetTester.tap(signInButton);
     await widgetTester.pumpAndSettle();
     await fakeDelay(3);

     expect(find.byType(HomeView),findsOneWidget);
     await fakeDelay(2);
   }

   Future<void> createApiMockResponses() async {
     dioAdapter?.onGet(AppEnv.config[CommonConstants.apiGatewayUrl],
         (server) => server.reply(ServerCode.ok,
             <String, dynamic>{},
             delay: MockDuration.value
         ));

     dioAdapter?.onPost(Urls.login,
             (server) => server.reply(ServerCode.accepted,
                 LoginMockResponse.successResponse,
                 delay: MockDuration.value));

    dioAdapter?.onGet(
      Urls.companyState,
      (server) => server.reply(
        ServerCode.ok,
        CompanyStatesMockResponse.okResponse,
        delay: MockDuration.value,
      ),
    );

     dioAdapter?.onGet(
      Urls.featureFlag,
      (server) => server.reply(
        ServerCode.ok,
        FeatureFlagMockResponse.okResponse,
        delay: MockDuration.value,
      ),
    );


    dioAdapter?.onPost(
      Urls.lastEntityUpdate,
      (server) => server.reply(
        ServerCode.ok,
        LastEntityUpdateMockResponse.okResponse,
        delay: MockDuration.value,
      ),
    );

    dioAdapter?.onPut(
      '${Urls.jobNote}/3460',
      (server) => server.reply(
        ServerCode.ok,
        UpdateJobNoteMockResponse.response,
        delay: MockDuration.value,
      ),
    );

    dioAdapter?.onGet(
      Urls.appointmentCount,
      (server) => server.reply(
        ServerCode.ok,
        AppointmentCountMockResponse.okResponse,
        delay: MockDuration.value,
      ),
    );

    dioAdapter?.onPost(
      Urls.generateSerialNumber,
      (server) => server.reply(
        ServerCode.ok,
        GenerateSerialNumberMockResponse.okResponse,
        delay: MockDuration.value,
      ),
    );

     dioAdapter?.onGet(
      Urls.materialLists,
      (server) => server.reply(
        ServerCode.ok,
        MaterialListingMockResponse.okResponse,
        delay: MockDuration.value,
      ),
    );

    dioAdapter?.onGet(
      Urls.customFields,
      (server) => server.reply(
        ServerCode.ok,
        CustomFieldsMockResponse.okResponse,
        delay: MockDuration.value,
      ),
    );

    dioAdapter?.onPost(
      Urls.jobType(1),
      (server) => server.reply(
        ServerCode.ok,
        JobTypesMockResponse.okResponse,
        delay: MockDuration.value,
      ),
    );

    dioAdapter?.onGet(
      '${Urls.comapnyContacts}?',
      (server) => server.reply(
        ServerCode.ok,
        CompanyContactListMockResponse.okResponse,
        delay: MockDuration.value,
      ),
    );

    dioAdapter?.onPost(
      Urls.comapnyContacts,
      (server) => server.reply(
        ServerCode.ok,
        CreateCompanyContactMockResponse.okResponse,
        delay: MockDuration.value,
      ),
    );

    dioAdapter?.onPost(
      Urls.jobAwardedStage,
      (server) => server.reply(
        ServerCode.ok,
        JobAwardedStageMockResponse.okResponse,
        delay: MockDuration.value,
      ),
    );

     dioAdapter?.onGet(Urls.setCookie,
             (server) => server.reply(ServerCode.ok,
                 SetCookiesMockResponse.okResponse,
                 headers: CookiesMockHeader.value,
                 delay: MockDuration.value));

     dioAdapter?.onGet(Urls.companySettings,
             (server) => server.reply(ServerCode.ok,
                 CompanySettingsMockResponse.okResponse,
                 delay: MockDuration.value));

     dioAdapter?.onGet(Urls.permissions,
             (server) => server.reply(ServerCode.ok,
                 PermissionsMockResponse.okResponse,
                 delay: MockDuration.value));

     dioAdapter?.onGet(Urls.featureFlag,
             (server) => server.reply(ServerCode.ok,
                 FeatureFlagMockResponse.okResponse,
                 delay: MockDuration.value));            

     dioAdapter?.onGet('${Urls.user}/1229',
             (server) => server.reply(ServerCode.ok,
                 UserCompanyMockResponse.okResponse,
                 delay: MockDuration.value));

     dioAdapter?.onGet(Urls.user,
             (server) => server.reply(ServerCode.ok,
                 UserCompanyMockResponse.okResponseList,
                 delay: MockDuration.value));

     dioAdapter?.onGet(Urls.subscriberDetails,
             (server) => server.reply(ServerCode.ok,
                 SubscriberDetailsMockResponse.okResponse,
                 delay: MockDuration.value));

     dioAdapter?.onGet(Urls.connectedThirdParty,
             (server) => server.reply(ServerCode.ok,
                 ConnectedThirdPartyMockResponse.okResponse,
                 delay: MockDuration.value));

     dioAdapter?.onGet(Urls.workFlowStages,
             (server) => server.reply(ServerCode.ok,
                 WorkFlowStagesMockResponse.okResponse,
                 delay: MockDuration.value));

     dioAdapter?.onGet(Urls.subContractor,
             (server) => server.reply(ServerCode.ok,
                 SubContractorsMockResponse.okResponse,
                 delay: MockDuration.value));

     dioAdapter?.onGet(Urls.tags,
             (server) => server.reply(ServerCode.ok,
                 TagsMockResponse.okResponse,
                 delay: MockDuration.value));

     dioAdapter?.onGet(Urls.divisions,
             (server) => server.reply(ServerCode.ok,
                 DivisionMockResponse.okResponse));

     dioAdapter?.onGet(Urls.referrals,
             (server) => server.reply(ServerCode.ok,
                 ReferralsMockResponse.okResponse,
                 delay: MockDuration.value));

     dioAdapter?.onGet(Urls.companyTrades,
             (server) => server.reply(ServerCode.ok,
                 CompanyTradesMockResponse.okResponse,
                 delay: MockDuration.value));

     dioAdapter?.onGet(Urls.companyList,
             (server) => server.reply(ServerCode.ok,
                 CompanyListMockResponse.okResponse,
                 delay: MockDuration.value));

     dioAdapter?.onGet(Urls.country,
             (server )=> server.reply(ServerCode.ok,
                 CountriesMockResponse.okResponse,
                 delay: MockDuration.value));

     dioAdapter?.onGet(Urls.state,
             (server) => server.reply(ServerCode.ok,
                 StatesMockResponse.okResponse,
                 delay: MockDuration.value));

     dioAdapter?.onGet(Urls.flags,
             (server) => server.reply(ServerCode.ok,
                 FlagsMockResponse.okResponse,
                 delay: MockDuration.value));

     Map<String, dynamic>? device =
         await preferences.read(PrefConstants.device);

     dioAdapter?.onPut(Urls.registerDevice(device?["id"].toString() ?? ''),
             (server) => server.reply(ServerCode.ok,
                 DeviceMockResponse.okResponse,
                 delay: MockDuration.value));

     dioAdapter?.onPut(Urls.registerDevice('5026'),
             (server) => server.reply(ServerCode.ok,
             DeviceMockResponse.okResponse,
             delay: MockDuration.value));

     dioAdapter?.onGet('${Urls.jobs}/recent_viewed',
             (server) => server.reply(ServerCode.ok,
                 RecentViewedMockResponse.okResponse,
                 delay: MockDuration.value));

     dioAdapter?.onGet('${Urls.jobs}/21665',
             (server) => server.reply(ServerCode.ok,
                 JobMockResponse.okResponse,
                 delay: MockDuration.value));

     
     dioAdapter?.onGet(Urls.dripCampaigns,
             (server) => server.reply(ServerCode.ok,
                 DripCampaignsMockResponse.okResponse,
                 delay: MockDuration.value));

    dioAdapter?.onGet(Urls.resourcesRecent,
             (server) => server.reply(ServerCode.ok,
                 ResourcesRecentMockResponse.okResponse,
                 delay: MockDuration.value));

    dioAdapter?.onGet(Urls.measurements,
             (server) => server.reply(ServerCode.ok,
                 MeasurementListingMockResponse.okResponse,
                 delay: MockDuration.value));
                
    dioAdapter?.onGet(Urls.measuremnentAttributeList,
            (server)=>  server.reply(ServerCode.ok,
              MeasurementFormMockResponse.okResponse, 
              delay: MockDuration.value));

     dioAdapter?.onGet(Urls.task,
            (server)=>  server.reply(ServerCode.ok,
              TaskListingMockResponse.okResponse, 
              delay: MockDuration.value),
              queryParameters: {"page" : 1}
              );

    dioAdapter?.onGet(Urls.task,
            (server)=>  server.reply(ServerCode.ok,
              TaskListingMockResponse.okResponse2, 
              delay: MockDuration.loadMore),
              queryParameters: {"page" : 2}
              );

    dioAdapter?.onGet(Urls.task,
            (server)=>  server.reply(ServerCode.ok,
              TaskListingMockResponse.noDataResponse, 
              delay: MockDuration.value),
              queryParameters: {"page" : 1, 'duration': 'today'}
              );

    dioAdapter?.onGet(Urls.task,
            (server)=>  server.reply(ServerCode.ok,
              TaskListingMockResponse.okResponseDesc, 
              delay: MockDuration.value),
              queryParameters: {"page" : 1, 'sort_order': 'DESC'}
              );

    dioAdapter?.onGet(Urls.measurement(2337) ,
            (server)=>  server.reply(ServerCode.ok,
              EditMeasurementFormMockResponse.okResponse, 
              delay: MockDuration.value));
    
    dioAdapter?.onPut(Urls.measurement(2420),
          (server) => server.reply(ServerCode.ok,
              EditMeasurementSuccessResponse.okResponse,
              delay: MockDuration.value));

     dioAdapter?.onGet(Urls.estimations,
             (server) => server.reply(ServerCode.ok,
                 EstimatesMockResponse.okResponse,
                 delay: MockDuration.value));

    dioAdapter?.onGet(Urls.proposals,
             (server) => server.reply(ServerCode.ok,
                 ProposalsMockResponse.okResponse,
                 delay: MockDuration.value));

     dioAdapter?.onGet(Urls.measurements,
          (server) => server.reply(ServerCode.ok,
              MeasurementListingMockResponse.okResponse,
              delay: MockDuration.value));
      
     dioAdapter?.onGet(Urls.notificationList,
             (server) => server.reply(ServerCode.ok,
                 NotificationListMockResponse.okResponse,
                 delay: MockDuration.value));

     dioAdapter?.onGet(Urls.customer,
             (server) => server.reply(ServerCode.ok,
             CustomerListingMockResponse.okResponse,
             delay: MockDuration.value),
         queryParameters: {'page' : 1}
     );

     dioAdapter?.onGet(Urls.customer,
             (server) => server.reply(ServerCode.ok,
                 CustomerListingMockResponse.okResponse2,
                 delay: MockDuration.loadMore),
         queryParameters: {'page' : 2}
     );

     dioAdapter?.onGet(Urls.customer,
             (server) => server.reply(ServerCode.ok,
                 CustomerListingMockResponse.noDataResponse,
                 delay: MockDuration.value),
         queryParameters: {
           'page' : 1,
           'sort_by': 'last_name',
           'sort_order': 'asc'
         }
     );

     dioAdapter?.onGet(Urls.customer,
             (server) => server.reply(ServerCode.ok,
                 CustomerListingMockResponse.okResponseLastModified,
                 delay: MockDuration.value),
         queryParameters: {'page' : 1, 'sort_by': 'updated_at'}
     );

     dioAdapter?.onGet(Urls.customerMeta,
             (server) => server.reply(ServerCode.ok,
             CustomerMetaDataMockResponse.okResponse,
             delay: MockDuration.value));

     dioAdapter?.onGet("${Urls.customers}/19644",
             (server) => server.reply(ServerCode.ok,
                 CustomersMockResponse.okResponse,
                 delay: MockDuration.value));

     dioAdapter?.onGet(Urls.emailTemplate,
             (server) => server.reply(ServerCode.ok,
             EmailTemplateMockResponse.okResponse,
             delay: MockDuration.value));

     dioAdapter?.onGet(Urls.latestUpdate,
             (server) => server.reply(ServerCode.ok,
             LatestUpdateMockResponse.okResponse,
             delay: MockDuration.value));

      dioAdapter?.onGet(Urls.jobNote,
        (server) => server.reply(ServerCode.ok,
        JobNoteListingMockResponse.okResponse,
        delay: MockDuration.value
        )
      );
     
     dioAdapter?.onGet(Urls.featureFlag,
             (server) => server.reply(ServerCode.ok,
               FeatureFlagMockResponse.okResponse,
             delay: MockDuration.value));

     dioAdapter?.onGet(Urls.companyGoogleAccount,
             (server) => server.reply(ServerCode.ok,
               CompanyGoogleAccountMockResponse.okResponse,
             delay: MockDuration.value));

     dioAdapter?.onGet(Urls.dailyPlanCount,
             (server) => server.reply(ServerCode.ok,
               DailyPlanCountMockResponse.okResponse,
             delay: MockDuration.value));

     dioAdapter?.onGet(Urls.jobsListing,
             (server) => server.reply(ServerCode.ok,
               JobListingMockResponse.okResponse,
             delay: MockDuration.value));

     dioAdapter?.onGet(Urls.jobMeta,
             (server) => server.reply(ServerCode.ok,
               JobListingMetaDataMockResponse.okResponse,
             delay: MockDuration.value));

     dioAdapter?.onGet(Urls.followUpNote,
             (server) => server.reply(ServerCode.ok,
               FollowupNotesMockResponse.okResponse,
             delay: MockDuration.value));

     dioAdapter?.onGet(Urls.progressBoards,
             (server) => server.reply(ServerCode.ok,
               ProgressBoardsMockResponse.okResponse,
             delay: MockDuration.value));

     dioAdapter?.onPost(Urls.addToProgressBoards,
             (server) => server.reply(ServerCode.ok,
               AddToProgressBoardMockResponse.okResponse,
             delay: MockDuration.value));

     dioAdapter?.onGet(Urls.googleMapAutocompletePlaces,
             (server) => server.reply(ServerCode.ok,
             PlaceAutocompleteMockResponse.okResponse,
             delay: MockDuration.value));

     dioAdapter?.onGet(Urls.googleMapPlaceDetail,
             (server) => server.reply(ServerCode.ok,
             PlaceDetailMockResponse.okResponse,
             delay: MockDuration.value));

     dioAdapter?.onGet(Urls.customFieldSubOptions(218, 906),
             (server) => server.reply(ServerCode.ok,
             CustomFieldsMockResponse.okDropDown1OptionsResponse,
             delay: MockDuration.value));

     dioAdapter?.onGet(Urls.customFieldSubOptions(218, 909),
             (server) => server.reply(ServerCode.ok,
             CustomFieldsMockResponse.okDropDown2OptionsResponse,
             delay: MockDuration.value));

     dioAdapter?.onGet(Urls.customFieldSubOptions(218, 915),
             (server) => server.reply(ServerCode.ok,
             CustomFieldsMockResponse.okDropDown3OptionsResponse,
             delay: MockDuration.value));

     dioAdapter?.onGet("${Urls.customers}/46372",
             (server) => server.reply(ServerCode.ok,
             CustomersMockResponse.okResponse,
             delay: MockDuration.value));

     dioAdapter?.onPost(Urls.customers,
             (server) => server.reply(ServerCode.ok,
             CustomerFormMockResponse.okResponseAddCustomer,
             delay: MockDuration.value));
   }

   void setTestDescription(String groupDesc, String testDesc) {
     groupTestDescription.value = groupDesc;

     testDescription.value = testDesc;
   }

  void changeUrlMatcher(JPUrlMatcherMode urlMatcherMode) =>
      urlMatcher.isFullMatch = urlMatcherMode == JPUrlMatcherMode.fullRequestMatch;
}