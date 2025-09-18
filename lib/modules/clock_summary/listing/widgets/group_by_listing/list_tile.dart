
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_timelog.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import 'package:jobprogress/modules/clock_summary/listing/widgets/show_clock_summary_hours.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ClockSummaryGroupByTile extends StatelessWidget {

  const ClockSummaryGroupByTile({
    super.key,
    required this.data,
    required this.index,
    required this.type,
    this.onTap
  });

  final ClockSummaryTimeLog data;

  final int index; //used to display index on tile

  final String type; //used to filter display values in ClockSummaryGroupByTile

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14
            ),
            child: Row(
              children: [
                /// index
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: JPAppTheme.themeColors.lightBlue
                  ),
                  child: Center(
                    child: JPText(
                      text: (index + 1).toString(),
                      textSize: JPTextSize.heading4,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// title
                      if(data.jobId != null && type == 'job')...{
                        JobNameWithCompanySetting(
                          job: data.jobModel!,
                          textSize: JPTextSize.heading4,
                          fontWeight: JPFontWeight.medium,
                        ),
                      }else...{
                        JPText(
                          text: groupTypeToTitle(),
                          textSize: JPTextSize.heading4,
                          fontWeight: JPFontWeight.medium,
                          textAlign: TextAlign.start,
                          maxLine: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      },

                      /// trades
                      if(data.allTrades != null && data.allTrades!.isNotEmpty && type == 'job')
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5
                          ),
                          child: JPText(
                            text: groupTypeToTrades().toUpperCase(),
                            textSize: JPTextSize.heading5,
                            fontWeight: JPFontWeight.regular,
                            textAlign: TextAlign.start,
                            textColor: JPAppTheme.themeColors.tertiary,
                          ),
                        ),

                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                /// duration
                ShowClockSummaryHours(
                  time: data.duration,
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          indent: 62,
          color: JPAppTheme.themeColors.dimGray,
        ),
      ],
    );
  }

  String groupTypeToTitle() {
    switch (type) {
      case 'job':
        return 'without_job'.tr;
      case 'user':
        return "${data.userName}";
      case 'date':
        return "${data.date}";
      default:
        return "";
    }
  }

  String groupTypeToTrades() {
    switch(type) {
      case "job":
        return data.allTrades ?? "";
      default:
        return "";
    }
  }

}
