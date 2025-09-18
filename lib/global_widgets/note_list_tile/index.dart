import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/note_listing.dart';
import 'package:jobprogress/common/extensions/color/index.dart';
import 'package:jobprogress/common/models/note_list/note_listing.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/follow_ups_note.dart';
import 'package:jobprogress/core/constants/work_flow_stage_color.dart';
import 'package:jobprogress/core/utils/color_helper.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/global_widgets/user_list_for_popover/index.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class NoteListTile extends StatelessWidget {

  final List<NoteListModel> noteList;
  final NoteListModel noteItem;
  final int index;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final NoteListingType type;
  final bool canShowCount;
  final Color? noteColor;
  final Color? noteDateColor;
  final int? noteLimit;

  const NoteListTile({super.key,
    required this.noteList,
    required this.noteItem,
    required this.index,
    this.onTap,
    this.onLongPress,
    required this.type,
    this.canShowCount = true,
    this.noteColor,
    this.noteDateColor,
    this.noteLimit,
  });

  @override
  Widget build(BuildContext context) {

    Widget getWorkCrewCount() {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Material(
          color: noteItem.isSelected ? JPAppTheme.themeColors.primary : JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 30,
            height: 30,
            child: Center(
              child: JPText(
                textColor: noteItem.isSelected ? JPAppTheme.themeColors.base : JPAppTheme.themeColors.primary,
                text: (index + 1).toString(),
              ),
            ),
          ),
        )
      );
    }

    Widget getJobNoteProfilePic() {
      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: noteItem.createdBy!.profilePic!= null ? JPAvatar(
          child: JPNetworkImage(src: noteItem.createdBy!.profilePic)): 
        JPAvatar(
          backgroundColor: ColorHelper.getHexColor(noteItem.createdBy?.color ?? JPAppTheme.themeColors.tertiary.toHex()),
          child: JPText(text: noteItem.createdBy?.intial ?? '', textColor: JPAppTheme.themeColors.base),
        ),
      );
    }

    Widget getFollowUpIcons() {
      return JPAvatar(
        backgroundColor: ColorHelper.getHexColor(noteItem.createdBy?.color ?? JPAppTheme.themeColors.tertiary.toHex()),
        child:  noteItem.createdBy!.profilePic != null ?  
          JPNetworkImage(src: noteItem.createdBy!.profilePic) : 
          JPText(
            text:  noteItem.createdBy?.intial ?? '',
            textColor: JPAppTheme.themeColors.base
            )  
      );
    }
      
    Widget showImageOrCount(){
      switch(type) {
        case NoteListingType.workCrewNote:
          return getWorkCrewCount();

        case NoteListingType.jobNote: {
          return getJobNoteProfilePic();
        }
        case NoteListingType.followUpNote: {
          return getFollowUpIcons();
        }
      }
    }

    Widget getFollowUpText(){    
      Widget reminderWidget = JPText(
        text: FollowUpsNotesConstants.followupLabels[noteItem.mark].toString(), 
        textColor: FollowUpsNotesConstants.followupLabelColors[noteItem.mark],
        fontWeight: JPFontWeight.medium
      );
     
      if(noteItem.taskId != null){
          reminderWidget = Row(children: [
            reminderWidget,
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: JPText(text: 'with_reminder'.tr, fontWeight: JPFontWeight.medium),
            ),
            const SizedBox(width: 11),
            JPAvatar(
              size: JPAvatarSize.small,
              backgroundColor: JPAppTheme.themeColors.inverse,
              child:JPIcon(Icons.today_outlined, color: JPAppTheme.themeColors.tertiary, size: 14) 
            )
          ]);
      }

      return reminderWidget;
    }

    return Material(
      color: noteItem.isSelected ? JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.8) : JPAppTheme.themeColors.base,
      child: InkWell(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(left: canShowCount ? 16 : 0, top: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(canShowCount)
              Center(
                child: showImageOrCount()
              ),
              if(canShowCount)
              const SizedBox(width: 15),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: canShowCount ? 0 : 16, bottom: 12, right: 16 ),
                  decoration: BoxDecoration(
                    border: index == noteList.length - 1 ? null :  Border( bottom: BorderSide(width: 1, color:JPAppTheme.themeColors.dimGray, style: BorderStyle.solid))),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(type == NoteListingType.followUpNote)
                            getFollowUpText(),

                            JPRichText(
                              text: Helper.formatNote(noteItem.note.toString().trim(), noteItem.mentions, 'id', 'full_name', noteColor ?? JPAppTheme.themeColors.tertiary, JPTextSize.heading4, limit: noteLimit),
                              strutStyle:const StrutStyle(height: 1.4),
                              maxLines: Helper.isValueNullOrEmpty(noteLimit) ? 5 : null,
                              overflow: Helper.isValueNullOrEmpty(noteLimit) ? TextOverflow.ellipsis : TextOverflow.visible,
                              softWrap: true,
                              textAlign: TextAlign.start,
                            ),

                            if(noteItem.workCrew != null)
                            Wrap(
                              direction: Axis.horizontal,
                              children: [
                                for (var i = 0; i < noteItem.workCrew!.length; i++)
                                if (i < 5)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5, top: 6),
                                      child: JPChip(
                                        text: Helper.getWorkCrewName(noteItem.workCrew![i],byRoleName: true),
                                        child:JPProfileImage(
                                          src: noteItem.workCrew![i].profilePic,
                                          initial:noteItem.workCrew![i].intial ?? '',
                                          color:noteItem.workCrew![i].color ,
                                          )
                                      ),
                                    ),
                                    if (noteItem.workCrew!.length > 5)
                                    Padding(
                                        padding:const EdgeInsets.only(left: 10, top: 8),
                                        child: JPPopUpMenuButton(
                                          popUpMenuButtonChild: JPText(
                                            text: '+${noteItem.workCrew!.length - 5} ${'more'.tr}',
                                            textSize: JPTextSize.heading4,
                                            fontWeight: JPFontWeight.medium,
                                            textColor: JPAppTheme.themeColors.primary,
                                          ),
                                          childPadding: const EdgeInsets.only(
                                              left: 16, right: 16, top: 9, bottom: 9),
                                          itemList:noteItem.workCrew!.sublist(5),
                                          popUpMenuChild: (UserLimitedModel val) {
                                            return UserListItemForPopMenuItem(user: val);
                                          },
                                        )),
                              ],
                            ) ,
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if(noteItem.attachments != null && noteItem.attachments!.isNotEmpty)
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 6),
                                      child: JPIcon(Icons.attachment_outlined, color: JPAppTheme.themeColors.tertiary, size: 18),
                                    ),
                                  ),
                                  if(noteItem.stage != null)
                                  Flexible(
                                    child: JPText(
                                      text: noteItem.stage!.name.capitalize.toString(),
                                      textAlign: TextAlign.right,
                                      textSize: JPTextSize.heading5,
                                      fontWeight: JPFontWeight.medium,
                                      textColor: WorkFlowStageConstants.colors[noteItem.stage!.color],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if(type != NoteListingType.workCrewNote && noteItem.stage != null)
                                  Container(
                                    margin: const EdgeInsets.only(left: 5, right: 5),
                                    color: noteDateColor ?? JPAppTheme.themeColors.secondaryText,
                                    height: 10,
                                    width: 0.5
                                  ),
                                  JPText(
                                    text: DateTimeHelper.formatDate(noteItem.createdAt.toString(), DateFormatConstants.dateTimeFormatWithoutSeconds),
                                    textAlign: TextAlign.left,
                                    textSize: JPTextSize.heading5,
                                    textColor: noteDateColor ?? JPAppTheme.themeColors.secondaryText,
                                  ),
                              ]),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
