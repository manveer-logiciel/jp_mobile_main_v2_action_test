import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/recurring_email.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/common/services/appointment/get_recuring.dart';
import 'package:jobprogress/modules/job/job_recurring_email/controller.dart';
import 'package:jobprogress/modules/job/job_recurring_email/widget/option_list/index.dart';
import 'package:jobprogress/modules/job/job_recurring_email/widget/scheduled_email/index.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';


class JobRecurringEmailTile extends StatelessWidget {
  const JobRecurringEmailTile({
  super.key, required this.controller, required this.index,
  });
  
  final JobRecurringEmailController controller;
  final int index;
  
  @override
  Widget build(BuildContext context) {
    RecurringEmailModel recurringEmail = controller.recurringEmail![index];
    return 
    Container(
      decoration: BoxDecoration(
        color: JPAppTheme.themeColors.base,
      ),
      padding: const EdgeInsets.only(left: 16, top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8,right: 5),
                padding: const EdgeInsets.all(6),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: JPAppTheme.themeColors.lightBlue
                ),
                child: Icon(
                  Icons.schedule_send_outlined,
                  color: JPAppTheme.themeColors.primary,
                  size: 18,
                ),
              ),
              if(recurringEmail.status == 'canceled')
                Positioned.fill(
                  child:
                  Align(
                    alignment: Alignment.topRight,
                    child:
                    Container(
                        height: 18,
                        width: 18,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                          color: JPAppTheme.themeColors.secondary,
                        ),
                        child: JPIcon(Icons.close_outlined, color: JPAppTheme.themeColors.base,size: 14)
                    ),
                  ),
                ),
              if(recurringEmail.status == 'closed')
                Positioned.fill(
                  child: Align(
                      alignment: Alignment.topRight,
                      child:JPIcon(Icons.check_circle, color: JPAppTheme.themeColors.success, size: 18)
                  ),
                ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(right: 16, bottom: 12),
              decoration:BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1,
                          color: JPAppTheme.themeColors.dimGray)
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0, top: 8),
                              child: Row(
                                children:[
                                  Flexible(
                                    child: JPText(
                                      textAlign: TextAlign.left,
                                      text: recurringEmail.subject!.capitalize!,
                                      fontWeight: JPFontWeight.medium,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  if(recurringEmail.attachments!.isNotEmpty)
                                    const JPIcon(Icons.attachment_outlined),
                                ],
                              ),
                            ),
                            if(recurringEmail.endStageCode!.isEmpty)
                              JPText(text: RecurringService.getRecOption(recurringEmail),textColor: JPAppTheme.themeColors.tertiary)
                            else
                            JPRichText(
                              text: JPTextSpan.getSpan(
                                RecurringService.getRecOption(recurringEmail) + ', ' + 'until'.tr + ' ' + 'completion'.tr + ' ' + 'on'.tr + ' ',
                                height: 1.523,
                                textColor: JPAppTheme.themeColors.tertiary,
                                children: [
                                  JPTextSpan.getSpan(
                                    controller.getStageName(stageCode: recurringEmail.endStageCode!, job:controller.job!),
                                    textColor: controller.getStageColor(stageCode: recurringEmail.endStageCode!, job:controller.job!),
                                  ),
                                  JPTextSpan.getSpan(
                                    ' ${'stage'.tr}',
                                    textColor: JPAppTheme.themeColors.tertiary
                                  )
                                ]
                              )),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: JPText(
                                text: controller.getStageName(stageCode: recurringEmail.currentStageCode!,job: controller.job!),
                              textColor:controller.getStageColor(stageCode: recurringEmail.currentStageCode!, job:controller.job!),
                            )) ,
                          ],
                        ),
                      ),
                      if(recurringEmail.status == 'in_process')
                        Material(
                          color: JPAppTheme.themeColors.base,
                          borderRadius:BorderRadius.circular(12),
                          child: JPPopUpMenuButton(
                            popUpMenuButtonChild: Padding(
                                padding: const EdgeInsets.all(8),
                                child: JPIcon(Icons.more_vert_outlined,color: JPAppTheme.themeColors.tertiary,size: 24,)
                            ),
                            itemList: [
                              PopoverActionModel(label: '${'cancel'.tr.capitalize!} ${'recurring'.tr.capitalize!}', value: 'cancel_recurring'),
                              PopoverActionModel(label: 'preview'.tr.capitalize!+' ' 'email'.tr.capitalize! , value: 'preview_email'),
                            ],
                            popUpMenuChild:(PopoverActionModel value) {
                              return JobRecurringEmailOptionsList(value: value.label);
                            },
                            onTap: (PopoverActionModel selected){
                              if(selected.value == 'cancel_recurring'){
                                controller.openCancelNotesDialog(recurringEmail.id!);
                              }
                              else{
                                controller.openEmailDetailView(recurringEmail.scheduleEmail![0].emailDetailId!);
                              }
                            },
                          ),
                        ),
                      if(recurringEmail.status != 'in_process')
                        Material(
                          color: JPAppTheme.themeColors.base,
                          child: JPTextButton(
                              onPressed: (){
                                controller.openEmailDetailView(recurringEmail.scheduleEmail![0].emailDetailId!);
                              },
                              icon: Icons.visibility_outlined,
                              color: JPAppTheme.themeColors.tertiary,
                              iconSize: 24
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 11),
                  ScheduleEmail(
                    controller: controller,
                    recurringEmail: recurringEmail,
                    index: index,
                  ),
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}