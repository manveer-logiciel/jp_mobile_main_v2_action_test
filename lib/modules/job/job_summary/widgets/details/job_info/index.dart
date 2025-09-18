
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/location_helper.dart';
import 'package:jobprogress/global_widgets/has_permission/index.dart';
import 'package:jobprogress/modules/job/job_detail/widgets/detail_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../common/enums/jpchip_type.dart';
import '../../../../../../global_widgets/chip_with_avatar/index.dart';
import 'job_description_button.dart';

class JobOverViewDetailsJobInfo extends StatelessWidget {
  const JobOverViewDetailsJobInfo({
    super.key,
    required this.job,
    this.onTapViewMore, 
    required this.emailCount, 
    this.onTapDescription, 
    this.onTapEdit,
  });

  final JobModel job;
  final int emailCount;
  final VoidCallback? onTapViewMore;
  final Function(String)? onTapDescription;
  final VoidCallback? onTapEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// job address
        if(!(job.isProject ?? false) && (job.addressString?.isNotEmpty ?? false))...{
          JobDetailTile(
            isVisible: true,
            isDescriptionSelectable: true,
            label: 'job_address'.tr,
            labelColor: JPAppTheme.themeColors.tertiary,
            description: job.addressString,
            descriptionColor: JPAppTheme.themeColors.text,
            trailing: JPTextButton(
              icon: Icons.location_on,
              onPressed: () {
                LocationHelper.openMapBottomSheet(
                  query: job.addressString,
                  address: job.address
                );
              },
              iconSize: 24,
              color: JPAppTheme.themeColors.primary,
            ),
          ),
          divider(),
        },
        /// job description
        if(job.description?.isNotEmpty ?? false)...{
          JobDetailTile(
            isVisible: true,
            label: job.isProject! ? 'project_description'.tr : 'job_description'.tr,
            labelColor: JPAppTheme.themeColors.tertiary,
            description: job.description,
            descriptionColor: JPAppTheme.themeColors.text,
            trailing: !AuthService.isPrimeSubUser() ? JPTextButton(
              onPressed: onTapEdit,
              color: JPAppTheme.themeColors.primary,
              icon: Icons.edit_outlined,
              iconSize: 16,
            ): const SizedBox.shrink(),
          ),

          if((emailCount != 0) || (job.scheduled?.isNotEmpty ?? false) || (job.productionBoards?.isNotEmpty ?? false))...{
            Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                spacing: 5,
                runSpacing: 5,
                children: [
                  ///   Email recurring
                  if(emailCount != 0)
                  JobDetailButton(
                    text: '${'email'.tr.capitalize!} ${'recurring'.tr.capitalize!} ($emailCount)',
                    onTapDescription: () => onTapDescription!("email_recurring"),
                    prefixIcon: Icons.schedule_send_outlined,
                  ),
                  ///   Job scheduled
                  if(job.scheduled?.isNotEmpty ?? false)
                  JobDetailButton(
                    text: job.scheduled ?? "",
                    onTapDescription: () => onTapDescription!("job_scheduled"),
                    prefixIcon: Icons.calendar_month,
                  ),
                  ///   added to progress board
                  if(job.productionBoards?.isNotEmpty ?? false)
                  Visibility(
                    visible: !AuthService.isPrimeSubUser(),
                    child: HasPermission(
                      permissions: const [PermissionConstants.viewProgressBoard,PermissionConstants.manageProgressBoard],
                      child: JobDetailButton(
                        text: "${"added_in_progress_board".tr} (${(job.productionBoards?.length.toString() ?? "")})",
                        onTapDescription: () => onTapDescription!("progress_board"),
                        prefixIcon: Icons.wysiwyg,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            )
          },
          divider(),
        },

        if(job.flags?.isNotEmpty ?? false)...{
          ///   Job Flags
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 5),
            child: JPText(
              text: job.isProject! ? "project_flags".tr.capitalize! : "Job_flags".tr.capitalize!,
              textAlign: TextAlign.start,
              textSize: JPTextSize.heading5,
              textColor: JPAppTheme.themeColors.tertiary,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16,right: 16, bottom: 16),
            child: JPChipWithAvatar(
              jpChipType: JPChipType.flags,
              flagList: job.flags ?? [],
            ),
          ),

          divider(),
        },

        /// view more
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: JPButton(
              type: JPButtonType.outline,
              text: 'view_more'.tr.toUpperCase(),
              size: JPButtonSize.extraSmall,
              onPressed: onTapViewMore,
            ),
          ),
        )
      ],
    );
  }

  Widget divider() => Divider(
    height: 1,
    thickness: 1,
    color: JPAppTheme.themeColors.dimGray,
  );
}
