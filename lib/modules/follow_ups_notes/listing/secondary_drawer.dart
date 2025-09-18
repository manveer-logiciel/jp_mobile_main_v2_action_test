import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../global_widgets/single_field_shimmer/index.dart';
import 'controller.dart';

class FollowUpsNotesSecondaryHeader extends StatelessWidget {

  final FollowUpsNotesListingController followUpsNotesController;

  const FollowUpsNotesSecondaryHeader({super.key, required this.followUpsNotesController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top : 11, left: 16, bottom: 10, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Flexible(
          child: Row(
            children: [
              Flexible(
                child: JPText(
                  text: 'follow_ups'.tr.toUpperCase(),
                  fontWeight: JPFontWeight.medium,
                  textSize: JPTextSize.heading4,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              JPText(
                text: followUpsNotesController.followUpNoteListOfTotalLength == 0 ? '' : ' (${followUpsNotesController.followUpNoteListOfTotalLength})',
                fontWeight: JPFontWeight.medium,
                textSize: JPTextSize.heading4,
                textAlign: TextAlign.left,
              ), 
            ],
          ),
        ),
        if(followUpsNotesController.followUpNoteList.isNotEmpty) ...{

          followUpsNotesController.isReOpenRequest != null
              ? JPTextButton(
            onPressed: () =>
                followUpsNotesController.reOpenFollowup(
                    isReOpenRequest: followUpsNotesController.isReOpenRequest ??
                        false),
            text: followUpsNotesController.isReOpenRequest ?? false
                ? 'reopen_follow_up'.tr.toUpperCase()
                : 'close_follow_up'.tr.toUpperCase(),
            fontWeight: JPFontWeight.medium,
            textSize: JPTextSize.heading4,
            isDisabled: followUpsNotesController.isLoading,
            color: JPAppTheme.themeColors.primary,
          )
              : const JPSingleFieldShimmer(height: 14, width: 100,),
        }
       ],
      ),
    );
  }
}
