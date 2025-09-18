import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/job_switcher.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/job_overview_placeholders/secondary_header_placeholder.dart';
import 'package:jobprogress/global_widgets/job_switcher/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPSecondaryHeader extends StatelessWidget {
  final int customerId;
  final JobModel? currentJob;
  final VoidCallback? onTap;
  final Function(int)? onJobPressed;
  final Widget? placeHolder;
  final FLModule? type;
  final bool canOpenSecondaryHeader;

  const JPSecondaryHeader({
    super.key,
    required this.customerId,
    required this.currentJob,
    this.onTap,
    this.onJobPressed,
    this.placeHolder,
    this.type,
    this.canOpenSecondaryHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: JPAppTheme.themeColors.secondary,
      padding: const EdgeInsets.only(left: 20, top:6, bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                if(canOpenSecondaryHeader && Get.currentRoute != Routes.email)...{
                  Material(
                    color: JPAppTheme.themeColors.secondary,
                    child: JPTextButton(
                      key: const Key(WidgetKeys.secondaryDrawerMenuKey),
                      onPressed: onTap,
                      color: JPAppTheme.themeColors.base,
                      icon: Icons.menu_open,
                      iconSize: 24,
                      padding: 0,
                      isDisabled: currentJob == null,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  )
                },
                if(currentJob != null)...{
                  Flexible(
                    child: Material(
                    color: JPAppTheme.themeColors.secondary,
                    child: JPTextButton(
                      onPressed: () {
                        showJPBottomSheet(
                            isScrollControlled: true,
                            child: ((_) {
                              return JobSwitcherBottomSheet(
                                currentJob: currentJob!,
                                customerId: customerId,
                                onJobPressed: onJobPressed,
                                type: JobSwitcherType.job,
                              );
                            })
                        );
                      },
                      color: JPAppTheme.themeColors.base,
                      text: 'Job: ${Helper.getJobName(currentJob!.parent ?? currentJob!)}',
                      textSize: JPTextSize.heading5,
                      iconSize: 20,
                      icon: Icons.arrow_drop_down,
                    ),
                  ),
                  ),
                } else...{
                  Flexible(child: placeHolder ?? const JobOverViewSecondaryHeaderPlaceholder()),
                }
              ],
            ),
          ),
          if(currentJob != null &&
              (currentJob!.isMultiJob || currentJob!.parentId != null)
              && type != FLModule.jobProposal)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Material(
                color: JPAppTheme.themeColors.secondary,
                child: JPTextButton(
                  onPressed: () {
                    showJPBottomSheet(
                        isScrollControlled: true,
                        child: ((_) {
                          return JobSwitcherBottomSheet(
                            currentJob: currentJob!,
                            customerId: customerId,
                            onJobPressed: onJobPressed,
                            type : JobSwitcherType.project,
                          );
                        })
                    );
                  },
                  color: JPAppTheme.themeColors.base,
                  text: 'Project: ${Helper.getJobName(currentJob!)}',
                  textSize: JPTextSize.heading6,
                  icon: Icons.arrow_drop_down,
                ),
              ),
            ),
        ],
      ),
    );
  }
}