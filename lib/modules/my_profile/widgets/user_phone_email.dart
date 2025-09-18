import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/location_helper.dart';
import 'package:jobprogress/global_widgets/custom_material_card/index.dart';
import 'package:jobprogress/global_widgets/email_button/index.dart';
import 'package:jobprogress/global_widgets/message/index.dart';
import 'package:jobprogress/modules/customer/detail_screen_body/detail_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MyProfileEmailPhone extends StatelessWidget {
  const MyProfileEmailPhone({super.key, required this.userDetails});
  final UserModel userDetails;

  @override
  Widget build(BuildContext context) {
    return  CustomMaterialCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///   Phone
          for ( int index = 0; index < (userDetails.phones?.length ?? 0); index++ ) Column(
            children: [
              divider(index != (userDetails.phones?.length ?? 0)),
              CustomerDetailTile(
                visibility: userDetails.phones?[index].number?.isNotEmpty ?? false,
                label: userDetails.phones?[index].label?.capitalize ?? "phone".tr.capitalize,
                description: PhoneMasking.maskPhoneNumber(userDetails.phones![index].number ?? ""),
                ext: userDetails.phones?[index].ext ?? "",
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    JPTextButton(
                      onPressed: () => Helper.launchCall(userDetails.phones![index].number!),
                      color: JPAppTheme.themeColors.primary,
                      icon: Icons.local_phone,
                      iconSize: 24,
                    ),
                    const SizedBox(width: 10,),
                    JPSaveMessageLog(
                      phone: userDetails.phones![index].number!,
                      phoneModel: userDetails.phones![index],
                    )
                  ],
                ),
              ),
            ],
          ),
          divider(userDetails.email?.isNotEmpty ?? false),
          ///   Email
          CustomerDetailTile(
            visibility: userDetails.email?.isNotEmpty ?? false,
            label: "email".tr,
            description: userDetails.email ?? "",
            trailing: JPEmailButton(
              fullName: userDetails.fullName,
              email: userDetails.email
            )
          ),

          divider(userDetails.convertedAddress?.isNotEmpty ?? false),
          CustomerDetailTile(
            visibility: userDetails.convertedAddress?.isNotEmpty ?? false,
            label: "address".tr,
            description: userDetails.convertedAddress ?? "",
            trailing: JPTextButton(
              color: JPAppTheme.themeColors.primary,
              onPressed: () {
                LocationHelper.openMapBottomSheet(query: userDetails.convertedAddress);
              },
              icon: Icons.location_on,
              iconSize: 24,
            ),
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