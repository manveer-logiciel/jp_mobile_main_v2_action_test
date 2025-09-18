import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/contact_view/notes_quick_actions.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../core/constants/date_formats.dart';
import '../../../core/utils/date_time_helpers.dart';
import 'controller.dart';

class CompanyContactsNotes extends StatelessWidget {
  CompanyContactsNotes({super.key});
  final contactsController = Get.put(CompanyContactViewController());

  @override
  Widget build(BuildContext context) {
    int length = contactsController.notes.length;

    Widget getNotesHeader(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            JPText(
              text: (contactsController.notesLength == 0) ? 'notes'.tr.toUpperCase() : '${'notes'.tr.toUpperCase()} (${contactsController.notesLength})',
              fontWeight: JPFontWeight.bold,
              textColor: JPAppTheme.themeColors.darkGray,
            ),
            JPButton(
              onPressed: () {
                contactsController.getAddNoteDialog();
              },
              colorType: JPButtonColorType.lightBlue,
              size: JPButtonSize.smallIcon,
              iconWidget: JPIcon(
                Icons.add,
                size: 18,
                color: JPAppTheme.themeColors.primary,
              ),
            )
          ],
        ),
      );
    }

    Widget getEmptyNote(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 20),
        child: Row(
          children: [
            JPRichText(
              text: JPTextSpan.getSpan(
                '${'tap_here'.tr} ',
                recognizer: TapGestureRecognizer()..onTap = () {
                  contactsController.getAddNoteDialog();
                },
                textColor: JPAppTheme.themeColors.primary,
                children: [
                  JPTextSpan.getSpan('to_create_a_note'.tr, textColor: JPAppTheme.themeColors.darkGray)
                ]
              ),
            )
          ],
        ),
      );
    }

    List<Widget> notes = [];

    List<Widget> getNotes() {
      for (int i = 0; i < length; i++) {
        notes.add(
          Material(
            borderRadius: i == length - 1 ? BorderRadius.circular(18) : null,
            color: JPAppTheme.themeColors.base,
            child: InkWell(
              borderRadius: i == length - 1 ? const BorderRadius.vertical(bottom: Radius.circular(18)) : null,
              onLongPress: () {
                ContactViewService.openQuickActions((value) {
                  contactsController.handleNotesQuickActions(value, i);
                });
              },
              child: Container(
                padding: EdgeInsets.only(top: i == 0 ? 15 : 10, left: 16, right: 16),
                decoration: BoxDecoration(
                  border: i == 0 ? null : Border(
                    top: BorderSide(color: JPAppTheme.themeColors.dimGray, width: 1)
                  )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    JPReadMoreText(
                      contactsController.notes[i].note ?? '',
                      textAlign: TextAlign.start,
                      dialogTitle: 'note_description'.tr,
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        JPText(
                          text: DateTimeHelper.formatDate(contactsController.notes[i].createdAt.toString(), DateFormatConstants.dateOnlyFormat),
                          textSize: JPTextSize.heading5,
                          textColor: JPAppTheme.themeColors.tertiary,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ),
          )
        );
      }

      return notes;
    }

    Widget getLoadMore() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Center(
          child: JPButton(
            text: 'load_more'.tr,
            iconWidget: contactsController.isLoadMore
                ? FadingCircle(color: JPAppTheme.themeColors.tertiary, size: 20)
                : null,
            size: JPButtonSize.mediumWithIcon,
            textColor: JPAppTheme.themeColors.tertiary,
            colorType: JPButtonColorType.lightGray,
            onPressed: () {
              contactsController.getLoadMore();
            },
          ),
        ),
      );
    }

    return GetBuilder<CompanyContactViewController>(builder: (_) {
      return Padding(
        padding: const EdgeInsets.only(bottom: JPResponsiveDesign.floatingButtonSize),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: JPAppTheme.themeColors.base,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getNotesHeader(context),
              (length == 0) ? const SizedBox( height: 10) : const SizedBox.shrink(),
      
              (length == 0) ? getEmptyNote(context) : const SizedBox.shrink(),
      
              Column(
                children: getNotes(),
              ),
      
              if (contactsController.canShowLoadMore)
                const SizedBox(
                  height: 25,
                ),
      
              if (contactsController.canShowLoadMore) getLoadMore(),
            ],
          ),
        ),
      );
    });
  }
}
