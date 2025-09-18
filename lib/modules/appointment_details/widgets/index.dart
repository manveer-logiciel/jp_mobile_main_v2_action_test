
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/modules/appointment_details/controller.dart';
import 'package:jobprogress/modules/appointment_details/widgets/attachments/index.dart';
import 'package:jobprogress/modules/appointment_details/widgets/details/index.dart';
import 'package:jobprogress/modules/appointment_details/widgets/job_details/index.dart';
import 'package:jobprogress/modules/appointment_details/widgets/results/index.dart';

import 'shimmer.dart';

class AppointmentDetails extends StatelessWidget {

  const AppointmentDetails({
    super.key,
    required this.controller,
  });

  final AppointmentDetailsController controller;

  @override
  Widget build(BuildContext context) {

    if(controller.isLoading) {
      return const AppointmentDetailsShimmer();
    } else if(controller.appointment != null) {

      AppointmentModel appointment = controller.appointment!;

      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 16,
            ),
            AppointmentDetailsCard(
              appointment: appointment,
              onTapComplete: controller.showConfirmationDialog,
              onTapJobs: controller.showJobsSheet,
              location: controller.launchMapCallback
            ),
            const SizedBox(height: 10),
            if(appointment.job!.isNotEmpty)...{
              AppointmentJobDetails(
                jobDetailsList: controller.jobDetailsList,
                jobId: appointment.job![0].id,
                customer: appointment.customer,
                updateScreen: controller.refreshPage,
              )
            } else...{
              AppointmentJobDetails(
                jobDetailsList: controller.jobDetailsList,
                updateScreen: controller.refreshPage,
              )
            },
            const SizedBox(height: 10),
            if(appointment.attachments != null &&
                appointment.attachments!.isNotEmpty)...{
              AppointmentDetailAttachments(
                attachments: appointment.attachments!,
              ),
              const SizedBox(
                height: 20,
              ),
            },

            AppointmentResult(
              results: appointment.results,
              resultOption: appointment.resultOption,
              onTapBtn: controller.showAppointmentResultDialog,
            ),

            const SizedBox(
              height: 16,
            ),
          ],
        ),
      );

    } else {
      return NoDataFound(
        icon: Icons.calendar_month_sharp,
        title: 'no_appointment_found'.tr.capitalize,
      );
    }
  }
}
