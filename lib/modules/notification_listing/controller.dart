import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/common/enums/note_listing.dart';
import 'package:jobprogress/common/enums/notification.dart';
import 'package:jobprogress/common/enums/task_form_type.dart';
import 'package:jobprogress/common/models/notification/notification.dart';
import 'package:jobprogress/common/models/notification/notification_group.dart';
import 'package:jobprogress/common/models/notification/notification_params.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/providers/firebase/realtime_db.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/common/repositories/notification.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/note_actions/quick_actions.dart';
import 'package:jobprogress/common/services/task/quick_actions.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/files_listing/page.dart';
import 'package:jobprogress/modules/notification_listing/widgets/announcement_detail.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../core/constants/navigation_parms_constants.dart';

class NotificationListingController extends GetxController {
  bool isLoading = true;
  bool isLoadMore = false;
  bool canShowLoadMore = false;
  bool isDataNotSynced = false;
  bool changesMadeByCurrentUser = false; // helps in checking whether current user made changes or not

  int totalNotificationLength = 0;
  int loadedNotificationLength = 0;
  int previousNotificationCount = 0;
  List<GroupNotificationListingModel> notificationGroup = [];

  List<JPSingleSelectModel> filterByList = [
    JPSingleSelectModel(id: 'all', label: "all".tr),
    JPSingleSelectModel(id: 'unread_only', label: "unread_only".tr),
    JPSingleSelectModel(id: 'read_only', label: "read_only".tr)
  ];

  String selectedFilterByOptions = 'all';

  final List<RealTimeKeyType> realTimeKeys = [RealTimeKeyType.notificationUnread];

  final firebaseStream = RealtimeDBProvider.streamsMap[RealTimeKeyType.notificationUnread];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  NotificationListingParamModel paramkeys = NotificationListingParamModel();

  StreamSubscription<String>? countsSubscription;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    // creating a local stream to listen changes so, global stream
    // should not be affected
    countsSubscription = RealtimeDBProvider.listenToLocalStream(
        realTimeKeys.first,
        onData: toggleIsDataNotSynced
    );
  }

  //Fetching task listing from api
  Future<void> fetchNotifications() async {
    try {
      final notificationParams = <String, dynamic>{
        'includes[0]': ['job'],
        'includes[1]': ['jobs'],
        "includes[2]": ['customer'],
        "includes[3]": ['sender'],
        "includes[4]": ['recipients'],
        ...paramkeys.toJson()
      };

      Map<String, dynamic> response = await NotificationListingRepository()
        .fetchNotificationList(notificationParams);
      
      setNotificationList(response);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadMore = false;
      update();
    }
  }

  Future<void> markAllAsRead() async {
    showJPBottomSheet(child: ((controller) {
      return JPConfirmationDialog(
        title: "confirmation".tr,
        subTitle: "you_are_about_to_mark_all_notifications_as_read".tr,
        suffixBtnText: 'confirm'.tr,
        icon: Icons.report_problem_outlined,
        disableButtons: controller.isLoading,
        suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
        onTapPrefix: () {
          Get.back();
        },
        onTapSuffix: () async {
          changesMadeByCurrentUser = true;
          controller.toggleIsLoading();
          await NotificationListingRepository().markAllAsRead();
          controller.toggleIsLoading();

          Get.back();
          
          Helper.showToastMessage("notifications_are_marked_as_read".tr);
          for (GroupNotificationListingModel notificationlist in notificationGroup) {
            for (var notification in notificationlist.groupValues) {
              notification.isRead = true;
            }
          }

          update();
        },
      );
    }));
  }

  Future<void> jobPriceStatusUpdate(NotificationListingModel notification, int status) async {
    
    final params = <String, dynamic>{
      'id': notification.jobPrice!.id,
      'approve': status
    };
    
    await JobFinancialRepository().jobPriceApproveRejectRequest(params, params['id']);

    if(status == 1) {
      notification.jobPrice!.approvedBy = AuthService.userDetails!.id;
      Helper.showToastMessage("job_price_update_request_approved".tr);
    } else {
      notification.jobPrice!.rejectedBy = AuthService.userDetails!.id;
      Helper.showToastMessage("job_price_update_request_rejected".tr);
    }

    update();
  }

  void openFilters() {
    SingleSelectHelper.openSingleSelect(
      filterByList,
      selectedFilterByOptions,
      'filter_by'.tr,
      updateFilter,
      isFilterSheet: true
    );
  }

  Future<void> updateFilter(String value) async {
    /// set default false & for all case
    paramkeys.readOnly = false;
    paramkeys.unreadOnly = false;
    paramkeys.page = 1;

    if (value == 'read_only') paramkeys.readOnly = true;
    if (value == 'unread_only') paramkeys.unreadOnly = true;

    selectedFilterByOptions = value;
    isLoading = true;

    update();
    Get.back();
    
    await fetchNotifications();
  }
  
  void handleNotificationClick(NotificationListingModel notification) {
    if(!notification.isRead) {
      markNotificationRead(notification);
    }

    switch (notification.notificationType) {
      case NotificationType.job:
        Get.toNamed(
          Routes.jobSummary,
          arguments: {
            NavigationParams.jobId: notification.job!.id,
            NavigationParams.customerId: notification.job!.customerId
          },
          preventDuplicates: false
        );
        break;
      case NotificationType.customer:
        Get.toNamed(Routes.customerDetailing, arguments: {NavigationParams.customerId: notification.customer!.id});
        break;
      case NotificationType.task:
        if(notification.task != null) {
          TaskService.openTaskdetail(
            id: notification.task?.id,
            callback: handleTaskQuickActionUpdate,
          );
        } else {
          Helper.showToastMessage("no_task_found".tr);
        }
        break;
      case NotificationType.workCrewNote:
        NoteService.openNoteDetail(
          id: notification.noteDetail!.id,
          type: NoteListingType.workCrewNote
        );
        break;
      case NotificationType.jobFollowUp:
        NoteService.openNoteDetail(
          id: notification.noteDetail!.id,
          type: NoteListingType.followUpNote
        );
        break;
      case NotificationType.jobNote:
        NoteService.openNoteDetail(
          id: notification.noteDetail!.id,
          type: NoteListingType.jobNote
        );
        break;
      case NotificationType.announcement:
        showJPGeneralDialog(child: (dController) {
          return AnnouncementDetail(
            title: notification.announcement?.title ?? "",
            description: notification.announcement?.description ?? ""
          );
        });
        
        break;
      case NotificationType.jobPriceRequest:
      case NotificationType.leapPay:
        Get.toNamed(Routes.jobfinancial, arguments: 
        {
          'jobId' : notification.body!.jobId,
          'customerId' : notification.body!.customerId,
        });
        break;
      case NotificationType.appointment:
        Get.toNamed(
          Routes.appointmentDetails,
          arguments: {'appointment_id': notification.body!.appointmentId},
        );
        break;
      case NotificationType.jobSchedule:
        if(notification.body!.type == 'job_schedule') {
          Get.toNamed(
            Routes.scheduleDetail,
            arguments: {'id': notification.body?.scheduleId}
          );
        } else {
          Get.toNamed(
            Routes.jobSummary,
            arguments: {
              NavigationParams.jobId: notification.body?.jobId,
              NavigationParams.customerId: notification.body?.customerId
            },
            preventDuplicates: false
          );
        }
        break;
      case NotificationType.message:
        Get.toNamed(Routes.messages, arguments: {
          'group_id' : notification.body?.threadId,
          'type' : Helper.getMessageType(notification.body?.type)
        });
        break;
      case NotificationType.worksheet:
        // TODO: Need to redirect to worksheet listing or edit worksheet for QBD notification
        break;
      case NotificationType.documentExpired:
        Get.toNamed(
          Routes.documentExpired , 
          arguments: {
            'id': notification.body?.objectId,
            'type': notification.body?.objectType,
            'job_id': notification.body?.jobId,
          }
        );
        break;
        
      case NotificationType.materialList:
        Get.to(() =>
          FilesListingView(
            refTag: "${FLModule.workOrder}${(notification.body?.jobId)}",
          ),
          arguments: {
            'type':FLModule.workOrder,
            'customerId': notification.body?.customerId,
            'jobId': notification.body?.jobId
          },
          preventDuplicates: false
       );
      break;

      case NotificationType.notification:
      break;

      default:
        break;
    }
  }

  void handleTaskQuickActionUpdate(TaskListModel task, String action) {
    Get.back();
    if(action == 'edit') {
      navigateToCreateTask(task : task);
    }
  }

  Future<void> navigateToCreateTask({TaskListModel? task}) async{
    await Get.toNamed(Routes.createTaskForm, arguments: {
      NavigationParams.task: task,
      NavigationParams.pageType: task == null ? TaskFormType.createForm : TaskFormType.editForm,
    });
  }

  Future<void> markNotificationRead(NotificationListingModel notification) async {
    isLoadMore = true;
    changesMadeByCurrentUser = true;
    await NotificationListingRepository().markAsRead(notification.id);
    notification.isRead = true;
    update();
  }

  void setNotificationList(Map<String, dynamic> response) {

    List<NotificationListingModel> list = response['list'];
    PaginationModel pagination = response['pagination'];

    totalNotificationLength = pagination.total!;

    if (!isLoadMore) {
      notificationGroup = [];
      loadedNotificationLength = 0;
    }

    loadedNotificationLength += list.length;

    Helper.groupBy(list, (NotificationListingModel notification) {
      return DateTimeHelper.getLabelAccordingToDate(notification.createdAt.toString());
    }).forEach((key, value) {

      if(notificationGroup.any((GroupNotificationListingModel element) => element.groupName == key)) {
        notificationGroup.last.groupValues.addAll(value);
      } else {
        notificationGroup.add(
            GroupNotificationListingModel(groupName: key, groupValues: value));
      }
    });

    canShowLoadMore = loadedNotificationLength < totalNotificationLength;
  }

  Future<void> refreshList({bool? showLoading}) async {
    paramkeys.page = 1;
    isLoading = showLoading ?? false;
    isDataNotSynced = false;
    changesMadeByCurrentUser = false;
    update();
    await fetchNotifications();
  }

  Future<void> loadMore() async {
    paramkeys.page += 1;
    isLoadMore = true;
    await fetchNotifications();
  }

  /// [toggleIsDataNotSynced] used to toggle [isDataNotSynced] on the basis of
  /// whether changes made by current user or not
  void toggleIsDataNotSynced() {
    isDataNotSynced = !changesMadeByCurrentUser;
    changesMadeByCurrentUser = false;
    update();
  }

  /// [removeCountsListener] removes the local listener
  Future<void> removeCountsListener() async {
    await countsSubscription?.cancel();
    countsSubscription = null;
  }

  @override
  void dispose() async {
    await removeCountsListener();
    super.dispose();
  }
}
