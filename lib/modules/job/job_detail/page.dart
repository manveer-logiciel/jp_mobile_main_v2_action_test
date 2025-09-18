import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/job_customer_flags.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'widgets/index.dart';
import 'controller.dart';
import 'widgets/shimmer.dart';

class JobDetailView extends GetView<JobDetailController> {
  const JobDetailView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobDetailController>(
      global: false,
      init: JobDetailController(),
      builder: (JobDetailController controller) {
        return JPScaffold(
          backgroundColor: JPAppTheme.themeColors.inverse,
          appBar: JPHeader(
            backgroundColor: JPAppTheme.themeColors.inverse,
            backIconColor: JPAppTheme.themeColors.text,
            title: controller.jobModel?.customer?.fullName ?? "",
            centerTitle: true,
            titleColor: JPAppTheme.themeColors.text,
            onBackPressed: () => Get.back(result: controller.jobModel),
            actions: [
              IconButton(
                padding: EdgeInsets.zero,
                splashRadius: 20,
                color: JPAppTheme.themeColors.text,
                onPressed: () => controller.scaffoldKey.currentState!.openEndDrawer(),
                icon: const Icon(Icons.menu)
              ),
            ],
          ),
          scaffoldKey: controller.scaffoldKey,
          endDrawer: JPMainDrawer(
            selectedRoute: 'job_manager',
            onRefreshTap: controller.refreshPage,
          ),
          body: (controller.jobModel != null) ? JobScreenBody(
                emailCount: controller.emailCount,
                jobModel: controller.jobModel!,
                updateScreen: controller.refreshPage,
                addFlagCallback:(() =>  
                  JobCustomerFlags.showFlagsBottomSheet(
                    jobModel: controller.jobModel, 
                    id: controller.jobModel!.id, 
                    updateScreen: controller.update,
                  )
                ),
                launchMapCallback: controller.launchMapCallback,
                spaceBtwContactPersonNdDescriptionTile: controller.spaceBtwContactPersonNdDescriptionTile,
                spaceBtwDescriptionNdCustomerAddressTile: controller.spaceBtwDescriptionNdCustomerAddressTile,
                spaceBtwCustomerAddressNdJobContractTile: controller.spaceBtwCustomerAddressNdJobContractTile,
                handleDeliveryDateActions: controller.handleMaterialDeliveryDateActions,
                handleMaterialPOActions: controller.handleMaterialPOActions,
                handleDurationActions: controller.handleDurationActions,
                handleEditJobNameActions: controller.handleEditJobNameActions,
                onTapAdditionalFlags: controller.onTapAdditionalFlags,
                navigateToAddScreen: controller.navigateToAddScreen,
                navigateToEditScreen: controller.navigateToEditScreen,
                navigateToEditCustomerScreen: controller.navigateToEditCustomerScreen,
                handlePhoneAction: controller.openCustomerCallDialog,
                handleJobCompletionDateActions: controller.handleJobCompletionDateActions,
                handleJobContractSignedActions: controller.handleJobContractActions,
                handleEditJobDescription: controller.openDescriptionDialog,
                handleEditWorkCrew: controller.openWorkCrewDialog,
                handleEditCategory: controller.openCategoryDialog,
                handleEditJobDivisionActions: controller.openJobDivisionDialog
              )
            : const JobScreenShimmer()
        );
      }
    );
  }
}