import 'package:flutter/material.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/email_editor/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/job/job_sale_automation_email_listing/controller.dart';
import 'package:jobprogress/modules/job/job_sale_automation_email_listing/shimmer.dart';
import 'package:jobprogress/modules/job/job_sale_automation_email_listing/tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobSaleAutomationEmailListing extends GetView<JobSaleAutomationEmailLisitingController> {
  const JobSaleAutomationEmailListing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobSaleAutomationEmailLisitingController>(
      builder: (_) {
        return 
        AbsorbPointer(
          absorbing: controller.buttonLoading,
          child: JPScaffold(
            scaffoldKey: controller.scaffoldKey,
            resizeToAvoidBottomInset: false,
            backgroundColor: JPAppTheme.themeColors.inverse,
            endDrawer: JPMainDrawer(
              onRefreshTap:controller.refreshPage,
            ),
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
              Get.back(result: controller.emailSentOrSkipped);
              },
            ),
            body: Stack(
              children: [
                if(controller.isDataLoaded)
                Visibility(
                  maintainState: controller.maintainWebViewState,
                  visible: false,
                  child: JPEmailEditor(editorController: controller.editorController)
                ),
                controller.isLoading ?
                const JobSaleAutomationEmailListingShimmer(): 
                JPSafeArea(
                  child:
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16, left: 16, right:16, bottom:7),
                        child: Row(
                          children: [
                            Expanded(
                              child: JPText(
                                textAlign: TextAlign.left,
                                text: '${'emails'.tr.capitalize!} - ${'workflow_automation'.tr}  (${'estimate'.tr.capitalize!})',
                                textSize: JPTextSize.heading3
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:16,right:16,bottom: 15),
                        child: JobNameWithCompanySetting(
                          textDecoration: TextDecoration.underline,
                          job: controller.job!,
                          textColor: JPAppTheme.themeColors.darkGray,
                        )
                      ),
                      if(!Helper.isValueNullOrEmpty(controller.templateList))...{
                        Expanded(
                          child: SingleChildScrollView(
                            controller: controller.scrollController,
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.only(bottom: 16), 
                            child:Column(
                              children: [
                                EmailAutomationTile(controller: controller),
                                
                              ],
                            ) 
                          )
                        )
                      } else...{
                        Expanded(
                          child: NoDataFound(
                            icon: JPScreen.isDesktop ? null : Icons.email,
                            title: 'no_email_found'.tr.capitalize,
                          ),
                        ),
                      },
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: JPResponsiveDesign.popOverButtonFlex,
                              child: JPButton(
                                disabled: controller.buttonLoading,
                                onPressed: controller.skippedEmail,
                                size: JPButtonSize.small,
                                text: '${'skip'.tr.toUpperCase()} ${'emails'.tr.toUpperCase()}',
                                colorType: JPButtonColorType.tertiary,
                              ),
                            ),
                            
                            if(!controller.hideSendButton && !Helper.isValueNullOrEmpty(controller.templateList))...{
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                flex: JPResponsiveDesign.popOverButtonFlex,
                                child: JPButton(
                                  disabled: controller.buttonLoading,
                                  suffixIconWidget: showJPConfirmationLoader(show: controller.buttonLoading),
                                  onPressed: controller.sendEmail,
                                  size: JPButtonSize.small,
                                  text: !controller.buttonLoading ? 'send'.tr.toUpperCase() : '' 
                                ),
                              )
                            }
                          ],
                        ),
                      )
                    ],
                  ),
                )    
              ]
            )
          ),
        );
      }
    );
  }
}