import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/global_widgets/secondary_header/index.dart';
import 'package:jobprogress/modules/email/listing/controller.dart';
import 'package:jobprogress/modules/email/listing/secondary_header.dart';
import 'package:jobprogress/modules/email/listing/widgets/groups_list/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class EmailsListing extends StatelessWidget {
  const EmailsListing({
    super.key,
    required this.controller,
  });

  final EmailListingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: controller.jobId != null,
          child: JPSecondaryHeader(
            customerId: controller.customerId!,
            currentJob: controller.job,
            canOpenSecondaryHeader: false,
            onJobPressed: controller.handleChangeJob,
          ),
        ),
        if (controller.jobId == null)
          EmailListingSecondaryHeader(
            controller: controller,
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 10,
                    bottom: controller.jobId != null ? 5 : 15,
                    left: 16),
                child: controller.jobId == null ? 
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const SizedBox(width: double.maxFinite,),
                    JPText(
                      textAlign: TextAlign.left,
                      text:
                      '${controller.selectedLabel!.name.toString().toUpperCase()}'
                          ' ${!controller.isLoading ? controller.totalEmailLength > 0 ? '(${controller.totalEmailLength.toStringAsFixed(0)})' : '' : ''}',
                      fontWeight: JPFontWeight.medium,
                    ),
                    controller.isMultiSelectionOn ? 
                    Material(
                      color: JPColor.transparent,
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: JPTextButton(
                          icon: Icons.more_vert,
                          iconSize: 24,
                          padding: 6,
                          color: JPAppTheme.themeColors.tertiary,
                          onPressed: () {
                            controller.openQuickActionDialog();
                          },
                        ),
                      ),
                    ) : AuthService.isAdmin() && FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.userManagement])? 
                    Material(
                      color: JPColor.transparent,
                      child: Container(
                        margin: const EdgeInsets.only(
                            right: 10),
                        child: InkWell(
                          splashColor: JPAppTheme.themeColors.inverse,
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            controller.filterEmailListByUser();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (controller.selectedUser !=
                                    null)
                                  JPProfileImage(
                                    src: controller
                                        .selectedUser!
                                        .profilePic,
                                    color: controller
                                        .selectedUser!.color,
                                    initial: controller
                                        .selectedUser!.intial,
                                  ),
                                if (controller.selectedUser !=
                                    null)
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        left: 8.0),
                                    child: JPText(
                                      text: controller
                                          .selectedUser!
                                          .id ==
                                          controller
                                              .loggedInUser!
                                              .id
                                          ? 'me'.tr
                                          : controller
                                          .selectedUser!
                                          .fullName,
                                      fontWeight:
                                      JPFontWeight.medium,
                                      textSize:
                                      JPTextSize.heading5,
                                    ),
                                  ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      left: 8.0),
                                  child: JPIcon(
                                      Icons
                                          .expand_more_outlined,
                                      color: JPAppTheme
                                          .themeColors
                                          .tertiary),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ) : 
                    const SizedBox.shrink()
                  ],
                ): null,
              ),
              EmailsGroupList(
                controller: controller,
              ),
            ],
          ),
        )
      ],
    );
  }
}
