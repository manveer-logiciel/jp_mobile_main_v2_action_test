import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/note_listing.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/note_actions/quick_actions.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/note_list_tile/index.dart';
import 'package:jobprogress/global_widgets/note_list_tile/note_list_shimmer.dart';
import 'package:jobprogress/global_widgets/secondary_header/index.dart';
import 'package:jobprogress/modules/job_note/listing/controller.dart';
import 'package:jobprogress/modules/job_note/listing/secondary_drawer.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobNoteList extends StatelessWidget {
  final JobNoteListingController controller;
  const JobNoteList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [         
      JPSecondaryHeader(
        customerId: controller.customerId,
        currentJob : controller.job,
        onJobPressed: controller.handleChangeJob,
        onTap: (){ controller.scaffoldKey.currentState!.openDrawer();}),  
        JobNoteSecondaryHeader(jobNoteController: controller),    
        controller.isLoading
            ? const NoteListingShimmmer(type: NoteListingType.jobNote)
            : controller.jobNoteList.isNotEmpty
                ? JPListView(
                    doAddFloatingButtonMargin: true,
                    listCount: controller.jobNoteList.length,
                    onLoadMore: controller.canShowLoadMore ? controller.loadMore : null,
                    onRefresh: controller.refreshList,
                    itemBuilder: (_, index) {
                      if (index < controller.jobNoteList.length) {
                        return NoteListTile(
                          key: ValueKey('${WidgetKeys.jobNoteListing}[$index]'),
                          noteList: controller.jobNoteList,
                          type: NoteListingType.jobNote,
                          noteItem: controller.jobNoteList[index],
                          index: index,
                          onLongPress: () {
                            if(AuthService.isPrimeSubUser()) return;
                            NoteService.openQuickActions(controller.jobNoteList[index], controller.handleQuickActionUpdate, NoteListingType.jobNote);
                          },
                          onTap: () {
                            NoteService.openNoteDetail(
                              note: controller.jobNoteList[index],
                              callback: controller.handleQuickActionUpdate,
                              type: NoteListingType.jobNote,
                              job: controller.job
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
