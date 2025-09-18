import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jobprogress/common/enums/app_state.dart';
import 'package:jobprogress/common/models/push_notifications/push_notification.dart';
import 'package:jobprogress/common/services/local_notifications/confirmations.dart';
import 'package:jobprogress/core/constants/push_notification.dart';
import 'package:jobprogress/routes/pages.dart';
import 'notification_to_navigate.dart';

class LocalNotificationHandler {

  static NotificationToNavigate navigation = NotificationToNavigate();

  static PushNotificationModel? pendingPayload;

  static Future<void> checkForPendingPayloadAndView() async {

    // retrieving notification data when app is terminated and notification tapped
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if(initialMessage != null) {
      // setting up payload
      pendingPayload = PushNotificationModel.fromJson(initialMessage.data);
    }

    if(pendingPayload != null) {
      typeToView(data: pendingPayload!);
      pendingPayload = null;
    }
  }

  static void typeToView({required PushNotificationModel data}) {

    if(data.eData == null) return;

    if(appState == JPAppState.loadingData) {
      pendingPayload = data;
      return;
    }

    if(LocalNotificationConfirmation.doShowCompanySwitchConfirmation(data.eData?.companyId)) {
      LocalNotificationConfirmation.showCompanySwitchConfirmationDialog(
        compId: data.eData!.companyId!,
        onConfirmation: () {
          pendingPayload = data;
        }
      );
      return;
    }

    if(LocalNotificationConfirmation.doShowScreenSwitchConfirmation()) {
      LocalNotificationConfirmation.showScreenSwitchConfirmationDialog(
          onConfirmation: () {
            typeToView(data: data);
          },
      );
      return;
    }

    String notificationType = data.type!.toString();

    switch (notificationType) {
      case PushNotificationConstants.taskCompleted:
        navigation.viewJobTasks(data.eData!, completedTasks: true);
        break;

      case PushNotificationConstants.newTask:
      case PushNotificationConstants.taskReminder:
        navigation.viewJobTasks(data.eData!);
        break;

      case PushNotificationConstants.jobAssigned:
        navigation.viewJobSummary(data.eData!, autoNavigateToJobDetails: true);
        break;

      case PushNotificationConstants.jobFollowUpNotes:
        navigation.viewMentionedNote(data.eData!, route: Routes.followUpsNoteListing);
        break;

      case PushNotificationConstants.jobNotes:
        navigation.viewMentionedNote(data.eData!, route: Routes.jobNoteListing);
        break;

      case PushNotificationConstants.workCrewNotes:
        navigation.viewMentionedNote(data.eData!, route: Routes.workCrewNotesListing);
        break;

      case PushNotificationConstants.newAppointment:
        navigation.viewAppointmentDetails(appointmentId: data.eData?.appointmentId ?? -1);
        break;

      case PushNotificationConstants.appointmentReminder:
        navigation.viewAppointmentDetails(appointmentId: data.eData?.id ?? -1);
        break;

      case PushNotificationConstants.jobStageChange:
      case PushNotificationConstants.proposalAccepted:
      case PushNotificationConstants.wordPressNewJobCreated:
        navigation.viewJobSummary(data.eData!);
        break;

      case PushNotificationConstants.customerAssigned:
        navigation.viewCustomerInfo(data.eData!);
        break;

      case PushNotificationConstants.newEmail:
        navigation.viewEmailListing();
        break;

      case PushNotificationConstants.announcement:
        navigation.viewNotificationListing();
        break;

      case PushNotificationConstants.jobPriceRequestSubmitted:
      case PushNotificationConstants.leapPaymentSuccessful:
      case PushNotificationConstants.leapPaymentFailed:
        navigation.viewJobFinancials(data.eData!);
        break;

      case PushNotificationConstants.newMessage:
        navigation.viewNewMessage(data.eData!);
        break;

      case PushNotificationConstants.scheduleReminder:
        navigation.viewScheduleDetails(data.eData!);
        break;

      case PushNotificationConstants.dailyPlan:
        navigation.viewDailyPlans();
        break;        

      case PushNotificationConstants.worksheet:
        navigation.handleWorkSheetNotification(data.eData!);
        break;
      
      case PushNotificationConstants.newWorkOrderAssigned:
      case PushNotificationConstants.workOrderCompleted:
      case PushNotificationConstants.workOrderOpen:
        navigation.navigateToWorkOrder(data.eData!);
        break;

      // TODO: Only Need to check functionality on app
      case PushNotificationConstants.documentExpired:
        navigation.navigateToDocumentExpiredScreen(data.eData!);
        break;
      
      /// TODO: 4. Worksheet QBD notification handling - TBH

      default:
        break;
    }
  }

}
