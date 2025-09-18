import 'dart:isolate';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/mixpanel/view_observer.dart';
import 'package:jobprogress/core/config/app_env.dart';

class Crashlytics {

  static final instance = FirebaseCrashlytics.instance;

  static bool get skipCrashlytics => AppEnv.currentEnv != Environment.dev;

  static void initCrashlytics() {
    // Setting up crashlytics to share reports
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!skipCrashlytics);
    if (skipCrashlytics) return;
    // Pass all uncaught errors from the framework to Crashlytics.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    // Creating an isolate listener to listen errors that don't fall in context
    Isolate.current.addErrorListener(RawReceivePort((dynamic pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
        fatal: true,
      );
    }).sendPort);
  }

  static void recordError(Object error, StackTrace? stackTrace) {
    if (skipCrashlytics) return;
    instance.recordError(error, stackTrace);
  }

  static void crashApp() {
    instance.crash();
  }

  static void throwNonFatalError() {
    throw Error();
  }

  static void throwFatalError() {
    throw instance.recordError(Exception('Custom Exception : Fatal error'), StackTrace.empty, fatal: true);
  }

  static setUserAndCompanyId()  async {

    final userDetails = AuthService.userDetails;

    instance.setUserIdentifier('${userDetails?.id}');
  }

  /// [setCustomKeys] helps in setting additional details to be stored in firebase crashlytics
  static void setCustomKeys() {
    final userDetails = AuthService.userDetails;
    instance.setCustomKey('route', MixPanelViewObserver.formattedPath);
    instance.setCustomKey('user_id', '${userDetails?.id}');
    instance.setCustomKey('company_id', '${userDetails?.companyDetails?.id}');
  }
}