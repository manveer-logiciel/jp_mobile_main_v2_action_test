import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/firebase/firestore/chat_group.dart';
import 'package:jobprogress/common/models/firebase/firestore/participants_status.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/providers/firebase/firestore/reference.dart';
import 'package:jobprogress/common/repositories/firebase/firestore/group_messages.dart';
import 'package:jobprogress/common/services/firestore/streams/groups/params.dart';
import 'package:jobprogress/common/services/firestore/streams/messages/params.dart';
import 'package:jobprogress/core/constants/firebase/firestore_keys.dart';
import 'package:jobprogress/core/utils/firebase/firestore.dart';

class GroupsRepo {

  static Future<Map<String, UserLimitedModel>?> getParticipantsData(List<String> allParticipants) async {

    try {
      if (allParticipants.isEmpty) return null;

      List<List<String>> chunks = FirestoreHelpers.getChunks(allParticipants);
      Map<String, UserLimitedModel> tempUsers = {};

      for (List<String> chunkedIds in chunks) {
        if (chunkedIds.isNotEmpty) {
          await ReferenceProvider.usersRef
              .where(FirestoreKeys.companyId,
              isEqualTo: GroupsRequestParams.instance.companyId.toString())
              .where(FirestoreKeys.id, whereIn: chunkedIds)
              .get()
              .then((value) {
            for (var data in value.docs) {
              final user = UserLimitedModel.fromJson(
                  data.data() as Map<String, dynamic>);
              tempUsers.putIfAbsent(user.id.toString(), () => user);
            }
          });
        }
      }

      return tempUsers;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, JobModel>?> getJobsData(List<String> jobs) async {
    if (jobs.isEmpty) return null;

    List<List<String>> chunks = FirestoreHelpers.getChunks(jobs);

    Map<String, JobModel> tempJobs = {};

    for (List<String> chunkedIds in chunks) {
      await ReferenceProvider.jobsRef
          .where(FirestoreKeys.companyId, isEqualTo: GroupsRequestParams.instance.companyId.toString())
          .where(FirestoreKeys.id, whereIn: chunkedIds)
          .get()
          .then((value) {
        for (var data in value.docs) {
          final user = JobModel.fromFirestoreJson(data.data() as Map<String, dynamic>);
          tempJobs.putIfAbsent(user.id.toString(), () => user);
        }
      });
    }

    return tempJobs;
  }

  static Future<void> markGroupAsRead({required String groupId, String? lastMessageId}) async {

    String currentUserId = GroupsMessageRequestParams.instance.userId.toString();

    final groupRef = ReferenceProvider.groupsRef.doc(groupId);
    final userRef = ReferenceProvider.usersRef.doc(currentUserId);
    final groupParticipantsRef = ReferenceProvider.groupParticipantsRef.doc('${groupId}_$currentUserId');

    // making message count zero
    Map<String, dynamic> groupParticipantsData = {FirestoreKeys.unreadMessageCount: 0};

    Map<String, dynamic> groupData = {};
    groupData['${FirestoreKeys.participantStatus}.$currentUserId.${FirestoreKeys.unreadMessageCount}'] = 0;

    if(lastMessageId != null) {
      // updating last read message id
      groupData['${FirestoreKeys.participantStatus}.$currentUserId.${FirestoreKeys.lastReadMessage}'] =
          lastMessageId;
    }

    Map<String, dynamic> userData = {};

    String sourceLAstUpdatedInfo = await FirestoreHelpers.getSourceLastUpdatedInfo();

    await FirebaseFirestore.instance.runTransaction((transaction) async {

      // attaching necessary data to make message as read
      userData.putIfAbsent(FirestoreKeys.sourceLastUpdated, () => Platform.operatingSystem);
      userData.putIfAbsent(FirestoreKeys.sourceLastUpdatedInfo, () => sourceLAstUpdatedInfo);

      groupData.putIfAbsent(FirestoreKeys.sourceLastUpdated, () => Platform.operatingSystem);
      groupData.putIfAbsent(FirestoreKeys.sourceLastUpdatedInfo, () => sourceLAstUpdatedInfo);

      groupParticipantsData.putIfAbsent(FirestoreKeys.sourceLastUpdated, () => Platform.operatingSystem);
      groupParticipantsData.putIfAbsent(FirestoreKeys.sourceLastUpdatedInfo, () => sourceLAstUpdatedInfo);

      // Use of transaction helps in updating count everywhere (in all 3 collections) we want to,
      // in case any of the one will fail, transaction will not update data on either of them,
      // thus helps in maintaining concurrency of data

      return await transaction.get(userRef).then((snapshot) async {
        DocumentSnapshot groupSnapshot = await transaction.get(groupRef);

        if(!groupSnapshot.exists) return;

        ChatGroupModel group = ChatGroupModel.fromJson(groupSnapshot.data() as Map<String, dynamic>, snapshot);

        if(group.myGroupMessageDetails == null) return;

        ParticipantsStatusModel userStatus = group.myGroupMessageDetails!;

        final userTransactionData = UserLimitedModel.fromJson(snapshot.data() as Map<String, dynamic>);

        if (userStatus.unreadMessageCount != null) {
          int remainingCount = userTransactionData.unreadMessageCount! - userStatus.unreadMessageCount!;

          // counts can never be in minus
          userData.putIfAbsent(FirestoreKeys.unreadMessageCount, () => remainingCount >= 0 ? remainingCount : 0);

          // updating documents
          transaction.update(userRef, userData);
          transaction.update(groupRef, groupData);
          transaction.update(groupParticipantsRef, groupParticipantsData);
        }
      });
    });
  }

  static Future<void> markGroupAsUnRead({required String groupId, String? lastMessageId}) async {

    String currentUserId = GroupsMessageRequestParams.instance.userId.toString();

    final groupRef = ReferenceProvider.groupsRef.doc(groupId);
    final userRef = ReferenceProvider.usersRef.doc(currentUserId);
    final groupParticipantsRef = ReferenceProvider.groupParticipantsRef.doc('${groupId}_$currentUserId');

    String sourceLAstUpdatedInfo = await FirestoreHelpers.getSourceLastUpdatedInfo();

    Map<String, dynamic> groupParticipantsData = {
      FirestoreKeys.unreadMessageCount: 1,
      FirestoreKeys.sourceLastUpdated: Platform.operatingSystem,
      FirestoreKeys.sourceLastUpdatedInfo: sourceLAstUpdatedInfo,
    };

    Map<String, dynamic> groupData = {
      FirestoreKeys.sourceLastUpdated: Platform.operatingSystem,
      FirestoreKeys.sourceLastUpdatedInfo: sourceLAstUpdatedInfo,
    };

    groupData['${FirestoreKeys.participantStatus}.$currentUserId.${FirestoreKeys.unreadMessageCount}'] = 1;

    Map<String, dynamic> userData = {
      FirestoreKeys.unreadMessageCount: FieldValue.increment(1),
      FirestoreKeys.sourceLastUpdated: Platform.operatingSystem,
      FirestoreKeys.sourceLastUpdatedInfo: sourceLAstUpdatedInfo,
    };

    /// Run transaction to update all related collections parallelly,
    /// If any query fails or some concurrent operations on same collections or in case of any errors,
    /// it will prevent data inconsistency and will rollback data from all queries.

    return await FirebaseFirestore.instance.runTransaction((transaction){
      transaction.update(groupRef, groupData);
      transaction.update(userRef, userData);
      transaction.update(groupParticipantsRef, groupParticipantsData);
      return Future(() => null);
    }).catchError((dynamic e) {
      throw e;
    });

  }
  
  /// Increments number of groups count to jobs collection if groups belongs to job
  static Future<void> incrementGroupCount({required String? jobId}) async {

    if(jobId?.isEmpty ?? true) return;

    try {

      String sourceLAstUpdatedInfo = await FirestoreHelpers.getSourceLastUpdatedInfo();

      Map<String, dynamic> incrementer = {
        FirestoreKeys.groupsCount: FieldValue.increment(1),
        FirestoreKeys.sourceLastUpdated: Platform.operatingSystem,
        FirestoreKeys.sourceLastUpdatedInfo: sourceLAstUpdatedInfo,
      };

      await ReferenceProvider.jobsRef.doc(jobId).update(incrementer);

    } catch (e) {
      rethrow;
    }
  }

  static Future<void> createNewGroup({
    bool sendAsEmail = false,
    required List<String> participantIds,
    String? jobId,
    String? taskId,
    required String content,
  }) async {

    try {

      final reference = ReferenceProvider.jobsRef;

      String companyId = GroupsMessageRequestParams.instance.companyId.toString();
      String currentUserId = GroupsMessageRequestParams.instance.userId.toString();
      String sourceInfo = await FirestoreHelpers.getSourceLastUpdatedInfo();
      String platform = Platform.operatingSystem;

      final timeStamp = Timestamp.now();

      Map<String, dynamic> groupData = {};

      participantIds.add(currentUserId);

      participantIds.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

      if(jobId != null) {
        groupData.putIfAbsent(FirestoreKeys.job, () => reference.doc(jobId));
        groupData.putIfAbsent(FirestoreKeys.jobId, () => jobId);
      } else {
        groupData.putIfAbsent(FirestoreKeys.jobId, () => '');
      }

      final response = await ReferenceProvider
          .groupsRef
          .where(FirestoreKeys.companyId, isEqualTo: companyId)
          .where(FirestoreKeys.jobId, isEqualTo: jobId ?? '')
          .where(FirestoreKeys.participants, whereIn: [participantIds])
          .get();

      if(response.size > 0) {
        await GroupMessageRepo.sendMessage(
            content,
            groupDataParticipants: participantIds,
            groupId: response.docs.first.id,
            createNewGroup: false,
            jobId: jobId,
            sendAsEmail: sendAsEmail,
            taskId: taskId,
        );
      } else {

        Map<String, dynamic> participantStatus = {};

        for (var id in participantIds) {
          participantStatus.putIfAbsent(id.toString(), () => {
            FirestoreKeys.unreadMessageCount : id == currentUserId ? 0 : FieldValue.increment(1),
            FirestoreKeys.createdAt : timeStamp,
            FirestoreKeys.createdBy : currentUserId,
            FirestoreKeys.lastReadMessage : '',
          });
        }

        groupData.putIfAbsent(FirestoreKeys.createdAt, () => timeStamp);
        groupData.putIfAbsent(FirestoreKeys.updatedAt, () => timeStamp);
        groupData.putIfAbsent(FirestoreKeys.participants, () => participantIds);
        groupData.putIfAbsent(FirestoreKeys.participantStatus, () => participantStatus);
        groupData.putIfAbsent(FirestoreKeys.companyId, () => companyId);
        groupData.putIfAbsent(FirestoreKeys.createdBy, () => currentUserId);
        groupData.putIfAbsent(FirestoreKeys.source, () => platform);
        groupData.putIfAbsent(FirestoreKeys.sourceInfo, () => sourceInfo);

        await ReferenceProvider
            .groupsRef
            .add(groupData)
            .then((groupRef) async {

          await GroupMessageRepo.sendMessage(
              content,
              groupDataParticipants: participantIds,
              groupId: groupRef.id,
              createNewGroup: true,
              jobId: jobId,
              sendAsEmail: sendAsEmail,
              taskId: taskId,
          ).then((value) async {
            await incrementGroupCount(jobId: jobId);
          });
        });
      }
    } catch (e) {
      rethrow;
    }

  }

  /// getMessageContentForTask() helps in generating task description message
  static String getMessageContentForTask(TaskListModel task) {
    String content = "${"task_message_desc".tr}:-\n\n${"title".tr.capitalizeFirst!} - ${task.title}";

    if(task.job != null && task.customer != null) {
      content += "\n${"linked_job".tr.capitalize!} - ${task.customer!.firstName} ${task.customer!.lastName} / ${task.job!.number}";
    }

    if(task.participants?.isNotEmpty ?? false) {
      final participantsNames = task.participants?.map((participant) => "${participant.firstName} ${participant.lastName}");

      content += "\n${"participants".tr.capitalizeFirst!} - ${participantsNames?.join(', ')}";
    }

    if(task.notes?.isNotEmpty ?? false) {
      content += "\n${"notes".tr.capitalizeFirst!} - ${task.notes}";
    }

    if(task.dueDate?.isNotEmpty ?? false) {
      content += "\n${"due_date".tr.capitalize!} - ${task.dueDate}";
    }

    return content;
  }

  static Future<void> forceUpdateTotalUnreadCount({int newCount = 0}) async {
    String currentUserId = GroupsMessageRequestParams.instance.userId.toString();

    final userRef = ReferenceProvider.usersRef.doc(currentUserId);

    Map<String, dynamic> userData = {};

    String sourceLAstUpdatedInfo = await FirestoreHelpers.getSourceLastUpdatedInfo();

    // attaching necessary data to make message as read
    userData.putIfAbsent(FirestoreKeys.sourceLastUpdated, () => Platform.operatingSystem);
    userData.putIfAbsent(FirestoreKeys.sourceLastUpdatedInfo, () => sourceLAstUpdatedInfo);

    userData.putIfAbsent(FirestoreKeys.unreadMessageCount, () => newCount);

    await FirebaseFirestore.instance.runTransaction((transaction){
      transaction.update(userRef, userData);
      return Future(() => null);
    }).catchError((dynamic e) {
      throw e;
    });

  }


}
