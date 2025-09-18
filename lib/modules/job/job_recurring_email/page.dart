import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/modules/job/job_recurring_email/list_tile.dart';
import 'package:jobprogress/modules/job/job_recurring_email/shimmer.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class JobRecurringEmailView extends GetView<JobRecurringEmailController> {
  const JobRecurringEmailView({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobRecurringEmailController>( builder: (_) {
      return Scaffold(
        backgroundColor: JPAppTheme.themeColors.inverse,
        appBar: JPHeader(
          title: '${'recurring'.tr} ${'emails'.tr}',
          onBackPressed: () async {
            Get.back();
          },
        ),
        endDrawer: JPMainDrawer( onRefreshTap: controller.refreshData,),
        body: controller.isLoading ? 
          const JobRecurringEmailShimmer():
          !Helper.isValueNullOrEmpty(controller.recurringEmail)?
          Column(
            children: [
              JPListView(
                listCount: controller.recurringEmail!.length-1, itemBuilder: (_, index) {
                  return JobRecurringEmailTile(controller: controller, index: index);
                }
              ) 
            ],
          ): 
          NoDataFound(
            icon: JPScreen.isDesktop ? null : Icons.email,
            title: 'no_email_found'.tr.capitalize,
          )
        );
      }
    );
  }
}