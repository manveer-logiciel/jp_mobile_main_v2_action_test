import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// A tile widget to display payment details in a proceed payment screen
class ProceedPaymentDetailTile extends StatelessWidget {
  /// Constructs a [ProceedPaymentDetailTile].
  ///
  /// [highlightValue] determines whether the value should be highlighted
  /// [title] is the title of the payment detail
  /// [value] is the value of the payment detail
  const ProceedPaymentDetailTile({
    this.highlightValue = false,
    required this.title,
    required this.value,
    this.subText,
    super.key,
  });

  /// Whether the value should be highlighted.
  final bool highlightValue;

  /// The title of the payment detail.
  final String title;

  /// The value of the payment detail.
  final String value;

  final String? subText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 7,
            horizontal: 5
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Expanded(
                    child: JPText(
                      text: title.capitalize!,
                      textAlign: TextAlign.start,
                      textColor: JPAppTheme.themeColors.dimBlack,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: JPText(
                      text: value,
                      textAlign: TextAlign.end,
                      fontWeight: JPFontWeight.medium,
                      textSize: highlightValue
                          ? JPTextSize.heading3
                          : JPTextSize.heading4,
                      textColor: highlightValue
                          ? JPAppTheme.themeColors.themeBlue
                          : JPAppTheme.themeColors.text,
                    ),
                  ),
                ]
              ),
              if(subText != null) ...{
                JPText(
                  text: subText ?? '',
                  textAlign: TextAlign.right,
                  textColor: JPAppTheme.themeColors.darkGray,
                  textSize: JPTextSize.heading5,
                )
              }
            ],
          ),
        ),
        Divider(
          color: JPAppTheme.themeColors.dimGray,
          thickness: 0.8,
        ),
      ],
    );
  }
}
