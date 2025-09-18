import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../../common/models/forms/quick_measure/index.dart';
import '../../../../../../../global_widgets/divider/index.dart';
import '../../../../../../job/job_detail/widgets/detail_tile.dart';

class QuickMeasureOrderDialogueOtherSection extends StatelessWidget {
  const QuickMeasureOrderDialogueOtherSection({
    super.key,
    required this.formData
  });

  final QuickMeasureFormData formData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///   other Information
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: JPText(
            text: "other_information".tr.toUpperCase(),
            textAlign: TextAlign.start,
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.darkGray,
            fontWeight: JPFontWeight.medium,
          ),
        ),
        ///   email recipient
        JobDetailTile(
          isVisible: formData.emailController.text.isNotEmpty,
          label: "email_recipient".tr,
          description: formData.emailController.text,
        ),
        JPDivider(isVisible: formData.emailController.text.isNotEmpty),
        ///   claim Info
        JobDetailTile(
          isVisible: formData.specialInfoController.text.isNotEmpty,
          label: "special_instructions".tr,
          description: formData.specialInfoController.text,
        ),
        JPDivider(isVisible: formData.specialInfoController.text.isNotEmpty),
      ],
    );
  }
}
