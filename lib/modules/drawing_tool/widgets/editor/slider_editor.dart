import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class DrawingToolEditorSlider extends StatelessWidget {
  const DrawingToolEditorSlider({
    super.key,
    required this.value,
    required this.title,
    required this.displayValue,
    required this.displayUnit,
    required this.onChanged,
    required this.divisions,
    this.maxValue,
    this.minValue,
    required this.isVisible,
    this.onTapBack,
    this.isBackButtonVisible = true
  });

  final double value;

  final String title;

  final String displayValue;

  final String displayUnit;

  final int divisions;

  final Function(double value) onChanged;

  final double? minValue;

  final double? maxValue;

  final bool isVisible;

  final bool isBackButtonVisible;

  final VoidCallback? onTapBack;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          if(isBackButtonVisible)...{
            JPTextButton(
              icon: Icons.chevron_left,
              color: JPColor.white,
              onPressed: onTapBack,
              iconSize: 22,
              padding: 8,
            ),

            const SizedBox(
              width: 5,
            ),
          } else...{
            const SizedBox(
              width: 25,
            ),
          },

          Expanded(
            child: Material(
              color: JPColor.black,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 10
                ),
                child: Row(
                  children: [
                    JPText(
                      text: title,
                      fontWeight: JPFontWeight.medium,
                      fontFamily: JPFontFamily.montserrat,
                      textAlign: TextAlign.start,
                      textColor: JPColor.white,
                      textSize: JPTextSize.heading6,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Expanded(
                      child: slider(
                        value: value,
                        divisions: divisions,
                        onChanged: onChanged,
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    JPText(
                      text: displayValue,
                      fontWeight: JPFontWeight.regular,
                      textSize: JPTextSize.heading6,
                      textColor: JPColor.white,
                    ),
                    JPText(
                      text: displayUnit,
                      fontWeight: JPFontWeight.regular,
                      textSize: JPTextSize.heading6,
                      textColor: JPColor.white,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(
            width: 25,
          ),
        ],
      ),
    );
  }

  Widget slider({
    double value = 0.0,
    int divisions = 0,
    required Function(double val) onChanged,
  }) {
    return SliderTheme(
      data: SliderThemeData(
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        trackHeight: 2,
        overlayShape: SliderComponentShape.noOverlay,
        inactiveTrackColor: JPAppTheme.themeColors.dimGray,
        thumbColor: JPAppTheme.themeColors.primary,
        activeTickMarkColor: JPAppTheme.themeColors.primary,
        inactiveTickMarkColor: JPAppTheme.themeColors.dimGray,
        activeTrackColor: JPAppTheme.themeColors.primary,
      ),
      child: Slider(
        value: value,
        min: minValue ?? 0,
        max: maxValue ?? 1,
        divisions: divisions,
        onChanged: onChanged,
      ),
    );
  }
}
