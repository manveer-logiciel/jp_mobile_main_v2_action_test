import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/chats.dart';
import 'package:jobprogress/common/extensions/get_navigation/extension.dart';
import 'package:jobprogress/common/models/firebase/firestore/chat_group.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/common/repositories/company_settings.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/chats/db_reader.dart';
import 'package:jobprogress/common/services/chats/quick_actions.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_handlers.dart';
import 'package:jobprogress/common/services/firestore/streams/groups/index.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/chats.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/mix_panel/event/filter_events.dart';
import 'package:jobprogress/core/utils/firebase/firestore.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/multi_select_helper.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/send_message/index.dart';
import 'package:jobprogress/modules/chats/groups_listing/widgets/messages/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../core/constants/navigation_parms_constants.dart';

class GroupsListingController extends GetxController with GetTickerProviderStateMixin {

  final scaffoldKey = GlobalKey<ScaffoldState>(); // for opening drawer

  late TabController tabController; // helps to navigate between Messages & texts
  late GroupsService groupsService; // handles all the groups action and provides data

  bool isLoadingMessage = true; // used to managing loading state
  bool isLoadMoreMessage = false; // used to manage load-more state
  bool canShowMessageLoadMore = true; // used to manage load-more state
  bool isLoadingTexts = true; // used to managing loading state
  bool isLoadMoreTexts = false; // used to manage load-more state
  bool canShowTextsLoadMore = true; // used to manage load-more state

  List<JPMultiSelectModel> localUser = []; // used to store list of users, to be used while applying filter
  List<JPMultiSelectModel> localUserGroup = [];
  List<String> filterUserIds = []; // used to store users ids selected while applying filter
  List<ChatGroupModel> groups = []; // used to store list of groups
  List<ChatGroupModel> texts = []; // used to store list of texts

  String? jobId = Get.arguments?['jobId']; // used to filter groups via job id
  String? jobName = Get.arguments?['jobName'];  // used to display name as page title
  
  JobModel? job = Get.arguments?[NavigationParams.jobModel];  // used to sore details of job

  // SMS Type filtering properties
  String selectedSmsType = ChatsConstants.smsTypeConversations; // Default to Conversation
  List<JPSingleSelectModel> smsTypeOptions = [
    JPSingleSelectModel(id: ChatsConstants.smsTypeConversations, label: 'conversations'.tr),
    JPSingleSelectModel(id: ChatsConstants.smsTypeAutomated, label: 'automated'.tr),
    JPSingleSelectModel(id: ChatsConstants.smsTypeAll, label: 'all'.tr),
  ]; // Filter options

  List<PopoverActionModel> sortBy = [
    PopoverActionModel(label: 'all'.tr, value: 'all_messages', isSelected: true),
    PopoverActionModel(label: 'unread'.tr, value: 'unread_message_count'),
  ]; // sort by filters list

  late GroupsListingType messageListType;
  late GroupsListingType selectedListType;
  late GroupsListingType selectedMessagesListType;

  final messageThreadsKey = GlobalKey<GroupsThreadListState>();

  Widget? selectedProfile; // used to pass as an argument to message page

  bool hasUserManagementFeature = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.userManagement]);
  bool get canDrawerOpen => JPScreen.isDesktop || groupsService.selectedGroupData == null;

  // used to open texts tab by default
  bool get switchToTexts {
    if(hasUserManagementFeature) {
      return Get.arguments?['switchToTexts'] ?? false;
    }
    return true;
  } 

  @override
  void onInit() {
    // setting up tab controller
    tabController = TabController(length: 2, vsync: this);

    if(job != null) {
      jobId = job?.id.toString();
      jobName = job?.customer?.fullName;
    }

    messageListType =
        selectedListType =
        selectedMessagesListType =
        getMessageListingType();
    // Load saved text type filter setting
    loadTextTypeFilterSetting();

    // setting up group service as soon as page loads
    groupsService = GroupsService(
        jobId: jobId,
        onMessagesLoaded: onMessagesLoaded,
        onTextsLoaded: onTextsLoaded,
        type: messageListType,
        doLoadTextsFirst: switchToTexts
    );

    tabController.addListener(() {
      setSelectedListingType(tabController.index);
      groupsService.type = selectedListType;

      if(tabController.indexIsChanging) return;

      if(selectedListType == GroupsListingType.apiTexts && isLoadingTexts) {
        groupsService.setSmsType(selectedSmsType);
        groupsService.setUpApiTextsStream();
      } else if(switchToTexts) {
        groupsService.setSmsType(selectedSmsType);
        groupsService.typeToInitialLoad();
      }
      update();
    });


    if(switchToTexts) {
      tabController.animateTo(1);
    }

    // setting up list of users to be filtered from
    setLocalUsers();
    setLocalUserGroup();
    super.onInit();
  }

  // setLocalUsers() : will load all users from local storage to be used as filters
  Future<void> setLocalUsers() async {
    localUser = await ChatsDbReader.getAllUsers();
  }

  Future<void> setLocalUserGroup() async {
    localUserGroup = await ChatsDbReader.getAllTags();
  }

  // animateTabTo(index): used to switch between tabs
  // index: is the index on new tab to which to be switched
  void animateTabTo(int index) {
    // in case trying to navigate to selected tab, no action will take place
    if(index == tabController.index) return;
    tabController.animateTo(index);
    update();
  }

  // loadMoreMessages(): helps in loading next set of data from server
  Future<void> loadMoreMessages() async {
    // in case one loading is already in progress, next loading should not take place
    if(isLoadMoreMessage || !canShowMessageLoadMore) return;
    isLoadMoreMessage = true;

    // calling service to load next set of data
    groupsService.typeToLoadMoreGroups(
      filterUserIds: filterUserIds,
    );
  }

  // loadMoreMessages(): helps in loading next set of data from server
  Future<void> loadMoreTexts() async {
    // in case one loading is already in progress, next loading should not take place
    if(isLoadMoreTexts || !canShowTextsLoadMore) return;
    isLoadMoreTexts = true;

    // calling service to load next set of data - now always pass selectedSmsType including 'ALL'
    groupsService.setSmsType(selectedSmsType);
    groupsService.typeToLoadMoreGroups();
  }

  // onDataLoaded(): will setup data list and other variable to setup state
  Future<void> onMessagesLoaded({bool clearData = false}) async {
    // scrolling to top in case of api message listing when data loaded from firebase
    // count update stream to avoid (loader stuck issue) in case of api message listing
    // This is a temporary fix taken from old app. It can be improved later on in future.
    bool scrollToTop = clearData
      && groupsService.type == GroupsListingType.apiMessages;

    if (scrollToTop) {
      await messageThreadsKey.currentState?.scrollToTop();
    }

    isLoadMoreMessage = false;
    isLoadingMessage = false;
    canShowMessageLoadMore = groupsService.canShowMessageLoadMore;
    groups = groupsService.groups;
    // updating group data in messaging page (eg. counts, participants etc.)
    groupsService.selectedGroupData = groups
        .firstWhereOrNull((group) => group.groupId == groupsService.selectedGroupData?.groupId) ?? groupsService.selectedGroupData;
    update();
  }

  // onTextsLoaded(): will setup data list and other variable to setup state
  void onTextsLoaded() {
    isLoadMoreTexts = false;
    isLoadingTexts = false;
    canShowTextsLoadMore = groupsService.canShowTextsLoadMore;
    texts = groupsService.texts;
    // updating group data in messaging page (eg. counts etc.)
    groupsService.selectedGroupData = texts
        .firstWhereOrNull((group) => group.groupId == groupsService.selectedGroupData?.groupId) ?? groupsService.selectedGroupData;
    update();
  }

  // showFilterSheet(): will display filter list
  void showFilterSheet() {
    MultiSelectHelper.openMultiSelect(
        maxSelection: 10,
        mainList: localUser,
        subList: localUserGroup,
        isGroupsHeader: localUserGroup.isNotEmpty,
        inputHintText: 'search_here'.tr,
        title: 'select_users'.tr,
        helperText: 'select_up_to_10_users'.tr,
        isScrollControlled: true,
        onMaxSelectionReached: () {
          Helper.showToastMessage('cant_select_more_than_10_users'.tr);
        },
        callback: (List<JPMultiSelectModel> users) {
          applyFilter(users);
          Get.back();
        },
    );
  }

  // applyFilter(): will apply user filters and load filtered data
  void applyFilter(List<JPMultiSelectModel> users) {

    // updating selected list
    localUser = users;

    // filtering selected users from all users
    List<String> userIds = localUser
        .where((element) => element.isSelect)
        .map((e) => e.id).toList();

    // in case there is no change in filters, server request will not tage place
    if(!listEquals(filterUserIds, userIds)) {

      groupsService.typeToLoadGroups(
        clearData: true,
        selectedUserIds: userIds
      );
    }

    filterUserIds = userIds; // updating filter user ids
    isLoadingMessage = true; // updating loading state

    MixPanelService.trackEvent(event: MixPanelFilterEvent.chats);

    update();
  }

  // getTitle(): returns appropriate title for the page
  String getTitle() {
    if(jobName != null) {
      return jobName ?? '';
    }
    if(hasUserManagementFeature){
      return 'messages'.tr;
    }
    return 'texts'.tr.capitalizeFirst!;
  }
    
  

  // onApplyingSortFilter(): will helps in sorting groups list on the basis of applied filter
  void onApplyingSortFilter(String val) {
    groupsService.applySortFilter(
        val,
        userIds: filterUserIds
    );
    PopoverActionModel.selectAction(sortBy, val);
    isLoadingMessage = true;

    MixPanelService.trackEvent(event: MixPanelFilterEvent.chats);

    update();
  }

  // onTapGroup() : set's up selected group data, also navigates to groups if isn't already selected
  void onTapGroup(String? id, Widget profileWidget) async {

    if(id == groupsService.selectedGroupData?.groupId) return;

    ChatGroupModel? groupData = groupsService.getGroupDataFromId(id!); // getting group data

    // in case group data is not found (which may happen on bg refresh) we will wait for 500ms and try again
    // so data is available to us for searching tapped group
    if (groupData == null) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      // re-fetching thread from available threads
      groupData = groupsService.getGroupDataFromId(id); // getting group data
    }
    // In case thread is not found, do nothing
    if (groupData == null) return;

    bool itemSelectedBeforeNavigation = groupsService.selectedGroupData != null; // identifying navigation type

    groupsService.selectedGroupData = groupData; // setting up data
    selectedProfile = profileWidget;
    selectedMessagesListType = selectedListType;
    Get.toSplitNamed(Routes.messages, onSplitExit: (_) async {
      if (messageListType == GroupsListingType.apiMessages) {
        messageThreadsKey.currentState?.jumpToTop();
      }
      // Group data is removed conditionally here because:
      // Mobile and tablet - On re-opening the previously opened group, It should re-load and a new screen should open
      //           if we not remove group data it refuses to do so
      // Desktop - On re-opening the previously opened group, It should 'not' re-load and
      //           preserve the previous data that's why we are not removing group data
      if (!JPScreen.isDesktop) groupsService.selectedGroupData = null;
      // in case group listing is under data changes, waiting for 500ms to get it completed
      // this approach is used to avoid showing shimmer and data not yet loaded message
      if (groups.isEmpty) await Future<void>.delayed(const Duration(milliseconds: 500));
      update();
    }, itemSelectedBeforeNavigation: itemSelectedBeforeNavigation);
    update();
  }

  GroupsListingType getMessageListingType() {
    if(FirestoreHelpers.instance.isMessagingEnabled) {
      return GroupsListingType.fireStoreMessages;
    } else {
      return GroupsListingType.apiMessages;
    }
  }

  void setSelectedListingType(int index) {
    if (index == 0) {
      selectedListType = getMessageListingType();
    } else if (index == 1) {
      selectedListType = GroupsListingType.apiTexts;
    }
  }

  void onLongPressGroup(int index) {

    int? unreadMessageCount = groupsService.typeToUnreadMessageCount(index);

    if(unreadMessageCount == null) return;

    // Check if this is an automated SMS conversation
    ChatGroupModel? groupData = selectedListType == GroupsListingType.apiTexts 
        ? (index < texts.length ? texts[index] : null)
        : (index < groups.length ? groups[index] : null);
    
    // Disable unread/read functionality for automated SMS when flag is enabled
    if (groupData?.isAutomated == true && 
        LDService.hasFeatureEnabled(LDFlagKeyConstants.textNotificationsAutomation)) {
      return;
    }

    GroupListingQuickActions.openQuickActions(unreadMessageCount, (value)  async {

      try {
        switch (value) {
          case "GroupListingMarkAs.unread":
            await groupsService.typeToMarkGroupAsUnRead(index);
            break;

          case "GroupListingMarkAs.read":
            await groupsService.typeToMarkGroupAsRead(index);
            break;
        }
      } catch (e) {
        rethrow;
      } finally {
        Get.back();
      }

    });
  }

  void showSendMessageSheet() {
    showJPBottomSheet(
        child: (_) {
          return SendMessageForm(
            jobData: job,
            onMessageSent: () async {
              await groupsService.loadGroupsFromApi(
                clearData: true
              );
            },
          );
        },
      isScrollControlled: true,
      enableInsets: true,
    );
  }

  // handleOnMessageSent(): helps in handling on message sent (eg. pushing group on top of list)
  void handleOnMessageSent(String message) {
    if(groupsService.groups.any((group) => group.groupId == groupsService.selectedGroupData?.groupId)) {
      groupsService.insertGroupAtTopOfList(groupsService.selectedGroupData!, message);
      update();
    }

    if(groupsService.texts.any((group) => group.groupId == groupsService.selectedGroupData?.groupId)) {
      groupsService.insertGroupAtTopOfList(groupsService.selectedGroupData!, message);
      update();
    }
  }

  Future<bool> onWillPop() async {
    final isGroupOpen = groupsService.selectedGroupData != null;

    if(isGroupOpen) {
      groupsService.selectedGroupData = null;
      Get.splitPop();
    }

    return !isGroupOpen;
  }

  /// Handles the action of adding a message.
  /// Depending on the selected tab, it either shows the send message sheet
  /// or sends a text via JobProgress.
  void onAddMessage() {
    if (tabController.index == 0) {
      showSendMessageSheet(); // Show the send message sheet if the first tab is selected
    } else {
      FileListQuickActionHandlers.sendViaJobProgress(
        onTextSent: () async {
          await groupsService.loadTextsFromApi(clearData: true); // Load texts from API after sending
        },
      );
    }
  }

  // showSmsTypeFilter(): will display SMS type filter options
  void showSmsTypeFilter() {
    SingleSelectHelper.openSingleSelect(
      smsTypeOptions,
      selectedSmsType,
      'filter_by'.tr,
      (String value) {
        applySmsTypeFilter(value);
        Get.back();
      },
      isFilterSheet: true
    );
  }

  // applySmsTypeFilter(): will apply SMS type filter and reload data
  void applySmsTypeFilter(String smsType) {
    if (selectedSmsType == smsType) return;

    selectedSmsType = smsType;
    isLoadingTexts = true;
    update();

    // Save the selected text type filter setting
    saveTextTypeFilterSetting();

    // Reload texts with new filter - now always pass the smsType, including 'ALL'
    groupsService.setSmsType(smsType);
    groupsService.loadTextsFromApi(clearData: true);
  }

  // loadTextTypeFilterSetting(): loads saved text type filter preference
  void loadTextTypeFilterSetting() {
    bool hasAccessAutomativeText = LDService.hasFeatureEnabled(LDFlagKeyConstants.textNotificationsAutomation) && (AuthService.isOwner() || AuthService.isSystemUser() || jobId != null);
    // If LaunchDarkly flag is off, force SMS type only
    if (!hasAccessAutomativeText) {
      selectedSmsType = ChatsConstants.smsTypeConversations;
    } else {
      try {
        dynamic savedFilter = CompanySettingsService.getCompanySettingByKey(
        CompanySettingConstants.textTypeFilter,
        onlyValue: true
      );
      
      if (savedFilter is String && savedFilter.isNotEmpty) {
        selectedSmsType = savedFilter;
      }
      } catch (e) {
        Helper.recordError(e);
        // Continue with default value
      }
    }
  }


  // saveTextTypeFilterSetting(): saves user's text type filter preference
  Future<void> saveTextTypeFilterSetting() async {
    try {
      dynamic preservedFilter = CompanySettingsService.getCompanySettingByKey(
        CompanySettingConstants.textTypeFilter,
        onlyValue: false
      );
      
      // Creating settings for the first time
      if (preservedFilter is bool || preservedFilter == null) {
        preservedFilter = {
          "name": CompanySettingConstants.textTypeFilter,
          "key": CompanySettingConstants.textTypeFilter,
          "user_id": AuthService.userDetails?.id,
        };
      }
      
      // updating the filter value
      preservedFilter['value'] = selectedSmsType;
      await CompanySettingRepository.saveSettings(preservedFilter);
    } catch (e) {
      Helper.recordError(e);
    }
  }

}
