import 'package:flutter/material.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class LeapPayPreferencesLabeledToggle extends StatelessWidget {
  const LeapPayPreferencesLabeledToggle({
    super.key,
    required this.value,
    required this.title,
    required this.onToggle,
    this.fee,
    this.subTitle,
    this.isDisabled = false,
  });

  /// [value] set the value of the toggle
  final bool value;

  /// [title] can be used to display title of the item
  final String title;

  /// [title] can be used to display sub-title of the item
  final String? subTitle;

  /// [onToggle] can be used to perform action toggle changed
  final Function(bool) onToggle;

  /// [isDisabled] helps in disabling item
  final bool isDisabled;

  final double? fee;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            JPToggle(
              value: value,
              onToggle: onToggle,
              disabled: isDisabled,
            ),
            const SizedBox(width: 15,),
            Expanded(
              //flex: 2,
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JPText(
                    text: title,
                    textAlign: TextAlign.center,
                    textSize: JPTextSize.heading4,
                    textColor: isDisabled
                        ? JPAppTheme.themeColors.secondaryText
                        : JPAppTheme.themeColors.text,
                  ),
                  if(subTitle != null) ...{
                    const SizedBox(height: 3,),
                    JPText(
                      text: subTitle!,
                      textAlign: TextAlign.start,
                      textColor: isDisabled
                          ? JPAppTheme.themeColors.secondaryText
                          : JPAppTheme.themeColors.text,
                    ),
                  }
                ],
              ),
            ),
            if(fee != null)...{
              Expanded(
                //flex: 1,
                  child: JPRichText(
                    textAlign: TextAlign.end,
                    text: JPTextSpan.getSpan(
                        'Fee Total: ',
                        textSize: JPTextSize.heading4,
                        children: [
                          WidgetSpan(
                            child: JPText(
                              text: JobFinancialHelper.getCurrencyFormattedValue(value: fee),
                              textSize: JPTextSize.heading4,
                              fontWeight: JPFontWeight.bold,
                              textAlign: TextAlign.left,
                            ),
                          )
                        ]
                    ),
                  )
              ),
            }

          ],
        )
    );
  }
}