import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../common/models/financial_product/financial_product_model.dart';

class SRSTemplateProductTile extends StatelessWidget {
  final FinancialProductModel model;
  const SRSTemplateProductTile({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: JPAppTheme.themeColors.base,
      margin: const EdgeInsets.only(top: 5,left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          JPText(
            text: model.name ?? '',
            textSize: JPTextSize.heading5,
          ),
          const SizedBox(height: 5,),
          const Divider(thickness: 0.4)
        ],
      ),
    );
  }
}
