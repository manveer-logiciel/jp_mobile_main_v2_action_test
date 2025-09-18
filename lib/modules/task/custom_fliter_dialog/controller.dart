import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/task_listing/task_listing_filter.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class TaskListingDialogController extends GetxController {
  TaskListingDialogController(this.selectedFilters, this.jobId, this.onApply, this.userList);

  final TaskListingFilterModel selectedFilters;

  final int? jobId;

  final void Function(TaskListingFilterModel params) onApply;

  final List<UserModel>? userList;

  TaskListingFilterModel filterKeys = TaskListingFilterModel();

  UserModel? selectedUser;

  List<JPSingleSelectModel> statusFilters = [
    JPSingleSelectModel(label: "all".tr.capitalize!, id: "all"),
    JPSingleSelectModel(label: "pending".tr.capitalize!, id: "pending"),
    JPSingleSelectModel(label: "completed".tr.capitalize!, id: "completed")
  ];

  List<JPSingleSelectModel> dueOnFilters = [
    JPSingleSelectModel(label: "none".tr.capitalize!, id: "none"),
    JPSingleSelectModel(label: "today".tr.capitalize!, id: "today"),
    JPSingleSelectModel(label: "next_week".tr, id: "next_week"),
    JPSingleSelectModel(label: "upcoming".tr.capitalize!, id: "upcoming"),
    JPSingleSelectModel(label: "last_month".tr, id: "last_month")
  ];

  void setDefaultKeys(TaskListingFilterModel params) {
    filterKeys.includeLockedTask = params.includeLockedTask;
    filterKeys.onlyHighPriorityTask = params.onlyHighPriorityTask;
    filterKeys.reminderNotification = params.reminderNotification;
    filterKeys.duration = params.duration == 'past' ? 'none' : (params.duration ?? 'none');
    filterKeys.status = params.status;
    filterKeys.jobId = params.jobId;
    filterKeys.userId = params.userId;
      if(filterKeys.userId != null) {
      selectedUser = userList!.firstWhere((user) => user.id.toString() == filterKeys.userId.toString());
    } else{
      selectedUser = null;
    }
    update();
  }

  void openStatusFilter() {
    SingleSelectHelper.openSingleSelect(
        statusFilters, filterKeys.status, "select_status".tr, (value) {
      filterKeys.status = value;
      update();
      Get.back();
    });
  }

  void openDueOnFilter() {
    SingleSelectHelper.openSingleSelect(
        dueOnFilters, filterKeys.duration, "select_due_on".tr, (value) {
      filterKeys.duration = value;
      update();
      Get.back();
    });
  }

  void openAssigneeUsersFilter() {
    List<JPSingleSelectModel> list = [];   
    int id = filterKeys.userId ?? -1; 

    for (UserModel user in userList!) {
      list.add(JPSingleSelectModel(
                child: user.profilePic != null ? JPNetworkImage(src: user.profilePic) : null,
                label: user.fullName,
                id: user.id.toString()));
    }
    
    SingleSelectHelper.openSingleSelect(list, id.toString(), "select_user".tr,
        (value) {        
      selectedUser = userList!.firstWhere((user) => user.id.toString() == value);
      filterKeys.userId = userList!.firstWhere((user) => user.id.toString() == value).id;
      update();
      Get.back();
    }, inputHintText: 'search_user'.tr);
  }

  bool isResetButtonDisable() {
    bool isOnlyHighPriorityTaskSame = filterKeys.onlyHighPriorityTask == selectedFilters.onlyHighPriorityTask;
    bool isReminderNotificationSame = filterKeys.reminderNotification == selectedFilters.reminderNotification;
    bool isIncludeLockedTaskSame = filterKeys.includeLockedTask == selectedFilters.includeLockedTask;
    bool isStatusSame = filterKeys.status == selectedFilters.status;
    bool isDurationSame = filterKeys.duration == selectedFilters.duration;
    bool isJobIdSame = filterKeys.jobId == selectedFilters.jobId;
    bool isUserIdSame = filterKeys.userId == selectedFilters.userId;
    
    return (isOnlyHighPriorityTaskSame && isReminderNotificationSame && isIncludeLockedTaskSame && isDurationSame && isStatusSame && isJobIdSame && isUserIdSame);
  }

    @override
  void onInit() {
    setDefaultKeys(selectedFilters);
    super.onInit();
  }
}
