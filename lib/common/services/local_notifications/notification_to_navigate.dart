import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/job_financial_listing.dart';
import 'package:jobprogress/common/models/push_notifications/notification_data.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/modules/files_listing/page.dart';
import 'package:jobprogress/routes/pages.dart';
import '../../../core/utils/helpers.dart';

class NotificationToNavigate {

  void viewJobTasks(PushNotificationDataModel data, {bool completedTasks = false }) {
    int? taskId = data.id == -1 ? data.taskId : data.id;
    if (Get.currentRoute == Routes.taskListing) {
      Get.back();
      if(Get.currentRoute == Routes.taskListing) {
        Get.back();
      }
    }
    Get.toNamed(Routes.taskListing, arguments: {
      NavigationParams.taskId :  taskId,
      NavigationParams.customerId : data.customerId,
      if(completedTasks)
        NavigationParams.taskFilter: 'my_completed_tasks',
    });
  }

  void viewJobSummary(PushNotificationDataModel data, {bool autoNavigateToJobDetails = false}) async {
    if (Get.currentRoute == Routes.jobSummary) {
      Get.back();
    }

    await Get.toNamed(Routes.jobSummary, arguments: {
      NavigationParams.jobId : data.jobId,
      NavigationParams.customerId : data.customerId,
      NavigationParams.autoNavigateToJobDetails: autoNavigateToJobDetails
    });
  }

  void viewMentionedNote(PushNotificationDataModel data, {required String route}) async {

    if(Get.currentRoute == route) {
      Get.back();
    }

    await Get.toNamed(route, arguments: {
      'jobId' : data.jobId,
      'customerId' : data.customerId,
      NavigationParams.followUpNoteId: data.jobFollowUpId,
      NavigationParams.jobNoteId: data.jobNoteId,
      NavigationParams.workCrewNoteId: data.workCrewId,
    });
  }

  void viewAppointmentDetails({required int appointmentId}) {
    if(Get.currentRoute == Routes.appointmentDetails) {
      Get.back();
    }

    Get.toNamed(Routes.appointmentDetails, arguments: {
      'appointment_id' : appointmentId
    });
  }

  void viewCustomerInfo(PushNotificationDataModel data) async {

    if(Get.currentRoute == Routes.customerDetailing) {
      Get.back();
    }

    await Get.toNamed(Routes.customerDetailing, arguments: {
      NavigationParams.customerId : data.customerId,
    });
  }

  void viewEmailListing() {

    if(Get.currentRoute == Routes.email || Get.currentRoute == '/EmailListingView') {
      Get.back();
    }

    Get.toNamed(Routes.email, preventDuplicates: false);
  }

  void viewNotificationListing() {

    if(Get.currentRoute == Routes.notificationListing) {
      Get.back();
    }

    Get.toNamed(Routes.notificationListing, preventDuplicates: false);
  }

  void viewJobFinancials(PushNotificationDataModel data) {

    if(Get.currentRoute == Routes.jobfinancial) {
      Get.back();
    }

    Get.toNamed(Routes.jobfinancial, arguments: {
      'jobId' : data.jobId,
      'customerId' : data.customerId,
    });
  }
  
  void viewNewMessage(PushNotificationDataModel data) {

    if(Get.currentRoute == Routes.messages) {
      Get.back();
    }

    Get.toNamed(Routes.messages, arguments: {
      'group_id' : data.threadId,
      'type': Helper.getMessageType(data.type)
    });
  }

  void viewScheduleDetails(PushNotificationDataModel data) {

    if(Get.currentRoute == Routes.scheduleDetail) {
      Get.back();
    }

    Get.toNamed(Routes.scheduleDetail, arguments: {
      'id' : data.scheduleId,
    });
  }

  void viewDailyPlans() {

    if(Get.currentRoute == Routes.dailyPlan) {
      Get.back();
    }

    Get.toNamed(Routes.dailyPlan, preventDuplicates: false);
  }

  void handleWorkSheetNotification(PushNotificationDataModel data) async {

    if(data.subType == 'qbd_sync_failed') {

      if(data.action == 'listing') {

        final moduleType = typeToModule(data.worksheetType!);

        if(moduleType == null) return;

        if(Get.currentRoute == '/FilesListingView') {
          Get.off(() =>
              FilesListingView(
                refTag: "$moduleType${(data.jobId!)}",
              ),
              arguments: {
                'type': moduleType,
                'customerId': data.customerId,
                'jobId': data.jobId
              },
              preventDuplicates: false
          );
        } else {
          Get.to(() =>
              FilesListingView(
                refTag: "$moduleType${(data.jobId!)}",
              ),
              arguments: {
                'type': moduleType,
                'customerId': data.customerId,
                'jobId': data.jobId
              },
              preventDuplicates: false
          );
        }
      }
      // TODO: data.action == 'edit' pending to be handled - related to QBD
    }
  }

  void navigateToWorkOrder(PushNotificationDataModel data){
    if(Get.currentRoute == '/FilesListingView') {
      Get.off(() =>
          FilesListingView(
            refTag: "${FLModule.workOrder}${(data.jobId!)}",
          ),
          arguments: {
            'type':FLModule.workOrder,
            'customerId': data.customerId,
            'jobId': data.jobId
          },
          preventDuplicates: false
      );
    } else {
      Get.to(() =>
          FilesListingView(
            refTag: "${FLModule.workOrder}${(data.jobId!)}",
          ),
          arguments: {
            'type':FLModule.workOrder,
            'customerId': data.customerId,
            'jobId': data.jobId
          },
          preventDuplicates: false
      );
    } 
  }

  void navigateToDocumentExpiredScreen(PushNotificationDataModel data){
    Get.toNamed(
      Routes.documentExpired , 
      arguments: {
        'id': data.objectId,
        'type': data.objectType,
        'job_id': data.jobId,
      }
    ); 
  }

  FLModule? typeToModule(String type) {
    switch (type) {
      case 'estimate':
        return FLModule.estimate;

      case 'proposal':
        return FLModule.jobProposal;

      case 'material_list':
        return FLModule.materialLists;

      case 'work_order':
        return FLModule.workOrder;

      default:
        return null;
    }
  }

  void navigateToPaymentDetails(PushNotificationDataModel data) {
    if(Get.currentRoute == Routes.jobfinancialListingModule) {
      Get.back();
    }

    Get.toNamed(Routes.jobfinancialListingModule,
      arguments: {
        'listing': JFListingType.paymentsReceived,
        'jobId': data.jobId,
        'customer_id': data.customerId,
      },
    );
  }
}