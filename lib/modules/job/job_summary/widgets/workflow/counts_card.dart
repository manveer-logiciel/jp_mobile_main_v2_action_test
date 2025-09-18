
import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobOverViewWorkFlowCountCard extends StatelessWidget {

  const JobOverViewWorkFlowCountCard({
    super.key,
    this.bgColor,
    this.textColor,
    required this.count,
    required this.title,
    this.onTap
  });

  /// bgColor used to give background color
  final Color? bgColor;

  /// textColor is used to give text color
  final Color? textColor;

  /// count is the text to be displayed on card as count
  final String count;

  /// title is name of counts
  final String title;

  /// onTap handles click in card
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: InkWell(
          onTap: onTap,
          splashColor: bgColor,
          highlightColor: bgColor?.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          child: JPResponsiveBuilder(
            mobile: Column(
              children: [
                getCount(),
                getTitle(),
                const SizedBox(
                  height: 6,
                ),
              ],
            ),
            tablet: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getCount(),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                      child: getTitle(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getCount() => Padding(
    padding: const EdgeInsets.all(7.0),
    child: AspectRatio(
      aspectRatio: 1,
      child: Material(
        color: bgColor ?? JPAppTheme.themeColors.lightBlue,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: JPText(
              text: count,
              textColor: textColor ?? JPAppTheme.themeColors.primary,
              dynamicFontSize: count.length >= 4 ? 12 : 15,
              fontWeight: JPFontWeight.medium,
              fontFamily: JPFontFamily.montserrat,
              maxLine: 1,
            ),
          ),
        ),
      ),
    ),
  );

  Widget getTitle() => JPText(
    text: title,
    textSize: JPTextSize.heading5,
    maxLine: 1,
    overflow: TextOverflow.ellipsis,
  );

}
