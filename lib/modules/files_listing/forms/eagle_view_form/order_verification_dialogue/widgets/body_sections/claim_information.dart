import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../../common/models/forms/eagleview_order/index.dart';
import '../../../../../../../global_widgets/divider/index.dart';
import '../../../../../../job/job_detail/widgets/detail_tile.dart';

class EagleViewOrderDialogueClaimSection extends StatelessWidget {
  const EagleViewOrderDialogueClaimSection({
    super.key,
    required this.formData
  });

  final EagleViewFormData formData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///   claim Information
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: JPText(
            text: formData.claimInfoController.text,
            textAlign: TextAlign.start,
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.darkGray,
            fontWeight: JPFontWeight.medium,
          ),
        ),
        ///   claim number
        JobDetailTile(
          isVisible: formData.claimNumberController.text.isNotEmpty,
          label: "claim_number".tr,
          description:  formData.claimNumberController.text,
        ),
        JPDivider(isVisible: formData.claimNumberController.text.isNotEmpty,),
        ///   claim Info
        JobDetailTile(
          isVisible: formData.claimInfoController.text.isNotEmpty,
          label: "claim_info".tr,
          description: formData.claimInfoController.text,
        ),
        JPDivider(isVisible: formData.claimInfoController.text.isNotEmpty,),
        ///   PO Number
        JobDetailTile(
          isVisible: formData.poNumberController.text.isNotEmpty,
          label: "po_number".tr,
          description: formData.poNumberController.text,
        ),
        JPDivider(isVisible: formData.poNumberController.text.isNotEmpty,),
        ///   cat id
        JobDetailTile(
          isVisible: formData.catIdController.text.isNotEmpty,
          label: "cat_id".tr,
          description: formData.catIdController.text,
        ),
        JPDivider(isVisible: formData.catIdController.text.isNotEmpty,),
        ///   date of loss
        JobDetailTile(
          isVisible: formData.dateOfLossController.text.isNotEmpty,
          label: "date_of_loss".tr,
          description: formData.dateOfLossController.text,
        ),
        JPDivider(isVisible: formData.dateOfLossController.text.isNotEmpty,),
      ],
    );
  }
}
