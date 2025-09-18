import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/secondary_drawer_item.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/routes/pages.dart';

class JobDrawerItemLists {
  List<JPSecondaryDrawerItem> jobSummaryItemList = [
    JPSecondaryDrawerItem(
      icon: Icons.dashboard_outlined,
      title: "job_overview".tr,
      slug: 'job_overview',
      route: Routes.jobSummary,
    ),
    JPSecondaryDrawerItem(
      svgAssetsPath: AssetsFiles.measurement,
      title: "measurements".tr,
      slug: FileUploadType.measurements,
      route: Routes.filesListing
    ),
    JPSecondaryDrawerItem(
      icon: Icons.description_outlined,
      title: "estimates".tr,
      slug: FileUploadType.estimations,
      route: Routes.filesListing,
      permissions:[PermissionConstants.manageEstimates],
    ),
    JPSecondaryDrawerItem(
      icon: Icons.description_outlined,
      title: 'forms_proposals'.tr,
      slug: FileUploadType.formProposals,
      route: Routes.filesListing,
      permissions: [
        PermissionConstants.manageProposals,
        PermissionConstants.viewProposals]
    ),
    if (LDService.hasFeatureEnabled(LDFlagKeyConstants.salesProForEstimate))
      JPSecondaryDrawerItem(
        icon: Icons.description_outlined,
        title: 'contracts'.tr,
        slug: FileUploadType.contracts,
        route: Routes.filesListing,
    ),
    if(FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.production]))
    JPSecondaryDrawerItem(
      icon: Icons.assignment_outlined,
      title: 'materials'.tr,
      route: Routes.filesListing,
      slug: FileUploadType.materialList
    ),
    if(FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.production]))
      JPSecondaryDrawerItem(
        icon: Icons.assignment_outlined,
        title: 'work_orders'.tr,
        route: Routes.filesListing,
        slug: FileUploadType.workOrder
      ),
    JPSecondaryDrawerItem(
      icon: Icons.perm_media_outlined,
      title: 'photos_documents'.tr,
      route: Routes.filesListing,
      slug: FileUploadType.photosAndDocs
    ),
    if(FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.financeAndAccounting]))
      JPSecondaryDrawerItem(
        icon: JobFinancialHelper.getCurrencyIcon(),
        title: 'financials'.tr,
        slug: 'job_financial',
        route: Routes.jobfinancial,
        permissions: [
          PermissionConstants.manageFinancial,
          PermissionConstants.viewFinancial],
      ),
    JPSecondaryDrawerItem(
        icon: Icons.contact_phone_outlined,
        title: 'follow_up'.tr,
        slug: 'follow_up',
        route: Routes.followUpsNoteListing
    ),
    if(FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.production]))
      JPSecondaryDrawerItem(
          icon: Icons.notes_outlined,
          title: 'work_crew_notes'.tr,
          slug: 'work_crew_notes',
          route: Routes.workCrewNotesListing
      ),
    JPSecondaryDrawerItem(
      icon: Icons.notes_outlined,
      title: 'job_notes'.tr,
      slug: 'job_notes',
      route: Routes.jobNoteListing
    ),
    JPSecondaryDrawerItem(
      icon: Icons.task_alt_outlined,
      title: 'tasks'.tr,
      slug: 'tasks',
      route: Routes.taskListing
    ),
    JPSecondaryDrawerItem(
      icon: Icons.folder_copy_outlined,
      title: 'stage_resources'.tr,
      route: Routes.filesListing,
      slug: FLModule.stageResources.toString(),
      permissions: [
        PermissionConstants.manageResourceViewer,
        PermissionConstants.viewResourceViewer]
    ),
    JPSecondaryDrawerItem(
      icon: Icons.history_outlined,
      title: 'email_history'.tr,
      slug: 'email_history',
      route: Routes.email
    ),
    if(FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.userManagement]))
      JPSecondaryDrawerItem(
        route: Routes.clockSummary,
        icon: Icons.pending_actions,
        title: 'clock_summary'.tr,
        slug: 'clock_summary',
      ),
  ];
}
