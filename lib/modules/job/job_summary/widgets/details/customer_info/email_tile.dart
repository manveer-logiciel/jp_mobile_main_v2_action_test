import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/customer_info.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/email_button/index.dart';
import 'package:jobprogress/modules/job/job_detail/widgets/detail_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobSummaryCustomerRepEmailTile extends StatelessWidget {
  const JobSummaryCustomerRepEmailTile({
    super.key,
    required this.data,
    required this.job, 
    this.onTapEmailHistory,
  });

  final CustomerInfo data;
  final JobModel job;
  final VoidCallback? onTapEmailHistory;

  @override
  Widget build(BuildContext context) {
    return JobDetailTile(
      isVisible: true,
      label: data.label,
      labelColor: JPAppTheme.themeColors.tertiary,
      description: data.email ?? 'no_email'.tr,
      descriptionColor: JPAppTheme.themeColors.text,
      isDescriptionSelectable: true,
      trailing: Row(
        children: [
          JPTextButton(
            icon: Icons.history,
            iconSize: 24,
            color: JPAppTheme.themeColors.primary,
            onPressed: onTapEmailHistory
          ),
          Visibility(
            visible: !Helper.isValueNullOrEmpty(data.email),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: JPEmailButton(
                jobId: job.id,
                fullName: data.email,
                email: data.email,
                actionFrom: 'job_detail',
              ),
            ),
          ),
        ],
      ), 
    );
  }
}
