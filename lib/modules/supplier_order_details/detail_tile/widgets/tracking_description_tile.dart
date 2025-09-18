import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/custom_fields/custom_fields.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/custom_fields/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../global_widgets/custom_material_card/index.dart';

class SrsTrackingDetailTile extends StatelessWidget {

  const SrsTrackingDetailTile({
    super.key, 
    this.transactionNumber, 
    this.dateOrdered, 
    this.expectedDeliveryDate, 
    this.trackingUrl, 
    this.deliveryDate, 
    this.isDeliveryCompleted = false, 
    this.onTapOfPdf, 
  });

  final String? transactionNumber;
  final String? dateOrdered;
  final String? expectedDeliveryDate;
  final String? trackingUrl;
  final String ? deliveryDate;
  final bool isDeliveryCompleted;
  final VoidCallback? onTapOfPdf;

  @override
  Widget build(BuildContext context) {
    return CustomMaterialCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomFields(
            customFields: [
              CustomFieldsModel(
                type: 'text',
                name: 'transaction_number'.tr,
                value: transactionNumber 
              ),
              CustomFieldsModel(
                isVisible: isDeliveryCompleted,
                type: 'text',
                name: 'delivered_on'.tr,
                value:  DateTimeHelper.convertHyphenIntoSlash(dateOrdered ?? '')
              ),
              CustomFieldsModel(
                type: 'text',
                name: 'date_ordered'.tr,
                value:  DateTimeHelper.convertHyphenIntoSlash(dateOrdered ?? '')
              ),
              CustomFieldsModel(
                type: 'text',
                name: 'expected_delivery_date'.tr,
                value: DateTimeHelper.convertHyphenIntoSlash(expectedDeliveryDate ?? ''),
              ),
            ],
          ),
          Divider(height: 1, color: JPAppTheme.themeColors.dimGray,),
          Padding(
            padding: const EdgeInsets.only(left: 16,top:10, bottom: 10),
            child: GestureDetector(
              onTap: () {
                Helper.launchUrl(trackingUrl ?? '');
              },
              child: JPText(
                text: 'link_to_tracking'.tr,
                textColor: JPAppTheme.themeColors.primary,
              ), 
            ),
          ),
          Divider(height: 1, color: JPAppTheme.themeColors.dimGray,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JPText(
                  text: 'proof_of_delivery'.tr,
                  textAlign: TextAlign.start,
                  textSize: JPTextSize.heading5,
                  textColor: JPAppTheme.themeColors.tertiary
                ),
                const SizedBox(height: 6,),
                GestureDetector(
                  onTap : onTapOfPdf,
                  child: JPText(
                    text: isDeliveryCompleted ? 'download_pdf'.tr : 'n_a'.tr,
                    textAlign: TextAlign.start,
                    textColor: isDeliveryCompleted ? JPAppTheme.themeColors.primary : JPAppTheme.themeColors.text,
                    textSize: JPTextSize.heading4,
                  ),
                ),
              ],
            ),             
          ),
        ],
      )
    ); 
  }
}
