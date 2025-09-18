
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/templates/functions.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// [JPTemplateEditorController] provides necessary functionalities required by html template editor
/// So the effort of writing everything from scratch can be saved
abstract class JPTemplateEditorController extends GetxController {

  final String path = "assets/html/template.html";

  String? html;
  String? initialHtml;

  bool isLoading = true;
  bool isInitialised = false;

  int selectedIndex = 0;
  String selectedClassName = '';

  InAppWebViewController? webViewController;

  // provides details of tapped item
  void onElementTapped(int index, String className);

  void onWebViewInitialized() {
    isInitialised = true;
  }

  // initializes controller and injects JS for function calling
  Future<void> setWebViewController(InAppWebViewController controller) async {
    webViewController = controller;
    if (!isInitialised) {
      await webViewController?.injectJavascriptFileFromAsset(assetFilePath: "assets/html/template.js");
      // Add orientation change handler
      webViewController?.addJavaScriptHandler(
        handlerName: 'onOrientationChange',
        callback: (arguments) {
          // Rescale content when orientation changes
          Future.delayed(const Duration(milliseconds: 100), () {
            scaleContent();
          });
        },
      );

      await scaleContent();
      onWebViewInitialized();
    }
  }

  // sets up display template HTML
  Future<void> setHtml({String? content, String? pageType, List<String>? clickableElements}) async {
    await executeJs(TemplateFunctionConstants.setHtml, args: {
          'html': content ?? html
        });

    // setting up parent element classes
    if (pageType != null) await setClassesOnTemplateBody(pageType);
    // adding listeners
    if (clickableElements != null) await addHandlers(clickableElements);
    // blocking text editing
    blockText();
    // binds listeners on HTML input fields, check boxes & textarea
    bindListenersOnElements();
  }

  // returns updated html whenever it's called
  Future<String> getHtml() async {
    final response = await executeJs(TemplateFunctionConstants.getHtml);
    return response?.value;
  }

  // helps in performing JS function executing in an organised way
  Future<CallAsyncJavaScriptResult?> executeJs(String function, {Map<String, dynamic>? args}) async {

    String? functionArgs = args?.keys.join(",");

    final result = await webViewController?.callAsyncJavaScript(
        functionBody: 'return ' + function + "(${functionArgs ?? ''})",
        arguments: args ?? {}
    );

    return result;
  }

  // binds handlers with HTML elements
  Future<void> addHandlers(List<String> classesToAddClickOn) async {
    
    webViewController?.addJavaScriptHandler(
      handlerName: 'elementClicked',
      callback: (dynamic arguments) {
        int index = arguments[0];
        String className = arguments[1];
        onElementTapped(index, className);
      },
    );

    for (var name in classesToAddClickOn) {
      await executeJs(TemplateFunctionConstants.addClicks, args: {
        'name': name
      });
    }
  }

  Future<void> setClassesOnTemplateBody(String className) async {
    await executeJs(TemplateFunctionConstants.setClassesOnTemplateBody, args: {
      'className': className,
    });
  }

  void blockText() {
    executeJs(TemplateFunctionConstants.blockText);
  }

  void bindListenersOnElements() {
    executeJs(TemplateFunctionConstants.bindListeners);
  }

  // prints data of web-view in console
  void onConsoleMessage(_, ConsoleMessage message) {
    debugPrint("WEB VIEW CONSOLE: $message");
  }

  // set's up initial HTML for comparison
  Future<void> setInitialHtml() async {
    if (RunModeService.isUnitTestMode) return;
    initialHtml = await getHtml();
  }

  // compares initial and current HTML to detect whether any changes made or not
  Future<bool> checkIfNewDataAdded() async {
    if (html == null) return true;
    final currentHtml = await getHtml();
    return initialHtml != currentHtml;
  }

  Future<void> scaleContent({String scale = '0.52'}) async {
    await executeJs(TemplateFunctionConstants.scaleContent, args: {
      'scale': JPScreen.width / CommonConstants.templateWidth
    });
  }

  void resetScale() {
    webViewController?.zoomBy(zoomFactor: 0.1);
  }

  void unFocus() {
    executeJs(TemplateFunctionConstants.unFocus);
  }
}