import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/workflow/service_params.dart';
import 'package:jobprogress/modules/job/job_summary/widgets/workflow/counts.dart';
import 'package:jobprogress/modules/job/job_summary/widgets/workflow/stages/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../core/utils/job_financial_helper.dart';
import 'header.dart';

class JobOverViewWorkFlow extends StatelessWidget {
  const JobOverViewWorkFlow({
    super.key,
    required this.workFlowParams,
    required this.refreshJob,
    required this.onTapCount,
    required this.users,
    this.onTapAwarded,
    this.onTapTotalJobPrice,
  });

  /// workFlowParams is used to store workflow stages data
  final WorkFlowStagesServiceParams? workFlowParams;

  /// call back to main controller for refreshing page
  final Future<void> Function({bool showLoading}) refreshJob;

  /// onTapCount handles tap/click on count
  final Function(String type) onTapCount;

  /// users store list of users to be displayed while updating project state
  final List<JPMultiSelectModel> users;

  /// onTapAwarded is used to handle tap on awarded/non-awarded
  final VoidCallback? onTapAwarded;

  /// onTapTotalJobPrice is used to open job price update dialog
  final VoidCallback? onTapTotalJobPrice;

  @override
  Widget build(BuildContext context) {

    return Material(
      color: JPAppTheme.themeColors.base,
      child: Column(
        children: [
          /// header
          if(workFlowParams != null)
          JobOverViewWorkFlowHeader(
            amount: JobFinancialHelper.getTotalPrice(workFlowParams!.job).toString(),
            isAwarded: workFlowParams!.job.isAwarded ?? false,
            isProject: workFlowParams!.isProject,
            onTapAwarded: onTapAwarded,
            onTapTotalJobPrice: onTapTotalJobPrice,
          ),
          /// stages
          if(doShowProjectStages)...{
            JobOverViewWorkflowStages(
              params: workFlowParams!,
              refreshJob: refreshJob,
              users: users,
            ),
          },

          /// counts
          if(workFlowParams != null)...{
            if(doShowProjectStages)
              Divider(
              thickness: 1,
              height: 1,
              color: JPAppTheme.themeColors.dimGray,
            ),

            JobOverViewWorkFlowCounts(
              job: workFlowParams!.job,
              onTap: onTapCount,
            ),
          }
        ],
      ),
    );
  }

  bool get doShowProjectStages => workFlowParams?.projectStages?.isNotEmpty ?? true;
}
