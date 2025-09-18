import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class FinancialTotalPriceTile extends StatelessWidget {
  const FinancialTotalPriceTile({
    super.key,
    this.value,
    this.title, 
    this.trailing,
    this.hideTotal = false
  });
  
  final String? value;
  final String? title;
  final List<Widget>? trailing;
  final bool hideTotal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal:20, vertical: 16),
      child: Stack(
        children: [
           Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              if (hideTotal) ...{
                const SizedBox(height: 40,)
              } else ...{
                JPText(
                  text: title ?? 'total_price'.tr,
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
              }
            ],
          ),
          Positioned(
            right: 0, top: 0,
            child: Row(
              children: trailing ?? [],
            )
          )
        ]
      ),
    );
  }
}

