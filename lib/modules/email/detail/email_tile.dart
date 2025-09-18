import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/extensions/String/index.dart';
import 'package:jobprogress/common/services/email/quick_action.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/attachments_detail/index.dart';
import 'package:jobprogress/global_widgets/email_popup_menu_item/index.dart';
import 'package:jobprogress/global_widgets/in_app_web_view/index.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class EmailMessageTile extends StatelessWidget {
  const EmailMessageTile({
    super.key,
    required this.controller,
  });

  final EmailDetailController controller;

  @override
  Widget build(BuildContext context) {
    
    Widget getMessageTile(int i) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: JPColor.transparent,
            child: InkWell(
              splashColor: controller.emailDetail.length > 1 ? null : JPColor.transparent,
              highlightColor: controller.emailDetail.length > 1 ? null : JPColor.transparent,
              borderRadius: i == 0 ? const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)) : null,
              onTap: () {
                if(controller.emailDetail.length > 1) {
                  if(controller.emailDetail[i].actualHeight! > 1) {
                    controller.emailDetail[i].actualHeight = 1;
                  } else {
                    controller.emailDetail[i].actualHeight = controller.emailDetail[i].height;
                  }
                }
                controller.update();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child:JPAvatar(
                        size: JPAvatarSize.small,
                        backgroundColor: controller.avatarColor,
                        child: controller.emailDetail[i].type !='sent' || controller.emailDetail[i].createdBy!.profilePic==null ?
                        JPText(
                          text:  controller.emailDetail[i].from![0].toString().toUpperCase(),
                          textSize: JPTextSize.heading3,
                          textColor: JPAppTheme.themeColors.base,
                        ):
                        JPNetworkImage(src:controller.emailDetail[i].createdBy!.profilePic),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: JPText(
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    text:Helper.getEmailTo(controller.emailDetail[i].from!).capitalizeFirst! ,
                                    fontWeight: JPFontWeight.medium),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5,right:15),
                                  child: JPText(
                                    text:DateTimeHelper.formatDate(controller.emailDetail[i].updatedAt.toString(),'am_time_ago'),
                                    textSize: JPTextSize.heading5,
                                    fontWeight: JPFontWeight.medium,
                                    textColor: JPAppTheme.themeColors.secondaryText,
                                  ),
                                )
                              ],
                            ),
                            JPPopUpMenuButton(
                              offset: const Offset(-50,24),
                              itemList: const [1],
                              popUpMenuButtonChild: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 5.0),
                                      child: JPText(
                                        textAlign: TextAlign.left,
                                        text: '${'to_'.tr} ${controller.emailDetail[i].allEmails!}',
                                        overflow: TextOverflow.ellipsis,
                                        textColor: JPAppTheme.themeColors.tertiary,
                                        textSize: JPTextSize.heading5,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:  const EdgeInsets.only(bottom: 5),
                                    child :JPTextButton(
                                      icon: Icons.expand_more_outlined,
                                      color: JPAppTheme.themeColors.tertiary
                                    )
                                  )
                                ],
                              ),
                              popUpMenuChild:(int val) {
                                return EmailListPopup(emailDetail: controller.emailDetail, i: i, fromVisible: true,);
                              }
                            ),
                          ]
                        ),
                      ),
                    ),
                    JPTextButton(
                      onPressed: () {
                        EmailService.goToEmailCompose(controller.emailDetail[i], 'reply', controller.onEmailSent);
                      },
                      icon: Icons.reply,
                      color: JPAppTheme.themeColors.tertiary,
                      iconSize: 24,
                    ),
                    JPTextButton(
                      onPressed: () {
                        EmailService.openQuickActions(controller.emailDetail[i], controller.onEmailSent);
                      },
                      icon: Icons.more_vert_outlined,
                      color: JPAppTheme.themeColors.tertiary,
                      iconSize: 24,
                    )
                  ],
                ),
              ),
            ),
          ),
          if(controller.emailDetail[i].actualHeight == 1)
          Padding(
            padding: EdgeInsets.only(bottom: (!controller.isAllEmailOpen && i == 1) ? 10 : 20, right: 16, left: 16),
            child: JPText(
              text: TrimEnter(controller.emailDetail[i].parseHtmlContent!).trim(),
              textSize: JPTextSize.heading5,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              maxLine: 1,
            ),
          ),
          if(controller.emailDetail[i].htmlContent!.isNotEmpty)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.only(left: 16, right: 16),
              height: controller.emailDetail[i].actualHeight,
              width: MediaQuery.of(context).size.width,
              child: JPInAppWebView(
                height: controller.emailDetail[i].height!,
                content: controller.emailDetail[i].htmlContent!,
                disableContextMenu: false,
                callBackForHeight: (htmlHeightFixed) {
                  controller.emailDetail[i].height = htmlHeightFixed;
                  if(i == 0) {
                    controller.emailDetail[i].actualHeight = controller.emailDetail[i].height;
                  }
                  controller.update();
                },
              ),
            ),
          if(!(i == controller.emailDetail.length - 1 || (i == 1 && controller.emailDetail.length > 4 && !controller.isAllEmailOpen)))
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Divider(color: JPAppTheme.themeColors.dimGray, thickness: 1, height: 1),
          ),
        ],
      );
    }
                    
    List<Widget> getChildrens() {
      final children = <Widget>[];
      for (var i = 0; i < controller.emailDetail.length; i++) {
        children.add(
          Column(
            children: [
              if(controller.isAllEmailOpen || (i == 0 || i == 1 || i == controller.emailDetail.length - 1 || i == controller.emailDetail.length - 2))
              getMessageTile(i),
              if(i == 2 && controller.emailDetail.length > 4 && !controller.isAllEmailOpen)
              Material(
                color: JPColor.transparent,
                child: InkWell(
                  onTap: () {
                    controller.isAllEmailOpen = true;
                    controller.update();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Divider(color: JPAppTheme.themeColors.dimGray, height: 1, thickness: 1, indent: 30,),
                              const SizedBox(height: 10),
                              Divider(color: JPAppTheme.themeColors.dimGray, height: 1, thickness: 1, indent: 30),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: JPAppTheme.themeColors.inverse
                              ),
                              child: const JPIcon(Icons.unfold_more_outlined, size: 20,),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if(controller.emailDetail[i].attachments!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: JPAttachmentDetail(attachments: controller.emailDetail[i].attachments!, paddingLeft: 16)
              )
            ],
          )
        );
      }

      return children;
    }

    return Container(
      decoration:  BoxDecoration(
        borderRadius:const BorderRadius.all(Radius.circular(18)),
        color: JPAppTheme.themeColors.base,  
      ),
      child: Column(
        children: getChildrens(),
      )
    );       
  }
}

