import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

class MessageListShimmer extends StatelessWidget {
  const MessageListShimmer({super.key, this.isGroup = true});

  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: JPAppTheme.themeColors.dimGray,
      highlightColor: JPAppTheme.themeColors.inverse,
      child: ListView.separated(
        reverse: true,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          return messagesList;
        },
        separatorBuilder: (_, index) {
          return dateSeparator();
        },
        itemCount: 3,
      ),
    );
  }

  Widget get messagesList => Column(
        children: [
          getOtherUserMessage(),
          getOtherUserMessage(width: 40),
          getOtherUserMessage(width: 50, height: 2),
          getMyMessage(width: 30),
          getMyMessage(width: 50, height: 2),
          getMyMessage(
            width: 40
          ),
        ],
      );

  Widget getOtherUserMessage({double height = 1, double width = 25}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isGroup) ...{
          Container(
            height: 30,
            width: 30,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: JPAppTheme.themeColors.inverse),
          ),
          const SizedBox(
            width: 12,
          ),
        },
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isGroup) ...{
                  Container(
                    width: 100,
                    height: 8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: JPAppTheme.themeColors.inverse,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                },
                Container(
                  height: height * 30,
                  width: JPScreen.width * (width / 100),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: JPAppTheme.themeColors.inverse,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 100,
        ),
      ],
    );
  }

  Widget getMyMessage({double height = 1, double width = 25}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(
          width: 100,
        ),
        Flexible(
          child: Container(
            height: height * 30,
            width: JPScreen.width * (width / 100),
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              color: JPAppTheme.themeColors.inverse,
            ),
          ),
        ),
      ],
    );
  }

  Widget dateSeparator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 25,
          width: 100,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: JPAppTheme.themeColors.inverse,
          ),
        ),
      ],
    );
  }
}
