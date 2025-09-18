import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:jobprogress/global_widgets/template_editor/controller.dart';

/// [JPTemplateEditor] can be used to display html content
/// that can also be modified and can be interacted
class JPTemplateEditor extends StatelessWidget {

  const JPTemplateEditor({
    super.key,
    required this.controller,
    this.isDisabled = false,
  });

  final JPTemplateEditorController controller;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isDisabled,
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1,
        child: InAppWebView(
          initialFile: controller.path,
          initialSettings: InAppWebViewSettings(
            verticalScrollBarEnabled: false,
            horizontalScrollBarEnabled: false,
            allowFileAccessFromFileURLs: true,
          ),
          gestureRecognizers: {
            Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()),
            Factory<HorizontalDragGestureRecognizer>(() => HorizontalDragGestureRecognizer()),
          },
          onLoadStop: (webViewcontroller, url) async {
            controller.setWebViewController(webViewcontroller);
          },
          onWebViewCreated: (webViewcontroller) {
            controller.webViewController = webViewcontroller;
          },
          onConsoleMessage: controller.onConsoleMessage,
        ),
      ),
    );
  }
}
