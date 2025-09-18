import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/extensions/scroll/no_scroll_physics.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/modules/chats/messages/controller.dart';
import 'package:jobprogress/modules/chats/messages/widgets/list_tile/date_tile.dart';
import 'package:jobprogress/modules/chats/messages/widgets/list_tile/index.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class MessagesList extends StatelessWidget {
  const MessagesList({super.key, required this.controller});

  final MessagesPageController controller;

  @override
  Widget build(BuildContext context) {

    if(controller.messagesList.isEmpty) {
      return NoDataFound(
        icon: Icons.chat_outlined,
        title: 'no_message_found'.tr.capitalize,
      );
    } else {
      return GestureDetector(
        onTap: Helper.hideKeyboard,
        child: ScrollConfiguration(
          behavior: NoScrollPhysics(),
          child: CustomScrollView(
            center: controller.centerKey,
            physics: const ClampingScrollPhysics(),
            controller: controller.scrollController,
            slivers: <Widget>[
              historyMessagesList,
              if (controller.messagesList.isNotEmpty) listSeparator,
              messagesList,
            ],
          ),
        ),
      );
    }
  }

  bool get isSeparatorVisible => controller.messagesList.first.unreadMessageSeparatorText != null
      && controller.historyMessagesList.isEmpty;

  Widget get loadingCircle => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FadingCircle(
            color: JPAppTheme.themeColors.primary,
            size: 25,
          ),
        ),
      );

  Widget get historyMessagesList => SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final showMessage = index < controller.historyMessagesList.length;
            final showLoader = index == controller.historyMessagesList.length && controller.canShowHistory;

            if (showMessage) {
              final data = controller.historyMessagesList[index];
              final isGroup = controller.service.groupData?.isGroup ?? false;
              final isLastMsg = index == controller.historyMessagesList.length - 1;

              return GroupMessage(
                isAutomated: controller.service.groupData?.isAutomated ?? false,
                isGroup: isGroup,
                data: data,
                isLastMsg: isLastMsg,
                onTapFile: controller.handleOnTapFile,
              );

            } else if (showLoader) {
              return loadingCircle;
            } else {
              return const SizedBox();
            }
          },
          addAutomaticKeepAlives: true,
          childCount: controller.historyMessagesList.length + 1,
        ),
      );

  Widget get messagesList => SliverList(
        key: controller.centerKey,
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {

          final doShowMessage = index < controller.messagesList.length;
          final doShowLoader = index == controller.messagesList.length && controller.canShowLoadMore;

            if (doShowMessage) {

              final isGroup = controller.service.groupData?.isGroup ?? false;
              final data = controller.messagesList[index];
              final isFirstMsg = index == 0 && controller.historyMessagesList.isEmpty;
              final isLastMsg = index == controller.messagesList.length - 1;

              return AutoScrollTag(
                index: index,
                controller: controller.scrollController,
                key: Key('$index'),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GroupMessage(
                      isAutomated: controller.service.groupData?.isAutomated ?? false,
                      isGroup: isGroup,
                      data: data,
                      isLastMsg: isFirstMsg,
                      onTapFile: controller.handleOnTapFile,
                      onTapTryAgain: () => controller.onTapTryAgain(index),
                      onTapCancel: () => controller.onTapCancel(index),
                    ),

                    if(isLastMsg)
                      const SizedBox(
                        height: 10,
                      ),
                  ],
                ),
              );
            } else if (doShowLoader) {
              return AutoScrollTag(
                index: index,
                controller: controller.scrollController,
                key: Key('$index'),
                child: loadingCircle,
              );
            } else {
              return const SizedBox();
            }
          },
          childCount: controller.messagesList.length + 1,
          addAutomaticKeepAlives: true,
        ),
      );

  Widget get listSeparator => SliverToBoxAdapter(
        child: SizedBox(
          width: double.maxFinite,
          child: isSeparatorVisible ? MessageDateTile(
                  date: controller.messagesList.first.updatedAt,
                )
              : const SizedBox(),
        ),
      );
}
