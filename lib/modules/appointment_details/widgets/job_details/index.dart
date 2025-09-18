
import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/modules/appointment_details/widgets/job_details/detail_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AppointmentJobDetails extends StatelessWidget {

  const AppointmentJobDetails({
    super.key,
    required this.jobDetailsList, 
    this.jobId, 
    this.customer, 
    this.updateScreen,
  });

  final List<dynamic> jobDetailsList;
  final int? jobId;
  final CustomerModel? customer;
  final VoidCallback? updateScreen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: jobDetailsList.length > 1 ? 10 : 0,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(18),
        child: ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (_, index) {
              return AppointmentJobDetailTile(
                data: jobDetailsList[index],
                jobId: jobId, 
                updateScreen: updateScreen,
                customer: customer,
              );
            },
            separatorBuilder: (_, index) {
              return Divider(
                thickness: 1,
                height: 1,
                color: JPAppTheme.themeColors.dimGray,
              );
            },
            itemCount: jobDetailsList.length,
        ),
      ),
    );
  }
}
