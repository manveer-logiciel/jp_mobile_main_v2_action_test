import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/custom_fields/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../common/models/address/address.dart';
import '../../../../common/models/custom_fields/custom_fields.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../global_widgets/custom_material_card/index.dart';

class SRSShippingAddressTile extends StatelessWidget {
  final AddressModel? data;
  const SRSShippingAddressTile({super.key,this.data});

  @override
  Widget build(BuildContext context) {
    return CustomMaterialCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: JPText(
                text: "shipping_address".tr.toUpperCase(),
                textAlign: TextAlign.start,
                textSize: JPTextSize.heading5,
                textColor: JPAppTheme.themeColors.darkGray,
                fontWeight: JPFontWeight.medium,
              ),
            ),
            CustomFields(
            customFields: [
              CustomFieldsModel(
                type: 'text',
                value: Helper.convertAddress(data)
              ),
              ],
             ),
          ],
        )
    );
  }
}