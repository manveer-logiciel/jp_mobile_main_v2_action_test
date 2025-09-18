
// ignore_for_file: sdk_version_since

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/appointment_form_type.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/appointment/appointment_result/appointment_result_options.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/repositories/appointment.dart';
import 'package:jobprogress/common/repositories/customer_listing.dart';
import 'package:jobprogress/common/services/appointment/quick_actions.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/event/view_events.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/location_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/appointment_details/widgets/result_options_dialog/index.dart';
import 'package:jobprogress/modules/cutomer_job_list/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';

class AppointmentDetailsController extends GetxController {

  AppointmentDetailsController({
    this.tempAppointmentId,
    this.onAppointmentUpdate,
    this.onAppointmentDelete,
  });

  final int? tempAppointmentId;

  final VoidCallback? onAppointmentDelete;

  final Function(AppointmentModel appointment)? onAppointmentUpdate;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  /// In case we don't want to load appointment from server [appointment] argument should be passed from previous screen
  AppointmentModel? appointment = Get.arguments?['appointment']; // appointment comes from previous page

  /// In case we want to load appointment from server [appointment_id] argument should be passed from previous screen
  int? appointmentId = Get.arguments?['appointment_id']; // appointment_id comes from previous page

  List<AppointmentResultOptionsModel> resultOptions = []; // used to store appointment result options

  List<dynamic> jobDetailsList = []; // used to store phones, duration appointment for etc.

  bool isLoading = true;
  bool? isAppointmentUpdated;

  @override
  void onInit() async{
    appointmentId ??= tempAppointmentId;
    await fetchAppointment();
    MixPanelService.trackEvent(event: MixPanelViewEvent.appointmentDetails);
    super.onInit();
  }

  void refreshPage() async{
    appointment = null;
    isLoading = true;
    update();
    await fetchAppointment();
  }

  Map<String, dynamic> getParams() {
    return {
      'id': appointmentId,
      'includes[0]': 'customer',
      'includes[1]': 'jobs',
      'includes[2]': 'attendees',
      'includes[3]': 'created_by',
      'includes[4]': 'reminders',
      'includes[5]': 'attachments',
      'includes[6]': 'result_option',
      'includes[7]': 'jobs.trades',
      'includes[8]': 'customer.address',
      'includes[9]': 'jobs.division',
    };
  }

Future<void> fetchAppointment() async {
  try {
    if (appointment == null) {
      Map<String, dynamic> requestParams = getParams();
      await AppointmentRepository().fetchAppointment(requestParams)
          .then((value) => appointment = value);
      // Fetch the customer meta data
        fetchCustomerMeta(appointment);  
       
    }
  } catch (e) {
    rethrow;
  } finally {
    isLoading = false;
    jobDetailsList = getDetailsList();
    update();
  }
}

int? get customerId{
  if(!Helper.isValueNullOrEmpty(appointment?.customerId)){
    return appointment?.customerId;
  }
  if(!Helper.isValueNullOrEmpty(appointment?.customer?.id)){
    return appointment?.customer?.id;
  }
  if(!Helper.isValueNullOrEmpty(appointment?.job)){
    if(appointment?.job?.first.customerId != null){
      return appointment?.job?.first.customerId;
    }
    if(appointment?.job?.first.customer?.id != null){
      return appointment?.job?.first.customer?.id;
    }
  }
  return null;
    
  }


  Map<String, dynamic> getRequestOptionParams() {
    return {
      if(appointment?.resultOptionIds == null)...{
        'active' : 1
      } else...{
        'ids[]' : appointment!.resultOptionIds!,
      },
      'limit' : 0,
    };
  }

    Future<void> fetchCustomerMeta(AppointmentModel? appointment) async { 
      if(customerId == null) return;
      Map<String, dynamic> queryParams = {
        "type[0]": "phone_consents",
        "customer_ids[]" : customerId
      };
    
      try {
        Map<String, dynamic> metaListApiResponse = await CustomerListingRepository().fetchMetaList(queryParams);
      List<CustomerModel> metaDataList = metaListApiResponse["list"];
      CustomerModel? firstMetaData = metaDataList.isNotEmpty ? metaDataList.first : null;
    
      if (firstMetaData != null) {
        for (int i = 0; i < firstMetaData.phoneConsents!.length; i++) {
          var phoneConsent = firstMetaData.phoneConsents![i];
          for (int j = 0; j < jobDetailsList.length; j++) {  
            if (jobDetailsList[j] is PhoneModel && phoneConsent.phoneNumber == jobDetailsList[j].number) {
              jobDetailsList[j]!.consentStatus = phoneConsent.status;
              jobDetailsList[j]!.consentCreatedAt = phoneConsent.createdAt;
              jobDetailsList[j]!.consentEmail = phoneConsent.email;
              jobDetailsList[j]!.showConsentStatus = true;
            }
          }
        }
      }
    
      update();
      } catch (e) {
      rethrow;
      }
    }

  // fetchResultOptions() : loads result options to add from
  Future<void> fetchResultOptions() async {
    try {
      showJPLoader();
      Map<String, dynamic> params = getRequestOptionParams();
      resultOptions = await AppointmentRepository().loadAppointmentResultOptions(params);

      // updating data for selected appointment results
      if(appointment?.resultOption != null) {
        int index = resultOptions.indexWhere((element) => element.id == appointment?.resultOption!.id);
        if(index != -1) {
          resultOptions[index].fields = appointment!.results;
        }
      }

    } catch (e) {
      rethrow;
    } finally {
      update();
      Get.back();
    }
  }

  // showAppointmentResultDialog() : displays appointment result dialog
  Future<void> showAppointmentResultDialog() async {

    await fetchResultOptions(); // loads result options

    if(resultOptions.isEmpty) return; // in case it's empty do return

    AppointmentModel? tempAppointment = await showJPGeneralDialog(
        child: (controller) {
          return AppointmentResultOptionsDialog(
            resultOptions: resultOptions,
            appointment: appointment!,
          );
        },
    );

    // updating appointment if any changes being saved for appointment results
    if(tempAppointment != null) {
      appointment = tempAppointment;
      isAppointmentUpdated = true;
      update();
    }
  }

  Map<String, dynamic> getMarkAsCompletedParams() {
    return {
      'id' : appointment!.id,
      'impact_type' : 'only_this',
      'is_completed' : appointment!.isCompleted ?? false ? 0 : 1
    };
  }

  // markAsCompleted() : marks/un-marks appointment as completed
  Future<void> markAsCompleted({required VoidCallback toggleIsLoading}) async {
    try {
      Map<String, dynamic> params = getMarkAsCompletedParams();

      final response = await AppointmentRepository().markAsCompleted(params);

      appointment!.isCompleted = response.isCompleted;
      appointment!.id = response.id;
      appointment!.isRecurring = response.isRecurring;

      if(appointment!.isCompleted ?? false) {
        Helper.showToastMessage('appointment_marked_as_completed'.tr);
      } else {
        Helper.showToastMessage('appointment_marked_as_uncompleted'.tr);
      }
      isAppointmentUpdated = true;
      Get.back();
    } catch (e) {
      rethrow;
    } finally {
      toggleIsLoading();
      update();
    }
  }

  // typeToHeaderAction() : used to handle pop-up menu actions
  void typeToHeaderAction(String val) {
    switch(val) {
      case 'duplicate':
        handleAppointmentQuickActionUpdate(appointment!,'duplicate');
      break;
      case 'delete':
        // in case of recurring displays available options, otherwise simply displays dialog
        if(appointment!.isRecurring) {
          AppointmentService.openQuickActions(
              appointment!,
              handleAppointmentQuickActionUpdate,
              showRecurringDeleteActions: true
          );
        } else {
          AppointmentService.showDeleteBottomSheet(
              appointment!,
              'delete',
              handleAppointmentQuickActionUpdate
          );
        }
        break;
      case 'edit':
        handleAppointmentQuickActionUpdate(appointment!,'edit');
        break;
      default:
        break;
    }
  }

  Future<void> handleAppointmentQuickActionUpdate(AppointmentModel appointment, String action) async {
    switch (action) {
      case 'delete':
        await Future<dynamic>.delayed(const Duration(milliseconds: 200));
        Get.back(result: {'action' : action});
        if(onAppointmentDelete != null) onAppointmentDelete!();
        break;
      case 'edit':
         navigateToUpdateAppointment(appointment: appointment);
         break;
      case 'duplicate':
        navigateToCreateAppointment(appointment);
        break;
      default:
    }
  }

  Future<void> navigateToUpdateAppointment({AppointmentModel? appointment}) async {
    final result = await Get.toNamed(Routes.createAppointmentForm, arguments: {
      NavigationParams.appointment: appointment,
      NavigationParams.pageType: appointment == null ? AppointmentFormType.createForm : AppointmentFormType.editForm,
    }, preventDuplicates: false);
    if(result != null && result["status"]) {
      Get.back(result: result);
      if(onAppointmentUpdate != null) onAppointmentUpdate!(appointment!);
    }
  }

  Future<void> navigateToCreateAppointment(AppointmentModel appointment) async{
    final result = await Get.toNamed(Routes.createAppointmentForm, arguments: {
      NavigationParams.appointment: appointment,
      NavigationParams.pageType: AppointmentFormType.duplicateForm,
    }, preventDuplicates: false); 
    if(result != null && result["status"]) {
      Get.back(result: result);
    } else{
      Get.back();
    }
  }

  List<dynamic> getDetailsList() {

    if(appointment == null) return [];

    List<dynamic> list = [];

    list.addAll(appointment!.customer?.phones ?? []);

    if(appointment!.invites != null && appointment!.invites!.isNotEmpty) {
      list.add(appointment!.invites ?? []);
    }

    if(appointment!.user != null) {
      list.add(appointment!.user ?? []);
    }

    return list;
  }

  void showConfirmationDialog() {

    showJPBottomSheet(
        child: (controller) => JPConfirmationDialog(
            title: "confirmation".tr,
            subTitle: appointment!.isCompleted ?? false
                ? 'you_are_about_to_mark_this_appointment_as_incomplete'.tr
                : 'you_are_about_to_mark_this_appointment_as_complete'.tr,
          suffixBtnText: controller.isLoading ? '' : 'confirm'.tr.toUpperCase(),
          suffixBtnIcon: showJPConfirmationLoader(
           show: controller.isLoading
          ),
          icon: Icons.warning_amber_rounded,
          disableButtons: controller.isLoading,
          onTapSuffix: () async {
              controller.toggleIsLoading();
              await markAsCompleted(toggleIsLoading: controller.toggleIsLoading);
          },
        ),
    );
  }

  void showJobsSheet() {
    showJPBottomSheet(
        child: (_) {
          return CustomerJobListing(
            customerId: appointment?.customer?.id ?? appointment?.job?.first.customer!.id,
            jobs: appointment!.job!,
            closeSheetWhileNavigation: true,
          );
        },
      isScrollControlled: true
    );
  }

  Future<bool> onWillPop() async {
    if(appointment != null) {
      Get.back(result: {'appointment': appointment!});
      if(onAppointmentUpdate != null && (tempAppointmentId != appointment?.id
          || (isAppointmentUpdated ?? false))) {
        onAppointmentUpdate!(appointment!);
      }
    } else {
      Get.back();
    }
    return false;
  }

      ////////////////////////////    LAUNCH MAP    ////////////////////////////////

  void launchMapCallback() {
        LocationHelper.openMapBottomSheet(query: appointment!.location);
  }
}