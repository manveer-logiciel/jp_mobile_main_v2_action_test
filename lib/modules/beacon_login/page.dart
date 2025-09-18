import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/beacon_login/controller.dart';
import 'package:jp_mobile_flutter_ui/Header/header.dart';

class BeaconLoginWebView extends StatelessWidget {
  const BeaconLoginWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      child: GetBuilder<BeaconLoginController>(
        init: BeaconLoginController(),
        global: false,
        builder: (controller) =>
            JPScaffold(
                appBar: JPHeader(
                  onBackPressed: Get.back<void>,
                ),
                body: InAppWebView(
                  initialUrlRequest: URLRequest(url: WebUri(Urls.beaconLoginUrl)),
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: true,
                    thirdPartyCookiesEnabled: true,
                    cacheEnabled: true,
                    useShouldOverrideUrlLoading: true,
                  ),
                  shouldOverrideUrlLoading: (webViewController, navigation) async {
                    if (navigation.request.url?.uriValue.toString().startsWith(Urls.appUrl) ?? false) {
                      await controller.setBeaconDetails(navigation.request.url?.uriValue.toString());
                      return NavigationActionPolicy.CANCEL;
                    }
                    return NavigationActionPolicy.ALLOW;
                  },
                ),
            ),
      ),
    );
  }
}
