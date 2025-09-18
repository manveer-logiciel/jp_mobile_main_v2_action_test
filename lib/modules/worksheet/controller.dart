import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/worksheet.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_worksheet.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../common/models/forms/worksheet/supplier_form_params.dart';
import 'widgets/attachements/index.dart';

class WorksheetFormController extends GetxController {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey();
  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing

  late WorksheetFormService service;

  int? jobId = Get.arguments?[NavigationParams.jobId];
  int? worksheetId = Get.arguments?[NavigationParams.worksheetId];
  int? dbUnsavedResourceId = Get.arguments?[NavigationParams.dbUnsavedResourceId];
  bool hidePriceDialog = Get.arguments?[NavigationParams.hidePriceDialog] ?? false;

  FLModule? module = Get.arguments?[NavigationParams.worksheetType] ?? FLModule.estimate;

  WorksheetFormType formType = Get.arguments?[NavigationParams.worksheetFormType] ?? WorksheetFormType.add;

  bool removeIntegratedSupplierItems = Get.arguments?[NavigationParams.removeIntegratedSupplierItems] ?? false;

  MaterialSupplierFormParams? materialSupplierFormParams = Get.arguments?[NavigationParams.materialSupplierFormParams];

  bool showVariationConfirmationValidation = Get.arguments?[NavigationParams.showVariationConfirmationValidation] ?? false;

  String get saveButtonTitle {
    if (service.isEditForm) {
      return 'update'.tr.toUpperCase();
    } else {
      return 'save'.tr.toUpperCase();
    }
  }

  String get typeToTitle {
    switch (module) {
      case FLModule.estimate:
        return 'estimate_worksheet'.tr;

      case FLModule.materialLists:
        return 'material_list_worksheet'.tr;

      case FLModule.workOrder:
        return 'work_order_worksheet'.tr;

      case FLModule.jobProposal:
        return 'proposal_worksheet'.tr;

      default:
        return "";
    }
  }

  @override
  Future<void> onInit() async {
    String worksheetType = moduleToWorksheetType();

    service = WorksheetFormService(
      update: update,
      jobId: jobId,
      worksheetId: worksheetId,
      worksheetType: worksheetType,
      formType: formType,
      flModule: module,
      dbUnsavedResourceId: dbUnsavedResourceId,
      hidePriceDialog: hidePriceDialog,
      removeIntegratedSupplierItems: removeIntegratedSupplierItems,
      materialSupplierFormParams: materialSupplierFormParams,
      resetDbUnsavedResourceId: () {
        dbUnsavedResourceId = null;
      },
      showVariationConfirmationValidation: showVariationConfirmationValidation
    );
    if(!RunModeService.isUnitTestMode) {
      service.initForm();
    }
    super.onInit();
  }

  Future<bool> onWillPop() async {
    Helper.hideKeyboard();

    if(service.checkIfNewDataAdded() || dbUnsavedResourceId != null) {
      Helper.showUnsavedChangesConfirmation(unsavedResourceId: service.dbUnsavedResourceId);
    } else {
      if(!service.isDBResourceIdFromController) service.deleteUnsavedResource();
      Get.back(result: service.isSavedOnTheGo);
    }
    return false;
  }

  String moduleToWorksheetType() {
    switch (module) {
      case FLModule.estimate:
        return WorksheetConstants.estimate;

      case FLModule.materialLists:
        return WorksheetConstants.materialList;

      case FLModule.workOrder:
        return WorksheetConstants.workOrder;

      case FLModule.jobProposal:
        return WorksheetConstants.proposal;

      default:
        return "";
    }
  }

  void showAttachmentSheet() {
    showJPBottomSheet(
        child: (_) => WorksheetAttachments(controller: this),
        isScrollControlled: true
    );
  }

  @override
  Future<void> dispose() async {
    await service.stream?.cancel();
    super.dispose();
  }
}