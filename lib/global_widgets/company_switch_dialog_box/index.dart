import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/company/company.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/common/services/upload.dart';
import 'package:jobprogress/core/constants/mix_panel/event/view_events.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/company_switch_dialog_box/controller.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPCompanySwitcherDialogBox extends StatelessWidget {
  final bool isLoginPage;
  JPCompanySwitcherDialogBox({
    super.key,
    required this.isLoginPage,
  });
  final companySwitchController = Get.find<CompanySwitchController>();
  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      child: AbsorbPointer(
        absorbing: companySwitchController.isLoading,
        child: AlertDialog(
            insetPadding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(   
              padding: const EdgeInsets.only(top: 20,),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 13,
                      bottom: 8,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          JPText(
                            text: "select_company".tr,
                            fontWeight: JPFontWeight.medium,
                            textSize: JPTextSize.heading3,
                          ),
                          JPTextButton(
                            onPressed: () {
                              if (isLoginPage) {
                                Get.offNamedUntil(Routes.home, (route) => false);
                              } else {
                                Get.back();
                              }
                              MixPanelService.trackEvent(event: MixPanelViewEvent.companySwitchViewClose);
                            },
                            padding: 0,
                            color: JPAppTheme.themeColors.text,
                            icon: Icons.clear,
                            iconSize: 24,
                          ),
                        ]),
                  ),
                  Container(
                    constraints:BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.70),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: companySwitchController
                            .loggedInUser.allCompanies!.length,
                  
                        itemBuilder: (BuildContext context, int index) {
                          CompanyModel company = companySwitchController
                              .loggedInUser.allCompanies![index];
      
                          return GetBuilder<CompanySwitchController>(
                              builder: (controller) {
                            return InkWell(
                              key: ValueKey('${WidgetKeys.selectCompanyKey}[$index]'),
                              onTap: () async {
                                if (companySwitchController
                                        .loggedInUser.companyDetails!.id ==
                                    company.id) {
                                  if (isLoginPage) {
                                    Get.offNamedUntil(
                                        Routes.home, (route) => false);
                                  } else {
                                    Get.back();
                                  }
                                } else {
                                  await UploadService.pauseAllUploads();
                                  controller.switchCompany(company.id);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left:16.0,),
                                child: Row(
                                  children: [
                                   Container(
                                     decoration:const BoxDecoration(
                                       shape: BoxShape.circle,
                                       gradient: LinearGradient(colors:[
                                         Color(0xff418BCA),
                                         Color(0xff4178CA),
                                       ] 
                                       ),
                                     ),
                                     child: JPAvatar(
                                      size: JPAvatarSize.large,
                                      child: company.logo == null
                                        ? JPText(
                                            text: company.intial!,
                                            textColor: JPAppTheme.themeColors.base,
                                          )
                                        : JPNetworkImage(
                                            src: company.logo,
                                          )
                                      ),
                                   ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.only(bottom: 25,top: 25,right: 13),
                                        decoration:BoxDecoration(
                                          border:index!=companySwitchController.loggedInUser.allCompanies!.length-1? Border(
                                            bottom: BorderSide(
                                                color: JPAppTheme.themeColors.dimGray,
                                                width: 1,
                                            )
                                          ):null
                                        ),
                                        child: Row(
                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: JPText(
                                                textColor: companySwitchController
                                                            .loggedInUser
                                                            .companyDetails!
                                                            .id ==
                                                        company.id
                                                    ? JPAppTheme
                                                        .themeColors.primary
                                                    : null,
                                                maxLine: 2,
                                                textAlign: TextAlign.left,
                                                text: company.companyName,
                                                fontWeight: JPFontWeight.medium,
                                              ),
                                            ),
                                            if (companySwitchController.loggedInUser.companyDetails!.id ==company.id)
                                                JPIcon(Icons.done,color: JPAppTheme.themeColors.primary,)
                                            else
                                                const JPIcon(Icons.navigate_next),        
                                                                             
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                        }),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
