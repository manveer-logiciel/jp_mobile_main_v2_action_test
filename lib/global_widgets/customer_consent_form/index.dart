import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/customer_consent_form/widgets/body.dart';
import 'package:jobprogress/global_widgets/customer_consent_form/widgets/footer.dart';
import 'package:jobprogress/global_widgets/customer_consent_form/widgets/header.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../global_widgets/safearea/safearea.dart';
import 'controller.dart';

class ConsentFormDialog extends StatelessWidget {
  const ConsentFormDialog({
    super.key,
    this.emails,
    this.previousEmail,
    this.phoneNumber,
    this.customerId, 
    this.contactPersonId, 
    this.updateScreen,
    this.obtainedConsent,
  });

  final List<String?>? emails;
  final String? previousEmail;
  final String? phoneNumber;
  final int? customerId;
  final int? contactPersonId;
  final VoidCallback? updateScreen;
  final String? obtainedConsent;

  @override
  Widget build(BuildContext context) {
    final consentFormController = Get.put(
      ConsentFormDialogController(
        previousEmail: previousEmail,
        emailList: emails,
        phoneNumber: phoneNumber,
        customerId: customerId,
        updateScreen: updateScreen,
        obtainedConsent: obtainedConsent,
      ),
    );
    return GestureDetector(
      onTap: () => Helper.hideKeyboard(),
      child: JPSafeArea(
        child: GetBuilder<ConsentFormDialogController>(
          builder: (_) => AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            content: Builder(
              builder: (context) => Container(
                width: double.maxFinite,
                padding: const EdgeInsets.fromLTRB(20, 13, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConsentFormHeader(controller: consentFormController),
                    ConsentFormBody(controller: consentFormController),
                    Visibility(
                      visible: consentFormController.showEmailField,
                      child: ConsentFormFooter(controller: consentFormController)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}