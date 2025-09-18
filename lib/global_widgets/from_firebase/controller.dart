import 'package:get/get.dart';
import 'package:jobprogress/common/enums/firebase.dart';

class FromFirebaseController extends GetxController {
  Map<RealTimeKeyType, dynamic> valuesMap = {
    RealTimeKeyType.taskPending: null,
    RealTimeKeyType.messageUnread: null,
    RealTimeKeyType.notificationUnread: null,
    RealTimeKeyType.emailUnread: null,
    RealTimeKeyType.isRestricted: null,
    RealTimeKeyType.taskTodayUpdated: null,
    RealTimeKeyType.taskUpcomingUpdated: null,
    RealTimeKeyType.appointmentTodayUpdated: null,
    RealTimeKeyType.appointmentUpcomingUpdated: null,
    RealTimeKeyType.eventTodayUpdated: null,
    RealTimeKeyType.scheduleTodayUpdated: null,
    RealTimeKeyType.permissionUpdated: null,
    RealTimeKeyType.workflowUpdated: null,
    RealTimeKeyType.job: null,
    RealTimeKeyType.textMessageUnread: null,
    RealTimeKeyType.checkInCheckOutWithOutJob: null,
    RealTimeKeyType.userSettingUpdated: null,
    RealTimeKeyType.companySettingUpdated: null,
    RealTimeKeyType.automationFeedUpdated: null,
  };

  Map<FireStoreKeyType, dynamic> valuesMapFirestore = {
    FireStoreKeyType.unreadMessageCount : null,
  };

  dynamic getValues({List<RealTimeKeyType>? keys, RealTimeResult result = RealTimeResult.firstValue, FireStoreKeyType? fireStoreKeyType}) {
    if (fireStoreKeyType != null) {
      return valuesMapFirestore[fireStoreKeyType];
    } else if(keys != null) {
      if (keys.length == 1) {
        return valuesMap[keys.first];
      } else {
        if (result == RealTimeResult.firstValue) {
          return valuesMap[keys.first];
        } else if (result == RealTimeResult.add) {
          int count = 0;
          for (var val in keys) {
            count = count + int.parse(valuesMap[val] ?? '0');
          }
          return count;
        } else {
          List<dynamic> values = [];
          for (var val in keys) {
            values.add(valuesMap[val]);
          }
          return values;
        }
      }
    }
  }

  dynamic getAddedResult(List<dynamic> keys) {

    int result = 0;

    for (var key in keys) {

      if(key == null) continue;

      if(key is FireStoreKeyType) {
        result += int.parse(valuesMapFirestore[key]?.toString() ?? '0');
      } else if(key is RealTimeKeyType) {
        result += int.parse(valuesMap[key] ?? '0');
      } else {
        result += 0;
      }

    }

    return result;

  }

}
