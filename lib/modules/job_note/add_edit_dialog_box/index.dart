import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/note_list/note_listing.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/common/services/note_actions/quick_actions.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/attachments_detail/index.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/modules/job_note/add_edit_dialog_box/controller.dart';
import 'package:jobprogress/modules/job_note/listing/controller.dart';
import 'package:jp_mobile_flutter_ui/FlutterMention/flutter_mentions.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../core/utils/color_helper.dart';
import '../../../global_widgets/network_image/index.dart';


class AddEditJobNoteDialogBox extends StatelessWidget {

  const AddEditJobNoteDialogBox({
    super.key,
    required this.jobModel,
    required this.controller,
    required this.dialogController,
    required this.jobId,
    this.isEdit = false,
    this.jobNote,
    this.onApply,
  });

  final JobNoteListingController controller;
  final JPBottomSheetController dialogController;
  final bool isEdit;
  final NoteListModel? jobNote;
  final int jobId;
  final JobModel? jobModel;
  final VoidCallback? onApply;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddEditJobNoteDialogBoxController>(
      init: AddEditJobNoteDialogBoxController(jobId, jobNote?.attachments ?? []),
      global: false,
      builder: (noteDialogController) {
        return JPSafeArea(
          child: GestureDetector(
            onTap:(){
              Helper.hideKeyboard();
            },
            child: AlertDialog(
              insetPadding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              contentPadding: const EdgeInsets.fromLTRB(0, 14, 0, 20),
              shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: SizedBox(
                width: Get.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          JPText(
                            text: isEdit ? jobModel?.parentId != null ?
                            'edit_project_note'.tr.toUpperCase() : 'edit_job_note'.tr.toUpperCase() : jobModel?.parentId != null ?
                            'add_project_note'.tr.toUpperCase() : 'add_job_note'.tr.toUpperCase(),
                            fontWeight: JPFontWeight.medium,
                            textSize: JPTextSize.heading3),
                          JPTextButton(
                            isDisabled: dialogController.isLoading,
                            onPressed: () {
                            controller.reset();
                            Get.back();
                          },
                          icon: Icons.close,iconSize: 24,),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20
                                ),
                                child: Form(
                                  key: controller.formKey,
                                  child: JPMention(
                                    defaultText: isEdit ? Helper.formatNote(jobNote!.note.toString().trim(), jobNote!.mentions, 'id', 'full_name', JPAppTheme.themeColors.tertiary, JPTextSize.heading5).toPlainText():'',
                                    validator: (value) {
                                          return controller.validateNote(value);
                                        },
                                      onChanged: (val) {
                                         if (controller.isValidate) {
                                            controller.validateNoteForm(controller.formKey);
                                          }
                                      },
                                    onMarkupChanged: (val) {
                                      controller.jobNotes = val;
                                    },
                                    getController:(val) {
                                     controller.noteController = val;
                                    } ,
                                    label: 'note'.tr,
                                    mentions: [
                                      Mention(
                                        markupBuilder: (trigger, markup, value) {
                                          return '$trigger[u:$markup]';
                                        },
                                        data:  NoteService.getSuggestionsList(jobModel),
                                        matchAll: false,
                                        suggestionBuilder: (data) {
                                          return  Column(
                                            key: ValueKey(data['id']),
                                            children: [
                                              const SizedBox(height: 8),
                                              Container(
                                                padding: const EdgeInsets.only(left: 15,right: 15),
                                                child: Row(
                                                  children: <Widget>[
                                                    JPAvatar(
                                                      size: JPAvatarSize.small,
                                                      borderWidth: data['photo'] != null ? 2 : 1,
                                                      borderColor: data['border_color'] != null ? ColorHelper.getHexColor(data['border_color']): JPAppTheme.themeColors.darkGray,
                                                      backgroundColor: data['border_color'] == null ? JPAppTheme.themeColors.darkGray : ColorHelper.getHexColor(data['border_color']),
                                                      child: data['photo'] != null ? JPNetworkImage(
                                                      src: data['photo'],
                                                      ):
                                                      JPText(
                                                        text: data['initial'].toString(),
                                                        textColor: JPAppTheme.themeColors.base,
                                                        textSize: JPTextSize.heading6
                                                      )
                                                    ),
                                                    const SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    Flexible(child: JPText(text:data['display'], overflow: TextOverflow.ellipsis)),
                                                    const SizedBox(width: 2),
                                                    JPText(text: data['suffix-text'],textSize: JPTextSize.heading5, textColor: JPAppTheme.themeColors.darkGray),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 8,),

                                            ],
                                          );
                                        }
                                      ),
                                    ],
                                    isRequired: true,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25,),
                              JPAttachmentDetail(
                                titleTextColor: JPAppTheme.themeColors.text,
                                attachments: noteDialogController.uploadedAttachments + noteDialogController.attachments,
                                disabled: dialogController.isLoading,
                                addCallback: noteDialogController.showFileAttachmentSheet,
                                onTapCancelIcon: noteDialogController.removeAttachment,
                                isEdit: true,
                                headerActions: [
                                  JPButton(
                                    onPressed: noteDialogController.showFileAttachmentSheet,
                                    colorType: JPButtonColorType.lightBlue,
                                    size: JPButtonSize.smallIcon,
                                    iconWidget: SvgPicture.asset(
                                        AssetsFiles.addIcon,
                                        width: 10,
                                        height: 10,
                                        colorFilter: ColorFilter.mode(
                                            JPAppTheme.themeColors.primary,
                                            BlendMode.srcIn)
                                    ),
                                  )
                                ],
                              ),
                              if((noteDialogController.uploadedAttachments + noteDialogController.attachments).isEmpty)...{
                                const SizedBox(height: 10,),
                              }
                            ],
                          ),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        top: 10
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: JPResponsiveDesign.popOverButtonFlex,
                            child: JPButton(
                              disabled: dialogController.isLoading,
                              onPressed: () {
                                controller.reset();
                                Get.back();
                              },
                               size: JPButtonSize.small,
                              text: 'cancel'.tr.toUpperCase(),
                              colorType: JPButtonColorType.lightGray
                            )
                          ),
                          const SizedBox(width: 15,),
                          Expanded(
                            flex: JPResponsiveDesign.popOverButtonFlex,
                            child: JPButton(
                              key: const Key(WidgetKeys.saveJobNoteBtnKey),
                              onPressed: () async {
                              controller.saveData(
                                  jobModel: jobModel,
                                  dialogController: dialogController,
                                  isEdit: isEdit,
                                  jobNote: jobNote,
                                  attachments: noteDialogController.attachments,
                                  deletedAttachments: noteDialogController.deletedAttachments,
                                  onApply: onApply
                              );
                              },
                              iconWidget: showJPConfirmationLoader(show: dialogController.isLoading),
                              disabled: dialogController.isLoading,
                              size: JPButtonSize.small,
                              text: dialogController.isLoading ?
                              '' : isEdit ? 'update'.tr.toUpperCase() :
                              'save'.tr.toUpperCase(),
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ),
          ),
        );
      }
    );
  }
}
