import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/division_unmatch.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class DivisionUnMatchAlert extends StatelessWidget {
  const DivisionUnMatchAlert({
    super.key,
    required this.jobs,
    required this.usersFromAnotherDivision,
    required this.type,
  });

  final List<JobModel> jobs;
  final List<JPMultiSelectModel> usersFromAnotherDivision;
  final DivisionUnMatchType type;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.only(left: 10, right: 10),
      contentPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Builder(
        builder: (context) {
          return Container(
            padding:
                const EdgeInsets.only(right: 16, top: 12, bottom: 16, left: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        JPText(
                          text: "alert!".tr.toUpperCase(),
                          textSize: JPTextSize.heading3,
                          fontWeight: JPFontWeight.medium,
                        ),
                        JPTextButton(
                          onPressed: () {
                            Get.back();
                          },
                          color: JPAppTheme.themeColors.text,
                          icon: Icons.clear,
                          iconSize: 24,
                        )
                      ]),
                ),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      JPRichText(
                        text: TextSpan(children: [
                          JPTextSpan.getSpan(getTitle(),
                              textAlign: TextAlign.start,
                              textColor: JPAppTheme.themeColors.tertiary,
                              height: 1.5),
                          JPTextSpan.getSpan(' $jobNames ',
                              textAlign: TextAlign.start,
                              fontWeight: JPFontWeight.medium,
                              textColor: JPAppTheme.themeColors.primary,
                              height: 1.5),
                          JPTextSpan.getSpan('which_belongs_to_division'.tr,
                              textAlign: TextAlign.start,
                              textColor: JPAppTheme.themeColors.tertiary,
                              height: 1.5),
                          JPTextSpan.getSpan(' ($divisions) ',
                              textAlign: TextAlign.start,
                              fontWeight: JPFontWeight.medium,
                              textColor: JPAppTheme.themeColors.primary,
                              height: 1.5),
                          JPTextSpan.getSpan(
                              'and_the_selected_users_doesnt_belong_to_the_same_division'.tr,
                              textAlign: TextAlign.start,
                              textColor: JPAppTheme.themeColors.tertiary,
                              height: 1.5),
                          JPTextSpan.getSpan(' ($divisions)',
                              textAlign: TextAlign.start,
                              fontWeight: JPFontWeight.medium,
                              textColor: JPAppTheme.themeColors.primary,
                              height: 1.5),
                          JPTextSpan.getSpan('. ${'please_correct_and_try_again'.tr}',
                              textAlign: TextAlign.start,
                              textColor: JPAppTheme.themeColors.tertiary,
                              height: 1.5),
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Wrap(
                        runSpacing: 5,
                        spacing: 5,
                        children: List.generate(usersFromAnotherDivision.length,
                            (index) {
                          final user = usersFromAnotherDivision[index];

                          return JPChip(
                            text: user.label,
                            child: user.child,
                          );
                        }),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        JPButton(
                          text: 'close'.toUpperCase(),
                          onPressed: () {
                            Get.back();
                          },
                          fontWeight: JPFontWeight.medium,
                          size: JPButtonSize.small,
                          colorType: JPButtonColorType.lightGray,
                          textColor: JPAppTheme.themeColors.tertiary,
                        ),
                      ]),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  String get jobNames => jobs.map((job) => Helper.getJobName(job)).toSet().join(", ");

  String get divisions => jobs.map((job) => job.division?.name ?? '').toSet().join(", ");

  String getTitle() {
    switch (type) {
      case DivisionUnMatchType.schedule:
        return 'this_schedule_is_linked_to'.tr;

      case DivisionUnMatchType.appointment:
        return 'this_appointment_is_linked_to'.tr;

      case DivisionUnMatchType.job:
        return 'this_job_is_linked_to'.tr;
    }
  }

}
