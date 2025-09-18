import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class IntegratedSupplierDeactivated extends StatelessWidget {
  final VoidCallback? onCreateAnyway;
  final String materialSupplierType;
  const IntegratedSupplierDeactivated({
    super.key,
    required this.onCreateAnyway,
    required this.materialSupplierType
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20)
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JPText(text: 'required_supplier_is_not_active'.trParams({
              'type': materialSupplierType
            }).toUpperCase(),
              textSize: JPTextSize.heading3,
              fontWeight: JPFontWeight.medium,
            ),
            const SizedBox(height: 10,),
            JPText(text: 'integrated_supplier_deactivated_description'.tr,
              textSize: JPTextSize.heading5,
              textAlign: TextAlign.start,
              height: 1.3,
            ),
            const SizedBox(height: 10),
            _getBulletPoint('integrated_supplier_deactivated_description_point1'.tr),
            const SizedBox(height: 8),
            _getBulletPoint('integrated_supplier_deactivated_description_point2'.tr),
            const SizedBox(height: 8),
            _getBulletPoint('integrated_supplier_deactivated_description_point3'.tr),
            const SizedBox(height: 10),
            Flexible(
              child: JPText(text: 'integrated_supplier_deactivated_description_note'.tr,
                textSize: JPTextSize.heading5,
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: JPResponsiveDesign.popOverButtonFlex,
                  child: JPButton(
                    text: 'close'.tr.toUpperCase(),
                    textColor: JPAppTheme.themeColors.tertiary,
                    size: JPButtonSize.small,
                    colorType: JPButtonColorType.lightGray,
                    onPressed: Get.back<void>,
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                Expanded(
                  flex: JPResponsiveDesign.popOverButtonFlex,
                  child: JPButton(
                      text: 'create_anyway'.tr.toUpperCase(),
                      textColor: JPAppTheme.themeColors.base,
                      size: JPButtonSize.small,
                      colorType: JPButtonColorType.tertiary,
                      onPressed: () {
                        Get.back();
                        onCreateAnyway?.call();
                      }
                  ),
                ),
              ]
            )
          ],
        ),
      ),
    );
  }

  Widget _getBulletPoint(String bulletPoint) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: JPAppTheme.themeColors.themeBlack
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: JPText(text: bulletPoint,
                textSize: JPTextSize.heading5,
                textAlign: TextAlign.start,
                height: 1.3
            ),
          ),
        ],
      ),
    );
  }
}
