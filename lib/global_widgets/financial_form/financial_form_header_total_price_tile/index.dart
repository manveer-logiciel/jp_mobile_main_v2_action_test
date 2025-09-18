import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class FinancialFormHeaderTotalPriceTile extends StatelessWidget {
  const FinancialFormHeaderTotalPriceTile({
    super.key,
    this.value,
    this.trailing,
  });

  final String? value;
  final List<Widget>? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 10, 16),
      child: Stack(
        children: [
          // total prize
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              JPText(
                text: 'total_price'.tr,
                textSize: JPTextSize.heading3,
                fontWeight: JPFontWeight.medium,
                textColor: JPAppTheme.themeColors.base,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 5,),
              JPText(
                text: value!,
                textColor: JPAppTheme.themeColors.base,
                fontWeight: JPFontWeight.bold,
                textSize: JPTextSize.size30,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          // apply tax
          Positioned(
            right: 0, top: 0,
            child: Row(
              children: trailing ?? [],
            )
          )
        ],
      ),
    );
  }
}

