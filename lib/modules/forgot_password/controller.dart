import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import '../../common/repositories/forgot_password.dart';
import '../../core/constants/urls.dart';
import '../../core/utils/helpers.dart';
import '../../routes/pages.dart';

class ForgotPasswordController extends GetxController {

  final GlobalKey<FormState> forgotPasswordKey = GlobalKey();
  final GlobalKey<FormState> forgotPasswordButtonKey = GlobalKey();

  final TextEditingController emailController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  bool isLoading = false;
  bool isValidate = false;

  bool validateForm() => forgotPasswordKey.currentState?.validate() ?? false;

  //This function check and move sign in button above keyboard
  void scrollRecoverPasswordBtnAboveKeyboard() async{

    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Getting position of sign in button
    RenderBox? box = getRenderObject(forgotPasswordButtonKey);
    if(box == null) return;
    Offset position = box.localToGlobal(Offset.zero);

    // Getting area that will be visible on keyboard
    double viewPortHeight = scrollController.position.viewportDimension;
    double difference = position.dy - viewPortHeight + box.size.height;

    // Condition confirms whether button is behind
    if (difference > 0) {
      double scrollPosition = difference + scrollController.offset + 45; // 45 is difference between keyboard and recover password button
      scrollController.animateTo(scrollPosition, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
    }
  }

  RenderBox? getRenderObject(GlobalKey key) {
    if(key.currentContext == null) return null;
    return key.currentContext!.findRenderObject() as RenderBox?;
  }

  Future<void> recoverPassword() async {
    try {
      if(validateForm()) {
        Helper.hideKeyboard();
        showJPLoader();

        await callRecoverPasswordApi();
      } else {
        isValidate = true;
      }
    } catch (e) {
      Get.back();
      rethrow;
    }
  }

  bool onChangeEmail(String value) {
    if(isValidate) {
      validateForm();
    }
    return isValidate;
  }

  Future<void> callRecoverPasswordApi() async {
    try {
      String email = emailController.text.trim();
      final Map<String, dynamic> param = {
        'email': email,
        'url': Urls.resetPasswordUrl
      };
      final Map<String, dynamic> response = await ForgotPasswordRepository.recoverPassword(param);
      Get.back();
      Helper.showToastMessage(response['message']);

      if(response['status'] == 200) {
        Get.offNamed(Routes.resetPasswordLinkSent);
      }
    } catch(e) {
      rethrow;
    }
  }

}