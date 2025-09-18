import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/appointment_details/widgets/index.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class AppointmentDetailsView extends StatelessWidget {

  const AppointmentDetailsView({
    super.key,
    this.appointmentId,
    this.onAppointmentDelete,
    this.onAppointmentUpdate
  });

  final int? appointmentId;

  final VoidCallback? onAppointmentDelete;

  final Function(AppointmentModel appointment)? onAppointmentUpdate;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentDetailsController>(
      init: AppointmentDetailsController(
          tempAppointmentId: appointmentId,
          onAppointmentDelete: onAppointmentDelete,
          onAppointmentUpdate: onAppointmentUpdate
      ),
      global: false,
      builder: (controller) {
        return JPWillPopScope(
          onWillPop: controller.onWillPop,
          child: JPScaffold(
            scaffoldKey: controller.scaffoldKey,
            backgroundColor: JPAppTheme.themeColors.dimGray,
            appBar: JPHeader(
              backgroundColor: JPColor.transparent,
              backIconColor: JPAppTheme.themeColors.text,
              onBackPressed: controller.onWillPop,
              actions: [
                /// more icon
               if(controller.appointment != null)
                actions(
                 onTap: controller.typeToHeaderAction
                ),

                const SizedBox(
                  width: 3,
                ),
                /// drawer icon
                Center(
                  child: JPTextButton(
                    icon: Icons.menu,
                    iconSize: 24,
                    onPressed: () {
                      controller.scaffoldKey.currentState?.openEndDrawer();
                    },
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
              ],
            ),
            endDrawer: JPMainDrawer(),
            body: JPSafeArea(
                child: AppointmentDetails(controller: controller),
            ),
          ),
        );
      }
    );
  }

  Widget actions({Function(String val)? onTap}) {
    return Center(
      child: JPPopUpMenuButton<String>(
        itemList: [
          if(PhasesVisibility.canShowSecondPhase) 'duplicate',
          if(PhasesVisibility.canShowSecondPhase) 'edit',
          'delete',
        ],
        popUpMenuChild: (val) {
          return Padding(
            padding: const EdgeInsets.all(2),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10
              ),
              child: Row(
                children: [
                  JPText(text: val.tr.capitalize!),
                  const SizedBox(
                    width: 40,
                  ),
                ],
              ),
            ),
          );
        },
        onTap: onTap,
        offset: const Offset(0, 35),
        popUpMenuButtonChild: Padding(
          padding: const EdgeInsets.all(6.0),
          child: JPIcon(
            Icons.more_vert,
            color: JPAppTheme.themeColors.text,
          ),
        ),
      ),
    );
  }

}