import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/consent_status/consent_label_details_model.dart';
import 'package:jobprogress/common/models/consent_status/consent_status_params.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'badge.dart';
import 'banner.dart';

class TransactionalConsentStatus extends StatelessWidget {
  const TransactionalConsentStatus({
    super.key,
    required this.params,
  });

  final ConsentStatusParams? params;

  ConsentLabelDetailsModel? get consentDetails =>
      ConsentHelper.getConsentDetails(params?.phoneConsentDetail?.consentStatusObs.value);

  @override
  Widget build(BuildContext context) {
    if (params?.phoneConsentDetail == null) {
      return const SizedBox();
    } else if (Helper.isTrue(params?.isComposeMessage)) {
      return Obx(
        () => TransactionalConsentStatusBanner(
          consentDetails: consentDetails!,
          params: params,
        ),
      );
    } else {
      return Obx(
        () => TransactionalConsentStatusBadge(
          consentDetails: consentDetails!,
          params: params,
        ),
      );
    }
  }
}
