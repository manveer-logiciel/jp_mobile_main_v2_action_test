import 'package:flutter/material.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class JobFinancialSecondaryHeader extends StatelessWidget {

  final JobFinancialController jobFinancialController;

  const JobFinancialSecondaryHeader({super.key, required this.jobFinancialController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: JPAppTheme.themeColors.secondary,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: 6
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                JPTextButton(
                  key: const Key(WidgetKeys.secondaryDrawerMenuKey),
                  onPressed: () {
                    jobFinancialController.scaffoldKey.currentState!.openDrawer();
                  },
                  color: JPAppTheme.themeColors.base,
                  icon: Icons.menu_open_outlined,
                  iconSize: 24,
                ),
                const SizedBox(
                  width: 10,
                ),
                JPText(
                  text: jobFinancialController.jobId.toString(),
                  textSize: JPTextSize.heading5,
                  textColor: JPAppTheme.themeColors.base,
                ),
              ],
            ),
          ),
        ),
     ],
    );
  }
}
