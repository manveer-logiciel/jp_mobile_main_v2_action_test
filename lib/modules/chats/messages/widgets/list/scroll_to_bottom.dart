import 'package:flutter/material.dart';
import 'package:jobprogress/modules/chats/messages/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MessagesScrollToBottom extends StatelessWidget {
  const MessagesScrollToBottom({
    super.key,
    required this.controller
  });

  final MessagesPageController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.isScrollToBottomVisible,
      builder: (_, bool isVisible, Widget? child) {
        return Visibility(
          visible: isVisible,
          child: child!,
        );
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 5,
                right: 5
            ),
            child: Material(
              color: JPAppTheme.themeColors.tertiary,
              shape: const CircleBorder(),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: controller.jumpToBottom,
                child: SizedBox(
                  height: 28,
                  width: 28,
                  child: JPIcon(
                    Icons.keyboard_double_arrow_down,
                    color: JPAppTheme.themeColors.base,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 2,
            child: ValueListenableBuilder(
              valueListenable: controller.unreadNewMessageCount,
              builder: (_, int val, child) {

                if(val <= 0) {
                  return const SizedBox();
                }

                return Container(
                  constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16
                  ),
                  decoration: BoxDecoration(
                    color: JPAppTheme.themeColors.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4
                      ),
                      child: JPText(
                        text: controller.unreadNewMessageCount.value.toString(),
                        textColor: JPAppTheme.themeColors.base,
                        textSize: JPTextSize.heading6,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
