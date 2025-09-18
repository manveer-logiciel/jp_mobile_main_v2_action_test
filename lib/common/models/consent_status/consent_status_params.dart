import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/consent_status/index.dart';

/// [ConsentStatusParams] is you refine and make the [ConsentStatus] widget's code
/// scalable and easily maintainable
class ConsentStatusParams {
  final PhoneModel? phoneConsentDetail;
  final EdgeInsets? padding;
  final String? email;
  final List<String?>? additionalEmails;
  final int? customerId;
  final int? contactPersonId;
  final VoidCallback? updateScreen;
  final bool isComposeMessage;
  final bool isLoadingMeta;
  final CustomerModel? customer;
  final CompanyContactListingModel? contact;
  final JobModel? job;
  final Function(String)? onConsentChanged;
  late bool isToolTip;

  ConsentStatusParams({
    this.phoneConsentDetail,
    this.padding,
    this.email,
    this.additionalEmails,
    this.customerId,
    this.contactPersonId,
    this.updateScreen,
    this.isComposeMessage = false,
    this.isLoadingMeta = false,
    this.onConsentChanged,
    this.customer,
    this.job,
    this.contact,
    this.isToolTip = false,
  }) {
   updateConsentStatus();
  }

  /// [updateConsentStatus] will refresh the consent status all over the place in the UL
  void updateConsentStatus() {
    phoneConsentDetail?.setObsConsentStatus();
  }

  List<String?> getEmails() {
    List<String?> emails = [];
    emails.addIf(!Helper.isValueNullOrEmpty(phoneConsentDetail?.consentEmail), phoneConsentDetail?.consentEmail);
    emails.addAllIf(!Helper.isValueNullOrEmpty(contact?.emails), contact?.emails?.map((e) => e.email).toList() ?? []);
    emails.addIf(!Helper.isValueNullOrEmpty(customer?.email), customer?.email);
    emails.addAllIf(!Helper.isValueNullOrEmpty(customer?.additionalEmails), customer?.additionalEmails ?? []);
    emails.addIf(!Helper.isValueNullOrEmpty(job?.customer?.email), job?.customer?.email);
    emails.addAllIf(!Helper.isValueNullOrEmpty(job?.customer?.additionalEmails), job?.customer?.additionalEmails ?? []);
    emails.removeWhere((element) => Helper.isValueNullOrEmpty(element));
    emails = emails.toSet().toList();
    return emails;
  }

  /// Sets the tooltip flag to indicate whether the consent UI is shown in a tooltip
  ///
  /// This flag is used to determine how to handle consent status updates,
  /// particularly for closing the tooltip when consent is updated.
  ///
  /// [isToolTip] - Boolean value indicating whether the consent UI is in a tooltip
  void setToolTip(bool isToolTip) {
    this.isToolTip = isToolTip;
  }
}