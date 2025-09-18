import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/company/company.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/location_helper.dart';
import 'package:jobprogress/global_widgets/custom_material_card/index.dart';
import 'package:jobprogress/global_widgets/email_button/index.dart';
import 'package:jobprogress/global_widgets/message/index.dart';
import 'package:jobprogress/modules/customer/detail_screen_body/detail_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MyProfileCompanyDetails extends StatelessWidget {
  const MyProfileCompanyDetails({super.key, required this.userDetails});
  final UserModel userDetails;

  @override
  Widget build(BuildContext context) {
    CompanyModel companyDetails = userDetails.companyDetails!;

    return  CustomMaterialCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomerDetailTile(
            visibility: companyDetails.companyName.isNotEmpty,
            label: "company".tr,
            description: companyDetails.companyName,
          ),
          for ( int index = 0; index < (companyDetails.allPhones?.length ?? 0); index++ ) Column(
            children: [
              divider(index != (companyDetails.allPhones?.length ?? 0)),
              CustomerDetailTile(
                visibility: companyDetails.allPhones?[index].isNotEmpty ?? false,
                label: "company_phone".tr.capitalize,
                description: PhoneMasking.maskPhoneNumber(companyDetails.allPhones![index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    JPTextButton(
                      onPressed: () => Helper.launchCall(companyDetails.allPhones![index]),
                      color: JPAppTheme.themeColors.primary,
                      icon: Icons.local_phone,
                      iconSize: 24,
                    ),
                    const SizedBox(width: 10,),
                    JPSaveMessageLog(
                        phone: companyDetails.allPhones![index],
                    )
                  ],
                ),
              ),
            ],
          ),

          divider(companyDetails.fax?.isNotEmpty ?? false),
          CustomerDetailTile(
            visibility: companyDetails.fax?.isNotEmpty ?? false,
            label: "company_fax".tr.capitalize,
            description: companyDetails.fax ?? '',
          ),
          for(int index = 0; index < (companyDetails.allEmails?.length ?? 0); index++ ) Column(
            children: [
              divider(index != (companyDetails.allEmails?.length ?? 0)),
              CustomerDetailTile(
                visibility: companyDetails.allEmails?[index].isNotEmpty ?? false,
                label: "company_email".tr.capitalize,
                description: companyDetails.allEmails![index],
                trailing: JPEmailButton(
                  fullName: companyDetails.allEmails![index],
                  email: companyDetails.allEmails![index]
                )
              ),
            ],
          ),

          divider(companyDetails.convertedAddress?.isNotEmpty ?? false),
          CustomerDetailTile(
            visibility: companyDetails.convertedAddress?.isNotEmpty ?? false,
            label: "company_address".tr.capitalize,
            description: companyDetails.convertedAddress ?? '',
            trailing: JPTextButton(
              color: JPAppTheme.themeColors.primary,
              onPressed: () {
                LocationHelper.openMapBottomSheet(query: companyDetails.convertedAddress);
              },
              icon: Icons.location_on,
              iconSize: 24,
            ),
          ),
          divider(userDetails.divisions?.isNotEmpty ?? false),
          CustomerDetailTile(
            visibility: userDetails.divisions?.isNotEmpty ?? false,
            label: "divisions".tr.capitalize,
            description: userDetails.divisions?.map((e) => e.name).join(', '),
          ),
        ],
      ),
    );
  }
}

Widget divider(bool dividerVisibility) => Visibility(
    visible: dividerVisibility,
    child: Divider(height: 1, color: JPAppTheme.themeColors.dimGray
  )
);