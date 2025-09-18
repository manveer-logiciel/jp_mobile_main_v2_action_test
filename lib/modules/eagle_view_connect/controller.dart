import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/providers/firebase/realtime_db.dart';
import 'package:jobprogress/core/constants/shared_pref_constants.dart';
import 'package:jobprogress/core/constants/urls.dart';

class EVConnectWebViewController extends GetxController {

  Future<void> setWebViewController(InAppWebViewController webViewController) async {
    final token = await prefService.read(PrefConstants.accessToken);
    await webViewController.loadUrl(
        urlRequest: URLRequest(url: WebUri(Urls.eagleViewRedirectURI),
        headers: {
          'Authorization': 'Bearer $token'
        })
    );
  }

  Future<void> loginSuccessfullyAcknowledgement() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    Get.back(result: true); // This will close the current screen
  }
}