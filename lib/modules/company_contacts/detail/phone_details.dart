import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/message/index.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/font_weight.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_size.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';
import 'package:jp_mobile_flutter_ui/TextButton/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import 'controller.dart';

class CompanyContactsPhoneDetails extends StatelessWidget {
  CompanyContactsPhoneDetails({super.key});

  final contactsController = Get.put(CompanyContactViewController());
  final List<Widget> phoneDetails = [];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompanyContactViewController>(builder: (_) {
      int length = contactsController.companyContactView.phones?.length ?? 0;

      List<Widget> getPhoneList() {
        for (int i = 0; i < length; i++) {
          String ext = contactsController.companyContactView.phones![i].ext ?? '';
          
          String label = contactsController.companyContactView.phones![i].label ?? '';
          
          String number = contactsController.companyContactView.phones![i].number!;

          phoneDetails.add(
            Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: i == 0 ? 20: 16, bottom: (i + 1 == length) ? 20: 16),
              decoration: BoxDecoration(
                border: (i + 1 == length) ? null : Border(
                  bottom: BorderSide(color: JPAppTheme.themeColors.dimGray, width: 1)
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        JPText(
                          text: label.capitalize.toString(),
                          textColor: JPAppTheme.themeColors.tertiary,
                          textSize: JPTextSize.heading5,

                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 5,
                            children: [
                              JPText(
                                text: PhoneMasking.maskPhoneNumber(number),
                                fontWeight: JPFontWeight.medium,
                              ),
                              if(ext.isNotEmpty)
                              Wrap(
                                children: [
                                  JPText(
                                    text: 'Ext: ',
                                    textColor: JPAppTheme.themeColors.tertiary,
                                    fontWeight: JPFontWeight.medium,
                                  ),
                                  JPText(
                                    text: ext,
                                    fontWeight: JPFontWeight.medium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Material(
                        color: JPAppTheme.themeColors.base,
                        child: JPTextButton(
                          color: JPAppTheme.themeColors.primary,
                          onPressed: () {
                            Helper.launchUrl("tel://${number.trim()}");
                          },
                          icon: Icons.local_phone,
                          iconSize: 24,
                        ),
                      ),
                      const SizedBox(width: 10),
                      JPSaveMessageLog(
                        phone: number.trim(),
                        phoneModel: contactsController.companyContactView.phones![i],
                        contactModel: contactsController.companyContactView,
                      )
                    ],
                  )
                ],
              ),
            )
          );
        }

        return phoneDetails;
      }

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: JPAppTheme.themeColors.base
        ),
        child: Column(
          children: getPhoneList(),
        ),
      );
    });
  }
}
