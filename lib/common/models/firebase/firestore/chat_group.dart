import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/firebase/firestore/participants_status.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/firestore/streams/groups/data.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/constants/chats.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/user_roles.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';

class ChatGroupModel {
  String? groupId;
  late String companyId;
  late String createdBy;
  late String jobId;
  late int messageCount;
  late List<String> participants;
  late Map<String, ParticipantsStatusModel> participantsStatus;
  late String recentMessage;
  DocumentReference? recentMessageRef;
  late Timestamp createdAt;
  late Timestamp updatedAt;
  String? groupTitle;
  int? unreadMessageCount;
  JobModel? job;
  DocumentSnapshot? snapshot;
  bool? isGroup;
  String? groupProfileText;
  String? profileImage;
  List<UserLimitedModel>? activeParticipants;
  List<UserLimitedModel>? inActiveParticipants;
  ParticipantsStatusModel? myGroupMessageDetails;
  UserLimitedModel? sender;
  String? phoneNumber;
  String? smsStatus;
  String? apiCreatedAt;
  bool? isAutomated;

  ChatGroupModel(
      {this.groupId,
      required this.companyId,
      required this.createdBy,
      this.jobId = "",
      this.messageCount = 0,
      required this.participants,
      required this.participantsStatus,
      this.recentMessage = "",
      this.recentMessageRef,
      required this.createdAt,
      required this.updatedAt,
      this.activeParticipants,
      this.groupTitle,
      this.unreadMessageCount,
      this.job,
      this.snapshot,
      this.isGroup = false,
      this.groupProfileText,
      this.profileImage,
      required this.myGroupMessageDetails,
      this.isAutomated});

  factory ChatGroupModel.addPendingData(ChatGroupModel group) {
    final loggedInUserId = AuthService.userDetails?.id.toString();

    if (group.activeParticipants == null) {
      group.activeParticipants = [];
      group.inActiveParticipants = [];
      for (String userId in group.participants) {
        final user = GroupsData.allUsers[userId];

        if (user == null) continue;
        if (GroupsData.allUsers[userId] != null) {
          user.active = group.participantsStatus[userId]?.deletedAt == null;
          user.active!
              ? group.activeParticipants!.add(user)
              : group.inActiveParticipants!.add(user);
        }
        if ((userId != loggedInUserId && group.groupProfileText == null) ||
            group.participants.length == 1) {
          group.groupProfileText =
              "${user.firstName[0]}${user.lastName?[0] ?? ''}";
          group.profileImage = user.profilePic;
          // Check if this is a system user and use Leap System instead
          if (user.groupId == UserGroupIdConstants.anonymous) {
            group.groupTitle = 'leap_system'.tr;
          } else {
            group.groupTitle = "${user.firstName} ${user.lastName ?? ""}";
          }
        }
      }

      if (group.participants.length > 2 || group.groupTitle == null) {
        List<String>? groupUsers = group.activeParticipants
            ?.map((e) => "${e.firstName} ${e.lastName ?? ""}")
            .toList();
        groupUsers?.sort();
        group.groupTitle = groupUsers?.join(", ");
      }
    }

    if (group.jobId.isNotEmpty) {
      group.job = GroupsData.allJobs[group.jobId];
    }

    group.isGroup = group.participants.length > 2;

    return group;
  }

  ChatGroupModel.fromJson(
      Map<String, dynamic> data, DocumentSnapshot documentSnapshot) {
    groupId = documentSnapshot.id.toString();
    companyId = data['company_id'];
    createdBy = data['created_by'];
    jobId = data['job_id'];
    messageCount = data['message_count'] ?? 0;
    participants = data['participants'].cast<String>();
    isAutomated = data['type'] == ChatsConstants.smsTypeAutomated;
    if (data['participants'] != null && data['participants_status'] != null) {
      participants = [];

      final tempParticipants =
          (data['participants_status'] as Map<dynamic, dynamic>)
              .keys
              .map((e) => e.toString())
              .toList();
      tempParticipants.sort();
      participants.addAll(tempParticipants);

      participantsStatus = {};
      for (var participantId in participants) {
        if (participantId == AuthService.userDetails?.id.toString()) {
          unreadMessageCount = data['participants_status']?[participantId]
                  ?['unread_message_count'] ??
              0;
          myGroupMessageDetails = ParticipantsStatusModel.fromJson(
              data['participants_status'][participantId]);
        }

        final tempParticipantData = ParticipantsStatusModel.fromJson(
            data['participants_status'][participantId]);

        participantsStatus.putIfAbsent(
            participantId.toString(), () => tempParticipantData);
      }
    }
    snapshot = documentSnapshot;
    recentMessage = data['recent_message'] ?? '-';
    recentMessageRef = data['recent_message_ref'];
    createdAt = data['created_at'];
    updatedAt = data['updated_at'];
  }

  ChatGroupModel.fromApiJson(Map<String, dynamic> json, {
    bool canUsePhoneAsTitle = false,
    bool includeUnreadCount = true,
  }) {
    final loggedInUserId = AuthService.userDetails?.id;

    groupId = json['thread_id'];
    companyId = "";
    createdBy = "";
    messageCount = json['unread_message_count'] ?? 0;
    recentMessage = json['content'] ?? "";
    isAutomated = json['type'] == ChatsConstants.smsTypeAutomated;
    if (includeUnreadCount) unreadMessageCount = json['unread_message_count'] ?? 0;

    if (json['job'] != null) {
      job = JobModel.fromJson(json['job']);
      jobId = job!.id.toString();
    } else {
      jobId = '';
    }

    if (json['participants']?['data'] != null) {
      activeParticipants = [];
      participants = [];
      json['participants']?['data']?.forEach((dynamic user) {
        activeParticipants?.add(UserLimitedModel.fromJson(user));
      });
    }

    participants =
        activeParticipants?.map((e) => e.id.toString()).toList() ?? [];

    phoneNumber = Helper.removeCountryCodes(json['phone_number']?.toString() ?? "");
    smsStatus = json['sms_status']?.toString();

    inActiveParticipants = [];
    for (UserLimitedModel? user in activeParticipants ?? []) {
      if (user == null) continue;
      if ((user.id != loggedInUserId && groupProfileText == null) ||
          participants.length == 1) {
        groupProfileText = user.intial ?? '';
        profileImage = user.profilePic;
        // Check if this is a system user and use Leap System instead
        if (user.groupId == UserGroupIdConstants.anonymous) {
          groupTitle = 'leap_system'.tr;
        } else {
          groupTitle = "${user.firstName} ${user.lastName ?? ""}";
        }
      }
    }

    if (participants.length > 2 || groupTitle == null) {
      List<String>? groupUsers = activeParticipants
          ?.map((e) => "${e.firstName} ${e.lastName ?? ""}")
          .toList();
      groupUsers?.sort();
      groupTitle = groupUsers?.join(", ");
    }

    isGroup = participants.length > 2;
    participantsStatus = {};
    createdAt = Timestamp.now();
    apiCreatedAt = json['created_at'];
    if (apiCreatedAt != null) {
      updatedAt = Timestamp.fromDate(DateTime.parse(DateTimeHelper.formatDate(apiCreatedAt!, DateFormatConstants.dateTimeServerFormat)));
    }
    myGroupMessageDetails = ParticipantsStatusModel(
      unreadMessageCount: unreadMessageCount,
      lastReadMessage: '',
      createdAt: createdAt,
      createdBy: createdBy,
    );

    if(json['sender'] != null) {
      sender = UserLimitedModel.fromJson(json['sender']);
    }

    if(canUsePhoneAsTitle) {
      if(participants.length != 2 && phoneNumber != null) {
        groupTitle = PhoneMasking.maskPhoneNumber(phoneNumber!);
      }
    }

  }
}
