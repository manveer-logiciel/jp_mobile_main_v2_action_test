import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobprogress/common/models/firebase/firestore/chat_group.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/firestore/streams/groups/params.dart';

class GroupsData {

  int totalGroups = 0; // used to store group count
  int totalTexts = 0; // used to store texts count

  String? jobId; // used to store job id
  String? groupFilter = 'all_messages'; // used to store group filter

  DocumentSnapshot? afterDocForFilterList; // used to perform load-more in filtered list

  bool isForFilteredList = false; // helps to know whether list is filtered list

  List<ChatGroupModel> groupsList = []; // used to store groups
  List<ChatGroupModel> textsList = []; // used to store groups
  List<List<String>> filteredGroupChunks = []; // used to store group id chunks

  Map<String, ChatGroupModel> allGroups = {}; // used to store loaded groups from fire-store

  // Reason for static: so once loaded users, jobs needs not to be loaded again and again
  static Map<String, UserLimitedModel> allUsers = {};  // used to store all used (local + loaded from firebase)
  static Map<String, JobModel> allJobs = {}; // used to store jobs loaded from fire-store

  bool get isUnreadMessageCountFilterApplied => groupFilter == 'unread_message_count';

  /// setUpGroups():  parse data received from fire-store to groups model
  Map<String, List<String>> setUpGroups(QuerySnapshot snapshots, {required VoidCallback? onSelectedGroupRemoved, required String? selectedGroupId}) {

    List<String> participantIds = []; // for storing users, whose data is not available
    List<String> jobIds = []; // for storing jobIds, which are not loaded

    for (var changedDoc in snapshots.docChanges) {

      final String docId = changedDoc.doc.id;

      // parsing snapshot to ChatGroupModel
      final chatGroup = ChatGroupModel.fromJson(
          changedDoc.doc.data() as Map<String, dynamic>, changedDoc.doc);

      // adding participants ids which are not loaded yet
      participantIds.addAll(chatGroup.participants.where((userId) => !allUsers.containsKey(userId)));

      // adding job ids which are not loaded yet
      if (chatGroup.jobId.isNotEmpty && !allJobs.containsKey(chatGroup.jobId)) {
        jobIds.add(chatGroup.jobId);
      }

      if (allGroups.containsKey(docId)) {
        if(changedDoc.type == DocumentChangeType.removed) {
          if(selectedGroupId == docId) {
            onSelectedGroupRemoved?.call();
          }
          allGroups.remove(docId);
        } else {
          // in case received snapshot is already available, simpy updating it
          allGroups.update(
              docId, (value) => ChatGroupModel.addPendingData(chatGroup));
        }
      } else {
        // if received data is loaded for first time, simply adding it
        allGroups.putIfAbsent(docId, () => chatGroup);
      }
    }

    // returning participantIds & jobIds, that needs to be loaded from firebase
    return {
      'participants': participantIds,
      'jobs': jobIds,
    };
  }

  /// setUsers(): setter for users
  static void setUsers(Map<String, UserLimitedModel>? users) {
    if (users == null) return;
    allUsers.addAll(users);
  }

  /// setJobs(): setter for jobs
  static void setJobs(Map<String, JobModel>? jobs) {
    if (jobs == null) return;
    allJobs.addAll(jobs);
  }

  /// setFilteredGroupChunks(): groups chunk setter
  void setFilteredGroupChunks(List<List<String>>? chunks) {
    if(chunks == null || chunks.isEmpty) {
      totalGroups = 0;
      filteredGroupChunks.clear();
      return;
    }
    filteredGroupChunks.addAll(chunks); // adding chunks
    totalGroups = (chunks.first.length) + totalGroups + (totalGroups == 0 ? 1 : 0); // setting up group count for filtered list
  }

  /// getGroupChunkToLoad(): loads and removes loaded chunks
  List<String> getGroupChunkToLoad() {

    if(filteredGroupChunks.isEmpty) return <String>[];

    List<String> chunks = filteredGroupChunks[0];
    filteredGroupChunks.removeAt(0);
    return chunks;
  }

  /// updateGroupsWithUsersAndJob(): update loaded groups with, loaded users and jobs from fire-store
  void updateGroupsWithUsersAndJob() {
    for (ChatGroupModel group in allGroups.values) {
      group = ChatGroupModel.addPendingData(group);
    }
    setGroupsList();
  }

  void setGroupsList() {

    try {
      final loggedInUserId = AuthService.userDetails?.id.toString();

      final sortedMap = isUnreadMessageCountFilterApplied
          ? Map.fromEntries(allGroups.entries.skip(groupsList.length).toList()..sort((e1, e2) => e2.value.unreadMessageCount!.compareTo(e1.value.unreadMessageCount!)))
          : Map.fromEntries(allGroups.entries.toList()..sort((e1, e2) => e2.value.updatedAt.compareTo(e1.value.updatedAt)));

      if (isUnreadMessageCountFilterApplied) {
        groupsList.addAll(sortedMap.values.toList());
      } else {
        groupsList = sortedMap.values.toList();
      }


      if (!isForFilteredList && jobId == null && allUsers[loggedInUserId]?.groupCount != null) {
        totalGroups = allUsers[loggedInUserId]!.groupCount!;
      }

      if (groupsList.length <
          GroupsRequestParams.instance.defaultPaginationLimit) {
        totalGroups = groupsList.length;
      }
    } catch (e) {
      rethrow;
    }

  }

  /// setJobId(): setter for job id
  void setJobId(String? id) {
    jobId = id;
    clearGroups();
  }

  /// setGroupSortFilter(): setter for sort filter
  void setGroupSortFilter(String? filter) {

    if(filter == 'unread_message_count') {
      groupFilter = filter;
    } else {
      groupFilter = 'all_messages';
    }
    clearGroups();
  }

  void setAfterDoc(DocumentSnapshot? snapshot) {
    afterDocForFilterList = snapshot;
  }

  void clearData() {
    groupsList.clear();
    allUsers.clear();
    allGroups.clear();
    allJobs.clear();
    filteredGroupChunks.clear();
    totalGroups = 0;
  }

  void clearGroups() {
    afterDocForFilterList = null;
    filteredGroupChunks.clear();
    groupsList.clear();
    allGroups.clear();
    totalGroups = 0;
  }

  void clearTexts() {
    textsList.clear();
    totalTexts = 0;
  }

  int getTotalUnreadCountOfThreads() {

    int totalUnreadCount = 0;

    for (var group in groupsList) {
      totalUnreadCount += group.unreadMessageCount ?? 0;
    }

    return totalUnreadCount;
  }
}
