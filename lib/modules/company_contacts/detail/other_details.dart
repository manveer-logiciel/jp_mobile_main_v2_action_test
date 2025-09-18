import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/email_button/index.dart';
import 'package:jobprogress/core/utils/location_helper.dart';
import 'package:jp_mobile_flutter_ui/Chip/index.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/font_weight.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_size.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';
import 'package:jp_mobile_flutter_ui/TextButton/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import 'controller.dart';

class CompanyContactsOtherDetails extends StatelessWidget {
  CompanyContactsOtherDetails({super.key});

  final contactsController = Get.put(CompanyContactViewController());

  @override
  Widget build(BuildContext context) {
    final List<Widget> emailDetails = [];

    int emailLength = contactsController.companyContactView.emails?.length ?? 0;
    int tagsLength = contactsController.companyContactView.tags?.length ?? 0;
    String company = contactsController.companyContactView.companyName ?? '';

    List<Widget> getEmailList() {
      for (int i = 0; i < emailLength; i++) {
        emailDetails.add(
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: i == 0 ? 20: 16, bottom: contactsController.address.isEmpty ? 20 : 16),
            decoration: BoxDecoration(
              border: i == 0 ? null : Border(
                top: BorderSide(color: JPAppTheme.themeColors.dimGray, width: 1)
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
                        text: 'email'.tr,
                        textColor: JPAppTheme.themeColors.tertiary,
                        textSize: JPTextSize.heading5,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        child: JPText(
                          text: contactsController.companyContactView.emails![i].email,
                          fontWeight: JPFontWeight.medium,
                          textAlign: TextAlign.left,
                        ),
                      )
                    ],
                  ),
                ),
                JPEmailButton(
                  contactId: int.parse(contactsController.contactId),
                  fullName: contactsController.fullName,
                  email:contactsController.companyContactView.emails![i].email)
              ],
            ),
          ),
        );
      }

      return emailDetails;
    }

    Widget getAddress() {
      if (contactsController.address.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.only(left: 16, right: 16, top:16, bottom: company.isEmpty ? 20 : 16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: JPAppTheme.themeColors.dimGray, width: 1)
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
                    text: 'address'.tr,
                    textColor: JPAppTheme.themeColors.tertiary,
                    textSize: JPTextSize.heading5,
                  ),
            
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: JPText(
                          text:  contactsController.address,
                          fontWeight: JPFontWeight.medium,
                          maxLine: 10,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                  ),
                ]),
            ),
            JPTextButton(
                    color: JPAppTheme.themeColors.primary,
                    onPressed: () {
                      LocationHelper.openMapBottomSheet(
                        query: contactsController.address
                      );
                    },
                    icon: Icons.location_on,
                    iconSize: 24,
                  ),
          ],
        ),
      );
    }

    Widget getCompany() {
      if (company.isEmpty) {
        return const SizedBox.shrink();
      }
      return Container(
        padding: EdgeInsets.only(left: 16, right: 16, top:16, bottom: company.isEmpty ? 20 : 16),
        decoration:  (contactsController.address.isNotEmpty || contactsController.emailList.isNotEmpty) ? BoxDecoration(
          border: Border(
            top: BorderSide(color: JPAppTheme.themeColors.dimGray, width: 1)
          )
        ): null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JPText(
                    text: 'company'.tr,
                    textColor: JPAppTheme.themeColors.tertiary,
                    textSize: JPTextSize.heading5,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: JPText(
                            text: company,
                            textAlign: TextAlign.left,
                            fontWeight: JPFontWeight.medium,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }

    List<Widget> chips = [];
    List<Widget> getChips() {
      for (int i = 0; i < tagsLength; i++) {
        chips.add(Padding(
          padding: const EdgeInsets.only(right: 10, top: 5),
          child: JPChip(
            text: contactsController.companyContactView.tags![i].name,
            textColor: JPAppTheme.themeColors.tertiary,
          ),
        ));
      }
      return chips;
    }

    Widget getGroups() {
      if (tagsLength == 0) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 20),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: JPAppTheme.themeColors.dimGray, width: 1)
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
                    text: 'groups'.tr,
                    textColor: JPAppTheme.themeColors.tertiary,
                    textSize: JPTextSize.heading5,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    child: Wrap(
                      runSpacing: 5,
                      children: getChips(),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }

    return GetBuilder<CompanyContactViewController>(builder: (_) {
      bool canSetBottomMargin = contactsController.address.isEmpty && tagsLength == 0 && company.isEmpty && emailLength == 0;
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: JPAppTheme.themeColors.base
        ),
        margin: EdgeInsets.only(bottom: canSetBottomMargin ? 0 : 20),
        child: Column(
          children: [
            Column(
              children: getEmailList(),
            ),
            getAddress(),
            getCompany(),
            getGroups()
          ],
        ),
      );
    });
  }
}

