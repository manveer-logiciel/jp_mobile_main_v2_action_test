import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/global_widgets/expansion_tile/index.dart';
import 'package:jobprogress/modules/job_financial/form/leappay_preferences/widgets/preference_toggles.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../common/models/popover_action.dart';
import '../../../../../core/utils/job_financial_helper.dart';
import '../../../../../global_widgets/financial_form/financial_form_header_total_price_tile/index.dart';
import '../../../../../global_widgets/financial_form/no_charge_price_tile/index.dart';
import '../../../../../global_widgets/no_data_found/index.dart';
import '../../../../../global_widgets/note_tile/index.dart';
import '../../../../../global_widgets/safearea/safearea.dart';
import '../../../../../global_widgets/sheet_line_item_listing/index.dart';
import '../../../widgets/list.dart';
import '../controller.dart';
import 'section/invoice_details.dart';
import 'section/total_price_section.dart';

class InvoiceViewForm extends StatelessWidget {
const InvoiceViewForm({
  super.key,
  required this.controller,
});

final InvoiceFormController controller;

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Stack(
                children: [
                  Container(
                    height: 167,
                    color: JPAppTheme.themeColors.secondary,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      ///   Total Price
                      FinancialFormHeaderTotalPriceTile(
                        value: JobFinancialHelper.getCurrencyFormattedValue(value: controller.service.totalInvoicePrice),
                        trailing: [
                          AbsorbPointer(
                            absorbing: !controller.service.isFieldEditable(null),
                            child: JPPopUpMenuButton(
                              offset: const Offset(-10, 35),
                              popUpMenuButtonChild: Padding(
                                padding: const EdgeInsets.all(8),
                                child: JPIcon(Icons.more_vert_outlined,color: JPAppTheme.themeColors.base)),
                              itemList: [
                                PopoverActionModel(
                                  label: controller.service.isTaxable ? 'remove_tax'.tr : 'apply_tax'.tr,
                                  value: controller.service.isTaxable ? 'remove_tax' : 'apply_tax',
                                ),
                                if (ConnectedThirdPartyService.isSrsConnected())
                                  PopoverActionModel(
                                    label: 'srs'.tr.toUpperCase(), 
                                    value: WorksheetConstants.srs,
                                  ),
                                if (ConnectedThirdPartyService.isBeaconConnected())
                                  PopoverActionModel(
                                    label: 'qxo'.tr,
                                    value: WorksheetConstants.beacon,
                                  ),
                                if (controller.service.isAbcConnected())
                                  PopoverActionModel(
                                    label: 'abc'.tr,
                                    value: WorksheetConstants.abc,
                                  ),
                              ],
                              popUpMenuChild: (PopoverActionModel popoverActionModel) {
                                if (popoverActionModel.value == WorksheetConstants.srs) {
                                  return JobFinancialOptionsList(
                                    value: popoverActionModel.label,
                                    toggleValue: controller.service.isSRSEnable,
                                    onToggle: (_) {
                                      Get.back();
                                      controller.service.onTapMoreActionIcon(popoverActionModel);
                                    },
                                  );
                                } else if (popoverActionModel.value == WorksheetConstants.beacon) {
                                  return JobFinancialOptionsList(
                                    value: popoverActionModel.label,
                                    toggleValue: controller.service.isBeaconEnable,
                                    onToggle: (_) {
                                      Get.back();
                                      controller.service.onTapMoreActionIcon(popoverActionModel);
                                    },
                                  );
                                } else if(popoverActionModel.value == WorksheetConstants.abc) {
                                  return JobFinancialOptionsList(
                                    value: popoverActionModel.label,
                                    toggleValue: controller.service.isAbcEnable,
                                    onToggle: (_) {
                                      Get.back();
                                      controller.service.onTapMoreActionIcon(popoverActionModel);
                                    },
                                  );
                                } else {
                                  return JobFinancialOptionsList(value: popoverActionModel.label);
                                }
                              },
                              onTap: controller.service.onTapMoreActionIcon,
                            ),
                          ),
                        ],
                      ),
                      ///   Change order details
                      InvoiceDetailsBox(controller: controller,),
                      ///   Item list
                      Padding(
                        padding: EdgeInsets.only(top: controller.formUiHelper.verticalPadding),
                        child: controller.service.invoiceItems.isEmpty
                            ? NoDataFound(title: 'no_item_added_yet'.tr.capitalize, descriptions: 'tap_on_plus_button_to_adding_items'.tr,)
                            : SheetLineItemListing(
                          onTapItem: controller.editInvoiceOrderItem,
                          items: controller.service.invoiceItems,
                          isSavingForm: controller.isSavingForm,
                          onListItemReorder: controller.onListItemReorder,
                          pageType: controller.getAddLineItemFormType(),
                          onTapOfDelete: controller.service.deleteItem,
                        ),
                      ),
                      ///   Total Price Section
                      Visibility(
                        visible: controller.service.isTotalPriceFieldVisible,
                        child: Padding(
                          padding: EdgeInsets.only(top: controller.formUiHelper.verticalPadding),
                          child:  InvoiceFormTotalPriceSection(service: controller.service)
                        ),
                      ),
                      ///   No charge item section
                      Visibility(
                        visible: controller.service.noChargeItemsList.isNotEmpty
                        && controller.service.isNoChargeItemAvailable(),
                        child: Padding(
                          padding: EdgeInsets.only(top: controller.formUiHelper.verticalPadding),
                          child: FinancialFormNoChargePriceTile(
                            noChargeItemsList: controller.service.noChargeItemsList,
                            noChargeItemsTotal: controller.service.noChargeItemsTotal,
                            pageType: controller.getAddLineItemFormType(),
                          )
                        ),
                      ),

                      ///   Order note
                      Visibility(
                        visible: controller.service.invoiceItems.isNotEmpty,
                        child: Padding(
                          padding: EdgeInsets.only(top: controller.formUiHelper.verticalPadding),
                          child: NoteTile(
                            isDisable: controller.isSavingForm,
                            note: controller.service.noteString,
                            isWithSnippets: true,
                            callback: controller.service.onNoteChange,
                          )
                        ),
                      ),

                      /// Payment settings
                      Visibility(
                        visible: controller.service.doShowPaymentPreferences,
                        child: Padding(
                          padding: EdgeInsets.only(top: controller.formUiHelper.verticalPadding),
                          child: JPExpansionTile(
                            enableHeaderClick: true,
                            onExpansionChanged: (val) => controller.onExpansionChanged(val),
                            initialCollapsed: controller.isPaymentSectionExpanded,
                            borderRadius: controller.formUiHelper.sectionBorderRadius,
                            isExpanded: controller.isPaymentSectionExpanded,
                            headerPadding: EdgeInsets.symmetric(
                              horizontal: controller.formUiHelper.horizontalPadding,
                              vertical: controller.formUiHelper.verticalPadding,
                            ),
                            header: JPText(
                              text: 'payment_settings'.tr.toUpperCase(),
                              textSize: JPTextSize.heading4,
                              fontWeight: JPFontWeight.medium,
                              textColor: JPAppTheme.themeColors.secondaryText,
                              textAlign: TextAlign.start,
                            ),
                            trailing: (_) => JPIcon(
                              Icons.expand_more,
                              color: JPAppTheme.themeColors.secondaryText,
                            ),
                            contentPadding: EdgeInsets.only(
                              left: controller.formUiHelper.horizontalPadding,
                              right: controller.formUiHelper.horizontalPadding,
                              bottom: controller.formUiHelper.verticalPadding,
                            ),
                            children: [
                              LeapPayPreferences(
                                controller: controller.service.leapPayPreferencesController,
                                amount: controller.service.totalInvoicePrice.toDouble(),
                              )
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: JPResponsiveDesign.floatingButtonSize + 10,)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

