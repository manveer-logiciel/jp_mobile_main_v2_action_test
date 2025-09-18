import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/jpchip_type.dart';
import 'package:jobprogress/common/enums/page_type.dart';
import 'package:jobprogress/common/models/call_logs/call_log.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/job_item_with_company_setting_constant.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/call_log_helper.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/location_helper.dart';
import 'package:jobprogress/global_widgets/custom_material_card/index.dart';
import 'package:jobprogress/global_widgets/from_launch_darkly/index.dart';
import 'package:jobprogress/global_widgets/has_permission/index.dart';
import 'package:jobprogress/global_widgets/quick_book/index.dart';
import 'package:jobprogress/core/constants/follow_ups_note.dart';
import 'package:jobprogress/core/constants/work_flow_stage_color.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_item_with_company_setting.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import 'package:jp_mobile_flutter_ui/Label/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:shimmer/shimmer.dart';
import '../../common/services/user_preferences.dart';
import '../../core/constants/widget_keys.dart';
import '../../core/utils/helpers.dart';
import '../../core/utils/job_financial_helper.dart';
import '../chip_with_avatar/index.dart';
import 'widgets/source_type_content.dart';
import 'widgets/label_value_tile.dart';

class JobListTile extends StatelessWidget {
  final JobModel job;
  final int? index;
  final double? borderRadius;
  final void Function({int? jobID, int? currentIndex})? navigateToDetailScreen;
  final void Function({JobModel? job, int? index})? openQuickActions;
  final void Function({JobModel? job, int? index})? openDescDialog;
  final bool? isLoadingMetaData;
  final void Function({int? index})? onProjectCountPressed;
  final PageType? pageType;

  /// [onTapJobSchedule] handles the click on job schedule chip in the job list tile
  final VoidCallback? onTapJobSchedule;

  /// [onTapProgressBoard] handles the click on progress board chip in the job list tile
  final VoidCallback? onTapProgressBoard;

  const JobListTile({
    super.key,
    required this.job,
    this.navigateToDetailScreen,
    this.openQuickActions,
    this.index,
    this.borderRadius,
    this.openDescDialog,
    this.isLoadingMetaData = false,
    this.onProjectCountPressed,
    this.pageType,
    this.onTapJobSchedule,
    this.onTapProgressBoard,
  });

  @override
  Widget build(BuildContext context) {

    bool isMultiProject = ((job.projectCount ?? 0) != 0);

    bool isIconsVisible = (isMultiProject || pageType != PageType.scheduledListing)
      || (job.currentStage != null)
      || (job.followUpStatus != null && (job.followUpStatus?.taskId == null || job.followUpStatus!.taskId!.isEmpty))
      || (job.followUpStatus?.taskId?.isNotEmpty ?? false) && (job.wpJob?.toString() == "1" &&  job.wpJob?.toString() == "0");

    return CustomMaterialCard(
      borderRadius: borderRadius ?? 18,
      child: InkWell(
        key: ValueKey('${WidgetKeys.jobKey}[$index]'),
        borderRadius: BorderRadius.circular(borderRadius ?? 18),
        onTap: navigateToDetailScreen == null ? null
            : () => navigateToDetailScreen!(jobID: job.id, currentIndex: index!),
        onLongPress: openQuickActions == null ? null
            : () => openQuickActions!(job: job, index: index!),
        child: Padding(
          padding: pageType == PageType.home && (job.flags?.isNotEmpty ?? false)
              ? const EdgeInsets.all(16)
              : const EdgeInsets.fromLTRB(16, 16, 16, 11),
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///   JOb Name
                            Padding(
                              padding: isMultiProject ? const EdgeInsets.only(right: 65)
                                  : isIconsVisible ? const EdgeInsets.only(right: 19)
                                  : const EdgeInsets.only(right: 7),
                              child: JobNameWithCompanySetting(job: job, fontWeight: JPFontWeight.medium),
                            ),
                            space(),
                            ///   Trade Name
                            if(job.tradesString.isNotEmpty)
                              Padding(
                                padding: isMultiProject ? const EdgeInsets.only(right: 65)
                                    : isIconsVisible ? const EdgeInsets.only(right: 19)
                                    : EdgeInsets.zero,
                                child: JPText(
                                  text: job.tradesString,
                                  textColor: JPAppTheme.themeColors.tertiary,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            Visibility(
                                visible: job.isMultiJob
                                    || !Helper.isValueNullOrEmpty(job.jobLostDate)
                                    || Helper.isTrue(job.lostJob)
                                    || (job.archived?.isNotEmpty ?? false),
                                child: const SizedBox(height: 10,)
                            ),
                            ///   Multi Project
                            Row(
                              children: [
                                Visibility(
                                  visible: job.isMultiJob,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: JPChip(
                                      text: "multi_project".tr,
                                      textColor: JPAppTheme.themeColors.base,
                                      backgroundColor: JPAppTheme.themeColors.warning,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: job.archived?.isNotEmpty ?? false,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: JPChip(
                                      text: "archived".tr.capitalize!,
                                      textColor: JPAppTheme.themeColors.base,
                                      backgroundColor: JPAppTheme.themeColors.darkGray,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: !Helper.isValueNullOrEmpty(job.jobLostDate) || Helper.isTrue(job.lostJob),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: JPChip(
                                      text: job.isProject ?? false ? "lost_project".tr.capitalize! : "lost_job".tr.capitalize!,
                                      textColor: JPAppTheme.themeColors.base,
                                      backgroundColor: JPAppTheme.themeColors.secondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12,),
                            ///   JobId
                            JobItemWithCompanySetting(
                              job: job,
                              type: JobItemWithCompanySettingConstant.number,
                              value: job.number,
                              labelTextColor: JPAppTheme.themeColors.secondaryText,
                              valueTextColor: JPAppTheme.themeColors.tertiary,
                            ),
                            ///   AltID
                            JobItemWithCompanySetting(
                              job: job,
                              type: JobItemWithCompanySettingConstant.altId,
                              value: job.altId,
                              labelTextColor: JPAppTheme.themeColors.secondaryText,
                              valueTextColor: JPAppTheme.themeColors.tertiary,
                            ),
                            ///   Job name
                            JobItemWithCompanySetting(
                              job: job,
                              type: JobItemWithCompanySettingConstant.name,
                              value: job.name,
                              labelTextColor: JPAppTheme.themeColors.secondaryText,
                              valueTextColor: JPAppTheme.themeColors.tertiary,
                            ),
                            ///   Address
                            Padding(
                              padding: isIconsVisible ? const EdgeInsets.only(right: 5) : EdgeInsets.zero,
                              child: LabelValueTile(
                                visibility: job.jobAddress?.isNotEmpty ?? false,
                                label: "${"address".tr}:",
                                value: job.jobAddress ?? "",
                              ),
                            ),
                            Visibility(visible: job.jobAddress?.isNotEmpty ?? false, child: const SizedBox(height: 7),),
                            ///   Category
                            Visibility(
                              visible: !Helper.isValueNullOrEmpty(job.jobTypesString),
                              child: LabelValueTile(
                                label: "${"Category".tr}:",
                                value: job.jobTypesString?.isEmpty ?? true ? "unassigned".tr : job.jobTypesString ?? "",
                              ),
                            ),
                            Visibility(
                                visible: (job.jobTypesString?.isNotEmpty ?? false),
                                child: const SizedBox(height: 7,)
                            ),
                            // Work Crews
                            Visibility(
                              visible: !Helper.isValueNullOrEmpty(job.workCrewNames) && !job.isMultiJob,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 7
                                ),
                                child: LabelValueTile(
                                  label: "${"work_crew".tr}:",
                                  value: job.workCrewNames,
                                ),
                              ),
                            ),
                            // Canvasser
                            FromLaunchDarkly(
                              flagKey: LDFlagKeyConstants.jobCanvaser,
                              child: (_) => Visibility(
                                visible: !Helper.isValueNullOrEmpty(job.canvasser) || !Helper.isValueNullOrEmpty(job.canvasserString),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 7
                                  ),
                                  child: LabelValueTile(
                                    label: "${"canvasser".tr}:",
                                    value: job.canvasser?.fullName ?? job.canvasserString,
                                  ),
                                ),
                              ),
                            ),

                            ///   sm/ cust. Rep
                            if(pageType == PageType.jobListing)...{
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 7),
                                  child: LabelValueTile(
                                  label: "${"sm_cust_rep".tr}:",
                                  value: (job.customer?.rep == null) ? 'unassigned'.tr : job.customer?.rep?.fullName.toString() ?? "",
                                ),
                              )
                            },

                            Visibility(
                              visible: !Helper.isValueNullOrEmpty(job.updatedAt),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 7),
                                child: LabelValueTile(
                                  label: "${"last_modified".tr}:",
                                  value: getLastModifiedDate(),
                                ),
                              ),
                            ),

                            (job.scheduled?.isNotEmpty ?? false)
                                || (job.productionBoards?.isNotEmpty ?? false)
                                ? const SizedBox(height: 3,)
                                : const SizedBox.shrink(),

                            /// Appointment Tile
                            if(!Helper.isValueNullOrEmpty(job.appointmentDate))
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
                                child: JPChip(
                                  text: job.appointmentDate!,
                                  textSize: JPTextSize.heading5,
                                  avatarRadius: 10,
                                  avatarBorderColor: JPAppTheme.themeColors.inverse,
                                  backgroundColor: JPAppTheme.themeColors.inverse,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: JPAvatar(
                                      size: JPAvatarSize.small,
                                      backgroundColor: JPAppTheme.themeColors.primary,
                                      child: Icon(Icons.calendar_month, color: JPAppTheme.themeColors.base, size: 12,),
                                    ),
                                  ),
                                ),
                              ),

                            ///   Production Boards && Job scheduled
                            isLoadingMetaData ?? false
                                ? Shimmer.fromColors(
                              baseColor: JPAppTheme.themeColors.dimGray,
                              highlightColor: JPAppTheme.themeColors.inverse,
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.zero,
                                    width: 80,
                                    height: 20,
                                    child:  const JPLabel(
                                      text: " ",
                                      type: JPLabelType.lightGray,
                                    ),
                                  ),
                                  space(),
                                  Container(
                                    padding: EdgeInsets.zero,
                                    width: 80,
                                    height: 20,
                                    child:  const JPLabel(
                                      text: " ",
                                      type: JPLabelType.lightGray,
                                    ),
                                  ),
                                ],
                              ),
                            )
                                : Visibility(
                              visible: (job.scheduled?.isNotEmpty ?? false) || (job.productionBoards?.isNotEmpty ?? false),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: [
                                  Visibility(
                                    visible: job.scheduled?.isNotEmpty ?? false,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                                      child: JPChip(
                                        text: job.scheduled?.toString() ?? "",
                                        textSize: JPTextSize.heading5,
                                        avatarRadius: 10,
                                        avatarBorderColor: JPAppTheme.themeColors.inverse,
                                        backgroundColor: JPAppTheme.themeColors.inverse,
                                        onTapChip: onTapJobSchedule,
                                        child: Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: JPAvatar(
                                            size: JPAvatarSize.small,
                                            backgroundColor: JPAppTheme.themeColors.primary,
                                            child: Icon(Icons.calendar_month, color: JPAppTheme.themeColors.base, size: 12,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: job.productionBoards?.isNotEmpty ?? false,
                                    child: HasPermission(
                                      permissions: const [PermissionConstants.viewProgressBoard,PermissionConstants.manageProgressBoard],
                                      child: Visibility(
                                        visible: !AuthService.isPrimeSubUser(),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                                          child: JPChip(
                                            text: "${"added_in_progress_board".tr} (${(job.productionBoards?.length.toString() ?? "")})",
                                            textSize: JPTextSize.heading5,
                                            avatarRadius: 10,
                                            avatarBorderColor: JPAppTheme.themeColors.inverse,
                                            backgroundColor: JPAppTheme.themeColors.inverse,
                                            onTapChip: onTapProgressBoard,
                                            child: Padding(
                                              padding: const EdgeInsets.all(3),
                                              child: JPAvatar(
                                                size: JPAvatarSize.small,
                                                backgroundColor: JPAppTheme.themeColors.primary,
                                                child: Icon(Icons.wysiwyg, color: JPAppTheme.themeColors.base, size: 12,),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ///   Flags
                            Visibility(
                                visible: job.flags?.isNotEmpty ?? false ,
                                child: JPChipWithAvatar(
                                  jpChipType: JPChipType.flags,
                                  flagList: job.flags ?? [],)
                            ),

                            Visibility(
                              visible: (job.archived == null || job.archived!.isEmpty) && pageType != PageType.fileListing && pageType != PageType.scheduledListing,
                              child: (job.scheduled?.isNotEmpty ?? false)
                                  || (job.productionBoards?.isNotEmpty ?? false)
                                  || (job.flags?.isNotEmpty ?? false)
                                  ? const SizedBox(height: 15,)
                                  : const SizedBox(height: 8,),
                            ),

                          ],
                        ),
                      ),
                  ]),
                  Visibility(
                    visible: (job.archived == null || job.archived!.isEmpty) && pageType != PageType.fileListing && pageType != PageType.scheduledListing,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ///   call
                            Visibility(
                              visible: job.customer?.phones?.isNotEmpty ?? false,
                              child: JPButton(
                                text: 'call'.tr.toUpperCase(),
                                type: JPButtonType.outline,
                                size: JPButtonSize.extraSmall,
                                onPressed: () {
                                  if(job.customer != null
                                      && job.customer!.phones != null
                                      && job.customer!.phones!.isNotEmpty) {
                                    SaveCallLogHelper.saveCallLogs(
                                        CallLogCaptureModel(
                                            customerId: job.customerId,
                                            phoneNumber: job.customer!.phones![0].number!,
                                            phoneLabel: job.customer!.phones![0].label.toString()
                                        )
                                    );
                                  }
                                },
                              ),
                            ),

                            Visibility(visible: job.customer?.phones?.isNotEmpty ?? false, child: space()),
                            ///   desc
                            Visibility(
                              visible: !AuthService.isPrimeSubUser(),
                              child: InkWell(
                                onLongPress: (){},
                                child: JPButton(
                                  textSize: JPTextSize.heading1,
                                  text: 'desc'.tr.toUpperCase(),
                                  type: JPButtonType.outline,
                                  size: JPButtonSize.extraSmall,
                                  onPressed: () => openDescDialog!(job: job, index: index),
                                ),
                              ),
                            ),
                            Visibility(visible: job.addressString?.isNotEmpty ?? false, child: space()),
                            ///   Map
                            Visibility(
                              visible: job.addressString?.isNotEmpty ?? false,
                              child: InkWell(
                                onLongPress: (){},
                                child: JPButton(
                                  textSize: JPTextSize.heading1,
                                  text: 'map'.tr.toUpperCase(),
                                  type: JPButtonType.outline,
                                  size: JPButtonSize.extraSmall,
                                  onPressed: () => LocationHelper.openMapBottomSheet(query: job.addressString.toString()),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ///   Distance
                        Visibility(
                          visible: (job.distance?.isNotEmpty ?? false) && (UserPreferences.hasNearByAccess ?? false),
                          child: JPText(
                            text:
                            "${JobFinancialHelper.getRoundOff((num.tryParse(job.distance ?? "0") ?? 0), fractionDigits: 2)} mi",
                            textSize: JPTextSize.heading4,
                            textColor: JPAppTheme.themeColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
              ]),
              Positioned(
                top: 0, right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                    ///   job count
                    isLoadingMetaData ?? false
                        ? Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Shimmer.fromColors(
                        baseColor: JPAppTheme.themeColors.dimGray,
                        highlightColor: JPAppTheme.themeColors.inverse,
                        child: SizedBox(
                          height: 26,
                          child: JPLabel(
                            backgroundColor: JPAppTheme.themeColors.primary,
                            text: ' ',
                          ),
                        ),
                      ),
                    )
                        : Visibility(
                      visible: ((job.projectCount ?? 0) != 0) && pageType != PageType.scheduledListing,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: JPButton(
                          onLongPress: () {},
                          onPressed: () => onProjectCountPressed!(index: index!),
                          text: (job.projectCount ?? 0) <= 1 ? '${job.projectCount ?? 0} ${"project".tr.toUpperCase()}' : '${job.projectCount!} ${"projects".tr.toUpperCase()}' ,
                          type: JPButtonType.solid,
                          colorType: JPButtonColorType.primary,
                          size: JPButtonSize.extraSmall,
                        ),
                      ),
                    ),

                    if(job.currentStage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: JPAvatar(
                            size: JPAvatarSize.small,
                            backgroundColor: WorkFlowStageConstants.colors[job.currentStage?.color],
                            child: JPText(
                              text: job.currentStage!.initial!,
                              textColor: JPAppTheme.themeColors.base,
                            )
                        ),
                      ),

                    if(job.followUpStatus != null && (job.followUpStatus?.taskId == null || job.followUpStatus!.taskId!.isEmpty))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: JPAvatar(
                            size: JPAvatarSize.small,
                            backgroundColor: FollowUpsNotesConstants.followupLabelColors[job.followUpStatus!.mark],
                            child: JPText(
                              text: job.followUpStatus!.order.toString(),
                              textColor: JPAppTheme.themeColors.base,
                            )
                        ),
                      ),

                    if(job.followUpStatus?.taskId?.isNotEmpty ?? false)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: JPAvatar(
                            backgroundColor: FollowUpsNotesConstants.followupLabelColors[job.followUpStatus!.mark],
                            size: JPAvatarSize.small,
                            child: JPIcon(Icons.task_alt_outlined, color: JPAppTheme.themeColors.base, size: 18)
                        ),
                      ),

                    CustomerJobSourceTypeContent(sourceType: job.sourceType,),

                    if(job.wpJob?.toString() == "1" &&  job.wpJob?.toString() == "0")
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: JPAvatar(
                            size: JPAvatarSize.small,
                            backgroundColor: JPAppTheme.themeColors.base,
                            borderWidth: 1,
                            child: SvgPicture.asset(AssetsFiles.wordpressIcon)
                        ),
                      ),
                    QuickBookIcon(
                        status: job.quickbookSyncStatus,
                        origin: job.origin,
                        isSyncDisable: job.customer!.isDisableQboSync? 1 : 0,
                        qbDesktopId: job.qbDesktopId,
                        quickbookId: job.quickbookId
                    ),
                  ],
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget space() => const SizedBox(
    height: 5,
    width: 5,
  );

  String getLastModifiedDate() {
    final parsedDate = DateTime.tryParse(job.updatedAt ?? '');
    if (!Helper.isValueNullOrEmpty(parsedDate)) {
      bool isOneDayDifference = (DateTime.now().difference(parsedDate!)).abs().inDays == 1;
      if (isOneDayDifference) {
        return DateTimeHelper.formatDate(job.updatedAt.toString(), DateFormatConstants.dateOnlyFormat);
      } else {
        return DateTimeHelper.formatDate(job.updatedAt.toString(), 'am_time_ago');
      }
    }
    return '';
  }
}