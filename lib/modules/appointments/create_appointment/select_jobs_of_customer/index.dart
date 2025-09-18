import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/global_widgets/job_switcher/header.dart';
import 'package:jobprogress/global_widgets/job_switcher/shimmer.dart';
import 'package:jobprogress/global_widgets/job_switcher/tile.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/modules/appointments/create_appointment/select_jobs_of_customer/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class SelectJobOfCustomerBottomSheet extends StatelessWidget {

  const SelectJobOfCustomerBottomSheet({
    super.key,
    this.customerID,
    required this.selectedJobs,
  });

  final int? customerID;
  final List<JobModel> selectedJobs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectJobOfCustomerController>(
        global: false,
        init: SelectJobOfCustomerController(customerID,selectedJobs),
        builder: (controller) {
      return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: JPAppTheme.themeColors.base,
          borderRadius: JPResponsiveDesign.bottomSheetRadius,
      ),
        child: JPSafeArea(
          child: ClipRRect(
            borderRadius: JPResponsiveDesign.bottomSheetRadius,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                JobSwitcherListingHeader(
                    title: '${'select'.tr.toUpperCase()} ${'jobs'.tr.toUpperCase()}',),
                Flexible(
                  child: AnimatedContainer(
                    width: MediaQuery.of(context).size.width,
                    constraints: BoxConstraints(
                      maxHeight: controller.isLoading
                          ? MediaQuery.of(context).size.height * 0.30
                          : MediaQuery.of(context).size.height * 0.90,
                    ),
                    duration: const Duration(milliseconds: 200),
                    child: controller.isLoading
                        ? const JobSwitcherShimmer()
                        : controller.customerJobList.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: controller.customerJobList.length,
                                itemBuilder: ((context, index) => Material(
                                  color: controller.getSelectedColor(controller.customerJobList[index]),
                                  child: InkWell(
                                      onTap: () {
                                        controller.getSelectedJobs(controller.customerJobList[index]);
                                        controller.update();
                                      },
                                      child: JobSwitcherTileView(
                                          job: controller.customerJobList[index])),
                                    )))
                            : NoDataFound(
                              icon: Icons.task,
                              title: "no_job_found".tr.capitalize,
                            ),
                  ),
                ),

                if(controller.customerJobList.isNotEmpty
                    && !controller.isLoading)
                  Padding(
                    padding:const EdgeInsets.symmetric(vertical: 10),
                    child: JPButton(
                      text: 'done'.tr.toUpperCase(),
                      onPressed: controller.setSelectedJobData,
                      size: JPButtonSize.small,
                      textColor: JPAppTheme.themeColors.base,
                      colorType: JPButtonColorType.tertiary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}