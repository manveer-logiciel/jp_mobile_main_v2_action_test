import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/modules/calendar/job_schedule/listing/widgets/secondary_header.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../global_widgets/safearea/safearea.dart';
import '../../../../global_widgets/scaffold/index.dart';
import 'controller.dart';
import 'widgets/job_schedule_list.dart';

class JobScheduleListingView extends StatelessWidget {
  const JobScheduleListingView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobScheduleListingController>(
      init: JobScheduleListingController(),
      global: false,
      builder: (controller) {
        return JPScaffold(
        appBar: JPHeader(
          title: 'select_job_or_project'.tr.capitalize!,
          onBackPressed: () => Get.back(),
        ),
        body: JPSafeArea(
          top: false,
          containerDecoration: BoxDecoration(color: JPAppTheme.themeColors.base),
          child: Container(
            color: JPAppTheme.themeColors.inverse,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 11, top: 16,),
                  child: JPInputBox(
                    type: JPInputBoxType.searchbar,
                    controller: controller.textController,
                    onChanged: controller.onSearchTextChanged,
                    debounceTime: 700,
                    hintText: "search".tr,
                  ),
                ),
                JobScheduleListingSecondaryHeader(controller: controller),
                JobScheduleList(controller: controller),
              ],
            ),
          ),
        ),
      );
      });
  }
}
