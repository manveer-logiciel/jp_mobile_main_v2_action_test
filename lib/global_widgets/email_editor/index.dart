import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:jobprogress/global_widgets/email_editor/editor_controller.dart';

class JPEmailEditor extends StatefulWidget {
  const JPEmailEditor({
    super.key,
    required this.editorController, 
    this.onFocus
  });

  final EditorController editorController;
  final VoidCallback? onFocus; 

  @override
  State<JPEmailEditor> createState() => _JPEmailEditorState();
}

class _JPEmailEditorState extends State<JPEmailEditor> {
  double height = 150;

  @override
  Widget build(BuildContext context) {
    String filePath = 'assets/html/summernote.html';

    return SizedBox(
      height: height + 32,
      child: InAppWebView(
        initialFile: filePath,
        onWebViewCreated: (InAppWebViewController controller) {
          widget.editorController.webViewController = controller;
        },
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          transparentBackground: true,
          disableHorizontalScroll: false,
          supportZoom: false,
          disableVerticalScroll: true,
          horizontalScrollBarEnabled: false,
          verticalScrollBarEnabled: false,
          preferredContentMode: UserPreferredContentMode.MOBILE,
          geolocationEnabled: false,
          useWideViewPort: false,
          builtInZoomControls: false,
          loadWithOverviewMode: true,
          useHybridComposition: true,
          overScrollMode: OverScrollMode.IF_CONTENT_SCROLLS,
          thirdPartyCookiesEnabled: false,
        ),
        onWindowFocus: (controller) async {},
        onLoadStop: (InAppWebViewController controller, Uri? uri) async {
          var url = uri.toString();
          if (url.contains(filePath)) {
            await controller.evaluateJavascript(source: """
              \$('#emailCompose').summernote({
                  placeholder: "Message",
                  tabsize: 2,
                  focus: true,
                  disableResizeEditor: true,
                  toolbar: [
                    ['style', ['bold', 'italic']], //Specific toolbar display
                  ],
                  disableGrammar: false,
                  popover: {
                    air: [
                      ['color', ['color']],
                      ['font', ['bold', 'underline', 'clear']]
                    ]
                  },
              });

              \$('#emailCompose').summernote('reset');

              var editor = document.getElementsByClassName('note-editable'); 

              editor[0].addEventListener("keydown", (event) => {
                var key = event.key || event.code || event.keyCode.toString;
                if(key == '13' || key == 'Enter') {
                  var height = editor[0].scrollHeight;
                  window.flutter_inappwebview.callHandler("onChange", height);
                }
              }, false);

              editor[0].addEventListener("input", (event) => {
                var height = editor[0].scrollHeight;
                window.flutter_inappwebview.callHandler("onChange", height);
              }, false);

              editor[0].addEventListener("focus", (event) => {
               window.flutter_inappwebview.callHandler("onFocus");
              }, false);
          """);
          }

          controller.addJavaScriptHandler(
            handlerName: 'onChange',
            callback: (dynamic args) async {
              int height = args[0];
              await adjustEditorHeight(contentHeight: height.toDouble());
            }
          );
          controller.addJavaScriptHandler(
            handlerName: 'onFocus', 
            callback: (args) async {
              widget.onFocus?.call();
            }
          );
        },
      ),
    );
  }

  Future<void> adjustEditorHeight({
    required double contentHeight,
  }) async {
    var heightChange = contentHeight - height;
    if (heightChange != 0) {
      setState(() {
        height = max(contentHeight, 200);
      });
      if (widget.editorController.scrollController != null) {
        ScrollController controller = widget.editorController.scrollController!;
        if (controller.position.maxScrollExtent > 0) {
          await controller.animateTo(controller.offset + heightChange,
              duration: const Duration(milliseconds: 100), curve: Curves.ease);
        }
      }
    }
  }
}
