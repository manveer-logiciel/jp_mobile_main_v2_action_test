import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/financial_total_price_tile/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/note_tile/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/sheet_line_item_listing/index.dart';
import 'package:jobprogress/modules/job_financial/widgets/list.dart';
import 'package:jobprogress/modules/worksheet/controller.dart';
import 'package:jobprogress/modules/worksheet/widgets/warning_tile/index.dart';
import 'package:jobprogress/modules/worksheet/widgets/worksheet_disclaimer_tile/index.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_worksheet.dart';
import 'calculations/index.dart';
import 'form/index.dart';
import 'list/index.dart';
import 'shimmer/index.dart';

class WorksheetView extends StatelessWidget {

  const WorksheetView({
    super.key,
    required this.controller
  });

  final WorksheetFormController controller;

  WorksheetFormService get service => controller.service;

  WorksheetSettingModel? get settings => controller.service.settings;

  bool get showPricing => !(settings?.hidePricing ?? false);

  @override
  Widget build(BuildContext context) {

    if (service.isLoading) {
      return const WorksheetShimmer();
    }

    return JPSafeArea(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Stack(
          children: [
            Container(
              height: 168,
              color: JPAppTheme.themeColors.secondary,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FinancialTotalPriceTile(
                  title: 'list_total'.tr,
                  hideTotal: !showPricing,
                  value: JobFinancialHelper.getCurrencyFormattedValue(value: service.calculatedAmounts.displayTotal),
                  trailing: [
                    if (service.attachments.isNotEmpty)
                      Transform.translate(
                      offset: const Offset(5, 0),
                      child: Center(
                        child: JPTextButton(
                          icon: Icons.photo_outlined,
                          iconSize: 24,
                          color: JPAppTheme.themeColors.base,
                          onPressed: controller.showAttachmentSheet,
                        ),
                      ),
                    ),

                    Transform.translate(
                      offset: const Offset(8, 0),
                      child: JPPopUpMenuButton(
                        popUpMenuButtonChild: Padding(
                          padding:
                          const EdgeInsets.all(8),
                          child: JPIcon(
                            Icons.more_vert_outlined,
                            color: JPAppTheme.themeColors.base,
                          ),
                        ),
                        itemList: service.getActions(),
                        popUpMenuChild: (PopoverActionModel popoverActionModel) {
                          Helper.hideKeyboard();
                          if (popoverActionModel.value == WorksheetConstants.srs) {
                            return JobFinancialOptionsList(
                              value: popoverActionModel.label,
                              toggleValue: service.isSRSEnable,
                              isDisabled: popoverActionModel.isDisabled,
                              onToggle: (val) => service.toggleSupplier(val, MaterialSupplierType.srs)
                            );
                          } else if (popoverActionModel.value == WorksheetConstants.beacon) {
                            return JobFinancialOptionsList(
                              value: popoverActionModel.label,
                              toggleValue: service.isBeaconEnable,
                              isDisabled: popoverActionModel.isDisabled,
                              onToggle: service.toggleBeaconSupplier
                            );
                          } else if (popoverActionModel.value == WorksheetConstants.abc) {
                            return JobFinancialOptionsList(
                                value: popoverActionModel.label,
                                toggleValue: service.isAbcEnable,
                                isDisabled: popoverActionModel.isDisabled,
                                onToggle: (val) => service.toggleSupplier(val, MaterialSupplierType.abc)
                            );
                          } else {
                            return JobFinancialOptionsList(
                                value: popoverActionModel.label,
                            );
                          }
                          },
                        onTap: service.onTapMoreActionOption,
                      ),
                    )
                  ],
                ),
                WorksheetFormDetails(
                  controller: controller,
                ),
                /// Worksheet Disclaimer
                if(service.isPlaceSupplierOrder() && service.lineItems.isNotEmpty) ...{
                  SizedBox(height: controller.formUiHelper.verticalPadding,),
                  WorksheetDisclaimerTile(controller: controller)
                },

                // Worksheet warning tile
                if (service.isAnyTierWithWarning) ...{
                  SizedBox(height: controller.formUiHelper.verticalPadding,),
                  WorksheetWaringTile(
                    icon: Icons.error_outline,
                    label: 'tier_macro_missing_label'.tr,
                  ),
                },

                SizedBox(
                  height: controller.formUiHelper.verticalPadding,
                ),
                ///   Item list
                if (service.lineItems.isEmpty) ...{
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: NoDataFound(
                      title: 'no_item_added_yet'.tr.capitalize,
                      descriptions: 'tap_on_plus_button_to_adding_items'.tr,
                    ),
                  ),
                } else if (service.hasTiers)...{
                  WorksheetItemsList(
                    controller: controller,
                  ),
                } else ...{
                  Opacity(
                    opacity: service.isSavingForm ? 0.6 : 1,
                    child: SheetLineItemListing(
                      items: service.lineItems,
                      isSavingForm: service.isSavingForm,
                      onListItemReorder: service.onListItemReorder,
                      onTapOfDelete: service.removeItem,
                      pageType: AddLineItemFormType.worksheet,
                      onTapItem: (item) => service.showAddEditSheet(editLineItem: item),
                      isSupplierEnable: service.isAnySupplierEnabled,
                      isAbcEnable: service.isAbcEnable,
                      onTapMoreDetails: service.openAvailabilityProductNoticeSheet,
                      isBeaconOrder: service.isPlaceBeaconOrder(),
                      isAbcOrder: service.isPlaceABCOrder(),
                      jobDivision: service.job?.division,
                      showVariationConfirmationValidation: service.showVariationConfirmationValidation,
                      onTapVariationConfirmation: (item) => service.showAddEditSheet(editLineItem: item),
                      onTapBeaconMoreDetails: service.openPricingAvailabilityNoticeSheet,
                    ),
                  ),
                },

                if (service.lineItems.isNotEmpty && settings != null)
                  WorksheetCalculationsTile(
                  controller: controller,
                ),

                if(service.lineItems.isNotEmpty)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 100,top: 20),
                      child: NoteTile(
                        isWithSnippets: true,
                        callback: service.onNoteChange,
                        isDisable: service.isSavingForm,
                        note: service.note
                      )
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }


}
