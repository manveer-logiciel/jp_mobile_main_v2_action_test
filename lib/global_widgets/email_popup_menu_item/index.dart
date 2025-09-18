import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class EmailListPopup extends StatelessWidget {
  const EmailListPopup({
    super.key,
    required this.emailDetail, 
    required this.i, 
    required this.fromVisible,
  });

  final dynamic emailDetail;
  final int i;
  final bool fromVisible;

  @override
  Widget build(BuildContext context) {
    JPTextSize textSize = JPTextSize.heading5;

    return Container(
      padding: const EdgeInsets.only(left: 15, top: 15, right: 10),
      child: Column(
        children: [
          if(fromVisible)
          Container(
            padding: const EdgeInsets.only(bottom: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 45,
                  child: JPText(
                    text: '${'from'.tr}:',
                    textAlign: TextAlign.left,
                    textSize: textSize,
                    textColor: JPAppTheme.themeColors.darkGray
                  ),
                ),
                Expanded(
                  child: JPText(
                    textSize: textSize,
                    text: emailDetail[i].from!,
                    textAlign: TextAlign.left,
                    textColor:JPAppTheme.themeColors.tertiary
                  )
                ),
              ],
            ),
          ),
          if(emailDetail[i].to!.isNotEmpty)
          Container(
            padding: const EdgeInsets.only(bottom: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 45,
                  child: JPText(
                    text: '${'to'.tr.capitalize}:',
                    textAlign: TextAlign.left,
                    textSize: textSize,
                    textColor: JPAppTheme.themeColors.darkGray
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      for (var index = 0; index < emailDetail[i].to!.length; index++)
                      Container(
                        padding:  EdgeInsets.only(bottom:index == emailDetail[i].to!.length-1? 0:6),
                        child: Row(
                          children: [
                            Expanded(
                              child: JPText(
                                textSize: textSize,
                                text: emailDetail[i].to![index],
                                textAlign: TextAlign.left,
                                textColor:JPAppTheme.themeColors.tertiary
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if(!Helper.isValueNullOrEmpty(emailDetail[i].cc))
          Container(
            padding: const EdgeInsets.only(bottom: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 45,
                  child: JPText(
                    text: '${'cc'.tr.capitalize}:',
                    textAlign: TextAlign.left,
                    textColor: JPAppTheme.themeColors.darkGray,
                    textSize: textSize,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      for (var index = 0; index < emailDetail[i].cc!.length; index++)
                      Container(
                        padding:  EdgeInsets.only(bottom:index == emailDetail[i].cc!.length-1 ? 0:6),
                        child: Row(
                          children: [
                            Expanded(
                              child: JPText(
                                text: emailDetail[i].cc![index],
                                textAlign: TextAlign.left,
                                textSize: textSize,
                                textColor:JPAppTheme.themeColors.tertiary
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if(!Helper.isValueNullOrEmpty(emailDetail[i].bcc))
          Container(
            padding: const EdgeInsets.only(bottom: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 45,
                  child: JPText(
                    text: '${'bcc'.tr.capitalize}:    ',
                    textAlign: TextAlign.left,
                    textSize: textSize,
                    textColor: JPAppTheme.themeColors.darkGray
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      for (var index = 0; index < emailDetail[i].bcc!.length; index++)
                      Container(
                        padding:  EdgeInsets.only(bottom:index == emailDetail[i].bcc!.length-1? 0:6),
                        child: Row(
                          children: [
                            Expanded(
                              child: JPText(
                                text: emailDetail[i].bcc![index],
                                textAlign: TextAlign.left,
                                textSize: textSize,
                                textColor:JPAppTheme.themeColors.tertiary
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]
      ),
    );
  }
}
