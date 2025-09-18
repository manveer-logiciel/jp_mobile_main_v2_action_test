import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/templates/functions.dart';

import '../../common/enums/file_listing.dart';

 class JPExternalTemplateWebViewController extends GetxController {

  bool isInitialised = false;

  late InAppWebViewController webViewController;

  String get operationType => Get.arguments?["operation_type"];
  String url = Get.arguments?["url"];
  FLModule? pageType = Get.arguments?[NavigationParams.pageType];

  void onWebViewInitialized() {
    isInitialised = true;
  }

  Future<void> setWebViewController(InAppWebViewController controller) async {
    webViewController = controller;
    await webViewController.injectJavascriptFileFromAsset(assetFilePath: "assets/html/template.js");
    await addHandlers();
  }

  Future<CallAsyncJavaScriptResult?> executeJs(String function, {Map<String, dynamic>? args}) async {

    String? functionArgs = args?.keys.join(",");

    final result = await webViewController.callAsyncJavaScript(
        functionBody: 'return ' + function + "(${functionArgs ?? ''})",
        arguments: args ?? {}
    );
    return result;
  }

  Future<void> addHandlers() async {
    webViewController.addJavaScriptHandler(
      handlerName: 'fetchData',
      callback: (dynamic arguments) {
        if(arguments.first != null && arguments[0]["type"] == "save"){
          navigateTo(operationType);
        }
        if(arguments.first != null && arguments[0]["type"] == "close"){
          navigateTo(operationType);
        }
      },
    );
    await executeJs(TemplateFunctionConstants.getLocalStorageData);
  }

  void onConsoleMessage(_, ConsoleMessage message) {
    debugPrint("WEB VIEW CONSOLE: $message");
  }

  navigateTo(String type, {String? templateId}){
    switch(type){
      case 'edit':
        Get.back(result: true);
        break;

      case 'create':
        if(pageType != FLModule.templatesListing) {
          Get.back(result: true);
        }
        Get.back(result: true);
        break;
    }
  }

}