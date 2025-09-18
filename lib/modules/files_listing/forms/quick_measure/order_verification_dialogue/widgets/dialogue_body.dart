import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../common/enums/form_fields_sections.dart';
import '../../../../../../common/models/forms/quick_measure/index.dart';
import '../../../../../../global_widgets/divider/index.dart';
import '../../../../../job/job_detail/widgets/detail_tile.dart';
import '../controller.dart';
import 'body_sections/other_information.dart';
import 'body_sections/product_information.dart';

class QuickMeasureOrderDialogueBody extends StatelessWidget {
  const QuickMeasureOrderDialogueBody({
    super.key,
    required this.controller,
    required this.isDefaultLocation,
    required this.formData
  });

  final QuickMeasureOrderVerificationDialogueController controller;
  final bool isDefaultLocation;
  final QuickMeasureFormData formData;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///   address
            JobDetailTile(
              isVisible: controller.isVisible(FormFieldsSections.address),
              label: "address".tr,
              description: controller.getFormattedAddress,
            ),
            JPDivider(isVisible: controller.isVisible(FormFieldsSections.address)),
            ///   pin location
            JobDetailTile(
              isVisible: controller.isVisible(FormFieldsSections.address),
              label: "pin_location".tr,
              description: controller.getPinLocation,
              descriptionColor: controller.formData.selectedAddress?.lat == null ? JPAppTheme.themeColors.secondary : null,
            ),
            JPDivider(isVisible: controller.isVisible(FormFieldsSections.address)),
            ///   product Information
            Visibility(
              visible: controller.isVisible(FormFieldsSections.product),
              child: QuickMeasureOrderDialogueProductSection(formData: formData
              ),
            ),

            ///   other Information
            Visibility(
              visible: controller.isVisible(FormFieldsSections.other),
              child: QuickMeasureOrderDialogueOtherSection(formData: formData)
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
