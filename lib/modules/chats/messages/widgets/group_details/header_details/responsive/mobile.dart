import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class GroupDetailsHeaderMobile extends StatelessWidget {
  const GroupDetailsHeaderMobile({
    super.key,
    required this.title,
    required this.profileWidget,
    this.job,
  });

  final JobModel? job;

  final String title;

  final Widget profileWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        profileWidget,
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: JPText(
            text: title,
            textColor: JPAppTheme.themeColors.base,
            fontFamily: JPFontFamily.montserrat,
            textAlign: TextAlign.start,
            maxLine: 1,
            fontWeight: JPFontWeight.medium,
          ),
        ),
      ],
    );
  }
}
