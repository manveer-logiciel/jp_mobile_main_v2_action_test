import 'dart:core';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/models/customer_list/customer_listing_filter.dart';
import '../../../common/models/sql/state/state.dart';
import '../../../common/models/sql/user/user.dart';
import '../../../common/models/sql/user/user_param.dart';
import '../../../common/models/sql/user/user_response.dart';
import '../../../common/repositories/sql/flags.dart';
import '../../../common/repositories/sql/state.dart';
import '../../../common/repositories/sql/user.dart';
import '../../../common/services/phone_masking.dart';
import '../../../common/services/run_mode/index.dart';
import '../../../core/constants/dropdown_list_constants.dart';
import '../listing/controller.dart';

class CustomerListingFilterDialogController extends GetxController {

  CustomerListingFilterModel filterKeys = CustomerListingFilterModel();
  CustomerListingFilterModel defaultFilterKeys;

  final GlobalKey<FormState> filterFormKey = GlobalKey<FormState>();

  final customerList = Get.put(CustomerListingController()).customerList;

  UserModel? selectedUser;
  UserResponseModel? userResponseModel;
  JPSingleSelectModel? selectedNameFilter;

  List<StateModel?> stateList = [];
  List<JPMultiSelectModel> mainList = [];
  List<JPMultiSelectModel> flagList = [];

  TextEditingController assignedTextController = TextEditingController();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController customerNoteTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();
  TextEditingController stateTextController = TextEditingController();
  TextEditingController zipTextController = TextEditingController();
  TextEditingController flagsTextController = TextEditingController();

  bool isResetButtonDisable = true;

  CustomerListingFilterDialogController(CustomerListingFilterModel selectedFilters, this.defaultFilterKeys) {
    if(!RunModeService.isUnitTestMode) {
      setDefaultKeys(selectedFilters);
    }
  }

  @override
  void onInit() {
    super.onInit();
    updateResetButtonDisable();
  }

  String? validatePhone(String value) {
    if (value.isEmpty) {
      return '';
    }
    if (value.length != 10) {
      return 'phone_length_validation_error'.tr;
    }
    return "";
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return '';
    }
    if (!GetUtils.isEmail(value)) {
      return "please_enter_valid_email".tr;
    }
    return '';
  }

  void setDefaultKeys(CustomerListingFilterModel params) {
    filterKeys =  params;
    ///    Fetch  User
    UserParamModel requestParams = UserParamModel(
      limit: -1,
      withSubContractorPrime: false,
      withInactive: true
    );

    if(AuthService.isStandardUser() && AuthService.isRestricted) {
      assignedTextController.text = AuthService.getUserDetails()!.fullName;
    } else {
        SqlUserRepository().get(params: requestParams).then((userData) {
          assignedTextController.text = "";
          userData.data.insert(0, UserModel(id: 0, firstName: "all".tr, fullName: "all".tr, email: '', intial: "A"));
          userResponseModel = userData;
          if(filterKeys.repIds?.isNotEmpty ?? false) {
            for (var element in userResponseModel!.data) {
              if(filterKeys.repIds?.isNotEmpty ?? false) {
                  assignedTextController.text = element.fullName;
              }
            }
          } else {
            filterKeys.repIds = [];
            filterKeys.repIds!.add(0);
          }
          for (var element in userResponseModel!.data) {
            if(filterKeys.repIds?.isNotEmpty ?? false) {
              if (element.id == filterKeys.repIds![0]) {
                assignedTextController.text = element.fullName;
              }
            }
          }
          updateResetButtonDisable();
        });
    }

    ///   Fetch State
    SqlStateRepository().get().then((stateList) {
      this.stateList = stateList;
      stateTextController.text = "";

      if(filterKeys.stateIds?.isNotEmpty ?? false) {
        for(int i = 0; i < stateList.length; i++) {
          mainList.add(JPMultiSelectModel(
              id: stateList[i]!.id.toString(), label: stateList[i]!.name,
              isSelect: false));
          for (int j = 0; j < filterKeys.stateIds!.length; j++){
            if(stateList[i]!.id == filterKeys.stateIds![j]){
              mainList[i].isSelect = true;
              stateTextController.text = stateTextController.text + (stateTextController.text.isEmpty ? "" : ", ") + mainList[i].label;
              break;
            }
          }
        }
      } else {
        for (var element in stateList) {
          mainList.add(JPMultiSelectModel(
          id: element!.id.toString(), label: element.name, isSelect: false));
        }
      }
      updateResetButtonDisable();
    });

    /// Flags
    ///   Flags
    SqlFlagRepository().get(type: "customer").then((flags) {
      flagsTextController.text = "";
      if(filterKeys.flags?.isNotEmpty ?? false) {
        for(int i = 0; i < flags.length; i++) {
          flagList.add(JPMultiSelectModel(
              id: flags[i]!.id.toString(), label: flags[i]!.title,
              isSelect: false));
          for (int j = 0; j < filterKeys.flags!.length; j++) {
            if(flags[i]?.id == filterKeys.flags?[j]) {
              flagList[i].isSelect = true;
              flagsTextController.text = flagsTextController.text + (flagsTextController.text.isEmpty ? "" : ", ") + flags[i]!.title;
              break;
            }
          }
        }
      } else {
        for (var element in flags) {
          flagList.add(JPMultiSelectModel(
              id: element!.id.toString(),
              label: element.title,
              isSelect: false));
        }
      }
    });

    nameTextController.text = filterKeys.name ?? "";
    emailTextController.text = filterKeys.email ?? "";
    customerNoteTextController.text = filterKeys.customerNote ?? "";
    addressTextController.text = filterKeys.address ?? "";
    zipTextController.text = filterKeys.zipCode ?? "";
    selectedNameFilter = DropdownListConstants.nameFilterTypeList.firstWhereOrNull((nameFilter) => nameFilter.id == filterKeys.nameFilterType);

    if(filterKeys.phone != null && filterKeys.phone!.isNotEmpty) {
      phoneTextController.text = PhoneMasking.maskPhoneNumber(filterKeys.phone!);
    }
    
    updateResetButtonDisable();
  }

  void selectAssignedTo() {
    showJPBottomSheet(
        child: (_) => JPSingleSelect(
            selectedItemId: (filterKeys.repIds?.isEmpty ?? true) ? "" : filterKeys.repIds![0].toString(),
            inputHintText: 'search_user'.tr,
            title: "select_assigned_to".tr.toUpperCase(),
            showIncludeInactiveButton: FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.userManagement]),
            mainList: userResponseModel!.data.map((user) => JPSingleSelectModel(
                id: user.id.toString(),
                label: user.fullName,
                active: user.active,
                child: JPProfileImage(src: user.profilePic,color: user.color,initial: user.intial,)
            )).toList(),
            onItemSelect: (value) {
              selectedUser = userResponseModel!.data.firstWhereOrNull((user) => user.id == int.parse(value));
              assignedTextController.text = selectedUser?.fullName ?? "all".tr;
              filterKeys.repIds = [];
              filterKeys.repIds!.add(selectedUser?.id ?? 0);
              updateResetButtonDisable();
              Get.back();
              update();
            }),
        isScrollControlled: true,
    );
  }

  void selectNameFilterType() {
    showJPBottomSheet(
        child: (_) => JPSingleSelect(
            selectedItemId: selectedNameFilter?.id,
            title: "select_name_type".tr.toUpperCase(),
            mainList: DropdownListConstants.nameFilterTypeList,
            onItemSelect: (value) {
              selectedNameFilter = DropdownListConstants.nameFilterTypeList.firstWhereOrNull((nameFilter) => nameFilter.id == value);
              filterKeys.nameFilterType = value;
              updateResetButtonDisable();
              Get.back();
              update();
            }),
        isScrollControlled: true
    );
  }

  void selectState() {
    mainList = [];
    if(filterKeys.stateIds?.isNotEmpty ?? false) {
      for(int i = 0; i < stateList.length; i++) {
        mainList.add(JPMultiSelectModel(id: stateList[i]!.id.toString(),
          label: stateList[i]!.name, isSelect: false));

        for (int j = 0; j < filterKeys.stateIds!.length; j++){
          if(stateList[i]!.id == filterKeys.stateIds![j]){
            mainList[i].isSelect = true;
            break;
          }
        }
      }
    } else {
      for (var element in stateList) {
        mainList.add(JPMultiSelectModel(
        id: element!.id.toString(), label: element.name, isSelect: false));
      }
    }

    showJPBottomSheet(
      child: (_) => JPMultiSelect(
          mainList: mainList,
          inputHintText: 'search'.tr,
          title: "select_states".tr.toUpperCase(),
          disableButtons: false,
          canDisableDoneButton: false,
          onDone: (List<JPMultiSelectModel>? selectedTrades) {
            stateTextController.text = "";
            filterKeys.stateIds = [];
            for (var element in selectedTrades!) {
              if(element.isSelect){
                filterKeys.stateIds!.add(int.parse(element.id));
                stateTextController.text = stateTextController.text + (stateTextController.text.isEmpty ? "" : ", ") + element.label;
              }
            }
            updateResetButtonDisable();
            Get.back();
            update();
          },
        ),
        isScrollControlled: true
    );
  }

  void selectFlags() {
    mainList = [];
    if(filterKeys.flags?.isNotEmpty ?? false) {
      for(int i = 0; i < flagList.length; i++) {
        mainList.add(JPMultiSelectModel(id: flagList[i].id.toString(),
            label: flagList[i].label, isSelect: false));

        for (int j = 0; j < filterKeys.flags!.length; j++){
          if(flagList[i].id == filterKeys.flags![j].toString()){
            mainList[i].isSelect = true;
            break;
          }
        }
      }
    } else {
      for (var element in flagList) {
        mainList.add(JPMultiSelectModel(
            id: element.id.toString(), label: element.label, isSelect: false));
      }
    }

    showJPBottomSheet(
        child: (_) => JPMultiSelect(
          mainList: mainList,
          inputHintText: 'search'.tr,
          title: "select_flags".tr.toUpperCase(),
          disableButtons: false,
          canDisableDoneButton: false,
          onDone: (List<JPMultiSelectModel>? selectedTrades) {
            flagsTextController.text = "";
            filterKeys.flags = [];
            for (var element in selectedTrades!) {
              if(element.isSelect){
                filterKeys.flags!.add(int.parse(element.id));
                flagsTextController.text = flagsTextController.text + (flagsTextController.text.isEmpty ? "" : ", ") + element.label;
              }
            }
            updateResetButtonDisable();
            Get.back();
            update();
          },
        ),
        isScrollControlled: true
    );
  }

  void updateResetButtonDisable() {
    isResetButtonDisable = filterKeys.toJson().toString() == defaultFilterKeys.toJson().toString();
    update();
  }

  void applyFilter(void Function(CustomerListingFilterModel params) onApply) {

    filterKeys.name = nameTextController.text.trim().isEmpty ? null : nameTextController.text.trim();
    filterKeys.customerNote = customerNoteTextController.text.trim().isEmpty ? null : customerNoteTextController.text.trim();
    filterKeys.address = addressTextController.text.trim().isEmpty ? null : addressTextController.text.trim();
    filterKeys.zipCode = zipTextController.text.trim().isEmpty ? null : zipTextController.text.trim();
    filterKeys.email = emailTextController.text.trim().isEmpty ? null : emailTextController.text.trim();

    filterKeys.phone = phoneTextController.text.trim().length < 10
        ? null
        : PhoneMasking.unmaskPhoneNumber(phoneTextController.text.trim());

    if(filterKeys.repIds![0] == 0) {
      filterKeys.repIds = null;
    }

    if(stateTextController.text.isEmpty) {
      filterKeys.stateIds = [];
    }

    if(flagsTextController.text.isEmpty) {
      filterKeys.flags = [];
    }

    if(assignedTextController.text.isEmpty || assignedTextController.text == 'all'.tr) {
      filterKeys.repIds = [];
    }

    if(emailTextController.text.trim().isNotEmpty) {
      if(filterFormKey.currentState?.validate() ?? false) {
        onApply(filterKeys);
        Get.back();
      }
    } else {
      onApply(filterKeys);
      Get.back();
    }

  }

  void cleanFilterKeys() {
    assignedTextController.text = "all".tr;
    nameTextController.text = '';
    phoneTextController.text = '';
    emailTextController.text = '';
    customerNoteTextController.text = '';
    addressTextController.text = '';
    stateTextController.text = '';
    zipTextController.text = '';
    flagsTextController.text = '';

    filterKeys.distance = null;
    filterKeys.repIds = [0];
    filterKeys.stateIds = null;
    filterKeys.flags = null;
    filterKeys.name = filterKeys.phone = filterKeys.email =
        filterKeys.customerNote = filterKeys.address = filterKeys.zipCode = null;

    updateResetButtonDisable();
  }

  @override
  void onClose() {
    assignedTextController.dispose();
    nameTextController.dispose();
    phoneTextController.dispose();
    emailTextController.dispose();
    customerNoteTextController.dispose();
    addressTextController.dispose();
    stateTextController.dispose();
    zipTextController.dispose();
    flagsTextController.dispose();
    super.onClose();
  }
}