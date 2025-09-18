import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPMainDrawerFooter extends StatelessWidget {
  final UserModel loggedInUser;
  final VoidCallback onTap;
   
  const JPMainDrawerFooter({super.key, required this.loggedInUser, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      containerDecoration: BoxDecoration(
        color: JPAppTheme.themeColors.inverse,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
        ),
      ),
      top: false,
      child: InkWell(
        onTap: (loggedInUser.allCompanies?.length ?? 0) > 1
        ? onTap
        : null,
        child: Container(
          padding:
              EdgeInsets.only(top: 15, bottom: Helper.shouldApplySafeArea(context) ? 0 : 15, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    JPAvatar(
                        backgroundColor: JPAppTheme.themeColors.primary,
                        child: loggedInUser.companyDetails?.logo != null
                            ? JPNetworkImage(src: loggedInUser.companyDetails?.logo,) :
                            JPText(text: loggedInUser.companyDetails?.intial ?? "",textColor: JPAppTheme.themeColors.base,)),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: JPText(
                        textAlign: TextAlign.left,
                        textSize: JPTextSize.heading3,
                        fontWeight: JPFontWeight.medium,
                        overflow: TextOverflow.ellipsis,
                        text: loggedInUser.companyDetails?.companyName ?? "",
                      ),
                    ),
                  ],
                ),
              ),
              if ((loggedInUser.allCompanies?.length ?? 0) > 1)
                const JPIcon(
                      Icons.arrow_drop_up_outlined,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
