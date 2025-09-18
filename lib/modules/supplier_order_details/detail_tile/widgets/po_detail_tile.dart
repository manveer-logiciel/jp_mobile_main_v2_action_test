import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/custom_fields/custom_fields.dart';
import 'package:jobprogress/common/models/files_listing/srs/po_details.dart';
import 'package:jobprogress/global_widgets/custom_fields/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../core/utils/date_time_helpers.dart';
import '../../../../global_widgets/custom_material_card/index.dart';

class SRSPoDetailTile extends StatelessWidget {
  const SRSPoDetailTile({
    super.key,
    this.data, 
    this.attachments, 
  });
  final SrsPoDetailsModel? data;
  final List<AttachmentResourceModel>? attachments;
  
  @override
  Widget build(BuildContext context) {
    return CustomMaterialCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: JPText(
                text: "po_details".tr.toUpperCase(),
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
                    name: 'po_number'.tr,
                    value: '${data?.poNumber}'
                ),
              ],
            ),
            CustomFields(
              customFields: [
                CustomFieldsModel(
                  type: 'text',
                  name: 'timezone'.tr,
                  value: '${data?.timezone}' 
                ),
              ],
            ),
            CustomFields(
              customFields: [
                CustomFieldsModel(
                  type: 'text',
                  name: 'requested_delivery_date'.tr,
                  value: DateTimeHelper.convertHyphenIntoSlash(data?.expectedDeliveryDate ?? '')
                ),
              ],
            ),
            CustomFields(
              customFields: [
                CustomFieldsModel(
                  type: 'text',
                  name: 'requested_delivery_time'.tr,
                  value: '${data?.expectedDeliveryTime}' 
                ),
              ],
            ),
            CustomFields(
            customFields: [
              CustomFieldsModel(
                type: 'text',
                name: 'shipping_method'.tr,
                value: '${data?.viewShippingMethod}' 
              ),
              ],
             ),
             CustomFields(
            customFields: [
              CustomFieldsModel(
                type: 'text',
                name: 'delivery_type'.tr,
                value: '${data?.shippingMethod}' 
              ),
              ],
            ),
          ],
        )
    ); 
  }
}
