

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/call_logs/call_log_listing.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CallLogListingTile extends StatelessWidget {
  final List<CallLogModel> callLogList;
  final int index;
  final CallLogModel callLog;
  final UserModel? loggedInUser;

  const CallLogListingTile({super.key, required this.callLog, this.loggedInUser,required this.callLogList, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 12, top: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JPProfileImage(
              enableBorder: false,
              textSize: JPTextSize.heading3,
              size: JPAvatarSize.large,
              color: callLog.createdBy!.color,
              initial: callLog.createdBy!.intial,
              src: callLog.createdBy!.profilePic,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 7),
                decoration: BoxDecoration(
                  border:index == callLogList.length - 1 ? null : Border(bottom: BorderSide(width: 1, color:JPAppTheme.themeColors.dimGray, style: BorderStyle.solid))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(callLog.createdBy != null && loggedInUser != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                      child: JPRichText(
                          text:
                            JPTextSpan.getSpan(
                              loggedInUser!.id == callLog.createdBy!.id ? 'you_have'.tr.capitalize.toString() : callLog.createdBy!.fullName,
                              fontWeight: JPFontWeight.medium, children: [
                            JPTextSpan.getSpan('initated_a_call_with'.tr),
                            JPTextSpan.getSpan(
                              callLog.jobContactId != null && callLog.jobContact != null ?
                              callLog.jobContact!.fullName.toString() :
                              callLog.customer!.fullName.toString(),
                              fontWeight: JPFontWeight.medium
                            )
                          ]
                        )
                    ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Row(
                        children: [
                          JPText(
                            text: '${callLog.phoneLabel!.toUpperCase()} - ',
                            textColor: JPAppTheme.themeColors.tertiary,
                            textSize: JPTextSize.heading5
                          ),
                          JPText(
                            text: PhoneMasking.maskPhoneNumber(callLog.phoneNumber!),
                            textColor: JPAppTheme.themeColors.tertiary,
                            textSize: JPTextSize.heading5
                          )
                        ],
                      ),
                    ),
                    
                     if(callLog.job != null)
                     Padding(
                       padding: const EdgeInsets.only(top: 5),
                       child: JobNameWithCompanySetting(
                         job: callLog.job!,
                         textColor: JPAppTheme.themeColors.tertiary,
                         textSize: JPTextSize.heading5,
                         textDecoration: TextDecoration.underline,
                         ),
                     ),
            
                     Padding(
                      padding: const EdgeInsets.only(top: 7, right: 20),
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 5,
                        children: [
                          const SizedBox(width: double.infinity,),
                          JPText(
                            text: DateTimeHelper.formatDate(callLog.updatedAt!, DateFormatConstants.dateTimeFormatWithoutSeconds),
                            textColor: JPAppTheme.themeColors.darkGray,
                            textSize: JPTextSize.heading5
                          ),
                          JPChip(
                            backgroundColor: JPAppTheme.themeColors.inverse,
                            text: callLog.jobContactId != null ? 'contact_person'.tr.capitalize.toString() : 'customer'.tr.capitalize.toString(),
                            textColor: JPAppTheme.themeColors.tertiary,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );    
  }
}