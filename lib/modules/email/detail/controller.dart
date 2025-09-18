import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/secondary_drawer.dart';
import 'package:jobprogress/common/extensions/get_navigation/extension.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/models/email/email.dart';
import 'package:jobprogress/common/models/label.dart';
import 'package:jobprogress/common/models/secondary_drawer_item.dart';
import 'package:jobprogress/common/repositories/email.dart';
import 'package:jobprogress/common/services/email/quick_action.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/event/view_events.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/three_bounce.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class EmailDetailController extends GetxController {

  EmailDetailController({
    this.argEmailId,
    this.argAvatarColor,
    this.handleOnEmailSent,
    this.selectedLabelId
  });

  bool isLoading = true;
  String emailId = '';
  bool isAllEmailOpen = true;
  
  Color avatarColor = JPAppTheme.themeColors.warning;
  
  List<EmailListingModel> emailDetail = [];

  int? argEmailId;

  int? selectedLabelId;

  Color? argAvatarColor;

  Function(int)? handleOnEmailSent;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<JPSecondaryDrawerItem> labelList = [];
  Map<String, dynamic>? apiLabelList;

  Future<void> getEmailDetail() async {
    if(argEmailId == null) return;

    emailId = argEmailId.toString();
    try {
      final emailsParams = <String, dynamic>{
        'id': emailId,
        'recursive':1,
        'includes[0]': ['createdBy'],
        'includes[1]': ['attachments'],
      };
      
      Map<String, dynamic> response = await EmailListingRepository().fetchEmaildetail(emailsParams);
      
      emailDetail = response['list'];

      if(emailDetail.length > 4) {
        isAllEmailOpen = false;
      }

      if(argAvatarColor != null) {
        avatarColor = argAvatarColor!;
      }
    } catch (e) {
      rethrow;
    } finally {
        isLoading = false;
        update();
    }
  }
    
  void refreshPage() {
    isLoading = true;
    update();

    if(argEmailId == -1) return;
    getEmailDetail();
  }

  bool get showMoveButton {
    if(selectedLabelId == null || selectedLabelId == -2 || selectedLabelId == -3) {
      return false;
    }
    return true;

  }

  @override
  void onInit() {
    if(Get.arguments != null) {
      argEmailId = Get.arguments['tapped_email_id'];
    }
    getEmailDetailData();
    MixPanelService.trackEvent(event: MixPanelViewEvent.emailDetails);
    super.onInit();
  }

  Future<void> getEmailDetailData() async {
    await Future.wait([
      getEmailDetail(),
      setEmailLabelList(),
    ]);
  }

  void showConfirmationForDeleteEmail() {
    showJPBottomSheet(child: (controller) {
      return JPConfirmationDialog(
        icon: Icons.report_problem_outlined,
        title: "confirmation".tr,
        subTitle: 'you_are_about_to_delete_email'.tr,
        suffixBtnText: 'delete'.tr,
        disableButtons: controller.isLoading,
        suffixBtnIcon: controller.isLoading ? SpinKitThreeBounce(color: JPAppTheme.themeColors.base, size: 20) : null,
        onTapSuffix: () async {
          controller.toggleIsLoading();
          await deleteEmails().trackDeleteEvent(MixPanelEventTitle.emailDelete);
          controller.toggleIsLoading();
        },
      );
    });
  }

  Future<void> deleteEmails() async {
    List<int?> ids = emailDetail.map((email) => email.id).toList();
    final deleteEmailParams = <String, dynamic>{'force': 0, 'ids[]': ids};

    await EmailListingRepository().deleteEmail(deleteEmailParams);
    Get.splitPop(result: true);
    Helper.showToastMessage('deleted'.tr);
    Get.back();
  }

  Future<void> setEmailLabelList() async {
    Map<String, dynamic> emailLabelParams = <String, dynamic>{
      'limit': '0',
      'with_unread_count': '1',
    };

    await Future<void>.delayed(const Duration(milliseconds: 500));

    apiLabelList = await EmailListingRepository().fetchLabelList(emailLabelParams);

    addLabelList(apiLabelList!);
}

  void addLabelList(Map<String, dynamic> response) {
    labelList = [];
    List<EmailLabelModel> list = response['list'];

    if (list.isNotEmpty) {
      labelList.add(JPSecondaryDrawerItem(slug: 'label', title: 'label'.tr.toUpperCase(), itemType: SecondaryDrawerItemType.label));

      for (var label in list) {
        labelList.add(
          JPSecondaryDrawerItem(
            slug: label.id.toString(),
            title: label.name ?? "",
            icon: Icons.label_outline,
            number: label.unreadCount,
          ),
        );
      }
    }
}

  void openMoveToEmail() {
    List<JPQuickActionModel> mainList = [];

    for (JPSecondaryDrawerItem label in labelList) {
      if (label.slug != 'label') {
        mainList.add(JPQuickActionModel(label: label.title.toString(), id: label.slug.toString(), child: const JPIcon(Icons.label_outline, size: 20)));
      }
    }
    if (selectedLabelId != -1) {
      mainList.insert(0, JPQuickActionModel(label: 'inbox'.tr, id: '-1', child: const JPIcon(Icons.email_outlined, size: 20)));
    }

    showJPBottomSheet(
      child: (_) => JPQuickAction(
        mainList: mainList,
              title: "move_to".tr,
        onItemSelect: (value) {
          moveEmails(value);
        },
      ),
      isScrollControlled: true);
    }

    void moveEmails(String value) async{
      try{
        Get.back();
        showJPLoader();
        if (value == '-1') {
        await  removeLabel();
        } else {
        await moveToEmails(int.parse(value));
        }
        Get.splitPop(result: true);
        Helper.showToastMessage('emails_moved'.tr);
      } catch (e){
        rethrow;
      } finally {
        Get.back();
      }
    }

    Future<void> removeLabel() async {
      List<String?> threadIds = emailDetail.map((email) => email.threadId).toList();
      final removeLabelParams = <String, dynamic>{'thread_ids[]': threadIds};
      try {
        await EmailListingRepository().removeLabel(removeLabelParams);
      } catch (e) {
        rethrow;
      } 
  }

  Future<void> moveToEmails(int selectedLabelId) async {
    List<String?> threadIds = emailDetail.map((email) => email.threadId).toList();
    final moveEmailParams = <String, dynamic>{'thread_ids[]': threadIds, 'label_id': selectedLabelId};
    try {
      await EmailListingRepository().moveToEmail(moveEmailParams);
    } catch (e) {
      rethrow;
    }
  }

  void printEmail() {
    EmailService.printEmail(emailDetail.first,isRecursive: true);
  }

  void updateContent(int? updatedArgEmailId, {Color? color, }) {
    if(updatedArgEmailId != null && argEmailId != updatedArgEmailId) {
      argEmailId = updatedArgEmailId;
      if(color != null) argAvatarColor = color;
      refreshPage();
    }
  }

  void onEmailSent(int id) {
    if(handleOnEmailSent == null) {
      refreshPage();
    } else {
      handleOnEmailSent?.call(id);
    }
  }
}

