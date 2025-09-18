
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobprogress/common/models/firebase/firestore/group_participant.dart';
import 'package:jobprogress/common/providers/firebase/firestore/reference.dart';
import 'package:jobprogress/common/services/firestore/streams/groups/params.dart';
import 'package:jobprogress/core/constants/firebase/firestore_keys.dart';

class FilteredGroupsRepo {

  static Future<Map<String, dynamic>> getGroupIdsFromUserIds({
    List<String>? userIds,
    DocumentSnapshot? afterDoc,
    bool isUnreadMessageFilterApplied = false,
  }) async {

    try {
      String companyId = GroupsRequestParams().companyId.toString();
      String userId = GroupsRequestParams().userId.toString();

      Query<GroupParticipantModel> query = ReferenceProvider
          .groupParticipantsRef
          .where(FirestoreKeys.companyId, isEqualTo: companyId)
          .where(FirestoreKeys.uid, isEqualTo: userId)
          .where(FirestoreKeys.deletedAt, isEqualTo: '')
          .withConverter(
          fromFirestore: (snapshot, _) => GroupParticipantModel.fromSnapShot(snapshot),
          toFirestore: (_, __) => {});

      if(userIds?.isNotEmpty ?? false) {
        query = query.where(FirestoreKeys.participants, arrayContainsAny: userIds);
      }

      if(isUnreadMessageFilterApplied) {
        query = query
            .where(FirestoreKeys.unreadMessageCount, isGreaterThan: 0)
            .orderBy(FirestoreKeys.unreadMessageCount, descending: true);
      } else {
        query = query.orderBy(FirestoreKeys.updatedAt, descending: true);
      }

      if(afterDoc != null) {
        query = query.startAfterDocument(afterDoc);
      }

      query = query
          .limit(GroupsRequestParams.instance.defaultPaginationLimit);


      QuerySnapshot<GroupParticipantModel> result = await query.get();

      List<String> groupIds = result.docs.map((e) => e.data().groupId).toList();

      List<String> uniqueGroupIds = groupIds.toSet().toList();

      return {
        'groups_ids' : uniqueGroupIds,
        'after_doc' : result.docs.isEmpty ? null : result.docs.last
      };
    } catch(e) {
      rethrow;
    }
  }
}