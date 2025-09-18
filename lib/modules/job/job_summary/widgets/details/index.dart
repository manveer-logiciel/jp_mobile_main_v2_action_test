import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/job/customer_info.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_summary/customize/section_item.dart';
import 'package:jobprogress/core/constants/job_overview.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/expansion_tile/index.dart';
import 'package:jobprogress/modules/job/job_summary/widgets/details/contact_persons/index.dart';
import 'package:jobprogress/modules/job/job_summary/widgets/details/customer_info/index.dart';
import 'package:jobprogress/modules/job/job_summary/widgets/details/job_info/index.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobOverViewDetails extends StatelessWidget {
  const JobOverViewDetails({
    super.key,
    required this.tabController,
    this.emailCount,
    required this.job,
    this.onTapViewMore,
    required this.customerInfo,
    this.onTapCallLog,
    this.onTapShare,
    required this.contactPerson,
    required this.isJobDetailExpanded,
    this.onDetailExpansionChanged, 
    this.onTapDescription, 
    this.updateScreen, 
    this.onTapEmailHistory, 
    this.onTapEdit,
    required this.sectionItems
  });

  /// tabController is used to switch between tabs
  final TabController tabController;

  /// job is used to store job data
  final JobModel job;

  /// onTapViewMore handles click on view more
  final VoidCallback? onTapViewMore;

  /// customerInfo used to store customer info
  final List<CustomerInfo> customerInfo;

  /// onTapCallLog handles click on call logs
  final VoidCallback? onTapCallLog;

  /// onTapShare handles click on call share
  final VoidCallback? onTapShare;

  /// contactPerson stores contact persons data
  final List<CompanyContactListingModel> contactPerson;

  /// isJobDetailExpanded is used to expand details on click of details
  final bool isJobDetailExpanded;

  /// onDetailExpansionChanged is callback to manage expansion state
  final Function(bool val)? onDetailExpansionChanged;

  final int? emailCount;

  final Function(String)? onTapDescription;

  final VoidCallback? updateScreen;

  // onTapHistory handles click on email history
  final VoidCallback? onTapEmailHistory;

  // onTapEdit handles click on edit
  final VoidCallback? onTapEdit;

  /// sectionItems is used to store tabs order
  final List<JobOverviewSectionItem> sectionItems;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      child: JPExpansionTile(
        isExpanded: isJobDetailExpanded,
        onExpansionChanged: onDetailExpansionChanged,
        header: SizedBox(
          height: 30,
          child: TabBar(
            controller: tabController,
            tabs: getTabs(),
            padding: const EdgeInsets.all(0),
            labelStyle: TextStyle(
              fontSize: TextHelper.getTextSize(JPTextSize.heading4),
              fontFamily: TextHelper.getFontFamily(JPFontFamily.roboto, JPFontWeight.regular),
            ),
            labelColor: JPAppTheme.themeColors.primary,
            unselectedLabelColor: JPAppTheme.themeColors.text,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            // splashBorderRadius: BorderRadius.circular(8),
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                return states.contains(WidgetState.focused) ? null : JPColor.transparent;
              },
            ),
            indicator: BoxDecoration(
              color: JPAppTheme.themeColors.lightBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            labelPadding: const EdgeInsets.fromLTRB(10, 2, 10, 0),
            indicatorColor: JPAppTheme.themeColors.base,
          ),
        ),
        headerPadding: const EdgeInsets.only(
          top: 16,
          bottom: 10,
          left: 14,
          right: 14
        ),
        trailing: (bool isExpanded) {
          return const Padding(
            padding: EdgeInsets.all(2.0),
            child: JPIcon(
              Icons.keyboard_arrow_down_outlined,
            ),
          );
        },
        children: [
          Divider(
            thickness: 1,
            height: 1,
            color: JPAppTheme.themeColors.dimGray,
          ),

          if(doShowTab(JobOverviewConstants.job))
            JobOverViewDetailsJobInfo(
              onTapDescription: onTapDescription,
              emailCount: emailCount ?? 0,
              job: job,
              onTapViewMore: onTapViewMore,
              onTapEdit: onTapEdit,
            ),

          if(doShowTab(JobOverviewConstants.customer))
            JobOverViewDetailsCustomerInfo(
              customerInfo: customerInfo,
              job: job,
              customerName: job.customer?.fullNameMobile ?? '',
              onTapCallLog: onTapCallLog,
              onTapShare: onTapShare,
              updateScreen: updateScreen,
              onTapEmailHistory: onTapEmailHistory,
            ),

          if(doShowTab(JobOverviewConstants.contactPersons))
            JobOverViewContactPersons(
              persons: contactPerson,
              job: job,
              updateScreen: updateScreen,
            ),
        ],
      ),
    );
  }

  /// Returns a list of Tab widgets based on the section items configured in the job overview.
  ///
  /// This method maps each section item to a corresponding Tab widget with appropriate text:
  /// - For job section: Shows "project_info" or "job_info" based on job type
  /// - For customer section: Shows "customer_info"
  /// - For contact persons section: Shows "contact_persons"
  List<Widget> getTabs() {
    return sectionItems.map((item) {
      switch (item.key) {
        case JobOverviewConstants.job:
          return Tab(
            key: const ValueKey(WidgetKeys.jobInfo),
            text: job.isProject! ? 'project_info'.tr : 'job_info'.tr,
          );
        case JobOverviewConstants.customer:
          return Tab(
            key: const ValueKey(WidgetKeys.customerInfo),
            text: 'customer_info'.tr,
          );
        case JobOverviewConstants.contactPersons:
          return Tab(
            key: const ValueKey(WidgetKeys.contactPersons),
            text: 'contact_persons'.tr,
          );
        default:
          return const SizedBox.shrink();
      }
    }).toList();
  }

  /// Determines whether a specific tab should be displayed based on the current tab selection.
  ///
  /// This method checks if:
  /// 1. The specified tab key exists in the section items
  /// 2. The current tab controller index matches the index of that section item
  ///
  /// [tabKey] String The key identifier for the tab to check
  /// Returns bool True if the tab should be displayed, false otherwise
  bool doShowTab(String tabKey) {
    final item = sectionItems.firstWhereOrNull((item) => item.key == tabKey);
    return item != null && tabController.index == item.index;
  }
}
