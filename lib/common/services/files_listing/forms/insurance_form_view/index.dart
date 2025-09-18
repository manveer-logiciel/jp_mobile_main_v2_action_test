import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/enums/insurance_form_type.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/insurance_worksheet/index.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/repositories/estimations.dart';
import 'package:jobprogress/common/repositories/measurements.dart';
import 'package:jobprogress/common/services/download.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_handlers.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/constants/forms/insurance_form.dart';
import 'package:jobprogress/core/constants/mix_panel/event/add_events.dart';
import 'package:jobprogress/core/constants/mix_panel/event/edit_events.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/measurement_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/calculator/calculator.dart';
import 'package:jobprogress/global_widgets/financial_form/add_item_bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jobprogress/modules/files_listing/forms/insurance/controller.dart';
import 'package:jobprogress/modules/files_listing/widgets/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/position.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../core/utils/form/db_helper.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../global_widgets/bottom_sheet/index.dart';
import '../../../../../global_widgets/loader/index.dart';
import '../../../../../routes/pages.dart';
import '../../../../models/files_listing/files_listing_quick_action_params.dart';
import '../../../../models/macros/index.dart';
import '../../../../repositories/macros.dart';
import '../../../forms/value_selector.dart';
import '../../quick_action_dialogs.dart';

class InsuranceFormService extends InsuranceFormData {
  InsuranceFormService({
    required super.update,
    super.jobModel,
    String? workSheetId,
    super.pageType,
    super.insurancePdfJson,
  }) : super(
    worksheetId: workSheetId,
  );

  InsuranceFormController? _controller; // helps in managing controller without passing object

  InsuranceFormController get controller => _controller ?? InsuranceFormController();

  set controller(InsuranceFormController value) => _controller = value;

  // initForm(): initializes form data
  Future<void> initForm() async {
    // delay to prevent navigation animation lags
    // because as soon as we enter form page a request to local DB is made
    // resulting in ui lag. This delay helps to avoid running both tasks in parallel
    await Future<void>.delayed(const Duration(milliseconds: 200));

    showJPLoader();

    try {
      await setUpAPIData(); // loading form data from server
      setFormData(); // filling form data
      initialJson = insuranceFormJson();
      if (insurancePdfJson != null) {
        setInsuranceFormDataFromPdfJson(insurancePdfJson!);
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      Get.back();
      update();
    }
  }

  Future<void> fetchCategoryList() async {
    
    Map<String, dynamic> categoryParams = {'include_insurance_category': '1'};
    
    try {
      categoryList = await EstimatesRepository.fetchCategories(categoryParams);
    } catch(e) {
      rethrow;
    }
   
  }

  void setCategoryOfInsuranceItems() {
    if(!Helper.isValueNullOrEmpty(categoryList)){
      insuranceCategoryDetail = categoryList.firstWhere((element) => element.slug == 'insurance');
    }
    
    if(insuranceItems.isNotEmpty){
      for (var insuranceItem in insuranceItems) {
        insuranceItem.category = insuranceCategoryDetail; 
      }
    }
  }

  Future<void> fetchInsuranceWorksheet({String? id}) async {
    Map<String, dynamic> estimateParams = {
      'id': id ?? worksheetId,
      'includes[0]': 'division'
    };

    try {
      estimate = await EstimatesRepository.fetchWorksheet(estimateParams);
    } catch(e) {
      rethrow;
    }
  }

  Future<void> fetchAllDivisions() async {
    try {
      divisionsList = await FormsDBHelper.getAllDivisions();
    } catch (e) {
      rethrow;
    } finally {
      update();
    }
  }
  
  // setUpAPIData(): loads users from local DB & also fill fields with selected users
  Future<void> setUpAPIData() async {
     await Future.wait([
      fetchCategoryList(),
      if(pageType == InsuranceFormType.edit) fetchInsuranceWorksheet(),
      fetchAllDivisions(),
    ]); 
    setCategoryOfInsuranceItems();
  }

  List<PopoverActionModel> getActions() {
    List<PopoverActionModel> actions = [
      PopoverActionModel(label: 'preview'.tr.capitalize!,value: InsuranceFormConstant.preview),
      if(isMeasurementApplied)PopoverActionModel(label: 'preview_measurement'.tr.capitalize!, value: InsuranceFormConstant.previewMeasurement),
      if(!isMeasurementApplied)PopoverActionModel(label: 'apply_measurement'.tr.capitalize!,value: InsuranceFormConstant.applyMeasurement),
      PopoverActionModel(label: 'select_favorite'.tr.capitalize!,value: InsuranceFormConstant.selectFavorite),
      PopoverActionModel(label: 'select_macros'.tr.capitalize!,value: InsuranceFormConstant.selectMacro),
      if(isMeasurementApplied) PopoverActionModel(label: 'reapply_measurement'.tr.capitalize!, value: InsuranceFormConstant.reapplyMeasurement),
      if(isMeasurementApplied)PopoverActionModel(label: 'discard_measurement'.tr.capitalize!,value: InsuranceFormConstant.discardMeasurement),
      PopoverActionModel(label: 'calculator'.tr.capitalize!, value: InsuranceFormConstant.calculator)
    ];
    return actions;
  }

  // checkIfNewDataAdded(): used to compare form data changes
  bool checkIfNewDataAdded() => initialJson.toString() != insuranceFormJson().toString();

///////////////////////////     SELECT DIVISION     //////////////////////

  void selectDivision() {
    FormValueSelectorService.openSingleSelect(
      title: 'select_division'.tr,
      list: divisionsList,
      controller: divisionController,
      selectedItemId: selectedDivision?.id ?? "",
      onValueSelected: (val) {
        selectedDivision = divisionsList.firstWhereOrNull((element) => element.id == val);
        update();
      }
    );
  }

  Future<void> getSelectedMacros(List<String> macrosIds) async {
    final params = MacroListingModel.getViewSelectedMacroParams(macrosIds);
    final response = await MacrosRepository().fetchSelectedMacrosData(params, type: AddLineItemFormType.insuranceForm);
    List<SheetLineItemModel> items = [];
    for (MacroListingModel macro in response) {
      items.addAll(macro.details ?? []);
    }
    
    insuranceItems.addAll(items);
    calculateValues();
    update();
  }

///////////////////////////     OPEN INSURANCE NOTE DIALOG     //////////////////////////

  void openAddEditNotesDialog(String? val) {
    final bool isEdit = note.isNotEmpty;

    showJPGeneralDialog(
        child: (_){
          return JPQuickEditDialog(
            title: isEdit ? 'update_note'.tr.toUpperCase() : 'add_note'.tr.toUpperCase(),
            label: 'note'.tr,
            fillValue: isEdit ? note : null,
            maxLength: 230,
            position: JPQuickEditDialogPosition.center,
            type: JPQuickEditDialogType.textArea,
            suffixTitle: 'save'.tr,
            prefixTitle: 'cancel'.tr.toUpperCase(),
            onPrefixTap: (value) {
              Get.back();
            },
            onSuffixTap: (value) {
              note = value.trim();
              update();
              Get.back();
            }
          );
        }
    );
  }
  
  void toggleIsInsuranceInfo(bool val) {
    isInsuranceInfoUpdated = !isInsuranceInfoUpdated;
    update();
  }

  void setInsuranceItemsList(SheetLineItemModel sheetLineItemModel, {bool isEdit = false}) {
    if(isEdit) {
      if(sheetLineItemModel.currentIndex != null) {
        insuranceItems[sheetLineItemModel.currentIndex!] = sheetLineItemModel;
      }
    } 
    else {
      insuranceItems.add(sheetLineItemModel);
    }

    calculateValues();

    update();
  }

  Future<void> openAddItemBottomSheet() async {
    showJPBottomSheet(
        child: (_) =>  AddItemBottomSheetForm(
          categoryId: insuranceCategoryDetail?.id.toString(),
          pageType: AddLineItemFormType.insuranceForm,
          onSave :setInsuranceItemsList,
        ),
        isScrollControlled: true,
        ignoreSafeArea: false
    );
  }

  void deleteItem(int index) {
    insuranceItems.removeAt(index);

    calculateValues();

    update();
  }

  Future<void> createInsuranceApiCall(JPBottomSheetController controller) async {
    try {
      controller.toggleIsLoading();
      final success = await EstimatesRepository.createInsurance(insuranceFormJson());
      if (success) {
        Helper.showToastMessage('insurance_created'.tr.capitalizeFirst!);
        MixPanelService.trackEvent(event:  MixPanelAddEvent.form);
        Get.back();
        Get.back(result: success);
      }
    } catch (e) {
      rethrow;
    } finally {
      controller.toggleIsLoading();
    }
  }

  void toggleIsSaving() {
    isSavingForm = !isSavingForm;
    update();
  }

  Future<void> updateInsuranceApiCall() async {
    toggleIsSaving();
 
    try {
      final success = await EstimatesRepository.createInsurance(insuranceFormJson());
      if (success) {
        Helper.showToastMessage('insurance_updated'.tr.capitalizeFirst!);
        MixPanelService.trackEvent(event: MixPanelEditEvent.form);
        Get.back(result: success);
      }
    } catch (e) {
      rethrow;
    } finally {
      toggleIsSaving();
    }
  }

  Future<void> previewInsuranceAsPdf() async {
    showJPLoader(msg: 'downloading'.tr);
    try {
      String filePath = await EstimatesRepository.previewInsurance(insuranceFormJson());
      String fileName = '${FileHelper.getFileName(filePath)}.pdf';
      await DownloadService.downloadFile(filePath, fileName, action: 'open');
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }
  
  Future<void> selectMacro() async {
    final response = await Get.toNamed(Routes.macroListing);
    if (response is List<String>) {
      getSelectedMacros(response);
    }
  }

  Future<void> applyMeasurement() async {
    showMeasurementBottomSheet(
      onFilesSelected: (id) async {
        await measurementDetailApiRequest(id);
        insuranceItems = MeasurementHelper.getAppliedMeasurementItems(measurement!, insuranceItems);
        calculateValues();
        isMeasurementApplied = true;
        Helper.showToastMessage('measurement_applied'.tr.capitalizeFirst!);
        update();
      },
    );
  }

  Future<void> selectFavorite() async {
    String? favouriteId;
    await showFavouriteListingBottomSheet(
      setFavouriteWorksheet: (id){
        favouriteId = id;
      },
      onTapUnFavourite: (id){
        FilesListQuickActionPopups.showConfirmationBottomSheet(
          FilesListingQuickActionParams(
            fileList: [],
            onActionComplete: (model, action) {},
            type: FLModule.estimate),FLQuickActions.unMarkAsFavourite);          
      },
    );
    if(favouriteId != null){
      if((estimate != null && estimate!.worksheet!.lineItems!.isNotEmpty) || insuranceItems.isNotEmpty){
        WorksheetHelpers.showConfirmation(
          subTitle: 'apply_favourite_desc'.tr,
          onConfirmed: () async {
            await fetchInsuranceWorksheet(id: favouriteId);
            setFormData();
            xactimateFileName = null;
            update();
          }
        );
      } else {
        await fetchInsuranceWorksheet(id: favouriteId);
        setFormData();
        update();
      }
    }
  }

  Future<void> reapplyMeasurement() async {
    if(measurement == null) {
      await measurementDetailApiRequest(measurementId!);
    }
    insuranceItems = MeasurementHelper.getAppliedMeasurementItems(measurement!, insuranceItems);
    calculateValues();
    update();
  }
  
  void discardMeasurement() {
    for (var item in insuranceItems) {
        item.qty = item.actualQty ?? '0';
    }
    isMeasurementApplied = false;
    measurementId = '';
    calculateValues();
    update();
  }

  void openCalculatorDialogBox() {
    showJPGeneralDialog(
      isDismissible: false,
      child:(_)=> const FloatingCalculator());
  }

  void previewMeasurement() async {
    if(measurement == null) {
      await measurementDetailApiRequest(measurementId!);
      measurementPath = measurement!.filePath;
    }
    FileListQuickActionHandlers.downloadAndOpenFile(measurementPath);
  }

  Future<void> measurementDetailApiRequest(String id) async {
    Map<String,dynamic> params = {
      'includes[0]': 'measurement_details',
      'includes[1]': 'created_by',
    };

    try {
      measurement = await  MeasurementsRepository.fetchMeasurementDetail(params, id);
    } catch(e){
      rethrow;
    }
  }
  
  void onTapMoreActionIcon (PopoverActionModel moreIconActions) async{
    switch(moreIconActions.value) {
      case InsuranceFormConstant.preview:
        previewInsuranceAsPdf(); 
        break;
      case InsuranceFormConstant.applyMeasurement:
        applyMeasurement();
        break;
      case InsuranceFormConstant.reapplyMeasurement:
        await reapplyMeasurement();
        Helper.showToastMessage('measurement_applied'.tr.capitalizeFirst!);
        break;
      case InsuranceFormConstant.discardMeasurement:
        discardMeasurement();
        Helper.showToastMessage('measurement_discarded'.tr.capitalizeFirst!);
        break;
      case InsuranceFormConstant.previewMeasurement:
        previewMeasurement();
        break;
      case InsuranceFormConstant.calculator:
        openCalculatorDialogBox();
        break;
      case InsuranceFormConstant.selectMacro:
        selectMacro();
        break;
      case InsuranceFormConstant.selectFavorite:
        selectFavorite();
        break;
    }
  }
  
  void showSaveDialog() {
    if(isInsuranceInfoUpdated && ((
      jobModel?.parentId != null && 
      jobModel?.parent?.jobTypes?[0]?.name?.toLowerCase() != InsuranceFormConstant.insuranceClaim) ||
      jobModel?.jobTypes?[0]?.name?.toLowerCase() != InsuranceFormConstant.insuranceClaim)) {
      
      showJPBottomSheet(child: (controller){
        return JPConfirmationDialog(
          title: 'confirmation'.tr,
          subTitle: 'you_are_about_to_create_an_insurance_estimate_worksheet'.tr,
          onTapSuffix: () async{
             Get.back();
            await saveData();
          },
        );
      });
    } else {
      saveData();
    }
  }

  Future<void> saveData() async {
    if(insuranceItems.isEmpty) {
      Helper.showToastMessage('please_add_item_first'.tr);
    } else if(totalACV <= 0) {
      Helper.showToastMessage('total_amount_should_be_greater_than_zero'.tr);
    }
     else {
      if(pageType == InsuranceFormType.add) {
        FocusNode nameDialogFocusNode = FocusNode();
        showJPGeneralDialog(
          isDismissible: isSavingForm,
          child: (controller){
            return JPQuickEditDialog(
              title: 'save_insurance_worksheet'.tr.toUpperCase(),
              type: JPQuickEditDialogType.inputBox,
              fillValue: 'estimate'.tr.capitalize,
              label: 'insurance_name'.tr.capitalize,
              suffixIcon: showJPConfirmationLoader(show: controller.isLoading),
              disableButton: controller.isLoading,
              onSuffixTap: (val) async {
                fileName = val;
                setCategoryOfInsuranceItems();
                await createInsuranceApiCall(controller);
              },
              focusNode: nameDialogFocusNode,
              suffixTitle: controller.isLoading ? '' : 'save'.tr.toUpperCase(),
              maxLength: 50,
            );
          }
        );
        await Future<void>.delayed(const Duration(milliseconds: 400));
        nameDialogFocusNode.requestFocus();
      } else {
        if(checkIfNewDataAdded()) {
          setCategoryOfInsuranceItems();
          await updateInsuranceApiCall();
        } else {
          Helper.showToastMessage('no_changes_made'.tr);
        }    
      }
    }
  }

  void onNoteChange(String? val) {
    note = val ?? "";
    update();
  }

  void showMeasurementBottomSheet({required Function(String i) onFilesSelected}) {
    showJPBottomSheet(
        child: (_) => GetBuilder<FilesListingController>(
          init: FilesListingController(
            mode: FLViewMode.apply,
            attachType: FLModule.measurements,
            attachJobId: jobModel!.id,
            allowMultipleSelection: false
          ),
          global: false,
          builder: (FilesListingController controller) {
            return JPSafeArea(
              bottom: false,
              child: FilesView(
                controller: controller,
                onTapAttach: (List<FilesListingModel> selectedFiles) async {
                    onFilesSelected(selectedFiles.first.id!);
                    measurementId = selectedFiles.first.id;
                    measurementPath = selectedFiles.first.originalFilePath;
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
  Future<void> showFavouriteListingBottomSheet({required Function(String id) setFavouriteWorksheet,required Function(String id) onTapUnFavourite}) async {
     await showJPBottomSheet(
        child: (_) => GetBuilder<FilesListingController>(
          init: FilesListingController(
            mode: FLViewMode.apply,
            attachType: FLModule.favouriteListing,
            attachJobId: jobModel!.id,
            allowMultipleSelection: false
          ),
          global: false,
          builder: (FilesListingController controller) {
            return JPSafeArea(
              bottom: false,
              child: FilesView(
                controller: controller,
                onTapAttach: (List<FilesListingModel> selectedFiles) async {
                    setFavouriteWorksheet(selectedFiles.first.favouriteFile!.worksheetId.toString());
                    Get.back();
                },
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

}

  