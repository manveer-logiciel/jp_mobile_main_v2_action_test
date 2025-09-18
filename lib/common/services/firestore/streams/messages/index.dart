import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/chats.dart';
import 'package:jobprogress/common/models/firebase/firestore/chat_group.dart';
import 'package:jobprogress/common/models/firebase/firestore/group_message.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/providers/firebase/firestore/reference.dart';
import 'package:jobprogress/common/repositories/chats.dart';
import 'package:jobprogress/common/repositories/firebase/firestore/group_messages.dart';
import 'package:jobprogress/common/repositories/firebase/firestore/groups.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/firestore/streams/groups/data.dart';
import 'package:jobprogress/common/services/firestore/streams/groups/index.dart';
import 'package:jobprogress/common/services/firestore/streams/messages/params.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/common/services/send_as_email.dart';
import 'package:jobprogress/core/constants/firebase/firestore_keys.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';
import 'package:jobprogress/core/utils/firebase/firestore.dart';

import 'participants.dart';

class MessageService {

  /// unreadMessageIndex used to store index of message before which unread message count
  /// separator is displayed, default value is null. Useful in removing unread message
  /// separator, instead of iterating whole list
  int? unreadMessageIndex;

  /// groupId is the Id of current group, in-case only group id is available
  /// group data will be loaded from fire-store first
  String? groupId;

  /// groupData stores group data coming from groups listing page
  ChatGroupModel? groupData;

  /// pendingCountsToLoadMore helps in displaying and storing to be
  /// displayed on [scroll to bottom widget]
  int pendingCountsToLoadMore = 0;

  /// canShowHistory helps in checking whether history load can be performed or not
  bool canShowHistory = false;

  /// canShowLoadMore helps in checking whether history load can be performed or not
  bool canShowLoadMore = false;

  /// receivedNewMessage helps to manage state when new message arrives
  /// (eg. scrolling to message or displaying count) on [scroll to bottom widget]
  bool receivedNewMessage = false;

  /// streamSubscription used to cancel stream listening to latest message
  StreamSubscription<QuerySnapshot>? streamSubscription;

  /// onDataReceived helps in updating ui when data is received
  VoidCallback onDataReceived;

  /// messagesList used to save message list
  List<GroupMessageModel> messagesList = [];

  /// historyMessagesList used to save history message list
  List<GroupMessageModel> historyMessagesList = [];

  /// groupsService helps in loading group data in not available
  GroupsService? groupsService;

  /// isMessageFieldEnabled helps in enabling disabling message field
  bool isActiveParticipant = false;

  /// participantsService helps in handling participant related actions
  late ParticipantsService participantsService;

  /// currentPage helps in performing load history in case of api messaging
  int currentPage = 1;

  /// messagesSentByMeCount decides number of messages to be refreshed
  int messagesSentByMeCount = 0;

  /// used to differentiate api calls
  GroupsListingType type;

  bool isSendACopyAsEmailEnabled = false;

  // constructor will setUp service to load messages
  MessageService({
    this.groupData,
    this.groupId,
    required this.onDataReceived,
    required this.type
  }) {
    setGroupData();
  }

  /// loadFromUnreadMessage helps in checking whether messages will be loaded from
  /// unread message & load-more action will be performed
  bool get loadFromUnreadMessage =>
      (groupData?.myGroupMessageDetails?.unreadMessageCount ?? 0) >
      GroupsMessageRequestParams.instance.defaultPaginationLimit;

  /// showUnreadMessageBadge helps is displaying unread message separator
  bool get showUnreadMessageSeparator =>
      (groupData?.myGroupMessageDetails?.unreadMessageCount ?? 0) > 0;

  /// isApiList used to differentiate whether to load data from fire-store or server
  bool get isApiList =>
      type != GroupsListingType.fireStoreMessages;

  /// setGroupData(): will provide group data to use for loading messages
  void setGroupData() async {

    try {
      if (groupData != null) {
        onGroupSetUpDone();
        typeToLoadMessages();
      } else if(groupId == null) {
        // duration added to give time to controller for set-up
        await Future<void>.delayed(const Duration(milliseconds: 100));
        onDataReceived();
      } else {
        groupsService = GroupsService(
            groupId: groupId ?? groupData?.snapshot?.id,
            type: type,
            onTextsLoaded: () {
              final threads = groupsService?.groupsData.textsList;
              groupData = threads?.firstOrNull;
              if(groupData != null) {
                onGroupSetUpDone();
                if (messagesList.isEmpty) {
                  typeToLoadMessages();
                }
              } else {
                onDataReceived();
              }
            },
            loadOneGroupOnly: true,
            onMessagesLoaded: ({bool clearData = false}) {
              final threads = groupsService?.groupsData.groupsList;
              groupData = (threads?.isNotEmpty ?? false) ? threads!.first : null;
              if(groupData != null) {
                onGroupSetUpDone();
                if (messagesList.isEmpty) {
                  typeToLoadMessages();
                }
              } else {
                onDataReceived();
              }
            });
      }
    } catch (e) {
      onDataReceived();
      rethrow;
    }

    setUpSendCopyAsEmail();
  }

  Future<void> typeToLoadMessages() async {

    try {
      switch (type) {
        case GroupsListingType.fireStoreMessages:
          loadMessagesFromFirestore(); // loading messages
          break;

        case GroupsListingType.apiMessages:
        case GroupsListingType.apiTexts:
          loadMessagesFromApi();
          break;
      }
    } catch (e) {
      onDataReceived();
      rethrow;
    }
  }

  void typeToLoadHistory() {
    switch (type) {

      case GroupsListingType.fireStoreMessages:
        loadHistoryMessages(); // loading messages
        break;

      case GroupsListingType.apiMessages:
      case GroupsListingType.apiTexts:
        loadMessagesFromApi(loadHistory: true);
        break;
    }
  }

  void onGroupSetUpDone() {
    groupId = groupData!.groupId; // setting up group id
    isActiveParticipant = groupData?.activeParticipants?.any((element) => element.id.toString() == AuthService.userDetails!.id.toString()) ?? false;
    participantsService = ParticipantsService(groupData!, groupId!);
  }


  /// loadMessages(): will load initial set of messages
  Future<void> loadMessagesFromFirestore() async {
    try {
      String? afterId = loadFromUnreadMessage
          ? groupData!.myGroupMessageDetails?.lastReadMessage
          : null; // setting up afterId, in-case unread count is more than limit to be loaded

      List<GroupMessageModel> result = await GroupMessageRepo.fetchMessages(
          groupId: groupId!,
          afterId: afterId,
      ); // loading messages from fire-store

      result = FirestoreHelpers.setInBetweenMessageDates(result, forInitialLoad: true); // setting up date tags
      messagesList.addAll(result); // setting up messages list

      setUnreadMessageSeparator(); // setting up separator

      canShowHistory = result.isNotEmpty &&
          result.length >= GroupsMessageRequestParams.instance.defaultPaginationLimit;

      canShowLoadMore = loadFromUnreadMessage &&
          result.isNotEmpty &&
          result.length >= GroupsMessageRequestParams.instance.defaultPaginationLimit;

      if(groupData!.unreadMessageCount != null) {
        pendingCountsToLoadMore =
            groupData!.unreadMessageCount! - messagesList.length;
      }

      onAllMessagesLoaded();
    } catch (e) {
      rethrow;
    }
  }

  /// loadHistoryMessages(): helps in loading history messages
  Future<void> loadHistoryMessages() async {
    if (!canShowHistory) return;

    // beforeDoc will contain document before which history messages will be loaded
    DocumentSnapshot? beforeDoc = historyMessagesList.isEmpty
        ? messagesList[0].doc
        : historyMessagesList[historyMessagesList.length - 1].doc;

    List<GroupMessageModel> result = await GroupMessageRepo.fetchMessages(
      groupId: groupId!,
      beforeDoc: beforeDoc,
    ); // loading messages from fire-store

    result = FirestoreHelpers.setInBetweenMessageDates(result); // setting up date tags

    if (historyMessagesList.isEmpty && result.isNotEmpty) {
      // deciding whether tag has to be kept on very first message of messages list
      messagesList[0].doShowDate = FirestoreHelpers.doShowDate(messagesList[0], result[0]);
    }

    historyMessagesList.addAll(result); // updating history list

    canShowHistory = result.isNotEmpty &&
        result.length >=
            GroupsMessageRequestParams.instance.defaultPaginationLimit;
    receivedNewMessage = false;

    onDataReceived();
  }

  /// loadMoreMessages(): helps in performing load-more
  Future<void> loadMoreMessages() async {
    if (!canShowLoadMore) return;

    DocumentSnapshot afterDoc = messagesList[messagesList.length - 1].doc!; // setting after doc

    List<GroupMessageModel> result = await GroupMessageRepo.fetchMessages(
      groupId: groupId!,
      afterDoc: afterDoc,
    ); // loading data from fire-store

    result = FirestoreHelpers.setInBetweenMessageDates(result); // setting up date tags
    messagesList.addAll(result); // updating message list

    canShowLoadMore = result.isNotEmpty &&
        result.length >=
            GroupsMessageRequestParams.instance.defaultPaginationLimit;
    pendingCountsToLoadMore =
        groupData!.unreadMessageCount! - messagesList.length;

    onAllMessagesLoaded();
  }

  /// onAllMessagesLoaded(): sends callback to update data in controller
  Future<void> onAllMessagesLoaded() async {
    receivedNewMessage = false;

    if(type == GroupsListingType.fireStoreMessages) {
      listenToLatestMessage();
      await markGroupAsRead();
    }

    onDataReceived(); // sending callback
  }

  /// setUnreadMessageSeparator(): adds unread message count separator between messages
  void setUnreadMessageSeparator() {
    if (showUnreadMessageSeparator) {
      int showAtIndex = loadFromUnreadMessage
          ? 0 // adding separator at top of the list
          : messagesList.length -
              (groupData?.myGroupMessageDetails?.unreadMessageCount ?? 0); // adding separator before unread messages

      unreadMessageIndex = showAtIndex = showAtIndex < 0 ? 0 : showAtIndex; // setting up unreadMessageIndex

      int unreadMessageCount = groupData?.unreadMessageCount ?? 0; // setting up unread message count
      String separatorText =
          (unreadMessageCount > 1 ? 'unread_messages'.tr : 'unread_message'.tr); // setting up unread message text

      messagesList[showAtIndex].unreadMessageSeparatorText = '$unreadMessageCount $separatorText';
    }
  }

  /// listenToLatestMessage(): binds a listener on the latest message to receive messages in realtime
  void listenToLatestMessage() {
    if (streamSubscription != null || canShowLoadMore) return;

    bool doAddMsgToList = false; // helps in deciding whether message is to be added in list or not
    String companyId = GroupsMessageRequestParams.instance.companyId.toString();

    Query<GroupMessageModel> query = ReferenceProvider.groupsMessageRef
        .where(FirestoreKeys.companyId, isEqualTo: companyId)
        .where(FirestoreKeys.groupId, isEqualTo: groupId)
        .orderBy(GroupsMessageRequestParams.instance.defaultSortBy, descending: true)
        .withConverter(fromFirestore: (snapshot, _) =>
            GroupMessageModel.fromSnapShot(snapshot), toFirestore: (model, _) => {});

    query = query.limit(1);

    streamSubscription = query.snapshots().listen((snapshot) async {
      GroupMessageModel newMessage = snapshot.docs.first.data();

      if (doAddMsgToList) {
        // removing unread message separator
        messagesList[unreadMessageIndex ?? 0].unreadMessageSeparatorText = null;

        // deciding to add a date tag between new message
        if (messagesList.isNotEmpty) {
          newMessage.doShowDate =
              FirestoreHelpers.doShowDate(messagesList[messagesList.length - 1], newMessage);
        }

        if(newMessage.action != null) {
          await getNewAddedUser(newMessage.actionOnIds ?? []);
        }

        messagesList.add(newMessage); // update message list
        receivedNewMessage = true; // notifying controller, a new message is received

        HapticFeedback.lightImpact();

        onDataReceived(); // updating controller
      } else {
        doAddMsgToList = true;
      }
    });
  }

  Future<void> markGroupAsRead() async {

    if(messagesList.isNotEmpty && (groupData?.unreadMessageCount ?? 0) > 0) {

      String lastMessageId = messagesList[messagesList.length - 1].doc!.id;
      await GroupsRepo.markGroupAsRead(
          lastMessageId: lastMessageId,
          groupId: groupId!,
      ).then((value) {
        groupData?.unreadMessageCount = 0;
      });

    }
  }

  Future<void> sendMessage(String content, {
    bool sendAsEmail = false,
    bool createNewGroup = false,
  }) async {
    try {

      await GroupMessageRepo.sendMessage(content,
          groupDataParticipants: groupData?.participants,
          groupId: groupId,
          sendAsEmail: sendAsEmail,
          jobId: groupData?.jobId,
          createNewGroup: createNewGroup,
      );

    } catch (e) {
      rethrow;
    }
  }


  void setNewMessageUnreadSeparator(int count) {
    if(messagesList.isNotEmpty) {

      String separatorText = (count > 1
          ? 'new_messages'.tr
          : 'new_message'.tr
      ); // setting up unread message text

      // removing old separator if any
      messagesList[unreadMessageIndex ?? 0].unreadMessageSeparatorText = null;
      unreadMessageIndex = messagesList.length - count;
      messagesList[unreadMessageIndex ?? 0].unreadMessageSeparatorText = '$count $separatorText';
    }
  }


  Future<void> getNewAddedUser(List<String> ids) async {

    List<String> filteredIds = ids.where((e) => !GroupsData.allUsers.containsKey(e)).toList();

    if(filteredIds.isEmpty) return;

    final chunks = FirestoreHelpers.getChunks(filteredIds);

    for (List<String> chunk in chunks) {
      await GroupsRepo.getParticipantsData(chunk);
    }
  }

  /// loadMessagesFromApi(): will load message list from server
  Future<void> loadMessagesFromApi({
    int limit = PaginationConstants.pageLimit50, // decides number of documents to be loaded
    bool addNewMessages = false, // helps in differentiating whether to add new messages of load entire list
    bool loadHistory = false, // value should be true in case we want to load history
  }) async {

    // when new message is received
    if(addNewMessages) {
      // updating limit(unread message count in this case) with number of messages sent by me
      // when others user messages were not loaded, so we can increase number of new messages to be loaded
      // and then we can compare if they already exist (will keep them), otherwise will add new message to list
      // offering a similar behaviour to firebase chat
      limit += messagesSentByMeCount;
      receivedNewMessage = true; // informing that it's a new message
      if(messagesList.isNotEmpty) messagesList[unreadMessageIndex ?? 0].unreadMessageSeparatorText = null;
      // setting my unread count to zero
      groupData?.myGroupMessageDetails?.unreadMessageCount = 0;
      removeMessageFromTop(limit); // removing top messages so, load-history can be performed without message repetition
    }

    // in case of history load incrementing page number
    if(loadHistory) {
      currentPage++;
    }

    try {
      Map<String, dynamic> params = {
        'includes[0]': 'sender',
        'includes[1]': 'media',
        'limit': limit,
        'page': addNewMessages ? 1 : currentPage,
        'thread_id': groupData?.groupId,
      };

      final response = await ApiChatsRepo.fetchMessages(params);

      List<GroupMessageModel> result = response['messages'];

      if(result.length > 1) {
        // in-case more than one message is received, setting dates for all
         result = FirestoreHelpers
            .setInBetweenMessageDates(result, forInitialLoad: true);
      } else if(messagesList.isNotEmpty) {
        // in-case only one message is received, comparing it will last message of list
        result.first.doShowDate = FirestoreHelpers
            .doShowDate(result.first, messagesList[messagesList.length - 1]);
      }

      if(loadHistory) {
        // setting up history list
        result = result.reversed.toList();
        messagesList[0].doShowDate = FirestoreHelpers.doShowDate(messagesList.first, result.first);
        historyMessagesList.addAll(result);
      } else {

        if(addNewMessages) {
          // adding only those messages which are not in list
          for(int i=0; i<result.length; i++) {
            if(!messagesList.any((element) => element.id == result[i].id)) {
              messagesList.add(result[i]);
            }
          }
        } else {
          // adding all messages at once
          messagesList.addAll(result);
        }
        setUnreadMessageSeparator();
      }

      if(!addNewMessages) {
        PaginationModel pagination = PaginationModel.fromJson(response['pagination']);
        canShowHistory = (messagesList.length + historyMessagesList.length) < (pagination.total ?? 0);
      }

      messagesSentByMeCount = 0; // setting it to zero means, user message list is completely matches one on the server

      onDataReceived();
    } catch(e) {
      onDataReceived();
      rethrow;
    }
  }

  /// sendApiMessage(): helps in sending message
  Future<void> sendApiMessage({
    required String msg,
    required GroupsListingType type,
    bool sendAsEmail = false,
  }) async {

    try {
      Map<String, dynamic> params = {
        'thread_id': groupData?.groupId,
        'includes[]': 'sender',
        if (type == GroupsListingType.apiTexts) ...{
          'message': msg,
          'phone_number': PhoneMasking.unmaskPhoneNumber(groupData?.phoneNumber ?? "")
        } else ...{
          'content': msg,
          'send_as_email': 0,
          if(groupData?.job != null)...{
            'job_id': groupData?.job?.id,
            'customer_id': groupData?.job?.customerId
          }
        },
      };

      GroupMessageModel message = await ApiChatsRepo.sendMessage(params, type: type);

      messagesSentByMeCount++;

      if((unreadMessageIndex ?? 0) > 0) messagesList[unreadMessageIndex ?? 0].unreadMessageSeparatorText = null;

      if (messagesList.isNotEmpty) {
        message.doShowDate =
            FirestoreHelpers.doShowDate(messagesList.last, message);
      }

      messagesList.add(message);
      removeMessageFromTop(1);
      receivedNewMessage = true;
      markApiMessagesRead();
      onDataReceived();
    } catch (e) {
      rethrow;
    }
  }

  void removeMessageFromTop(int count) {

    // removing message from top only if history load can be performed
    if(!canShowHistory) return;

    for(int i=0; i<count; i++) {
      historyMessagesList.isEmpty
          ? messagesList.removeAt(i)
          : historyMessagesList.removeAt(historyMessagesList.length - 1 - i);
    }
  }

  Future<void> markApiMessagesRead() async {
    try {
      groupData?.myGroupMessageDetails?.unreadMessageCount = 0;
      Map<String, dynamic> params = {
        'last_read_message_id': messagesList[messagesList.length - 1].id,
        'thread_id': groupId
      };
      await ApiChatsRepo.markAsRead(params);
    } catch (e) {
      rethrow;
    }
  }

  void addFailedMessage(String content) {

    final message = GroupMessageModel(
      companyId: '',
      groupId: groupId!,
      updatedAt: DateTime.now(),
      sendAsEmail: 0,
      content: content,
      error: 'message_not_delivered'.tr,
      isMyMessage: true,
      createdAt: DateTime.now(),
      isMultilineText: false,
      isLastLineOfFullWidth: false,
      isTryingAgain: ValueNotifier(false),
    );

    message.doShowDate = FirestoreHelpers.doShowDate(messagesList[messagesList.length - 1], message);

    messagesList.add(message);

    onDataReceived();
  }

  void cancelFailedMessage(int index) {
    final messageToBeRemoved = messagesList[index];

    if(messagesList.length > (index + 1) && messageToBeRemoved.doShowDate) {
      messagesList[index + 1].doShowDate = true;
    }

    messagesList.removeAt(index);

    onDataReceived();
  }
  
  void setUpSendCopyAsEmail() {
    isSendACopyAsEmailEnabled = SendAsEmailService.isSendACopyAsEmailEnabled();
  }

  Future<void> updateSendCopyAsEmail(bool val) async {

    try {

      await SendAsEmailService.updateSendCopyAsEmail(val);

    } catch (e) {
     rethrow;
    }
  }

  /// closeStream(): helps to close message stream
  Future<void> closeStream() async {
    await streamSubscription?.cancel();
    await groupsService?.closeStreams(clearDataAlso: false);
  }
}
