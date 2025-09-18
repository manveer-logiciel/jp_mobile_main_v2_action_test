import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class GroupDetailsHeaderDesktop extends StatelessWidget {
  const GroupDetailsHeaderDesktop({
    super.key,
    required this.title,
    this.job,
    required this.profileWidget,
    required this.actions,
  });


  final JobModel? job;

  final String title;

  final Widget profileWidget;

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 12
          ),
          child: SizedBox(
            height: 50,
            child: Row(
              children: [
                const SizedBox(
                  width: 12,
                ),
                Transform.scale(
                  scale: 1.5,
                  child: profileWidget,
                ),
                const SizedBox(
                  width: 18,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      JPText(
                        text: title,
                        textColor: JPAppTheme.themeColors.text,
                        fontFamily: JPFontFamily.montserrat,
                        textAlign: TextAlign.start,
                        maxLine: 1,
                        fontWeight: JPFontWeight.bold,
                      ),

                      if(job != null) ...{
                        const SizedBox(height: 2,),
                        JobNameWithCompanySetting(
                          job: job!,
                          alignment: MainAxisAlignment.start,
                          textColor: JPAppTheme.themeColors.tertiary,
                          textDecoration: TextDecoration.underline,
                          isClickable: true,
                          textSize: JPTextSize.heading5,
                        ),
                      }
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions,
                )
              ],
            ),
          ),
        ),
        Divider(
          height: 3,
          thickness: 1.5,
          color: JPAppTheme.themeColors.dimGray,
        )
      ],
    );
  }
}
