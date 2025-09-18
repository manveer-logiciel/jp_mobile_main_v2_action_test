import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/custom_fields/custom_fields.dart';
import 'package:jobprogress/common/models/files_listing/srs/customer_contact.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/custom_fields/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../global_widgets/custom_material_card/index.dart';

class SRSCompanyContactTile extends StatelessWidget {
  final SrsCustomerContactInfoModel? data;
  const SRSCompanyContactTile({super.key,this.data});

  @override
  Widget build(BuildContext context) {

    return CustomMaterialCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: JPText(
                text: "company_contact".tr.toUpperCase(),
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
                value: '''${data?.customerContactName} \n${Helper.convertAddress(data?.customerContactAddress)}\n${data?.customerContactPhone} \n${data?.customerContactEmail}'''
              ),
              ],
             ),
            
          ],
        )
    );
  }
}