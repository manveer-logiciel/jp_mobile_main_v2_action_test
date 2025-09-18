import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/jpchip_type.dart';
import 'package:jobprogress/common/models/job/customer_info.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/global_widgets/chip_with_avatar/index.dart';
import 'package:jobprogress/global_widgets/feature_flag/index.dart';
import 'package:jobprogress/modules/job/job_summary/widgets/details/customer_info/customer_rep.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'detail_tile.dart';
import 'email_tile.dart';

class JobOverViewDetailsCustomerInfo extends StatelessWidget {
  const JobOverViewDetailsCustomerInfo({
    super.key,
    required this.customerInfo,
    required this.job,
    required this.customerName,
    this.onTapCallLog,
    this.onTapShare, 
    this.updateScreen, 
    this.onTapEmailHistory,
  });

  /// customerInfo stores customer info as list
  final List<CustomerInfo> customerInfo;

 /// job is used to store job data
  final JobModel job;

  /// customerName used to display customer name
  final String customerName;

  /// onTapCallLog handles click on call log
  final VoidCallback? onTapCallLog;

  /// onTapShare handles click on share
  final VoidCallback? onTapShare;

  // updateScreen will be used to update screen
  final VoidCallback? updateScreen;

  // onTapEmailHistory handles click on email History
  final VoidCallback? onTapEmailHistory;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16
          ),
          child: Row(
            children: [
              /// name
              Expanded(
                child: JPText(
                  text: customerName,
                  fontWeight: JPFontWeight.medium,
                  textAlign: TextAlign.start,
                  textSize: JPTextSize.heading3,
                  isSelectable: true,
                ),
              ),
              /// share icon
              HasFeatureAllowed(
                feature: const [FeatureFlagConstant.customerJobFeatures],
                child: JPTextButton(
                  icon: Icons.share,
                  onPressed: onTapShare,
                  iconSize: 24,
                  color: JPAppTheme.themeColors.primary,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              /// call log icon
              JPTextButton(
                icon: Icons.phone_forwarded_rounded,
                onPressed: onTapCallLog,
                iconSize: 24,
                color: JPAppTheme.themeColors.primary,
              ),
            ],
          ),
        ),

        if(customerInfo.every((element) => element.email == null)) ... {
          JobSummaryCustomerRepEmailTile(
            onTapEmailHistory: onTapEmailHistory,
            job: job,
            data: CustomerInfo(label: 'email'.tr.capitalize!),)
        },

        /// list of customer info
        ListView.separated(
            itemBuilder: (_, index) {
              final data = customerInfo[index];
              return JobOverViewCustomerInfoDetailTile(
                data: data,
                job: job,
                onTapEmailHistory: onTapEmailHistory,
                updateScreen: updateScreen,
                isDescriptionSelectable: true
              );
            },
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            separatorBuilder: (_, __) => divider(),
            itemCount: customerInfo.length
        ),
        divider(),
        JobSummaryCustomerRepTile(job: job),
        if(job.customer?.flags?.isNotEmpty ?? false)...{
          ///   Customer Flags
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 5),
            child: JPText(
              text: "customer_flags".tr.capitalize!,
              textAlign: TextAlign.start,
              textSize: JPTextSize.heading5,
              textColor: JPAppTheme.themeColors.tertiary,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16,right: 16, bottom: 16),
            child: JPChipWithAvatar(
              jpChipType: JPChipType.flags,
              flagList: job.customer?.flags ?? [],
            ),
          ),
          divider(),
        }
      ],
    );
  }

  // separator
  Widget divider() => Divider(
    height: 1,
    thickness: 1,
    color: JPAppTheme.themeColors.dimGray,
  );
}

