import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/firebase/firestore/chat_group.dart';
import 'package:jobprogress/common/models/firebase/firestore/group_participant.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/providers/firebase/firestore/reference.dart';
import 'package:jobprogress/common/services/firestore/streams/messages/params.dart';
import 'package:jobprogress/core/utils/firebase/firestore.dart';

class ParticipantsService {
  final ChatGroupModel group;
  final String groupId;

  ParticipantsService(this.group, this.groupId);

  Future<void> removeParticipants({
    required UserLimitedModel participant,
  }) async {


    // setting up necessary values
    final timeStamp = Timestamp.now();
    final instance = FirebaseFirestore.instance;
    final groupRef = ReferenceProvider.groupsRef.doc(groupId);

    String companyId = GroupsMessageRequestParams.instance.companyId.toString();
    String currentUserId = GroupsMessageRequestParams.instance.userId.toString();
    String sourceInfo = await FirestoreHelpers.getSourceLastUpdatedInfo();
    String platform = Platform.operatingSystem;
    String participantId = participant.id.toString();

    // Checking is user exist or not
    if (group.participants.isEmpty) {
      throw Exception('no_participants_found'.tr);
    }

    // Initialized new message object to show action and action details
    Map<String, dynamic> newMessageData = {
      "company_id": companyId,
      "content": FirestoreHelpers.getActionString(
        actionById: currentUserId,
        actionOnId: [participantId],
        actionType: 'remove_participant',
      ),
      "group_id": groupId,
      "created_at": timeStamp,
      "updated_at": timeStamp,
      "send_as_email": 0,
      "sender": currentUserId,
      "action": 'remove_participant',
      "action_detail": {
        "action_data_new": [participantId]
      },
      "source": platform,
      "source_info": sourceInfo
    };

    // updatedParticipantIds contains updated ids (without to be removed ids)
    List<String> updatedParticipantIds = group.participants.where((id) => id != participantId).toList();

    // sorting ids in asc. order
    updatedParticipantIds.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    Map<String, dynamic> groupDataToUpdate = {
      'participants': updatedParticipantIds,
      'message_count': FieldValue.increment(1),
      'recent_message': newMessageData['content'],
      'updated_at': timeStamp,
      'source_last_updated': platform,
      'source_last_updated_info': sourceInfo
    };

    groupDataToUpdate['participants_status.$participantId.deleted_by'] = currentUserId;
    groupDataToUpdate['participants_status.$participantId.deleted_at'] = timeStamp;
    groupDataToUpdate['participants_status.$participantId.unread_message_count'] = 0;


    // Adding new message object to show action and action details
    return await ReferenceProvider.groupsMessageRef
        .add(newMessageData)
        .then((messageRef) async {
      groupDataToUpdate['recent_message_ref'] = messageRef;

      // Getting all group participants which belongs to group for updating participants list
      return await ReferenceProvider.groupParticipantsRef
          .where('group_id', isEqualTo: groupId)
          .withConverter(
              fromFirestore: (snapshot, _) => GroupParticipantModel.fromSnapShot(snapshot),
              toFirestore: (_, __) => {})
          .get()
          .then((snapshot) {
        final groupParticipants = snapshot.docs;

        // Started transaction so we can rollback transaction if any fails
        return instance.runTransaction<void>((transaction) {
          Map<String, dynamic> userDataToUpdate = {
            'groups_count': FieldValue.increment(-1),
            'source_last_updated': platform,
            'source_last_updated_info': sourceInfo
          };

          if ((group.participantsStatus[participantId]?.unreadMessageCount ?? 0) > 0) {
            userDataToUpdate.putIfAbsent(
                'unread_message_count',
                () => FieldValue.increment(-(group.participantsStatus[participantId]?.unreadMessageCount ?? 1)));
          }

          final userRef = ReferenceProvider.usersRef.doc(participantId);
          transaction.update(userRef, userDataToUpdate);

          for (String userId in updatedParticipantIds) {
            if (userId != currentUserId) {
              final userRef = ReferenceProvider.usersRef.doc(userId);

              transaction.update(userRef, {
                "unread_message_count": FieldValue.increment(1),
                "source_last_updated": platform,
                "source_last_updated_info": sourceInfo,
              });

              groupDataToUpdate['participants_status.$userId.unread_message_count'] = FieldValue.increment(1);
            }
          }

          final groupParticipantIdToRemove = "${groupId}_$participantId";

          // Updating fetched group_participants participant list
          for (var doc in groupParticipants) {
            Map<String, dynamic> groupParticipantDataToUpdate = {
              'participants': updatedParticipantIds,
              'updated_at': timeStamp,
              'source_last_updated': platform,
              'source_last_updated_info': sourceInfo,
            };

            if (doc.id != "${groupId}_$currentUserId") {
              groupParticipantDataToUpdate['unread_message_count'] =
                  FieldValue.increment(1);
            }

            if (doc.id == groupParticipantIdToRemove) {
              groupParticipantDataToUpdate['deleted_by'] = currentUserId;
              groupParticipantDataToUpdate['deleted_at'] = timeStamp;
              groupParticipantDataToUpdate['unread_message_count'] = 0;
            }

            transaction.update(doc.reference, groupParticipantDataToUpdate);
          }

          //Updating group participant list and participant status
          transaction.update(groupRef, groupDataToUpdate);

          return Future(() => null);
        }).catchError((dynamic e) {
          throw e;
        });
      });
    });
  }

  Future<void> addParticipants(List<String> participantIds) async {

    // setting up necessary values
    final timeStamp = Timestamp.now();
    final groupRef = ReferenceProvider.groupsRef.doc(groupId);

    List<String> activeParticipantIds = group.activeParticipants!.map((e) => e.id.toString()).toList();

    String companyId = GroupsMessageRequestParams.instance.companyId.toString();
    String currentUserId = GroupsMessageRequestParams.instance.userId.toString();
    String sourceInfo = await FirestoreHelpers.getSourceLastUpdatedInfo();
    String platform = Platform.operatingSystem;

    for (var id in participantIds) {
      if (activeParticipantIds.contains(id)) {
        participantIds.remove(id);
      }
    }

    //Checking is user already exist or not
    if (participantIds.isEmpty) {
      throw Exception('participants_already_exist_in_group'.tr);
    }

    final groupParticipantsStatus = group.participantsStatus.map((key, value) =>
        MapEntry(key,
            value.toJson(removeDeleteEntries: participantIds.contains(key))));

    // Initialized new message object to show action and action details
    Map<String, dynamic> newMessageData = {
      'company_id': companyId,
      'content': FirestoreHelpers.getActionString(
          actionType: 'add_participant',
          actionOnId: participantIds,
          actionById: currentUserId),
      'group_id': groupId,
      'created_at': timeStamp,
      'updated_at': timeStamp,
      'send_as_email': 0,
      'sender': currentUserId,
      'action': 'add_participant',
      'action_detail': {'action_data_new': participantIds},
      'source': platform,
      'source_info': sourceInfo
    };

    // generating a combined list of old active users and new participants
    final sortedParticipantIds = [...activeParticipantIds, ...participantIds];
    sortedParticipantIds.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

    Map<String, dynamic> groupDataToUpdate = {
      'participants': sortedParticipantIds,
      'updated_at': timeStamp,
      'message_count': FieldValue.increment(1),
      'recent_message': newMessageData['content'],
      'participants_status': groupParticipantsStatus,
      'source_last_updated': platform,
      'source_last_updated_info': sourceInfo
    };

    // Adding new message object to show action and action details
    await ReferenceProvider.groupsMessageRef
        .add(newMessageData)
        .then((newAddedMessageRef) async {
      groupDataToUpdate['recent_message_ref'] = newAddedMessageRef;

      // Getting all group participants which belongs to group for updating participants list
      await ReferenceProvider.groupParticipantsRef
          .where('group_id', isEqualTo: groupId)
          .get()
          .then((grpParticipantsRes) async {

        //Started transaction so we can rollback transaction if any fails
        return await FirebaseFirestore.instance.runTransaction<void>((transaction) {

          //Adding new group_participants which are new in group_participants collection
          for (String userId in participantIds) {
            final newGroupParticipantsRef = ReferenceProvider
                .groupParticipantsRef
                .doc("${groupId}_$userId");

            Map<String, dynamic> newGroupParticipantsData = {
              'company_id': companyId,
              'group_id': groupId,
              'participants': sortedParticipantIds,
              'uid': userId,
              'job_id': group.jobId,
              'unread_message_count': FieldValue.increment(1),
              'created_at': timeStamp,
              'updated_at': timeStamp,
              'deleted_at': '',
              'created_by': currentUserId,
              'source': platform,
              'source_info': sourceInfo
            };

            groupDataToUpdate['participants_status'].putIfAbsent(userId, () => {
              'created_at' : timeStamp,
              'created_by' : currentUserId,
              'last_read_message' : ''
            });

            transaction.set(newGroupParticipantsRef, newGroupParticipantsData);
          }


           // Updating user collection keys(unread_message_count - for all new and existing user, groups_count - for new user)
           //  Updating participants_status for all new and existing user in groups collections
           // Not performing both action for user which is adding participant

          for (String userId in sortedParticipantIds) {
            if (userId != currentUserId) {
              // Updating user groups_count for new user in user collection
              final userRef = ReferenceProvider.usersRef.doc(userId);

              Map<String, dynamic> userDataToUpdate = {
                'unread_message_count': FieldValue.increment(1),
                'source_last_updated': platform,
                'source_last_updated_info': sourceInfo
              };

              if (participantIds.contains(userId)) {
                userDataToUpdate['groups_count'] = FieldValue.increment(1);
                groupDataToUpdate['participants_status.$userId.last_read_message'] = '';
                groupDataToUpdate['participants_status.$userId.created_by'] = currentUserId;
                groupDataToUpdate['participants_status.$userId.created_at'] = timeStamp;
                groupDataToUpdate['participants_status.$userId.unread_message_count'] = FieldValue.increment(1);
              }
              transaction.update(userRef, userDataToUpdate);

              groupDataToUpdate['participants_status.$userId.unread_message_count'] = FieldValue.increment(1);
            }
          }

          // Updating fetched group_participants participant list
          for (var doc in grpParticipantsRes.docs) {
            Map<String, dynamic> groupParticipant =
                doc.data() as Map<String, dynamic>;

            Map<String, dynamic> oldGroupParticipantDataToUpdate = {
              'participants': sortedParticipantIds,
              'updated_at': timeStamp,
              'source_last_updated': platform,
              'source_last_updated_info': sourceInfo,
            };

            if (groupParticipant['uid'] != currentUserId &&
                !participantIds.contains(groupParticipant['uid'])) {
              oldGroupParticipantDataToUpdate['unread_message_count'] =
                  FieldValue.increment(1);
            }

            transaction.update(doc.reference, oldGroupParticipantDataToUpdate);
          }

          // Updating group participant list and participant status in group collection
          transaction.update(groupRef, groupDataToUpdate);

          return Future(() => null);
        });
      });
    });
  }


}
