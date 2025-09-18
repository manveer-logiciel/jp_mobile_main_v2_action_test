import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/appointment/get_recuring.dart';
import 'package:jobprogress/core/constants/recurring_constant.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/email_popup_menu_item/index.dart';
import 'package:jobprogress/modules/job/job_sale_automation_email_listing/controller.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class EmailAutomationTile extends StatelessWidget {
  const EmailAutomationTile({super.key, required this.controller,});
  final JobSaleAutomationEmailLisitingController controller;
  
  @override
  Widget build(BuildContext context) {
    Widget getMessageTile(int i) {
      return Material(
        borderRadius:i == 0 ? 
          const BorderRadius.only(topLeft: Radius.circular(18), topRight:Radius.circular(18)): 
          i == controller.templateList.length-1 ?
          const BorderRadius.only(bottomLeft: Radius.circular(18), bottomRight:Radius.circular(18)):
          null,   
        child:InkWell(
          enableFeedback: false,
          borderRadius:i == 0 ? 
              const BorderRadius.only(topLeft: Radius.circular(18), topRight:Radius.circular(18)): 
              i == controller.templateList.length-1 ?
              const BorderRadius.only(bottomLeft: Radius.circular(18), bottomRight:Radius.circular(18)):null,
          onTap:controller.templateList[i].isApiRequestFailed == null ? 
            (){
              controller.getdataFromNextScreen(i);
            }: null,
          child: Padding(
            padding: i ==0 ? 
            const EdgeInsets.only(top: 8): 
            i== controller.templateList.length-1 ? 
            const EdgeInsets.only(top: 8) : 
            EdgeInsets.zero,
            child: Container(
              padding: const EdgeInsets.only(top:12,left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 9),
                    child: JPCheckbox(
                      disabled: controller.templateList[i].isApiRequestFailed != null,
                      borderColor: JPAppTheme.themeColors.themeGreen,
                      padding: EdgeInsets.zero,
                      selected: controller.templateList[i].isChecked,
                      onTap:(value){
                        controller.toggleIsChecked(i,controller.templateList);
                      }
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 12, right: 16, top: 3),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:BorderSide(
                          color: i != controller.templateList.length - 1 ?  JPAppTheme.themeColors.dimGray: JPAppTheme.themeColors.base
                          ),
                        )
                      ),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: JPText(
                                        text:controller.templateList[i].title!,
                                        textAlign: TextAlign.left,
                                    )),
                                    const SizedBox(width: 6),
                                    if(controller.templateList[i].attachments!.isNotEmpty)
                                    const JPIcon(Icons.attachment_outlined)
                                  ],
                                ),
                              ),
                              if(controller.templateList[i].isApiRequestFailed != null && controller.templateList[i].isApiRequestFailed == true)
                                JPIcon(
                                  Icons.cancel,
                                  color: JPAppTheme.themeColors.secondary,
                                ),
                              if(controller.templateList[i].isApiRequestFailed != null && controller.templateList[i].isApiRequestFailed == false)
                                JPIcon(
                                  Icons.check_circle,
                                  color: JPAppTheme.themeColors.success,
                                )
                            ],
                          ),
                          const SizedBox(height: 7),
                          JPText(
                            text: !Helper.isValueNullOrEmpty(controller.templateList[i].subject) ? controller.templateList[i].subject! : '- -',
                            textSize: JPTextSize.heading5,
                            textColor: JPAppTheme.themeColors.tertiary,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: 
                            Row(
                              children: [
                                JPText(
                                  text: '${'to'.tr}:  ',
                                  textColor: JPAppTheme.themeColors.tertiary,
                                ),
                                if(controller.templateList[i].to!.isEmpty)
                                JPText(
                                  text: '${'select'.tr.capitalize!} ${'email'.tr}',
                                  textColor: JPAppTheme.themeColors.primary,  
                                ),
                                if(controller.templateList[i].to!.isNotEmpty)
                                Flexible(
                                  child: JPPopUpMenuButton(
                                    offset: const Offset(0,24),
                                    itemList: const [1],
                                    popUpMenuButtonChild: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: JPText(
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            maxLine: 1,
                                            text: controller.getToEmails(i),
                                            textColor: JPAppTheme.themeColors.tertiary,
                                          ),
                                        ),
                                        JPTextButton(
                                          icon: Icons.expand_more_outlined,
                                          color: JPAppTheme.themeColors.tertiary
                                        )
                                      ],
                                    ),
                                    popUpMenuChild:(int val) {
                                      return EmailListPopup(emailDetail: controller.templateList,i:i,fromVisible: false);
                                    }
                                  ),
                                ),  
                              ],
                            ),
                          ),
                          if(controller.templateList[i].isChecked)...{
                            if(controller.templateList[i].isToEmpty || controller.templateList[i].isSubjectEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 7,bottom: 3),
                              child: JPText(
                                textAlign: TextAlign.left,
                                text: controller.validationMessage(i),
                                textColor: JPAppTheme.themeColors.red
                              ),
                            ),
                          },
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(   
                              borderRadius:BorderRadius.circular(8),
                              color: JPAppTheme.themeColors.inverse.withValues(alpha: 0.4),
                            ),  
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  JPText(text: 'repeat'.tr.capitalize!),
                                    JPToggle(
                                      disabled: controller.templateList[i].isApiRequestFailed != null,
                                      value: controller.templateList[i].isRepeatEnable, 
                                      onToggle: (value){
                                        controller.toggleRepeat(i);
                                      }
                                    ), 
                                  ],
                                ),
                                if(controller.templateList[i].isRepeatEnable)
                                Padding(
                                  padding: const EdgeInsets.only(top:10.0),
                                  child: Row(
                                    children: [
                                       Expanded(
                                         child:controller.templateList[i].recurringEmailData!.occurrence == RecurringConstants.jobEndStageCode ?
                                         JPRichText(
                                          text: 
                                          JPTextSpan.getSpan(
                                            RecurringService.getRecOption(controller.templateList[i].recurringEmailData),
                                            height: 1.4,
                                            textColor: JPAppTheme.themeColors.tertiary,
                                            textSize: JPTextSize.heading5,
                                            children: [
                                              JPTextSpan.getSpan(
                                                 ' ${'until'.tr} ${'completion'.tr} ${'on'.tr} ',
                                                textColor: JPAppTheme.themeColors.tertiary,
                                                textSize: JPTextSize.heading5
                                              ),
                                              JPTextSpan.getSpan(
                                                controller.getEndStageName(index: i,job: controller.job!,templateList: controller.templateList), 
                                                textColor: controller.getEndStageColor(index: i,job: controller.job!,templateList: controller.templateList),
                                                textSize: JPTextSize.heading5
                                              ),
                                              JPTextSpan.getSpan(
                                               ' ${'stage'.tr}', 
                                                textColor: JPAppTheme.themeColors.tertiary,
                                                textSize: JPTextSize.heading5
                                              )
                                            ]
                                          ),
                                        ):
                                        JPText(
                                          textAlign: TextAlign.left,
                                          textColor:JPAppTheme.themeColors.tertiary ,
                                          textSize: JPTextSize.heading5,
                                          text: RecurringService.getRecOption(controller.templateList[i].recurringEmailData)
                                       )),
                                       const SizedBox(width: 5),
                                        Material(
                                          color: JPColor.transparent,
                                          child: JPTextButton(
                                            highlightColor: JPAppTheme.themeColors.dimGray,
                                            onPressed: (){
                                              controller.openSaleAutomationBottomSheet(i);
                                          },
                                          color: JPAppTheme.themeColors.primary,
                                          icon: Icons.edit_outlined,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ), 
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
                    
    List<Widget> getChildrens() {
      final children = <Widget>[];
      for (var i = 0; i < controller.templateList.length; i++) {
        children.add(
          AutoScrollTag(
            controller: controller.scrollController,
            index: i,
            key: ValueKey(controller.templateList[i].id),
            child: getMessageTile(i)
          )
        );
      }
      return children;
    }

    return Column(
      children: getChildrens(),
    ); 
  }
}
