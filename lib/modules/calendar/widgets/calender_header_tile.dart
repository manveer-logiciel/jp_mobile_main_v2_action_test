import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../core/utils/helpers.dart';

class CalenderHeaderTile extends StatelessWidget {
  const CalenderHeaderTile({
    super.key,
     this.job, required this.isProductionCalendar,
  });
  
  final JobModel? job;
  final bool isProductionCalendar;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(job != null)...{
          JPText(
            text: job!.customer?.fullName ?? job!.name!,
            textColor: JPAppTheme.themeColors.base,
            fontWeight: JPFontWeight.medium,
          ),
          const SizedBox(height: 3,),
          JPText(
            text: Helper.getJobName(job!),
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.base,
          ),
        } else...{
          JPText(
            textColor: JPAppTheme.themeColors.base,
            fontWeight: JPFontWeight.medium,
            text:  isProductionCalendar ? 'production_calendar'.tr : 'staff_calendar'.tr)
        }
      ]);
    }
  }