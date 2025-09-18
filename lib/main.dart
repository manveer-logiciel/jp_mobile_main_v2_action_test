import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/background_session_tracking_service.dart';
import 'package:jobprogress/common/services/clock_in_clock_out.dart';
import 'package:jobprogress/common/services/dev_console/index.dart';
import 'package:jobprogress/common/services/firebase_core/index.dart';
import 'package:jobprogress/common/services/firebase_crashlytics.dart';
import 'package:jobprogress/common/services/language.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/common/services/shared_pref.dart';
import 'package:jobprogress/common/services/upload.dart';
import 'package:jobprogress/core/config/app_env.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jobprogress/translations/index.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'common/services/api_gateway/index.dart';
import 'common/services/connectivity.dart';
import 'common/services/mixpanel/view_observer.dart';
import 'common/services/workflow_stages/workflow_service.dart';
import 'core/constants/common_constants.dart';
import 'core/constants/shared_pref_constants.dart';
import 'core/utils/helpers.dart';
import 'package:pendo_sdk/pendo_sdk.dart';

SharedPrefService preferences = SharedPrefService();
dynamic isUserLoggedIn;
String? companyCode;

void main() async {
  await runZonedGuarded(() async {

    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    AppEnv.setEnvironment(Environment.dev);

    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    await JPFirebase.setUp();

    await FileHelper.setLocalStoragePath();

    // Helps in displaying the internet not connected message
    ConnectivityService.setUpConnectivity();

    isUserLoggedIn = await preferences.read(PrefConstants.accessToken);
    dynamic user = await preferences.read(PrefConstants.user);

    if(isUserLoggedIn != null) await AuthService.getLoggedInUser();

    await MixPanelService.init();

    WorkFlowService.setUp();

    ApiGatewayService.setUp();

    // Initialize language service with flag listener
    await LanguageService.initialize();

    BackgroundSessionTrackingService.setUp();

    await Helper.setApplicationBadgeCount('0');

    runApp(const JobProgressApp());
    if(user != null && user['company_details'] != null && user['company_details']['office_country'] != null && user['company_details']['office_country']['code'] != null){
      companyCode = user['company_details']['office_country']['code'];
    }
    ApiProvider.setAuthInterceptor();

    await Future<void>.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();

  }, (error, stackTrace) {
    Crashlytics.recordError(error, stackTrace);
    DevConsoleService.recordError(error);
  });
}

class JobProgressApp extends StatefulWidget {
  const JobProgressApp({super.key});

  static RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
  static GlobalKey widgetKey = GlobalKey();

  @override
  State<JobProgressApp> createState() => _JobProgressAppState();
}

class _JobProgressAppState extends State<JobProgressApp> {

  @override
  void initState() {
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
    setDimensions(doWait: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 0.5, maxScaleFactor: 1.5),
            ),
            child: ResponsiveWrapper.builder(
              JPLayoutBuilder(
                child: SizedBox(
                  key: JobProgressApp.widgetKey,
                  child: Center(
                    child: child!,
                  ),
                ),
                onUpdate: () async {
                  await setDimensions();
                  UploadService.handleOrientationChange();
                  ClockInClockOutService.handleOrientationChange();
                },
              ),
              maxWidth: JPScreen.maxWidth,
              minWidth: 350,
              defaultScale: false,
              breakpoints: [
                const ResponsiveBreakpoint.resize(350, name: MOBILE, scaleFactor: 1),
                const ResponsiveBreakpoint.resize(600, name: TABLET, scaleFactor: 1.15),
                const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                ResponsiveBreakpoint.resize(JPScreen.maxWidth, name: DESKTOP),
              ],
              alignment: Alignment.center,
              background: Container(color: JPColor.black),
            ),
          );
        },
        title: 'Leap',
        defaultTransition: Transition.rightToLeft,
        navigatorObservers: [PendoNavigationObserver(), JobProgressApp.routeObserver],
        routingCallback: MixPanelViewObserver.observe,
        translations: JPTranslations(),
        transitionDuration: const Duration(milliseconds: CommonConstants.transitionDuration),
      locale: LanguageService.currentLocale,
        getPages: AppPages.pages,
        initialRoute: isUserLoggedIn == null ? Routes.login : Routes.home,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            backgroundColor: JPAppTheme.themeColors.base,
          ),
          typography: Typography.material2014(),
          iconButtonTheme: const IconButtonThemeData(
            style: ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          dialogTheme: DialogTheme(
            backgroundColor: JPAppTheme.themeColors.base,
          ),
          drawerTheme: DrawerThemeData(
              backgroundColor: JPAppTheme.themeColors.base
          ),
          cardTheme: CardTheme(
              color: JPAppTheme.themeColors.base
          ),
          appBarTheme: const AppBarTheme(
              surfaceTintColor: JPColor.transparent
          ),
          dividerTheme: DividerThemeData(
              thickness: 0.5,
              color: JPAppTheme.themeColors.lightestGray
          ),
          tabBarTheme: TabBarTheme(
            labelColor: JPAppTheme.themeColors.primary,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          useMaterial3: true
      ),
    );
  }

  Future<void> setDimensions({bool doWait = false}) async {
    if(doWait)  await Future<void>.delayed(const Duration(seconds: 2));
    JPScreen.setDimensions(JobProgressApp.widgetKey);
    if(JPScreen.doForceRefershOnLayoutChange) {
      await Get.forceAppUpdate();
    }
  }
}
