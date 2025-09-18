import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/has_permission/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
class JobOverViewWorkFlowHeader extends StatelessWidget {
  const JobOverViewWorkFlowHeader({
    super.key,
    this.amount,
    this.isAwarded = false,
    this.onTapAwarded,
    this.onTapTotalJobPrice,
    this.isProject = false
  });
  /// displays amount only if available otherwise
  final String? amount;
  /// displays awarded button default value is [false]
  final bool isAwarded;
  /// helps in show/hide awarded button default value is [false]
  final bool isProject;
  /// onTapAwarded is used to handle tap on awarded/non-awarded
  final VoidCallback? onTapAwarded;
  /// onTapTotalJobPrice is used to open job price update dialog
  final VoidCallback? onTapTotalJobPrice;
  bool get doShowTotalJobPrice => amount != null && double.tryParse(amount!) != 0;
  bool get canUpdatePrice => PermissionService.hasUserPermissions([PermissionConstants.manageFinancial, PermissionConstants.updateJobPrice]);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          /// title
          JPText(
            text: isProject ? 'project_status'.tr.toUpperCase() : 'job_workflow'.tr.toUpperCase(),
            fontWeight: JPFontWeight.medium,
            textAlign: TextAlign.start,
          ),
          /// amount
          if(doShowTotalJobPrice)...{
            const SizedBox(width: 5,),
            HasPermission(
              permissions: const [PermissionConstants.manageFinancial, PermissionConstants.viewFinancial], 
              child: JPButton(
                onPressed: canUpdatePrice ? onTapTotalJobPrice : null,
                text: JobFinancialHelper.getCurrencyFormattedValue(value: amount),
                size: JPButtonSize.extraSmall,
                textSize: JPTextSize.heading5,
                colorType: JPButtonColorType.tertiary,
              ),
            ),
          },

          const Spacer(),

          if(isProject)
            JPButton(
              text: isAwarded ? 'not_awarded'.tr.toUpperCase() : 'awarded'.tr.toUpperCase(),
              size: JPButtonSize.extraSmall,
              textSize: JPTextSize.heading5,
              colorType: JPButtonColorType.primary,
              type: JPButtonType.outline,
              onPressed: onTapAwarded,
            )
        ],
      ),
    );
  }
}