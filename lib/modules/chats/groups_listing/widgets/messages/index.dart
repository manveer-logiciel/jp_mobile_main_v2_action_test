
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/firebase/firestore/chat_group.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/modules/chats/groups_listing/controller.dart';
import 'package:jobprogress/modules/chats/groups_listing/widgets/messages/list_tile/index.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class GroupsThreadList extends StatefulWidget {
  const GroupsThreadList({
    super.key,
    required this.groups,
    required this.onLoadMore,
    required this.canShowLoadMore,
    required this.onTapGroup,
    required this.onLongPressGroup,
    this.selectedGroupId,
    required this.controller,
    this.showAutomatedPill = false,
  });

  final List<ChatGroupModel> groups;

  final Future<void> Function() onLoadMore;

  final bool canShowLoadMore;

  final Function(String, Widget) onTapGroup;

  final bool showAutomatedPill;

  final Function(int) onLongPressGroup;

  final String? selectedGroupId;

  final GroupsListingController controller;

  @override
  State<GroupsThreadList> createState() => GroupsThreadListState();
}

class GroupsThreadListState extends State<GroupsThreadList> {

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return JPListView(
        scrollController: scrollController,
        doAddFloatingButtonMargin: true,
        listCount: widget.groups.length,
        padding: EdgeInsets.only(
          top: 6,
          bottom: Get.mediaQuery.viewPadding.bottom
        ),
        onLoadMore: widget.onLoadMore,
        itemBuilder: (_, index) {
          if(index < widget.groups.length) {

            bool isSelected = widget.selectedGroupId != null && widget.selectedGroupId == widget.groups[index].groupId;

            return GroupThreadTile(
              index: index,
              data: widget.groups[index],
              onTapGroup: widget.onTapGroup,
              onLongPressGroup: widget.onLongPressGroup,
              isSelected: isSelected && JPScreen.isDesktop,
              showAutomatedPill: widget.showAutomatedPill,
            );
          } else if(widget.canShowLoadMore){
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FadingCircle(
                  color: JPAppTheme.themeColors.primary,
                  size: 25,
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
    );
  }

  Future<void> scrollToTop() async {
    await scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  void jumpToTop() {
    scrollController.jumpTo(0);
  }
}
