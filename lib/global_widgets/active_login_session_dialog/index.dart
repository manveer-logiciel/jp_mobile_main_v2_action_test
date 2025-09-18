import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/list.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/sub_header.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../core/utils/helpers.dart';

class ActiveLoginSessionDialog extends StatelessWidget {
  final List<JPMultiSelectModel> sessions;
  final int selectedItemCount;
  final VoidCallback onTapSelectAndClearAll;
  final Function(String) onTapItem;
  final VoidCallback onTapContinue;

  const ActiveLoginSessionDialog({
    super.key,
    required this.sessions,
    required this.onTapSelectAndClearAll,
    required this.onTapItem,
    required this.onTapContinue,
    this.selectedItemCount = 0
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: JPColor.transparent,
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: JPAppTheme.themeColors.base),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height - 180,
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: JPAppTheme.themeColors.lightBlue),
                            margin: const EdgeInsets.only(bottom: 15, top: 5),
                            padding: const EdgeInsets.all(4),
                            child: JPIcon(
                              Icons.info_outline,
                              size: 28,
                              color: JPAppTheme.themeColors.primary,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: JPText(
                              text: 'active_session_limit_reached'.tr,
                              textSize: JPTextSize.heading3,
                              fontWeight: JPFontWeight.medium,
                              fontFamily: JPFontFamily.montserrat,
                              textAlign: TextAlign.left
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: RichText(
                                text: JPTextSpan.getSpan('active_session_desc'.tr,
                                textSize: JPTextSize.heading4,
                                fontWeight: JPFontWeight.medium,
                                fontFamily: JPFontFamily.montserrat,
                                children: [
                                    const TextSpan(text: ' '),
                                    JPTextSpan.getSpan(
                                    '${'support'.tr.toLowerCase()}.',
                                    recognizer: TapGestureRecognizer()..onTap = () => Helper.launchUrl(CommonConstants.leapSupportUrl),
                                    textColor: JPAppTheme.themeColors.primary,
                                    textDecoration: TextDecoration.underline
                                    )
                                ]
                            ))
                          ),
                          if(_isAnyHighlighted())
                            Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    const JPIcon(Icons.warning_outlined, color: JPColor.red),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: JPText(
                                        text: 'active_login_session_highlight'.tr,
                                        textSize: JPTextSize.heading4,
                                        fontWeight: JPFontWeight.medium,
                                        fontFamily: JPFontFamily.montserrat,
                                        textAlign: TextAlign.left,
                                        textColor: JPColor.red,
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                                  children: [
                                    JPMultiSelectSubHeader(
                                      mainListLength:  sessions.length,
                                      listLength: sessions.length,
                                      canShowClearAll: sessions.length > 1,
                                      selectedItemCount: selectedItemCount,
                                      selectAndClearAll: onTapSelectAndClearAll,
                                      canShowCount: sessions.length > 1,
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxHeight: JPScreen.height * 0.2
                                      ),
                                      child: JPMultiSelectList(
                                        list: sessions,
                                        onItemTap: onTapItem,
                                        controller: ScrollController(),
                                      ),
                                    ),
                                  ],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: JPButton(
                    text: 'end_session_continue'.trParams({
                      's': selectedItemCount > 1 ? 's' : ''
                    }).toUpperCase(),
                    textColor: JPAppTheme.themeColors.base,
                    size: JPButtonSize.flat,
                    colorType: JPButtonColorType.primary,
                    onPressed: () {
                      Get.back();
                      onTapContinue.call();
                    },
                    disabled: selectedItemCount == 0,
                  ),
                ),
                const SizedBox(
                  height: 10
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: JPButton(
                    text: 'cancel'.tr.toUpperCase(),
                    textColor: JPAppTheme.themeColors.tertiary,
                    size: JPButtonSize.flat,
                    colorType: JPButtonColorType.lightGray,
                    onPressed: Get.back<void>,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

  bool _isAnyHighlighted() {
    for (var session in sessions) {
      if (session.isHighlighted) {
        return true;
      }
    }
    return false;
  }
}
