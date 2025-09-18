
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/models/files_listing/delivery_date.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/photo_viewer_model.dart';
import 'package:jobprogress/common/repositories/material_lists.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_dialogs.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_handlers.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/photo_viewer_dialog/index.dart';
import 'package:jp_mobile_flutter_ui/DatePicker/index.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class SetViewDeliveryDateController extends GetxController {

  SetViewDeliveryDateController(this.fileParams, this.action, this.materialList, this.isSRSOrder);

  final FilesListingQuickActionParams fileParams;
  final FLQuickActions action;
  final List<JPSingleSelectModel>? materialList;

  TextEditingController materialDateController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController materialListController = TextEditingController();
  TextEditingController linkedListNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isUpdatingDeliveryDateStatus = false;
  bool isMaterialSheetLinked = false;

  final bool isSRSOrder;

  String? selectedDate;
  DeliveryDateModel? deliveryDate;

  String? selectedMaterialListValue;

  bool get isPastDeliveryDate => DateTimeHelper.isPastDate(selectedDate!, DateFormatConstants.dateServerFormat);

  @override
  void onInit() {

    if(fileParams.fileList.isNotEmpty) {
      deliveryDate = fileParams.fileList.first.deliveryDateModel;
      if (deliveryDate?.deliveryDate != null) {
        formatDate(DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(deliveryDate!.deliveryDate.toString())));
      }
      if (deliveryDate?.note != null) {
        noteController.text = deliveryDate!.note.toString();
      }
    }

    if(materialList?.isNotEmpty ?? false) {
      selectedMaterialListValue = materialList?.first.id;
      linkedListNameController.text = SingleSelectHelper.getSelectedSingleSelectValue(materialList!, selectedMaterialListValue);
    }

    super.onInit();
  }

  String validateExpiresOn(String value) {
    if (value.isEmpty) {
      return "please_provide_delivery_date".tr;
    }

    return '';
  }

  void pickDate() async {

    DateTime firstDate = DateTime.now().add(const Duration(days: 1));

    DateTime? dateTime = await Get.dialog(
      JPDatePicker(
        initialDate: selectedDate == null ? firstDate : DateTime.parse(selectedDate!),
        firstDate: action == FLQuickActions.placeSRSOrder ? firstDate : DateTime.now(),
      ),
    );

    if(dateTime != null){
      formatDate(dateTime);
    }
    validateForm();
  }

  bool validateForm() {
    return formKey.currentState!.validate();
  }

  Future<void> updateDeliveryDate() async {

    if (action == FLQuickActions.placeSRSOrder) {
      fileParams.onActionComplete(
        FilesListingModel(
          deliveryDateModel: DeliveryDateModel(
            deliveryDate: selectedDate,
            note: noteController.text,
          )
        ),
        FLQuickActions.placeSRSOrder,
      );
      Get.back();
      return;
    }

    if(validateForm()){

      try{
        toggleIsUpdatingDeliveryDate();

        Map<String, dynamic> params = {
          'includes[0]' : 'material_list',
          "includes[1]": "delivery_date",
          'jobId' : fileParams.jobModel?.id.toString(),
          if(fileParams.fileList.isNotEmpty)...{
            'materialId': fileParams.fileList.first.deliveryDateModel?.id,
            "material_id": fileParams.fileList.first.id,
          },
          if((materialList?.isNotEmpty ?? false) && isMaterialSheetLinked) ...{
            "material_id": int.parse(selectedMaterialListValue!),
          },
          "delivery_date": selectedDate,
          "note": noteController.text,
        };

         DeliveryDateModel response = await MaterialListsRepository.createUpdateDeliveryDate(params).trackUpdateEvent(MixPanelEventTitle.materialDeliveryDateUpdate);
         if(fileParams.fileList.isNotEmpty) {
           fileParams.fileList.first.deliveryDateModel = response;
           fileParams.onActionComplete(fileParams.fileList.first, FLQuickActions.setDeliveryDate);
           Helper.showToastMessage('delivery_date_updated'.tr);
         } else {
           Helper.showToastMessage('delivery_date_added'.tr);
           fileParams.onActionComplete(FilesListingModel(
             deliveryDateModel: response
           ), FLQuickActions.setDeliveryDate);
         }
         onCancelEditDeliveryDateDialog();


        Get.back();

      } catch(e) {
        Helper.handleError(e);
      } finally {
        toggleIsUpdatingDeliveryDate();
      }

    }
  }

  void formatDate(DateTime dateTime) {
    String dateOnly = dateTime.toString().substring(0,10);
    String formattedDate = DateTimeHelper.convertHyphenIntoSlash(dateOnly);
    materialDateController.text = formattedDate;
    selectedDate = dateOnly;
    update();
  }

  void toggleIsUpdatingDeliveryDate() {
    isUpdatingDeliveryDateStatus = !isUpdatingDeliveryDateStatus;
    update();
  }

  Future<void> onTapEdit() async {
    Get.back();
    await Future<void>.delayed(const Duration(milliseconds: 100));
    FilesListQuickActionPopups.showSetViewDeliveryDateDialog(fileParams, FLQuickActions.setDeliveryDate, isSRSOrder: isSRSOrder);
  }

  Future<void> onCancelEditDeliveryDateDialog() async {
    if(deliveryDate == null) return;
    await Future<void>.delayed(const Duration(milliseconds: 100));
    FilesListQuickActionPopups.showSetViewDeliveryDateDialog(fileParams, FLQuickActions.viewDeliveryDate, isSRSOrder: isSRSOrder);
  }

  void typeToOpenFile() {
    Get.back();
    switch (fileParams.fileList.first.jpThumbType) {
      case JPThumbType.image:

        showJPGeneralDialog(
            child: (_) {
          return PhotosViewerDialog(
                  data: PhotoViewerModel<SetViewDeliveryDateController>(
                    0,
                    [PhotoDetails(
                      fileParams.fileList.first.name ?? '',                      
                      urls: 
                      [
                        fileParams.fileList.first.thumbUrl ?? '',
                        fileParams.fileList.first.originalFilePath ?? '',
                        fileParams.fileList.first.id.toString(),
                      ],
                    )]
                  ),
              );
            },
          allowFullWidth: true,
        );

        break;
      case JPThumbType.icon:
        FileListQuickActionHandlers.downloadAndOpenFile(
            fileParams.fileList.first.originalFilePath ?? '',
            classType: fileParams.fileList.first.classType);
        break;
      default:
        break;
    }
  }

  void cancelOnGoingApiRequest() {
    Helper.cancelApiRequest();
  }

  String getTitle() {
    if(fileParams.fileList.isEmpty || fileParams.fileList.first.deliveryDateModel == null) {
      return 'add_delivery_date'.tr;
    } else {
      return 'edit_delivery_date'.tr;
    }
  }

  void toggleIsMaterialSheetLinked(bool val) {
    isMaterialSheetLinked = !val;
    update();
  }

  void selectMaterialList() {

    if(materialList == null) return;

    SingleSelectHelper.openSingleSelect(
        materialList!,
        selectedMaterialListValue,
        'select_material_list'.tr.toUpperCase(),
            (value) {
          selectedMaterialListValue = value;
          isMaterialSheetLinked = true;
          linkedListNameController.text = SingleSelectHelper.getSelectedSingleSelectValue(materialList!, value);
          update();
          Get.back();
        });
  }

}