import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/repositories/worksheet.dart';
import 'package:jobprogress/core/utils/helpers.dart';

import '../../common/services/auth.dart';
import '../../core/constants/urls.dart';
import '../../global_widgets/loader/index.dart';

class BeaconLoginController extends GetxController {
  InAppWebViewController? webViewController;

  Future<void> setWebViewController(InAppWebViewController controller) async {
    webViewController = controller;
    await saveUserDetailsOnLocalStorage();
    // Inject JavaScript to listen for `window.close()`
    await addCloseWindowJavaScriptHandler();
  }

  Future<void> saveUserDetailsOnLocalStorage() async {
    UserModel userModel = await AuthService.getLoggedInUser();
    String token = await AuthService.getAccessToken();
    final jsonString = jsonEncode({
      'user': userModel.toJson(),
      'token': {'access_token': token}
    });
     await webViewController?.platform.webStorage.localStorage.setItem(key: 'ls.AppUser', value: jsonString);
     await Future<void>.delayed(const Duration(seconds: 5));
  }

  Future<void> addCloseWindowJavaScriptHandler() async {
    webViewController?.addJavaScriptHandler(
      handlerName: 'closeWebView',
      callback: (args) async {
        // Close the InAppWebView or perform a custom action
        await Future<void>.delayed(const Duration(milliseconds: 500));
        Get.back(result: true); // This will close the current screen
      },
    );

    await webViewController?.evaluateJavascript(
      source: """
            // Override window.close to trigger a custom event
            window.close = function() {
              window.flutter_inappwebview.callHandler('closeWebView');
            };
            """,
    );
  }

  Future<void> onLoadStart(InAppWebViewController controller, WebUri? url) async {
    if(url?.uriValue.toString().contains(Urls.appUrl) ?? false) {
      await setWebViewController(controller);
    }
  }

  Future<void> setBeaconDetails(String? url) async {
    try {
      showJPLoader(msg: 'Connecting QXO...');
      UserModel userModel = await AuthService.getLoggedInUser();
      final beaconParams = Helper.extractParamsFromURL(url ?? "");

      if (!beaconParams.containsKey('access_token')) {
        throw Exception("Beacon Access Token not found");
      }

      final params = {
        ...beaconParams,
        "company_id": userModel.companyDetails?.id,
        "user_id": userModel.id
      };
      final response = await WorksheetRepository.setBeaconOAuthDetails(params);
      Get.back();
      Get.back(result: response);
    } catch (e) {
      Get.back();
      Get.back();
      rethrow;
    }
  }

}
