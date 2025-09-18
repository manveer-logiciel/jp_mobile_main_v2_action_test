import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/enums/insurance_form_type.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/note_tile/index.dart';
import 'package:jobprogress/global_widgets/sheet_line_item_listing/index.dart';
import 'package:jobprogress/global_widgets/sheet_total_amount/index.dart';
import 'package:jobprogress/global_widgets/sheet_total_amount/label_value_tile.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/files_listing/forms/insurance/widgets/insurance_detail_box.dart';
import 'package:jobprogress/modules/job_financial/widgets/list.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../global_widgets/financial_total_price_tile/index.dart';
import '../../../../global_widgets/job_header_detail/index.dart';
import '../../../../global_widgets/no_data_found/index.dart';
import '../../../../global_widgets/safearea/safearea.dart';
import '../../../../global_widgets/scaffold/index.dart';
import 'controller.dart';

class InsuranceFormView extends StatelessWidget {
  const InsuranceFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InsuranceFormController>(
        init: InsuranceFormController(),
        builder: (controller) => JPWillPopScope(
          onWillPop: controller.service.isSavingForm ? () async => false : controller.onWillPop,
          child: AbsorbPointer(
            absorbing: controller.service.isSavingForm,
            child: GestureDetector(
              onTap: Helper.hideKeyboard,
              child: JPScaffold(
                  scaffoldKey: controller.scaffoldKey,
                  backgroundColor: JPAppTheme.themeColors.lightestGray,
                  appBar: JPHeader(
                    onBackPressed: controller.service.isSavingForm ? null : controller.onWillPop,
                    titleWidget: JobHeaderDetail(job: controller.job, textColor: JPAppTheme.themeColors.base),
                    backgroundColor: JPAppTheme.themeColors.secondary,
                    titleColor: JPAppTheme.themeColors.base,
                    backIconColor: JPAppTheme.themeColors.base,
                    actions: [
                      Container(
                        padding: const EdgeInsets.only(right: 16),
                        alignment: Alignment.center,
                        child: JPButton(
                          text: controller.service.isSavingForm ? '' : 
                            controller.service.pageType == InsuranceFormType.edit ? 
                              'update'.tr.toUpperCase() : 
                              'save'.tr.toUpperCase(),
                          onPressed: controller.service.showSaveDialog,
                          type: JPButtonType.outline,
                          size: JPButtonSize.extraSmall,
                          colorType: JPButtonColorType.base,
                          disabled: controller.service.isSavingForm,
                          suffixIconWidget: showJPConfirmationLoader(show: controller.service.isSavingForm),
                        ),
                      )
                    ],
                  ),
                  floatingActionButton: JPButton(
                      size: JPButtonSize.floatingButton,
                      iconWidget: JPIcon(Icons.add,
                        color: JPAppTheme.themeColors.base,
                      ),
                      onPressed: controller.service.openAddItemBottomSheet,
                      disabled: controller.service.isSavingForm,
                  ),
                  body: JPSafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child:
                            Stack(
                              children: [
                                Container(
                                  height: 167,
                                  color: JPAppTheme.themeColors.secondary,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    FinancialTotalPriceTile(
                                      title: '${'total'.tr} ${'acv'.tr.toUpperCase()}',
                                      value: JobFinancialHelper.getCurrencyFormattedValue(value: controller.service.totalACV),
                                      trailing: [
                                        JPPopUpMenuButton(
                                          popUpMenuButtonChild: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: JPIcon(Icons.more_vert_outlined,color: JPAppTheme.themeColors.base)),
                                            itemList: controller.service.getActions(),
                                          popUpMenuChild:(PopoverActionModel value) => JobFinancialOptionsList(value: value.label),
                                          onTap: controller.service.onTapMoreActionIcon,
                                        ),
                                      ],
                                    ),
                                    InsuranceDetailsBox(controller: controller),
                                    ///   Item list
                                    Padding(
                                      padding: EdgeInsets.only(top: controller.formUiHelper.verticalPadding),
                                      child: controller.service.insuranceItems.isEmpty ? 
                                        NoDataFound(
                                          title: 'no_item_added_yet'.tr.capitalize,
                                          descriptions: 'tap_on_plus_button_to_adding_items'.tr.capitalizeFirst,
                                        ): 
                                        SheetLineItemListing(
                                          onTapItem:controller.editInsuranceItem,
                                          items: controller.service.insuranceItems,
                                          isSavingForm: controller.service.isSavingForm,
                                          onListItemReorder: controller.onListItemReorder,
                                          onTapOfDelete: controller.service.deleteItem,
                                          pageType: AddLineItemFormType.insuranceForm
                                        ),
                                    ),
                                    Visibility(
                                      visible: controller.service.insuranceItems.isNotEmpty,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: controller.formUiHelper.verticalPadding),
                                        child: SheetTotalAmountSection(
                                          labelValueList: [
                                            SheetLabelValueTile(
                                              labelWidget: JPText(
                                                text: 'total_tax'.tr.capitalize!,
                                                textColor: JPAppTheme.themeColors.tertiary,
                                              ), 
                                              valueWidget: JPText(
                                                text: JobFinancialHelper.getCurrencyFormattedValue(value: controller.service.totalTax),
                                                textColor: JPAppTheme.themeColors.text,
                                              ), 
                                            ),
                                            SheetLabelValueTile(
                                              labelWidget: JPText(
                                                text: "total_rcv".tr,
                                                textColor: JPAppTheme.themeColors.tertiary,
                                              ), 
                                              valueWidget: JPText(
                                                text: JobFinancialHelper.getCurrencyFormattedValue(value: controller.service.totalRCV),
                                                textColor: JPAppTheme.themeColors.text,
                                              ), 
                                            ),
                                            SheetLabelValueTile(
                                              labelWidget: JPText(
                                                text: "total_depreciation".tr.capitalize!,
                                                textColor: JPAppTheme.themeColors.tertiary,
                                              ), 
                                              valueWidget: JPText(
                                                text: JobFinancialHelper.getCurrencyFormattedValue(value: controller.service.totalDeprecation),
                                                textColor: JPAppTheme.themeColors.text,
                                              ), 
                                            )                                        
                                          ],
                                        )
                                      ),
                                    ),
                                    if(controller.service.insuranceItems.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 100,top: 20),
                                      child: NoteTile(
                                        isWithSnippets: true,
                                        callback: controller.service.onNoteChange,
                                        isDisable: controller.service.isSavingForm,
                                        note: controller.service.note,
                                      )
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
              ),
            ),
          ),
        )
    );
  }
}
