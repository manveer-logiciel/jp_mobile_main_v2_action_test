import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/tag/tag_param.dart';
import 'package:jobprogress/common/repositories/sql/tag.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/event/add_events.dart';
import 'package:jp_mobile_flutter_ui/FlutterMention/flutter_mentions.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/tag_modal.dart';
import '../../../../../common/models/follow_up_note/add_edit_model.dart';
import '../../../../../common/models/sql/user/user_param.dart';
import '../../../../../common/repositories/follow_ups_note.dart';
import '../../../../../common/repositories/sql/user.dart';
import '../../../../../core/constants/date_formats.dart';
import '../../../../../core/constants/follow_ups_note.dart';
import '../../../../../core/utils/date_time_helpers.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../core/utils/multi_select_helper.dart';
import '../../../../../global_widgets/profile_image_widget/index.dart';

class AddEditFollowUpNoteController extends GetxController {

  late AddEditFollowUpModel followUpNote;

  FollowUpsNotesKey? radioGroup;

  List<JPMultiSelectModel> userList = [];
  List<JPMultiSelectModel> groupList = [];

  TextEditingController noteTextController = TextEditingController();
  TextEditingController dateTypeTextController = TextEditingController();
  TextEditingController usersTextController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isEdit = false;

  AnnotationEditingController? noteController;

  AddEditFollowUpNoteController({AddEditFollowUpModel? addEditFollowUpModel}) {
    setDefaultKeys(addEditFollowUpModel!);
  }

  void setDefaultKeys(AddEditFollowUpModel params,) {

    followUpNote = AddEditFollowUpModel.copy(params);

    if(followUpNote.mark?.isNotEmpty ?? false){
      isEdit = true;
    }

    ///    Fetch  User
    UserParamModel requestParams = UserParamModel(
        withSubContractorPrime: false,
        limit: 0,
        includes: ['tags']
    );

    SqlUserRepository().get(params: requestParams).then((userData) {
      usersTextController.text = "";
      List<TagLimitedModel> tag = [];
      if(followUpNote.taskAssignTo?.isNotEmpty ?? false) {
        for(int i = 0; i < userData.data.length; i++) {
          if(userData.data[i].tags != null){
            for(int j = 0;j < userData.data[i].tags!.length; j++) {
              tag.add(TagLimitedModel(id:userData.data[i].tags![j].id ,
              name: userData.data[i].tags![j].name));
            }
          }
          userList.add(JPMultiSelectModel(
            id: userData.data[i].id.toString(), label: userData.data[i].fullName,tags: tag,
            isSelect: false,child:JPProfileImage(
              src: userData.data[i].profilePic,
              color: userData.data[i].color,
              initial: userData.data[i].intial,
            ),
          ));

         for (int j = 0; j < followUpNote.taskAssignTo!.length; j++) {
            if(userData.data[i].id == followUpNote.taskAssignTo![j]) {
              userList[i].isSelect = true;
              usersTextController.text = usersTextController.text + (usersTextController.text.isEmpty ? "" : ", ") + userData.data[i].fullName;
              break;
            }
          }
          tag=[];
        }
      } else {
        for (var element in userData.data) {
            List<TagLimitedModel> tag = [];
            if(element.tags != null){
              for(var e in element.tags! ){
                tag.add(TagLimitedModel(id: e.id,name: e.name));
              }
            }
          userList.add(JPMultiSelectModel(
            id: element.id.toString(),
            label: element.fullName,
            isSelect: false,
            child: JPProfileImage(
              src: element.profilePic,
              color: element.color,
              initial: element.intial,
            ),
            tags: tag,
          ));
          tag=[];
      }
    }}

);

    /// Fetch Tags
    TagParamModel tagsParams = TagParamModel(
      includes: ['users'],
    );

    SqlTagsRepository().get(params:tagsParams).then((tags) {
        for (var element in tags.data) {
          groupList.add(JPMultiSelectModel(
            id: element.id.toString(), 
            label: element.name, 
            isSelect: false,
            additionData: tags
          ));
        }
      });

    if(followUpNote.mark?.isEmpty ?? true){
      followUpNote.mark = FollowUpsNotesConstants.getFollowUpsNotesConstants(FollowUpsNotesKey.call);
      radioGroup = FollowUpsNotesKey.call;
    } else {
      radioGroup = FollowUpsNotesConstants.getFollowUpsNotesKey(followUpNote.mark ?? "");
    }

    dateTypeTextController.text = followUpNote.taskDueDate ?? "";
    noteTextController.text = followUpNote.note ?? "";
    update();
  }

  void openMultiSelect() {
    MultiSelectHelper.openMultiSelect(
        title: "select_users".tr.toUpperCase(),
        mainList: userList,
        subList: groupList,
        isGroupsHeader: groupList.isNotEmpty,
        callback: (List<JPMultiSelectModel> selectedTrades) {
          updateUsers(selectedTrades);
          Get.back();
        });
  }

  void updateUsers(List<JPMultiSelectModel> selectedTrades) {
    usersTextController.text = "";
    followUpNote.taskAssignTo = [];
    userList = selectedTrades;
    for (var element in selectedTrades) {
      if(element.isSelect){
        followUpNote.taskAssignTo!.add(int.parse(element.id));
        usersTextController.text = usersTextController.text + (usersTextController.text.isEmpty ? "" : ", ") + element.label;
      }
    }
    update();
  }

  void openDatePicker ({String? initialDate}) {
    DateTimeHelper.openDatePicker(
        initialDate: initialDate,
        isPreviousDateSelectionAllowed: false,
        helpText: "select_date".tr).then((dateTime) {
      if(dateTime != null) {
        dateTypeTextController.text = DateTimeHelper.format(dateTime.toString(), DateFormatConstants.dateOnlyFormat);
        followUpNote.taskDueDate = DateTimeHelper.format(dateTime.toString(), DateFormatConstants.dateServerFormat);
      }
      update();
    });
  }

  void updateRadioValue (FollowUpsNotesKey value) {
   radioGroup = value;
   followUpNote.mark = FollowUpsNotesConstants.getFollowUpsNotesConstants(value);
   update();
  }

  void reminderToggleUpdate(bool value) {
    followUpNote.followUpReminder = value;
    update();
  }

  @override
  void onClose() {
    usersTextController.dispose();
    dateTypeTextController.dispose();
    super.onClose();
  }

  onSave(void Function() onApply) {
    if(formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if((followUpNote.customerId != null)
          && (followUpNote.stageCode != null)
          && (followUpNote.jobId != null)) {
        isLoading = true;
        update();
        addFollowUpNote(onApply);
      } else {
        Helper.showToastMessage(
          followUpNote.customerId != null ? "customerId_not_available".tr :
          followUpNote.stageCode != null ? "stageCode_not_available".tr :
          followUpNote.jobId != null ? "jobId_not_available".tr : ""
        );
      }
    }
  }

  addFollowUpNote(void Function() onApply) {
    Map<String, dynamic> queryParams = {
      ...followUpNote.toJson()..removeWhere((dynamic key, dynamic value) =>
        (key == null || value == null)),
    };
    FollowUpsNoteListingRepository().addFollowUpsNote(queryParams).then((response) {
      if(response) {
        Helper.showToastMessage("added_follow_up_note".tr);
        MixPanelService.trackEvent(event: MixPanelAddEvent.followUpNote);
        onApply();
        Get.back();
      }
    }).catchError((onError) {Get.back();});
  }

  String? validateNote(String value) {
    if (value.isEmpty) {
      return "please_enter_note".tr;
    }
    return '';
  }

}