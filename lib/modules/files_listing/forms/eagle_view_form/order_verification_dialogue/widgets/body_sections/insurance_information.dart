import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../../common/models/forms/eagleview_order/index.dart';
import '../../../../../../../global_widgets/divider/index.dart';
import '../../../../../../job/job_detail/widgets/detail_tile.dart';

class EagleViewOrderDialogueInsuranceSection extends StatelessWidget {
  const EagleViewOrderDialogueInsuranceSection({
    super.key,
    required this.formData
  });

  final EagleViewFormData formData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///   insurance Information
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: JPText(
            text: "insurance_information".tr.toUpperCase(),
            textAlign: TextAlign.start,
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.darkGray,
            fontWeight: JPFontWeight.medium,
          ),
        ),
        ///   insured Name
        JobDetailTile(
          isVisible: formData.insuredNameController.text.isNotEmpty,
          label: "insured_name".tr,
          description: formData.insuredNameController.text,
        ),
        JPDivider(isVisible: formData.insuredNameController.text.isNotEmpty,),
        ///   reference
        JobDetailTile(
          isVisible: formData.referenceIdController.text.isNotEmpty,
          label: "reference_id".tr,
          description: formData.referenceIdController.text,
        ),
        JPDivider(isVisible: formData.referenceIdController.text.isNotEmpty,),
        ///   batch
        JobDetailTile(
          isVisible: formData.batchIdController.text.isNotEmpty,
          label: "batch_id".tr,
          description: formData.batchIdController.text,
        ),
        JPDivider(isVisible: formData.batchIdController.text.isNotEmpty,),
        ///   policy Number
        JobDetailTile(
          isVisible: formData.policyNoController.text.isNotEmpty,
          label: "policy_number".tr,
          description: formData.insuredNameController.text,
        ),
        JPDivider(isVisible: formData.insuredNameController.text.isNotEmpty),
      ],
    );
  }
}
