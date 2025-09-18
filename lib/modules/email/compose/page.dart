import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/snippet_trade_script.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/global_widgets/attachments_detail/index.dart';
import 'package:jobprogress/global_widgets/email_editor/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/email/compose/controller.dart';
import 'package:jobprogress/modules/email/compose/widgets/suggestion_list_tile.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/ChipsInput/index.dart';
import 'package:jp_mobile_flutter_ui/IconButton/index.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/ToolTip/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class EmailComposeView extends StatelessWidget {
  const EmailComposeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmailComposeController>(
        global: false,
        init: EmailComposeController(),
        builder: (EmailComposeController controller) {
          return JPWillPopScope(
            onWillPop: controller.saveValidateContent,
            child: JPScaffold(
              backgroundColor: JPAppTheme.themeColors.base,
              appBar: JPHeader(
                title: '${'compose'.tr.capitalize!} ${'email'.tr.capitalize!}',
                onBackPressed: controller.saveValidateContent,
                actions: [
                  if(controller.emailAction == FLModule.jobProposal)
                  JPTextButton(
                    onPressed: (){
                      controller.addProposalButton();
                    },
                    icon: Icons.add_link_outlined,
                    color: JPAppTheme.themeColors.base,
                    iconSize: 24,
                  ),
                  JPTextButton(
                    onPressed: () {
                      controller.editorController.removeFocus();
                      controller.openAttachmentSheet();
                    },
                    icon: Icons.attachment,
                    color: JPAppTheme.themeColors.base,
                    iconSize: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: JPTextButton(
                      onPressed: () {
                        controller.saveValidateContent(forSaveData: true);
                      },
                      icon: controller.isEdit ? Icons.done : Icons.send_outlined,
                      color: JPAppTheme.themeColors.base,
                      iconSize: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12, left: 8),
                    child: Material(
                      shape: const CircleBorder(),
                      color: JPAppTheme.themeColors.secondary,
                      clipBehavior: Clip.hardEdge,
                      child: JPPopUpMenuButton(
                          popUpMenuButtonChild: SizedBox(
                            height: 24,
                            width: 24,
                            child: JPIcon(
                              Icons.more_vert,
                              color: JPAppTheme.themeColors.base,
                            ),
                          ),
                          childPadding: const EdgeInsets.only(
                              left: 16, right: 16, top: 12, bottom: 12),
                          itemList: [
                            if(controller.emailAction !=  'sales_automation')
                            PopoverActionModel(
                                label: 'add_signature'.tr,
                                value: 'add_signature'),
                            PopoverActionModel(
                                label: '${'email'.tr.capitalize!} ${'templates'.tr.capitalize!}',
                                value: 'email_templates'),
                            PopoverActionModel(
                                label: 'snippets'.tr.capitalize!,
                                value: 'snippets'),
                            if(controller.emailAction == FLModule.jobProposal)
                              PopoverActionModel(
                                  label: 'thank_you_email'.tr,
                                  value: 'thank_you_email')
                          ],
                          popUpMenuChild: (PopoverActionModel val) {
                                return StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                      JPText(text: val.label),
                                      if(val.value == 'thank_you_email')
                                      JPToggle(
                                        value: controller.isThanksEmailActive,
                                        onToggle:(val){
                                          setState((){
                                            controller.toggleThankEmailbool(val);
                                          });
                                        
                                      })
                                    ],);
                                  }
                                );
                              },
                          onTap: (PopoverActionModel selected) {
                            controller.editorController.removeFocus();
                            switch (selected.value) {
                              case 'add_signature':
                                return controller.addUserSignature();
                              case 'email_templates':
                                return controller.openTemplateList();
                              case 'snippets':
                                Get.toNamed(Routes.snippetsListing, arguments: {'type': STArg.snippet});
                                break;
                            }
                          }
                          ),
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                controller: controller.scrollController,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: JPAppTheme.themeColors.base,
                        border: Border(
                          bottom: BorderSide(
                            width: 1.0,
                            color: JPAppTheme.themeColors.inverse
                          ),
                        ),
                      ),
                      child:
                      Visibility(
                        visible: controller.showCustomerField,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15,bottom: 15,right: 20),
                          child: 
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 10),
                                child: JPText(
                                  textColor: JPAppTheme.themeColors.tertiary,
                                  textSize: JPTextSize.heading5,
                                  text: '${controller.actionFromTitle} :'
                                ),
                              ),
                              Expanded(
                                child: JPText(
                                  overflow: TextOverflow.ellipsis,
                                  textSize: JPTextSize.heading5,
                                  textAlign: TextAlign.left,
                                  text: controller.actionFromDetail,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: controller.toVisibilty,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 1.0,
                                  color: JPAppTheme.themeColors.inverse),
                            ),
                            color: JPAppTheme.themeColors.base),
                        child: JPChipsInput(
                          saveChipData:(profile) => controller.addEmailInList('to',profile),
                          chipOnSpacePress: true,
                          validateEmail: controller.validateEmailFormat,
                          showCursor: controller.showCursor,
                          onPressed: controller.showCursorPointer,
                          selectedChips: const [],
                          removeOnBackSpace: (dynamic data){
                           controller.removeEmailInList('to', data); 
                          },
                          initialValue: controller.initialToValues,
                          key: controller.suggestionBuilderKey,
                          preffix: Padding(
                            padding: const EdgeInsets.only(top: 15, left: 16, right: 14),
                            child: JPText(
                              text: 'to'.tr.capitalize!,
                              textColor: JPAppTheme.themeColors.tertiary,
                              textSize: JPTextSize.heading5,
                            ),
                          ),
                          suffix: Padding(
                            padding: const EdgeInsets.only(top: 3, right: 9),
                            child: JPIconButton(
                              onTap: () {
                                controller.toggleCcBccVisibilty();
                              },
                              backgroundColor: JPAppTheme.themeColors.base,
                              iconSize: 24,
                              icon: controller.ccVisibilty
                                  ? Icons.expand_less_outlined
                                  : Icons.expand_more_outlined,
                              iconColor: JPAppTheme.themeColors.tertiary,
                            ),
                          ),
                          textStyle: TextStyle(
                              color: JPAppTheme.themeColors.text, fontSize: 12),
                          decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.only(top: 13, bottom: 10),
                              border: InputBorder.none),
                          suggestionBuilder: (context, state, dynamic profile) {
                            return EmailSuggestionListTile(
                              state: state,
                              profile: profile,
                              actionFrom: 'to',
                              controller: controller, 
                            );
                          },
                          chipBuilder: (context, state, dynamic profile) {
                            return JPToolTip(
                              message: profile.email,
                              child: JPChip(
                                text: profile.name,
                                backgroundColor: JPAppTheme.themeColors.dimGray,
                              
                                onRemove: () {
                                  state.deleteChip(profile);
                                  controller.removeEmailInList('to',profile);
                                },
                              )
                            );
                          },
                          onTypedChanged: (value) async {
                            if (value.length > 2) {
                              await controller.getSuggestionEmailData(value);
                              controller.setSuggestionEmailData(value);

                            }
                          },
                          onChanged: (data) {
                          },
                          findSuggestions: (String query) {
                            if (query.isNotEmpty && query.length > 2) {
                              return controller.suggestionList!;
                            } else {
                              return [];
                            }
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: controller.ccVisibilty,
                      child: Container(
                        decoration: BoxDecoration(
                          color: JPAppTheme.themeColors.base,
                          border: Border(
                            bottom: BorderSide(
                                width: 1.0,
                                color: JPAppTheme.themeColors.inverse),
                          ),
                        ),
                        child: JPChipsInput(
                          saveChipData: (profile) => controller.addEmailInList('cc',profile),
                          chipOnSpacePress: true,
                          validateEmail: controller.validateEmailFormat,
                          showCursor: controller.showCursor,
                          onPressed: controller.showCursorPointer,
                          removeOnBackSpace: (dynamic data){
                           controller.removeEmailInList('cc', data); 
                          },
                          initialValue:controller.initialCcValues,
                          onTypedChanged: (value) async {
                            if (value.length > 2) {
                              await controller.getSuggestionEmailData(value);
                              controller.setSuggestionEmailData(value);
                            }
                          },
                          preffix: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 16, right: 14),
                            child: JPText(
                              text: 'cc'.tr.capitalize!,
                              textColor: JPAppTheme.themeColors.tertiary,
                              textSize: JPTextSize.heading5,
                            ),
                          ),
                          suffix: !controller.bccVisibilty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, right: 14),
                                  child: JPTextButton(
                                    onPressed: () =>
                                        controller.toggleBccVisibilty(),
                                    text: 'bcc'.tr.capitalize!,
                                    color: JPAppTheme.themeColors.primary,
                                    textSize: JPTextSize.heading5,
                                  ),
                                )
                              : null,
                          textStyle: TextStyle(
                              color: JPAppTheme.themeColors.text, fontSize: 12),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.only(top: 13, bottom: 10),
                          ),
                          suggestionBuilder: (context, state, dynamic profile) {
                            return EmailSuggestionListTile(
                              state: state,
                              profile: profile,
                              actionFrom: 'cc',
                              controller: controller,
                            );
                          },
                          chipBuilder: (context, state, dynamic profile) {
                            return JPToolTip(
                              message: profile.email,
                              child: JPChip(
                                text: profile.name,
                                backgroundColor: JPAppTheme.themeColors.dimGray,
                                onRemove: () {
                                  state.deleteChip(profile);
                                  controller.removeEmailInList('cc', profile);
                                },
                              ),
                            );
                          },

                          onChanged: (data) {},
                          findSuggestions: (String query) {
                            if (query.isNotEmpty && query.length > 2) {
                              return controller.suggestionList!;
                            } else {
                              return [];
                            }
                          },
                        ),
                      ),
                    ),
                    if (controller.ccVisibilty && controller.bccVisibilty)
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: 1.0,
                                color: JPAppTheme.themeColors.inverse),
                          ),
                          color: JPAppTheme.themeColors.base,
                        ),
                        child: JPChipsInput(
                          saveChipData:(profile) => controller.addEmailInList('bcc',profile),
                          chipOnSpacePress: true,
                          validateEmail: controller.validateEmailFormat,
                          showCursor: controller.showCursor,
                          onPressed: controller.showCursorPointer,
                          removeOnBackSpace: (dynamic data){
                           controller.removeEmailInList('bcc', data); 
                          },
                          initialValue: controller.initialBccValues,
                          preffix: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 16, right: 14),
                            child: JPText(
                              text: 'bcc'.tr.capitalize!,
                              textColor: JPAppTheme.themeColors.tertiary,
                              textSize: JPTextSize.heading5,
                            ),
                          ),
                          onTypedChanged: (value) async {
                            if (value.length > 2) {
                              await controller.getSuggestionEmailData(value);
                              controller.setSuggestionEmailData(value);
                            }
                          },
                          textStyle: TextStyle(
                              color: JPAppTheme.themeColors.text, fontSize: 12),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.only(top: 13, bottom: 10),
                          ),
                          suggestionBuilder: (context, state, dynamic profile) {
                            return EmailSuggestionListTile(
                              state: state,
                              profile: profile,
                              controller: controller,
                              actionFrom: 'bcc',
                            );
                          },
                          chipBuilder: (context, state, dynamic profile) {
                            return JPToolTip(
                              message: profile.email,
                              child: JPChip(
                                text: profile.name,
                                backgroundColor: JPAppTheme.themeColors.dimGray,
                                onRemove: () {
                                  state.deleteChip(profile);
                                  controller.removeEmailInList('bcc', profile);
                                },
                              ),
                            );
                          },
                          onChanged: (data) {},
                          findSuggestions: (String query) {
                            if (query.isNotEmpty && query.length > 2) {
                              return controller.suggestionList!;
                            } else {
                              return [];
                            }
                          },
                        ),
                      ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: 1.0,
                                color: JPAppTheme.themeColors.inverse),
                          ),
                          color: JPAppTheme.themeColors.base,
                      ),
                      child: JPInputBox(
                          onPressed: controller.showCursorPointer,
                          showCursor: controller.showCursor,
                          controller: controller.subjectController,
                          fillColor: JPAppTheme.themeColors.base,
                          hintText: 'subject'.tr.capitalize,
                          textSize: JPTextSize.heading5,
                          type: JPInputBoxType.composeEmail,
                          onChanged: (value) {
                            controller.subject = value;
                          }),
                    ),
                    JPEmailEditor(
                      editorController: controller.editorController,
                      onFocus: controller.hideCursorPointer,
                    ),
                    Visibility(
                      visible: controller.canShowReplyForward,
                      child: JPEmailEditor(
                        editorController: controller.replyEditorController,
                        onFocus: controller.hideCursorPointer,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if(controller.attachments.isNotEmpty)
                      JPAttachmentDetail(
                        titleTextColor: JPAppTheme.themeColors.darkGray,
                        removeTitle: true,
                        attachments: controller.attachments,
                        iconColor: JPAppTheme.themeColors.secondary,
                        suffixIcon: Icons.close_outlined,
                        onTapSuffixIcon: controller.removeAttachment,
                      ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
