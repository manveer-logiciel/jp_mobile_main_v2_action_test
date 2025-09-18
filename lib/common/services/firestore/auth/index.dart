import 'package:jobprogress/common/providers/firebase/auth.dart';
import 'package:jobprogress/common/repositories/user_token.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/firestore/index.dart';
import 'package:jobprogress/core/utils/firebase/firestore.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class FirebaseAuthService {

  /// [loginToken] will be initialized for accounts having firebase messaging enabled
  /// Its made global so it can fetched with [setFirebaseLoginToken] alongside initial app load
  /// and saved the sequential loading time
  static String? loginToken;

  static Future<void> setFirebaseLoginToken() async {
    try {
      if(!FirestoreHelpers.instance.isMessagingEnabled) return;
      Map<String, dynamic> params = {'user_id': AuthService.userDetails?.id};
      // requesting token
      loginToken = await UserTokenRepo.getUserToken(params);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> login() async {

    if(!FirestoreHelpers.instance.isMessagingEnabled) return;

    try {

      if(FirebaseAuthProvider.getCurrentUser() != null) return;
      if (Helper.isValueNullOrEmpty(loginToken)) await setFirebaseLoginToken();
      if (Helper.isValueNullOrEmpty(loginToken)) return;
      // logging with retrieved token
      await FirebaseAuthProvider.loginWithToken(loginToken!);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> logOut() async {
    loginToken = null;
    await FirebaseAuthProvider.logOut();
    await FirestoreService.disposeAllStreams();
  }

}
