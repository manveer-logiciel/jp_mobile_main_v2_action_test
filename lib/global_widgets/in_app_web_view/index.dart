import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class JPInAppWebView extends StatelessWidget {
  const JPInAppWebView({
    super.key,
    required this.content,
    required this.height,
    required this.callBackForHeight,
    this.disableContextMenu = true,
  });

  final String content;

  final double height;

  final Function(double) callBackForHeight;

  /// [disableContextMenu] helps is deciding whether to disable context menu
  /// or not. By default it is set to [True] i.e. disable context menu.
  final bool disableContextMenu;

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialSettings: InAppWebViewSettings(
        useWideViewPort: false,
        supportZoom: !disableContextMenu,
        javaScriptEnabled: true,
        transparentBackground: true,
        disableContextMenu: disableContextMenu,
        horizontalScrollBarEnabled: false,
        verticalScrollBarEnabled: false,
      ),
      // Recognising long press gestures on HTML content, In case
      // context menu is to be displayed
      gestureRecognizers: !disableContextMenu
          ? {
            Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
            ),
          } : null,
      initialData: InAppWebViewInitialData(data: content),
      onWebViewCreated: (InAppWebViewController webViewController) {
        if (height <= 1.0) {
          webViewController.addJavaScriptHandler(
              handlerName: "handle_link",
              callback: (dynamic arguments) {
                Helper.launchUrl(arguments[0]);
              });
          webViewController.addJavaScriptHandler(
              handlerName: "setHeight",
              callback: (List<dynamic> arguments) async {
                int? contentHeight = await webViewController.getContentHeight();
                double? zoomScale = await webViewController.getZoomScale();
                double htmlHeight = contentHeight!.toDouble() * zoomScale!;
                double htmlHeightFixed = double.parse(htmlHeight.toStringAsFixed(2));

                if (htmlHeightFixed == 0.0) {
                  return;
                }

                callBackForHeight(htmlHeightFixed);
              });
        }
      },
      onLoadStop: (InAppWebViewController controller, Uri? url) async {
        // Resizing the webview to fit the content as per the device's screen size
        // What is the need of this additional code?
        // - On setting (supportZoom: true) iOS devices fails to scale the content on it's own
        // due to some issues with the webview code. So handing it explicitly.
        await controller.evaluateJavascript(source: """
          var meta = document.createElement('meta');
          meta.setAttribute('name', 'viewport');
          meta.setAttribute('content', 'width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=3.0');
          document.getElementsByTagName('head')[0].appendChild(meta);
         """);
      },
    );
  }
}
