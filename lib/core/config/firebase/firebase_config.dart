import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:jobprogress/core/config/firebase/dev_env_firebase.dart';
import 'package:jobprogress/core/config/firebase/qa_env_firebase.dart';
import 'package:jobprogress/core/config/firebase/qa_rc_env_firebase.dart';

import 'prod_env_firebase.dart';

class DefaultFirebaseOptions {

  // currentPlatform filters config files as per environment
  static Map<String, FirebaseOptions> get currentPlatform {
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // filters firebase options file as per app environment for android
  static const Map<String, FirebaseOptions> android = {
    'FIREBASE_QA': FirebaseQAEnv.androidDefault,
    'FIREBASE_QA_DATA': FirebaseQAEnv.androidData,
    'FIREBASE_QA_RC': FirebaseQARcEnv.androidDefault,
    'FIREBASE_QA_RC_DATA': FirebaseQARcEnv.androidData,
    'FIREBASE_DEV': FirebaseDevEnv.androidDefault,
    'FIREBASE_DEV_DATA': FirebaseDevEnv.androidData,
    'FIREBASE_PROD' : FirebaseProdEnv.androidDefault,
    'FIREBASE_PROD_DATA' : FirebaseProdEnv.androidData,
  };

  // filters firebase options file as per app environment for ios
  static const Map<String, FirebaseOptions> ios = {
    'FIREBASE_QA': FirebaseQAEnv.iosDefault,
    'FIREBASE_QA_RC': FirebaseQARcEnv.iosDefault,
    'FIREBASE_DEV': FirebaseDevEnv.iosDefault,
    'FIREBASE_QA_DATA': FirebaseQAEnv.iosData,
    'FIREBASE_QA_RC_DATA': FirebaseQARcEnv.iosData,
    'FIREBASE_DEV_DATA': FirebaseDevEnv.iosData,
    'FIREBASE_PROD' : FirebaseProdEnv.iosDefault,
    'FIREBASE_PROD_DATA' : FirebaseProdEnv.iosData,
  };
}