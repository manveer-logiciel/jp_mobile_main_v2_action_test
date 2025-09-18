
import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/call_logs/call_log.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/email.dart';
import 'package:jobprogress/common/models/job/customer_info.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/utils/location_helper.dart';
import 'package:jobprogress/global_widgets/email_button/index.dart';
import 'package:jobprogress/global_widgets/message/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../global_widgets/call_log/index.dart';
import 'detail_tile.dart';

class JobOverviewContactPersonDetails extends StatelessWidget {
  const JobOverviewContactPersonDetails({
    super.key,
    this.list,
    required this.type,
    this.job,
    required this.personId,
    this.isDescriptionSelectable = false,
    this.emailList, 
    this.updateScreen, 
    this.customerInfo, 
    this.person,
  });

  /// list is used to store contact persons data
  final List<dynamic>? list;

  /// type is used to differentiate between data
  final String type;

  /// job is used to store job data
  final JobModel? job;

  /// personId is needed while making a call
  final int personId;

  /// email List is used to display email list
  final List<EmailModel>? emailList; 

  final VoidCallback? updateScreen;

  final List<CustomerInfo>? customerInfo;

  final bool isDescriptionSelectable;

  final CompanyContactListingModel? person;


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (_, index) {
          return typeToTile(list![index]);
        },
        itemCount: list?.length ?? 0,
    );
  }

  // displays tile as on basis of type
  Widget typeToTile(dynamic data) {
    switch(type) {
      case 'email' :
        return emailListTile(data as EmailModel);
      case 'phone' :
        return phoneListTile(data as PhoneModel);
      case 'location' :
        return locationTile(data as String);
      default:
        return const SizedBox();
    }
  }

  Widget emailListTile(EmailModel email) {
    return JobOverviewContactPersonDetailTile(
      title: email.email,
      isDescriptionSelectable: isDescriptionSelectable,
      trailing: [
        JPEmailButton(
          jobId: job!.id,
          fullName: email.email,
          email: email.email,
          actionFrom: 'job_detail',
        )
      ],
    );
  }

  Widget phoneListTile(PhoneModel phone) {
    return JobOverviewContactPersonDetailTile(
      showConsentStatus: true,
      updateScreen: updateScreen,
      customer: job?.isContactSameAsCustomer ?? false ? job?.customer : null,
      personId: job?.isContactSameAsCustomer ?? false ? null : personId,
      contact: job?.isContactSameAsCustomer ?? false ? null : person,
      phone: phone,
      emailList: emailList,
      isDescriptionSelectable: isDescriptionSelectable,
      title: PhoneMasking.maskPhoneNumber(phone.number ?? ''),
      trailing: [
        JPSaveCallLog(
          callLogs: CallLogCaptureModel(
            customerId: job!.customerId,
            jobId: job!.id,
            jobContactId: (job?.isContactSameAsCustomer ?? false) ? null : personId,
            phoneNumber: phone.number!,
            phoneLabel: phone.label!,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        JPSaveMessageLog(
          consentStatus: phone.consentStatus,
          overrideConsentStatus: false,
          phone: phone.number!,
          job: job,
          phoneModel: phone,
          contactModel: person,
        )
      ],
    );
  }

  Widget locationTile(String address) {
    return JobOverviewContactPersonDetailTile(
      title: address,
      isDescriptionSelectable: isDescriptionSelectable,
      trailing: [
        JPTextButton(
          icon: Icons.location_on,
          onPressed: () {
            LocationHelper.openMapBottomSheet(
              query: address
            );
          },
          color: JPAppTheme.themeColors.primary,
          iconSize: 24,
        ),
      ],
    );
  }

}
