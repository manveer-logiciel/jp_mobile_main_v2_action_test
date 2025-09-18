import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/confirmation_dialog_type.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class EagleViewAuthErrorDialog extends StatelessWidget {
  final bool isAdmin = AuthService.isAdmin();
  final VoidCallback onTapLogin;
  EagleViewAuthErrorDialog({
    super.key,
    required this.onTapLogin
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: JPColor.transparent,
        child: JPConfirmationDialog(
            icon: Icons.error_outline_outlined,
            title: 'eagle_view_not_authenticated'.tr,
            type: isAdmin ? JPConfirmationDialogType.message : JPConfirmationDialogType.alert,
            prefixBtnColorType: JPButtonColorType.tertiary,
            prefixBtnText: isAdmin ? 'login'.tr.toUpperCase() : 'ok'.tr.toUpperCase(),
            suffixBtnText: 'cancel'.tr.toUpperCase(),
            onTapPrefix: () {
              Get.back();
              if(isAdmin) {
                onTapLogin.call();
              } else {
                Get.back();
              }
            },
            onTapSuffix: () {
              Get.back();
              Get.back();
            },
            content: JPText(
              text: isAdmin ? 'eagle_view_auth_error_admin_msg'.tr : 'eagle_view_auth_error_msg'.tr,
            )
        ),
      ),
    );
  }
}
