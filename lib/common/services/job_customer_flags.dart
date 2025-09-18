
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/job_quick_action_callback_type.dart';
import 'package:jobprogress/common/extensions/color/index.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/flag/flag.dart';
import 'package:jobprogress/common/repositories/flags.dart';
import 'package:jobprogress/core/constants/communication_flag_id.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../core/constants/widget_keys.dart';
import '../models/customer/customer.dart';
import '../repositories/sql/flags.dart';

class JobCustomerFlags {
 
  static void showFlagsBottomSheet({
    bool isQuickAction = false,
    int? id,
    JobModel? jobModel,
    int? index,
    VoidCallback? updateScreen,
    void Function({CustomerModel? customer, int? customerIndex})? flagCallbackForCustomer,
    void Function({JobModel? job, int? currentIndex, JobQuickActionCallbackType? callbackType})? flagCallbackForJob,
    CustomerModel? customer 
  }) {
    List<JPMultiSelectModel> filterByMultiList = [];
    
    SqlFlagRepository().get(type: jobModel != null ? "job" : 'customer').then((flagList) {
      if(jobModel != null){
        flagList.insertAll(0,<FlagModel>[FlagModel.callRequiredFlag, FlagModel.appointmentRequiredFlag]);
      }
      for (var element in flagList) {
        filterByMultiList.add(JPMultiSelectModel(
          id: element!.id.toString(),
          label: element.title,
          isSelect: false,
          color: Helper.evaluateFlagBackgroundColor(element),
          child: JPAvatar(
            size: JPAvatarSize.small,
            backgroundColor: element.actualColor,
            child: Icon(Icons.flag, color: JPAppTheme.themeColors.base, size: 18),
          )
        ));
      }
      loadFlagsBottomSheet(
        filterByMultiList: filterByMultiList, 
        flagList:jobModel == null ? customer!.flags! : jobModel.flags!, 
        id: id!, 
        customer:customer,
        jobModel:jobModel,
        isQuickAction: isQuickAction,
        index:index,
        flagCallbackForJob: flagCallbackForJob,
        flagCallbackForCustomer:flagCallbackForCustomer,
        updateScren: updateScreen
      );
    }); 
  }

  static Future<void> loadFlagsBottomSheet({
    required List<JPMultiSelectModel> filterByMultiList, 
    required List<FlagModel?> flagList, 
    VoidCallback? updateScren,
    required int id,
    bool isQuickAction = false,
    JobModel? jobModel,
    CustomerModel? customer,
    int? index,
    void Function({JobModel? job, int? currentIndex, JobQuickActionCallbackType? callbackType})? flagCallbackForJob,
    void Function({CustomerModel? customer, int? customerIndex})? flagCallbackForCustomer,   
  }) async {
    for (JPMultiSelectModel element in filterByMultiList) {
      if(!isQuickAction) {
        element.isSelect = false;
      }
      for (FlagModel? flag in (flagList)) {
        if(element.label == flag!.title) {
          element.isSelect = true;
        }
      }
    }

    showJPBottomSheet(isScrollControlled: true, child: ((controller) {
      return JPMultiSelect(
        key: const ValueKey(WidgetKeys.multiselect),
        mainList: filterByMultiList,
        inputHintText: 'search'.tr,
        title: "select_flags".tr.toUpperCase(),
        canDisableDoneButton: false,
        doneIcon: showJPConfirmationLoader(show: controller.isLoading),
        disableButtons: controller.isLoading,
        onDone: (List<JPMultiSelectModel>? selectedFlags) async {
          flagList = [];
          List<int> flagIDs = [];
          List<int> communicationFlagIds =[];
          List<JPMultiSelectModel> communcationFlags = [];
          for (var element in selectedFlags!) {
            if(element.id == CommunicationFlagsId.call.toString()) {
              communcationFlags.add(JPMultiSelectModel(label: 'call', id: element.id, isSelect: element.isSelect));
            }
            if(element.id == CommunicationFlagsId.appointment.toString()) {
              communcationFlags.add(JPMultiSelectModel(label: 'appointment', id: element.id, isSelect: element.isSelect));
            }
            if(element.isSelect) {
              if(element.id != CommunicationFlagsId.call.toString() && element.id != CommunicationFlagsId.appointment.toString()) {
                flagIDs.add(int.parse(element.id));
              } else {
                communicationFlagIds.add(int.parse(element.id));
              }
              flagList.add(
                FlagModel(
                  id: int.parse(element.id), title: element.label,
                  color: element.color!.toHex(), type: "Customer",
                  actualColor: element.color!, reserved: false
                )
              );
            }
          }
          if(jobModel != null) {
            jobModel.flags = flagList;
          }
          if(customer != null) {
            customer.flags = flagList;
          }
          
          try {
            controller.toggleIsLoading();
            for(JPMultiSelectModel element in communcationFlags) {
            await updateCommunicationFlag(type: element.label, id: id, isSelected: element.isSelect);
          }
            await updateFlagsOnServer(
              flagIDs: flagIDs, 
              id: id, 
              communicationFlagIds: communicationFlagIds,  
              isQuickaction: isQuickAction, 
              index: index,
              flagCallbackForCustomer: flagCallbackForCustomer,
              flagCallbackForJob: flagCallbackForJob,
              customer: customer,
              job: jobModel
            );
            if(!isQuickAction){
              updateScren!();
            }
            Get.back();

          } catch (e){
            rethrow;
          } finally {
            controller.toggleIsLoading();
          }
        },
      );
    }));
  }

  static Future<void> updateCommunicationFlag({String? type, bool? isSelected, int? id}) async {
    Map<String, dynamic> queryParams = {
      "type": type,
      "status": isSelected! ? 1 : 0,
    };
    await FlagsRepository().assignCommunicationFlags(queryParams,id!);
  }

  static Future<void> updateFlagsOnServer({
    List<int>? flagIDs,
    required bool isQuickaction, 
    int? id,
    List<int>? communicationFlagIds,
    CustomerModel? customer,
    JobModel? job,
    int? index,
    void Function({JobModel? job, int? currentIndex, JobQuickActionCallbackType? callbackType})? flagCallbackForJob,
    void Function({CustomerModel? customer, int? customerIndex})? flagCallbackForCustomer,
  }) async {
    Map<String, dynamic> queryParams = {
      "includes": ["color"],
      "flag_for":job!= null ? 'job' : 'customer',
      "limit":0,
      "id": id ?? "",
      "flag_ids": flagIDs ?? [],
    };
    await FlagsRepository().assignFlags(queryParams).then((response) {
      if(response.isNotEmpty) {
        if(flagIDs!.isEmpty && communicationFlagIds!.isEmpty){
          Helper.showToastMessage("flags".tr + "removed".tr);
        } else {
          Helper.showToastMessage('${"flags".tr} ${"applied".tr.toLowerCase()}');
        }
        if(isQuickaction && customer != null) {
          flagCallbackForCustomer!(customer: customer, customerIndex: index);
        }
        if(isQuickaction && job != null){
         flagCallbackForJob!(job: job, currentIndex: index, callbackType: JobQuickActionCallbackType.flagCallback); 
        }
      }
    });
  }

}