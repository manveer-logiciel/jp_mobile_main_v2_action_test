import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/company_contact_form_type.dart';
import 'package:jobprogress/common/enums/secondary_drawer.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/company_contacts/company_contacts_param.dart';
import 'package:jobprogress/common/models/group_company_contacts_model.dart';
import 'package:jobprogress/common/models/secondary_drawer_item.dart';
import 'package:jobprogress/common/models/sql/tag/tag.dart';
import 'package:jobprogress/common/repositories/company_contacts.dart';
import 'package:jobprogress/common/repositories/tag.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/color_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/company_contacts/listing/selected_contact_list_item.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/index.dart';

class CompanyContactListingController extends GetxController {
  List<CompanyContactListingModel> companyContacts = [];
  List<GroupCompanyContactListingModel> companyContactsGroup = [];
  List<CompanyContactListingModel> selectedContacts = [];

  final animatedScrollKey = GlobalKey<AnimatedListState>();

  FocusNode dialogFoucsNode = FocusNode();

  List<TagModel> tagList = [];
  double deviceWidth = 0;
  double listWidth = 0;
  bool isLoading = true;
  bool isSelectedListHasElement = false;
  bool isLoadMore = false;
  bool canShowLoadMore = false;
  int totalContactLength = 0;
  int allContactLength = 0;

  bool isMultiSelectionOn = false;
  bool countSearchLength = false;
  bool isForJobContactFormSelection = false; // used for fill up job contact person form after select contact

  TagModel? activeTag;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  CompanyContactListingParamModel paramkeys = CompanyContactListingParamModel();
  double maxScrollPosition = 0;

  List<JPSecondaryDrawerItem> drawerItems = [];

  List<JPSecondaryDrawerItem> drawerActions = [
    JPSecondaryDrawerItem(slug: 'create_group', title: 'create_group'.tr.toString(), number: 0, icon: Icons.add, itemType: SecondaryDrawerItemType.action)
  ];

//Getting companyContactsParams and tagsParams to send in Company contact listing api
  Future<void> getAll() async {
    try {
      if (RunModeService.isUnitTestMode) return;
      final companyContactsParams = <String, dynamic>{
        'includes[0]': ['tag'],
        'includes[1]': ['emails'],
        "includes[2]": ['phones'],
        "includes[3]": ["address"],
        ...paramkeys.toJson()
      };

      if (activeTag != null) {
        companyContactsParams["tag_ids[0]"] = activeTag!.id;
      } else {
        companyContactsParams.remove("tag_ids[0]");
      }

      final tagsParams = <String, dynamic>{
        'includes[0]': ['counts'],
        'includes[1]': ['users'],
        'limit': 0,
        'type': 'contact'
      };

      List<Map<String, dynamic>> response = (await Future.wait([
        CompanyContactsListingRepository().fetchCompanyContactsList(companyContactsParams),
        TagRepository().fetchTagsList(tagsParams),
      ]));

      setCompanyContactList(response[0]);
      setTagList(response[1]);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadMore = false;
      update();
    }
  }

  getCompanyContactList() async {
    if (RunModeService.isUnitTestMode) return;
    try {
      final companyContactsParams = <String, dynamic>{
        'includes[0]': ['tag'],
        'includes[1]': ['emails'],
        "includes[2]": ['phones'],
        "includes[3]": ["address"],
        ...paramkeys.toJson()
      };

      if (paramkeys.tagId != null) {
        companyContactsParams["tag_ids[0]"] = paramkeys.tagId;
        companyContactsParams.remove("tag_id");
      }

      Map<String, dynamic> response = await CompanyContactsListingRepository().fetchCompanyContactsList(companyContactsParams);

      setCompanyContactList(response);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadMore = false;
      update();
    }
  }

  String getTitleText(){
    String count = totalContactLength == 0 ? '' : '(${totalContactLength.toStringAsFixed(0)})';
    
    if(selectedContacts.isEmpty) {
      
      if(activeTag == null) {
        return 'all_contacts'.tr + count;
      } 
    
      return '${activeTag!.name.toUpperCase()}' ' ${isLoading == false ? count : ''}';
    
    }
      
    if(activeTag == null) {
      return '${'all_contacts'.tr} (${selectedContacts.length.toStringAsFixed(0)} ${'selected'.tr})';
    }

    return '${activeTag!.name.toUpperCase()} (${selectedContacts.length.toStringAsFixed(0)} ${'selected'.tr})';
  }

  setCompanyContactList(Map<String, dynamic> response) {
    List<CompanyContactListingModel> list = response['list'];

    if(paramkeys.tagId == null) {
      allContactLength = response['pagination']['total'];
    }

    totalContactLength = response['pagination']['total'];

    if (!isLoadMore) {
      companyContacts = [];
    }

    companyContacts.addAll(list);

    companyContactsGroup = [];

    if (selectedContacts.isNotEmpty) {
      for (CompanyContactListingModel contact in companyContacts) {
        int index = selectedContacts.indexWhere((element) => element.id == contact.id);
        if (index != -1) contact.checked = true;
      }
    }

    // company contctlist changed in grouping list by groupBy function
    Helper.groupBy(companyContacts, (CompanyContactListingModel contact) {
      return contact.firstName![0].toString().toUpperCase();
    }).forEach((key, value) => companyContactsGroup.add(GroupCompanyContactListingModel(groupName: key, groupValues: value)));
    
    canShowLoadMore = companyContacts.length < totalContactLength;
  }

  void setTagList(Map<String, dynamic> response) {
    tagList = response['list'];
     drawerItems = [
      JPSecondaryDrawerItem(slug: 'all_contacts', title: 'all_contacts'.tr.capitalize.toString(), number: 0, icon: Icons.contacts)
    ];
    drawerItems.first.number = allContactLength;
    if(tagList.isNotEmpty) {
      drawerItems.add(
        JPSecondaryDrawerItem(
            slug: 'group_label',
            title: 'groups'.tr.toUpperCase(),
            itemType: SecondaryDrawerItemType.label
        ),
      );
      for (var tag in tagList) {
        drawerItems.add(
          JPSecondaryDrawerItem(
              icon: Icons.label_outline,
              slug: tag.id.toString(),
              title: tag.name.toString(),
              number: tag.counts?.companyContactCount ?? 0,
          )
        );
      }
    }
  }

  void loadMore() {
    paramkeys.page += 1;
    isLoadMore = true;
    update();
    getCompanyContactList();
  }

  Future<void> refreshList({ bool? showLoading }) async {
    paramkeys.page = 1;
    isLoading = showLoading ?? false;
    update();
    await getCompanyContactList();
  }

  onSearchTextChanged(String text) async {
    paramkeys.name = text;
    paramkeys.page = 1;
    isLoading = true;
    update();
    getCompanyContactList();
  }

  void adjustSelectedListContainerHeight() {
    isSelectedListHasElement = !isSelectedListHasElement;
    update();
  }

  void getWidth() {
    final RenderBox? box = getRenderObject(animatedScrollKey);
     if(box!=null){
       listWidth = box.size.width;
     }
  }

   RenderBox? getRenderObject(GlobalKey key) {
    if(key.currentContext == null) return null;
    return key.currentContext!.findRenderObject() as RenderBox?;
  }
  

  Future<void> onContactChecked(int selectedGroupIndex, int selectedContactIndex) async {
    isMultiSelectionOn = true;

    CompanyContactListingModel selectedContact = companyContactsGroup[selectedGroupIndex].groupValues[selectedContactIndex];
    selectedContact.checked = !selectedContact.checked;

    if (selectedContact.checked) {
      selectedContact.color = ColorHelper.companyContactAvatarColors[selectedContactIndex % 8];
      selectedContacts.insert(selectedContacts.length, selectedContact);
      
      getWidth();
      
      if(listWidth > deviceWidth * 0.83){
        scrollForwardList();
      }

      if (selectedContacts.length == 1) {
        adjustSelectedListContainerHeight();
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      if(!RunModeService.isUnitTestMode) {
        animatedScrollKey.currentState!.insertItem(selectedContacts.length - 1, duration: const Duration(milliseconds: 200));
      }
    } else {
      int alreadySelectedIndex = selectedContacts.indexWhere((element) => element.id == selectedContact.id);
      if (alreadySelectedIndex != -1) {

        final item = selectedContacts.removeAt(alreadySelectedIndex);
        if(!RunModeService.isUnitTestMode) {
          animatedScrollKey.currentState!.removeItem(alreadySelectedIndex, (context, animation) => CompanyContactSelectedContactItem(controller: this, item:item, animation: animation),
          duration: const Duration(milliseconds: 200));
        }
        
        if (selectedContacts.isEmpty) {
          await Future<void>.delayed(const Duration(milliseconds: 200));
          adjustSelectedListContainerHeight();
        }
      }
    }

    if (selectedContacts.isEmpty) {
      isMultiSelectionOn = false;
    }
    update();
  }

  void removeSelectedContact(CompanyContactListingModel selectedContact) async{
    for (GroupCompanyContactListingModel contactDetalis in companyContactsGroup) {
      for (CompanyContactListingModel contact in contactDetalis.groupValues) {
        if (selectedContact.id == contact.id) {
          contact.checked = !contact.checked;

          int alreadySelectedIndex = selectedContacts.indexWhere((element) => element.id == selectedContact.id);

          if (alreadySelectedIndex != -1) {
            final item = selectedContacts.removeAt(alreadySelectedIndex);
            animatedScrollKey.currentState!.removeItem(alreadySelectedIndex, (context, animation) => CompanyContactSelectedContactItem(controller: this, item: item, animation: animation),
            duration: const Duration(milliseconds: 130));

            if (selectedContacts.isEmpty) {
              await Future<void>.delayed(const Duration(milliseconds: 100));
              adjustSelectedListContainerHeight();
            }

          }
        }
      }
    }

    if (selectedContacts.isEmpty) {
      isMultiSelectionOn = false;
    }

    update();
  }

 clearSelectedContact() async{
    if (selectedContacts.isNotEmpty) {
        for (var i = 0; i <= selectedContacts.length - 1; i++) {
          animatedScrollKey.currentState!.removeItem(0,(BuildContext context, Animation<double> animation) {
           return Container();
          });
        } 
      selectedContacts = [];
      for (var contactDetalis in companyContactsGroup) {
        for (var contact in contactDetalis.groupValues) {
          if (contact.checked) {
            contact.checked = false;
          }
        }
      }

      isMultiSelectionOn = false;
      await Future<void>.delayed(const Duration(milliseconds: 100));
      adjustSelectedListContainerHeight();
      update();
      return true;
    }

    return false;
  }

  Future<void> scrollForwardList() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if( scrollController.position.maxScrollExtent > 0) {
      maxScrollPosition = scrollController.position.maxScrollExtent;
      scrollController.animateTo(maxScrollPosition, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      maxScrollPosition = scrollController.position.maxScrollExtent;
      scrollController.animateTo(maxScrollPosition, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }


  scrollOnRemoved(){
    scrollController.animateTo(maxScrollPosition, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  filterContactBytag(TagModel selectedTag) {
    isLoading = true;
    paramkeys.page = 1;
    update();
    
    activeTag = selectedTag;
    paramkeys.tagId = selectedTag.id;
    clearSelectedContact();
    getCompanyContactList();
  }

  getAllContacts() {
    activeTag = null;
    paramkeys.tagId = null;
    paramkeys.page = 1;
    getAll();
  }

  Future<void> deleteContact() async {
    if (selectedContacts.isEmpty) return;

    try {
      List<int?> ids = selectedContacts.map((element) => element.id).toList();

      final companyContactsIdParams = <String, dynamic>{'ids[]': ids};

      await CompanyContactsListingRepository().deteleCompanyContact(companyContactsIdParams);
      isMultiSelectionOn = false;
      paramkeys.page = 1;
      Get.back();
      selectedContacts.length == 1 ? Helper.showToastMessage('company_contact_deleted'.tr) : Helper.showToastMessage('company_contacts_deleted'.tr);
      clearSelectedContact();
      getAll();
    } catch (e) {
      Get.back();
      rethrow;
    } finally {
    }
  }

  removeFromGroup() async {
    isLoading = true;
    if (selectedContacts.isEmpty || activeTag == null) {
      return;
    }
    try {
      List<int?> ids = selectedContacts.map((element) => element.id).toList();
      final removeGroupPramas = <String, dynamic>{
        'contact_ids[]': ids,
        'tag_ids[0]': [activeTag!.id]
      };

      await CompanyContactsListingRepository().removeFromGroup(removeGroupPramas);

      isMultiSelectionOn = false;
      clearSelectedContact();
      paramkeys.page = 1;
      Helper.showToastMessage('contact_removed_from_group'.tr);
      getAll();
      update();
    } catch (e) {
      rethrow;
    }
  }

  addSelectedIntoGroup(List<JPMultiSelectModel> selected) async {
    List<String> tagIds = selected.where((tag) => tag.isSelect).map((tag) => tag.id).toList();
    
    List<int?> contactIds = selectedContacts.map((contacct) => contacct.id).toList();
    
    if (contactIds.isEmpty || tagIds.isEmpty) {
      return;
    }

    try {
      final addGroupPramas = <String, dynamic>{'contact_ids[]': contactIds, 'tag_ids[]': tagIds};

      await CompanyContactsListingRepository().addToGroup(addGroupPramas);

      isMultiSelectionOn = false;


      clearSelectedContact();

      paramkeys.page = 1;
      Get.back(); //Closing dailog

      Helper.showToastMessage('contact_added_to_group'.tr);

      getAll();
    } catch (e) {
      Get.back(); //Closing dailog
      rethrow;
    } finally {
    }
  }

  renameGroup(String tagName) async {
    try {
      final renameGroupPramas = <String, dynamic>{'id': activeTag!.id, 'name': tagName, 'type': 'contact'};

      await CompanyContactsListingRepository().renameGroup(renameGroupPramas);


      int index = tagList.indexWhere((element) => element.id == activeTag!.id);

      tagList[index].name = tagName;

      activeTag!.name = tagName;

      int drawerIndex = drawerItems.indexWhere((element) => element.slug == activeTag!.id.toString());
      
      drawerItems[drawerIndex].title = tagName;
      
      paramkeys.page = 1;

      Get.back();
      Helper.showToastMessage('group_updated'.tr);
    } catch (e) {
      Get.back();
      rethrow;
    }
  }

  deleteGroup() async {
    update();
    try {
      final deleteGroupPramas = <String, dynamic>{'id': activeTag!.id, 'type': 'contact'};
      await CompanyContactsListingRepository().deleteGroup(deleteGroupPramas);
      getAllContacts();
      Helper.showToastMessage('group_deleted'.tr);
    } catch (e) {
       rethrow;
    } finally {
      Get.back();
    }
  }


  createGroup(String groupName) async {
    final createGroupPramas = <String, dynamic>{
      'name': groupName, 
      'type': 'contact'
    };

    try {
      TagModel response = await CompanyContactsListingRepository().createGroup(createGroupPramas);
      tagList.add(response);
      drawerItems.add(
          JPSecondaryDrawerItem(
            icon: Icons.label_outline,
            slug: response.id.toString(),
            title: response.name.toString(),
            number: response.counts?.companyContactCount ?? 0,
          )
      );
      Get.back();
      Helper.showToastMessage('group_saved'.tr);
    } catch (e) {
      Get.back();
      rethrow;
    }
  }

  void openCreateGroupDailog() async {
    showJPGeneralDialog(child: (controller) {
      return JPQuickEditDialog(
        maxLength: 50,
        label: 'group_name'.tr,
        suffixTitle: 'create'.tr,
        focusNode: dialogFoucsNode,
        errorText: 'group_name_is_required'.tr,
        disableButton: controller.isLoading,
        suffixIcon: showJPConfirmationLoader(show: controller.isLoading),
        onSuffixTap: (value) async {
          controller.toggleIsLoading();
          await createGroup(value);
          controller.toggleIsLoading();
        }
      );
    });

    await Future<void>.delayed(const Duration(milliseconds: 500));

    dialogFoucsNode.requestFocus();
  }

  void handleHeaderActions(String action) async {
    switch (action) {
      case 'delete_group':

      String msg = "you_are_about_to_delete_this_group".tr;
    showJPBottomSheet(child: (controller) {
      return JPConfirmationDialog(
        icon: Icons.report_problem_outlined,
        title: "confirmation".tr,
        subTitle: msg,
        suffixBtnText: 'delete'.tr,
        disableButtons: controller.isLoading,
        suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading ),
        onTapSuffix: () async {
          controller.toggleIsLoading();
          await deleteGroup();
          controller.toggleIsLoading();
        },
      );
    });
        break;
       
      case 'delete_contacts':
        String msg = "are_you_sure_you_want_to_delete".tr;

        msg += ' ${selectedContacts.length.toString()} ${'contact'.tr}';

        if(selectedContacts.length > 1) msg += 's';

        msg += '?';

        showJPBottomSheet(child: (controller) {
          return JPConfirmationDialog(
            icon: Icons.report_problem_outlined,
            title: "confirmation".tr,
            subTitle: msg,
            suffixBtnText: 'delete'.tr,
            disableButtons: controller.isLoading,
            suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading ),
            onTapPrefix: () {
              Get.back();
            },
            onTapSuffix: () async {
              controller.toggleIsLoading();
              await deleteContact().trackDeleteEvent(MixPanelEventTitle.contactDelete);
              controller.toggleIsLoading();
            },
          );
        });
        break;

      case 'add_to_group':
        showJPBottomSheet(
         child:(controller)  {
              return JPMultiSelect(
                disableButtons: controller.isLoading,
                inputHintText: 'search'.tr,
                title: 'groups'.tr,
                doneIcon: showJPConfirmationLoader(show: controller.isLoading),
                mainList: tagList.map((e) => JPMultiSelectModel(id: e.id.toString(), label: e.name.toString(), isSelect: false)).toList(),
                onDone: (List<JPMultiSelectModel> selected) async {
                  controller.toggleIsLoading();
                  await addSelectedIntoGroup(selected);
                  controller.toggleIsLoading();
                },
              );
            },
          isScrollControlled: true
        );
        break;
      
      case 'remove_from_group':
        removeFromGroup();
        break;

      case 'rename_group':
        showJPGeneralDialog(child: (controller) {
          return JPQuickEditDialog(
            label: 'group_name'.tr,
            maxLength: 50,
            suffixTitle: 'update'.tr,
            disableButton: controller.isLoading,
            suffixIcon: showJPConfirmationLoader(show: controller.isLoading),
            focusNode: dialogFoucsNode,
            errorText: 'this_field_is_required'.tr,
            fillValue: activeTag!.name,
            onSuffixTap: (value) async {
              controller.toggleIsLoading();
              await renameGroup(value);
              controller.toggleIsLoading();
            }
          );
        });

        await Future<void>.delayed(const Duration(milliseconds: 400));
        dialogFoucsNode.requestFocus();
        break;
    }
  }

  @override
  void onInit() {
    super.onInit();
    isForJobContactFormSelection = Get.arguments?[NavigationParams.isForJobContactFormSelection] ?? false;
    getAll();
  }

  void onTapDrawerItem(JPSecondaryDrawerItem item) {
    switch (item.slug) {
      case 'all_contacts':
        getAllContacts();
        break;
      default:
        filterContactBytag(
          TagModel(
            id: int.parse(item.slug),
            name: item.title.toString()
          )
        );
        break;
    }
  }

  void onTapDrawerAction(JPSecondaryDrawerItem item) {
    switch (item.slug) {
      case 'create_group':
        openCreateGroupDailog();
        break;
      default:
        break;
    }
  }

  Future<void> navigateToCreateCompanyContact() async{
    final result = await Get.toNamed(Routes.createCompanyContact, arguments: {
      NavigationParams.pageType: CompanyContactFormType.createForm,
    });
    if(result != null && result["status"]) {
      refreshList(showLoading: true);
    }
  }

}
