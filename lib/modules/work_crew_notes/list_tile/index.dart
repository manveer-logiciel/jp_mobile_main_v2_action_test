import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/note_listing.dart';
import 'package:jobprogress/common/services/note_actions/quick_actions.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/note_list_tile/index.dart';
import 'package:jobprogress/global_widgets/note_list_tile/note_list_shimmer.dart';
import 'package:jobprogress/global_widgets/secondary_header/index.dart';
import 'package:jobprogress/modules/work_crew_notes/listing/controller.dart';
import 'package:jobprogress/modules/work_crew_notes/listing/secondary_drawer.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class WorkCrewNoteList extends StatelessWidget {
  final WorkCrewNotesListingController controller;
  const WorkCrewNoteList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: controller.canShowSecondaryHeader,
          child: JPSecondaryHeader(
            customerId: controller.customerId,
            currentJob : controller.job,
            onJobPressed: controller.handleChangeJob,
            onTap: controller.isInSelectMode ? null : () => controller.scaffoldKey.currentState!.openDrawer()),
        ),
        WorkCrewNotesSecondaryHeader(workCrewNoteController:controller),
        controller.isLoading
            ? const NoteListingShimmmer( type: NoteListingType.workCrewNote)
            : controller.workCrewNotesList.isNotEmpty
                ? JPListView(
                    doAddFloatingButtonMargin: true,
                    listCount: controller.workCrewNotesList.length,
                    onLoadMore: controller.canShowLoadMore ? controller.loadMore : null,
                    onRefresh: controller.refreshList,
                    itemBuilder: (_, index) {
                      if (index < controller.workCrewNotesList.length) {
                        return NoteListTile(
                          noteList: controller.workCrewNotesList,
                          type: NoteListingType.workCrewNote,
                          noteItem: controller.workCrewNotesList[index],
                          index: index,
                          onLongPress: () => controller.isInSelectMode
                            ? controller.selectNote(index)
                            : NoteService.openQuickActions(controller.workCrewNotesList[index], controller.handleQuickActionUpdate, NoteListingType.workCrewNote),
                         onTap: () {
                          NoteService.openNoteDetail(
                            note: controller.workCrewNotesList[index],
                            callback: controller.handleQuickActionUpdate,
                            type: NoteListingType.workCrewNote
                          );
                         }
                        );
                      } else if (controller.canShowLoadMore) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: FadingCircle(
                              size: 25,
                              color: JPAppTheme.themeColors.primary,
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox(height: JPResponsiveDesign.floatingButtonSize);
                      }
                    },
                  )
                : Expanded(
                    child: NoDataFound(
                      icon: Icons.notes_outlined,
                      title: 'no_note_found'.tr.capitalize,
                    ),
                  )
      ],
    );
  }
}
