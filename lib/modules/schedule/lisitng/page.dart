
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/job_overview_placeholders/header_placeholder.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/schedule/lisitng/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'widgets/index.dart';

class SchedulesListingView extends StatelessWidget {

  const SchedulesListingView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SchedulesListingController>(
      init: SchedulesListingController(),
      global: false,
      builder: (controller) => JPWillPopScope(
        onWillPop: controller.onWillPop,
        child: JPScaffold(
            backgroundColor: JPAppTheme.themeColors.inverse,
            appBar: JPHeader(
              onBackPressed: controller.onWillPop,
              title: controller.job != null ? controller.job!.customer!.fullName! : 'schedules'.tr.capitalize!,
              titleWidget: controller.job == null && controller.isLoading
                  ? const JobOverViewHeaderPlaceHolder()
                  : null,
            ),
            body: JPSafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16
                    ),
                    child: JPText(
                      text: controller.secondaryHeaderTitle,
                      fontWeight: JPFontWeight.medium,
                      textAlign: TextAlign.start,
                      maxLine: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ScheduleListing(
                    controller: controller,
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}
