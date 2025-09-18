import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/ToolTip/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../core/constants/regex_expression.dart';
import '../../../../../../core/utils/job_financial_helper.dart';
import '../../../../../core/utils/form/validators.dart';
import 'controller.dart';


class BillAddItemBottomSheet extends StatelessWidget {
  final SheetLineItemModel? billItemModel;
  final List<JPSingleSelectModel> accountingHeads;
  final Function(SheetLineItemModel billItemModel, bool isUpdate) onAddUpdate;
  const BillAddItemBottomSheet({
    super.key,
    required this.onAddUpdate,
    required this.accountingHeads,
    this.billItemModel,
  });

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<BillAddItemController>(
      init: BillAddItemController(accountingHeads, item: billItemModel),
      builder: (controller) => GestureDetector(
        onTap: Helper.hideKeyboard,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: JPAppTheme.themeColors.base,
                borderRadius: JPResponsiveDesign.bottomSheetRadius,
              ),
              child: JPSafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 4,
                      width: 30,
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                        color: JPAppTheme.themeColors.dimGray,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Form(
                        key: controller.itemFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            JPText(
                              text: billItemModel!= null ?
                              'update_item'.tr.toUpperCase() :
                              'add_item'.tr.toUpperCase(),
                              textSize: JPTextSize.heading3,
                              fontWeight: JPFontWeight.medium,
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Expanded(
                                child: JPInputBox(
                                  inputBoxController: controller.accountingHeadController,
                                  type: JPInputBoxType.withLabel,
                                  label: 'accounting_head'.tr,
                                  fillColor: JPAppTheme.themeColors.base,
                                  isRequired: true,
                                  readOnly: true,
                                  suffixChild: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: JPIcon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: JPAppTheme.themeColors.text,
                                    ),
                                  ),
                                  onPressed: controller.openAccountingHead,
                                  validator: controller.validateAccountingHead,
                                ),
                              ),
                              const SizedBox(width: 8,),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: JPToolTip(
                                  message: 'only_expense_related_accounting_heads_can_be_chosen'.tr,
                                  child: JPIcon(
                                    Icons.info_outline,
                                    color: JPAppTheme.themeColors.primary,
                                    size: 20,
                                  )),
                              )
                            ],),
                            const SizedBox(height: 20,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: JPInputBox(
                                    inputBoxController: controller.priceController,
                                    label: 'price'.tr,
                                    type: JPInputBoxType.withLabel,
                                    fillColor: JPAppTheme.themeColors.base,
                                    isRequired: true,
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(RegexExpression.price))],
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                                    onChanged: controller.onItemDataChanged,
                                    validator: FormValidator.validatePrice,
                                    maxLength: 9,
                                  ),),
                                Container(
                                  margin: const EdgeInsets.only(top: 20,left: 5,right: 5,),
                                  child: const JPText(text: 'x', textSize: JPTextSize.heading3),
                                ),
                                Expanded(
                                  child: JPInputBox(
                                    inputBoxController: controller.qtyController,
                                    label: 'qty'.tr,
                                    type: JPInputBoxType.withLabel,
                                    fillColor: JPAppTheme.themeColors.base,
                                    isRequired: true,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(RegexExpression.amount))],
                                    onChanged: controller.onItemDataChanged,
                                    validator: FormValidator.validateQty,
                                    maxLength: 9,
                                  ),),
                              ],),
                            const SizedBox(height: 27,),
                            JPInputBox(
                              inputBoxController: controller.descriptionController,
                              label: 'description'.tr,
                              type: JPInputBoxType.withLabel,
                              fillColor: JPAppTheme.themeColors.base,
                              maxLines: 5,
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                JPText(text: 'total_price'.tr,
                                    fontWeight: JPFontWeight.medium,
                                    textSize: JPTextSize.heading3
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: JPText(text: JobFinancialHelper.getCurrencyFormattedValue(
                                        value: controller.itemTotalPrice),
                                      textColor: JPAppTheme.themeColors.primary,
                                      fontWeight: JPFontWeight.medium,
                                      textSize: JPTextSize.heading3,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                )
                              ],),
                            const SizedBox(height: 30,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: JPResponsiveDesign.popOverButtonFlex,
                                    child: JPButton(
                                      text: 'cancel'.toUpperCase(),
                                      onPressed: () {
                                        Get.back();
                                      },
                                      fontWeight: JPFontWeight.medium,
                                      size: JPButtonSize.small,
                                      colorType: JPButtonColorType.lightGray,
                                      textColor: JPAppTheme.themeColors.tertiary,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    flex: JPResponsiveDesign.popOverButtonFlex,
                                    child: JPButton(
                                      onPressed: () => controller.addUpdateBillItem(billItemModel, onAddUpdate),
                                      text: billItemModel != null ? 'update'.tr.toUpperCase() : 'save'.tr.toUpperCase(),
                                      fontWeight: JPFontWeight.medium,
                                      size: JPButtonSize.small,
                                      colorType: JPButtonColorType.primary,
                                      textColor: JPAppTheme.themeColors.base,
                                    ),
                                  )
                                ]),
                          ],
                        ),
                      ),
                    )
                  ],),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
