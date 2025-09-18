import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/page_type.dart';
import 'package:jobprogress/common/models/sql/tag/tag.dart';
import 'package:jobprogress/common/repositories/firebase/firestore/groups.dart';
import 'package:jobprogress/common/services/chats/db_reader.dart';
import 'package:jobprogress/common/services/forms/parsers.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/common/services/send_as_email.dart';
import 'package:jobprogress/core/constants/mix_panel/event/view_events.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/constants/user_type_list.dart';
import 'package:jobprogress/core/utils/firebase/firestore.dart';
import 'package:jobprogress/core/utils/form/db_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/multi_list.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/multi_list_model.dart';
import '../../common/models/job/job.dart';
import '../../common/repositories/chats.dart';

class SendMessageFormController extends GetxController {

  SendMessageFormController({this.jobData, this.onMessageSent});

  final formKey = GlobalKey<FormState>();
  final VoidCallback? onMessageSent;

  TextEditingController participantsController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  List<JPMultiSelectMultiListModel> selectionList = [
    JPMultiSelectMultiListModel(
        label: 'user_groups'.tr,
    ),
    JPMultiSelectMultiListModel(
        label: 'users'.tr,
    ),
  ];

  List<JPMultiSelectMultiListModel> selectionUserList = [
    JPMultiSelectMultiListModel(
      label: 'users'.tr,
    ),
  ];

  List<JPMultiSelectModel> selectedGroups = [];
  List<JPMultiSelectModel> selectedUsers = [];

  bool sendAsEmail = false;
  bool isLoading = false;

  JobModel? jobData;

  @override
  void onInit() {
    if (jobData != null) {
      String? customerName = jobData!.customer?.fullName;
      customerName = customerName != null ? '$customerName / ' : '';
      jobController.text = customerName + Helper.getJobName(jobData!);
    }
    setUpAllParticipants();
    setUpSendCopyAsEmail();
    MixPanelService.trackEvent(event: MixPanelViewEvent.sendMessageView);
    super.onInit();
  }

  Future<void> setUpAllParticipants({bool showLoader = false}) async {
    if(showLoader) showJPLoader();
    selectionList[0].list = await ChatsDbReader.getAllTags();
    selectionList[1].list = await ChatsDbReader.getAllUsers();
    selectionUserList[0].list = selectionList[1].list;
    setUserTypeList(selectionList[1].list);
    if(showLoader) Get.back();
  }

  void setUserTypeList(List<JPMultiSelectModel> users) {
    if(jobData != null) {
      if(jobData?.isMultiJob ?? false) {
        users.insert(0, UserTypeConstants.userTypeList.firstWhere((element) => element.id == '-1'));
      } else {
        users.insertAll(0, UserTypeConstants.userTypeList);
      }
    }
  }

  Future<void> selectJob() async {
    final job = await Get.toNamed(Routes.customerJobSearch, arguments: {
      NavigationParams.pageType : PageType.selectJob,
    }, preventDuplicates: false);

    if(job != null) {
      jobData = job;
      String? customerName = jobData?.customer?.fullName;
      jobController.text =  (customerName != null
          ? '$customerName / '
          : '') + Helper.getJobName(job);
      await updateUsersOnJobChange(jobData);
    }
    update();
  }

   Future<void> updateUsersOnJobChange(JobModel? job) async {
    final selectedUsersIDs = selectedUsers.map((e) => e.id).toList();

    selectionList[1].list = await FormsDBHelper.getAllUsers(
      selectedUsersIDs,
      divisionIds: [job?.division?.id],
    );
    setUserTypeList(selectionList[1].list);
    final selectedValuesList = selectionList[1].list.where((element) => element.isSelect).toList(); // filtering selected options
    participantsController.text = selectedValuesList.map((user) => user.label).toList().join(', ');
  }

  Future<void> selectParticipants() async {
    final bool hasUserGroupPermission = PermissionService.hasUserPermissions([PermissionConstants.messageToUserGroups]);
    showJPBottomSheet(
      child: (_) => JPMultiListMultiSelect(
        data: hasUserGroupPermission ? selectionList : selectionUserList,
        title: 'select_users'.tr,
        onDone: (List<JPMultiSelectMultiListModel> data) {
          List<JPMultiSelectModel> selectedItems = [];

          if(hasUserGroupPermission) {
            selectionList = data;
            selectedGroups = JPMultiSelectMultiListModel.getSelectedItems(data[0]);
            selectedUsers = JPMultiSelectMultiListModel.getSelectedItems(data[1]);

            selectedItems = selectedGroups + selectedUsers;
          } else {
            selectionUserList = data;
            selectedUsers = JPMultiSelectMultiListModel.getSelectedItems(data[0]);
            selectedItems = selectedUsers;
          }

          final selectedValuesList = selectedItems.where((element) => element.isSelect).toList(); // filtering selected options
          participantsController.text = selectedValuesList.map((user) => user.label).toList().join(', ');
        },
      ),
      isScrollControlled: true,
    );
  }

  void toggleSendAsEmail(bool val) {
    sendAsEmail = !val;
    updateSendCopyAsEmail(sendAsEmail);
    update();
  }


  String? validateMessage(String value) {
    if (value.trim().isEmpty) {
      return 'please_enter_message'.tr;
    }
    return null;
  }

  String? validateParticipants(String value) {
    if (value.isEmpty) {
      return 'please_select_participants'.tr;
    }
    return null;
  }

  void validateFormAndSendMessage() {

    bool isValid = formKey.currentState?.validate() ?? false;

    if(isValid) {
     formKey.currentState?.save();
     createNewGroup();
    }

  }

  List<String>? getParticipantIdsOnUserType(JobModel? jobData, List<String>? userTypeIds) {
    
    List<String> participantIds = [];
    
    for (String typeId in userTypeIds ?? []) {
      switch (typeId) {
        case UserTypeConstants.customerRep:
          participantIds.addAll(jobData?.reps?.map((user) => user.id.toString()) ?? []);
          continue;
        case UserTypeConstants.companyCrew:
          participantIds.addAll(jobData?.workCrew?.map((user) => user.id.toString()) ?? []);
          continue;
        case UserTypeConstants.estimator:
          participantIds.addAll(jobData?.estimators?.map((user) => user.id.toString()) ?? []);
          continue;
        case UserTypeConstants.subs:
          participantIds.addAll(jobData?.subContractors?.map((user) => user.id.toString()) ?? []);
          continue;
      }  
    }
    return participantIds;
  }

  Future<void> createNewGroup() async {
    List <String> userTypeIds = FormValueParser.multiSelectToUserTypeIds(selectedUsers) ?? [];
    List<String> userIds = FormValueParser.multiSelectToSelectedIds(selectedUsers)?.map((e) => e.toString()).toList() ?? [];
    List<String>? userTypeSelectedIds = getParticipantIdsOnUserType(jobData,userTypeIds);
    
    if(
      !Helper.isValueNullOrEmpty(userTypeIds) && 
      Helper.isValueNullOrEmpty(userIds) && 
      Helper.isValueNullOrEmpty(userTypeSelectedIds)
    ){
        Helper.showToastMessage('please_assign_user_to_customer_rep_estimator_company_crew_sub_contractor'.tr);
    } else {
      try {
        toggleIsLoading();
        
        List<String> participantIds = [];
        
        for (JPMultiSelectModel group in selectedGroups) {
          List<String> userIds = (group.additionData as TagModel)
              .users?.map((user) => user.id.toString()).toList() ?? [];
          participantIds.addAll(userIds);
        } 
        participantIds.addAll(userIds);
        
        if(FirestoreHelpers.instance.isMessagingEnabled) {
          participantIds.addAll(userTypeSelectedIds ?? []);
          await GroupsRepo.createNewGroup(
            content: messageController.text.trim(),
            jobId: jobData?.id.toString(),
            participantIds: participantIds,
          );
        } else {
          await createApiGroup(participantIds, userTypeIds: userTypeIds);
        }
        Get.back();
      } catch (e) {
        Helper.showToastMessage('something_went_wrong'.tr);
      } finally {
        toggleIsLoading();
      }
    }
  }

  void toggleIsLoading() {
    isLoading = !isLoading;
    update();
  }

  /// createApiGroup(): helps in creating group & sending message
  Future<void> createApiGroup(List<String> participantIds,{List <String>? userTypeIds}) async {

    try {
      Map<String, dynamic> params = {
        'content': messageController.text.trim(),
        'send_as_email': sendAsEmail ? 1 : 0,
        'includes[0]': 'sender',
        'includes[1]': 'participants',
        'includes[2]': 'thread.job',
        if(jobData != null)...{
          'job_id': jobData?.id,
          'customer_id': jobData?.customerId
        },
        if(!Helper.isValueNullOrEmpty(userTypeIds))...{
          for(int i=0; i<userTypeIds!.length; i++)
          'participant_setting[$i]' : userTypeIds[i]
        },
        if(participantIds.isNotEmpty)...{
          for(int i=0; i<participantIds.length; i++)
          'participants[$i]' : int.parse(participantIds[i]),
        } else... {
          'participants[]': ''
        }
      };

      await ApiChatsRepo.sendMessage(params);

      if(onMessageSent != null) onMessageSent!();

    } catch (e) {
      rethrow;
    }
  }

  void setUpSendCopyAsEmail() {
    sendAsEmail = SendAsEmailService.isSendACopyAsEmailEnabled();
  }

  Future<void> updateSendCopyAsEmail(bool val) async {
    try {
      await SendAsEmailService.updateSendCopyAsEmail(val);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeJob() async {
    jobController.clear();
    jobData = null;
    await updateUsersOnJobChange(jobData);
    update();
    
  }

  Future<bool> onWillPop() async {
    return !isLoading;
  }
}