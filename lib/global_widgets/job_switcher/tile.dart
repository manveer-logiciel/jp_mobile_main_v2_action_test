import 'package:get/get.dart';
import 'package:jobprogress/common/extensions/String/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:jobprogress/common/enums/job_switcher.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/core/constants/job_item_with_company_setting_constant.dart';
import 'package:jobprogress/core/constants/work_flow_stage_color.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/details_listing_tile/widgets/source_type_content.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_item_with_company_setting.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../quick_book/index.dart';


class JobSwitcherTileView extends StatelessWidget {
  const JobSwitcherTileView({ super.key, required this.job, this.type, this.currentJob, this.canRemoveCustomerName = false});
  final JobModel job;
  final JobModel? currentJob;
  final JobSwitcherType? type;
  final bool canRemoveCustomerName;

  @override
  Widget build(BuildContext context) {

    String jobAddress = Helper.convertAddress(job.address);

    Color? getSelectedColor() {
      if(currentJob!= null && currentJob!.parentId != null && type == JobSwitcherType.job) {
        return job.id == currentJob!.parentId ? JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.5) : null;
      }
      return currentJob != null ? job.id == currentJob!.id ? JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.5) : null : null;
    }

    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1,color: JPAppTheme.themeColors.inverse)),
          color: getSelectedColor()
      ),
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12, bottom: 5),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    canRemoveCustomerName ? JPText(
                      textDecoration: TextDecoration.none,
                      text: type == JobSwitcherType.project && job.isMultiJob ? 'Parent(${Helper.getJobName(job)})' : Helper.getJobName(job),
                      fontWeight: JPFontWeight.medium,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      textSize: JPTextSize.heading4,
                      textColor: JPAppTheme.themeColors.text,
                    ) : JobNameWithCompanySetting(
                      job: job,
                      fontWeight: JPFontWeight.medium,
                    ),
                    space(),
                    if(job.trades != null && job.trades!.isNotEmpty) ...{
                      JPText(
                        text: job.tradesString,
                        textColor: JPAppTheme.themeColors.tertiary,
                        textAlign: TextAlign.start,
                      ),
                      space(),
                    },
                    JobItemWithCompanySetting(
                      job: job,
                      type: JobItemWithCompanySettingConstant.number,
                      value: job.number,
                    ),
                    JobItemWithCompanySetting(
                      job: job,
                      type: JobItemWithCompanySettingConstant.altId,
                      value: job.altId,
                    ),
                    JobItemWithCompanySetting(
                      job: job,
                      type: JobItemWithCompanySettingConstant.name,
                      value: job.name,
                    ),
                    if(jobAddress.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom:8.0),
                        child: JPText(
                          text: '${'address'.tr}: ${TrimEnter(jobAddress).trim()}',
                          textColor: JPAppTheme.themeColors.tertiary,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if(job.isMultiJob)
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 5),
                          child: JPBadge(
                            text: 'MP',
                            backgroundColor: JPAppTheme.themeColors.warning,
                            textColor: JPAppTheme.themeColors.base,
                          ),
                        ),
                      if(job.currentStage != null && job.parentId == null)
                        Padding(
                          padding: const EdgeInsets.only(left : 10, bottom: 5),
                          child: JPAvatar(
                            size: JPAvatarSize.small,
                            backgroundColor: WorkFlowStageConstants.colors[job.currentStage!.color],
                            child: JPText(
                              text: job.currentStage!.name[0].toUpperCase(),
                              textColor: JPAppTheme.themeColors.base,
                            ),
                          ),
                        ),
                    ],
                  ),
                  CustomerJobSourceTypeContent(sourceType: job.sourceType,),
                  QuickBookIcon(
                      status: job.quickbookSyncStatus,
                      origin: job.origin,
                      isSyncDisable: job.customer != null && job.customer!.isDisableQboSync? 1 : 0,
                      qbDesktopId: job.qbDesktopId,
                      quickbookId: job.quickbookId
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

Widget space() => const SizedBox(
  height:7,
  width: 5,
);