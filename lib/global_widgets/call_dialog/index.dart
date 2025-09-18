import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/customer_info.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/global_widgets/call_dialog/phone_tile.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../core/utils/helpers.dart';

class JPCallDialog extends StatelessWidget {
  const JPCallDialog({
    super.key, 
    required this.jobModel,
    required this.customerInfo,
  });

  final JobModel jobModel;
  final List<CustomerInfo> customerInfo;

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        contentPadding: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  JPText(
                    text: "choose_number".tr.toUpperCase(),
                    textSize: JPTextSize.heading3,
                    fontWeight: JPFontWeight.medium,
                  ),
                  JPTextButton(
                    onPressed: () => Get.back(),
                    color: JPAppTheme.themeColors.text,
                    icon: Icons.clear,
                    iconSize: 24,
                  )
                ]
              ),
              const SizedBox(height: 20),
              /// list of customer number
              JPText(
                text: "customer".tr.toUpperCase(),
                textSize: JPTextSize.heading4,
                fontWeight: JPFontWeight.medium,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                separatorBuilder: (_, __) => Divider(height: 1, thickness: 1, color: JPAppTheme.themeColors.dimGray),
                itemCount: customerInfo.length,
                itemBuilder: (_, index) {
                  final data = customerInfo[index];
                  return ContactPhoneTile(
                    job: jobModel,
                    phones: data.phone != null ? [data.phone!] : [],
                  );
                },
              ),
              const SizedBox(height: 10),
              /// list of contact person number
              if (jobModel.contactPerson?.isNotEmpty ?? false) ...[
                JPText(
                  text: '${"contact_persons".tr.toUpperCase()} (${jobModel.contactPerson!.length})',
                  textSize: JPTextSize.heading4,
                  fontWeight: JPFontWeight.medium,
                ),
                const SizedBox(height: 10),
                Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    separatorBuilder: (_, __) => Divider(height: 5, thickness: 1, color: JPAppTheme.themeColors.dimGray),
                    itemCount: jobModel.contactPerson!.length,
                    itemBuilder: (_, index) {
                      final data = jobModel.contactPerson![index];
                      return ContactPhoneTile(
                        name: data.fullNameMobile, 
                        isPrimary: data.isPrimary,
                        job: jobModel,
                        phones: data.phones ?? [],
                        jobContactId: Helper.isTrue(jobModel.isContactSameAsCustomer) ? null : data.id!,
                        // Passing contact details only when Job Contact person is different than
                        // Job customer. If both are same, then it will be null
                        // It is used to carry on contact person details while obtaining and editing consent
                        contact: Helper.isTrue(jobModel.isContactSameAsCustomer) ? null : data,
                      );
                    },
                  ),
                ),
              ],
            ],
          )
        ),
      ),
    );
  }
}