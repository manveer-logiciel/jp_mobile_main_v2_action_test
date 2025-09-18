import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/enums/insurance_form_type.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/services/files_listing/forms/insurance_form_view/index.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/financial_form/add_item_bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class InsuranceFormController extends GetxController {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey();
  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing

  late InsuranceFormService service;

  JobModel ? job;
  String? worksheetId;
  InsuranceFormType? pageType;
  Map<String, dynamic>? insurancePdfJson;

  @override
  void onInit() async {
    init();
    super.onInit();
  }

  /////   init(): will set up form service and form data    /////

  Future<void> init() async {
    job = Get.arguments?[NavigationParams.jobModel];
    pageType = Get.arguments?[NavigationParams.pageType];
    worksheetId = Get.arguments?[NavigationParams.id] ?? '';
    insurancePdfJson = Get.arguments?[NavigationParams.insurancePdfJson];

    /////   setting up service    /////
    service = InsuranceFormService(
      update: update,
      jobModel: job,
      workSheetId: worksheetId,
      pageType: pageType,
      insurancePdfJson: insurancePdfJson,
    );

    service.controller = this;
    await service.initForm(); // setting up form data
  }
  

  void onListItemReorder(int oldIndex, int newIndex) {
    if (oldIndex <= newIndex) {
      newIndex -= 1;
    }
    if(oldIndex == newIndex) return;

    reorderItem(oldIndex, newIndex);
  }

  void reorderItem(int oldIndex, int newIndex) {
    final SheetLineItemModel temp = service.insuranceItems.removeAt(oldIndex);
    service.insuranceItems.insert(newIndex, temp);
    update();
  }
  

  void editInsuranceItem(SheetLineItemModel item) {
    showJPBottomSheet(
      isScrollControlled: true,
      ignoreSafeArea: false,
      child: (controller) => AddItemBottomSheetForm(
        categoryId: service.insuranceCategoryDetail!.id.toString(),
        pageType: AddLineItemFormType.insuranceForm,
        sheetLineItemModel: item,
        onSave : (SheetLineItemModel sheetLineItemModel) =>
          service.setInsuranceItemsList(sheetLineItemModel, isEdit: true),
      ),
    );
  }

  Future<bool> onWillPop() async {
    Helper.hideKeyboard();
    if(service.checkIfNewDataAdded()) {
      Helper.showUnsavedChangesConfirmation();
    } else {
      Get.back();
    }
    return false;
  }
}