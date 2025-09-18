import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/note_tile/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/job_financial/form/refund_form/widgets/refund_details_box.dart';
import 'package:jp_mobile_flutter_ui/Button/color_type.dart';
import 'package:jp_mobile_flutter_ui/Button/index.dart';
import 'package:jp_mobile_flutter_ui/Button/size.dart';
import 'package:jp_mobile_flutter_ui/Button/type.dart';
import 'package:jp_mobile_flutter_ui/Header/header.dart';
import 'package:jp_mobile_flutter_ui/Icon/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import '../../../../core/utils/job_financial_helper.dart';
import '../../../../global_widgets/financial_form/financial_form_header_total_price_tile/index.dart';
import '../../../../global_widgets/job_header_detail/index.dart';
import '../../../../global_widgets/job_overview_placeholders/header_placeholder.dart';
import '../../../../global_widgets/loader/index.dart';
import '../../../../global_widgets/no_data_found/index.dart';
import '../../../../global_widgets/safearea/safearea.dart';
import '../../../../global_widgets/scaffold/index.dart';
import '../../../../global_widgets/sheet_line_item_listing/index.dart';
import 'controller.dart';

class RefundFormView extends StatelessWidget {
  const RefundFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RefundFormController>(
        init: RefundFormController(),
        builder: (controller) => JPWillPopScope(
          onWillPop: controller.onWillPop,
          child: GestureDetector(
            onTap: Helper.hideKeyboard,
            child: JPScaffold(
                scaffoldKey: controller.scaffoldKey,
                backgroundColor: JPAppTheme.themeColors.lightestGray,
                appBar: JPHeader(
                  onBackPressed: controller.onWillPop,
                  titleWidget:controller.isLoading ?
                  const JobOverViewHeaderPlaceHolder():
                  JobHeaderDetail(job: controller.service.job, textColor: JPAppTheme.themeColors.base),
                  backgroundColor: JPAppTheme.themeColors.secondary,
                  titleColor: JPAppTheme.themeColors.base,
                  backIconColor: JPAppTheme.themeColors.base,
                  actions: [
                    Container(
                      padding: const EdgeInsets.only(right: 16),
                      alignment: Alignment.center,
                      child: JPButton(
                        text: controller.isSavingForm ? '' : 'save'.tr.toUpperCase(),
                        onPressed: controller.saveRefundForm,
                        type: JPButtonType.outline,
                        size: JPButtonSize.extraSmall,
                        colorType: JPButtonColorType.base,
                        disabled: controller.isSavingForm,
                        suffixIconWidget: showJPConfirmationLoader(show: controller.isSavingForm),
                      ),
                    )
                  ],
                ),
                floatingActionButton: JPButton(
                    size: JPButtonSize.floatingButton,
                    iconWidget: JPIcon(Icons.add,
                      color: JPAppTheme.themeColors.base,
                    ),
                    onPressed: controller.showAddItemBottomSheet,
                    disabled: controller.isSavingForm,
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
                                  FinancialFormHeaderTotalPriceTile(
                                        value: JobFinancialHelper.getCurrencyFormattedValue(
                                            value: controller.service.totalPrice),
                                    ),
                                  RefundDetailsBox(controller: controller,),
                                  const SizedBox(height: 30,),

                                  controller.service.refundItems.isEmpty ?
                                  NoDataFound(title: 'no_item_added_yet'.tr.capitalize,descriptions: 'tap_on_plus_button_to_adding_items'.tr,) :
                                  SheetLineItemListing(
                                    onTapItem: (item) => controller.showAddItemBottomSheet(item: item),
                                    items: controller.service.refundItems,
                                    isSavingForm: controller.isSavingForm,
                                    onListItemReorder: controller.onListItemReorder,
                                    pageType: AddLineItemFormType.refundForm,
                                    onTapOfDelete: controller.service.deleteItem,
                                  ),
                                  const SizedBox(height: 20,),
                                  if(controller.service.refundItems.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 100),
                                      child: NoteTile(
                                        isWithSnippets: true,
                                        callback: controller.service.onNoteTextChange,
                                        isDisable: controller.isSavingForm,
                                        note: controller.service.note,
                                      ))
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
        )
    );
  }
}
