import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../core/constants/regex_expression.dart';
import '../../../../../../core/utils/form/validators.dart';
import '../../../../../../core/utils/job_financial_helper.dart';
import 'controller.dart';


class RefundAddItemBottomSheet extends StatelessWidget {
  final SheetLineItemModel? refundItemModel;
  final Function(SheetLineItemModel itemModel, bool isUpdate) onAddUpdate;
  const RefundAddItemBottomSheet({
    super.key,
    required this.onAddUpdate,
    this.refundItemModel
  });

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<RefundAddItemController>(
      init: RefundAddItemController(item: refundItemModel),
      builder: (controller) => Container(
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
                            text: refundItemModel!= null ?
                            'update_item'.tr.toUpperCase() :
                            'add_item'.tr.toUpperCase(),
                            textSize: JPTextSize.heading3,
                            fontWeight: JPFontWeight.medium,
                          ),
                          const SizedBox(height: 20,),
                          JPInputBox(
                            inputBoxController: controller.activityController,
                            label: 'activity'.tr,
                            type: JPInputBoxType.withLabel,
                            fillColor: JPAppTheme.themeColors.base,
                            isRequired: true,
                            readOnly: true,
                            maxLines: 6,
                            onPressed: controller.openFinancialProductSearch,
                            onChanged: controller.onItemDataChanged,
                            validator: controller.validateActivityTitle,
                          ),
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
                                    onPressed: () => controller.addUpdateRefundItem(refundItemModel, onAddUpdate),
                                    text: refundItemModel != null ? 'update'.tr.toUpperCase() : 'save'.tr.toUpperCase(),
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
    );
  }
}
