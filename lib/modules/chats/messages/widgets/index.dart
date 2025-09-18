import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/chats.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/twilio_status_banner/index.dart';
import 'package:jobprogress/modules/chats/messages/controller.dart';
import 'package:jobprogress/modules/chats/messages/widgets/list/index.dart';
import 'package:jobprogress/modules/chats/messages/widgets/shimmer.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'list/scroll_to_bottom.dart';

class MessagesView extends StatelessWidget {

  const MessagesView({
    super.key,
    required this.controller,
  });

  final MessagesPageController controller;

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      top: false,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                MessagesList(
                  controller: controller,
                ),
                Positioned(
                  bottom: 8,
                  right: 16,
                  child: MessagesScrollToBottom(
                    controller: controller,
                  ),
                ),
                if (controller.isLoading || controller.isInitialLoad) loader,
              ],
            ),
          ),

          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.doShowTwilioStatusBanner) ...{
                      JPTwilioStatusBanner(
                        status: controller.twilioTextStatus,
                      ),
                    } else ...{
                      textInput(),
                    },

                    if(controller.type != GroupsListingType.apiTexts) ...{
                      JPCheckbox(
                        selected: controller.sendAsEmail,
                        onTap: (val) {
                          controller.toggleSendAsEmail(!val);
                        },
                        disabled: !controller.isActiveParticipant,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        text: 'send_a_copy_as_email'.tr,
                        separatorWidth: 0,
                        textSize: JPTextSize.heading5,
                        borderColor: JPAppTheme.themeColors.themeGreen,
                      ),
                    } else ...{
                      const SizedBox(height: 16,),
                    }
                  ],
                ),
              ),
              if(controller.isSendingMessage)
                Positioned.fill(child: Container(color: JPColor.transparent,)),
            ],
          ),

        ],
      ),
    );
  }

  Widget get loader => Container(
        color: JPAppTheme.themeColors.base,
        child: MessageListShimmer(
          isGroup: controller.service.groupData?.isGroup ?? false,
        ),
      );


  bool get isInputBoxDisabled => !controller.isActiveParticipant || controller.isLoading || controller.messagesList.isEmpty || controller.isSendingMessage || controller.isCustomerOptedOut;

  String getDisabledHintText() {
    // Check if this is an automated conversation
    if (controller.service.groupData?.isAutomated == true) {
      return 'reply_to_automated_message_disabled'.tr;
    }
    return 'reply_to_message_disabled'.tr;
  }

  Widget textInput() => JPInputBox(
    controller: controller.messageController,
    disabled: isInputBoxDisabled,
    type: JPInputBoxType.searchbar,
    borderColor: isInputBoxDisabled ? JPAppTheme.themeColors
        .dimGray : JPAppTheme.themeColors.inverse,
    fillColor: isInputBoxDisabled ? JPAppTheme.themeColors
        .dimGray : JPAppTheme.themeColors.inverse,
    hintText: isInputBoxDisabled ? getDisabledHintText() : 'send_message'.tr,
    padding: const EdgeInsets.symmetric(
      vertical: 7,
    ),
    onPressed: () {
      controller.animateToBottom();
    },
    onChanged: (val) {
      controller.animateToBottom(
          duration: 50
      );
    },
    prefixChild: const SizedBox(),
    onTapSuffix: controller.sendMessage,
    maxLines: 4,
    autoGrow: true,
    suffixChild: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Material(
        color: JPAppTheme.themeColors.primary,
        shape: const CircleBorder(),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 32,
            width: 32,
            child: controller.isSendingMessage
                ? showJPConfirmationLoader(
                show: true,
                size: 10
            )
                : JPIcon(
              Icons.send_outlined,
              color: JPAppTheme.themeColors.base,
              size: 20,
            ),
          ),
        ),
      ),
    ),
  );
}
