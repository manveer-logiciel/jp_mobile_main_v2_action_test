import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../global_widgets/safearea/safearea.dart';
import '../../global_widgets/scaffold/index.dart';
import 'controller.dart';

class EVConnectWebView extends StatelessWidget {
  const EVConnectWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      child: GetBuilder<EVConnectWebViewController>(
        init: EVConnectWebViewController(),
        global: false,
        builder: (controller) =>
            JPScaffold(
              appBar: JPHeader(
                onBackPressed: Get.back<void>,
              ),
              body: InAppWebView(
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  thirdPartyCookiesEnabled: true,
                  cacheEnabled: true,
                  useWideViewPort: false,
                  supportZoom: false,
                  transparentBackground: true,
                  disableHorizontalScroll: true,
                  disableVerticalScroll: true,
                  useShouldOverrideUrlLoading: true,
                ),
                shouldOverrideUrlLoading: (_, navigator) async {
                  return NavigationActionPolicy.ALLOW;
                },
                onWebViewCreated: (webViewController) async => await controller.setWebViewController(webViewController),
                onLoadStop: (_, url) async {
                  if(url?.path.contains(Urls.eagleViewVerify) ?? false) {
                   await controller.loginSuccessfullyAcknowledgement();
                  }
                },
              )
            )
      )
    );
  }
}
