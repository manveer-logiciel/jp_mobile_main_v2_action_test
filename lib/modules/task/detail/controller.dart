import 'package:get/get.dart';
import 'package:jobprogress/common/enums/chats.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/models/task_listing/task_message.dart';
import 'package:jobprogress/common/repositories/task_listing.dart';
import 'package:jobprogress/common/services/task/quick_actions.dart';
import 'package:jobprogress/core/utils/firebase/firestore.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/routes/pages.dart';

class TaskDetailController extends GetxController {
  late TaskListModel task;
  Function(TaskListModel, String)? callback;

  bool isUserHaveEditPermission = true;

  bool isTaskTemplate = false;

  TaskDetailController({this.isUserHaveEditPermission = true, this.isTaskTemplate = false});


  void handleQuickActionUpdate(TaskListModel updatedTask, String action) {
    switch (action) {
      case 'mark_as_complete':
        task.completed = updatedTask.completed;
        break;

      case 'edit':
      case 'delete':
        Get.back();
        break;
      
      case 'unlock_stage_change':
        task.locked = false;
        break;

      case 'add_to_daily_plan':
        task.dueDate = updatedTask.dueDate;
        break;
        
      default:
    }
    
    if(callback != null) {
      update();
      callback!(updatedTask, action);
    }
    update();
  }

  void markAsComplete() async {
    TaskListModel updatedTask = await TaskService.markAsComplete(task);
    handleQuickActionUpdate(updatedTask, 'mark_as_complete');
  }

  Future<void> navigateToMessages() async {

    TaskMessageModel? message = task.message ?? (await reloadTask());

    if(message == null) return;

    Get.back();

      Get.toNamed(Routes.messages, arguments: {
        'group_id': message.threadId,
        'type': FirestoreHelpers.instance.isMessagingEnabled
            ? GroupsListingType.fireStoreMessages
            : GroupsListingType.apiMessages,
      });
    }

  Future<TaskMessageModel?> reloadTask() async {

    try {
      showJPLoader();

      Map<String, dynamic> params = {
        "includes[0]": ["created_by"],
        "includes[1]": ["participants"],
        "includes[2]": ["job"],
        "includes[3]": ["stage"],
        "includes[4]": ["customer"],
        "includes[5]": ["attachments"],
        "includes[6]": ["message"],
        'id': task.id
      };

      TaskListModel reloadedTask = await TaskListingRepository().getTask(params);
      return reloadedTask.message;
    } catch (e) {
      rethrow;
    }
  }

}
