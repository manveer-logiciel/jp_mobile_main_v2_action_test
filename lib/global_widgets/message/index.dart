import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/core/utils/message_send_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPSaveMessageLog extends StatelessWidget {
  final String phone;
  final String?  consentStatus;
  final bool isLargeIcon;
  final JobModel? job;
  final CustomerModel? customerModel;
  final CompanyContactListingModel? contactModel;
  final bool? overrideConsentStatus;
  final PhoneModel? phoneModel;

  const JPSaveMessageLog({
    super.key,
    required this.phone,
    this.isLargeIcon = false,
    this.job,
    this.customerModel,
    this.contactModel,
    this.consentStatus,
    this.overrideConsentStatus,
    this.phoneModel,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPColor.transparent,
      child: JPTextButton(
        onPressed: () => SaveMessageSendHelper().saveMessageLogs(
          phone,
          job:job,
          customerModel:customerModel,
          consentStatus: consentStatus,
          overrideConsentStatus: overrideConsentStatus,
          phoneModel: phoneModel,
          contactModel: contactModel,
        ),
        color: (isLargeIcon) ? JPAppTheme.themeColors.base : JPAppTheme.themeColors.primary,
        icon: Icons.sms,
        iconSize: 24,
      ),
    );
  }
}