import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/call_logs/call_log.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/location_helper.dart';
import 'package:jobprogress/global_widgets/call_log/index.dart';
import 'package:jobprogress/global_widgets/email_button/index.dart';
import 'package:jobprogress/global_widgets/message/index.dart';
import 'package:jobprogress/modules/job/job_detail/widgets/detail_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobContactPersonTile extends StatelessWidget {
  const JobContactPersonTile({
    super.key,
    required this.contactPerson,
    required this.job,
    this.overflow = TextOverflow.ellipsis, 
    this.updateScreen,
  });

  final CompanyContactListingModel contactPerson;
  final JobModel job;
  final TextOverflow? overflow;
  final VoidCallback? updateScreen;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              Flexible(
                child: JPText(
                  text: contactPerson.fullName!.capitalize!,
                  textAlign: TextAlign.start,
                  textSize: JPTextSize.heading3,
                  fontWeight: JPFontWeight.medium,
                  overflow: overflow,
                ),
              ),
              const SizedBox(width: 7),
              Visibility(
                visible: contactPerson.isPrimary,
                child: JPChip(
                  text: "primary".tr,
                  textSize: JPTextSize.heading6,
                  textColor: JPAppTheme.themeColors.base,
                  backgroundColor: JPAppTheme.themeColors.success,
                ),
              )
            ],
          ),
        ),

        ///   Emails
        for ( int index = 0; index < (contactPerson.emails?.length ?? 0); index++ ) Column(
          children: [
            JobDetailTile(
              isVisible: contactPerson.emails?[index].email.isNotEmpty ?? false,
              label: "email".tr,
              description: contactPerson.emails?[index].email ?? "",
              isDescriptionSelectable: contactPerson.emails?[index].email.isNotEmpty ?? false,
              trailing: JPEmailButton(
                actionFrom: 'job_detail',
                jobId: job.id,
                fullName: contactPerson.emails?[index].email,
                email: contactPerson.emails?[index].email,
              )            
            ),
            divider(index != (contactPerson.emails?.length ?? 0)),
          ],
        ),

        ///   Phone
        for ( int index = 0; index < (contactPerson.phones?.length ?? 0); index++ ) Column(
          children: [
            JobDetailTile(
              showConsentStatus: true,
              updateScreen: updateScreen,
              phone: contactPerson.phones?[index],
              additionalEmails: contactPerson.emails,
              contactPersonId: contactPerson.id,
              isVisible: contactPerson.phones?[index].number?.isNotEmpty ?? false,
              isDescriptionSelectable: contactPerson.phones?[index].number?.isNotEmpty ?? false,
              label: contactPerson.phones?[index].label!.capitalize ?? "phone".tr,
              description: PhoneMasking.maskPhoneNumber(contactPerson.phones![index].number ?? ""),
              ext: contactPerson.phones?[index].ext ?? "",
              contact: contactPerson,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  JPSaveCallLog(
                    callLogs: CallLogCaptureModel(
                      customerId: job.customerId,
                      jobContactId: Helper.isTrue(job.isContactSameAsCustomer) ? null : contactPerson.id,
                      phoneLabel: contactPerson.phones![index].label!,
                      phoneNumber: contactPerson.phones![index].number!
                    )
                  ),
                  const SizedBox(width: 10,),
                  JPSaveMessageLog(
                    phone: contactPerson.phones![index].number!,
                    job: job,
                    consentStatus: contactPerson.phones?[index].consentStatus,
                    overrideConsentStatus: false,
                    // Contact Person & Phone Details are used to carry on contact person details
                    // while obtaining and editing consent
                    phoneModel: contactPerson.phones![index],
                    contactModel: contactPerson,
                  )
                ],
              ),
            ),
            divider(index != (contactPerson.phones?.length ?? 0)),
          ],
        ),

        ///   Address
        JobDetailTile(
          isVisible: contactPerson.addressString?.isNotEmpty ?? false,
          label: "address".tr,
          description: contactPerson.addressString ?? "",
          isDescriptionSelectable: contactPerson.addressString?.isNotEmpty ?? false,
          trailing: JPTextButton(
            onPressed: () {
              LocationHelper.openMapBottomSheet(query: contactPerson.addressString!);
            },
            color: JPAppTheme.themeColors.primary,
            icon: Icons.location_on,
            iconSize: 24,
          ),
        ),
      ],
    );
  }
}


Widget divider(bool dividerVisibility) => Visibility(
  visible: dividerVisibility,
  child: Divider(height: 1, color: JPAppTheme.themeColors.dimGray,)
);