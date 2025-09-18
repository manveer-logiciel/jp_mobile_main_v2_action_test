
import 'package:get/get.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

extension JPGetNavigation on GetInterface {
  //Get.offCurrentNamed('') can be used in place of Get.toNamed('')
  //in can you want to remove current page from stack while navigating to new page
  Future<T?>? offCurrentToNamed<T>(
    String page, {
    dynamic arguments,
    int? id,
  }) {
    if (Get.currentRoute != Routes.home) {
      global(id).currentState?.pop();
    }

    return global(id).currentState?.pushNamed<T>(
          page,
          arguments: arguments,
        );
  }

  void offAllToFirst({
    dynamic arguments,
    int? id,
  }) {
    return global(id).currentState?.popUntil((route) => route.isFirst);
  }

  // toSplitNamed(): Used to navigate in split view/nested navigation
  // params : splitRoute  : Name of the route to navigated in nested navigation
  //        : onSplitExit : Will be called when ever splitPop() will be called to perform any action
  //        : itemSelectedBeforeNavigation : Helps is deciding between pop-push & direct push
  Future<void> toSplitNamed(String splitRoute, {Function(dynamic)? onSplitExit, bool itemSelectedBeforeNavigation = false}) async {
    if(itemSelectedBeforeNavigation && JPScreen.isDesktop) {
      dynamic result = await Get.nestedKey(Get.currentRoute)?.currentState?.popAndPushNamed(
        splitRoute,
      );

      onSplitExit?.call(result);

    } else {
      dynamic result = await Get.nestedKey(Get.currentRoute)?.currentState?.pushNamed(
        splitRoute,
      );

      onSplitExit?.call(result);
    }
  }

  // splitPop(): Just like Get.back() but for view which is being used as split view
  void splitPop({bool? result}) async {
    if(Get.nestedKey(Get.currentRoute)?.currentState?.maybePop(result) == null) {
     back(result: result);
    }
  }

  // splitDialogPop(): Can be used for some of the dialogs
  void splitDialogPop() {
    Get.nestedKey(Get.currentRoute)?.currentState?.maybePop();
  }
}

