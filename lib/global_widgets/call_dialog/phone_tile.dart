import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jobprogress/common/models/call_logs/call_log.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/global_widgets/call_log/index.dart';
import 'package:jobprogress/modules/job/job_summary/widgets/details/contact_persons/detail_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ContactPhoneTile extends StatelessWidget {
  const ContactPhoneTile({
    super.key, 
    this.name, 
    this.isPrimary = false, 
    required this.phones, 
    required this.job,
    this.jobContactId, 
    this.contact,
  });

  final String? name;
  final bool isPrimary;
  final List<PhoneModel> phones;
  final JobModel job;
  final int? jobContactId;

  /// [contact] details are used in [JobOverviewContactPersonDetailTile] to carry
  /// further contact details while obtaining consent
  final CompanyContactListingModel? contact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Row(
          children: [
            if (name?.isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: JPText(
                  text: name!,
                  textAlign: TextAlign.start,
                  textSize: JPTextSize.heading4,
                  fontWeight: JPFontWeight.medium,
                  textColor: JPAppTheme.themeColors.tertiary,
                ),
              ),
            if (isPrimary)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: JPAppTheme.themeColors.success,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: JPText(
                  text: 'primary'.tr.capitalize!,
                  textSize: JPTextSize.heading6,
                  textColor: JPAppTheme.themeColors.base,
                ),
              ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: phones.length,
          itemBuilder: (context, index) {
            final phone = phones[index];
            return JobOverviewContactPersonDetailTile(
              title: PhoneMasking.maskPhoneNumber(phone.number ?? ''),
              ext: phone.ext,
              label: phone.label?.capitalize,
              padding: const EdgeInsets.only(left: 5, bottom: 8),
              contact: contact,
              trailing: [
                JPSaveCallLog(
                  callLogs: CallLogCaptureModel(
                    customerId: job.customerId,
                    jobId: job.id,
                    jobContactId: jobContactId,
                    phoneNumber: phone.number!,
                    phoneLabel: phone.label!,
                  ),
                ),
              ],
            );
          }
        ),
      ],
    );
  }
}