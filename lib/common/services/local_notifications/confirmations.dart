
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/app_state.dart';
import 'package:jobprogress/common/extensions/get_navigation/extension.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/company_switch_dialog_box/controller.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';

class LocalNotificationConfirmation {

  static List<String> dataLostProneRoutes = [
    Routes.createTaskForm,
    Routes.formProposalMergeTemplate,
    Routes.formProposalTemplate,
    Routes.imageEditor,
    Routes.composeEmail,
    Routes.createAppointmentForm,
    Routes.createEventForm,
    Routes.receivePaymentForm,
    Routes.applyPaymentForm,
    Routes.quickMeasureForm,
    Routes.applyCreditForm,
    Routes.eagleViewForm,
    Routes.createCompanyContact,
    Routes.customerForm,
    Routes.refundForm,
    Routes.billForm,
    Routes.measurementForm,
    Routes.addMultipleMeasurement,
    Routes.invoiceForm,
    Routes.insuranceForm,
    Routes.changeOrderForm,
    Routes.jobForm,
    Routes.projectForm,
    Routes.insuranceDetailsForm,
    Routes.selectFavorite,
    Routes.worksheetForm,
    Routes.worksheetSetting,
    Routes.macroListing,
    Routes.macroListDetail,
    Routes.placeSupplierOrderForm,
    Routes.handWrittenTemplate,
    Routes.supportForm,
    Routes.tierSearch,
    Routes.externalTemplateWebView,
    Routes.externalTemplateWebView,
    Routes.reviewPaymentDetails,
    Routes.receivePaymentForm,
  ];

  static bool doShowScreenSwitchConfirmation() {
    if(dataLostProneRoutes.any((route) => Get.currentRoute == route)) {
      return true;
    }
    return false;
  }

  static bool doShowCompanySwitchConfirmation(int? compId) {
    if(compId != null && AuthService.userDetails?.companyDetails?.id != compId) {
      return true;
    }
    return false;
  }

  static void showScreenSwitchConfirmationDialog({required VoidCallback onConfirmation}) {
    showJPBottomSheet(
        child: (_) => JPConfirmationDialog(
          title: 'confirmation'.tr,
          subTitle: 'push_notification_screen_switch_description'.tr,
          suffixBtnText: 'confirm'.tr,
          icon: Icons.warning_amber,
          onTapPrefix: Get.back<void>,
          onTapSuffix: () {
            Get.offAllToFirst();
            onConfirmation();
          },
        ),
    );
  }

  static void showCompanySwitchConfirmationDialog({required int compId, required VoidCallback onConfirmation}) {

    bool isDataLostPronePage = doShowScreenSwitchConfirmation();

    showJPBottomSheet(
        child: (sheetController) => JPConfirmationDialog(
          title: 'confirmation'.tr,
          subTitle: isDataLostPronePage ? 'push_notification_company_switch_description2'.tr : 'push_notification_company_switch_description1'.tr,
          suffixBtnText: sheetController.isLoading ? null : 'confirm'.tr,
          disableButtons: sheetController.isLoading,
          suffixBtnIcon: showJPConfirmationLoader(
            show: sheetController.isLoading
          ),
          icon: Icons.warning_amber,
          onTapPrefix: Get.back<void>,
          onTapSuffix: () async {
            sheetController.toggleIsLoading();
            await switchCompany(compId).then((value) {
              onConfirmation();
              sheetController.toggleIsLoading();
            }).catchError((e) {
              sheetController.toggleIsLoading();
            });
          },
        ),
    );
  }

  static Future<void> switchCompany(int compId) async {
    try {
      appState = JPAppState.loadingData;
      final CompanySwitchController controller = Get.put(CompanySwitchController());
      await controller.getCompanySwitchData();
      final companiesList = controller.loggedInUser.allCompanies ?? [];

      if(companiesList.any((companies) => companies.id == compId)) {
        await controller.switchCompany(compId);
      } else {
        Helper.showToastMessage('company_does_not_exist'.tr);
        Get.back();
      }
    } catch (e) {
      appState = JPAppState.setUpDone;
      rethrow;
    }
  }

}