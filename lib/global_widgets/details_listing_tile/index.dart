import 'package:flutter/material.dart';

import '../../common/enums/cj_list_type.dart';
import '../../common/enums/page_type.dart';
import '../../common/models/customer/customer.dart';
import '../../common/models/job/job.dart';
import 'customer.dart';
import 'job.dart';

class CustomerJobDetailListingTile extends StatelessWidget {
  const CustomerJobDetailListingTile({
    super.key,
    required this.listType,
    this.pageType,
    this.customer,
    this.navigateToCustomerDetailScreen,
    this.openCustomerQuickActions,
    this.job,
    this.navigateToJobDetailScreen,
    this.openJobQuickActions,
    this.customerIndex,
    this.borderRadius,
    this.openDescDialog,
    this.isLoadingMetaData = false,
    this.onProjectCountPressed,
    this.appointmentDate, 
    this.updateScreen,
    this.onTapEmailAction,
    this.onTapAppointmentChip,
    this.onTapJobSchedule,
    this.onTapProgressBoard,
  });

  final CJListType listType;
  final PageType? pageType;
  final CustomerModel? customer;
  final void Function({int? customerID, int? index})? navigateToCustomerDetailScreen;
  final void Function({CustomerModel? customer, int? index})? openCustomerQuickActions;
  final JobModel? job;
  final void Function({int? jobID, int? currentIndex})? navigateToJobDetailScreen;
  final void Function({JobModel? job, int? index})? openJobQuickActions;
  final int? customerIndex;
  final double? borderRadius;
  final bool? isLoadingMetaData;
  final void Function({JobModel? job, int? index})? openDescDialog;
  final void Function({int? index})? onProjectCountPressed;
  final String? appointmentDate;
  final VoidCallback? updateScreen;
  final void Function()? onTapEmailAction;

  /// [onTapAppointmentChip] handles the click on appointment chip in the customer list tile
  final VoidCallback? onTapAppointmentChip;

  /// [onTapJobSchedule] handles the click on job schedule chip in the job list tile
  final VoidCallback? onTapJobSchedule;

  /// [onTapProgressBoard] handles the click on progress board chip in the job list tile
  final VoidCallback? onTapProgressBoard;

  @override
  Widget build(BuildContext context) {
    switch(listType) {
      case CJListType.customer:
        return CustomerListTile(
          customer: customer!,
          navigateToDetailScreen: navigateToCustomerDetailScreen,
          openQuickActions: openCustomerQuickActions,
          customerIndex: customerIndex!,
          borderRadius: borderRadius,
          isLoadingMetaData: isLoadingMetaData,
          pageType: pageType,
          updateScreen: updateScreen,
          onTapEmailAction: onTapEmailAction,
          onTapAppointmentChip: onTapAppointmentChip,
        );
      case CJListType.job:
      case CJListType.projectJobs:
      case CJListType.scheduledJobs:
      case CJListType.nearByJobs:
        job?.listType = listType;
        return JobListTile(
          job: job!,
          navigateToDetailScreen: navigateToJobDetailScreen,
          openQuickActions: openJobQuickActions,
          index: customerIndex!,
          borderRadius: borderRadius,
          openDescDialog: openDescDialog,
          isLoadingMetaData: isLoadingMetaData,
          onProjectCountPressed: onProjectCountPressed,
          pageType: pageType,
          onTapJobSchedule: onTapJobSchedule,
          onTapProgressBoard: onTapProgressBoard,
        );
    }
  }
}
