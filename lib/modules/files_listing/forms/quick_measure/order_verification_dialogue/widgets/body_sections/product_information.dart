import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../../common/models/forms/quick_measure/index.dart';
import '../../../../../../../global_widgets/divider/index.dart';
import '../../../../../../job/job_detail/widgets/detail_tile.dart';

class QuickMeasureOrderDialogueProductSection extends StatelessWidget {
  const QuickMeasureOrderDialogueProductSection({
    super.key,
    required this.formData
  });

  final QuickMeasureFormData formData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///   product Information
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: JPText(
            text: "product_information".tr.toUpperCase(),
            textAlign: TextAlign.start,
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.darkGray,
            fontWeight: JPFontWeight.medium,
          ),
        ),
        ///   product Name
        JobDetailTile(
          isVisible: formData.selectedProduct?.label.isNotEmpty ?? false,
          label: "products".tr,
          description: formData.selectedProduct?.label,
        ),
        JPDivider(isVisible: formData.selectedProduct?.label.isNotEmpty ?? false),
      ],
    );
  }
}
