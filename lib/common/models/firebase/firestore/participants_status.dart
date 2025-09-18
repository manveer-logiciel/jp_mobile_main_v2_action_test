
import 'package:cloud_firestore/cloud_firestore.dart';

class ParticipantsStatusModel {

  late String createdBy;
  String? lastReadMessage;
  int? unreadMessageCount;
  Timestamp? deletedAt;
  String? deletedBy;
  late Timestamp createdAt;

  ParticipantsStatusModel({
    required this.createdAt,
    required this.createdBy,
    this.lastReadMessage = '',
    this.unreadMessageCount = 0,
  });

  ParticipantsStatusModel.fromJson(Map<String, dynamic> data) {
    deletedAt = data['deleted_at'];
    deletedBy = data['deleted_by'];
    createdBy = data['created_by'];
    lastReadMessage = data['last_read_message'];
    unreadMessageCount = data['unread_message_count'] ?? 0;
    createdAt = data['created_at'];
  }

  Map<String, dynamic> toJson({bool removeDeleteEntries = true}) {
    final dataToReturn = <String, dynamic>{};
    if(deletedAt != null && !removeDeleteEntries) {
      dataToReturn['deleted_at'] = deletedAt;
    }
    if(deletedBy != null && !removeDeleteEntries) {
      dataToReturn['deleted_by'] = deletedBy;
    }
    dataToReturn['last_read_message'] = lastReadMessage ?? '';
    dataToReturn['unread_message_count'] = unreadMessageCount;
    dataToReturn['created_by'] = createdBy;
    dataToReturn['created_at'] = createdAt;

    return dataToReturn;
  }


}