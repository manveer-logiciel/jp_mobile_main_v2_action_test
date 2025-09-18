
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:jobprogress/core/config/app_env.dart';
import 'package:jobprogress/core/constants/common_constants.dart';

import '../firebase_crashlytics.dart';

class JPFirebase {

  static Future<void> setUp() async {
    // setting up default firebase app
    await Firebase.initializeApp(
        options: AppEnv.config['FIREBASE_OPTIONS']
    );

    // setting up second firebase app
    await Firebase.initializeApp(
        options: AppEnv.config[CommonConstants.secondFirebaseAppName],
        name: CommonConstants.secondFirebaseAppName
    );

    // setting up default instances as second firebase app for (fire-store, realtime-db, firebase-auth)
    /// Q1. Why second app is not set for firebase messaging only instead of setting up for all these 3 ?
    // - Firebase messaging for now doesn't support 2nd firebase app & works with default firebase app only. But,
    // other's do work with 2nd or third firebase app.
    FirebaseFirestore.instance.app = Firebase.app(CommonConstants.secondFirebaseAppName);
    FirebaseDatabase.instance.app = Firebase.app(CommonConstants.secondFirebaseAppName);
    FirebaseAuth.instance.app = Firebase.app(CommonConstants.secondFirebaseAppName);

    Crashlytics.initCrashlytics();
  }

}