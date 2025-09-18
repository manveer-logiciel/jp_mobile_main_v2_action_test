
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'counts_card.dart';

class JobOverViewWorkFlowCounts extends StatelessWidget {
  const JobOverViewWorkFlowCounts({
    super.key,
    required this.job,
    required this.onTap
  });

  /// job is used to store job's data
  final JobModel job;

  /// onTap handles tap on item
  final Function(String type) onTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: JPScreen.isMobile ? 400 : 800,
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 25,
          ),
          if(FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.userManagement]))...{
            JobOverViewWorkFlowCountCard(
              title: 'messages'.tr,
              count: (job.jobMessageCount ?? 0).toString(),
              textColor: JPAppTheme.themeColors.foam,
              bgColor: JPAppTheme.themeColors.lightFoam,
              onTap: () {
                onTap('message');
              },
            ),
            spacer(),
          },
          JobOverViewWorkFlowCountCard(
            title: 'text'.tr,
            count: (job.jobTextCount ?? 0).toString(),
            textColor: JPAppTheme.themeColors.grassGreen,
            bgColor: JPAppTheme.themeColors.lightGrassGreen,
            onTap: () {
              onTap('text');
            },
          ),
          spacer(),
          JobOverViewWorkFlowCountCard(
            title: 'appts'.tr,
            count: (job.appointmentCount ?? 0).toString(),
            textColor: JPAppTheme.themeColors.brown,
            bgColor: JPAppTheme.themeColors.lightBrown,
            onTap: () {
              onTap('appts');
            },
          ),
          spacer(),
          JobOverViewWorkFlowCountCard(
            title: 'notes'.tr,
            count: (job.jobNoteCount ?? 0).toString(),
            textColor: JPAppTheme.themeColors.wildBlue,
            bgColor: JPAppTheme.themeColors.lightWildBlue,
            onTap: () {
              onTap('notes');
            },
          ),
          spacer(),
          JobOverViewWorkFlowCountCard(
            title: 'tasks'.tr,
            count: (job.jobTaskCount ?? 0).toString(),
            textColor: JPAppTheme.themeColors.yellow,
            bgColor: JPAppTheme.themeColors.lightYellow,
            onTap: () {
              onTap('tasks');
            },
          ),
          const SizedBox(
            width: 25,
          ),
        ],
      ),
    );
  }

  Widget spacer() => const SizedBox(
    width: 10,
  );

}
