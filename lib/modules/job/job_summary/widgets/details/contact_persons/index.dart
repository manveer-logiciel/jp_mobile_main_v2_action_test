import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/global_widgets/expansion_tile/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'details.dart';

class JobOverViewContactPersons extends StatelessWidget {

  const JobOverViewContactPersons({
    super.key,
    required this.persons,
    required this.job, 
    this.updateScreen,
  });

  /// list of contact persons to be displayed
  final List<CompanyContactListingModel> persons;

  /// job is used to store job data
  final JobModel job;

  // updateScreen is used to update screen
  final VoidCallback? updateScreen;

  @override
  Widget build(BuildContext context) {

    return Material(
      color: JPAppTheme.themeColors.base,
      child: persons.isEmpty
          ? SizedBox(
              height: 150,
              child: Center(
                child: JPText(
                  text: 'no_contact_persons'.tr,
                ),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 4),
              physics: const ClampingScrollPhysics(),
              itemBuilder: (_, index) {
                final data = persons[index];
                return JPExpansionTile(
                  initialCollapsed: index != 0,
                  header: Row(
                    children: [
                      /// name
                      JPText(
                        text: data.fullNameMobile ?? '',
                        textAlign: TextAlign.start,
                        fontWeight: JPFontWeight.medium,
                      ),

                      /// primary tag
                      if (data.isPrimary) ...{
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: JPAppTheme.themeColors.success,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          child: JPText(
                            text: 'primary'.tr.capitalize!,
                            textSize: JPTextSize.heading6,
                            textColor: JPAppTheme.themeColors.base,
                          ),
                        ),
                      }
                    ],
                  ),
                  headerPadding: const EdgeInsets.only(
                      left: 16, right: 15, top: 16, bottom: 8),
                  trailing: (bool isExpanded) {
                    return Container(
                      height: 26,
                      width: 26,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: JPAppTheme.themeColors.lightBlue,
                      ),
                      child: const JPIcon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 18,
                      ),
                    );
                  },
                  children: [
                    JobOverviewContactPersonDetails(
                      type: 'email',
                      list: data.emails,
                      personId: data.id!,
                      person: data,
                      job: job,
                      isDescriptionSelectable: data.emails?.isNotEmpty ?? false,
                    ),
                    JobOverviewContactPersonDetails(
                      type: 'phone',
                      list: data.phones,
                      emailList: data.emails,
                      updateScreen: updateScreen,
                      personId: data.id!,
                      person: data,
                      job: job,
                      isDescriptionSelectable: data.phones?.isNotEmpty ?? false,
                    ),
                    if (data.addressString?.isNotEmpty ?? false)
                      JobOverviewContactPersonDetails(
                        type: 'location',
                        list: [data.addressString],
                        personId: data.id!,
                        person: data,
                        job: job,
                        isDescriptionSelectable: true,
                      ),
                    const SizedBox(
                      height: 4,
                    )
                  ],
                );
              },
              separatorBuilder: (_, __) => Divider(
                height: 4,
                thickness: 1,
                color: JPAppTheme.themeColors.dimGray,
              ),
              itemCount: persons.length,
            ),
    );
  }
}
