import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/email/profile_detail.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/phone_consents.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/repositories/customer_listing.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/schedule.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/mix_panel/event/view_events.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/location_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/schedule/details/widgets/confirmation_status_sheet.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialogWithSwitch/index.dart';
import '../../../common/enums/event_form_type.dart';
import '../../../core/constants/navigation_parms_constants.dart';
import '../../../routes/pages.dart';

class ScheduleDetailController extends GetxController {

  ScheduleDetailController({this.scheduleId, this.onScheduleDelete}) {
    scaffoldKey = GlobalKey<ScaffoldState>();
  }

  final String? scheduleId;

  final VoidCallback? onScheduleDelete;

  int? jobId = Get.arguments?[NavigationParams.jobId];

  late GlobalKey<ScaffoldState> scaffoldKey;
  SchedulesModel? schedulesDetails;
  JobModel? jobModel;
  String id = '';
  bool isDeleting = false;
  bool scheduleLoading = false;
  bool showNotification = false;
  bool updateJobCompletionDate = false;

  int declined = 0;
  int confirmed = 0;
  int pending = 0;

  bool canShowScheduleConfirmationStatus = false;

  @override
  void onInit() {
    id = scheduleId ?? ((Get.arguments != null) ? Get.arguments['id'].toString() : '');
    dynamic setting = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.showScheduleConfirmationStatus);
    canShowScheduleConfirmationStatus = Helper.isTrue(setting);
    getScheduleDetails();
    MixPanelService.trackEvent(event: MixPanelViewEvent.scheduleDetails);
    super.onInit();
  }

  void refreshPage() async {
    schedulesDetails = null;
    scheduleLoading = true;
    update();
    getScheduleDetails();
  }

  Map<String, dynamic> scheduleDetailParams() {
    return <String, dynamic>{
      'id': id,
      'includes[0]': 'trades',
      'includes[1]': ' work_types',
      'includes[2]': 'reps',
      'includes[3]': 'sub_contractors',
      'includes[4]': 'work_crew_notes',
      'includes[5]': 'work_orders',
      'includes[6]': 'material_lists',
      'includes[7]': 'reminders',
      'includes[8]': 'created_by',
      'includes[9]': 'attachments',
      'includes[10]': 'customer.phones'
    };
  }

  Future<void> getScheduleDetails() async {
    try {
      if(jobId != null) {
        Map<String, dynamic> params = {
          'includes[0]': 'created_by',
          'includes[1]': 'modified_by',
          'includes[2]': 'trades',
          'includes[3]': 'work_types',
          'includes[4]': 'reps',
          'includes[5]': 'sub_contractors',
          'includes[6]': 'notes',
          'job_id': jobId
        };
        schedulesDetails = await ScheduleRepository.fetchScheduleDetailsByJobId(params, jobId!);
      } else if(id != '') {
        schedulesDetails = await ScheduleRepository.fetchScheduleDetails(scheduleDetailParams(), id);
      }

      
      if (schedulesDetails?.job != null) {
        Map<String, dynamic> params = {
          'includes[0]': ['address'],
          'includes[1]': ['reps'],
          'includes[2]': ['sub_contractors'],
          'includes[3]': ['division'],
          'includes[4]': ['notes'],
          'includes[5]': ['flags.color']
        };
        jobModel = (await JobRepository.fetchJob(schedulesDetails!.job!.id, params: params))['job'];
      }
      await fetchCustomerMeta();
      setUserStatusCount();
    } catch (e) {
      rethrow;
    } finally {
      update();
    }
  }

  Future<void> reFetchSchedule() async {
    try {
      showJPLoader();
      await getScheduleDetails();
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  Future<void> fetchCustomerMeta() async {
    final queryParams = {
      "type[0]": "phone_consents",
      "customer_ids[]": schedulesDetails?.customerId,
    };
  
    try {
      final metaListApiResponse = await CustomerListingRepository().fetchMetaList(queryParams);
      final metaDataList = metaListApiResponse["list"] as List<CustomerModel>;
      final firstMetaData = metaDataList.isNotEmpty ? metaDataList.first : null;
  
      if (firstMetaData != null && schedulesDetails != null) {
        for (PhoneConsentModel phoneConsent in firstMetaData.phoneConsents ?? []) {
          for (PhoneModel phone in schedulesDetails!.customer!.phones ?? []) {
            if (phoneConsent.phoneNumber == phone.number) {
              phone.consentStatus = phoneConsent.status;
              phone.consentCreatedAt = phoneConsent.createdAt;
              phone.consentEmail = phoneConsent.email;
            }
          }
        }
      }
  
      update();
    } catch (e) {
      rethrow;
    }
  }

  void setUserStatusCount() {
    pending = 0;
    declined = 0;
    confirmed = 0;
    showNotification = false;

    if (schedulesDetails?.workCrew?.isNotEmpty ?? false) {
      int len = schedulesDetails!.workCrew!.length;
      for (int i = 0; i < len; i++) {
        if (schedulesDetails!.workCrew![i].status == 'pending') {
          pending++;
        }

        if (schedulesDetails!.workCrew![i].status == 'decline') {
          declined++;
        }

        if (schedulesDetails!.workCrew![i].status == 'accept') {
          confirmed++;
        }
      }

      int loggedInUserId = AuthService.userDetails!.id;

      UserLimitedModel? user = schedulesDetails!.workCrew!.firstWhereOrNull((element) => element.id == loggedInUserId);

      if(user?.status == 'pending') {
        showNotification = true;
      }
    }

  }

  Map<String, dynamic> actionParam(String type) {
    return <String, dynamic>{
      "only_this": (type == 'deleteJobSchedule') ? 0 : 1,
    };
  }

  Future<void> deleteJobSchedule() async {
    isDeleting = true;
    update();
    try {
      await JobRepository.deleteJobSchedule(actionParam('deleteJobSchedule'), schedulesDetails!.id.toString());
      Get.back();
    } catch (e) {
      rethrow;
    } finally {
      isDeleting = false;
      update();
      Get.back(
          result: {'action' : 'delete'}
      );
      if(onScheduleDelete != null) {
        onScheduleDelete!();
      }
    }
  }

  void openEmail() {
    String scheduleId = Helper.isValueNullOrEmpty(id) ? schedulesDetails!.id!.toString() : id;
    
    List<EmailProfileDetail> toList = [];
    
    for(UserLimitedModel users  in schedulesDetails!.workCrew!) {
      toList.add(EmailProfileDetail(name: users.email, email: users.email));
    }
   
    Helper.navigateToComposeScreen(
      arguments: {
        'job_schedule_id': scheduleId,
        'to_list': toList, 
        'jobId':jobModel?.id,
        'action':'job_detail'
      }
    );
  }

  Future<void> markAction(String key) async {
    showJPLoader();
    try {
      await JobRepository.markAction(actionParam('markAction'), id, key).whenComplete(() => getScheduleDetails());
    } catch (e) {
      rethrow;
    } finally {
      update();
      Get.back();
    }
  }

  Map<String, dynamic> markCompleteParam(String key) {
    int isComplete = 0;
    if (key == 'accept') {
      isComplete = 1;
    }
    return <String, dynamic>{
      'is_completed': isComplete,
      'update_job_completion_date': updateJobCompletionDate? 1 : 0,
      'includes[0]': 'reps',
      'includes[1]': 'labours',
      'includes[2]': 'sub_contractors',
      'includes[3]': 'trades',
      'includes[4]': 'work_types'
    };
  }

  Future<void> markComplete(String key) async {
    scheduleLoading = true;
    update();
    try {
      await JobRepository.markCompleteJobSchedule(markCompleteParam(key), id).whenComplete(() => getScheduleDetails());
    } catch (e) {
      rethrow;
    } finally {
      scheduleLoading = false;
      update();
      Get.back();
    }
  }

    String getConfirmationMessage() {
      String message;
      if(schedulesDetails!.type == 'schedule') {
        message = schedulesDetails!.iscompleted
        ? 'mark_schedule_as_uncomplete_message'.tr
        : 'mark_schedule_as_completed_message'.tr;
      } else {
      message = schedulesDetails!.iscompleted
        ? 'mark_event_as_uncomplete_message'.tr
        : 'mark_event_as_completed_message'.tr;
      }
    
      return message;
    }

     String getToggleMessage() {
      if(schedulesDetails!.iscompleted) {
        if(schedulesDetails?.job?.isProject ?? false) {
          return 'reset_project_completion_date'.tr;
        } 
          return 'reset_job_completion_date'.tr;
      } 
      if(schedulesDetails?.job?.isProject ?? false) {
          return 'update_project_completion_date'.tr;
        } 
      return 'update_job_completion_date'.tr;
    }

  void handleComplete() {
    if(schedulesDetails!.type == 'schedule'){
      handleCompleteSchedule();
    } else {
      handleCompleteEvent();
    }
  }

    Future<void> handleCompleteSchedule() async {
    showJPBottomSheet(child: (controller) {
      if(schedulesDetails!.iscompleted){
        controller.switchValue = true;
      } else {
        controller.switchValue = false;
      }
      
      return JPConfirmationDialogWithSwitch(
        title: 'confirmation'.tr.toUpperCase(),
        subTitle: getConfirmationMessage(),
        toggleTitle: getToggleMessage(),
        toggleValue: controller.switchValue,
        suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
        disableButtons: controller.isLoading,
        suffixBtnText: controller.isLoading ? '' : 'yes'.tr.toUpperCase(),
        onSuffixTap: (val) async {
          controller.toggleIsLoading();
          if (val) {
            updateJobCompletionDate = val; 
          }
           if (!schedulesDetails!.iscompleted) {
              markComplete('accept');
            } else {
              markComplete('decline');
            }
        },
      );
    });
  }
  
  void handleCompleteEvent() async {

    showJPBottomSheet(child: (_) => GetBuilder<ScheduleDetailController>(
        init: this,
        builder: (context) {
      return JPConfirmationDialog(
        icon: Icons.report_problem_outlined,
        title: "confirmation".tr,
        subTitle: getConfirmationMessage(),
        suffixBtnText: 'YES',
        prefixBtnText: 'NO',
        disableButtons: scheduleLoading,
        suffixBtnIcon: showJPConfirmationLoader(show: scheduleLoading),
        onTapPrefix: () {
          Get.back();
        },
        onTapSuffix: () {
          if (!schedulesDetails!.iscompleted) {
            markComplete('accept');
          } else {
            markComplete('decline');
          }
        },
      );
    }), isDismissible: false, enableDrag: false, isScrollControlled: true);
  }

  void handleHeaderActions(String action) async {

    switch (action) {
      case 'edit':
        await reFetchSchedule();
        dynamic data = await Get.toNamed(Routes.createEventForm, preventDuplicates: false, arguments: {
          NavigationParams.pageType: jobModel != null && schedulesDetails!.id != null
              ? EventFormType.editScheduleForm : EventFormType.editForm,
          NavigationParams.jobModel: jobModel,
          NavigationParams.schedulesModel: schedulesDetails,
        });

        if(data != null) {
          Get.back(
              result: {'action' : 'update'}
          );
          if(onScheduleDelete != null) {
            onScheduleDelete!();
          }
        }

        break;
      case 'deletes':
        showJPBottomSheet(child: (controller) => JPConfirmationDialog(
          icon: Icons.report_problem_outlined,
          title: "confirmation".tr,
          subTitle: schedulesDetails!.type == 'schedule' ? "delete_job_schedule_message".tr : 'delete_event_message'.tr,
          suffixBtnText: 'delete'.tr,
          disableButtons: controller.isLoading,
          suffixBtnIcon: controller.isLoading
              ? showJPConfirmationLoader(
              show: controller.isLoading
          ) : null,
          onTapPrefix: () {
            Get.back();
          },
          onTapSuffix: () async {
            controller.toggleIsLoading();
            await deleteJobSchedule().catchError((e) => controller.toggleIsLoading());
            controller.toggleIsLoading();
          },
        ));
        break;
      case 'duplicate':
        await reFetchSchedule();
        navigateToAddScheduleEvents();
        break;
    }
    update();
  }

  void handleStatusActions(String action) async {
    switch (action) {
      case 'confirm':
        await markAction('mark_as_accept');
        update();
        break;
      case 'decline':
        await markAction('mark_as_decline');
        update();
        break;
      case 'pending':
        await markAction('mark_as_pending');
        update();
        break;
    }
    update();
  }

  void conformationStatus() async {
    showJPBottomSheet(isScrollControlled: true, child: (_) {
      return GetBuilder(
        global: false,
        init: this,
        builder: (context) {
          return ScheduleConfirmationStatusBottomSheet(
                controller: this,
              );
        }
      );
    },
    );
  }

      ////////////////////////////    LAUNCH MAP    ////////////////////////////////

  void launchMapCallback(String? location) {
        LocationHelper.openMapBottomSheet(query: location);
  }

  Future<void> navigateToAddScheduleEvents() async {
    dynamic data = await Get.toNamed(
        Routes.createEventForm,
        preventDuplicates: false, arguments: {
      NavigationParams.pageType: jobModel != null
          && schedulesDetails!.id != null ?
      EventFormType.createScheduleForm :
      EventFormType.createForm,
      NavigationParams.jobModel: jobModel,
      NavigationParams.schedulesModel: schedulesDetails,
    });

    if(data != null) {
      Get.back(
          result: {'action' : 'update'}
      );
      if(onScheduleDelete != null) {
        onScheduleDelete!();
      }
    }
  }

  Future<bool> onWillPop() async {
    Get.back(result: schedulesDetails);
    return true;
  }

}

