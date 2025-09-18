import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class EditorController {
  void Function(double height)? setHeight;

  /// Underlying web view controller.
  ///
  /// This will get initialized once the editor is fully loaded.
  late InAppWebViewController webViewController;

  /// Controller that controls the enclosing scroll view.
  ///
  /// ```dart
  /// ListView(
  ///   controller: scrollController,
  ///   children: [
  ///     ...,
  ///     HtmlEditor(
  ///       controller: EditorController(
  ///         scrollController: scrollController
  ///       ), // EditorController
  ///     ), // HtmlEditor
  ///     ...,
  ///   ],
  /// ) // ListView
  /// ```
  ScrollController? scrollController;

  EditorController({this.scrollController});

  /// Get html content from editor
  Future<String> getHtml() async {
    String sourceString = "\$('#emailCompose').summernote('code');";

    return await webViewController.evaluateJavascript(
        source: sourceString);
  }

  String processHtml({required String html}) {
      html = html
          .replaceAll("'", r"\'")
          .replaceAll('"', r'\"')
          .replaceAll('\r', '')
          .replaceAll('\r\n', '');
      html = html.replaceAll('\n', '').replaceAll('\n\n', '');
    return html;
  }

  /// Set html content for editor
  Future<void> setHtml(String html) async {
    String sourceString = "\$('#emailCompose').summernote('code', '${processHtml(html: html)}');";

    await webViewController.evaluateJavascript(source: sourceString);

    await setEditorHeight();
    await blockAnchorTag();
  }

  void pasteHtml(String html) async {
    String sourceString = "\$('#emailCompose').summernote('pasteHTML', '${processHtml(html: html)}');";

    await webViewController.evaluateJavascript(source: sourceString);

    await setEditorHeight();
    await blockAnchorTag();
  }

  void getAndSetHtml(String html) async {
    String content = await getHtml();
    setHtml(content + html);
  }

  Future<void> blockAnchorTag() async {
    await webViewController.evaluateJavascript(source: '''
      setTimeout(() => {
        \$.each( \$('.note-editing-area').find('a'), function( key, value ) {
		    	var href = \$(this).attr('href');

          \$(this).attr('href', '#');

          var propUrl = \$(this).attr('data-prop-url');

          if( propUrl && propUrl != null && propUrl != '' ){
            //assign the same data-prop-url value if present
            \$(this).attr('data-prop-url', propUrl);
          }else{
            \$(this).attr('data-prop-url', href);
          }

          \$(this).click(function(e) {
            e.preventDefault();
          });
        });
      }, 500);
    ''');
  }

  Future<void> setEditorHeight() async {
    await webViewController.evaluateJavascript(source: '''
        var editor = document.getElementsByClassName('note-editable');
        var height = editor[0].scrollHeight;
        window.flutter_inappwebview.callHandler("onChange", height);
      ''');
  }

  void removeFocus() {
    webViewController.evaluateJavascript(source: '''
      \$(".note-editable").blur();
      var sel = window.getSelection ? window.getSelection() : document.selection;
      if (sel) {
        if (sel.removeAllRanges) {
            sel.removeAllRanges();
        } else if (sel.empty) {
            sel.empty();
        }
      }
    ''');
  }
}
