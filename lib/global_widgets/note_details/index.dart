import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/note_listing.dart';
import 'package:jobprogress/common/models/note_list/note_listing.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/work_flow_stage_color.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/attachments_detail/index.dart';
import 'package:jobprogress/global_widgets/note_details/controller.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/global_widgets/user_list_for_popover/index.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../common/models/job/job.dart';

class NoteDetail extends StatelessWidget {
  const NoteDetail({super.key, required this.note, this.callback, required this.type, this.job});

  final NoteListModel note;
  final Function(NoteListModel, String)? callback;
  final NoteListingType type;
  final JobModel? job;

  @override
  Widget build(BuildContext context) {
    final NoteDetailController controller = Get.put(NoteDetailController(type));
    controller.note = note;
    controller.callback = callback;


    String showTitle(){
      switch(type) {
        case NoteListingType.workCrewNote:
          return 'work_crew_note_detail'.tr;

        case NoteListingType.jobNote: {
          return job?.parentId != null ? 'project_note_detail'.tr : 'job_note_detail'.tr;
        }
        case NoteListingType.followUpNote: {
          return 'follow_up_detail'.tr;
        }
      }
    }

    return Wrap(
      children: [
        GetBuilder<NoteDetailController>(
            builder: (_) {
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: JPAppTheme.themeColors.base,
                borderRadius: JPResponsiveDesign.bottomSheetRadius,
            ),
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.only(left: 20, right: 20,top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Flexible(
                             child: Padding(
                               padding: const EdgeInsets.only(top: 5),
                               child: JPText(
                                 text: showTitle().toUpperCase(),
                                 textSize: JPTextSize.heading3,
                                 fontWeight: JPFontWeight.medium,
                                 textAlign: TextAlign.left,
                               ),
                             ),
                           ),
                          Material(
                            color: JPAppTheme.themeColors.base,
                            child: JPTextButton(
                              color: JPAppTheme.themeColors.text,
                              icon: Icons.clear,
                              iconSize: 22,
                              onPressed: (){
                                Get.back();
                              },
                            ),
                          )
                          ],
                    )),
                Container(
                  width: MediaQuery.of(context).size.width,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(note.task != null)
                          Column(
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              Padding(
                                 padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    JPText(text: 'title'.tr),
                                    const SizedBox(height: 5),
                                    JPText(
                                      text: note.task!.title,
                                      textColor: JPAppTheme.themeColors.tertiary,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if(note.task != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start, 
                             children: [                               
                                const SizedBox(height: 15),
                                JPText(text: 'assigned_to'.tr),
                                const SizedBox(height: 5),
                                JPText(
                                  text: note.task!.participants!.map((e) => e.fullName).join(', '),
                                  height: 1.4,
                                  textAlign: TextAlign.left,
                                  textColor: JPAppTheme.themeColors.tertiary
                                ),
                             ],
                            ),
                          ),
                          if(note.task != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, 
                              children: [                                
                                const SizedBox(height: 15),
                                JPText(text: 'due_date'.tr),
                                const SizedBox(height: 5),
                                JPText(
                                  text: DateTimeHelper.convertHyphenIntoSlash(controller.note.task!.dueDate!.toString()),
                                  textColor: JPAppTheme.themeColors.tertiary
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              JPText(text: 'note'.tr),
                              const SizedBox(height: 2),
                              JPRichText(
                                text: Helper.formatNote(note.note.toString().trim(), note.mentions, 'id', 'full_name', JPAppTheme.themeColors.tertiary, JPTextSize.heading4),
                                strutStyle:const StrutStyle(height: 1.4),
                              ),
                            ]),
                          ),
                          if(type == NoteListingType.workCrewNote)
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [                              
                                const SizedBox(height: 15),
                                JPText(text: 'work_crew'.tr ),
                                  const SizedBox(height: 5),
                                  note.workCrew != null && note.workCrew!.isNotEmpty ? 
                                Wrap(
                                  runSpacing: 5.0,
                                  direction: Axis.horizontal,
                                  children: [
                                    for (int i = 0; i < note.workCrew!.length; i++)
                                    if (i < 5)  
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: JPChip(
                                        text: Helper.getWorkCrewName(note.workCrew![i],byRoleName: true),
                                        child:JPProfileImage(src: note.workCrew![i].profilePic,color: note.workCrew![i].color,initial:note.workCrew![i].intial ?? '') 
                                       ),
                                    ),
                                    if (note.workCrew!.length > 5)
                                    Padding(
                                        padding:const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
                                        child: Material(
                                          child: JPPopUpMenuButton(
                                            popUpMenuButtonChild: JPText(
                                              text: '+${note.workCrew!.length - 5}${' ' 'more'.tr}',
                                              textSize: JPTextSize.heading4,
                                              fontWeight: JPFontWeight.medium,
                                              textColor: JPAppTheme.themeColors.primary,
                                            ),
                                            childPadding: const EdgeInsets.only(
                                                left: 16, right: 16, top: 9, bottom: 9),
                                            itemList:note.workCrew!.sublist(5),
                                            popUpMenuChild: (UserLimitedModel val) {
                                              return UserListItemForPopMenuItem(user: val);
                                            },
                                          ),
                                      )),
                                  ],
                                ) :
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: JPText(text: 'unassigned'.tr, textColor: JPAppTheme.themeColors.tertiary,)
                                ),
                            ],
                        ),
                          ),
                        
                        if(type != NoteListingType.workCrewNote)                             
                        const SizedBox(height: 15),
                        if(type != NoteListingType.workCrewNote && note.stage != null) 
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              JPText(text: 'stage'.tr,),
                              const SizedBox(height: 5),
                              JPText(
                                text: note.stage!.name.capitalize.toString(),
                                textAlign: TextAlign.left,
                                textColor: WorkFlowStageConstants.colors[note.stage!.color],
                              ),
                            ]),
                          ),
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                JPText(text: 'created_on'.tr),
                                const SizedBox(height: 5),
                                Wrap(
                                  children: [
                                  JPText(
                                    text: DateTimeHelper.formatDate(note.createdAt.toString(), DateFormatConstants.dateTimeFormatWithoutSeconds),
                                    textAlign: TextAlign.left,
                                    textColor: JPAppTheme.themeColors.tertiary,
                                  ),
                                  if(note.createdBy != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5, right: 5),
                                    child: JPText(
                                      text: 'by'.tr.capitalize.toString(),
                                      textColor: JPAppTheme.themeColors.tertiary,
                                    ),
                                  ),
                                  if(note.createdBy != null)
                                  JPText(
                                    text: note.createdBy!.fullName,
                                    textColor: JPAppTheme.themeColors.tertiary
                                  ),
                                  ]),
                            ]),
                          ),
                                                            
                          if(note.attachments != null && note.attachments!.isNotEmpty)
                          Column(
                            children: [
                              const SizedBox(height: 15),
                              JPAttachmentDetail(
                                attachments: controller.note.attachments!,
                                iconColor: JPAppTheme.themeColors.tertiary,
                                titleFontWeight: JPFontWeight.regular,
                                titleText: 'attachment'.capitalize,
                                tileTextColor: JPAppTheme.themeColors.tertiary,
                              ),
                            ],
                          ),
                        const SizedBox( height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
