import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/job/profit_loss_summary_view_model.dart';
import 'package:jp_mobile_flutter_ui/ToolTip/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../global_widgets/custom_material_card/index.dart';

class ProfitLossSummaryAmountTile extends StatelessWidget {
  const ProfitLossSummaryAmountTile({
    super.key,
    required this.isTileVisible,
    required this.title,
    required this.list,
  });

  final bool isTileVisible;
  final String title;
  final List<ProfitLossSummaryViewModel> list;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isTileVisible,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: CustomMaterialCard(
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///   Title
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: JPText(
                    text: title,
                    textSize: JPTextSize.heading2,
                  ),
                ),
                ///   Amount List
                for (var item in list)
                  Padding(
                    padding: EdgeInsets.only(bottom: item.isPaddingExcluded! ? 3 : 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ///   Amount Title Text along with info Icon
                        Flexible(
                          child: JPRichText(
                            text: JPTextSpan.getSpan(
                              item.priceTitle ?? "",
                              textColor: item.titleColor ?? JPAppTheme.themeColors.tertiary,
                              textAlign: TextAlign.center,
                              fontWeight: item.titleFontWeight ?? JPFontWeight.regular,
                              textSize: item.titleTextSize ?? JPTextSize.heading4,
                              children: [
                                WidgetSpan(child: Visibility(
                                  visible: item.isInfoIconVisible ?? false,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: JPToolTip(
                                      message: item.infoMessage ?? "",
                                      child: JPIcon(
                                        Icons.info_outline,
                                        color: JPAppTheme.themeColors.primary,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                )),
                              ]
                            ),
                          ),
                        ),
                        ///   Amount Text
                        Flexible(
                          child: JPText(
                            text: item.amount ?? "",
                            textSize: item.amountTextSize ?? JPTextSize.heading4,
                            textColor: item.amountColor ?? JPAppTheme.themeColors.text,
                            fontWeight: item.amountFontWeight,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
