import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/files_listing/delivery_date.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/files_listing/work_order_assigned_user.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/sql/tag/tag.dart';
import 'package:jobprogress/common/models/sql/tag/tag_param.dart';
import 'package:jobprogress/common/models/sql/tag/tag_response.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/sql/user/user_param.dart';
import 'package:jobprogress/common/models/sql/user/user_response.dart';
import 'package:jobprogress/common/repositories/sql/tag.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/repositories/sql/user.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/files_listing/expires_on/index.dart';
import 'package:jobprogress/common/services/files_listing/mark_as_favourite/index.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_handlers.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_helpers.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_repo/index.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_repo/work_order_repo.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions_list.dart';
import 'package:jobprogress/common/services/files_listing/set_view_delivery_date/index.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/user_roles.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/multi_select_helper.dart';
import 'package:jobprogress/core/utils/upgrade_plan_helper.dart';
import 'package:jobprogress/global_widgets/add_signature_dialog/index.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/share_via_jobprogress/controller.dart';
import 'package:jobprogress/global_widgets/share_via_jobprogress/index.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jobprogress/modules/files_listing/widgets/file_info.dart';
import 'package:jobprogress/modules/files_listing/widgets/index.dart';
import 'package:jobprogress/modules/worksheet/widgets/default_setting_selector/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/tag_modal.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/position.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../core/constants/navigation_parms_constants.dart';
import '../../../global_widgets/select_supplier_branch/index.dart';
import '../../../modules/worksheet/widgets/integrated_supplier_deactivate/index.dart';
import '../../enums/supplier_form_type.dart';
import '../../models/forms/worksheet/supplier_form_params.dart';
import '../../models/suppliers/beacon/default_branch_model.dart';

// FilesListQuickActionPopups contains all the popups/bottom sheet/dialogs
// that will be displayed on clicking on quick action
class FilesListQuickActionPopups{

  // Below comment applies to all functions inside FilesListQuickActionPopups

  // Parameters : params[required] , action[required if present], arguments[optional if present]
  // 1.) params - it will contain all the data on which quick action is to be performed
  // 2.) action - it is being used here as a differentiator so that same function (e.g. showConfirmationBottomSheet())
  //              sheet can be used for multiple quick actions
  // 3.) arguments - It can be used to pass some additional data

  static void showConfirmationBottomSheet(FilesListingQuickActionParams params, FLQuickActions action, [Map<String, dynamic>? arguments]){
    showJPBottomSheet(
      child: (controller) {
        return
          JPConfirmationDialog(
            icon: Icons.warning_amber_outlined,
            title: 'confirmation'.tr,
            suffixBtnText: action == FLQuickActions.delete ? 'delete'.tr : 'confirm'.tr.toUpperCase(),
            subTitle: FileListingQuickActionHelpers.getConfirmationMessage(params, action, arguments),
            disableButtons: controller.isLoading,
            suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
            onTapSuffix: () async {
              controller.toggleIsLoading();
              await confirmationToAction(params, action, arguments);
              controller.toggleIsLoading();
            },
          );
      },
    );
  }

  static void showConfirmationBottomSheetWithSwitch(FilesListingQuickActionParams params, FLQuickActions action, [Map<String, dynamic>? arguments]){
    showJPBottomSheet(
      child: (controller) {
        return JPConfirmationDialogWithSwitch(
          title: 'confirmation'.tr.toUpperCase(),
          subTitle: FileListingQuickActionHelpers.getConfirmationMessage(params, action, arguments),
          toggleTitle: 'thank_you_email'.tr,
          toggleValue: controller.switchValue,
          suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
          disableButtons: controller.isLoading,
          suffixBtnText: controller.isLoading ? '' : 'yes'.tr.toUpperCase(),
          onSuffixTap: (val) async {
            arguments!.addAll({'switch_value' : Helper.isTrueReverse(val)});
            controller.toggleIsLoading();
            await confirmationToAction(params, action, arguments);
            controller.toggleIsLoading();
          },
        );
      },
    );
  }

  static Future<void> showTextAreaDialog(FilesListingQuickActionParams params, FLQuickActions action, [Map<String, dynamic>? arguments]) async{

    FocusNode noteDialogFocusNode = FocusNode();

    showJPGeneralDialog(
      isDismissible: false,
      child: (controller){
        return JPQuickEditDialog(
          position: JPQuickEditDialogPosition.center,
          type: JPQuickEditDialogType.textArea,
          label: 'note'.tr,
          title: 'add_note'.tr.toUpperCase(),
          suffixTitle: 'save'.tr,
          prefixTitle: 'cancel'.tr,
          maxLength: 500,
          focusNode: noteDialogFocusNode,
          fillValue: params.fileList.first.note,
          onPrefixTap: (val){
            Get.back();
          },
          disableButton: controller.isLoading,
          suffixIcon: showJPConfirmationLoader(show: controller.isLoading),
          onSuffixTap: (newNote) async{
            controller.toggleIsLoading();
            await confirmationToAction(params, action, {'newNote' : newNote});
            controller.toggleIsLoading();
          },
        );
      },
    );

    await Future<void>.delayed(const Duration(milliseconds: 400));

    noteDialogFocusNode.requestFocus();
  }
  
  static Future<void> showRenameDialog(FilesListingQuickActionParams params, FLQuickActions action) async {
    if(action == FLQuickActions.makeACopy) {
      bool showUpgradePlanDialog = await UpgradePlanHelper.showUpgradePlanOnDocumentLimit();
      if(showUpgradePlanDialog){
        return;
      }  
    }
    
    FocusNode renameDialogFocusNode = FocusNode();

    showJPGeneralDialog(
        child: (controller){
          return JPQuickEditDialog(
            type: JPQuickEditDialogType.inputBox,
            title: action ==  FLQuickActions.makeACopy ?  'make_a_copy'.tr.toUpperCase() : 'rename'.tr.toUpperCase() ,
            label: params.fileList.first.isDir == 1 ? 'folder_name'.tr : 'file_name'.tr,
            suffixIcon: showJPConfirmationLoader(show: controller.isLoading),
            errorText: 'name_is_required'.tr,
            disableButton: controller.isLoading,
            fillValue: params.fileList.first.name!.trim(),
            onSuffixTap: (val) async{
              controller.toggleIsLoading();
              await typeToRename(params, action, val);
              controller.toggleIsLoading();
            },
            focusNode: renameDialogFocusNode,
            suffixTitle: controller.isLoading ? '' : getDialogButtonText(action),
            maxLength: 50,
          );
        });

    await Future<void>.delayed(const Duration(milliseconds: 400));

    renameDialogFocusNode.requestFocus();
  }

  static String getDialogButtonText(FLQuickActions action) {
    if(action == FLQuickActions.makeACopy) {
      return 'create'.tr.toUpperCase();
    } 
    return 'rename'.tr.toUpperCase();
  }

  static void showMoveFilePopUp(FilesListingQuickActionParams params) {

    showJPBottomSheet(
      child: (_) => GetBuilder<FilesListingController>(
        init: FilesListingController(
            mode: FLViewMode.move,
            jobIdParam: params.jobModel?.id,
            typeParam: params.type
        ),
        global: false,
        builder: (FilesListingController controller) {
          return JPSafeArea(
            bottom: false,
            child: FilesView(
              controller: controller,
              onTapMove: () async {
                controller.toggleIsMovingFile();
                await FileListQuickActionHandlers.move(params,
                    dirId: controller.getSelectedDirID()
                );
                controller.toggleIsMovingFile();
              },
            ),
          );
        },
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  static void showShareFilePopUp(FilesListingQuickActionParams params) {

    showJPBottomSheet(
      child: (_) => GetBuilder<FilesListingController>(
        init: FilesListingController(
            mode: FLViewMode.copy,
            jobIdParam: params.jobModel?.id,
            typeParam: params.type,
            attachJobId: params.jobModel?.id,
            attachType: params.type
        ),
        global: false,
        builder: (FilesListingController controller) {
          return JPSafeArea(
            bottom: false,
            child: FilesView(
              controller: controller,
              onTapAttach: (_) async {
                controller.uploadFile(filePaths: params.sharedFilesPath, selectedFolderId: controller.getSelectedDirID());
                params.onActionComplete(FilesListingModel(), FLQuickActions.copyToJob);
              },
            ),
          );
        },
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  /// Shows a bottom sheet dialog to share files via JobProgress
  ///
  /// [model] - The file model to be shared
  /// [jobModel] - Optional job model associated with the file
  /// [type] - The module type for the file
  /// [phone] - Optional phone number for sending the file
  /// [customerModel] - Optional customer model associated with the file
  /// [updateScreen] - Optional callback to update the screen after action
  /// [onTextSent] - Optional callback triggered when text is sent
  /// [phoneModel] - Phone model containing consent information
  /// [consentStatus] - Current consent status for the phone number
  static void showShareFileViaJobProgressPopUp({
    FilesListingModel? model,
    JobModel? jobModel,
    FLModule? type,
    String? phone,
    CustomerModel? customerModel,
    VoidCallback? updateScreen,
    VoidCallback? onTextSent,
    PhoneModel? phoneModel,
    String? consentStatus
  }) {

    showJPBottomSheet(
      child: (_) => GetBuilder<SendViaJobProgressController>(
        global: false,
        init: SendViaJobProgressController(
          model: model,
          jobModel: jobModel,
          type: type,
          phone: phone,
          customerModel: customerModel,
          onTextSent: onTextSent,
          phoneModel: phoneModel,
          consentStatus: consentStatus,
        ),
        builder: (SendViaJobProgressController controller) {
          return ShareViaJobProgress(
            controller: controller,
          );
        },
      ),
      enableDrag: true,
      ignoreSafeArea: false,
      isScrollControlled: true,
    );
  }

  // getContacts() : will be responsible for merging job customer numbers & job contact person number
  static List<JPMultiSelectModel> getContacts(JobModel? jobModel) {
    List<JPMultiSelectModel> customerNumber = [];
    List<JPMultiSelectModel> jobContactPerson = [];

    final customerPhones = jobModel?.customer?.phones ?? [];

    for (var phone in customerPhones) {
      customerNumber.add(
        JPMultiSelectModel(
            label: PhoneMasking.maskPhoneNumber(phone.number.toString()),
            id: phone.number.toString(),
            isSelect: false,
            prefixLabel: phone.label != null ? "${phone.label!.capitalizeFirst!} - " : ""),
      );
    }

    if (jobModel?.contactPerson != null) {

      for (int j = 0; j < jobModel!.contactPerson!.length; j++) {

        if (jobModel.contactPerson![j].phones != null) {

          for (int i = 0; i < jobModel.contactPerson![j].phones!.length; i++) {

            PhoneModel contactPersonPhone = jobModel.contactPerson![j].phones![i];

            bool isContactPersonAlreadyInCustomer = customerNumber.any((customer) => customer.id == contactPersonPhone.number.toString());

            if (isContactPersonAlreadyInCustomer) continue;

            if(contactPersonPhone.number != null) {
              jobContactPerson.add(
                JPMultiSelectModel(
                    label: PhoneMasking.maskPhoneNumber(
                        contactPersonPhone.number!),
                    id: contactPersonPhone.number!,
                    isSelect: false,
                    prefixLabel: contactPersonPhone.label != null
                        ? "${contactPersonPhone.label!.capitalizeFirst!} - "
                        : ""),
              );
            }
          }
        }
      }
    }
    return customerNumber + jobContactPerson;
  }

  // showJobContacts(): will display multi-selection sheet with labelled phone numbers
  //                   & will open native messenger to share file
  static void showJobContacts({required FilesListingQuickActionParams params, String? phone}) {

    if(params.jobModel == null) {
      FileListQuickActionHandlers.sendViaDevice(
        recipients: phone != null ? [phone] : [],
        model: params.fileList.isEmpty ? null : params.fileList.first
      );
      return;
    }

    List<JPMultiSelectModel> list = getContacts(params.jobModel);

    MultiSelectHelper.openMultiSelect(
      mainList: list,
      title: 'select_contact'.tr.toUpperCase(),
      callback: (List<JPMultiSelectModel> list) {
        List<String> selectedNumbers = list
          .where((element) => element.isSelect)
          .map((e) => e.label.toString())
          .toList();
        if (selectedNumbers.isEmpty) {
          Helper.showToastMessage('no_contact_selected'.tr);
        } else {
          Get.back();
          FileListQuickActionHandlers.sendViaDevice(
            model: params.fileList.isNotEmpty ? params.fileList.first : null,
            recipients: selectedNumbers,
          );
        }
      },
    );
  }

  static void showFileInfoPopUp(FilesListingQuickActionParams params) {
    showJPBottomSheet(
      child: (_) => FileInfo(
        data: params.fileList.first,
      ),
    );
  }

  static Future<dynamic> confirmationToAction(FilesListingQuickActionParams params, FLQuickActions action, Map<String, dynamic>? arguments) async{
    switch(action){
      case FLQuickActions.delete:
        return await FileListQuickActionHandlers.delete(params);
      case FLQuickActions.showOnCustomerWebPage:
        return await FileListQuickActionHandlers.showHideOnCustomerWebPage(params, action);
      case FLQuickActions.removeFromCustomerWebPage:
        return await FileListQuickActionHandlers.showHideOnCustomerWebPage(params, action);
      case FLQuickActions.unMarkAsFavourite:
        return await FileListQuickActionHandlers.unMarkAsFavourite(params);
      case FLQuickActions.updateStatus:
        return await FileListQuickActionHandlers.updateStatus(params, arguments!);
      case FLQuickActions.formProposalNote:
        return await FileListQuickActionHandlers.formProposalNote(params, arguments!['newNote']);
      case FLQuickActions.cumulativeInvoiceNote:
        params.fileList.first.note = arguments!['newNote'];
        return await FileListQuickActionHandlers.cumulativeInvoiceNote(params: params, action: "save" , type: FLModule.cumulativeInvoices);
      case FLQuickActions.markAsCompleted:
      case FLQuickActions.markAsPending:
        return await FileListQuickActionHandlers.markAs(params, action);
      case FLQuickActions.updateJobPrice:
        return await FileListQuickActionHandlers.updateJobPrice(params);
      default:
        break;
    }
  }

  static Future<dynamic> typeToRename(FilesListingQuickActionParams params, FLQuickActions action, String newName) async{

    switch(action){
      case FLQuickActions.rename:
        return await FileListQuickActionHandlers.rename(params.type, params.fileList.first, newName).then((value) {
          if(value == null) return;
          params.onActionComplete(value, FLQuickActions.rename);
        });

      case FLQuickActions.makeACopy:
        return await FileListQuickActionHandlers.makeACopy(params, newName).then((value) {
          if(value == null) return;
          params.onActionComplete(value, FLQuickActions.makeACopy);
        });

      default:
        break;
    }
  }

  static Future<dynamic> showFilterList(FilesListingQuickActionParams params){
    return showJPBottomSheet(
      child: (controller) => JPSingleSelect(
        mainList: actionToFilterList(params),
        selectedItemId: params.fileList.first.status,
        title: 'update_status'.tr,
        isFilterSheet: true,
        onItemSelect: (value) {
          if(value == params.fileList.first.status) return;
          Get.back();
          bool canShowThankYouEmailToggle = value == 'accepted' && FilesListingService().canShowThankYouMailToggle;
          params.doShowThankYouEmailToggle = canShowThankYouEmailToggle ? true : false;
          onSelectingFilter(params, value);
        },
      ),
      enableDrag: false,
    );
  }

  static List<JPSingleSelectModel> actionToFilterList(FilesListingQuickActionParams params){
    switch(params.type){
      case FLModule.jobProposal:
        return FileListingQuickActionsList.jobProposalStatusList;
      default:
        return <JPSingleSelectModel>[];
    }
  }

  static void onSelectingFilter(FilesListingQuickActionParams params, String filterId) {
    switch(params.type){
      case FLModule.jobProposal:
        String newStatus = FileListingQuickActionsList.jobProposalStatusList.firstWhere((element) => element.id == filterId).label;
        String oldStatus = FileListingQuickActionsList.jobProposalStatusList.firstWhere((element) => element.id == params.fileList.first.status).label;
        Map<String,dynamic> arguments = {'oldStatus' : oldStatus, 'newStatus' : newStatus, 'newStatusId' : filterId};
        if(params.doShowThankYouEmailToggle ?? false) {
          showConfirmationBottomSheetWithSwitch(params, FLQuickActions.updateStatus, arguments);
        } else {
          showConfirmationBottomSheet(params, FLQuickActions.updateStatus, arguments);
        }        
        break;
      default:
        break;
    }
  }

  static void showMarkAsFavouriteDialog(FilesListingQuickActionParams params){
    showJPGeneralDialog(
      child: (_) => MarkAsFavouriteDialog(
        fileParams: params,
      ),
    );
  }

  static void showExpireOnDialog(FilesListingQuickActionParams params){
    showJPGeneralDialog(
      child: (_) => ExpireOnDialog(
        fileParams: params,
      ),
    );
  }

  static void showSetViewDeliveryDateDialog(FilesListingQuickActionParams params, FLQuickActions action, {DeliveryDateModel? deliveryDate, bool isSRSOrder = false}) {
    showJPBottomSheet(
        child: (_) => SetViewDeliveryDateDialog(
          fileParams: params,
          action: action,
          isSRSOrder: isSRSOrder
        ),
        ignoreSafeArea: false,
        isScrollControlled: true
    );
  }


  static Future<dynamic> showAssignedUserBottomSheet(FilesListingQuickActionParams params) async {
    
    List<JPMultiSelectModel> assignedUsers = [];

    List<JPMultiSelectModel> groupList = [];
    
    UserParamModel userParams = UserParamModel(
      withSubContractorPrime: true,
      limit: 0,
      includes: ['tags','divisions']
    );

    TagParamModel tagParams = TagParamModel(includes: ['users']);

    UserResponseModel allUsers = await SqlUserRepository().get(params: userParams);

    TagResponseModel allTags = await SqlTagsRepository().get(params: tagParams);

    for(TagModel tag in allTags.data) { 
      
      if(tag.users == null) continue;

      groupList.add(JPMultiSelectModel(
        label: tag.name,
        id: tag.id.toString(),
        isSelect: false,
        additionData: tag
      ));

    }
    
    for (UserModel user in allUsers.data) {
      
      List<TagLimitedModel> tag = [];
      
      if(user.tags != null){
        for(var tags in user.tags!){
          tag.add(TagLimitedModel(id:tags.id ,name: tags.name));
        }
      }
      
      assignedUsers.add(
        JPMultiSelectModel(
          label: user.groupId == UserGroupIdConstants.subContractorPrime ? '${user.fullName} (${'sub'.tr})' : user.fullName,
          id: user.id.toString(),
          tags: tag,
          isSelect: params.fileList.first.workOrderAssignedUser!.any((element) => element.id == user.id),
          child: JPProfileImage(
            size: JPAvatarSize.small,
            src: user.profilePic,
            color: user.color,
            initial: user.intial,
          )
        ),
      );

      tag = [];
    }
    
    return showJPBottomSheet(
      child: (controller) => JPMultiSelect(
        mainList: assignedUsers,
        subList: groupList,
        canShowSubList: groupList.isNotEmpty,
        inputHintText: 'search_here'.tr,
        title: 'assign_to'.tr.toUpperCase(),
        disableButtons: controller.isLoading,
        doneIcon: showJPConfirmationLoader(show: controller.isLoading),
        onDone: (list) async {
          controller.toggleIsLoading();
          List<WorkOrderAssignedUserModel> selectedUsers = [];
          for(JPMultiSelectModel element in list){
            if(element.isSelect){
             selectedUsers.add(WorkOrderAssignedUserModel(id: int.parse(element.id),name: element.label)); 
            }
          }
          await FileListingWorkOrderQuickActionRepo.updateAssignedUser(selectedUsers, params);
          controller.toggleIsLoading();
          Get.back();
        },
      ),
      isScrollControlled: true,
    );
  }

  static void showMeasurementSelectionSheet({required Future<void> Function(FilesListingModel) onFilesSelected, int? jobId}) {
    showJPBottomSheet(
        child: (_) => GetBuilder<FilesListingController>(
          init: FilesListingController(
              mode: FLViewMode.apply,
              attachType: FLModule.measurements,
              attachJobId: jobId,
              allowMultipleSelection: false
          ),
          global: false,
          builder: (FilesListingController controller) {
            return JPSafeArea(
              bottom: false,
              child: FilesView(
                controller: controller,
                onTapAttach: (List<FilesListingModel> selectedFiles) async {
                  await onFilesSelected(selectedFiles.first);
                  Get.back();
                },
              ),
            );
          },
        ),
        ignoreSafeArea: false,
        isScrollControlled: true
    );
  }

  static Future<void> showFavouriteListingBottomSheet({
    required Future<dynamic> Function(List<FilesListingModel> files) onTapAttach,
    required Function(String id) onTapUnFavourite,
    Map<String, dynamic>? additionalParams,
    int? jobId,
    String? parentModule,
    int? worksheetId,
  }) async {
    await showJPBottomSheet(
        child: (_) => GetBuilder<FilesListingController>(
          init: FilesListingController(
              mode: FLViewMode.apply,
              attachType: FLModule.favouriteListing,
              attachJobId: jobId,
              additionalParams: additionalParams,
              allowMultipleSelection: false,
              parentModule: WorksheetHelpers.typeToFLModule(parentModule ?? ''),
              parentWorksheetId: worksheetId
          ),
          global: false,
          builder: (FilesListingController controller) {
            return JPSafeArea(
              bottom: false,
              child: FilesView(
                controller: controller,
                onTapAttach: onTapAttach,
                onTapUnFavourite: (List<FilesListingModel> selectedFiles) async {
                  onTapUnFavourite(selectedFiles.first.id!);
                },
              ),
            );
          },
        ),
        ignoreSafeArea: false,
        isScrollControlled: true
    );

  }

  /// [showSaveWorksheetDialog] opens up same dialog as per the type of worksheet
  /// and also set up some of the necessary properties of worksheet
  static void showSaveWorksheetDialog({
    required String worksheetType,
    required WorksheetModel worksheet,
    required FilesListingQuickActionParams params
  }) {

    final file = params.fileList.first;
    bool secondaryToggleValue = true;
    bool useDefaultSettings = WorksheetHelpers.doShowDefaultSettingsSelector(worksheetType)
        ? Helper.isTrue(CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.useWorksheetSettingByDefault))
        : false;
    bool includeIntegratedSuppliers = WorksheetHelpers.hasIntegratedSupplier(file.worksheet);
    WorksheetHelpers.showNameDialog(
      label: 'name'.tr,
      title:  WorksheetHelpers.worksheetTypeToTitle(worksheetType),
      filledValue: file.name,
      preFooter: (controller) {
        if (WorksheetHelpers.doShowDefaultSettingsSelector(worksheetType)) {
          return WorksheetDefaultSettingSelector(
            isSelected: useDefaultSettings,
            worksheetType: worksheetType,
            onToggle: (val) {
              useDefaultSettings = !val;
              controller.update();
            },
          );
        }
        return null;
      },
      secondaryToggleText: 'include_integrated_supplier_materials'.tr,
      isSecondaryToggle: includeIntegratedSuppliers && worksheetType == WorksheetConstants.materialList,
      secondaryToggleValue: secondaryToggleValue,
      onSecondaryToggle: (val) {
        secondaryToggleValue = val;
      },
      onDone: (name) async {
        worksheet.name = name;
        worksheet.type = worksheetType;
        bool isSRS = worksheetType == WorksheetConstants.srsMaterialList;
        bool isBeacon = worksheetType == WorksheetConstants.beaconMaterialList;
        bool isABC = worksheetType == WorksheetConstants.abcMaterialList;
        // Re-setting type to material list if it is SRS or Beacon or ABC
        if (isSRS || isBeacon || isABC) worksheet.type = WorksheetConstants.materialList;
        worksheet.measurementId = file.linkedMeasurement?.id?.toString();

        if (useDefaultSettings) {
          worksheet.overrideWithDefaultSettings(generateWorksheetType: worksheetType);
        }

        await onWorksheetSaved(worksheet, params, includeIntegratedSuppliers: includeIntegratedSuppliers && secondaryToggleValue);
      },
    );
  }

  /// [onWorksheetSaved] makes an api call to server to store worksheet data and also performs
  /// navigation to corresponding worksheet as per type worksheet-type
  static Future<void> onWorksheetSaved(WorksheetModel worksheet, FilesListingQuickActionParams params, {bool includeIntegratedSuppliers = true}) async {
    int? savedWorksheetId;
    try {
      savedWorksheetId = await FileListingQuickActionRepo.saveWorksheet(params, worksheet, includeIntegratedSuppliers: includeIntegratedSuppliers);
      if(savedWorksheetId != null) {
        params.onActionComplete(FilesListingModel(), FLQuickActions.generateWorkSheet);
      }
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
      if (savedWorksheetId != null && params.tempModule != null) {
        FileListQuickActionHandlers.navigateToWorksheet(params, type: params.tempModule, worksheetId: savedWorksheetId);
      }
    }
  }

  static void showSignatureDialog(FilesListingQuickActionParams params) async {
    showJPGeneralDialog(
      child: (_) => AddViewSignatureDialog(
        viewOnly: false,
        onAddSignature: (signature) async {
          return await FileListQuickActionHandlers.signFile(params, signature);
        },
      ),
    );
  }

  /// [showIntegratedSupplierDeactivationWarningDialog] shows the warning dialog when integrated supplier is deactivated
  static void showIntegratedSupplierDeactivationWarningDialog(FilesListingQuickActionParams params, String materialSupplierType) {
    showJPBottomSheet(
      child: (_) => IntegratedSupplierDeactivated(
        materialSupplierType: materialSupplierType,
        onCreateAnyway: () async {
          return await FileListQuickActionHandlers.navigateToWorksheet(params, removeIntegratedSupplierItems: true);
        }
      )
    );
  }

  /// [showIntegratedSupplierAccountSelectionDialog] shows the integrated supplier account selection dialog
  static Future<void> showIntegratedSupplierAccountSelectionDialog(WorksheetModel? worksheet, {bool isDefaultBranch = true, Function(MaterialSupplierFormParams?)? onSupplierSelect}) async {
    final MaterialSupplierType? type = FileListingQuickActionHelpers.getSupplierType(worksheet?.suppliers);
    if(type == null) return;
    DefaultBranchModel? defaultBranchModel = WorksheetHelpers.getDefaultBranch(type);
    String worksheetType = worksheet?.type ?? '';
    final result = await showJPBottomSheet(
      ignoreSafeArea: false,
      isScrollControlled: true,
      child: (_) => MaterialSupplierForm(
        params: MaterialSupplierFormParams(
            abcAccount: defaultBranchModel?.abcAccount,
            abcBranch: defaultBranchModel?.branch,
            srsShipToAddress: defaultBranchModel?.srsShipToAddress,
            srsBranch: defaultBranchModel?.branch,
            beaconAccount: defaultBranchModel?.beaconAccount,
            beaconJob: defaultBranchModel?.jobAccount,
            beaconBranch: defaultBranchModel?.branch,
            type: type,
            isDefaultBranchSaved: isDefaultBranch && defaultBranchModel != null,
            onChooseDifferentBranch: () {
              showIntegratedSupplierAccountSelectionDialog(worksheet, isDefaultBranch: false, onSupplierSelect: onSupplierSelect);
            },
            srsSupplierId: FileListingQuickActionHelpers.getSrsSupplierId(worksheet?.suppliers),
            worksheetType: WorksheetHelpers.getDefaultSaveName(worksheetType).toLowerCase()
        ),
      ),
    );

    // In case supplier has been selected
    if (result != null && result is Map<String, dynamic>) {
      // Parsing and updating the supplier details
      onSupplierSelect?.call(result[NavigationParams.supplierDetails]);
    }
  }

}