import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/consent_status/consent_label_details_model.dart';
import 'package:jobprogress/common/models/consent_status/consent_status_params.dart';
import 'package:jobprogress/global_widgets/consent_status/widgets/transactional_consent_status/banner.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// [TransactionalConsentBadgeInfo] helps in displaying the consent details on tap of consent badge
/// 
/// Previously used a simple tooltip, but now displays a more interactive consent banner
/// that supports direct editing of consent status from within the tooltip.
class TransactionalConsentBadgeInfo extends StatelessWidget {
  const TransactionalConsentBadgeInfo({
    super.key,
    required this.consentDetails,
    required this.params,
  });

  /// [consentDetails] helps in displaying the consent details
  final ConsentLabelDetailsModel consentDetails;

  /// [params] provides consent status parameters to enable editing consent from the tooltip
  final ConsentStatusParams? params;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Material(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: JPText(
                        text: 'consent_status'.tr.toUpperCase(),
                        fontWeight: JPFontWeight.medium,
                        textSize: JPTextSize.heading4,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    JPTextButton(
                      onPressed: Get.back<void>,
                      icon: Icons.close,
                      iconSize: 24,
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),

                /// Body
                TransactionalConsentStatusBanner(
                  consentDetails: consentDetails,
                  params: params,
                ),
              ],
            ),
          ),
      ),
    );
  }
}
