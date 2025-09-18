import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'labeled_toggle.dart';

class WorksheetSettingSection extends StatelessWidget {

  const WorksheetSettingSection({
    super.key,
    this.title,
    required this.settings,
  });

  final String? title;

  final List<Widget> settings;

  @override
  Widget build(BuildContext context) {

    if (settings.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10
      ),
      child: Material(
        color: JPAppTheme.themeColors.base,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...{
                JPText(
                  text: title!.toUpperCase(),
                  textColor: JPAppTheme.themeColors.darkGray,
                  textSize: JPTextSize.heading4,
                  fontWeight: JPFontWeight.medium,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
              },

              ListView.separated(
                shrinkWrap: true,
                primary: false,
                padding: EdgeInsets.zero,
                itemBuilder: (_, index) => settings[index],
                separatorBuilder: (_, index) {
                  // By this condition divider will only be displayed after [WorksheetSettingLabeledToggle]
                  // This is done as some of the settings are dependent on launch darkly and appears dynamically
                  // This change is intended to keep the existing functionality with minimal changes
                  if (settings[index] is WorksheetSettingLabeledToggle) {
                    return Divider(
                      color: JPAppTheme.themeColors.dimGray,
                      thickness: 1,
                      height: 26,
                    );
                  }
                  return const SizedBox();
                },
                itemCount: settings.length,
              )
            ],
          ),
        ),
      ),
    );
  }
}
