import 'package:get/get.dart';
import 'package:jobprogress/common/enums/attach_file.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/templates.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/forms/worksheet/index.dart';
import 'package:jobprogress/common/models/job/job_division.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/workflow/header_action_params.dart';
import 'package:jobprogress/common/models/worksheet/amounts.dart';
import 'package:jobprogress/common/repositories/cookies.dart';
import 'package:jobprogress/common/repositories/measurements.dart';
import 'package:jobprogress/common/repositories/worksheet.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_worksheet.dart';
import 'package:jobprogress/common/services/files_listing/mark_as_favourite/index.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_dialogs.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_repo/index.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/common/services/worksheet/calculations.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/measurement_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/calculator/calculator.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/worksheet/widgets/division_selector/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// [WorksheetMoreActionService] is responsible for handling all the more actions of worksheet
/// from it's conditions to each and every action it talks with the [WorksheetFormService] with callbacks
class WorksheetMoreActionService {

  /// [params] holds data coming from main service file
  late WorksheetHeaderActionParams params;

  WorksheetFormData get data => params.data;

  List<JPSingleSelectModel> worksheetPricingList = [
    JPSingleSelectModel(id: 'true', label: 'selling_price'.tr),
    JPSingleSelectModel(id: 'false', label: 'unit_cost'.tr),
  ];

  /// [getActions] returns action to be displayed on clicking 3 dot (more) options
  static List<PopoverActionModel> getActions({required WorksheetHeaderActionParams params}) {

    // setting up conditions to enable disable actions
    bool isMeasurementApplied = params.data.worksheetMeasurement != null || params.data.measurementId != null;
    bool isEditForm = params.data.isEditForm;
    bool hasTiers = params.data.hasTiers;
    bool isSrsConnected = params.data.worksheetType != WorksheetConstants.workOrder && ConnectedThirdPartyService.isSrsConnected();
    bool isBeaconConnected = params.data.worksheetType != WorksheetConstants.workOrder && ConnectedThirdPartyService.isBeaconConnected();
    bool isAnyTierExpanded = false;
    bool hasAtLeastOneItem = !params.data.checkIfAnyItemToSave();
    bool showFavourite = !params.data.selectedFromFavourite && isEditForm;
    bool hasFavouriteEntity = params.data.workSheet?.file?.myFavouriteEntity != null;
    bool isSrsEnable = params.data.isSRSEnable;
    bool hasViewUnitCostPermission = PermissionService.hasUserPermissions([PermissionConstants.viewUnitCost]);
    bool showEditTemplatePage = params.data.worksheetType == WorksheetConstants.proposal
        && hasAtLeastOneItem && isEditForm && (params.data.companyTemplates.isNotEmpty)
        && params.data.workSheet?.pagesExist == 1;
    bool showAddTemplatePage = params.data.worksheetType == WorksheetConstants.proposal
        && hasAtLeastOneItem && isEditForm && (params.data.companyTemplates.isNotEmpty)
        && params.data.workSheet?.pagesExist != 1;

    bool isPlaceSRSOrder = params.data.isPlaceSRSOrder();
    bool isPlaceBeaconOrder = params.data.isPlaceBeaconOrder();
    bool isPlaceABCOrder = params.data.isPlaceABCOrder();
    bool isSRSV2SupplierId = Helper.isSRSv2Id(Helper.getSupplierId());
    bool isAbcConnected = params.data.worksheetType != WorksheetConstants.workOrder && ConnectedThirdPartyService.isAbcConnected();

    if (hasTiers) {
      WorksheetHelpers.tierListIterator(params.data.lineItems, action: (tier) {
        if (!isAnyTierExpanded) isAnyTierExpanded = tier.isTierExpanded ?? false;
      });
    }

    List<PopoverActionModel> actions = [
      if (hasAtLeastOneItem)
        PopoverActionModel(label: 'remove_zero_quantity_items'.tr, value: WorksheetConstants.removeZeroQuantityItems),
      if(!isPlaceSRSOrder && !isPlaceBeaconOrder && !isPlaceABCOrder)
        PopoverActionModel(label: 'add_tiers'.tr, value: WorksheetConstants.addTier),
      if (hasTiers) ...{
        PopoverActionModel(label: 'remove_tiers'.tr, value: WorksheetConstants.removeTiers),
        if (!isAnyTierExpanded) PopoverActionModel(label: 'expand_tier'.tr, value: WorksheetConstants.expandTier),
        if (isAnyTierExpanded) PopoverActionModel(label: 'collapse_tier'.tr, value: WorksheetConstants.collapseTier),
      },
      if (isSrsConnected && !isPlaceBeaconOrder)
        PopoverActionModel(label: 'srs'.tr.toUpperCase(), value: WorksheetConstants.srs, isDisabled: isPlaceSRSOrder),
      if (isBeaconConnected && !isPlaceSRSOrder)
        PopoverActionModel(label: 'qxo'.tr, value: WorksheetConstants.beacon, isDisabled: isPlaceBeaconOrder),
      if(isAbcConnected)
        PopoverActionModel(label: 'abc'.tr.toUpperCase(), value: WorksheetConstants.abc),
      // PopoverActionModel(label: 'activate_qbd'.tr, value: WorksheetConstants.activateQBD),
      // PopoverActionModel(label: 'deactivate_qbd'.tr, value: WorksheetConstants.deactivateQBD),
      if(hasViewUnitCostPermission)
        PopoverActionModel(label: 'worksheet_pricing'.tr, value: WorksheetConstants.worksheetPricing),
      if(!isSrsEnable)
        PopoverActionModel(label: 'attach_photos'.tr, value: WorksheetConstants.attachPhotos),
      if (!hasTiers)
        PopoverActionModel(label: 'macros'.tr, value: WorksheetConstants.macros),
      if(isSrsEnable && !isSRSV2SupplierId)
        PopoverActionModel(label: 'srs_smart_template'.tr, value: WorksheetConstants.srsSmartTemplate),
      PopoverActionModel(label: 'favourites'.tr, value: WorksheetConstants.favourites),
      if (isMeasurementApplied) ...{
        PopoverActionModel(label: 'linked_measurement'.tr.capitalize!, value: WorksheetConstants.linkedMeasurement),
        PopoverActionModel(label: 'reapply_measurement'.tr.capitalize!, value: WorksheetConstants.reapplyMeasurement),
        PopoverActionModel(label: 'discard_measurement'.tr.capitalize!, value: WorksheetConstants.discardMeasurement),
      } else ...{
        PopoverActionModel(label: 'apply_measurement'.tr.capitalize!, value: WorksheetConstants.applyMeasurement),
      },
      if(isPlaceSRSOrder)
        PopoverActionModel(label: 'place_srs_order'.tr, value: WorksheetConstants.placeSRSOrder),
      if(isPlaceBeaconOrder)
        PopoverActionModel(label: 'place_beacon_order'.tr, value: WorksheetConstants.placeBeaconOrder),
      if (showFavourite) ...{
        if (!hasFavouriteEntity) PopoverActionModel(label: 'mark_as_favourite'.tr, value: WorksheetConstants.markAsFavourite),
        if (hasFavouriteEntity) PopoverActionModel(label: 'unmark_mark_as_favourite'.tr, value: WorksheetConstants.unMarkAsFavourite),
      },
      if (showAddTemplatePage)
        PopoverActionModel(label: 'add_template_pages'.tr, value: WorksheetConstants.addTemplatePages),
      if (showEditTemplatePage)
        PopoverActionModel(label: 'edit_template_pages'.tr, value: WorksheetConstants.editTemplatePages),
      if (hasAtLeastOneItem)
        PopoverActionModel(label: 'worksheet_setting'.tr, value: WorksheetConstants.worksheetSettings),
      if (isEditForm)
        PopoverActionModel(label: 'save_as'.tr, value: WorksheetConstants.saveAs),
      PopoverActionModel(label: 'calculator'.tr.capitalize!, value: WorksheetConstants.calculator),
      if (hasAtLeastOneItem)
        PopoverActionModel(label: 'preview'.tr.capitalize!, value: WorksheetConstants.preview),
    ];
    return actions;
  }

  /// [getTierSubTotalsActions] helps in getting tier subtotal actions
  /// on clicking on amount displaying on the tier
  static List<PopoverActionModel> getTierSubTotalsActions() {
    return [
      PopoverActionModel(label: 'sub_total'.tr, value: WorksheetConstants.tierSubTotal),
      PopoverActionModel(label: 'line_total'.tr, value: WorksheetConstants.tierLineTotal),
      PopoverActionModel(label: 'profit'.tr, value: WorksheetConstants.tierProfit),
      PopoverActionModel(label: 'tax'.tr, value: WorksheetConstants.tierTax),
    ];
  }

  /// [handleMoreAction] categorises the actions and their handling
  Future<dynamic> handleMoreAction({required WorksheetHeaderActionParams params}) async {
    this.params = params;
    switch (params.action) {
      case WorksheetConstants.addTier:
        return openAddTiers();

      case WorksheetConstants.worksheetSettings:
        return openWorksheetSettings();

      case WorksheetConstants.preview:
        return previewWorksheetAsPdf();

      case WorksheetConstants.calculator:
        return openCalculator();

      case WorksheetConstants.applyMeasurement:
        return selectMeasurement();

      case WorksheetConstants.reapplyMeasurement:
        return applyMeasurement(reApply: true);

      case WorksheetConstants.discardMeasurement:
        return discardMeasurement();

      case WorksheetConstants.linkedMeasurement:
        if (data.measurementId != null) await applyMeasurement();
        return WorksheetHelpers.openFile(data.worksheetMeasurement?.filePath);

      case WorksheetConstants.worksheetPricing:
        return showPriceSelectionSheet();

      case WorksheetConstants.saveAs:

        // showing confirmation dialog in case of save worksheet and total is negative
        final saveWithNegativeTotal = await WorksheetHelpers.doSaveWithNegativeTotal(data.getContractTotal(), false);
        if (!saveWithNegativeTotal) return;

        return WorksheetHelpers.showNameDialog(
          title: WorksheetHelpers.worksheetTypeToTitle(params.data.worksheetType, saveAs: true),
          label: 'name'.tr,
          filledValue: WorksheetHelpers.getDefaultSaveName(data.worksheetType, worksheet: data.workSheet),
          onDone: (name) => saveAs(name),
        );

      case WorksheetConstants.collapseTier:
        return expandCollapseTier(expand: false);

      case WorksheetConstants.expandTier:
        return expandCollapseTier(expand: true);

      case WorksheetConstants.removeTiers:
        return WorksheetHelpers.showConfirmation(
            subTitle: 'remove_all_tiers_confirmation_desc'.tr,
            onConfirmed: removeAllTiers
        );

      case WorksheetConstants.removeZeroQuantityItems:
        return WorksheetHelpers.showConfirmation(
          subTitle: 'zero_quantity_item_remove_desc'.tr,
          onConfirmed: removeZeroQuantityItems
        );

      case WorksheetConstants.attachPhotos:
        return showAttachPhotosSheet();

      case WorksheetConstants.markAsFavourite:
        return showMarkAsFavouriteDialog();

      case WorksheetConstants.unMarkAsFavourite:
        return WorksheetHelpers.showConfirmation(
          subTitle: 'you_are_about_to_remove_this_worksheet_from_favorites_press_confirm_to_proceed'.tr,
          onConfirmed: unMarkAsFavourite
        );

      case WorksheetConstants.srs:
        return params.onActionComplete?.call(WorksheetConstants.srs);

      case WorksheetConstants.beacon:
        return params.onActionComplete?.call(WorksheetConstants.beacon);

      case WorksheetConstants.macros:
        return await WorksheetHelpers.navigateToMacros(
          isEnableSellingPrice: data.settings?.enableSellingPrice ?? false,
          forSupplierId: data.workSheet?.materialList?.forSupplierId,
          srsSupplierId: getSupplierId(),
          worksheetType: params.data.worksheetType,
          srsBranchCode: params.data.selectedSrsBranch?.branchCode,
          beaconBranchCode: params.data.selectedBeaconBranch?.branchCode,
          abcBranchCode: params.data.selectedAbcBranch?.branchCode,
          shipToSequenceId: params.data.selectedSrsShipToAddress?.shipToSequenceId,
          jobDivisionId: params.data.job?.division?.id,
          onDone: (macros) {
            params.onActionComplete?.call(WorksheetConstants.macros, data: macros);
          }
        );

      case WorksheetConstants.favourites:
        return showFavouritesSheet();

      case WorksheetConstants.editTemplatePages:
      case WorksheetConstants.addTemplatePages:
        return navigateToProposalTemplate();

      case WorksheetConstants.srsSmartTemplate:
        return params.onActionComplete?.call(WorksheetConstants.srsSmartTemplate);

      case WorksheetConstants.placeSRSOrder:
        return params.onActionComplete?.call(WorksheetConstants.placeSRSOrder);

      case WorksheetConstants.placeBeaconOrder:
        return params.onActionComplete?.call(WorksheetConstants.placeBeaconOrder);
      case WorksheetConstants.abc:
        return params.onActionComplete?.call(WorksheetConstants.abc);
    }
  }

  /// [getLineItems] returns line items to perform action on
  /// [excludeMeasurement] - helps in excluding items which are part of measurement
  List<SheetLineItemModel> getLineItems({bool excludeMeasurement = false, bool addEmptyTier = false}) {
    List<SheetLineItemModel> items = WorksheetHelpers.getParsedItems(lineItems: data.lineItems, addEmptyTier: addEmptyTier);
    if (excludeMeasurement) items.removeWhere((item) => item.hasTierMeasurement());
    return items;
  }

  /// [openWorksheetSettings] navigates to worksheet settings
  Future<void> openWorksheetSettings() async {
    params.data.settings?.isSRSEnable = params.data.isSRSEnable;
    params.data.settings?.isBeaconEnable = params.data.isBeaconEnable;

    await Get.toNamed(Routes.worksheetSetting, arguments: {
      NavigationParams.settings: params.data.settings,
      NavigationParams.forSupplierId: params.data.workSheet?.materialList?.forSupplierId,
      NavigationParams.lineItems: params.data.lineItems
    });
    params.onActionComplete?.call(WorksheetConstants.worksheetSettings);
  }

  /// [navigateToProposalTemplate] opens up templates editor
  Future<dynamic>? navigateToProposalTemplate() async {

    bool pagesExist = Helper.isTrue(data.workSheet?.pagesExist);

    Map<String, dynamic> args = {
      NavigationParams.jobId: data.jobId,
      NavigationParams.proposalType: ProposalTemplateFormType.edit,
      NavigationParams.worksheetId: data.worksheetId,
      NavigationParams.worksheetPagesExist: pagesExist
    };

    final result = await Get.toNamed(Routes.formProposalMergeTemplate, arguments: args);

    if (result != null) {
      params.data.workSheet?.pagesExist = Helper.isTrueReverse(result);
      params.onActionComplete?.call(WorksheetConstants.addTemplatePages);
    }
  }

  /// [openAddTiers] handle to open add tier name dialog or navigate to search all tiers list
  Future<void> openAddTiers() async {
    if (data.allTiers.isEmpty) {
      WorksheetHelpers.showNameDialog(
        title: 'add_tier'.tr,
        label: 'tier_name'.tr,
        onDone: (name) async {
          await addTier(name);
          Get.back();
        }
      );
    } else {
      final result = await Get.toNamed(Routes.tierSearch, arguments: {
        NavigationParams.list: data.allTiers
      });
      if (result != null) {
        addTier(result);
      }
    }
  }

  /// [addTier] is responsible for adding new tier after name is entered it decides
  /// whether any tier is added or not.
  /// In case there is not tier, it pick up all the items and add them to created tier
  /// In case tiers already exists, it a adds a new tier to tiers list
  Future<void> addTier(String name) async {

    bool replicatedName = WorksheetHelpers.verifyTierName(data.lineItems, name);
    if (replicatedName) return;

    List<SheetLineItemModel> lineItems = data.lineItems;
    bool hasNoTierAdded = lineItems.isEmpty || lineItems.first.type != WorksheetConstants.collection;
    List<SheetLineItemModel> tempLineItems = [];
    // adding tier for the first time
    if (hasNoTierAdded) {
      // adding existing items to newly created tier
      tempLineItems.addAll(lineItems);
      lineItems.clear();
    }
    // setting up tier calculations
    WorksheetAmounts tierTotals = WorksheetCalculations.getTierAmounts(tempLineItems);
    // creating a new tier with default values
    final tier = SheetLineItemModel.tier(
        title: name,
        totalPrice: "",
        subItems: tempLineItems,
        tier: 1,
        workSheetSettings: data.settings
    );
    // updating the tier calculations
    tier.setTierSubTotals(tierTotals);
    // adding new tier
    lineItems.add(tier);
    params.onActionComplete?.call(WorksheetConstants.addTier);
  }

  /// [previewWorksheetAsPdf] downloads and opens work sheet as pdf for preview
  Future<void> previewWorksheetAsPdf() async {
    showJPLoader(msg: 'downloading'.tr);
    try {
      await CookiesRepository.getCookies();
      final items = getLineItems();
      final json = data.worksheetJson(items, isPreview: true);
      String filePath = await WorksheetRepository.previewWorksheet(json);
      WorksheetHelpers.openFile(filePath);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  /// [openCalculator] displays floating calculator
  void openCalculator() {
    showJPGeneralDialog(
        isDismissible: false,
        child:(_) => const FloatingCalculator()
    );
  }

  /// [selectMeasurement] opens up measurement selection list to select measurement from
  void selectMeasurement() {
    FilesListQuickActionPopups.showMeasurementSelectionSheet(
      jobId: data.jobId,
      onFilesSelected: (file) async {
        applyMeasurement(id: file.id!, hoverJobId: file.hoverJob?.hoverJobId);
      },
    );
  }

  /// [applyMeasurement] loads measurements from server to apply
  /// This function can also be used to re-apply measurement by setting [reApply] to [true]
  /// In case of edit this function also handles loading measurement for re-applying
  Future<void> applyMeasurement({String? id, bool reApply = false, int? hoverJobId}) async {
    try {
      showJPLoader();
      Map<String,dynamic> requestParams = {
        'includes[0]': 'measurement_details',
        'includes[1]': 'created_by',
      };

      // loading items
      final items = getLineItems(excludeMeasurement: true);

      // deciding whether measurement needs to be loaded from server or not
      // measurement has to be loaded if it's getting applied from the first time
      // or it was already applied but the case was edit as in edit case only
      // measurement id is available
      bool applyMeasurement = id != null;
      bool doLoadMeasurement = (id != null) || (data.measurementId != null && data.worksheetMeasurement == null);

      if (doLoadMeasurement) {
        final measurementId = id ?? data.measurementId;
        data.worksheetMeasurement = await MeasurementsRepository.fetchMeasurementDetail(requestParams, measurementId.toString());
        data.measurementId = null;
      }

      if (data.worksheetMeasurement == null) return;

      // Applying Suggested Waste Factor
      if (hoverJobId != null) {
        final wasteFactorAttributeId = MeasurementHelper.getWasteFactorAttributeId(data.worksheetMeasurement);
        if(wasteFactorAttributeId != null) {
          Get.back();
          MeasurementHelper.showApplyingSuggestedWasteFactorDialog(
            hoverJobId, wasteFactorAttributeId,
            wasteFactorApplied: (wasteFactor) {
              applyingMeasurement(items, reApply, applyMeasurement, wasteFactor: wasteFactor);
            },
            onTapNo: () {
              applyingMeasurement(items, reApply, applyMeasurement);
            }
          );
          return;
        }
      }
      applyingMeasurement(items, reApply, applyMeasurement);
      Get.back();
    } catch(e){
      rethrow;
    }
  }

  /// [discardMeasurement] helps in unlinking linked measurement
  void discardMeasurement() {
    // removing worksheet data
    data.worksheetMeasurement = null;
    data.measurementId = null;
    final items = getLineItems(excludeMeasurement: true);
    // recalculating amounts
    WorksheetHelpers.reCalculateLineTotal(items, resetQuantity: true);
    Helper.showToastMessage('measurement_discarded'.tr.capitalizeFirst!);
    params.onActionComplete?.call(WorksheetConstants.discardMeasurement);
  }

  /// [expandCollapseTier] helps in toggling tier's expansion states
  Future<void> expandCollapseTier({bool expand = true}) async {
    WorksheetHelpers.tierListIterator(params.data.lineItems, action: (tier) {
      tier.isTierExpanded = expand;
    });
    // Additional delay for pop-up menu to close
    await Future<void>.delayed(const Duration(milliseconds: 300));
    params.onActionComplete?.call(WorksheetConstants.expandTier);
  }

  /// [removeAllTiers] helps in removing all the tiers, it also extract all the items
  /// and bring them outside tiers before removing tiers
  void removeAllTiers() {
    final items = WorksheetHelpers.getParsedItems(lineItems: data.lineItems, attachTierDetails: false);
    data.lineItems.clear();
    data.lineItems.addAll(items);
    // turning off the setting as soon as all tiers are removed from the
    // worksheet so to display options in Worksheet Settings correctly
    data.settings?.hasTier = false;
    params.onActionComplete?.call(WorksheetConstants.removeTiers);
  }

  /// [removeZeroQuantityItems] helps in removing items with 0 or no quantity
  void removeZeroQuantityItems() {
    if (params.hasTiers) {
      WorksheetHelpers.tierListIterator(data.lineItems, action: (item) {
        item.subItems?.removeWhere((item) => (num.tryParse(item.qty ?? "") ?? 0) <= 0);
      });
    } else {
      data.lineItems.removeWhere((item) => (num.tryParse(item.qty ?? "") ?? 0) <= 0);
    }
    params.onActionComplete?.call(WorksheetConstants.removeZeroQuantityItems);
  }

  Future<void> showFavouritesSheet() async {
    await FilesListQuickActionPopups.showFavouriteListingBottomSheet(
        jobId: data.jobId,
        additionalParams: WorksheetHelpers.getFavouriteParams(data.worksheetType, data.srsSupplierId),
        onTapUnFavourite: (id) {},
        parentModule: data.worksheetType,
        worksheetId: data.worksheetId,
        onTapAttach: (files) async {
          String? beaconAccountId = files.first.favouriteFile?.worksheet?.beaconAccountId;
          WorksheetHelpers.checkIsNotBeaconOrBeaconAccountExist(beaconAccountId, (isNotBeaconOrBeaconAccountExist) async {
            if(isNotBeaconOrBeaconAccountExist) {
              await validateAndApplyFavouriteDivision(files.first);
            }
          });
        }
    );
  }

  void showAttachPhotosSheet() {
    FormValueSelectorService.selectAttachments(
        attachments: data.attachments,
        type: AttachmentOptionType.attachWorksheetPhoto,
        dirWithImageOnly: true,
        jobId: data.jobId,
        maxSize: Helper.flagBasedUploadSize(fileSize: CommonConstants.maxAllowedFileSize),
        onSelectionDone: () {
          Helper.showToastMessage('photos_attached'.tr);
          params.onActionComplete?.call(WorksheetConstants.attachPhotos);
        }
    );
  }

  void showMarkAsFavouriteDialog() {

    final file = data.workSheet?.file;

    if (file == null) return;

    if (Helper.isValueNullOrEmpty(file.name)) {
      file.name = data.workSheet?.name;
    }

    showJPGeneralDialog(
      child: (_) => MarkAsFavouriteDialog(
        fileParams: FilesListingQuickActionParams(
          fileList: [file],
          type: data.flModule!,
          onActionComplete: (_, action) {
            params.onActionComplete?.call(WorksheetConstants.markAsFavourite);
          }),
      ),
    );
  }

  Future<dynamic> unMarkAsFavourite() async {
    final file = data.workSheet?.file;

    if (file == null) return;

    try {
      showJPLoader();
      final requestParams = FilesListingQuickActionParams(
        fileList: [file],
        type: FLModule.estimate,
        onActionComplete: (_, __) {},
      );
      await FileListingQuickActionRepo.unMarkAsFavourite(requestParams);
      data.workSheet?.file?.myFavouriteEntity = null;
      params.onActionComplete?.call(WorksheetConstants.unMarkAsFavourite);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  /// [showPriceSelectionSheet] opens up worksheet pricing sheet to switch pricing
  void showPriceSelectionSheet() {
    FormValueSelectorService.openSingleSelect(
      list: worksheetPricingList,
      title: 'set_worksheet_pricing'.tr,
      selectedItemId: data.settings!.enableSellingPrice.toString(),
      onValueSelected: (id) {
        data.settings!.enableSellingPrice = Helper.isTrue(id);
        params.onActionComplete?.call(WorksheetConstants.worksheetPricing);
      },
    );
  }

  /// [saveAs] helps in saving worksheet with different name and new file
  Future<void> saveAs(String name) async {
    final items = getLineItems(addEmptyTier: true);

    final json = params.worksheetJson?.call(items, name: name);
    try {
      await WorksheetRepository.saveWorksheet(json);
      Helper.showToastMessage('worksheet_created'.tr);
      params.onActionComplete?.call(WorksheetConstants.saveAs);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  /// [applyingMeasurement] Applying Measurement in line items
  void applyingMeasurement(List<SheetLineItemModel> items, bool reApply, bool applyMeasurement, {String? wasteFactor}) {
    // updating items to show quantity as of measurement
    MeasurementHelper.getAppliedMeasurementItems(data.worksheetMeasurement!, items, wasteFactor: wasteFactor);
    WorksheetHelpers.reCalculateLineTotal(items);

    if (reApply) {
      Helper.showToastMessage('measurement_reapplied'.tr.capitalizeFirst!);
      params.onActionComplete?.call(WorksheetConstants.reapplyMeasurement);
    } else if (applyMeasurement) {
      Helper.showToastMessage('measurement_applied'.tr.capitalizeFirst!);
      params.onActionComplete?.call(WorksheetConstants.applyMeasurement);
    }
  }

  int? getSupplierId() {
    int? supplierId;
    if (data.isSRSEnable) {
      if(data.workSheet?.materialList?.forSupplierId != null) {
        supplierId = data.workSheet?.materialList?.forSupplierId?.toInt();
      } else if(!Helper.isValueNullOrEmpty(data.workSheet?.suppliers)) {
        int? srsSupplierId = data.workSheet?.suppliers?.firstWhereOrNull((element) => Helper.isSRSv1Id(element.id) || Helper.isSRSv2Id(element.id))?.id;
        supplierId = srsSupplierId ?? Helper.getSupplierId();
      } else {
        supplierId = Helper.getSupplierId();
      }
    }
    return supplierId;
  }

  /// [validateAndApplyFavouriteDivision] Validates and applies the favourite division for a given file.
  ///
  /// This function checks if the job's division and the favourite file's division
  /// are comparable and if they are the same. If they are not comparable or are the same,
  /// it applies the favourite directly. Otherwise, it shows a dialog to select the appropriate
  /// division and applies the favourite with the selected division if one is chosen.
  ///
  /// Param:
  /// - [favFile] The favourite file to validate and apply.
  Future<void> validateAndApplyFavouriteDivision(FilesListingModel? favFile) async {
    // If divisions are not comparable or are the same, apply the favourite directly
    if (doSkipDivisionCheck(favFile)) {
      Get.back();
      return applyFavourite(favFile);
    }

    // Show a dialog to select the appropriate division if divisions are different
    final result = await showJPDialog(
      child: (_) => WorksheetDivisionSelector(
        jobDivision: data.job?.division,
        favouriteDivision: favFile?.division,
      ),
    );

    // If a division is selected from the dialog, apply the favourite with the selected division
    if (result is DivisionModel) {
      Get.back();
      applyFavourite(favFile, selectedDivision: result);
    }
  }

  /// [doSkipDivisionCheck] checks if the division check should be skipped.
  ///
  /// This function determines whether the division check between the job's division
  /// and the favourite file's division should be skipped. It returns `true` if either
  /// the job's division or the favourite file's division is null or empty, or if they
  /// are the same.
  ///
  /// Param:
  /// - [favFile] The favourite file to check the division against.
  ///
  /// Returns:
  /// - `true` if the division check should be skipped, `false` otherwise.
  bool doSkipDivisionCheck(FilesListingModel? favFile) {
    // Check if either the job's division or the favourite file's division is null or empty
    bool isDivisionNotComparable = Helper.isValueNullOrEmpty(data.job?.division) || Helper.isValueNullOrEmpty(favFile?.division);

    // Check if the job's division and the favourite file's division are the same
    bool isSameDivision = data.job?.division?.id == favFile?.division?.id;
    return isDivisionNotComparable || isSameDivision;
  }

  /// [applyFavourite] Applies the favourite file to the worksheet.
  ///
  /// This function validates and applies the favourite file to the worksheet.
  /// If a division is selected, it updates the division of the favourite file.
  /// If the worksheet has line items, it shows a confirmation dialog before applying the favourite.
  ///
  /// Params:
  /// - [selectedFile] The favourite file to apply.
  /// - [selectedDivision] The selected division to apply to the favourite file.
  void applyFavourite(FilesListingModel? selectedFile, {
    DivisionModel? selectedDivision
  }) {
    // Get the favourite worksheet ID from the selected file
    String? favouriteId = selectedFile?.favouriteFile?.worksheetId;

    // Update the division of the selected file if a division is provided
    if (selectedDivision != null) selectedFile?.division = selectedDivision;

    // If the favourite ID is not null, proceed to apply the favourite
    if (favouriteId != null) {
      // If there are line items in the worksheet, show a confirmation dialog
      if (data.lineItems.isNotEmpty) {
        WorksheetHelpers.showConfirmation(
            subTitle: 'apply_favourite_desc'.tr,
            onConfirmed: () {
              // Call the onActionComplete callback with the selected file
              params.onActionComplete?.call(WorksheetConstants.favourites, data: selectedFile);
            }
        );
      } else {
        // If there are no line items, directly call the onActionComplete callback
        params.onActionComplete?.call(WorksheetConstants.favourites, data: selectedFile);
      }
    }
  }
}
