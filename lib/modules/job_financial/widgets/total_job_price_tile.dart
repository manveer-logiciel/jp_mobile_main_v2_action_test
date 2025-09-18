import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/modules/job_financial/controller.dart';
import 'package:jobprogress/modules/job_financial/widgets/list.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFinanacialTotalJobPriceTile extends StatelessWidget {
  const JobFinanacialTotalJobPriceTile({super.key,this.value, this.showDoneIcon = false,  this.canBlockFinancials = false, required this.controller});
  final String? value;
  final bool showDoneIcon;
  final bool canBlockFinancials;
  final JobFinancialController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left:16, top: 18, right: 14 , bottom: 18),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              JPText(
                text: controller.job?.isProject ?? false ?  'total_project_price'.tr : 'total_job_price'.tr,
                textSize: JPTextSize.heading3,
                fontWeight: JPFontWeight.medium,
                textColor: JPAppTheme.themeColors.base,
              ),
              Row(
                children: [
                  if(!canBlockFinancials)
                  Material(
                    color: JPColor.transparent,
                    child: JPTextButton(
                      key: const ValueKey(WidgetKeys.invoices),
                      icon: Icons.receipt_outlined,
                      iconSize: 24,
                      color: JPAppTheme.themeColors.base,
                      onPressed: controller.navigateToInvoiceScreenWithThumb
                    ),
                  ),
                  const SizedBox(width: 5),
                  Visibility(
                    visible: !Helper.isValueNullOrEmpty(controller.job?.financialDetails),
                    child: Material(
                      color: JPAppTheme.themeColors.secondary,
                      borderRadius:BorderRadius.circular(12) ,
                      child: JPPopUpMenuButton(
                        popUpMenuButtonChild: Padding(
                          padding: const EdgeInsets.all(8),
                          child: JPIcon(Icons.more_vert_outlined,color: JPAppTheme.themeColors.base)),
                        itemList: controller.getActionList(),
                        popUpMenuChild:(PopoverActionModel value) {
                          return JobFinancialOptionsList(value: value.label);
                        },
                        onTap: (PopoverActionModel selected) => controller.onPopUpMenuItemTap(selected),
                      ),
                    ),
                  ),
                ],
              ), 
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Flexible(
                child: JPText(
                  text: value!,
                  textColor: JPAppTheme.themeColors.base,
                  fontWeight: JPFontWeight.bold,
                  textSize: JPTextSize.size30,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(width: 15),
              if(showDoneIcon)
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: JPAppTheme.themeColors.success),
                child:JPIcon(
                  Icons.done,
                  size: 22,
                  color: JPAppTheme.themeColors.base,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

