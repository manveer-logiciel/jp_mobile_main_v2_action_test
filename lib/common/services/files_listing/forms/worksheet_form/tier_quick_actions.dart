import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/macros/index.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/workflow/tier_service_params.dart';
import 'package:jobprogress/common/repositories/measurements.dart';
import 'package:jobprogress/common/repositories/worksheet.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_worksheet.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_dialogs.dart';
import 'package:jobprogress/common/services/worksheet/calculations.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/measurement_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/position.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../models/forms/worksheet/index.dart';

/// [WorksheetTierQuickActionService] helps in handling all the tier quick actions
/// It communicates with [WorksheetFormService] with help of callbacks
class WorksheetTierQuickActionService {

  /// [getQuickActionList] helps in deciding which actions to be displayed
  static List<JPQuickActionModel> getQuickActionList(WorksheetTierParams params) {

    SheetLineItemModel item = params.lineItem;

    // setting up conditions to show hide tier quick actions
    bool showApplyMeasurement = params.data.worksheetType != WorksheetConstants.workOrder;
    bool hasSubTiers = (item.subTiers?.isNotEmpty ?? false);
    bool hasSubItems = (item.subItems?.isNotEmpty ?? false);
    bool showAddSubTier = item.tier != 3;
    bool showCreateNew = (num.tryParse(item.totalPrice ?? "") ?? 0) > 0;
    bool hasParentMultipleTiers = (item.parent?.subTiers?.length ?? 0) > 1;
    bool hideDeleteTier = (hasParentMultipleTiers || hasSubTiers || (hasSubItems && item.tier == 1 && params.totalCollections != 1));// || (item.tier != 1 && (hasSubItems || hasSubTiers));
    bool hideDeleteTierWithItems = !hasSubTiers && !hasSubItems;
    bool isMeasurementApplied = item.tierMeasurement != null || item.tierMeasurementId != null;
    bool isSrsEnabled = params.data.isSRSEnable && !hasSubTiers;
    bool isSRSV2SupplierId = Helper.isSRSv2Id(Helper.getSupplierId());

    return [
      if (showAddSubTier)
        JPQuickActionModel(id: WorksheetConstants.addSubTier, child: const JPIcon(Icons.format_list_bulleted_add, size: 20), label: 'add_sub_tier'.tr),
      if (!hasSubTiers)
        JPQuickActionModel(id: WorksheetConstants.addItem, child: const JPIcon(Icons.add_box_outlined, size: 20), label: 'add_item'.tr),
      JPQuickActionModel(id: WorksheetConstants.addDescription, child: const JPIcon(Icons.note_alt_outlined, size: 20), label: 'tier_description'.tr),
      JPQuickActionModel(id: WorksheetConstants.rename, child: const JPIcon(Icons.edit_outlined , size: 20), label: 'rename'.tr),
      if (!hasSubTiers)
        JPQuickActionModel(id: WorksheetConstants.macros, child: const JPIcon(Icons.list , size: 20), label: 'macros'.tr),
      if(isSrsEnabled && !isSRSV2SupplierId)
        JPQuickActionModel(id: WorksheetConstants.srsSmartTemplate, child: const JPIcon(Icons.list , size: 20), label: 'srs_smart_template'.tr),
      if (showCreateNew)
        JPQuickActionModel(id: WorksheetConstants.createNew, child: const JPIcon(Icons.note_add_outlined , size: 20), label: 'create_new'.tr),
      if (hasSubTiers)
        JPQuickActionModel(id: WorksheetConstants.removeSubTier, child: const JPIcon(Icons.indeterminate_check_box_outlined, size: 20), label: 'remove_sub_tier'.tr),
      if (showApplyMeasurement) ...{
        if (!isMeasurementApplied) ...{
          JPQuickActionModel(id: WorksheetConstants.applyMeasurement, child: const JPIcon(Icons.refresh, size: 20), label: 'apply_measurement'.tr.capitalize!),
        } else ...{
          JPQuickActionModel(id: WorksheetConstants.linkedMeasurement, child: const JPIcon(Icons.remove_red_eye_outlined, size: 20), label: 'linked_measurement'.tr),
          JPQuickActionModel(id: WorksheetConstants.reapplyMeasurement, child: const JPIcon(Icons.refresh, size: 20), label: 'reapply_measurement'.tr),
          JPQuickActionModel(id: WorksheetConstants.discardMeasurement, child: const JPIcon(Icons.do_not_disturb_on_outlined, size: 20), label: 'discard_measurement'.tr),
        },
      },
      if (!hideDeleteTier || hideDeleteTierWithItems)
        JPQuickActionModel(id: WorksheetConstants.deleteTier, child: const JPIcon(Icons.delete_outline, size: 20), label: 'delete_tier'.tr),
      if (!hideDeleteTierWithItems)
        JPQuickActionModel(id: WorksheetConstants.deleteTierWithItems, child: const JPIcon(Icons.delete_forever_outlined , size: 20), label: 'delete_tier_with_items'.tr),
    ];
  }

  /// [openQuickActions] helps in setting options and opening quick action bottom sheet
  static openQuickActions({required WorksheetTierParams params}) {
    List<JPQuickActionModel> quickActionList = getQuickActionList(params);

    showJPBottomSheet(
        child: (_) => JPQuickAction(
          mainList: quickActionList,
          onItemSelect: (value) {
            Get.back();
            handleQuickActions(value, params);
          },
        ),
        isScrollControlled: true
    );
  }

  /// [handleQuickActions] Handling quick action tap and performs action accordingly
  static Future<void> handleQuickActions(String action, WorksheetTierParams params) async {
    switch (action) {
      case WorksheetConstants.addDescription:
        addDescriptionDialog(params);
        break;

      case WorksheetConstants.addSubTier:
        WorksheetHelpers.showNameDialog(
            title: 'add_sub_tier'.tr,
            label: 'tier_name'.tr,
            onDone: (name) async => addSubTier(params, name));
        break;

      case WorksheetConstants.rename:
        WorksheetHelpers.showNameDialog(
            title: 'rename_tier'.tr,
            label: 'tier_name'.tr,
            filledValue: params.lineItem.title,
            onDone: (name)  async => renameTier(params, name));
        break;

      case WorksheetConstants.createNew:
        WorksheetHelpers.showNameDialog(
            title: WorksheetHelpers.worksheetTypeToTitle(params.data.worksheetType, saveAs: true),
            label: 'name'.tr,
            filledValue: WorksheetHelpers.getDefaultSaveName(params.data.worksheetType),
            onDone: (name) => createNew(params, name),);
        break;

      case WorksheetConstants.deleteTier:
        WorksheetHelpers.showConfirmation(
          subTitle: '${'you_are_about_to_remove'.tr} ${params.lineItem.title}. ${'press_confirm_to_proceed'.tr}',
          onConfirmed: () => deleteTier(params),
        );
        break;

      case WorksheetConstants.removeSubTier:
        WorksheetHelpers.showConfirmation(
          subTitle: '${'you_are_about_to_remove'.tr} ${params.lineItem.title}\'s ${'remove_sub_item_desc'.tr}',
          onConfirmed: () => removeSubTier(params),
        );
        break;

      case WorksheetConstants.deleteTierWithItems:
        showDeleteWithItemsConfirmation(params);
        break;

      case WorksheetConstants.applyMeasurement:
        selectMeasurement(params);
        break;

      case WorksheetConstants.reapplyMeasurement:
        applyMeasurement(params, reApply: true);
        break;

      case WorksheetConstants.discardMeasurement:
        discardMeasurement(params);
        break;

      case WorksheetConstants.linkedMeasurement:
        if (params.lineItem.tierMeasurementId != null)  await applyMeasurement(params);
        WorksheetHelpers.openFile(params.lineItem.tierMeasurement?.filePath);
        break;

      case WorksheetConstants.macros:
        WorksheetHelpers.navigateToMacros(
            isEnableSellingPrice: params.data.settings!.enableSellingPrice ?? false,
            worksheetType: params.data.worksheetType,
            forSupplierId: params.data.workSheet?.materialList?.forSupplierId,
            srsSupplierId: getSupplierId(params.data),
            srsBranchCode: params.data.selectedSrsBranch?.branchCode,
            beaconBranchCode: params.data.selectedBeaconBranch?.branchCode,
            abcBranchCode: params.data.selectedAbcBranch?.branchCode,
            shipToSequenceId: params.data.selectedSrsShipToAddress?.shipToSequenceId,
            jobDivisionId: params.data.job?.division?.id,
            onDone: (macros) => addMacros(macros, params)
        );
        break;

      default:
        params.onActionComplete(action);
    }
  }

  /// [getLineItems] returns line items to perform action on
  /// [excludeMeasurement] - helps in excluding items which are part of measurement
  static List<SheetLineItemModel> getLineItems(WorksheetTierParams params, {
    int? tierLevel
  }) {
    List<SheetLineItemModel> items = WorksheetHelpers.getParsedItems(lineItems: [params.lineItem]);
    if (tierLevel != null) items.removeWhere((item) => item.doAddTierMeasurement(tierLevel));
    return items;
  }

  /// [addDescriptionDialog] opens up a dialog to add tier description
  static void addDescriptionDialog(WorksheetTierParams params) {
    final bool isEdit = (params.lineItem.description ?? "").isNotEmpty;

    showJPGeneralDialog(
        child: (_){
          return JPWillPopScope(
            onWillPop: () async => false,
            child: JPQuickEditDialog(
                title: (isEdit ? 'update_description'.tr.toUpperCase() : 'add_description'.tr).toUpperCase(),
                label: 'description'.tr,
                fillValue: params.lineItem.description ?? "",
                maxLength: 250,
                position: JPQuickEditDialogPosition.center,
                type: JPQuickEditDialogType.textArea,
                suffixTitle: 'save'.tr,
                prefixTitle: 'cancel'.tr.toUpperCase(),
                onPrefixTap:(value) => Get.back(),
                onSuffixTap: (value) {
                  params.lineItem.description = value.trim();
                  Get.back();
                  params.onActionComplete(WorksheetConstants.addDescription);
                }
            ),
          );
        }
    );
  }

  /// [addSubTier] helps in adding sub tier to already existing tier. It also
  /// extracts items from parent tier and add them to sub tier
  static void addSubTier(WorksheetTierParams params, String name) {

    SheetLineItemModel lineItem = params.lineItem;
    int currentTier = lineItem.tier ?? -1;

    bool replicatedName = WorksheetHelpers.verifyTierName(lineItem.subTiers, name);
    if (replicatedName) return;

    if (currentTier > 0 && currentTier < 3) {
      // extracting items from parent tier
      List<SheetLineItemModel> tempLineItems = [];
      if (Helper.isValueNullOrEmpty(lineItem.subTiers)) {
        tempLineItems.addAll(lineItem.subItems ?? []);
      }
      lineItem.subItems?.clear();
      lineItem.subTiers ??= [];
      // Calculating line item amounts
      final amounts = WorksheetCalculations.getTierAmounts(tempLineItems);
      final tier = SheetLineItemModel.tier(
          title: name,
          totalPrice: '',
          subItems: tempLineItems,
          tier: currentTier + 1,
          parent: lineItem,
          workSheetSettings: params.data.settings
      );
      // updating amount in sub tier
      tier.setTierSubTotals(amounts);
      // adding items to parent tier
      lineItem.subTiers?.add(tier);
    }
    params.onActionComplete(WorksheetConstants.addSubTier);
    Get.back();
  }

  /// [renameTier] helps in renaming tier
  static void renameTier(WorksheetTierParams params, String name) {

    SheetLineItemModel lineItem = params.lineItem;
    bool isRootItem = lineItem.tier == 1;

    List<SheetLineItemModel>? items = isRootItem ? params.data.lineItems : lineItem.parent?.subTiers;

    bool replicatedName = WorksheetHelpers.verifyTierName(items, name, avoidName: lineItem.title);
    if (replicatedName) return;

    lineItem.title = name;
    Get.back();
    params.onActionComplete(WorksheetConstants.rename);
  }

  /// [createNew] can be used to create new worksheet from tier or sub tiers
  static Future<void> createNew(WorksheetTierParams params, String name) async {
    final items = WorksheetHelpers.getParsedItems(lineItems: [params.lineItem], tierIndex: params.lineItem.tier ?? 1);

    final json = params.worksheetJson.call(items, name: name);
    try {
      await WorksheetRepository.saveWorksheet(json);
      Helper.showToastMessage('worksheet_created'.tr);
      params.onActionComplete(WorksheetConstants.createNew);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  /// [deleteTier] can be used to delete tier
  static deleteTier(WorksheetTierParams params, {
    bool removeItems = false,
  }) {
    int currentItemTier = params.lineItem.tier ?? -1;
    WorksheetHelpers.deAttachTierDetails(params.lineItem.subItems??[]);
    // in case parent tier, removing it from list
    if (currentItemTier == 1) {
      if (removeItems) removeSubTier(params, removeItems: removeItems);
      params.onActionComplete.call(WorksheetConstants.removeCollection);
    } else if (currentItemTier > -1) {
      // otherwise removing sub tiers
      SheetLineItemModel? removeTiersFor = params.lineItem.parent;
      if (removeTiersFor != null) {
        final tierIndex = removeTiersFor.subTiers?.indexWhere((tier) => tier.title == params.lineItem.title) ?? -1;
        if (tierIndex >= 0) removeSubTier(params, item: removeTiersFor, index: tierIndex, removeItems: removeItems);
      }
    }
  }

  /// [removeSubTier] helps in removing all the sub tiers, it also extracts items from sub tier
  /// and add them to parent tier
  /// [removeItems] - helps in removing tier items along with tier
  static removeSubTier(WorksheetTierParams params, {
    SheetLineItemModel? item,
    int? index,
    bool removeItems = false
  }) {
    List<SheetLineItemModel> subItems = [];
    item ??= params.lineItem;
    item.subItems?.clear();

    if (!removeItems) {
      WorksheetHelpers.tierIterator(item, action: (item) => subItems.addAll(item.subItems ?? []));
      item.subItems?.addAll(subItems);
    }

    if (index == null) {
      item.subTiers = [];
    } else {
      item.subTiers?.removeAt(index);
    }
    params.onActionComplete.call(WorksheetConstants.removeSubTier);
  }

  /// [deleteTierWithItems] can be used to delete tier along with it's items
  static deleteTierWithItems(WorksheetTierParams params) {
    deleteTier(params, removeItems: true);
    Get.back();
  }

  static void addMacros(List<MacroListingModel> macros, WorksheetTierParams params) {
    params.lineItem.subItems ??= [];
    List<SheetLineItemModel> items = WorksheetHelpers.parseMacroToLineItems(macros,
        settings: params.data.settings,
        allTrades: params.data.allTrades,
    );
    params.lineItem.subItems?.addAll(items);
    params.onActionComplete.call(WorksheetConstants.macros);
  }

  /// [selectMeasurement] opens up measurement selection list to select measurement from
  static void selectMeasurement(WorksheetTierParams params) {
    FilesListQuickActionPopups.showMeasurementSelectionSheet(
      jobId: params.jobId,
      onFilesSelected: (file) async {
        await applyMeasurement(params, id: file.id!);
      },
    );
  }

  /// [applyMeasurement] loads measurements from server to apply
  /// This function can also be used to re-apply measurement by setting [reApply] to [true]
  /// In case of edit this function also handles loading measurement for re-applying
  /// [parent] can be used to get measurement details of parent
  static Future<void> applyMeasurement(WorksheetTierParams params, {
    String? id,
    bool reApply = false,
    SheetLineItemModel? parent
  }) async {
    try {
      showJPLoader();

      Map<String,dynamic> requestParams = {
        'includes[0]': 'measurement_details',
        'includes[1]': 'created_by',
      };

      final data = parent ?? params.lineItem;
      // loading items
      final items = getLineItems(params, tierLevel: data.tier);
      // deciding whether measurement needs to be loaded from server or not
      // measurement has to be loaded if it's getting applied from the first time
      // or it was already applied but the case was edit as in edit case only
      // measurement id is available
      bool applyMeasurement = id != null;
      bool doLoadMeasurement = applyMeasurement || (data.tierMeasurementId != null && data.tierMeasurement == null);

      if (doLoadMeasurement) {
        final measurementId = id ?? data.tierMeasurementId;
        data.tierMeasurement = await MeasurementsRepository.fetchMeasurementDetail(requestParams, measurementId!.toString());
        data.tierMeasurementId = null;
      }

      final tempMeasurement = data.tierMeasurement ?? params.data.worksheetMeasurement;

      if (tempMeasurement == null) return;
      // updating items to show quantity as of measurement
      MeasurementHelper.getAppliedMeasurementItems(tempMeasurement, items);
      WorksheetHelpers.reCalculateLineTotal(items);

      if (reApply) {
        Helper.showToastMessage('measurement_reapplied'.tr.capitalizeFirst!);
        params.onActionComplete.call(WorksheetConstants.reapplyMeasurement);
      } else if (applyMeasurement) {
        Helper.showToastMessage('measurement_applied'.tr.capitalizeFirst!);
        params.onActionComplete.call(WorksheetConstants.applyMeasurement);
      }

    } catch(e){
      rethrow;
    } finally {
      Get.back();
    }
  }

  /// [discardMeasurement] helps in unlinking linked measurement. It also searches
  /// for if parent has measurement when child's measurement is removed and applies it
  static void discardMeasurement(WorksheetTierParams params) {
    // removing worksheet data
    params.lineItem.tierMeasurement = null;
    params.lineItem.tierMeasurementId = null;
    final items = getLineItems(params, tierLevel: params.lineItem.tier);
    // recalculating amounts
    WorksheetHelpers.reCalculateLineTotal(items, resetQuantity: true);
    Helper.showToastMessage('measurement_discarded'.tr.capitalizeFirst!);

    // searching for whether parent has any measurement attached
    SheetLineItemModel? parentItemWithMeasurement = WorksheetHelpers.getParentMeasurementItem(params.lineItem);

    // applying measurement if there is any attached to parent
    bool hasParentMeasurement = parentItemWithMeasurement != null || params.data.worksheetMeasurement != null;
    if (hasParentMeasurement) applyMeasurement(params, parent: parentItemWithMeasurement);

    params.onActionComplete.call(WorksheetConstants.discardMeasurement);
  }

  /// [showDeleteWithItemsConfirmation] displays confirmation dialog on removing tier
  static showDeleteWithItemsConfirmation(WorksheetTierParams params) {
    showJPBottomSheet(child: (_) => JPConfirmationDialog(
      title: 'confirmation'.tr,
      icon: Icons.warning_amber_rounded,
      subTitle: '${'you_are_about_to_remove'.tr} ${params.lineItem.title} ${'along_with_its_items_confirmation'.tr}',
      suffixBtnText: 'confirm'.tr,
      prefixBtnText: 'cancel'.tr,
      onTapPrefix: Get.back<void>,
      onTapSuffix: () => deleteTierWithItems(params),
    ));
  }

  static int? getSupplierId(WorksheetFormData data) {
    int? supplierId;
    if (data.isSRSEnable) {
      if(data.workSheet?.materialList?.forSupplierId != null) {
        supplierId = data.workSheet?.materialList?.forSupplierId?.toInt();
      } else if(!Helper.isValueNullOrEmpty(data.workSheet?.suppliers)) {
        supplierId = data.workSheet?.suppliers?.first.id;
      } else {
        supplierId = Helper.getSupplierId();
      }
    }
    return supplierId;
  }
}