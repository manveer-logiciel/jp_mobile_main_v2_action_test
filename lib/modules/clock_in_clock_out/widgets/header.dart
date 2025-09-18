import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import 'package:jobprogress/modules/clock_summary/listing/widgets/show_clock_summary_hours.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ClockInClockOutHeader extends StatelessWidget {

  const ClockInClockOutHeader({
    super.key,
    this.data,
    this.onTapSelect,
    this.duration,
    this.previousSelectedJob
  });

  /// used to display selected job data or check-in job
  final JobModel? data;

  /// used to check whether job is coming from previous screen or not.
  final JobModel? previousSelectedJob;

  /// onTapSelect handles tap on select button
  final VoidCallback? onTapSelect;

  /// duration used to display duration text
  final String? duration;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [

              /// job details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(data != null)...{
                      JobNameWithCompanySetting(
                        job: data!,
                        textSize: JPTextSize.heading4,
                        fontWeight: JPFontWeight.medium,
                      ),
                    } else...{
                      JPText(
                        text: 'without_job'.tr,
                        fontWeight: JPFontWeight.medium,
                        textSize: JPTextSize.heading4,
                        textAlign: TextAlign.start,
                        maxLine: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    },
                    if(data?.trades?.isNotEmpty ?? false)...{
                      const SizedBox(
                        height: 6,
                      ),
                      JPText(
                        text: data!.tradesString,
                        fontWeight: JPFontWeight.regular,
                        textSize: JPTextSize.heading5,
                        textColor: JPAppTheme.themeColors.tertiary,
                        textAlign: TextAlign.start,
                      )
                    }
                  ],
                ),
              ),
              const SizedBox(
                width: 5,
              ),

              /// duration
              if(duration != null)...{
                ShowClockSummaryHours(
                  time: duration,
                ),
              } else if(previousSelectedJob == null)...{
                /// select button
                JPButton(
                  type: JPButtonType.outline,
                  text: 'select'.tr.toUpperCase(),
                  size: JPButtonSize.extraSmall,
                  onPressed: onTapSelect,
                )
              }
            ],
          ),

          /// job address
          if(data?.addressString?.isNotEmpty ?? false)...{
            const SizedBox(
              height: 5,
            ),
            JPText(
              text: data!.addressString ?? "",
              textSize: JPTextSize.heading5,
              textColor: JPAppTheme.themeColors.tertiary,
              textAlign: TextAlign.start,
            ),
          }
        ],
      ),
    );
  }

}
