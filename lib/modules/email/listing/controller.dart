import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/common/enums/secondary_drawer.dart';
import 'package:jobprogress/common/extensions/get_navigation/extension.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/models/email/email.dart';
import 'package:jobprogress/common/models/email/email_group.dart';
import 'package:jobprogress/common/models/email/email_params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/secondary_drawer_item.dart';
import 'package:jobprogress/common/models/label.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/sql/user/user_param.dart';
import 'package:jobprogress/common/models/sql/user/user_response.dart';
import 'package:jobprogress/common/repositories/email.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/sql/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/color_helper.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/modules/email/detail/controller.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/three_bounce.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../core/constants/user_roles.dart';

class EmailListingController extends GetxController {
  bool isLoading = true;
  bool isLoadMore = false;
  bool canShowLoadMore = false;
  bool isLoadingInDialog = false;
  bool isMultiSelectionOn = false;

  final animatedScrollKey = GlobalKey<AnimatedListState>();
  late GlobalKey<ScaffoldState> scaffoldKey;
  late GlobalKey<ScaffoldState> secondaryDrawerKey;

  int totalEmailLength = 0;
  int totalEmailCount = 0;
  int? jobId = Get.arguments == null ? -1 : Get.arguments?[NavigationParams.jobId];
  int? customerId = Get.arguments == null ? -1 : Get.arguments?[NavigationParams.customerId];

  String controllerTag = '';
  JobModel? job;

  List<GroupEmailListingModel> emailGroup = [];
  List<JPSecondaryDrawerItem> labelList = [];
  Map<String, dynamic>? apiLabelList;
  List<UserModel> userList = [];
 

  List<EmailListingModel> selectedEmails = [];
  List<JPSecondaryDrawerItem> customLabelList = [
    JPSecondaryDrawerItem(slug: '-1', title: 'inbox'.tr.capitalize!, icon: Icons.inbox_outlined, realTimeKeys: [RealTimeKeyType.emailUnread]),
    JPSecondaryDrawerItem(slug: '-2', title: 'sent'.tr.capitalize!, icon: Icons.send_outlined),
    JPSecondaryDrawerItem(slug: '-3', title: 'trash'.tr.capitalize!, icon: Icons.delete_outlined),
  ];

  List<JPSecondaryDrawerItem> actionList = [
    JPSecondaryDrawerItem(slug: 'create_label', title: 'create_label'.tr, icon: Icons.add, itemType: SecondaryDrawerItemType.action),
  ];

  TextEditingController textController = TextEditingController();

  EmailListingParamModel paramKeys = EmailListingParamModel(users: AuthService.userDetails!.id);

  EmailLabelModel? selectedLabel;

  String? selectedSlug;

  UserModel? loggedInUser;

  UserModel? selectedUser;

  int? selectedEmailId; // used to pass as an argument to detail page

  Color? selectedAvatarColor; // used to pass as an argument to detail page

  EmailDetailController? emailDetailController;

  bool get canShowFloatingActionButton => selectedEmailId == null;

  bool get canDrawerOpen => JPScreen.isDesktop || selectedEmailId == null;

  Future<dynamic> getLoggedInData() async {
    loggedInUser = await AuthService.getLoggedInUser();
    selectedUser = loggedInUser;
  }

//Getting emailsParams and tagsParams to send in Email listing api
  Future<void> getAll() async {
    try {
     if(jobId != null){
      if (jobId != null) {
        paramKeys.jobId = jobId;
        paramKeys.withReply = null;
        if (selectedUser != null) {
          paramKeys.customerId = selectedUser!.id;
        } else {
          paramKeys.customerId = customerId;
        }
      }}

      final emailsParams = <String, dynamic> {
        'includes[0]': ['createdBy'],
        'includes[1]': ['attachments'],
        'includes[2]': ['replies'],
        ...paramKeys.toJson()
      };

      Map<String, dynamic> response =  await EmailListingRepository().fetchEmailList(emailsParams);
      await setEmailLabelList();
     
      UserParamModel requestParams = UserParamModel(
        limit: 0,
        withSubContractorPrime: true
      );

      UserResponseModel userResponse = await SqlUserRepository().get(params: requestParams);

      userList = userResponse.data;

      setEmailsList(response);
      
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadMore = false;
      update();
    }
  }

  Future<void> setEmailLabelList() async {
    try {
      Map<String, dynamic> emailLabelParams = <String, dynamic> {
        'limit': '0',
        'with_unread_count': '1',
      };

      await  Future<void>.delayed(const Duration(milliseconds: 500));

      apiLabelList =  await EmailListingRepository().fetchLabelList(emailLabelParams);
    
      addLabelList(apiLabelList!);

    } catch(e){
      rethrow;
    }
    
  }

  getEmailsList(bool? withReply, int? labelId) async {
    try {
      paramKeys.withReply = withReply;
      paramKeys.labelId = labelId;

      final emailsParams = <String, dynamic>{
        'includes[0]': ['createdBy'],
        'includes[1]': ['attachments'],
        'includes[2]': ['replies'],
        ...paramKeys.toJson()
      };

      List<Map<String, dynamic>> response = (await Future.wait([EmailListingRepository().fetchEmailList(emailsParams)]));

      setEmailsList(response[0]);
    } catch (e) {
      rethrow;
    } finally {
      isLoadMore = false;
      isLoading = false;
      update();
    }
  }

  setEmailsList(Map<String, dynamic> response) {
    List<EmailListingModel> list = response['list'];

    PaginationModel pagination = response['pagination'];

    totalEmailLength = pagination.total!;

    if (!isLoadMore) {
      emailGroup = [];
      totalEmailCount = 0;
    }

    totalEmailCount += list.length;

    Helper.groupBy(list, (EmailListingModel email) {
      return DateTimeHelper.getLabelAccordingToDate(email.updatedAt.toString());
    }).forEach((key, value) {
      if(emailGroup.any((GroupEmailListingModel element) => element.groupName == key)) {
        emailGroup.last.groupValues.addAll(value);
      } else {
        emailGroup.add(
            GroupEmailListingModel(groupName: key, groupValues: value),
        );
      }
    });

    canShowLoadMore = totalEmailCount < totalEmailLength;
  }

  void addLabelList(Map<String, dynamic> response) {
    
    labelList = [];
    
    List<EmailLabelModel> list = response['list'];

    if(list.isNotEmpty) {

      labelList.add(JPSecondaryDrawerItem(slug: 'label', title: 'label'.tr.toUpperCase(), itemType: SecondaryDrawerItemType.label));

      for (var label in list) {
        labelList.add(
          JPSecondaryDrawerItem(
            slug: label.id.toString(),
            title: label.name ?? "",
            icon: Icons.label_outline,
            number: label.unreadCount
          )
        );
      }
    }
  }

  Future<void> loadMore() async {
    paramKeys.page += 1;
    isLoadMore = true;
    await getListAccordingToAction();
  }

  Future<void> refreshList({bool? showLoading, bool doRefreshDetailList = true}) async {

    paramKeys.page = 1;
    ///   show shimmer if showLoading = true
    isLoading = showLoading ?? false;
    update();
    if(selectedLabel != null){
      handleHeaderActions(selectedLabel!,isLoading: showLoading);
    }
    if(doRefreshDetailList) {
      emailDetailController?.refreshPage();
    }
  }

  Future<void> getListAccordingToAction() async {
    if(selectedLabel != null) {
      String id = selectedLabel!.id.toString();
      switch (id) {
        case '-1':
          await getEmailsList(true, null);
          break;
        case '-2':
          await getEmailsList(false, null);
          break;
        case '-3':
          await trashedList();
          break;
        default:
          await getEmailsList(true, selectedLabel!.id);
          break;
      }
    }
  }

  onSearchTextChanged(String text) async {
    paramKeys.keyword = text;
    paramKeys.page = 1;
    isLoading = true;
    isMultiSelectionOn = false;
    clearSelectedEmails();
    update();
    getListAccordingToAction();
  }

  inboxList() {
    isLoading = true;
    paramKeys.page = 1;
    getEmailsList(true, null);
    update();
  }

  sentList() {
    isLoading = true;
    paramKeys.page = 1;
    getEmailsList(null, null);
    update();
  }

  trashedList() async {
    try {
      paramKeys.withReply = null;
      final emailTrashedParams = <String, dynamic>{
        'includes[0]': ['createdBy'],
        'includes[1]': ['attachments'],
        "includes[2]": ['replies'],
        ...paramKeys.toJson()
      };

      List<Map<String, dynamic>> response = (await Future.wait([EmailListingRepository().emailTrashedList(emailTrashedParams)]));
      setEmailsList(response[0]);
    } catch (e) {
      rethrow;
    } finally {
      isLoadMore = false;
      isLoading = false;
      update();
    }
  }

  createLabel(String createNewLabel) async {
    final createNewLabelParams = <String, dynamic>{'name': createNewLabel};

    try {
      EmailLabelModel response = await EmailListingRepository().createNewLabel(createNewLabelParams);
      response.unreadCount = 0;
      labelList.add(JPSecondaryDrawerItem(
          slug: response.id.toString(),
          title: response.name.toString(),
          icon: Icons.label_outline,
          number: response.unreadCount
        ),
      );
      Get.back();
      Helper.showToastMessage('label_created'.tr);
      update();
    } catch (e) {
      Get.back();
      rethrow;
    }
  }

  void openCreateLabelDailog() {
    showJPGeneralDialog(child: (controller) {
      return JPQuickEditDialog(
        maxLength: 50,
        label: 'label_name'.tr,
        suffixTitle: 'create'.tr,
        errorText: 'label_name_is_required'.tr,
        disableButton: controller.isLoading,
        suffixIcon: controller.isLoading ? SpinKitThreeBounce(color: JPAppTheme.themeColors.base, size: 18) : null,
        autofocus: true,
        onSuffixTap: (value) async {
          controller.toggleIsLoading();
          await createLabel(value);
          controller.toggleIsLoading();
        });
    });
  }

  void handleHeaderActions(EmailLabelModel label, {bool? isLoading = true}) async {
    selectedLabel = label;
    isLoading = isLoading;
    paramKeys.page = 1;
    clearSelectedEmails();
    update();
    getListAccordingToAction();
  }

  emailListByUser(int selectedId) async {
    selectedUser = userList.firstWhereOrNull((user) => user.id == selectedId)!;
    paramKeys.withReply = null;
    paramKeys.users = selectedId;
    paramKeys.page = 1;
    isLoading = true;
    update();
    getListAccordingToAction().trackFilterEvents();
  }

  filterEmailListByUser() {
    showJPBottomSheet(child: (_) => JPSingleSelect(
      mainList: userList
          .map((user) => JPSingleSelectModel(
              child:JPProfileImage(src: user.profilePic, color: user.color, initial: user.intial,),
              id: user.id.toString(),
              label: user.groupId == UserGroupIdConstants.subContractorPrime ? '${user.fullName} (${'sub'.tr})' : user.fullName
              ))
          .toList(),
      selectedItemId: selectedUser!.id.toString(),
      inputHintText: 'search_user'.tr,
      title: 'select_user'.tr,
      onItemSelect: (value) {
        emailListByUser(int.parse(value));
        Get.back();
      }), isDismissible: true, enableDrag: false, isScrollControlled: true);
  }

  void onEmailChecked(int selectedGroupIndex, int selectedEmailIndex) async {
    isMultiSelectionOn = true;

    EmailListingModel selectedEmail = emailGroup[selectedGroupIndex].groupValues[selectedEmailIndex];
    selectedEmail.checked = !selectedEmail.checked;

    if (selectedEmail.checked) {
      selectedEmails.insert(selectedEmails.length, selectedEmail);
    } else {
      selectedEmails.remove(selectedEmail);
    }

    if (selectedEmails.isEmpty) {
      isMultiSelectionOn = false;
    }
    update();
  }

  clearSelectedEmails() async {
    if (selectedEmails.isNotEmpty) {
      for (var emailsDetails in emailGroup) {
        for (var email in emailsDetails.groupValues) {
          if (email.checked) {
            email.checked = false;
          }
        }
      }

      isMultiSelectionOn = false;
      selectedEmails = [];
      update();
      return true;
    }
    return false;
  }

  openQuickActionDialog() {
    bool isUnRead = selectedEmails.any((email) => !email.isRead!);

    showJPBottomSheet(child: (_) => JPQuickAction(
      mainList: getActionList(isUnRead),
      onItemSelect: (value) {
        switch (value) {
          case 'mark_as_read':
            changeReadState(true);         
            break;
          case 'mark_as_unread':
            changeReadState(false);
            break;
          case 'move_to':
            moveOpenDialog();
            break;
          case 'delete':
           showConfirmationForDeleteEmail(value);
            break;
          default:
        }
      },
    ), isScrollControlled: true);
  }

  getActionList(bool isUnRead) {
    
    List<JPQuickActionModel> actionList = [
    JPQuickActionModel(id: 'mark_as_read', label: 'mark_as_read'.tr.capitalize!, child: const JPIcon(Icons.drafts_outlined, size: 18)),
    JPQuickActionModel(id: 'mark_as_unread', label: 'mark_as_unread'.tr.capitalize!, child: const JPIcon(Icons.mail_outlined, size: 18)),
    JPQuickActionModel(id: 'move_to', label: 'move_to'.tr, child: const JPIcon(Icons.exit_to_app_outlined, size: 18)),
    JPQuickActionModel(id: 'delete', label: 'delete'.tr, child: const JPIcon(Icons.delete_outline, size: 18))];
    
    if(isUnRead){
      Helper.removeMultipleKeysFromArray(actionList, ['mark_as_unread']);
    } else {
      Helper.removeMultipleKeysFromArray(actionList, ['mark_as_read']);
    }
    if(selectedLabel!.id == -2) {
      Helper.removeMultipleKeysFromArray(actionList, ['move_to']);
    }
    if(selectedLabel!.id == -3) {
      Helper.removeMultipleKeysFromArray(actionList, [
        'mark_as_unread',
        'mark_as_read',
        'move_to'
      ]); 
    }
    return actionList;
  }

  showConfirmationForDeleteEmail(String value) {
    Get.back();
    String msg = "you_are_about_to_delete".tr;

    msg += ' ${selectedEmails.length.toString()} ' 'email';

    if (selectedEmails.length > 1) msg += 's';

    msg += '. Kindly confirm to proceed';

    showJPBottomSheet(child: (conrtoller) {
      return JPConfirmationDialog(
        icon: Icons.report_problem_outlined,
        title: "confirmation".tr,
        subTitle: msg,
        suffixBtnText: 'delete'.tr,
        disableButtons: conrtoller.isLoading,
        suffixBtnIcon: conrtoller.isLoading ? SpinKitThreeBounce(color: JPAppTheme.themeColors.base, size: 20) : null,
        onTapSuffix: () async {
          conrtoller.toggleIsLoading();
          await deleteEmails(value).trackDeleteEvent(MixPanelEventTitle.emailDelete);
          conrtoller.toggleIsLoading();
        },
      );
    });
  }

  void changeReadState(bool isRead) async {    
    Get.back();
    showJPLoader();
    List<int?> ids = selectedEmails.map((email) => email.id).toList();
    final changeReadStateParams = <String, dynamic>{'email_ids[]': ids, 'is_read': isRead ? 1 : 0};

    try {
      await Future.wait([
        EmailListingRepository().changeReadState(changeReadStateParams),
        setEmailLabelList(),
      ]);
       
      Get.back();
      if(isRead) {
        Helper.showToastMessage('marked_as_read'.tr);
      } else {
        Helper.showToastMessage('marked_as_unread'.tr);
      }
      for(var emailGroup in emailGroup) {
        for (var element in emailGroup.groupValues) {
          if (ids.contains(element.id)) {
            element.isRead = isRead;
          }
        }
      }
      clearSelectedEmails();
    } catch (e) {
      Get.back();
      rethrow;
    } finally {
      update();
    }
  }

  Future<void> deleteEmails(String markUnreadValue) async {
    if (selectedEmails.isEmpty) return;

    List<int?> ids = selectedEmails.map((email) {
      if(email.id == selectedEmailId) {
        // removing selection on email delete
        selectedEmailId = null;
        Get.splitPop();
      }
      return email.id;
    }).toList();
    final deleteEmailParams = <String, dynamic>{'force': 0, 'ids[]': ids};

    try {
      await Future.wait([
      EmailListingRepository().deleteEmail(deleteEmailParams),
      setEmailLabelList(),
      ]);
      Get.back();
      Helper.showToastMessage('deleted'.tr);
      handleHeaderActions(selectedLabel!);
    } catch (e) {
      Get.back();
      rethrow;
    }
  }

  moveOpenDialog() {
    
    Get.back();

    List<JPQuickActionModel> mainList = [];

    for (JPSecondaryDrawerItem label in labelList) {
      if(label.slug != 'label') {
        mainList.add(JPQuickActionModel(label: label.title.toString(), id: label.slug.toString(), child: const JPIcon(Icons.label_outline, size: 20)));
      }
    }
    if(selectedLabel?.id != -1) {
      mainList.insert(0, JPQuickActionModel(label: 'inbox'.tr, id: '-1', child: const JPIcon(Icons.email_outlined, size: 20)));
    }

    showJPBottomSheet(child: (_) =>
        JPQuickAction(
          mainList: mainList,
              title: "move_to".tr,
          onItemSelect: (value) {
            if(value == '-1'){
              removeLabel();
            } else {
              moveTOEmails(int.parse(value));
            }
            showJPLoader();
          },
        ),
        isScrollControlled: true);
  }

  void removeLabel() async {
    isLoading = true;
    List<String?> threadIds = selectedEmails.map((email) => email.threadId).toList();
    final removeLabelParams = <String, dynamic>{'thread_ids[]': threadIds};
   try {
      await Future.wait([
        EmailListingRepository().removeLabel(removeLabelParams),
        setEmailLabelList(),
      ]);
      
      Get.back();
      Helper.showToastMessage('emails_moved'.tr);
      handleHeaderActions(selectedLabel!);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
      update();
    }

  }

  moveTOEmails(int selectedLabelId) async {
    isLoading = true;
    List<String?> threadIds = selectedEmails.map((email) => email.threadId).toList();
    final moveEmailParams = <String, dynamic>{'thread_ids[]': threadIds, 'label_id': selectedLabelId};

    try {
      await Future.wait([
        EmailListingRepository().moveToEmail(moveEmailParams),
        setEmailLabelList(),
      ]);
      Get.back();
      Helper.showToastMessage('emails_moved'.tr);
      handleHeaderActions(selectedLabel!);
      Get.back();
    } catch (e) {
      Get.back();
      rethrow;
    } finally {
      update();
    }
  }

  isReadTrue(int? id) {
    for(var emailGroup in emailGroup) {
      for (var element in emailGroup.groupValues) {
        if (id == element.id) {
          element.isRead = true;
        }
      }
    }
    update();
  }

  String showFirstLetterOfEmail(EmailListingModel email){
    return jobId == null ?
    selectedLabel!.name == 'sent'
        ? email.to!.map((e) => Helper.getEmailTo(e[0])).first.toUpperCase()
        : selectedLabel!.name == 'trash'
        ? (email.from != null || email.to != null && email.to!.isNotEmpty
        ? email.to!.isNotEmpty
        ? email.to!.map((e) => Helper.getEmailTo(e[0])).first.toUpperCase()
        : email.from![0].toUpperCase()
        : email.from![0].toUpperCase())
        .toString()
        : email.from![0].toUpperCase()
        :  email.to!.map((e) => Helper.getEmailTo(e[0])).first.toUpperCase();
  }

  String showEmailListWithThreeDots(EmailListingModel email){
    if (jobId == null) {
      switch (selectedLabel!.id) {
        case -1:
          return Helper.getEmailTo(email.from!.replaceAll(RegExp('\\.'), ' ').capitalize.toString());
        case -2:
          return 'To: ${email.to!.map((e) => Helper.getEmailTo(e.replaceAll(RegExp('\\.'), ' ').capitalize.toString())).join(', ')}';
        case -3:
          return ((email.to!.map((e) => Helper.getEmailTo(e.replaceAll(RegExp('\\.'), ' ').capitalize.toString())).join(', ')) +
            (', ') + (Helper.getEmailTo(email.from!.replaceAll(RegExp('\\.'), ' ').capitalize.toString())));
        
        default:
          return Helper.getEmailTo(email.from!.replaceAll(RegExp('\\.'), ' ').capitalize.toString());
      }  
    } else {
      return email.to!.map((e) => Helper.getEmailTo(e.replaceAll(RegExp('\\.'), ' ').capitalize.toString())).join(', ');
    }
  }

  void getJob() async {
    try {
      final jobsCountParams = <String, dynamic>{
        'id': jobId,
        'includes[0]': ['count:with_ev_reports(true)'],
        'includes[1]': ['job_message_count'],
        'includes[2]': ['upcoming_appointment_count'],
        'includes[3]': ['Job_note_count'],
        'includes[4]': ['job_task_count'],
        'includes[5]': ['upcoming_appointment'],
        'includes[6]': ['workflow'],
        'incomplete_task_lock_count': 1,
        'track_job': 1
      };
      if(jobId != null){
        job = (await JobRepository.fetchJob(jobId!, params: jobsCountParams))['job'];
      }
    
    } catch (e) {
      rethrow;
    } finally {
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    jobId = Get.arguments == null ? null : Get.arguments[NavigationParams.jobId];
    getLoggedInData();
    selectedLabel = jobId == null ? parseToEmailLabelModel(customLabelList.first): null;
    controllerTag = 'email-$jobId';
    getAll();
    getJob();
  }

  EmailLabelModel parseToEmailLabelModel(JPSecondaryDrawerItem item) {
    return EmailLabelModel(
      id: int.parse(item.slug),
      icon: item.icon,
      name: item.title,
    );
  }

  void onTapDrawerItem(JPSecondaryDrawerItem item) {
    if(selectedLabel?.id.toString() == item.slug) return;
    handleHeaderActions(parseToEmailLabelModel(item));
  }

  void onTapDrawerAction(JPSecondaryDrawerItem item) {
    if(item.slug == 'create_label') {
      openCreateLabelDailog();
    }
  }

  void handleChangeJob(int id){
    jobId = id;
    getJob();
    refreshList(showLoading: true);
  }

  void setUpDrawerKeys() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    secondaryDrawerKey = GlobalKey<ScaffoldState>();
  }

  Future<void> onTapEmail(int index, int tappedIndex) async {
    
    if (isMultiSelectionOn) {
      onEmailChecked(index, tappedIndex);
      return;
    }

    final tappedEmailId = emailGroup[index].groupValues[tappedIndex].id;
    selectedAvatarColor = ColorHelper.companyContactAvatarColors[(tappedIndex % 8)];
    isReadTrue(tappedEmailId);

    if(tappedEmailId == selectedEmailId) return;
    
    // Adding additional arguments in existing arguments
    Helper.addArguments({'tapped_email_id' : tappedEmailId!});
    selectedEmailId = tappedEmailId;
    update();
    await Get.toSplitNamed(
      Routes.emailDetailView,
      onSplitExit: (result) {
        selectedEmailId = selectedAvatarColor = null;
        if (Helper.isTrue(result)) {
          refreshList(showLoading: true);
        }
      },
      itemSelectedBeforeNavigation: selectedEmailId != null,
    );
    update();
  }

  // handleOnEmailSent(): helps in refreshing list & updating selected email id
  void handleOnEmailSent(int id) {
    selectedEmailId = id;
    emailDetailController?.updateContent(id);
    refreshList(doRefreshDetailList: false);
  }

  Future<bool> onWillPop() async {
    final isEmailOpen = selectedEmailId != null;

    if(isEmailOpen) {
      selectedEmailId = null;
      Get.splitPop();
      update();
    }

    return !isEmailOpen;
  }
}
