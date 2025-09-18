import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class GroupJobDetails extends StatelessWidget {
  const GroupJobDetails({
    super.key,
    this.job,
    this.onTapDetails,
  });

  final JobModel? job;

  final VoidCallback? onTapDetails;

  @override
  Widget build(BuildContext context) {
    if (job == null) return const SizedBox();

    return Material(
      color: JPAppTheme.themeColors.dimGray,
      child: InkWell(
        onTap: onTapDetails,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: JobNameWithCompanySetting(
                  job: job!,
                  alignment: MainAxisAlignment.end,
                  textColor: JPAppTheme.themeColors.tertiary,
                  textDecoration: TextDecoration.underline,
                  isClickable: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
