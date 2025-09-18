import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jobprogress/common/enums/chats.dart';
import 'package:jobprogress/common/enums/twilio_text_status.dart';
import 'package:jobprogress/common/models/firebase/firestore/message_media.dart';
import 'package:jobprogress/common/models/phone_consents.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/repositories/customer.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/chats/db_reader.dart';
import 'package:jobprogress/common/services/connectivity.dart';
import 'package:jobprogress/common/services/download.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/core/constants/consent_status_constants.dart';
import 'package:jobprogress/core/constants/mix_panel/event/view_events.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/user_roles.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jobprogress/core/utils/firebase/firestore.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:jobprogress/common/models/firebase/firestore/chat_group.dart';
import 'package:jobprogress/common/models/firebase/firestore/group_message.dart';
import 'package:jobprogress/common/services/firestore/streams/messages/index.dart';

class MessagesPageController extends GetxController {

  MessagesPageController(this.groupsData, this.type, this.onMessageSent);

  final ChatGroupModel? groupsData; // retrieves group data from previous page
  final Function(String message)? onMessageSent;

  GroupsListingType type;

  late MessageService service; // helps in loading messages from fire-store
  late AutoScrollController scrollController; // maintains scroll position of the messages

  bool isLoading = true; // helps in managing initial loading state
  bool isLoadingMore = false;  // manages load-more state
  bool isLoadingHistory = false; // manages history-load state
  bool canShowHistory = false; // helps in knowing, whether history can be loaded
  bool canShowLoadMore = false; // helps in knowing, whether more messages can be loaded
  bool isInitialLoad = true; // manages initial load state
  bool sendAsEmail = false; // used to select un-select send as email
  bool isActiveParticipant = false; // used to enable/disable message field
  bool isSendingMessage = false; // used to handle concurrent message send case
  bool isCustomerOptedOut = false;

  List<GroupMessageModel> historyMessagesList = []; // stores history messages
  List<GroupMessageModel> messagesList = []; // stores messages

  ValueNotifier<bool> isScrollToBottomVisible = ValueNotifier(false); // helps in show/hide scroll to bottom helper
  ValueNotifier<int> unreadNewMessageCount = ValueNotifier(0); // displays unread message counts

  TextEditingController messageController = TextEditingController();

  Key centerKey = const ValueKey('messageList'); // helps in creating double sided load-more

  String? groupId = Get.arguments?['group_id']; // retrieves group id from previous page

  List<JPSingleSelectModel> groupParticipantsList = [];
  List<JPMultiSelectModel> outOfGroupUsers = [];
  List<JPMultiSelectModel> allUsers = [];

  TwilioTextStatus? twilioTextStatus = ConsentHelper.lastTwilioTextStatus;

  bool get doShowTwilioStatusBanner => type == GroupsListingType.apiTexts
      && twilioTextStatus != TwilioTextStatus.enabled;

  @override
  void onInit() {

    if(Get.arguments?['type'] != null) {
      type = Get.arguments?['type'];
    }

    // setting up service
    service = MessageService(
        groupData: groupsData,
        groupId: groupId,
        type: type,
        onDataReceived: onDataReceived
    );

    // setting up controller and it's listener
    setUpScrollController();
    getAllUsers();
    setUpTwilioStatus();
    MixPanelService.trackEvent(event: MixPanelViewEvent.messagingListing);
    super.onInit();
  }

  // conditions to help

  bool get isScrolledToBottom =>
      scrollController.offset == scrollController.position.maxScrollExtent;

  bool get isScrolledToTop =>
      scrollController.offset <= scrollController.position.minScrollExtent;

  bool get canShowScrollToBottom =>
      scrollController.offset < scrollController.position.maxScrollExtent - 100;

  bool get doIncrementUnreadMessageCount =>
      isScrollToBottomVisible.value && service.receivedNewMessage;

  bool get doSetPendingMessageCounts =>
      service.loadFromUnreadMessage || canShowLoadMore;


  // setUpScrollController(): binds listener to scroll controller for performing
  // load-more and history-load
  void setUpScrollController() {
    scrollController = AutoScrollController(
      keepScrollOffset: true,
    );

    scrollController.addListener(() {
      // reached at the end of scroll
      if(isScrolledToBottom && canShowLoadMore) loadMore();

      // setting unreadNewMessageCount to zero, in-case scrolled to bottom and no load-more can be performed
      if(isScrolledToBottom && !canShowLoadMore) unreadNewMessageCount.value = 0;

      // reached at top of scroll
      if(isScrolledToTop && canShowHistory)  loadHistory();

      // shows/hides scroll to bottom helper
      isScrollToBottomVisible.value = canShowScrollToBottom || canShowLoadMore;
    });
  }

  // loadHistory(): loads history messages
  void loadHistory() {

    if(isLoadingHistory || !canShowHistory) return;

    isLoadingHistory = true;

    service.typeToLoadHistory();
  }

  // loadMore(): loads pending unread messages
  void loadMore() {

    if(isLoadingMore || !canShowLoadMore || isLoadingHistory) return;

    isLoadingMore = true;
    service.loadMoreMessages();
  }

  // onDataReceived(): updates data and position list as per data
  void onDataReceived() {
    isLoadingHistory = false;
    isLoading = false;
    isLoadingMore = false;
    canShowHistory = service.canShowHistory;
    canShowLoadMore = service.canShowLoadMore;
    messagesList = service.messagesList;
    historyMessagesList = service.historyMessagesList;
    isActiveParticipant = service.isActiveParticipant;
    if(!service.isApiList) {
      setUnreadMessageCount();
    }

    if(isInitialLoad) {
      toggleSendAsEmail(service.isSendACopyAsEmailEnabled);
    }

    setGroupParticipants();
    update();

    messageTypeToPositionList();

  }

  // setUnreadMessageCount(): sets unread message counts to be displayed on scroll to bottom helper
  void setUnreadMessageCount() {
    if(doIncrementUnreadMessageCount) {
      unreadNewMessageCount.value++;
      service.setNewMessageUnreadSeparator(unreadNewMessageCount.value);
    } else if(doSetPendingMessageCounts) {
      unreadNewMessageCount.value = service.pendingCountsToLoadMore < 0
          ? 0
          : service.pendingCountsToLoadMore;
    }
  }

  // messageTypeToPositionList(): positions message list
  Future<void> messageTypeToPositionList() async {
    if(isInitialLoad) {
      handleInitialListPositioning();
    } else if(service.receivedNewMessage) {
      // in case of new message scrolling to bottom
      animateToBottom(duration: 100);
    }
  }

  // handleInitialListPositioning(): handles different cases to position list
  Future<void> handleInitialListPositioning() async {

    // duration for list to be displayed, before positioning
    await Future<void>.delayed(const Duration(milliseconds: 50));

    if(service.loadFromUnreadMessage) {
      // in case load-more can be performed and unread message count is more than
      // limit of messages to be loaded, scrolling to top of the list, as very
      // first message will be unread message
      double scrollToOffset = scrollController.position.minScrollExtent + 55;
      scrollController.jumpTo(scrollToOffset);

    } else if(service.unreadMessageIndex != null) {

      // in case load-more can not be performed and unread message count is less than
      // limit of messages to be loaded, scrolling to index of the unread message of the
      // list
      int scrollIndex = service.unreadMessageIndex! - (service.unreadMessageIndex! > 1 ? 1 : 0);
      await scrollController.scrollToIndex(scrollIndex, preferPosition: canShowHistory
          ? AutoScrollPosition.begin
          : AutoScrollPosition.middle
      );

    } else {

      // in case no unread message is there, simply jump to the bottom the list
      await jumpToBottom();
    }

    await Future<void>.delayed(const Duration(milliseconds: 100));

    isInitialLoad = false;
    update();
  }

  // animateToBottom(): animates list to bottom on arrival of new message
  Future<void> animateToBottom({int duration = 500}) async {

    if(!scrollController.hasClients) return;

    if(!canShowScrollToBottom && scrollController.offset >= scrollController.position.maxScrollExtent - 20) {

      // duration for keyboard to get opened
      await Future<void>.delayed(Duration(milliseconds: duration));
      jumpToBottom(duration: duration);
    }
  }

  // jumpToBottom(): jumps to bottom of the list, to the last index
  Future<void> jumpToBottom({int duration = 200}) async {

    if(!scrollController.hasClients) return;

    int scrollToIndex = canShowLoadMore
        ? messagesList.length
        : messagesList.length - unreadNewMessageCount.value;

    await scrollController.scrollToIndex(
        scrollToIndex,
        duration: Duration(milliseconds: duration),
        preferPosition: AutoScrollPosition.middle
    ).then((value) {
      // in case load-more can be performed, it starts loading data
      if(canShowLoadMore) {
        loadMore();
      } else {
        // otherwise just remove pending counts and hides scroll to bottom helper
        unreadNewMessageCount.value = 0;
        isScrollToBottomVisible.value = false;
      }
    });
  }

  Future<void> onTapJob() async {
    try {

      showJPLoader();

      int jobId = int.tryParse(service.groupData?.jobId ?? '-1') ?? -1;
      await JobRepository.fetchJob(jobId);

      Get.back();
      navigateToJobDetails();

    } catch (e) {
      Get.back();
      rethrow;
    } finally {
      animateToBottom();
    }
  }

  void navigateToJobDetails() {
    Get.toNamed(Routes.jobSummary, arguments: {
      NavigationParams.jobId : int.tryParse(service.groupData!.jobId.toString()),
      NavigationParams.customerId : int.tryParse(service.groupData!.job!.customerId.toString())
    });
  }

  Future<void> sendMessage({String? msg}) async {

    if(!ConnectivityService.isInternetConnected) {
      Helper.showToastMessage('please_check_your_internet_connection'.tr);
      return;
    }

    String message = msg ?? messageController.text;

    if(isSendingMessage) return;

    try {
      toggleIsSendingMessage();
      HapticFeedback.mediumImpact();

      switch (type) {
        case GroupsListingType.fireStoreMessages:
          service.sendMessage(
              message,
              sendAsEmail: sendAsEmail
          );
          break;

        case GroupsListingType.apiMessages:
        case GroupsListingType.apiTexts:
          await service.sendApiMessage(
              msg: message,
              type: type,
              sendAsEmail: sendAsEmail
          );
          if(onMessageSent != null) onMessageSent!(message);
          break;
      }
    } catch (e) {
      if(msg == null) {
        service.addFailedMessage(message);
      }
      rethrow;
    } finally {
      if(msg == null) {
        messageController.text = "";
      }
      toggleIsSendingMessage();
      await jumpToBottom();
    }
  }

  void toggleIsSendingMessage() {
    isSendingMessage = !isSendingMessage;
    update();
  }

  void toggleSendAsEmail(bool val) {
    sendAsEmail = val;
    if(!isInitialLoad) service.updateSendCopyAsEmail(val);
    update();
  }

  // setGroupParticipants() : sets group participants list (for active participant)
  void setGroupParticipants() {

    if(groupParticipantsList.isNotEmpty) return;

    int? currentUserId = AuthService.userDetails?.id;

    service.groupData?.activeParticipants?.forEach((participant) {

      final doShowEditOptions = participant.id != currentUserId
          && isActiveParticipant
          && type == GroupsListingType.fireStoreMessages;

      // Check if participant is leap system  for automation
      bool isLeapSystem = (service.groupData?.isAutomated ?? false )&& participant.groupId == UserGroupIdConstants.anonymous;
      
      groupParticipantsList.add(
        JPSingleSelectModel(
            label: FirestoreHelpers.getUserName(participant,isAutomated: service.groupData?.isAutomated ?? false),
            id: participant.id.toString(),
            child: isLeapSystem
                ? Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: JPAppTheme.themeColors.themeGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AssetsFiles.automatedTextIcon,
                          width: 12,
                          height: 12,
                          colorFilter: ColorFilter.mode(
                            JPAppTheme.themeColors.base,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    )
                : JPProfileImage(
                    src: participant.profilePic,
                    color: participant.color,
                    size: JPAvatarSize.small,
                    initial: participant.intial ?? participant.firstName.substring(0, 2).toUpperCase(),
                  ),
            onTapItem: participant.isCustomer ? () {
              navigateToCustomerDetails(participant.id);
            } : null,
            suffix: doShowEditOptions
                ? JPTextButton(
              icon: Icons.remove_circle_outline,
              color: JPAppTheme.themeColors.secondary,
              iconSize: 20,
              onPressed: () {
                int index = groupParticipantsList.indexWhere((element) => element.id == participant.id.toString());
                removeParticipantConfirmationDialog(index, participant);
              },
            ) : participant.isCustomer
                ? JPIcon(Icons.arrow_forward_ios_outlined,
              size: 15,
              color: JPAppTheme.themeColors.tertiary,
            ) : null
        ),
      );
    });


    // sorting list to display users in an order
    groupParticipantsList.sort((a, b) => a.label.compareTo(b.label));

    // inserting loggedIn user at top of the list
    int index = groupParticipantsList.indexWhere((element) => element.suffix == null);

    if(index >= 0) {
      final loggedInUser = groupParticipantsList[index];

      groupParticipantsList.removeAt(index);
      groupParticipantsList.insert(0, loggedInUser);
    }
  }

  // showGroupParticipants(): displays active participants sheet
  void showGroupParticipants() {

    final doShowButtons = type == GroupsListingType.fireStoreMessages && isActiveParticipant;

    showJPBottomSheet(
      child: (_) {
        return GetBuilder<MessagesPageController>(
          init: this,
          builder: (_) {
            return JPSingleSelect(
              mainList: groupParticipantsList,
              title: '${'participants'.tr.toUpperCase()} (${groupParticipantsList.length})',
              isFilterSheet: false,
              inputHintText: 'search_here'.tr,
              prefixButtonText: doShowButtons ? 'cancel'.tr : null,
              suffixButtonText: doShowButtons ? 'add_more'.tr : null,
              onTapSuffixBtn: () {
                Get.back();
                showAddMoreParticipantsDialog();
              },
              onTapPrefixBtn: () {
                Get.back();
              },
            );
          },
        );
      },
      isScrollControlled: true,
    );
  }

  // getAllUsers(): will load all the local users from db
  Future<void> getAllUsers() async{
    allUsers = await ChatsDbReader.getAllUsers();
  }

  Future<String?> fetchConsentStatus(String? val) async {
    Map<String, dynamic> params = {
      'number': val ?? '',
    };
    try {
      PhoneConsentModel phoneConsent  = await CustomerRepository.fetchPhoneConsent(params);
      return phoneConsent.status;
    } catch (e) {
      rethrow;
    } 
  }

  Future<void> disableFunctionality(String? val) async {
    if (twilioTextStatus != TwilioTextStatus.enabled) return;
    PhoneMasking.unmaskPhoneNumber(val ?? '');
    String? status = await fetchConsentStatus(val);
    if(status == ConsentStatusConstants.optedOut){
      ConsentHelper.openOptedOutDialog();
      isCustomerOptedOut = true;
    } else {
      isCustomerOptedOut = false; 
    }
     update();
  }
  
  void removeParticipantConfirmationDialog(int index, UserLimitedModel participant) {

    String name = FirestoreHelpers.getUserName(participant); // getting user name

    showJPBottomSheet(
        child: (controller) {
          return JPConfirmationDialog(
            title: 'confirmation'.tr,
            icon: Icons.warning_amber_outlined,
            subTitle: '${'you_are_about_to_remove_the_participant'.tr} ($name). ${'click_confirm_to_proceed'.tr}',
            onTapSuffix: () async {
              controller.toggleIsLoading();
              removeParticipant(participant, name: name).then((value) {
                controller.toggleIsLoading();
              }).catchError((e) {
                controller.toggleIsLoading();
              });
            },
            onTapPrefix: () {
              Get.back();
            },
            disableButtons: controller.isLoading,
            suffixBtnIcon: showJPConfirmationLoader(
                show: controller.isLoading
            ),
          );
        },
      isDismissible: false
    );
  }

  // removeParticipant(): removes participants from the group
  Future<void> removeParticipant(UserLimitedModel participant, {required String name}) async {
    try {
      await service.participantsService.removeParticipants(
        participant: participant,
      );
      Get.back();
      Helper.showToastMessage('$name ${'removed_from_group'.tr}');
    } catch (e) {
      Helper.showToastMessage(e.toString());
      rethrow;
    } finally {
      update();
    }
  }

  void showAddMoreParticipantsDialog() {
    outOfGroupUsers = allUsers
        .where(
            (localUser) => !groupParticipantsList.any(
                (groupParticipant) => groupParticipant.id == localUser.id)).toList();

    showJPBottomSheet(
      child: (controller) {
        return JPMultiSelect(
          mainList: outOfGroupUsers,
          title: 'add_participants'.tr,
          inputHintText: 'search_here'.tr,
          helperText: 'new_participants_would_be_able_to_see_all_messages'.tr,
          disableButtons: controller.isLoading,
          onDone: (List<JPMultiSelectModel> allUsers) async {
            List<String> newParticipantIds = allUsers.where((element) => element.isSelect).map((e) => e.id.toString()).toList();
            await addParticipants(newParticipantIds);
          },
        );
      },
      isScrollControlled: true,
    );

  }

  // addParticipants(): adds new participants to group
  Future<void> addParticipants(List<String> newParticipantIds) async {

    if(newParticipantIds.isEmpty) {
      Helper.showToastMessage('please_select_participants_to_add'.tr);
      return;
    }

    try {

      Get.back();
      showJPLoader(
          msg: 'adding_participants'.tr
      );
      await service.participantsService.addParticipants(newParticipantIds);
      String msg = FirestoreHelpers.getActionOn(newParticipantIds) ?? "";
      Helper.showToastMessage('$msg ${'added_to_group'.tr}');

    } catch (e) {
      Helper.showToastMessage('something_went_wrong'.tr);
      rethrow;
    } finally {
      update();
      Get.back();
    }
  }

  Future<void> closeStreams() async {
    await service.closeStream();
    if(scrollController.hasClients) scrollController.dispose();
    markAsRead();
  }

  // onGroupUpdated(): updates group data (members, title etc.)

  Future<void> onGroupUpdated(ChatGroupModel? updatedData) async {

    if(service.isApiList) {
      // in case of api listing, when unread message count is there loading new messages from server
      if((updatedData?.unreadMessageCount ?? 0) > 0) {
        await service.loadMessagesFromApi(
            limit: updatedData!.unreadMessageCount!,
            addNewMessages: true
        );
        if(doIncrementUnreadMessageCount) {
          unreadNewMessageCount.value += updatedData.unreadMessageCount!;
          service.setNewMessageUnreadSeparator(unreadNewMessageCount.value);
        }
      }
    } else if(updatedData == null) {
      isActiveParticipant = false;
      groupParticipantsList.clear();
      setGroupParticipants();
      groupParticipantsList.removeWhere((element) => element.id.toString() == AuthService.userDetails?.id.toString());
      await Future<void>.delayed(const Duration(milliseconds: 500));
      update();
    } else if(type == GroupsListingType.fireStoreMessages) {
      // updating group data when new participants are added
      if (updatedData.activeParticipants?.length != service.groupData?.activeParticipants?.length) {
        service.groupData = updatedData;
        service.onGroupSetUpDone();
        isActiveParticipant = service.isActiveParticipant;
        groupParticipantsList.clear();
        setGroupParticipants();
        await Future<void>.delayed(const Duration(milliseconds: 500));
        update();
      }

      service.groupData = updatedData;
      service.onGroupSetUpDone();

    }
  }

  Future<void> markAsRead() async {
    if((service.groupData?.unreadMessageCount ?? 0) > 0 && type == GroupsListingType.fireStoreMessages) {
      await service.markGroupAsRead();
    }
  }

  Future<void> handleOnTapFile(MessageMediaModel file) async {

    try{
      showJPLoader(
          msg: 'downloading_file'.tr
      );
      if (!Helper.isValueNullOrEmpty(file.filePath)) {
        await DownloadService.downloadFile(file.filePath!, file.fileName!);
      }
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  Future<void> onTapTryAgain(int index) async {

    String content = messagesList[index].content!;

    try {
      messagesList[index].isTryingAgain?.value = true;
      await sendMessage(msg: content);
      messagesList[index].isTryingAgain?.value = false;
      onTapCancel(index);
    } catch (e) {
      rethrow;
    } finally {
      messagesList[index].isTryingAgain?.value = false;
    }
  }

  void onTapCancel(int index) {
    service.cancelFailedMessage(index);
  }

  void navigateToCustomerDetails(int? id) {

    Get.back();

    Get.toNamed(Routes.customerDetailing, arguments: {
      NavigationParams.customerId : id,
    });
  }

  Future<void> setUpTwilioStatus() async {
    if (type == GroupsListingType.apiTexts) {
      twilioTextStatus = await ConsentHelper.getTwilioTextStatus();
      disableFunctionality(groupsData?.phoneNumber);
    }
  }
}