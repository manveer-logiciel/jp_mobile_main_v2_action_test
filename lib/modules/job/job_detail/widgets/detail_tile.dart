import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/consent_status/consent_status_params.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/consent_status/index.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jp_mobile_flutter_ui/IconButton/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobDetailTile extends StatelessWidget {

  const JobDetailTile({
    super.key,
    required this.isVisible,
    this.label,
    this.labelColor,
    this.description,
    this.descriptionWidget,
    this.descriptionColor,
    this.ext,
    this.imageURl,
    this.color,
    this.trailing,
    this.initial,
    this.isDescriptionSelectable = false, 
    this.showConsentStatus = false, 
    this.phone, 
    this.customerId, 
    this.email, 
    this.contactPersonId, 
    this.additionalEmails, 
    this.isAdditionalEmailsStringList = false, 
    this.updateScreen, 
    this.doShowCancelIcon = false,
    this.onTapCancel,
    this.customer,
    this.contact,
  });

  final bool isVisible;
  final String? label;
  final Color? labelColor;
  final String? description;
  final Widget? descriptionWidget;
  final Color? descriptionColor;
  final String? ext;
  final String? imageURl;
  final String? color;
  final Widget? trailing;
  final String? initial;
  final bool isDescriptionSelectable;
  final PhoneModel? phone;
  final bool showConsentStatus;
  final int? customerId;
  final int? contactPersonId;
  final String? email; 
  final List<dynamic>? additionalEmails;
  final bool isAdditionalEmailsStringList;
  final VoidCallback? updateScreen;
  final bool doShowCancelIcon;
  final VoidCallback? onTapCancel;
  final CustomerModel? customer;

  /// [contact] details are used in [JobOverviewContactPersonDetailTile] to carry
  /// further contact details while obtaining consent
  final CompanyContactListingModel? contact;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: isVisible,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: label?.isNotEmpty ?? false,
                      child: JPText(
                        text: label!,
                        textAlign: TextAlign.start,
                        textSize: JPTextSize.heading5,
                        textColor: labelColor ?? JPAppTheme.themeColors.tertiary,
                      ),
                    ),
                    const SizedBox(height: 6,),
                    Row(
                      children: [
                        Flexible(
                          child: getDescription()
                        ),
                        Visibility(
                          visible: doShowCancelIcon,
                          child: JPIconButton(
                            icon: Icons.close,
                            iconColor: JPAppTheme.themeColors.red,
                            backgroundColor: JPAppTheme.themeColors.base,
                            onTap: onTapCancel,
                          ),
                        ),
                        if (!ConsentHelper.isTransactionalConsent())
                          getConsentStatus(),
                      ],
                    ),
                    if (ConsentHelper.isTransactionalConsent()) ...{
                      const SizedBox(height: 10),
                      getConsentStatus(),
                    }
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 5
                ),
                child: trailing ?? const SizedBox.shrink(),
              )
            ],
          ),
        )
    );
  }

  Widget getDescription() {
    if(imageURl != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            JPProfileImage(
              size: JPAvatarSize.small,
              src: imageURl,
              color: color,
              initial: initial,
            ),
            Visibility(
              visible: description?.isNotEmpty ?? false,
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: JPText(
                    text: description ?? "",
                    textAlign: TextAlign.start,
                    textSize: JPTextSize.heading4,
                    fontWeight: JPFontWeight.medium,
                    textColor: descriptionColor,
                    isSelectable: isDescriptionSelectable,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (!Helper.isValueNullOrEmpty(ext)) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: description?.isNotEmpty ?? false,
              child: JPText(
                text: description ?? "",
                textAlign: TextAlign.start,
                textSize: JPTextSize.heading4,
                textColor: descriptionColor,
                isSelectable: isDescriptionSelectable,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Visibility(
                    visible: ext?.isNotEmpty ?? false,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: JPText(
                        text: "ext".tr,
                        textAlign: TextAlign.start,
                        textSize: JPTextSize.heading5,
                        textColor: JPAppTheme.themeColors.tertiary,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: ext?.isNotEmpty ?? false,
                    child: Expanded(
                      child: JPText(
                        text: ext ?? "",
                        textAlign: TextAlign.start,
                        textSize: JPTextSize.heading4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                 
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      if(label == "job_description".tr) {
        return Visibility(
          visible: description?.isNotEmpty ?? false || descriptionWidget != null,
          child: descriptionWidget ?? JPReadMoreText(
            description!,
            dialogTitle: label,
            textAlign: TextAlign.start,
            textSize: JPTextSize.heading4,
            textColor: descriptionColor,
            height: 1.3,
          ),
        );
      } else {
        return Visibility(
          visible: description?.isNotEmpty ?? false || descriptionWidget != null,
          child: descriptionWidget ?? JPText(
            text: description ?? "",
            textAlign: TextAlign.start,
            textSize: JPTextSize.heading4,
            textColor: descriptionColor,
            isSelectable: isDescriptionSelectable,
          ),
        );
      }
    }
  }

  Widget getConsentStatus() {
    return Visibility(
      visible: showConsentStatus,
      child: ConsentStatus(
        params: ConsentStatusParams(
          padding: const EdgeInsets.only(left: 8),
          phoneConsentDetail: phone,
          email: email,
          updateScreen: updateScreen,
          customerId: customerId,
          contactPersonId: contactPersonId,
          customer: customer,
          contact: contact,
          additionalEmails:Helper.convertEmailListToStringList(additionalEmails,isAlreadyString: isAdditionalEmailsStringList),
        ),
      ),
    );
  }
}