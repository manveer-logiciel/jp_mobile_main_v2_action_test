import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/document_count.dart';
import 'package:jobprogress/common/repositories/upgrade_plan.dart';
import 'package:jobprogress/common/services/free_trial_user_data/index.dart';
import 'package:jobprogress/common/services/subscriber_details.dart';
import 'package:jobprogress/core/constants/subscriber_plan_code.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/updgrde_plan_dialog/index.dart';

class UpgradePlanHelper {
  static Future<bool> showUpgradePlanOnDocumentLimit() async {
    String? planCode = SubscriberDetailsService.subscriberDetails?.subscription?.plan?.code;
    String billingCode =  FreeTrialUserDataService.billingCode ?? '';
    bool isFreeTrialUser =  planCode == SubscriberPlanCode.essentialFree30Days;
    
    if(isFreeTrialUser) {
       bool isDocumentLimitExceeded = await isDocumentUploadLimitExceeded();
       if(isDocumentLimitExceeded) {
        showJPBottomSheet(
          child: (JPBottomSheetController controller) {
          return UpgradePlanDialog(
            dialogIcon: Icons.warning_amber_outlined,
            billingCode: billingCode,
            controller: controller,
            title: 'document_limit_cross_title'.tr,
            subTitle: 'document_limit_cross_message'.tr,
            );  
          }
        );
        return true;
      }     
    }
    return false;
  }

  static Future<bool> isDocumentUploadLimitExceeded() async {
    DocumentUploadLimitModel? documentUpload = await UpgradePlanRepository.getDocumentUploadLimit();
    return (documentUpload.count ?? 0) >= (documentUpload.limit ?? 0);
  }
}