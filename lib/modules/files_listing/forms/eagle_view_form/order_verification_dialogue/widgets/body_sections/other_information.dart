import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../../common/models/forms/eagleview_order/index.dart';
import '../../../../../../../global_widgets/divider/index.dart';
import '../../../../../../job/job_detail/widgets/detail_tile.dart';

class EagleViewOrderDialogueOtherSection extends StatelessWidget {
  const EagleViewOrderDialogueOtherSection({
    super.key,
    required this.formData
  });

  final EagleViewFormData formData;

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
          isVisible: formData.sendCopyToController.text.isNotEmpty,
          label: "email_recipient".tr,
          description: formData.sendCopyToController.text
        ),
        JPDivider(isVisible: formData.sendCopyToController.text.isNotEmpty),
      ],
    );
  }
}
