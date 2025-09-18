import 'package:cloud_firestore/cloud_firestore.dart';

class GroupParticipantModel {
  String? companyId;
  String? createdBy;
  String? deletedAt;
  late String groupId;
  String? jobId;
  List<String>? participants;
  String? source;
  String? sourceInfo;
  String? sourceLastUpdated;
  String? sourceLastUpdatedInfo;
  String? uid;
  int? unreadMessageCount;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  GroupParticipantModel({
    required this.groupId,
    this.companyId,
    this.createdAt,
    this.createdBy,
    this.deletedAt,
    this.jobId,
    this.participants,
    this.source,
    this.sourceInfo,
    this.sourceLastUpdated,
    this.sourceLastUpdatedInfo,
    this.uid,
    this.unreadMessageCount,
    this.updatedAt,
  });

  GroupParticipantModel.fromSnapShot(DocumentSnapshot snapshot) {

    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;

    companyId = json['company_id'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    deletedAt = json['deleted_at'];
    groupId = json['group_id'];
    jobId = json['job_id'];
    participants = json['participants'].cast<String>();
    source = json['source'];
    sourceInfo = json['source_info'];
    sourceLastUpdated = json['source_last_updated'];
    sourceLastUpdatedInfo = json['source_last_updated_info'];
    uid = json['uid'];
    unreadMessageCount = json['unread_message_count'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['company_id'] = companyId;
    data['created_at'] = createdAt;
    data['created_by'] = createdBy;
    data['deleted_at'] = deletedAt;
    data['group_id'] = groupId;
    data['job_id'] = jobId;
    data['participants'] = participants;
    data['source'] = source;
    data['source_info'] = sourceInfo;
    data['source_last_updated'] = sourceLastUpdated;
    data['source_last_updated_info'] = sourceLastUpdatedInfo;
    data['uid'] = uid;
    data['unread_message_count'] = unreadMessageCount;
    data['updated_at'] = updatedAt;
    return data;
  }
}
