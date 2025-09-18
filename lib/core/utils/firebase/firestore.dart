
import 'dart:io';
import 'package:jobprogress/common/libraries/global.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:jobprogress/common/models/firebase/firestore/group_message.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/providers/firebase/auth.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/user_roles.dart';
import 'package:jobprogress/common/services/firestore/streams/groups/data.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class FirestoreHelpers {
  static FirestoreHelpers get instance {
    return FirestoreHelpers();
  }

  bool get isMessagingEnabled => Helper.isTrue(CompanySettingsService.getCompanySettingByKey(
          CompanySettingConstants.realTimeMessaging).toString());

  bool get isFirebaseLoggedIn =>
      FirebaseAuthProvider.getCurrentUser() != null;

  static String getMessageTime(Timestamp timestamp) {

    final date = timestamp.toDate();
    final today = DateTime.now();

    if(today.difference(date).inDays < 1 && today.day == date.day) {
      return DateTimeHelper.format(date.toString(), DateFormatConstants.timeOnlyFormat);
    } else {
      return Jiffy.parse(date.toString()).fromNow();
    }
  }

  static List<List<String>> getChunks(List<String> data, {int chunkSize = 10}) {

    final uniqueEntries = data.toSet().toList();

    List<List<String>> chunksList = [];

    int chunksCount = (uniqueEntries.length / chunkSize).floor();
    int remainingChunk = (uniqueEntries.length % chunkSize);

    for (int i = 0; i < chunksCount; i++) {

      final startFrom = i * chunkSize;
      chunksList.add(uniqueEntries.sublist(startFrom, startFrom + chunkSize));
    }

    if (remainingChunk > 0) {
      chunksList.add(uniqueEntries.reversed.take(remainingChunk).toList());
    }

    return chunksList;
  }

  static int getDaysDifference(DateTime dateOne, DateTime dateTwo) {

    final dateOneToCompare = DateTime(dateOne.year, dateOne.month, dateOne.day);
    final dateTwoToCompare = DateTime(dateTwo.year, dateTwo.month, dateTwo.day);

    return dateTwoToCompare.difference(dateOneToCompare).inDays.abs();
  }

  static String? actionTypeToName(String? actionType) {
    if (actionType == 'add_participant') {
      return 'added';
    } else if (actionType == 'remove_participant') {
      return 'removed';
    } else {
      return null;
    }
  }

  static String? getActionBy(String? id, {bool giveYouForCurrentUserName = true}) {
    if (id != null) {
      UserLimitedModel? user = GroupsData.allUsers[id];

      if (user == null) {
        return "";
      }

      return getUserName(user, giveYouForCurrentUserName: giveYouForCurrentUserName);
    } else {
      return null;
    }
  }

  static String? getActionOn(List<dynamic>? ids) {

    if (ids != null) {
      List<String> participantsToLoadIds = [];

      List<UserLimitedModel?> participants = ids.map((e) {
        final user = GroupsData.allUsers[e];
        if (user == null) participantsToLoadIds.add(e);
        return user;
      }).toList();


      switch (participants.length) {
        case 1:
          return getUserName(participants[0]);
        case 2:
          return "${getUserName(participants[0])} and ${getUserName(participants[1])}";
        case 3:
          return "${getUserName(participants[0])}, ${getUserName(participants[1])} and ${getUserName(participants[2])}";
        default:
          return "${getUserName(participants[0])}, ${getUserName(participants[1])} and ${participants.length - 2} other";
      }
    } else {
      return null;
    }
  }

  static String getUserName(UserLimitedModel? user, {bool giveYouForCurrentUserName = true, bool isAutomated = false}) {

    if(user == null) return "";

    if(giveYouForCurrentUserName && user.id == AuthService.userDetails?.id) return 'You';

    // Check if this is a system user (anonymous group ID) and return "Leap System"
    if(user.groupId == UserGroupIdConstants.anonymous && isAutomated) return 'Leap System';

    return user.firstName + (user.lastName != null ? " ${user.lastName}" : "");
  }

  static String getActionString({
    String? actionType,
    String? actionById,
    List<dynamic>? actionOnId,
  }) {
    String? action = FirestoreHelpers.actionTypeToName(actionType);
    String? actionBy = FirestoreHelpers.getActionBy(actionById, giveYouForCurrentUserName: false);
    String? actionOn = FirestoreHelpers.getActionOn(actionOnId);

    return "$actionBy $action $actionOn";

  }


  /// setInBetweenMessageDates(): scans message list and decides whether a date tag has to be inserted in between messages
  static List<GroupMessageModel> setInBetweenMessageDates(
      List<GroupMessageModel> result, {bool forInitialLoad = false}) {
    for (int i = 0; i < result.length; i++) {
      if (i < result.length - 1) {
        int indexToUpdate = forInitialLoad ? i + 1 : i;
        result[indexToUpdate].doShowDate = doShowDate(result[i], result[i + 1]);
      }
    }

    return result;
  }

  /// doShowDate(): finds difference between dates and decides, whether date needs to be displayed
  static bool doShowDate(GroupMessageModel msgOne, GroupMessageModel msgTwo) {
    return FirestoreHelpers.getDaysDifference(
        msgOne.updatedAt, msgTwo.updatedAt) >
        0;
  }

  /// getSourceLastUpdatedInfo(): provides data for getting info of device
  static Future<String> getSourceLastUpdatedInfo() async {
    String url = Get.currentRoute;
    String version = globals.appVersion;
    String agent = await getUserAgent();

    return "$version \n $url \n $agent";
  }

  /// getUserAgent(): provides all the available device details
  static Future<String> getUserAgent() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final value = await deviceInfoPlugin.androidInfo;
      // ignore: deprecated_member_use
      return "${value.manufacturer.toString().capitalizeFirst} ${value.device} ${value.version.toMap()}";
    } else {
      final value = await deviceInfoPlugin.iosInfo;
      return "${value.name} ${value.systemName}(${value.systemVersion}) ${value.utsname.machine} ${value.utsname.version}";
    }
  }

}