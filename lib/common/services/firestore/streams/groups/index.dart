import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart' as db;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/chats.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/common/extensions/get_navigation/extension.dart';
import 'package:jobprogress/common/models/firebase/firestore/chat_group.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/providers/firebase/firestore/reference.dart';
import 'package:jobprogress/common/providers/firebase/realtime_db.dart';
import 'package:jobprogress/common/repositories/chats.dart';
import 'package:jobprogress/common/repositories/firebase/firestore/filtered_groups.dart';
import 'package:jobprogress/common/repositories/firebase/firestore/groups.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/firestore/auth/index.dart';
import 'package:jobprogress/common/services/firestore/db_helper/local_db_helper.dart';
import 'package:jobprogress/common/services/firestore/streams/groups/data.dart';
import 'package:jobprogress/common/services/firestore/streams/groups/params.dart';
import 'package:jobprogress/core/constants/firebase/firebase_paths.dart';
import 'package:jobprogress/core/constants/firebase/firebase_realtime_keys.dart';
import 'package:jobprogress/core/constants/firebase/firestore_keys.dart';
import 'package:jobprogress/core/constants/chats.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';
import 'package:jobprogress/core/utils/firebase/firestore.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/from_firebase/controller.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';

class GroupsService {

  String? jobId; // used to apply job filter
  String? groupId; // used for loading group data from id
  bool loadOneGroupOnly; // used to load only one groups data at a time
  String? smsType; // used to filter SMS type for texts
  Function({bool clearData}) onMessagesLoaded; // callback to controller when message is loaded
  VoidCallback onTextsLoaded; // callback to controller when texts is loaded
  GroupsData groupsData = GroupsData(); // used to setup groups data
  GroupsListingType type;
  int currentMessagePage = 0;
  int currentTextsPage = 0;
  StreamSubscription<db.DatabaseEvent>? apiMessageStream;
  StreamSubscription<db.DatabaseEvent>? apiTextsStream;
  JobModel? jobModel;
  bool doLoadTextsFirst = false;
  ChatGroupModel? selectedGroupData;

  /// GroupsService is a constructor for initializing service
  GroupsService({
    this.jobId,
    this.groupId,
    this.type = GroupsListingType.fireStoreMessages,
    this.loadOneGroupOnly = false,
    required this.onMessagesLoaded,
    required this.onTextsLoaded,
    this.doLoadTextsFirst = false,
  }) {

      groupsData.setJobId(jobId); // setting jobId if not null
      // loading users from local db
      FirestoreLocalDBHelper.getAllUsers().then((value) async {

        GroupsData.setUsers(value); // setting up users fetched from local db

        if(!doLoadTextsFirst) {
          typeToInitialLoad();
        }
      });
  }

  void typeToInitialLoad() {

    if(groups.isNotEmpty) return;

    try {
      switch (type) {
        case GroupsListingType.fireStoreMessages:
          loadDataFromFirestore();
          break;

        case GroupsListingType.apiMessages:
          setUpApiMessageStream();
          break;

        case GroupsListingType.apiTexts:
          setUpApiTextsStream();
          break;
      }
    } catch (e) {
      rethrow;
    }

  }

  void typeToLoadGroups({
    bool clearData = false,
    List<String>? selectedUserIds,
  }) {

    switch(type) {
      case GroupsListingType.fireStoreMessages:
        loadGroups(
            selectedUserIds: selectedUserIds
        );
        break;

      default:
        loadGroupsFromApi(
            clearData: true,
            selectedUserIds: selectedUserIds
        );

    }
  }

  void typeToLoadMoreGroups({List<String>? filterUserIds}) {

    switch(type) {
      case GroupsListingType.fireStoreMessages:
        loadGroups(
            forLoadMore: true,
            selectedUserIds: filterUserIds
        );
        break;

      case GroupsListingType.apiMessages:
        loadGroupsFromApi(
          selectedUserIds: filterUserIds,
        );
        break;

      case GroupsListingType.apiTexts:
        loadTextsFromApi();
        break;

    }
  }

  Future<void> setUpApiMessageStream() async {

    if(groups.isNotEmpty) return;

    if(jobModel == null && jobId != null) {
      await loadJobFromServer();
    }

    apiMessageStream = RealtimeDBProvider.createLocalStream(
        path: FirebasePaths(
          AuthService.userDetails!.companyDetails!.id.toString(),
          AuthService.userDetails!.id.toString(),
        ).countBasePath + FirebaseRealtimeKeys.messageUnread,
        onValueUpdate: () {},
        onData: (data) {
          loadGroupsFromApi(clearData: true);
        }
    );
  }

  Future<void> setUpApiTextsStream() async {

    if(texts.isNotEmpty) return;

    if(jobModel == null && jobId != null) {
      await loadJobFromServer();
    }

    apiTextsStream = RealtimeDBProvider.createLocalStream(
        path: FirebasePaths(
          AuthService.userDetails!.companyDetails!.id.toString(),
          AuthService.userDetails!.id.toString(),
        ).countBasePath + FirebaseRealtimeKeys.textMessageUnread,
        onValueUpdate: () {},
        onData: (data) {
          loadTextsFromApi(clearData: true);
        }
    );
  }

  /// LOADING DATA FROM FIRE-STORE
  Future<void> loadDataFromFirestore() async {
    await FirebaseAuthService.login();
    loadOneGroupOnly
        ? loadOneGroup(groupId)
        : loadGroups(); // loading groups after reading DB
  }

  /// used to close cached firebase streams
  static List<StreamSubscription<QuerySnapshot<dynamic>>> streamsList = [];

  /// canShowLoadMore helps in checking whether load-more can be performed or not
  bool get canShowMessageLoadMore =>
      groupsData.groupsList.length < groupsData.totalGroups;

  /// canShowLoadMore helps in checking whether load-more can be performed or not
  bool get canShowTextsLoadMore =>
      groupsData.textsList.length < groupsData.totalTexts;

  /// groups used to get list of loaded groups
  List<ChatGroupModel> get groups => groupsData.groupsList;

  /// groups used to get list of loaded texts
  List<ChatGroupModel> get texts => groupsData.textsList;

  /// canShowFilterIcon helps is hide/show filter icon
  bool get canShowFilterIcon => jobId == null && type != GroupsListingType.apiTexts;

  /// doShowCount helps in hide/show groups count
  bool get doShowCount => (!groupsData.isForFilteredList && jobId == null) || groupsData.isUnreadMessageCountFilterApplied;

  /// doShowFilterIcon helps is show/hide filter icon
  bool get doShowSortByIcon => jobId == null;

  /// doForceUpdateTotalUnreadCount helps in deciding whether force count update can be performed or not
  bool get doForceUpdateTotalUnreadCount => (!groupsData.isForFilteredList && jobId == null)
      && !canShowMessageLoadMore
      && type == GroupsListingType.fireStoreMessages
      && !loadOneGroupOnly
      && selectedGroupData == null;

  /// groupsStreamSubscription stores list of stream subscription to close whenever needed
  List<StreamSubscription<QuerySnapshot<dynamic>>> groupsStreamSubscription = [];

  /// getGroupQuery() : gives streamed query to load data from firebase
  Stream<QuerySnapshot> getGroupQuery({List<String>? chunks}) {

    Query query = ReferenceProvider.groupsRef; // setting up root reference

    DocumentSnapshot? afterDoc = groupsData.groupsList.isNotEmpty
        ? groupsData.groupsList[groupsData.groupsList.length - 1].snapshot!
        : null; // setting up after doc to perform load more

    if (groupsData.isForFilteredList) {
      // adding chunks to query for filtered list
      query = query.where(FieldPath.documentId, whereIn: chunks);
    } else {

      String companyId = GroupsRequestParams.instance.companyId.toString();
      String userId = GroupsRequestParams.instance.userId.toString();

      query = query
          .where(FirestoreKeys.companyId, isEqualTo: companyId);

      if(groupId != null) {
        query = query.where(FieldPath.documentId, isEqualTo: groupId);
      } else {
        query = query.orderBy(GroupsRequestParams.instance.defaultSortBy, descending: true);
      }

      if (groupsData.jobId != null) {
        query = query.where(FirestoreKeys.jobId, isEqualTo: groupsData.jobId); // adding job filter if jobId available
      } else {
        query = query.where(FirestoreKeys.participants, arrayContains: userId);
    }

      if (afterDoc != null) {
        query = query.startAfterDocument(afterDoc); // adding last doc to query after
      }
    }

    return query
        .limit(groupId != null ? 1 : GroupsRequestParams.instance.defaultPaginationLimit)
        .snapshots(); // returning queried stream
  }

  /// loadGroups(): creates stream in case of fire-store and and load data
  Future<void> loadGroups({
    List<String>? selectedUserIds,
    bool forLoadMore = false,
    bool clearDataAlso = false,
  }) async {

    List<String> chunks = []; // used to store chunks

    // in case request is not for load more closing previous streams, clearing data and loading new data
    if (!forLoadMore) {
      // checking for filter list
      groupsData.isForFilteredList =
          (selectedUserIds != null && selectedUserIds.isNotEmpty) || groupsData.isUnreadMessageCountFilterApplied;
      groupsData.clearGroups();
      await closeStreams(clearDataAlso: clearDataAlso); // closing all streams
    }

    // in case of filtered list
    if (groupsData.isForFilteredList) {
      await setGroupIdChunks(selectedUserIds); // loading chunks
      chunks = groupsData.getGroupChunkToLoad(); // setting up chunks list
      // in case chunks are empty (nothing to load), stopping load-more request
      if (chunks.isEmpty) {
        onMessagesLoaded();
        return;
      }
    }

    Stream<QuerySnapshot> queryStream = getGroupQuery(chunks: chunks); // loading query
    // setting up stream
    final streamSubscription = queryStream.listen((QuerySnapshot snapshot) async {
      await onDataReceived(snapshot); // updating data when retrieved
    });

    // adding stream to subscription lists to close streams when needed
    groupsStreamSubscription.add(streamSubscription);
    GroupsService.streamsList.add(streamSubscription);
  }

  /// loadOneGroup(): loads data for a single group
  Future<void> loadOneGroup(String? groupId) async {

    if(groupId == null) return;

    Stream<QuerySnapshot> queryStream = getGroupQuery(); // loading query
    // setting up stream
    final streamSubscription = queryStream.listen((QuerySnapshot snapshot) async {
      await onDataReceived(snapshot); // updating data when retrieved
    });

    // adding stream to subscription lists to close streams when needed
    groupsStreamSubscription.add(streamSubscription);
    GroupsService.streamsList.add(streamSubscription);
  }

  /// onDataReceived(): parse data, sets up required data (users, jobs) and sets up groups list
  Future<void> onDataReceived(QuerySnapshot snapshots) async {

    try {
      Map<String, List<String>> result = groupsData.setUpGroups(snapshots,
          selectedGroupId: selectedGroupData?.groupId,
          onSelectedGroupRemoved: () {
        Get.splitPop();
      }); // parsing received data

      final users = await GroupsRepo.getParticipantsData(result['participants'] ?? []); // loading users
      GroupsData.setUsers(users); // setting up users

      final jobs = await GroupsRepo.getJobsData(result['jobs'] ?? []); // loading jobs
      GroupsData.setJobs(jobs); // setting up jobs

      groupsData.updateGroupsWithUsersAndJob(); // updating groups with users and jobs

      onMessagesLoaded(); // callback to controller
    } catch (e) {
      rethrow;
    } finally {
      onMessagesLoaded(); // callback to controller
      forceUpdateUnreadMessageCount();
    }
  }

  /// setGroupChunks() : used to load group chunks for filtered list
  Future<void> setGroupIdChunks(List<String>? selectedUserIds) async {
    try {
      final result = await FilteredGroupsRepo.getGroupIdsFromUserIds(
        afterDoc: groupsData.afterDocForFilterList,
        isUnreadMessageFilterApplied: groupsData.isUnreadMessageCountFilterApplied,
        userIds: selectedUserIds
      );
      final chunks = FirestoreHelpers.getChunks(result['groups_ids']);
      groupsData.setAfterDoc(result['after_doc']);
      groupsData.setFilteredGroupChunks(chunks);
    } catch (e) {
      rethrow;
    }
  }

  /// closeStream(): used to close streams
  Future<void> closeStreams({bool clearDataAlso = true}) async {
    if (clearDataAlso) {
      groupsData.clearData();
    }
    for (var stream in groupsStreamSubscription) {
      await stream.cancel();
    }

    groupsStreamSubscription.clear();
    await apiTextsStream?.cancel();
    await apiMessageStream?.cancel();
  }

  static Future<void> closeCachedStreams() async {
    for (var stream in GroupsService.streamsList) {
      await stream.cancel();
    }
    streamsList.clear();
  }

  /// applySortFilter(): will filter list sort by
  Future<void> applySortFilter(String val, {List<String>? userIds}) async {

    if(val == groupsData.groupFilter) return; // if new selected filter is same as applied filter doing nothing

    groupsData.setGroupSortFilter(val); // setting up filter
    groupsData.clearGroups(); // clearing old groups data
    await closeStreams(clearDataAlso: false); // closing previous streams

    // loading new groups as of filters
    switch (type) {
      case GroupsListingType.fireStoreMessages:
        loadGroups(
          selectedUserIds: userIds,
        );
        break;

      default:
        loadGroupsFromApi(
          clearData: true,
          selectedUserIds: userIds,
        );
    }
  }

  /// LOADING DATA FROM API
  Future<void> loadGroupsFromApi({List<String>? selectedUserIds, bool clearData = false}) async {

    try{

      if(clearData) {
        currentMessagePage = 0;
      }

      currentMessagePage++;

      bool isJobAvailable = jobModel != null;

      Map<String, dynamic> params = {
        "includes[0]": 'participants',
        "includes[1]": 'job',
        "page": currentMessagePage,
        "limit": PaginationConstants.pageLimit,
        "type": 'SYSTEM_MESSAGE',
        "unread_thread": groupsData.isUnreadMessageCountFilterApplied ? 1 : 0,
        if(isJobAvailable) ...{
          "all_job_messages": 1,
          "customer_all_user_messages": 0,
          "job_id": jobId,
        },
        if(selectedUserIds != null)
          for(int i=0; i<selectedUserIds.length; i++)
            "participants[$i]" : selectedUserIds[i],
        if(loadOneGroupOnly)
          "thread_id" : groupId!
      };

      Map<String, dynamic> response = await ApiChatsRepo.fetchThreads(params, includeUnreadCount: !isJobAvailable);

      List<ChatGroupModel> groups = response['groups'];

      if(clearData) {
        groupsData.clearGroups();
      }

      groupsData.groupsList.addAll(groups);

      PaginationModel pagination = PaginationModel.fromJson(response['pagination']);
      groupsData.totalGroups = pagination.total ?? 0;

      onMessagesLoaded.call(clearData: clearData);

    } catch(e) {
     rethrow;
    }
  }

  Future<void> loadTextsFromApi({bool clearData = false}) async {

    try{

      if(clearData) {
        currentTextsPage = 0;
        groupsData.clearTexts();
      }

      currentTextsPage++;

      Map<String, dynamic> params = {
        "includes[0]": 'participants',
        "includes[1]": 'job',
        "page": currentTextsPage,
        "limit": PaginationConstants.pageLimit,
        if(jobModel != null) ...{
          "all_job_messages": 0,
          "customer_all_user_messages": 1,
          "customer_id": jobModel?.customerId,
        }
      };

      // Add type filter based on smsType variable
      if (smsType != null) {
        if (smsType == ChatsConstants.smsTypeAll) {
          params["type[]"] = [ChatsConstants.smsTypeConversations, ChatsConstants.smsTypeAutomated];
        } else {
          params["type"] = smsType;
        }
      }

      Map<String, dynamic> response = await ApiChatsRepo.fetchThreads(params, canUsePhoneAsTitle: true);

      List<ChatGroupModel> groups = response['groups'];

      groupsData.textsList.addAll(groups);

      PaginationModel pagination = PaginationModel.fromJson(response['pagination']);
      groupsData.totalTexts = pagination.total ?? 0;

      onTextsLoaded();

    } catch(e) {
      onTextsLoaded();
      rethrow;
    }
  }

  ChatGroupModel? getGroupDataFromId(String id) {

    ChatGroupModel? data;

    switch (type) {
      case GroupsListingType.fireStoreMessages:
        data = groupsData.allGroups[id];
        break;

      case GroupsListingType.apiMessages:
        data = groupsData.groupsList.firstWhereOrNull((element) => element.groupId == id);
        break;

      case GroupsListingType.apiTexts:
        data = groupsData.textsList.firstWhereOrNull((element) => element.groupId == id);
        break;
    }

    return data;
  }

  void insertGroupAtTopOfList(ChatGroupModel data, String message) {
    data.recentMessage = message;
    data.createdAt = Timestamp.now();
    data.updatedAt = Timestamp.now();
    data.unreadMessageCount = 0;

    switch (type) {
      case GroupsListingType.fireStoreMessages:
      case GroupsListingType.apiMessages:
        groups.removeWhere((group) => group.groupId == data.groupId);
        groups.insert(0, data);
        break;

      case GroupsListingType.apiTexts:
        texts.removeWhere((group) => group.groupId == data.groupId);
        texts.insert(0, data);
        break;
    }
  }

  Future<void> typeToMarkGroupAsUnRead(int index) async {

    showJPLoader(
        msg: 'marking_group_as_unread'.tr
    );

    try {
      switch (type) {
        case GroupsListingType.fireStoreMessages:
          String groupId = groups[index].groupId!;
          await GroupsRepo.markGroupAsUnRead(
            groupId: groupId,
          );
          groups[index].unreadMessageCount = 1;
          onMessagesLoaded();
          break;

        case GroupsListingType.apiMessages:
          String groupId = groups[index].groupId!;
          await markApiMessageAsUnRead(groupId);
          groups[index].unreadMessageCount = 1;
          onMessagesLoaded();
          break;

        case GroupsListingType.apiTexts:
          String groupId = texts[index].groupId!;
          await markApiMessageAsUnRead(groupId);
          texts[index].unreadMessageCount = 1;
          onTextsLoaded();
          break;
      }

      Helper.showToastMessage('mark_as_unread'.tr);

    } catch (e) {
      rethrow;
    }

  }

  Future<void> typeToMarkGroupAsRead(int index) async {

    showJPLoader(
        msg: 'marking_group_as_read'.tr
    );

    try {
      switch (type) {
        case GroupsListingType.fireStoreMessages:
          String groupId = groups[index].groupId!;
          await GroupsRepo.markGroupAsRead(
            groupId: groupId,
          );
          groups[index].unreadMessageCount = 0;
          onMessagesLoaded();
          break;

        case GroupsListingType.apiMessages:
          String groupId = groups[index].groupId!;
          await markApiMessageAsRead(groupId);
          groups[index].unreadMessageCount = 0;
          onMessagesLoaded();
          break;

        case GroupsListingType.apiTexts:
          String groupId = texts[index].groupId!;
          await markApiMessageAsRead(groupId);
          texts[index].unreadMessageCount = 0;
          onTextsLoaded();
          break;
      }
      Helper.showToastMessage('mark_as_read'.tr);

    } catch (e) {
      Helper.showToastMessage('something_went_wrong'.tr);
      rethrow;
    }
  }

  Future<void> markApiMessageAsRead(String groupId) async {
    try {
      Map<String, dynamic> params = {
        'thread_id': groupId
      };
      await ApiChatsRepo.markAsRead(params);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markApiMessageAsUnRead(String groupId) async {
    try {
      Map<String, dynamic> params = {
        'id': groupId
      };
      await ApiChatsRepo.markAsUnread(params);
    } catch (e) {
      rethrow;
    }
  }

  int? typeToUnreadMessageCount(int index) {

    switch (type) {
      case GroupsListingType.fireStoreMessages:
        if(groups.isEmpty || groups.length < index) {
          Helper.showToastMessage('please_wait_while_data_is_refreshing'.tr);
          return null;
        }
        return groups[index].unreadMessageCount ?? 0;

      case GroupsListingType.apiMessages:
        if(groups.isEmpty || groups.length < index) {
          Helper.showToastMessage('please_wait_while_data_is_refreshing'.tr);
          return null;
        }
        return groups[index].unreadMessageCount == 0 ? 0 : null;

      case GroupsListingType.apiTexts:
        if(texts.isEmpty || texts.length < index) {
          Helper.showToastMessage('please_wait_while_data_is_refreshing'.tr);
          return null;
        }
        return texts[index].unreadMessageCount == 0 ? 0 : null;
    }
  }

  Future<void> loadJobFromServer() async {

    try {

      Map<String, dynamic> params = {
        'id': int.tryParse(jobId!) ?? -1,
        'includes[0]': 'customer',
        'includes[1]': 'flags.color',
      };

      final response = await JobRepository.fetchJob(int.tryParse(jobId!) ?? -1, params: params);

      jobModel = response['job'];

    } catch (e) {
      rethrow;
    }

  }

  /// setSmsType() : setter function to update SMS type filter
  void setSmsType(String? type) {
    smsType = type;
  }

  /// forceUpdateUnreadMessageCount() : helps in maintaining concurrency of unread thread message counts with total unread counts
  /// Check will execute under following circumstances
  /// 1. When all threads are loaded and count mismatch
  /// 2. When new message arrives and count mismatch
  Future<void> forceUpdateUnreadMessageCount() async {

    if(doForceUpdateTotalUnreadCount) {

      final controller = Get.find<FromFirebaseController>();

      // additional delay for firebase to update user counts
      await Future<void>.delayed(const Duration(milliseconds: 500));

      final actualUnreadCount = groupsData.getTotalUnreadCountOfThreads();
      final currentUnreadCount = controller.valuesMapFirestore[FireStoreKeyType.unreadMessageCount] ?? 0;


      if(currentUnreadCount != actualUnreadCount) {
        await GroupsRepo.forceUpdateTotalUnreadCount(newCount: actualUnreadCount);
      }
    }
  }
}
