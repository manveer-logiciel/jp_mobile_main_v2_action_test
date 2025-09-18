import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/group_company_contacts_model.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/color_helper.dart';
import 'package:jobprogress/modules/company_contacts/listing/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';


class CompanyContactsTileList extends StatelessWidget {
  const CompanyContactsTileList(this.companyContacts, this.checkIcon, this.onContactChecked, this.controller, {super.key});
  final GroupCompanyContactListingModel companyContacts;
  final bool checkIcon;
  final void Function(int index) onContactChecked;
  final CompanyContactListingController controller;

  @override
  Widget build(BuildContext context) {

    Widget getListTile(int index) {
      CompanyContactListingModel contact = companyContacts.groupValues[index];

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          JPAvatar(
            size: JPAvatarSize.large,
            backgroundColor: ColorHelper.companyContactAvatarColors[(index % 8)], 
            child: JPText(
              text: '${contact.firstName![0].toString().toUpperCase()}'
                  '${contact.lastName![0].toString().toUpperCase()}',
              textSize: JPTextSize.heading3,
              textColor: JPAppTheme.themeColors.base,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 15, top: index == 0 ? 0 : 12),
              decoration: BoxDecoration(
                border: (index == companyContacts.groupValues.length - 1) ? null : Border(
                  bottom: BorderSide(color: JPAppTheme.themeColors.dimGray, width: 1)
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: JPText(
                            text: '${contact.firstName!.capitalize} ${contact.lastName!.capitalize}', 
                            fontWeight: JPFontWeight.medium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if(contact.phones != null && contact.phones!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: contact.emails!.isNotEmpty ? 5: 12),
                          child: JPText(
                            text: PhoneMasking.maskPhoneNumber(contact.phones![0].number!),
                            textColor: JPAppTheme.themeColors.tertiary,
                            textSize: JPTextSize.heading5,
                          ),
                        ),
                      if (contact.emails!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: (index == companyContacts.groupValues.length - 1) ? 0 : 12),
                          child: JPText(text: contact.emails![0].email.toString(), textColor: JPAppTheme.themeColors.tertiary, textSize: JPTextSize.heading5),
                        ),
                      if (contact.phones != null && contact.phones!.isEmpty && contact.emails!.isEmpty)
                        const SizedBox(height: 15)
                      ],
                    ),
                  ),
                  if (checkIcon)
                  Padding(
                    padding: EdgeInsets.only(bottom: (index == companyContacts.groupValues.length - 1) ? 0 : 12),
                    child: JPCheckbox(
                      onTap: (value) {
                        onContactChecked(index);
                      },
                      selected: contact.checked,
                      checkColor: JPAppTheme.themeColors.base,
                      color: JPAppTheme.themeColors.themeGreen,
                      borderColor: JPAppTheme.themeColors.themeGreen,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }

    List<Widget> getChildrens() {
      final children = <Widget>[];

      for (var i = 0; i < companyContacts.groupValues.length; i++) {
        children.add(
          Material(
            borderRadius: BorderRadius.circular(18),
            color: JPAppTheme.themeColors.base,
            child: InkWell(
              key: Key('${WidgetKeys.contactPersons}[$i]'),
              borderRadius:  BorderRadius.only(
                    topLeft: Radius.circular(i == 0 ? 18 : 0),
                    topRight: Radius.circular(i == 0 ? 18 : 0),
                    bottomLeft: Radius.circular((i + 1) == companyContacts.groupValues.length ? 18 : 0),
                    bottomRight: Radius.circular((i + 1) == companyContacts.groupValues.length ? 18 : 0)
                  ),
              onLongPress: () {
                if (!controller.isForJobContactFormSelection) {
                  onContactChecked(i);
                }
              },
              onTap: () async{
                if (controller.isForJobContactFormSelection) {
                  Get.back(result: companyContacts.groupValues[i]);
                  return;
                }
                
                if (!checkIcon) {
                final response =  await Get.toNamed('/company_contacts_view',
                  arguments: [companyContacts.groupValues[i].id, ColorHelper.companyContactAvatarColors[(i %8)]]);
                  if(response != null && response["status"]){
                      controller.refreshList(showLoading: true);
                    }
                  return;
                }
                 
          
                onContactChecked(i);
              },
              child: Container(padding: EdgeInsets.only(left: 16, top: i == 0 ? 16 : 0, bottom: (companyContacts.groupValues.length == i + 1) ? 16 : 0), child: getListTile(i)),
            ),
          )
        );
      }

      return children;
    }

    return StickyHeader(
      header:
        Container(
          color: JPAppTheme.themeColors.inverse,
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 10, left: 16),
          transform: Matrix4.translationValues(0.0, -0.25, 0.0),
          child: JPText(text: companyContacts.groupName,textAlign: TextAlign.left,),
        ),
        content:Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: JPAppTheme.themeColors.base),
          child: Column(
            children: getChildrens()
          ),
        ),
      
    );
  }
}
