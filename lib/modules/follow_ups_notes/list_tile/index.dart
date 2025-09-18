import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/note_listing.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/note_actions/quick_actions.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/note_list_tile/index.dart';
import 'package:jobprogress/global_widgets/secondary_header/index.dart';
import 'package:jobprogress/modules/follow_ups_notes/listing/controller.dart';
import 'package:jobprogress/modules/follow_ups_notes/listing/secondary_drawer.dart';
import 'package:jobprogress/modules/follow_ups_notes/listing/shimmer.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class FollowUpsNotesListing extends StatelessWidget {
  final FollowUpsNotesListingController controller;
  const FollowUpsNotesListing({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [        
        JPSecondaryHeader(
          customerId: controller.customerId,
          currentJob : controller.job,
          onJobPressed: controller.handleChangeJob,
          onTap: (){ controller.scaffoldKey.currentState!.openDrawer();}),
          FollowUpsNotesSecondaryHeader(followUpsNotesController:controller),
          controller.isLoading
            ? const FollowUpsShimmer()
            : controller.followUpNoteList.isNotEmpty
                ? JPListView(
                    doAddFloatingButtonMargin: true,
                    listCount: controller.followUpNoteList.length,
                    onLoadMore: controller.canShowLoadMore ? controller.loadMore : null,
                    onRefresh: controller.refreshList,
                    itemBuilder: (_, index) {
                      if (index < controller.followUpNoteList.length) {
                        return NoteListTile(
                          noteList: controller.followUpNoteList,
                          type: NoteListingType.followUpNote,
                          noteItem: controller.followUpNoteList[index],
                          index: index,
                          onLongPress: () {
                            if(AuthService.isPrimeSubUser() || controller.isFollowUpCompleted(index)) return;
                            NoteService.openQuickActions(controller.followUpNoteList[index], controller.handleQuickActionUpdate, NoteListingType.followUpNote);
                          },
                          onTap: () {
                            NoteService.openNoteDetail(
                              note: controller.followUpNoteList[index],
                              callback: controller.handleQuickActionUpdate,
                              type: NoteListingType.followUpNote
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
                        return const SizedBox.shrink();
                      }
                    },
                  )
                : Expanded(
                    child: NoDataFound(
                      icon: Icons.contact_phone_outlined,
                      title: 'no_note_found'.tr.capitalize,
                    ),
                  )
      ],
    );
  }
}
