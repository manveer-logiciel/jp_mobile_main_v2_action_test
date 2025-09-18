import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobNameWithCompanySetting extends StatelessWidget {
   const JobNameWithCompanySetting({
    super.key,
    required this.job,
    this.textColor,
    this.fontWeight,
    this.textSize,
    this.textDecoration,
    this.alignment = MainAxisAlignment.start,
    this.isClickable = false,
    this.overflow = TextOverflow.ellipsis,
    this.enableMultiLine = false,
    this.isEdit = false,
    this.onTapEdit,
  });

  final JobModel job;
  final Color? textColor;
  final JPFontWeight? fontWeight;
  final JPTextSize? textSize;
  final TextDecoration? textDecoration;
  final MainAxisAlignment alignment;
  final bool isClickable;
  final TextOverflow? overflow;
  final bool? enableMultiLine;
  final VoidCallback? onTapEdit;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    String jobName = Helper.getJobName(job);
    return (enableMultiLine ?? false)
      ? getMultiLineWidget(jobName)
      : getSingleLineWidget(jobName);
  }

  double get ratio => (job.customer?.fullNameMobile?.length ?? 0) / Helper.getJobName(job).length;


  Widget getMultiLineWidget(String jobName) => Row(
    mainAxisAlignment: alignment,
    children: [
      Flexible(
        child: JPRichText(
          overflow: overflow ?? TextOverflow.ellipsis,
          text: JPTextSpan.getSpan(
              "",
              overflow: overflow,
              children: [
                JPTextSpan.getSpan(
                  job.customer?.fullNameMobile ?? "",
                  recognizer: TapGestureRecognizer()..onTap = isClickable
                      ? () => Get.toNamed(Routes.customerDetailing,
                      arguments: {NavigationParams.customerId: job.customerId})
                      : null,
                  textDecoration: textDecoration ?? TextDecoration.none,
                  fontWeight: fontWeight ?? JPFontWeight.regular,
                  textAlign: TextAlign.start,
                  overflow: overflow,
                  textColor: textColor ?? JPAppTheme.themeColors.text,
                  textSize: textSize ?? JPTextSize.heading4,
                ),
                JPTextSpan.getSpan(
                  ' / ',
                  fontWeight: fontWeight ?? JPFontWeight.regular,
                  textAlign: TextAlign.start,
                  textSize: textSize ?? JPTextSize.heading4,
                  textColor: textColor ?? JPAppTheme.themeColors.text,
                ),
                JPTextSpan.getSpan(
                  jobName,
                  textDecoration: textDecoration ?? TextDecoration.none,
                  fontWeight: fontWeight ?? JPFontWeight.regular,
                  textAlign: TextAlign.start,
                  overflow: overflow,
                  textSize: textSize ?? JPTextSize.heading4,
                  textColor: textColor ?? JPAppTheme.themeColors.text,
                )
              ]
          ),
        ),
      ),
      if(isEdit) ...{
        const SizedBox(width: 10,),
        InkWell(
          onTap: onTapEdit,
          child: JPIcon(Icons.edit_outlined,
            size: 24,
            color: JPAppTheme.themeColors.primary,
          ),
        )
      }
    ],
  );

  Widget getSingleLineWidget(String jobName) => Row(
    mainAxisAlignment: alignment,
    children: [
      Visibility(
        visible: job.customer?.fullNameMobile?.isNotEmpty ?? false,
        child: Flexible(
          child: InkWell(
            onTap: isClickable ? () => Get.toNamed(Routes.customerDetailing, arguments: {NavigationParams.customerId: job.customer?.id ?? job.customerId}) : null,
            child: JPText(
              textDecoration: textDecoration ?? TextDecoration.none,
              text: job.customer?.fullNameMobile ?? "",
              fontWeight: fontWeight ?? JPFontWeight.regular,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              textColor: textColor ?? JPAppTheme.themeColors.text,
              textSize: textSize ?? JPTextSize.heading4,
            ),
          ),
        ),
      ),
      Visibility(
        visible: jobName.isNotEmpty,
        child: JPText(
          text: ' / ',
          fontWeight: fontWeight ?? JPFontWeight.regular,
          textAlign: TextAlign.start,
          textSize: textSize ?? JPTextSize.heading4,
          textColor: textColor ?? JPAppTheme.themeColors.text,
        ),
      ),
      Flexible(
        child: InkWell(
          onTap: isClickable ? (() => Get.toNamed(Routes.jobSummary, arguments: {NavigationParams.jobId: job.id, NavigationParams.customerId: job.customer?.id ?? job.customerId},preventDuplicates: false)) : null,
          child: JPText(
            textDecoration: textDecoration ?? TextDecoration.none,
            text: jobName,
            fontWeight: fontWeight ?? JPFontWeight.regular,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            textSize: textSize ?? JPTextSize.heading4,
            textColor: textColor ?? JPAppTheme.themeColors.text,
          ),
        ),
      ),
    ],
  );
}
