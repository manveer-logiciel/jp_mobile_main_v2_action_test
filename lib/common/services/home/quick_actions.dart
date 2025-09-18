
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/actions.dart';
import 'package:jobprogress/common/enums/task_form_type.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_params.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/common/services/upload.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/send_message/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../auth.dart';

class HomeQuickActionsService {

  List<JPQuickActionModel> get quickActions => [
    JPQuickActionModel(
      label: 'instant_photo'.tr,
      id: HomeActions.instantPhoto.toString(),
      child: const JPIcon(Icons.photo_camera_outlined),
    ),
    JPQuickActionModel(
      label: 'appointment'.tr,
      id: HomeActions.appointment.toString(),
      child: const JPIcon(Icons.today_outlined),
    ),
    if(PhasesVisibility.canShowSecondPhase) ...{
      if(!AuthService.isPrimeSubUser())...{
        JPQuickActionModel(
          label: 'lead'.tr,
          id: HomeActions.lead.toString(),
          child: const JPIcon(Icons.person_add_outlined),
        )
      },
      JPQuickActionModel(
          label: 'task'.tr,
          id: HomeActions.task.toString(),
          child: const JPIcon(Icons.task_alt_outlined),
        ),
    },
    if(FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.userManagement]))...{
      JPQuickActionModel(
        label: 'message'.tr,
        id: HomeActions.message.toString(),
        child: const JPIcon(Icons.textsms_outlined),
      ),
    },
    JPQuickActionModel(
      label: 'email'.tr,
      id: HomeActions.email.toString(),
      child: const JPIcon(Icons.email_outlined),
    ),
  ];

  static void handleQuickActions(String id) {

    switch (id) {

      case "HomeActions.instantPhoto":
        FileUploaderParams params = FileUploaderParams(type: FileUploadType.instantPhoto);
        UploadService.takePictureAndAddToQueue(params);
        break;

      case "HomeActions.appointment":
        Get.toNamed(Routes.createAppointmentForm);
        break;

      case "HomeActions.lead":
        Get.toNamed(Routes.customerForm);
        break;

      case "HomeActions.task":
        Get.toNamed(
            Routes.createTaskForm,
            preventDuplicates: false,
            arguments: {
              NavigationParams.pageType: TaskFormType.createForm
            }
        );
        break;

      case "HomeActions.message":
        showSendMessageSheet();
        break;

      case "HomeActions.email":
        Get.toNamed(Routes.composeEmail);
        break;
    }

  }

  static void showSendMessageSheet() {
    showJPBottomSheet(
      child: (_) {
        return SendMessageForm(
          onMessageSent: () {
            Helper.showToastMessage('message_sent'.tr);
          },
        );
      },
      isScrollControlled: true,
      enableInsets: true,
    );
  }

}