import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/consent_status/consent_status_params.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/email.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/consent_status/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobOverviewContactPersonDetailTile extends StatelessWidget {
  const JobOverviewContactPersonDetailTile ({
    super.key,
    this.label,
    required this.title,
    this.ext,
    this.padding,
    this.trailing, 
    this.showConsentStatus = false, 
    this.isDescriptionSelectable = false,
    this.phone,
    this.personId, 
    this.customer, 
    this.emailList, 
    this.updateScreen,
    this.contact,

  });

  /// used to give label to tile
  final String? label;

  /// used to give title to tile
  final String title;

  /// in case of phone number used to display ext
  final String? ext;

  /// used to give padding to tile
  final EdgeInsets? padding;

  /// any set of icons/widgets can be passed here to display
  final List<Widget>? trailing;

  final bool showConsentStatus;

  final bool isDescriptionSelectable;

  final PhoneModel? phone;

  final int? personId;

  final CustomerModel? customer;

  final List<EmailModel>? emailList;

  final VoidCallback? updateScreen;

  final CompanyContactListingModel? contact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(
        top: 0,
        left: 16,
        right: 10,
        bottom: 8
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (label?.isNotEmpty ?? false)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: JPText(
                          text: label!,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    Flexible(
                      child: JPText(
                        text: title,
                        textAlign: TextAlign.start,
                        isSelectable: isDescriptionSelectable,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if(ext?.isNotEmpty ?? false) ...{
                      JPText(
                        text: 'ext'.tr,
                        textAlign: TextAlign.start,
                        textColor: JPAppTheme.themeColors.tertiary,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      JPText(
                        text: ext!,
                        textAlign: TextAlign.start,
                      ),
                    },
                    if (!ConsentHelper.isTransactionalConsent())
                      getConsentStatus(),
                  ],
                ),
                if (ConsentHelper.isTransactionalConsent()) ...{
                  const SizedBox(height: 10),
                  getConsentStatus(),
                  const SizedBox(height: 8),
                }
              ],
            ),
          ),
          Row(
            children: trailing ?? [],
          )
        ],
      ),
    );
  }

  Widget getConsentStatus() {
    return Visibility(
      visible: showConsentStatus,
      child: ConsentStatus(
        params: ConsentStatusParams(
          phoneConsentDetail: phone,
          customerId: customer?.id,
          additionalEmails: customer?.additionalEmails ?? Helper.convertEmailListToStringList(emailList ?? []),
          email: customer?.email,
          contactPersonId: personId,
          updateScreen: updateScreen,
          customer: customer,
          contact: contact
        ),
      ),
    );
  }

}
