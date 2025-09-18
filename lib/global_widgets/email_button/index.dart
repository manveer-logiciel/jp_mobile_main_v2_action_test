import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/email_button_type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'contoller.dart';

class JPEmailButton extends StatelessWidget {
  const JPEmailButton({
    super.key, this.jobId, this.type, this.email,  this.fullName, this.customerId, this.contactId, this.actionFrom
  });

  final String? email;
  final String? fullName;
  final int? jobId;
  final int? customerId;
  final int? contactId;
  final String? type;
  final String? actionFrom;


  Widget textIcon(EmailButtonController controller) {
    return Expanded(
      child: Material(
        color: JPAppTheme.themeColors.base,
        child: InkWell(
          onTap:(() =>  controller.tapHandle(
            contactId: contactId,
            actionFrom: actionFrom,
            customerId: customerId,
            jobId: jobId,
            email: email,
            fullName: fullName
          )),      
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                JPIcon(
                  Icons.email, 
                  color: JPAppTheme.themeColors.primary
                ),
                const SizedBox(height: 3),
                JPText(
                  text: 'email'.tr,
                  textAlign: TextAlign.start,
                  textSize: JPTextSize.heading5,
                  textColor: JPAppTheme.themeColors.primary
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget simpleIcon(EmailButtonController controller) {
    return Row(
      children: [
        Material(
          color: JPAppTheme.themeColors.base,
          child: JPTextButton(
            color: JPAppTheme.themeColors.primary,
            onPressed:(() =>  controller.tapHandle(
            contactId: contactId,
            customerId: customerId,
            jobId: jobId,
            actionFrom: actionFrom,
            email: email,
            fullName: fullName
          )),
            icon: Icons.email,
            iconSize: 24,
          ),
        ),
      ],
    );
  }
  Widget iconInAvtar(EmailButtonController controller){
    return Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: email!.isNotEmpty ? JPAppTheme.themeColors.primary : JPAppTheme.themeColors.primary.withValues(alpha: 0.3)
      ),
      child: Material(
        color:JPColor.transparent,
        child: JPTextButton(
          iconSize: 24,
          onPressed:(){
            email!.isNotEmpty?
            controller.tapHandle(
              contactId: contactId,
              customerId: customerId,
              actionFrom: actionFrom,
              jobId: jobId,
              email: email,
              fullName: fullName
            ):null;
          },      
          icon:Icons.email,
          color: JPAppTheme.themeColors.base,
        ),
      ),
    );
  }

  Widget textButton(EmailButtonController controller){
    return JPButton(
      text: 'email'.tr.toUpperCase(),
      type: JPButtonType.outline,
      size: JPButtonSize.extraSmall,
      textSize: JPTextSize.heading6,
      onPressed:(() =>  controller.tapHandle(
        contactId: contactId,
        customerId: customerId,
        jobId: jobId,
        email: email,
        actionFrom: actionFrom,
        fullName: fullName
      )),      
    );
  }
  
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmailButtonController());
    switch(type){
      case EmailButtonType.iconWithText:
      return textIcon(controller);
      case EmailButtonType.iconInAvtar:
      return iconInAvtar(controller);
      case EmailButtonType.textButton:
      return textButton(controller);
      default:
      return simpleIcon(controller);
    }
  }
}
