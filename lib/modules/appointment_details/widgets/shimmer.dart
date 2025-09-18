
import 'package:flutter/material.dart';
import 'package:jobprogress/modules/appointment_details/widgets/attachments/shimmer.dart';
import 'package:jobprogress/modules/appointment_details/widgets/details/shimmer.dart';
import 'package:jobprogress/modules/appointment_details/widgets/job_details/shimmer.dart';
import 'package:jobprogress/modules/appointment_details/widgets/results/shimmer.dart';

class AppointmentDetailsShimmer extends StatelessWidget {
  const AppointmentDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 16,
          ),

          AppointmentDetailsCardShimmer(),

          SizedBox(height: 20,),

          AppointmentJobDetailsShimmer(),

          SizedBox(height: 20,),

          AppointmentDetailsAttachmentShimmer(),

          SizedBox(
            height: 20,
          ),

          AppointmentResultShimmer()
        ],
      ),
    );
  }
}
