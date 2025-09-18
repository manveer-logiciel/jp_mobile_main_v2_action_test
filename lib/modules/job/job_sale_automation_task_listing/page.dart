import 'package:flutter/material.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/task_tile/index.dart';
import 'package:jobprogress/modules/job/job_sale_automation_task_listing/controller.dart';
import 'package:jobprogress/modules/job/job_sale_automation_task_listing/shimmer.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class JobSaleAutomationTaskListing extends GetView<JobSaleAutomationTaskLisitingController> {
  const JobSaleAutomationTaskListing({Key? key}) : super(key: key);
  @override

  Widget build(BuildContext context) {
    return GetBuilder<JobSaleAutomationTaskLisitingController>(
      builder: (_) {
        return AbsorbPointer(
          absorbing: controller.buttonLoading,
          child: JPScaffold(
            scaffoldKey: controller.scaffoldKey,
            backgroundColor: JPAppTheme.themeColors.inverse,
            appBar: JPHeader(
              actions: [
                IconButton(
                  icon: const JPIcon(Icons.menu),
                  splashRadius: 20,
                  color: JPAppTheme.themeColors.text,
                  onPressed: () {
                    controller.scaffoldKey.currentState!.openEndDrawer();
                  },
                )
              ],
              backIconColor: JPAppTheme.themeColors.text,
              backgroundColor: JPAppTheme.themeColors.inverse,
              elevation: 0,
              onBackPressed:() {
                Get.back(result: controller.taskSentOrSkipped);
              },
            ),
            endDrawer: JPMainDrawer(
              onRefreshTap: controller.refreshPage,
            ),
            body:
            controller.isLoading ? const JobSaleAutomationTaskListingShimmer():
             JPSafeArea(
              child:
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16,left: 16,right:16,bottom: 7),
                    child: Row(
                      children: [
                        Expanded(
                          child: JPText(
                            textAlign: TextAlign.left,
                            text: '${'tasks'.tr.capitalize!} - ${'workflow_automation'.tr} (${'estimate'.tr.capitalize!})',
                            textSize: JPTextSize.heading3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(!Helper.isValueNullOrEmpty(controller.job))
                  Padding(
                    padding: const EdgeInsets.only(left:16,right:16,bottom: 15),
                    child: 
                    Row(
                      children: [
                        Flexible(
                          child: JPText(
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            text: controller.job?.customer?.fullName??'',
                            textColor: JPAppTheme.themeColors.darkGray,
                            textDecoration: TextDecoration.underline,
                          ),
                        ),
                        JPText(
                          textAlign: TextAlign.left,
                          text:' / ',
                          textColor: JPAppTheme.themeColors.darkGray,
                        ),
                        JPText(
                          textAlign: TextAlign.left,
                          text: Helper.getJobName(controller.job!),
                          textColor: JPAppTheme.themeColors.darkGray,
                          textDecoration: TextDecoration.underline,
                        ),
                      ],
                    ),
                  ),
                  if(!Helper.isValueNullOrEmpty(controller.taskList))...{
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller.scrollController,
                      padding: const EdgeInsets.only(bottom: 16), 
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:const BorderRadius.all(Radius.circular(18)),
                          color: JPAppTheme.themeColors.base,  
                        ),
                        child: Column(
                          children: [
                            for(int i = 0; i < controller.taskList.length; i++)
                            AutoScrollTag(
                              controller: controller.scrollController,
                              index: i,
                              key: ValueKey(controller.taskList[i].id),
                              child: DailyPlanTasksListTile(
                                isATemplate: true,
                                showBorder: i == controller.taskList.length-1 ? false : true,
                                checkValue: controller.taskList[i].isChecked,
                                onTapTask: () => 
                                controller.navigateToEditTask(index: i),
                                onTapCheckBox: (value){
                                  controller.toggleCheckBox(index: i,taskList: controller.taskList);
                                },
                                  showCheckBox:!controller.taskList[i].send,
                                  taskItem: controller.taskList[i]
                              ),
                            )
                          ],
                        ),
                      )  
                    )
                  ),
                  }else... {
                    Expanded(child: 
                      NoDataFound(
                        icon: Icons.task,
                        title: "no_task_found".tr.capitalize,
                      ),
                    )
                  },
                  
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: JPResponsiveDesign.popOverButtonFlex,
                          child: JPButton(
                            onPressed: controller.skipTask,
                            size: JPButtonSize.small,
                            text: '${'skip'.tr.toUpperCase()} ${'tasks'.tr.toUpperCase()}',
                            colorType: JPButtonColorType.tertiary,
                          ),
                        ),
                        if(!controller.hideSendButton && !Helper.isValueNullOrEmpty(controller.taskList))...{
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            flex: JPResponsiveDesign.popOverButtonFlex,
                            child: JPButton(
                              disabled: controller.buttonLoading,
                              suffixIconWidget: showJPConfirmationLoader(show: controller.buttonLoading),
                              onPressed: (){
                                controller.sendData();
                              },
                              size: JPButtonSize.small,
                              text: !controller.buttonLoading ? 'send'.tr.toUpperCase() : '',
                            ),
                          )
                        }
                      ],
                    ),
                  )
                ],
              ),
            )
          )
        );
      }
    );
  }
}