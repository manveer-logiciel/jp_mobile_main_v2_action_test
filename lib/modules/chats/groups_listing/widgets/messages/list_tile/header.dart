
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobprogress/core/utils/firebase/firestore.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ChatsMessageTileHeader extends StatelessWidget {
  const ChatsMessageTileHeader({
    super.key,
    required this.title,
    required this.time,
  });

  /// title to display group title
  final String title;

  /// time to display time details
  final Timestamp time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 2,
        bottom: 5
      ),
      child: Row(
        children: [
          Expanded(
            child: JPText(
              text: title,
              fontWeight: JPFontWeight.medium,
              maxLine: 1,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          JPText(
            text: FirestoreHelpers.getMessageTime(time),
            maxLine: 1,
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.secondaryText,
          ),
        ],
      ),
    );
  }
}
