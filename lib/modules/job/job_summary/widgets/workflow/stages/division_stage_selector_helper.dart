import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobOverviewDivisionStageSelectorHelper extends StatelessWidget {
  const JobOverviewDivisionStageSelectorHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 2, 16, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: JPAppTheme.themeColors.lightBlue
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: JPAppTheme.themeColors.primary,),
          const SizedBox(width: 8,),
          Expanded(
            child: JPText(
              text: 'job_workflow_update_info'.tr,
              textColor: JPAppTheme.themeColors.primary,
              textSize: JPTextSize.heading5,
              textAlign: TextAlign.start,
              height: 1.5,
            ),
          )
        ]
      )
    );
  }
}
