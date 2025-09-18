import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/appointments/list_tile/index.dart';
import 'package:jobprogress/modules/appointments/list_tile/shimmer.dart';
import 'package:jobprogress/modules/appointments/listing/controller.dart';
import 'package:jobprogress/modules/appointments/listing/secondary_header.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';


class AppointmentListingView extends StatelessWidget {
  const AppointmentListingView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentListingController>(
      global: false,
      init: AppointmentListingController(),
      builder: (controller) {
        return JPScaffold(
          scaffoldKey: controller.scaffoldKey,
          appBar: JPHeader(
            onBackPressed: () {
              Get.back();
            },
            title: 'appointments'.tr,
            actions: [
              if(!controller.isCustomerAppointments)
              IconButton(
                splashRadius: 20,
                onPressed: () {
                  controller.scaffoldKey.currentState!.openEndDrawer();
                },
                icon: JPIcon(
                  Icons.menu,
                  color: JPAppTheme.themeColors.base,
                )
              )
            ],
          ),
          endDrawer: JPMainDrawer(
            selectedRoute: 'appointments',
            onRefreshTap: () {
              controller.refreshList(showLoading: true);
            },
          ),
          body: JPSafeArea(
            top: false,
            containerDecoration: BoxDecoration(
              color: JPAppTheme.themeColors.inverse
            ),
            child: Container(
              color: JPAppTheme.themeColors.inverse,
              child: Column(
                children: [
                  AppointmentSecondaryHeader(appointmentController: controller),
                  controller.isLoading ?  const Expanded(child: AppointmentListingShimmer()):
                  controller.appointmentList.isNotEmpty ?
                  JPListView(
                    listCount: controller.appointmentList.length,
                    onLoadMore: controller.canShowLoadMore ? controller.loadMore : null,
                    onRefresh: controller.refreshList,
                    itemBuilder: (context, index) {
                      if(index < controller.appointmentList.length) {
                        return AppointmentListingTile(
                          appointment : controller.appointmentList[index],
                          onTap: () {
                            controller.navigateToAppointmentDetails(index);
                          },
                          onLongPress: () {
                            controller.openQuickActions(controller.appointmentList[index]);
                          },
                        );
                      } else if (controller.canShowLoadMore){
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Center(child: FadingCircle(color: JPAppTheme.themeColors.primary, size: 25)),
                        );
                      } else {
                        return const SizedBox(height: JPResponsiveDesign.floatingButtonSize);
                      }
                    },
                   ) : Expanded(
                    child: NoDataFound(
                        icon: Icons.event_note_outlined,
                        title: "no_appointment_found".tr.capitalize,
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Visibility(
            visible: PhasesVisibility.canShowSecondPhase && !controller.isCustomerAppointments,
            child: JPButton(
              size: JPButtonSize.floatingButton,
              iconWidget: JPIcon(
                Icons.add,
                color: JPAppTheme.themeColors.base,
              ),
              onPressed: controller.navigateToCreateAppointment,
            ),
          ),
        );
      }
    );
  }
}