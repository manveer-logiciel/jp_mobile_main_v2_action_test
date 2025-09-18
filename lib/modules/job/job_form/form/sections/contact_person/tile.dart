import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/contact_person/widgets/phones.dart';
import 'package:jp_mobile_flutter_ui/Label/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'widgets/emails.dart';

class JobFormContactPersonTile extends StatelessWidget {
  const JobFormContactPersonTile({
    super.key,
    required this.data,
    this.onTapEdit,
    this.onTapDelete,
    this.isDisabled = false,
  });

  final CompanyContactListingModel data;

  /// It can be used to perform edit contact person on button click
  final VoidCallback? onTapEdit;
  
  /// It can be used to perform delete contact person on button click
  final VoidCallback? onTapDelete;

  /// It can be used to disable edit button while saving form
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: JPText(
                        text: data.fullName ?? data.firstName ?? "",
                        fontWeight: JPFontWeight.medium,
                        textAlign: TextAlign.start,
                      ),
                    ),

                    const SizedBox(
                      width: 5,
                    ),

                    if (data.isPrimary)
                      Transform.scale(
                        scale: 0.9,
                        child: JPLabel(
                          key: const Key(WidgetKeys.primaryKey),
                          text: 'primary'.tr,
                          type: JPLabelType.success,
                          textSize: JPTextSize.heading5,
                        ),
                      )

                  ],
                ),
              ),
              editIcons(),
            ],
          ),

          if (data.emails?.isNotEmpty ?? false) ...{
            const SizedBox(height: 10,),
            JobFormContactPersonEmails(emails: data.emails),
          },

          if (data.phones?.isNotEmpty ?? false) ...{
            const SizedBox(height: 10,),
            JobFormContactPersonPhones(phones: data.phones),
          },
        ],
      ),
    );
  }

  Widget editIcons() {
    return Transform.translate(
      offset: const Offset(5, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          JPTextButton(
            icon: Icons.edit_outlined,
            color: JPAppTheme.themeColors.primary,
            onPressed: onTapEdit,
            isDisabled: isDisabled,
            iconSize: 20,
          ),

          const SizedBox(
            width: 2,
          ),

          JPTextButton(
            icon: Icons.close,
            color: JPAppTheme.themeColors.secondary,
            onPressed: onTapDelete,
            isDisabled: isDisabled,
            iconSize: 20,
          )
        ],
      ),
    );
  }
}
