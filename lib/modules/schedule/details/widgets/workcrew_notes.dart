import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/event_form_type.dart';
import 'package:jobprogress/common/enums/note_listing.dart';
import 'package:jobprogress/common/models/note_list/note_listing.dart';
import 'package:jobprogress/common/services/note_actions/quick_actions.dart';
import 'package:jobprogress/global_widgets/note_list_tile/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../core/constants/assets_files.dart';

class ScheduleDetailWorkCrewNotes extends StatelessWidget {
  ScheduleDetailWorkCrewNotes({
    super.key,
    required this.workCrewNote,
    this.pageType,
    this.onSelect,
    this.onAdd,
    this.isDisabled = false,
  });

  final List<NoteListModel> workCrewNote;
  final EventFormType? pageType;
  final VoidCallback? onSelect;
  final VoidCallback? onAdd;
  final bool isDisabled;

  Widget getTitle(String title) {
    return JPText(
      text: title.toUpperCase(),
      fontWeight: JPFontWeight.medium,
      textColor: JPAppTheme.themeColors.darkGray,
    );
  }

  final List<Widget> workCrewNotes = [];

  List<Widget> getAllWorkCrewNotes() {
    if(workCrewNote.isEmpty && (pageType == EventFormType.editScheduleForm
        || pageType == EventFormType.createScheduleForm)) {
      workCrewNotes.add(
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: JPRichText(
            text: JPTextSpan.getSpan(
              "${'tap_here'.tr} ",
                recognizer: TapGestureRecognizer()..onTap = isDisabled ? () {} : (onAdd ?? () {}),
                textColor: JPAppTheme.themeColors.primary,
              children: [
                JPTextSpan.getSpan('to_add_note'.tr,
                  textColor: JPAppTheme.themeColors.darkGray
                )
              ]
            ),
          ),
        )
      );
    } else {
      for (int i = 0; i < workCrewNote.length; i++) {
        workCrewNotes.add(
          NoteListTile(
            noteItem: workCrewNote[i],
            index: i,
            noteList: workCrewNote,
            type: NoteListingType.workCrewNote,
            onLongPress: () {  },
            noteColor: JPAppTheme.themeColors.text,
            noteDateColor: JPAppTheme.themeColors.darkGray,
            onTap: () {
              NoteService.openNoteDetail(
                  note: workCrewNote[i],
                  callback: (_, __) {},
                  type: NoteListingType.workCrewNote
              );
            },
            canShowCount: false,
            noteLimit: 280,
          )
        );
      }
    }
    return workCrewNotes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: JPAppTheme.themeColors.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getTitle('work_crew_notes'.tr),
                Visibility(
                  visible: pageType == EventFormType.editScheduleForm
                      || pageType == EventFormType.createScheduleForm,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: JPButton(
                          onPressed: onSelect,
                          text: "select".tr.toUpperCase(),
                          size: JPButtonSize.extraSmall,
                          disabled: isDisabled,
                        ),
                      ),
                      JPButton(
                        onPressed: onAdd,
                        disabled: isDisabled,
                        colorType: JPButtonColorType.lightBlue,
                        size: JPButtonSize.smallIcon,
                        iconWidget: SvgPicture.asset(
                            AssetsFiles.addIcon,
                            width: 10,
                            height: 10,
                            colorFilter: ColorFilter.mode(
                                JPAppTheme.themeColors.primary,
                                BlendMode.srcIn
                            )
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Column(
            children: getAllWorkCrewNotes(),
          ),
        ],
      ),
    );
  }
}
