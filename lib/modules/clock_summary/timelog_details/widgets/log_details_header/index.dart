
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_time_log_details.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import 'package:jobprogress/modules/clock_summary/listing/widgets/show_clock_summary_hours.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class TimeLogDetailsHeader extends StatelessWidget {

  const TimeLogDetailsHeader({super.key, required this.data});

  final ClockSummaryTimeLogDetails data;

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    if(data.jobModel != null)...{
                      JobNameWithCompanySetting(
                        job: data.jobModel!,
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
                    if(data.allTrades != null && data.allTrades!.isNotEmpty)...{
                      const SizedBox(
                        height: 6,
                      ),
                      JPText(
                        text: data.allTrades ?? "",
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
              ShowClockSummaryHours(
                time: data.duration,
              )
            ],
          ),
          if(data.jobAddress != null && data.jobAddress!.isNotEmpty)...{
            const SizedBox(
              height: 5,
            ),
            JPText(
              text: data.jobAddress ?? "",
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
