import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/consent_status/consent_status_params.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/consent_status/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';

class SaveMessageSendHelper {

  Future<void> saveMessageLogs(
      String phone, {
        String? consentStatus,
        JobModel? job,
        bool? overrideConsentStatus,
        CustomerModel? customerModel,
        PhoneModel? phoneModel,
        CompanyContactListingModel? contactModel,
        Function(String)? onAction
      }) async {

    /// [actionsKey] will be used to update main actions list
    GlobalKey<JPQuickActionState> actionsKey = GlobalKey();

    /// [getMainList] will be used to get updated main actions list
    List<JPQuickActionModel> getMainList() => FilesListingService.sendViaTextOptions(consentStatus: phoneModel?.consentStatus ?? consentStatus, overrideConsentStatus: overrideConsentStatus);

    FilesListingQuickActionParams param = FilesListingQuickActionParams(
      jobModel: job,
      customerModel: customerModel,
      fileList: [],
      onActionComplete: (FilesListingModel model, action) {},
    );

    showJPBottomSheet(child: (sheetController) {
      return JPQuickAction(
        key: actionsKey,
        mainList: getMainList(),
        subHeader: phoneModel != null ? Padding(
          padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16
          ),
          child: ConsentStatus(
            params: ConsentStatusParams(
                phoneConsentDetail: phoneModel,
                isComposeMessage: true,
                customer: customerModel,
                contact: contactModel,
                job: job,
                onConsentChanged: (updatedConsent) {
                  // Updating consent status
                  phoneModel.consentStatus = consentStatus = updatedConsent;
                  // Refreshing the sheet UI
                  sheetController.update();
                  // Updating the actions list as per Consent Status
                  actionsKey.currentState?.updateMainList(getMainList());
                }
            ),
          ),
        ) : null,
        onItemSelect: (value) {
          Get.back();
          FilesListingService.handleQuickAction(value, param,
            phone: phone,
            job: job,
            customerModel: customerModel,
            phoneModel: phoneModel,
            consentStatus: consentStatus
          );
        },
      );
    });
  }
}