import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/external_template_web_view/controller.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';

class JPExternalTemplateWebView extends StatelessWidget {
  const JPExternalTemplateWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<JPExternalTemplateWebViewController>(
        init: JPExternalTemplateWebViewController(),
        global: false,
        builder: (controller) {
          return JPWillPopScope(
            onWillPop: () async => false,
            child: InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(controller.url)),
                initialSettings: InAppWebViewSettings(
                  verticalScrollBarEnabled: false,
                  horizontalScrollBarEnabled: false,
                  allowFileAccessFromFileURLs: true,
                ),
                onLoadStop: (webViewController, url) {
                  controller.setWebViewController(webViewController);
                },
                onWebViewCreated: (webViewController) {
                  controller.webViewController = webViewController;
                },
                onConsoleMessage: controller.onConsoleMessage,              
              ),
          ); 
        },
      ),
    );
  }
}