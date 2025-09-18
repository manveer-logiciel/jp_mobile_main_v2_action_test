import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobprogress/common/models/firebase/firestore/group_message.dart';
import 'package:jobprogress/common/providers/firebase/firestore/reference.dart';
import 'package:jobprogress/common/services/firestore/streams/messages/params.dart';
import 'package:jobprogress/core/constants/firebase/firestore_keys.dart';
import 'package:jobprogress/core/utils/firebase/firestore.dart';

class GroupMessageRepo {
  static Future<List<GroupMessageModel>> fetchMessages({
    required String groupId,
    DocumentSnapshot? beforeDoc,
    DocumentSnapshot? afterDoc,
    String? afterId,
  }) async {
    try {

      if(afterId?.isNotEmpty ?? false) {
        DocumentSnapshot snapshot = await ReferenceProvider.groupsMessageRef.doc(afterId).get();
        beforeDoc = snapshot;
      }

      String companyId = GroupsMessageRequestParams.instance.companyId.toString();
      bool isDescending = afterDoc == null && afterId == null;
      bool doReverseResult = isDescending && beforeDoc == null;

      Query<GroupMessageModel> query = ReferenceProvider.groupsMessageRef
          .where(FirestoreKeys.companyId, isEqualTo: companyId)
          .where(FirestoreKeys.groupId, isEqualTo: groupId)
          .orderBy(GroupsMessageRequestParams.instance.defaultSortBy, descending: isDescending)
          .withConverter(
              fromFirestore: (snapshot, _) =>
                  GroupMessageModel.fromSnapShot(snapshot),
              toFirestore: (model, _) => {});

      if (beforeDoc != null) {
        query = query.startAfterDocument(beforeDoc);
      }

      if(afterDoc != null) {
        query = query.startAfterDocument(afterDoc);
      }

      query = query.limit(GroupsMessageRequestParams.instance.defaultPaginationLimit);

      QuerySnapshot<GroupMessageModel> result = await query.get();

      List<GroupMessageModel> messageList =
          result.docs.map((e) => e.data()).toList();

      if(doReverseResult) {
        messageList = messageList.reversed.toList();
      }

      return messageList;
    } catch (e) {
      rethrow;
    }
  }


  static Future<void> sendMessage(String content, {
    bool sendAsEmail = false,
    bool createNewGroup = false,
    required List<String>? groupDataParticipants,
    required String? groupId,
    String? jobId,
    String? taskId,
  }) async {

    final messageTime = Timestamp.now();

    String companyId = GroupsMessageRequestParams.instance.companyId.toString();
    String currentUserId = GroupsMessageRequestParams.instance.userId.toString();
    String sourceInfo = await FirestoreHelpers.getSourceLastUpdatedInfo();
    String platform = Platform.operatingSystem;

    List<String> participants = groupDataParticipants ?? [];

    GroupMessageModel message = GroupMessageModel(
      sendAsEmail: sendAsEmail ? 1 : 0,
      content: content,
      groupId: groupId!,
      createdAt: messageTime.toDate(),
      updatedAt: messageTime.toDate(),
      sender: currentUserId,
      companyId: companyId,
      source: platform,
      sourceInfo: sourceInfo,
      taskId: taskId,
    );

    final data = message.toJson();

    await ReferenceProvider
        .groupsMessageRef
        .add(data).then((messageRef) async {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      final groupRef = ReferenceProvider.groupsRef.doc(message.groupId);
      final recentMessageRef = ReferenceProvider.groupsMessageRef.doc(messageRef.id);

      Map<String, dynamic> groupData = {
        FirestoreKeys.recentMessage: message.content,
        FirestoreKeys.recentMessageRef: recentMessageRef,
        FirestoreKeys.messageCount: FieldValue.increment(1), // Will set count of messages in group.
        FirestoreKeys.updatedAt: messageTime,
        FirestoreKeys.sourceLastUpdated: platform,
        FirestoreKeys.sourceLastUpdatedInfo: sourceInfo
      };

      Map<String, dynamic> groupParticipantsCommonData = {
        FirestoreKeys.companyId: companyId,
        FirestoreKeys.groupId: groupId,
        FirestoreKeys.participants: participants,
        FirestoreKeys.jobId: jobId ?? '',
        FirestoreKeys.createdAt: messageTime,
        FirestoreKeys.updatedAt: messageTime,
        FirestoreKeys.createdBy: currentUserId,
        FirestoreKeys.deletedAt: '',
        FirestoreKeys.source: platform,
        FirestoreKeys.sourceInfo: sourceInfo
      };

      Map<String, dynamic> usersCommonData = {
        FirestoreKeys.sourceLastUpdated: platform,
        FirestoreKeys.sourceLastUpdatedInfo: sourceInfo
      };

      for (var participantId in participants) {

        Map<String, dynamic> groupParticipantsData = Map<String, dynamic>.from(groupParticipantsCommonData);
        Map<String, dynamic> usersData = Map<String, dynamic>.from(usersCommonData);

        String groupParticipantDocId = '${groupId}_$participantId';
        groupParticipantsData.putIfAbsent(FirestoreKeys.uid, () => participantId);

        if(participantId != currentUserId) {
          groupParticipantsData.putIfAbsent(FirestoreKeys.unreadMessageCount, () => FieldValue.increment(1));
        } else if(createNewGroup && participantId == currentUserId) {
          groupParticipantsData.putIfAbsent(FirestoreKeys.unreadMessageCount, () => 0);
        }

        if(participantId != currentUserId) {
          usersData.putIfAbsent(FirestoreKeys.unreadMessageCount, () => FieldValue.increment(1));
          if(!createNewGroup) {
            groupData['${FirestoreKeys.participantStatus}.$participantId.${FirestoreKeys.unreadMessageCount}'] = FieldValue.increment(1);
          }
        } else {
          groupData['${FirestoreKeys.participantStatus}.$currentUserId.${FirestoreKeys.lastReadMessage}'] = messageRef.id;
          if(createNewGroup) {
            groupData['${FirestoreKeys.participantStatus}.$currentUserId.${FirestoreKeys.unreadMessageCount}'] = 0;
          }
        }


        final groupParticipantsRef = ReferenceProvider.groupParticipantsRef.doc(groupParticipantDocId);

        if(createNewGroup) {

          usersData.putIfAbsent(FirestoreKeys.groupsCount, () => FieldValue.increment(1));
          batch.set(groupParticipantsRef, groupParticipantsData);

        } else {
          Map<String, dynamic> gpData = {
            FirestoreKeys.updatedAt: messageTime,
            FirestoreKeys.sourceLastUpdated: platform,
            FirestoreKeys.sourceLastUpdatedInfo: sourceInfo,
          };

          if (participantId != currentUserId) {
            gpData.putIfAbsent(FirestoreKeys.unreadMessageCount, () => FieldValue.increment(1));
          }
          batch.update(groupParticipantsRef, gpData);
        }

        if (usersData.containsKey(FirestoreKeys.groupsCount) || usersData.containsKey(FirestoreKeys.unreadMessageCount)) {
            final userUpdateRef = ReferenceProvider.usersRef.doc(participantId);

            if(createNewGroup && participantId == currentUserId) {
              usersData[FirestoreKeys.unreadMessageCount] = FieldValue.increment(0);
              batch.update(userUpdateRef, usersData);
            }

            if(participantId != currentUserId) {

              // increments group count of other user when first time group is created
              if(createNewGroup) {
                usersData[FirestoreKeys.unreadMessageCount] = FieldValue.increment(1);
              }

              batch.update(userUpdateRef, usersData);
            }
        }
      }

      batch.update(groupRef, groupData);

      await batch.commit();

    }). catchError((dynamic e) {
      throw e;
    });
  }

}
