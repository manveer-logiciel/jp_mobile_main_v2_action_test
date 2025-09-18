import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/consent_status/consent_label_details_model.dart';
import 'package:jobprogress/common/models/consent_status/consent_status_params.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jobprogress/global_widgets/link_text/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// [TransactionalConsentStatusBanner] helps in displaying consent banner
/// with more details that gives the option about to edit or get consent
class TransactionalConsentStatusBanner extends StatelessWidget {
  const TransactionalConsentStatusBanner({
    super.key,
    required this.consentDetails,
    required this.params,
    this.isToolTip = false,
  });

  /// [consentDetails] helps in displaying the consent details
  final ConsentLabelDetailsModel consentDetails;

  /// [params] provide additional details about the consent
  final ConsentStatusParams? params;

  /// Indicates whether this banner is displayed within a tooltip
  /// Used to apply different styling or behavior when shown in a tooltip context
  final bool isToolTip;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: consentDetails.color,
          width: 1
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title and Icon
          Row(
            children: [
              JPIcon(
                consentDetails.icon,
                color: consentDetails.color,
                size: 18,
              ),
              const SizedBox(
                width: 5,
              ),
              JPText(
                text: consentDetails.composeLabel.tr,
                textColor: consentDetails.color,
                fontWeight: JPFontWeight.bold,
                textSize: JPTextSize.heading4,
                height: 1,
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),

          /// Compose Message
          JPLinkText(
            text: consentDetails.composeMessage.tr,
            textSize: JPTextSize.heading5,
            height: 1.5,
          ),
          const SizedBox(
            height: 12,
          ),

          /// Consent Button
          JPButton(
            iconWidget: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 2
              ),
              child: JPIcon(
                Icons.edit,
                color: consentDetails.composeMessageButtonTextColor,
                size: 15,
              ),
            ),
            suffixIconWidget: const SizedBox(
              width: 8,
            ),
            text: consentDetails.composeMessageButtonText.tr.toUpperCase(),
            size: JPButtonSize.extraSmall,
            textColor: consentDetails.composeMessageButtonTextColor,
            colorType: consentDetails.composeMessageButtonColor,
            onPressed: () {
              ConsentHelper.navigateToObtainConsent(params);
            },
          )
        ],
      ),
    );
  }
}
