
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_entry.dart';
import 'package:jobprogress/core/utils/color_helper.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import 'package:jobprogress/modules/clock_summary/listing/widgets/show_clock_summary_hours.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ClockSummarySortByTile extends StatelessWidget {

  const ClockSummarySortByTile({super.key, required this.data, required this.index, this.onTap});

  final ClockSummaryEntry data;

  final VoidCallback? onTap;

  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12
            ),
            child: data.jobId == null ? JPText(
              text: 'without_job'.tr,
              textSize: JPTextSize.heading4,
              fontWeight: JPFontWeight.medium,
            ) : JobNameWithCompanySetting(
              job: data.jobModel!,
              textSize: JPTextSize.heading4,
              fontWeight: JPFontWeight.medium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 15
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 16,
                ),
                /// user profile
                JPAvatar(
                  height: 42,
                  width: 42,
                  radius: 21,
                  backgroundColor: data.user?.color != null ?  
                    ColorHelper.getHexColor(data.user!.color!) :
                    JPAppTheme.themeColors.darkGray,
                  child: getUserAvatar()
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// user name
                                JPText(
                                  text: data.userName ?? "-",
                                  fontWeight: JPFontWeight.medium,
                                  textSize: JPTextSize.heading4,
                                  textAlign: TextAlign.start,
                                  maxLine: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                /// date & time
                                Wrap(
                                  runSpacing: 5,
                                  spacing: 5,
                                  children: [
                                    JPText(
                                      text: data.date ?? "",
                                      textColor: JPAppTheme.themeColors.tertiary,
                                      textSize: JPTextSize.heading5,
                                      textAlign: TextAlign.start,
                                    ),
                                    JPText(
                                      text: data.time ?? "",
                                      textColor: JPAppTheme.themeColors.tertiary,
                                      textSize: JPTextSize.heading5,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                          ),
                          /// duration
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10
                            ),
                            child: ShowClockSummaryHours(
                              time: data.duration,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                        ],
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: JPAppTheme.themeColors.dimGray,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget getUserAvatar() {
    if(data.user?.profilePic != null || data.userName == null) {
      return JPNetworkImage(
        src: data.user!.profilePic ?? "",
      );
    } else if(data.user == null) {
      return JPText(
        text: '${data.userName?[0].toUpperCase()}'
            '${data.userName?[1].toUpperCase()}',
        textColor: JPAppTheme.themeColors.base,
        textSize: JPTextSize.heading3,
      );
    } else {
      return JPText(
        text: '${data.user!.firstName[0].toUpperCase()}'
            '${data.user!.lastName?[0].toUpperCase()}',
        textColor: JPAppTheme.themeColors.base,
        textSize: JPTextSize.heading3,
      );
    }
  }
}
