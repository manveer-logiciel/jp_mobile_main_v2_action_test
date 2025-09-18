import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/note_list/note_listing.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/FlutterMention/flutter_mentions.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../core/utils/color_helper.dart';
import '../../../core/utils/helpers.dart';
import '../../../global_widgets/network_image/index.dart';
import '../../../routes/pages.dart';
import 'controller.dart';


class AddEditWorkCrewNoteDialogBox extends StatelessWidget {
  const AddEditWorkCrewNoteDialogBox({
    super.key,
    required this.companyCrewList,
    required this.subcontractorList,
    required this.dialogController,
    required this.jobId,
    required this.onFinish,
    required this.suggestionList,
    this.note,
    required this.isEdit, 
  });
  
  final JPBottomSheetController dialogController;
  final NoteListModel? note;
  final List<Map<String, dynamic>> suggestionList;
  final List<JPMultiSelectModel> companyCrewList;
  final List<JPMultiSelectModel> subcontractorList;
  final bool isEdit;
  final int jobId;
  final Function(NoteListModel noteListModel) onFinish;

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: GetBuilder<AddEditWorkCrewNoteDialogController>(
          init: AddEditWorkCrewNoteDialogController(
            companyCrewList: companyCrewList, subcontractorList: subcontractorList,
            jobId: jobId, note: note, onFinish: onFinish, suggestionList: suggestionList,isEdit: isEdit),
          global: false,
          builder: (controller) => AlertDialog(
            insetPadding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            contentPadding: const EdgeInsets.all(20),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: SizedBox(
              width: Get.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: JPText(
                          text:isEdit ? 'edit_work_crew_note'.tr.toUpperCase() : 'add_work_crew_note'.tr.toUpperCase(),
                          fontWeight: JPFontWeight.medium,
                          textSize: JPTextSize.heading3,
                          overflow: TextOverflow.ellipsis,
                      ),
                      ),
                      const SizedBox(width: 10,),
                      Row(
                        children: [
                          JPButton(
                              text: 'snippet'.tr,
                            type: JPButtonType.outline,
                            size: JPButtonSize.extraSmall,
                            onPressed: () {
                              Transition.circularReveal;
                              Get.toNamed(Routes.snippetsListing, preventDuplicates: false);
                            },
                          ),
                          const SizedBox(width: 10,),
                          JPTextButton(
                            isDisabled: dialogController.isLoading,
                            onPressed: () => controller.reset(),
                            icon: Icons.close,
                            iconSize: 24,)
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Form(
                            key: controller.formKey,
                            child: JPMention(
                              defaultText: isEdit? Helper.formatNote(note!.note.toString().trim(), note!.mentions, 'id', 'full_name', JPAppTheme.themeColors.tertiary, JPTextSize.heading5).toPlainText() : '',
                              validator: (value) {
                                return controller.validateNote(value);
                              },
                              onChanged: (val) {
                                if (controller.isValidate) {
                                  controller.validateNoteForm(controller.formKey);
                                }
                              },
                              onMarkupChanged: (val) {
                                controller.notes = val;
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
                                    data: controller.suggestionList,
                                    matchAll: false,
                                    suggestionBuilder: (data) {
                                      return  Column(
                                        children: [
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.only(left: 15,right: 15),
                                            child: Row(
                                              children: <Widget>[
                                                JPAvatar(
                                                    size: JPAvatarSize.small,
                                                    borderWidth: data['photo'] != null? 2 : 1,
                                                    borderColor: data['border_color'] != null ? ColorHelper.getHexColor(data['border_color']) : JPAppTheme.themeColors.darkGray,
                                                    backgroundColor:  data['border_color'] == null ? JPAppTheme.themeColors.darkGray : ColorHelper.getHexColor(data['border_color']),
                                                    child:data['photo'] != null ? JPNetworkImage(
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
                                                const SizedBox(width: 2,),
                                                JPText(text: data['suffix-text'], textSize: JPTextSize.heading5, textColor: JPAppTheme.themeColors.darkGray,),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 8,)
                                        ],
                                      );
                                    },
                                ),
                              ],
                              isRequired: true,
                            ),
                          ),
                          const SizedBox(height: 25,),
                          JPInputBox(
                            label: "company_crew".tr,
                            controller: controller.companyCrewController,
                            type: JPInputBoxType.withLabel,
                            fillColor: JPAppTheme.themeColors.base,
                            readOnly: true,
                            hintText: 'select'.tr,
                            onPressed: controller.showCompanyCrewSelectionSheet,
                            suffixChild: const Padding(
                              padding: EdgeInsets.only(right: 9),
                              child: JPIcon(Icons.keyboard_arrow_down),
                            ),
                          ) ,
                          const SizedBox(height: 25,),
                          JPInputBox(
                            controller: controller.subController,
                            label: '${'labour'.tr} / ${'sub'.tr}',
                            type: JPInputBoxType.withLabel,
                            fillColor: JPAppTheme.themeColors.base,
                            readOnly: true,
                            hintText: 'select'.tr,
                            onPressed: controller.showLabourAndSubSelectionSheet,
                            suffixChild: const Padding(
                              padding: EdgeInsets.only(right: 9),
                              child: JPIcon(Icons.keyboard_arrow_down),
                            ),
                          ) ,
                          const SizedBox(height: 25,),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: JPResponsiveDesign.popOverButtonFlex,
                          child: JPButton(
                              onPressed: ()=> controller.reset(),
                              disabled: dialogController.isLoading,
                              size: JPButtonSize.small,
                              text: 'cancel'.tr.toUpperCase(),
                              colorType: JPButtonColorType.lightGray
                          )
                      ),
                      const SizedBox(width: 15,),
                      Expanded(
                          flex: JPResponsiveDesign.popOverButtonFlex,
                          child: JPButton(
                              onPressed: () async{
                                if (!controller.validateNoteForm(controller.formKey)) {
                                  controller.isValidate = true;
                                  return;
                                }
                                controller.isValidate = false;
                                controller.formKey.currentState!.save();
                                FocusManager.instance. primaryFocus?.unfocus();
                                dialogController.toggleIsLoading();

                                if(isEdit) {
                                  await controller.addEditCompanyContactNotes(note: note,isEdit: true);
                                } else {
                                  await controller.addEditCompanyContactNotes();
                                }

                                dialogController.toggleIsLoading();
                              },
                              iconWidget: showJPConfirmationLoader(show: dialogController.isLoading),
                              disabled: dialogController.isLoading,
                              size: JPButtonSize.small,
                              text: dialogController.isLoading ?
                              '' : isEdit ? 
                              'update'.tr.toUpperCase() : 
                              'save'.tr.toUpperCase())),
                    ],
                  )
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}
