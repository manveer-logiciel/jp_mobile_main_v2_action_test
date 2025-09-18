import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/consent_status/consent_label_details_model.dart';
import 'package:jobprogress/common/models/consent_status/consent_status_params.dart';
import 'package:jobprogress/core/constants/consent_status_constants.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';

/// [TransactionalConsentStatusBadge] helps in displaying consent status badge
/// in case of transactional consent. It is used to display in listings and
/// detail pages.
class TransactionalConsentStatusBadge extends StatelessWidget {
  const TransactionalConsentStatusBadge({
    super.key,
    required this.consentDetails,
    this.params
  });

  /// [consentDetails] helps in displaying the consent details
  final ConsentLabelDetailsModel? consentDetails;

  /// [params] provide additional details about the consent
  final ConsentStatusParams? params;

  @override
  Widget build(BuildContext context) {
    if (Helper.isTrue(params?.isLoadingMeta)) {
      return Shimmer.fromColors(
        baseColor: JPAppTheme.themeColors.dimGray,
        highlightColor: JPAppTheme.themeColors.inverse,
        child: SizedBox(
          height: 24,
          width: 100,
          child: JPLabel(
            backgroundColor: JPAppTheme.themeColors.primary,
            text: '',
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTapBadge,
      onLongPress: () {}, // Helps in eliminating ripple effect over parent widget
      borderRadius: BorderRadius.circular(20),
      child: JPChip(
        textSize: JPTextSize.heading6,
        avatarBorderColor: JPColor.transparent,
        text: consentDetails!.label.tr,
        child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: consentDetails!.color
          ),
          child: Center(
            child: JPIcon(
              consentDetails!.icon,
              color: Colors.white,
              size: 10,
            ),
          ),
        ),
      ),
    );
  }

  /// Handle tap on the consent badge to perform appropriate action
  ///
  /// - For empty/null status, navigates to obtain consent
  /// - For 'resend' status, resends the consent request
  /// - For other statuses, shows consent badge info with params to enable consent editing from tooltip
  void onTapBadge() {
    if (Helper.isValueNullOrEmpty(params?.phoneConsentDetail?.consentStatus)) {
      ConsentHelper.navigateToObtainConsent(params);
    } else if (params?.phoneConsentDetail?.consentStatus == ConsentStatusConstants.resend) {
      ConsentHelper.resendConsent(params);
    } else {
      ConsentHelper.showConsentBadgeInfo(consentDetails!, params: params);
    }
  }
}
