
import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/call_logs/call_log.dart';
import 'package:jobprogress/common/models/job/customer_info.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/utils/location_helper.dart';
import 'package:jobprogress/global_widgets/call_log/index.dart';
import 'package:jobprogress/global_widgets/message/index.dart';
import 'package:jobprogress/modules/job/job_detail/widgets/detail_tile.dart';
import 'package:jobprogress/modules/job/job_summary/widgets/details/customer_info/email_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobOverViewCustomerInfoDetailTile extends StatelessWidget {
  const JobOverViewCustomerInfoDetailTile({
    super.key,
    required this.data,
    required this.job, 
    this.updateScreen, 
    this.onTapEmailHistory,
    this.isDescriptionSelectable = false,
  });

  /// data is used to store customer info
  final CustomerInfo data;

  /// job is used to store job data
  final JobModel job;

  final VoidCallback? updateScreen;

  final VoidCallback? onTapEmailHistory;

  final bool isDescriptionSelectable;

  @override
  Widget build(BuildContext context) {
    return dataToTile();
  }

  // displays data as per tile
  Widget dataToTile() {
    if(data.email != null){
      return JobSummaryCustomerRepEmailTile(
        data: data, 
        job: job,
        onTapEmailHistory: onTapEmailHistory,
      );
    }
    else if(data.phone != null) {
      return phoneTile();
    } else if(data.address != null) {
      return addressTile();
    } else if(data.leadSource != null) {
      return additionalDetails(data.leadSource!);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget phoneTile() {
    return JobDetailTile(
      isVisible: true,
      label: data.label,
      showConsentStatus: true,
      isAdditionalEmailsStringList: true,
      phone: data.phone,
      email: job.customer?.email,
      customerId: job.customerId,
      additionalEmails: job.customer?.additionalEmails,
      labelColor: JPAppTheme.themeColors.tertiary,
      description: PhoneMasking.maskPhoneNumber(data.phone?.number ?? ''),
      descriptionColor: JPAppTheme.themeColors.text,
      updateScreen: updateScreen,
      isDescriptionSelectable: isDescriptionSelectable,
      customer: job.customer,
      trailing: Row(
        children: [
          JPSaveCallLog(
              callLogs: CallLogCaptureModel(
                  customerId: job.customerId,
                  phoneNumber: data.phone!.number!,
                  phoneLabel: data.phone!.label!,
              ),
          ),
          const SizedBox(
            width: 10,
          ),
          JPSaveMessageLog(
            phone: data.phone!.number!,
            overrideConsentStatus: false,
            consentStatus: data.phone?.consentStatus,
            job: job,
            phoneModel: data.phone,
          )
        ],
      ),
    );
  }

  Widget addressTile() {
    return JobDetailTile(
      isVisible: true,
      label: data.label,
      labelColor: JPAppTheme.themeColors.tertiary,
      description: data.addressString.toString(),
      descriptionColor: JPAppTheme.themeColors.text,
      isDescriptionSelectable: isDescriptionSelectable,
      trailing: JPTextButton(
        icon: Icons.location_on,
        onPressed: () {
          LocationHelper.openMapBottomSheet(
            address: data.address,
            query: data.addressString
          );
        },
        iconSize: 24,
        color: JPAppTheme.themeColors.primary,
      ),
    );
  }

  Widget additionalDetails(String description) {
    return JobDetailTile(
      isVisible: true,
      label: data.label,
      labelColor: JPAppTheme.themeColors.tertiary,
      description: description.toString(),
      descriptionColor: JPAppTheme.themeColors.text,
      isDescriptionSelectable: true
    );
  }

}
