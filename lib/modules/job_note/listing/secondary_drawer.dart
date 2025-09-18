import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'controller.dart';

class JobNoteSecondaryHeader extends StatelessWidget {

  final JobNoteListingController jobNoteController;

  const JobNoteSecondaryHeader({super.key, required this.jobNoteController});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 5,
          top: 5
        ),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const SizedBox(width: double.infinity,),
            JPText(
              text: title + (jobNoteController.jobNoteListOfTotalLength == 0 ? '':  ' (${jobNoteController.jobNoteListOfTotalLength})'),
              fontWeight: JPFontWeight.medium,
              textSize: JPTextSize.heading4,
            ),
            Wrap(
              children: [
                JPTextButton(
                  color: JPAppTheme.themeColors.tertiary,
                  onPressed: () {
                    jobNoteController.filterJobNoteListByStage();
                  },
                  fontWeight: JPFontWeight.medium,
                  textSize: JPTextSize.heading5,
                  text: jobNoteController.selectedStage != null ? '${'stage:'.capitalize!.tr} ${jobNoteController.selectedStage!.name}' : 'stage_all'.tr,
                  icon: Icons.keyboard_arrow_down_outlined,
                ),
                if(jobNoteController.jobNoteList.length > 1 && !jobNoteController.isLoading)
                InkWell(
                  onTap: () {
                    jobNoteController.sortJobNoteListing();
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: jobNoteController.paramKeys.sortOrder == 'desc' ? SvgPicture.asset('assets/svg/sort_asc.svg') : SvgPicture.asset('assets/svg/sort_desc.svg'),
                  )
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  String get title => jobNoteController.job == null ? '' : jobNoteController.job?.parentId != null ? 'project_notes'.tr.toUpperCase() : 'job_notes'.tr.toUpperCase();
}
