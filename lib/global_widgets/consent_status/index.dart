import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/consent_status/consent_status_params.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/global_widgets/consent_status/widgets/default_consent_status.dart';
import 'package:jobprogress/global_widgets/consent_status/widgets/transactional_consent_status/index.dart';

class ConsentStatus extends StatefulWidget {
  const ConsentStatus({
    super.key,
    required this.params,
  });

  final ConsentStatusParams? params;

  @override
  State<ConsentStatus> createState() => _ConsentStatusState();
}

class _ConsentStatusState extends State<ConsentStatus> {

  bool get isTransactional => LDService.hasFeatureEnabled(LDFlagKeyConstants.transactionalMessaging);

  @override
  void initState() {
    /// Set Obs Consent Status to listen value changes in realtime
    widget.params?.updateConsentStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isTransactional ? EdgeInsets.zero : (widget.params?.padding ?? EdgeInsets.zero),
      child: isTransactional ? TransactionalConsentStatus(
        params: widget.params,
      ) : DefaultConsentStatus(
        params: widget.params,
      ),
    );
  }
}