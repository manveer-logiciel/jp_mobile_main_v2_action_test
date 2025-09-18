import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/jpchip_type.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/email_button_type.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/email_button/index.dart';
import 'package:jobprogress/global_widgets/feature_flag/index.dart';
import 'package:jobprogress/global_widgets/from_launch_darkly/index.dart';
import 'package:jobprogress/global_widgets/has_permission/index.dart';
import 'package:jobprogress/global_widgets/job_contact_person/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../common/models/job/job.dart';
import '../../../../common/services/auth.dart';
import '../../../../core/constants/work_flow_stage_color.dart';
import '../../../../global_widgets/chip_with_avatar/index.dart';
import '../../../../global_widgets/custom_fields/index.dart';
import '../../../../global_widgets/custom_material_card/index.dart';
import '../../../../global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import '../../../../global_widgets/safearea/safearea.dart';
import '../../job_summary/widgets/details/job_info/job_description_button.dart';
import 'detail_tile.dart';

class JobScreenBody extends StatelessWidget {

  const JobScreenBody({
    super.key,
    required this.jobModel,
    this.addFlagCallback,
    required this.emailCount,
    this.launchMapCallback,
    this.navigateToJobListingScreen,
    this.spaceBtwContactPersonNdDescriptionTile,
    this.spaceBtwDescriptionNdCustomerAddressTile,
    this.spaceBtwCustomerAddressNdJobContractTile,
    this.handleDeliveryDateActions,
    this.handleMaterialPOActions,
    this.handleDurationActions,
    this.onTapAdditionalFlags,
    this.handleEditJobNameActions,
    this.navigateToAddScreen,
    this.navigateToEditScreen,
    this.navigateToEditCustomerScreen,
    this.handlePhoneAction, 
    this.handleJobContractSignedActions,
    this.handleJobCompletionDateActions, 
    this.updateScreen,
    this.handleEditJobDescription,
    this.handleEditWorkCrew,
    this.handleEditCategory,
    this.handleEditJobDivisionActions
  });

  final JobModel jobModel;
  final int emailCount;
  final void Function()? addFlagCallback;
  final void Function()? launchMapCallback;
  final void Function({int customerID})? navigateToJobListingScreen;
  final void Function()? navigateToAddScreen;
  final void Function()? navigateToEditScreen;
  final bool Function()? spaceBtwContactPersonNdDescriptionTile;
  final bool Function()? spaceBtwDescriptionNdCustomerAddressTile;
  final bool Function()? spaceBtwCustomerAddressNdJobContractTile;
  final Function(int, String)? handleDeliveryDateActions;
  final Function(int,String)? handleMaterialPOActions;
  final Function(int,String)? handleDurationActions;
  final Function(int,String)? handleEditJobNameActions;
  final Function(int,String?)? handleJobContractSignedActions;
  final Function(int,String?)? handleJobCompletionDateActions;
  final Function(String)? onTapAdditionalFlags;
  final VoidCallback? navigateToEditCustomerScreen;
  final VoidCallback? handlePhoneAction;
  final VoidCallback? updateScreen;
  final VoidCallback? handleEditJobDescription;
  final VoidCallback? handleEditWorkCrew;
  final VoidCallback? handleEditCategory;
  final VoidCallback? handleEditJobDivisionActions;

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      top: false,
      containerDecoration: BoxDecoration(
          color: JPAppTheme.themeColors.inverse
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              const SizedBox(height: 20,),
              ///   Name,
              CustomMaterialCard(
                child: Column(
                  children: [
                    ///   customer name, organisation name, job count
                    Padding(
                      padding: EdgeInsets.fromLTRB(16,
                        20 + (jobModel.tradesString.isNotEmpty
                            ? 0
                            : TextHelper.getTextSize(JPTextSize.heading1)/2),
                        16,
                        20 + (jobModel.tradesString.isNotEmpty
                            ? 0
                            : TextHelper.getTextSize(JPTextSize.heading1)/2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  JobNameWithCompanySetting(
                                    job: jobModel,
                                    textSize: JPTextSize.heading1,
                                    fontWeight: JPFontWeight.medium,
                                    overflow: TextOverflow.visible,
                                    enableMultiLine: true,
                                    isEdit: !AuthService.isPrimeSubUser(),
                                    onTapEdit: navigateToEditCustomerScreen,
                                  ),
                                  ///   customer name
                                  Visibility(
                                      visible: jobModel.tradesString.isNotEmpty,
                                      child: const SizedBox(height: 7,)),
                                  ///   organisation name
                                  if(jobModel.tradesString.isNotEmpty)
                                    JPText(
                                      text: jobModel.tradesString,
                                      textColor: JPAppTheme.themeColors.tertiary,
                                      textAlign: TextAlign.start,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: JPColor.dimGray,),
                    ///   Phone, Email, Map, Add job, Edit job
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ///   phone
                                iconButton(
                                  iconData: Icons.phone,
                                  buttonLabel: "phone".tr,
                                  labelColor: jobModel.customer?.phones == null ? JPAppTheme.themeColors.lightBlue : JPAppTheme.themeColors.primary,
                                  onTap: handlePhoneAction,
                                ),
                                // email
                                JPEmailButton(
                                  type:EmailButtonType.iconWithText,
                                  jobId: jobModel.id,
                                  customerId: jobModel.customerId,
                                  actionFrom: 'job_detail',
                                ),
                                ///   map
                                iconButton(
                                  iconData: Icons.location_on,
                                  buttonLabel: "map".tr,
                                  labelColor: (jobModel.addressString?.isEmpty ?? true) ? JPAppTheme.themeColors.lightBlue : JPAppTheme.themeColors.primary,
                                  onTap: (jobModel.addressString?.isEmpty ?? true) ? null : ()=> launchMapCallback!(),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 32,
                                  height: 32,
                                ),
                                ///   add job/project
                                iconButton(
                                  iconData: Icons.add,
                                  buttonLabel: (jobModel.isProject ?? false) ? "add_project".tr : "addJob".tr,
                                  labelColor: AuthService.isPrimeSubUser() ? JPAppTheme.themeColors.lightBlue : JPAppTheme.themeColors.primary,
                                  onTap: AuthService.isPrimeSubUser() ? null : navigateToAddScreen,
                                ),
                                ///   edit job/project
                                iconButton(
                                  iconData: Icons.edit_outlined,
                                  buttonLabel: (jobModel.isProject ?? false) ? "edit_project".tr : "edit_job".tr,
                                  labelColor: AuthService.isPrimeSubUser() ? JPAppTheme.themeColors.lightBlue : JPAppTheme.themeColors.primary,
                                  onTap: AuthService.isPrimeSubUser() ? null : navigateToEditScreen,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              /// Flags
              CustomMaterialCard(
                child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///   Label
                      JPText(
                        text: "flags".tr,
                        textAlign: TextAlign.start,
                        textSize: JPTextSize.heading5,
                        textColor: JPAppTheme.themeColors.tertiary,
                      ),
                      ///   Tags
                      JPChipWithAvatar(
                        jpChipType: JPChipType.flagsWithAddMoreButton,
                        flagList: jobModel.flags ?? [],
                        addCallback: addFlagCallback,
                      ),
                      if((jobModel.scheduled?.isNotEmpty ?? false) || (jobModel.productionBoards?.isNotEmpty ?? false))...{
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          color: JPAppTheme.themeColors.dimGray,
                          height: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: JPText(
                            text: 'actions'.tr,
                            textAlign: TextAlign.start,
                            textSize: JPTextSize.heading5,
                            textColor: JPAppTheme.themeColors.tertiary,
                          ),
                        ),
                        Wrap(
                          runSpacing: 5,
                          spacing: 5,
                          children: [
                            ///  Email Recurring
                            if(emailCount != 0)
                              JobDetailButton(
                                text: '${'email'.tr.capitalize!} ${'recurring'.tr.capitalize!} ($emailCount)',
                                onTapDescription: () => onTapAdditionalFlags!("email_recurring"),
                                prefixIcon: Icons.schedule_send_outlined,
                              ),
                            ///   Job scheduled
                            if(jobModel.scheduled?.isNotEmpty ?? false)
                              JobDetailButton(
                                text: jobModel.scheduled ?? "",
                                onTapDescription: () =>  onTapAdditionalFlags!("job_scheduled"),
                                prefixIcon: Icons.calendar_month,
                              ),
                            ///   added to progress board
                            if(jobModel.productionBoards?.isNotEmpty ?? false)
                              HasPermission(
                                permissions: const [PermissionConstants.viewProgressBoard,PermissionConstants.manageProgressBoard],
                                child: Visibility(
                                  visible: !AuthService.isPrimeSubUser(),
                                  child: JobDetailButton(
                                    text: "${"added_in_progress_board".tr} (${(jobModel.productionBoards?.length.toString() ?? "")})",
                                    onTapDescription: () => onTapAdditionalFlags!("progress_board"),
                                    prefixIcon: Icons.wysiwyg,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if((jobModel.scheduled?.isNotEmpty ?? false) || (jobModel.productionBoards?.isNotEmpty ?? false))
                          const SizedBox(height: 5),
                      }
                    ],
                  ),
                ),
              ),
              Visibility(
                  visible: (jobModel.contactPerson?.isNotEmpty ?? false),
                  child: const SizedBox(height: 20,)
              ),
              /// contact person
              Visibility(
                  visible: jobModel.contactPerson?.isNotEmpty ?? false,
                  child: JobContactPerson(
                    updateScreen: updateScreen,
                    job: jobModel, 
                    overflow: TextOverflow.visible)
              ),
              Visibility(
                  visible: spaceBtwContactPersonNdDescriptionTile!(),
                  child: const SizedBox(height: 20,)
              ),
              ///   description
              CustomMaterialCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///   job description
                    JobDetailTile(
                      isVisible: jobModel.description?.isNotEmpty ?? false,
                      label: (jobModel.isProject ?? false) ? "project_description".tr : "job_description".tr,
                      description: jobModel.description ?? "",
                      trailing: !AuthService.isPrimeSubUser() ? JPTextButton(
                        icon: Icons.edit_outlined,
                        color: JPAppTheme.themeColors.primary,
                        iconSize: 16,
                        onPressed: handleEditJobDescription
                      ) : const SizedBox.shrink()
                    ),
                    divider(jobModel.description?.isNotEmpty ?? false,),
                    ///   lead
                    JobDetailTile(
                      isVisible: jobModel.leadNumber?.isNotEmpty ?? false,
                      label: "${"lead".tr} #",
                      description: jobModel.leadNumber ?? "",
                    ),
                    divider(jobModel.leadNumber?.isNotEmpty ?? false,),
                    ///   job
                    JobDetailTile(
                      isVisible: jobModel.altId?.isNotEmpty ?? false,
                      label: "${(Helper.isTrue(jobModel.isProject) ? ('project'.tr.capitalize) : ("job".tr.capitalize)) !} #",
                      description: jobModel.altId ?? "",
                    ),
                    divider(jobModel.altId?.isNotEmpty ?? false,),
                    ///   job name
                    JobDetailTile(
                      isVisible: !(jobModel.isProject ?? false),
                      label: "job_name".tr,
                      description: (jobModel.name ?? "").isEmpty ? '--' : jobModel.name,
                      trailing: AuthService.isPrimeSubUser() ? null : JPTextButton(
                        icon: Icons.edit_outlined,
                        color: JPAppTheme.themeColors.primary,
                        iconSize: 16,
                        onPressed: () {
                          handleEditJobNameActions?.call(jobModel.id,jobModel.name??"");
                        },
                      ),
                    ),
divider(!(jobModel.isProject ?? false)),
                    ///   job division
                    JobDetailTile(
                      isVisible: !(jobModel.isProject ?? false),
                      label: "job_division".tr,
                      description: jobModel.division?.name ?? "--",
                      trailing: AuthService.isPrimeSubUser() ? null : FromLaunchDarkly(
                        flagKey: LDFlagKeyConstants.divisionBasedMultiWorkflows,
                        child: (_) => JPTextButton(
                          icon: Icons.edit_outlined,
                          color: JPAppTheme.themeColors.primary,
                          iconSize: 16,
                          onPressed: handleEditJobDivisionActions,
                        ),
                      ),
                    ),
                    divider(jobModel.division?.name?.isNotEmpty ?? false,),
                    ///   category
                    JobDetailTile(
                      isVisible: !(jobModel.isProject ?? false),
                      label: "category".tr,
                      description: !Helper.isValueNullOrEmpty(jobModel.jobTypesString)? jobModel.jobTypesString : '--',
                      trailing: Row(
                        children: [
                          if(jobModel.jobTypesString == 'Insurance Claim' && jobModel.insurance != 0)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: JPTextButton(
                              onPressed: () =>  Get.toNamed(Routes.insuranceDetails,arguments: {'data':jobModel}),
                              color: JPAppTheme.themeColors.primary,
                              icon: Icons.remove_red_eye,
                              iconSize: 16,
                            ),
                          ),
                          AuthService.isPrimeSubUser() ? const SizedBox.shrink() :
                          JPTextButton(
                            onPressed: handleEditCategory,
                            color: JPAppTheme.themeColors.primary,
                            icon: Icons.edit_outlined,
                            iconSize: 16,
                          ),
                        ],
                      )
                    ),
                    divider(jobModel.jobTypesString?.isNotEmpty ?? false),
                    ///   trade type
                    JobDetailTile(
                      isVisible: jobModel.tradesString.isNotEmpty,
                      label: "trade_type".tr,
                      description: jobModel.tradesString,
                    ),
                    divider(jobModel.tradesString.isNotEmpty,),
                    ///   work types
                    JobDetailTile(
                      isVisible: jobModel.workTypesString?.isNotEmpty ?? false,
                      label: "work_type".tr,
                      description: jobModel.workTypesString ?? "",
                    ),
                    divider(jobModel.workTypesString?.isNotEmpty ?? false),
                    ///   Project stage
                    JobDetailTile(
                      isVisible: jobModel.isProject!,
                      label: "project_stage".tr,
                      description: jobModel.parent?.projectStatus?.status?.name ?? "--",
                    ),
                    divider(jobModel.isProject!),
                    ///   Project Status
                    JobDetailTile(
                      isVisible: jobModel.isProject!,
                      label: "project_status".tr,
                      description: (jobModel.isAwarded ?? false) ?  "awarded".tr  : "not_awarded".tr,
                    ),
                    divider(jobModel.isProject!),
                    ///   duration
                    JobDetailTile(
                      isVisible: true,
                      label: jobModel.isProject! ? "project_duration".tr : "job_duration".tr,
                      description: (jobModel.duration ?? '').isNotEmpty ? jobModel.duration : '--',
                      trailing: AuthService.isPrimeSubUser() ? null : JPTextButton(
                        icon: Icons.edit_outlined,
                        color: JPAppTheme.themeColors.primary,
                        iconSize: 16,
                        onPressed: () {
                          handleDurationActions?.call(jobModel.id,jobModel.duration??"");
                        },
                      ),
                    ),
                    divider(true,),
                    ///   total job amount
                    HasPermission(
                      permissions: const [PermissionConstants.manageFinancial, PermissionConstants.viewFinancial],
                      child: JobDetailTile(
                        isVisible: !(jobModel.isProject ?? false) && (jobModel.amount?.isNotEmpty ?? false) && double.tryParse(jobModel.amount!) != 0,
                        label: "total_job_amount".tr,
                        description: JobFinancialHelper.getCurrencyFormattedValue(value: JobFinancialHelper.getTotalPrice(jobModel).toString()),
                      ),
                    ),
                    divider(!(jobModel.isProject ?? false) && (jobModel.amount?.isNotEmpty ?? false) && double.tryParse(jobModel.amount!) != 0),
                  ],
                ),
              ),
              Visibility(
                  visible: spaceBtwDescriptionNdCustomerAddressTile!(),
                  child: const SizedBox(height: 20,)
              ),
              ///   Customer Address
              CustomMaterialCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///   Customer Address
                    JobDetailTile(
                      isVisible: !(jobModel.isProject ?? false) && (jobModel.addressString?.isNotEmpty ?? false),
                      label: "job_address".tr,
                      description: jobModel.addressString ?? "",
                      isDescriptionSelectable: jobModel.addressString?.isNotEmpty ?? false,
                      trailing: JPTextButton(
                        onPressed: ()=> (jobModel.addressString == null ) ? null : launchMapCallback!(),
                        color: JPAppTheme.themeColors.primary,
                        icon: Icons.location_on,
                        iconSize: 24,
                      ),
                    ),
                    divider(!(jobModel.isProject ?? false) && (jobModel.addressString?.isNotEmpty ?? false)),
                    ///   stage
                    JobDetailTile(
                      isVisible: jobModel.currentStage?.name.isNotEmpty ?? false,
                      label: jobModel.isProject! ? "parent_job_stage".tr : "current_stage".tr.capitalize,
                      description: jobModel.currentStage?.name ?? "",
                      descriptionColor: WorkFlowStageConstants.colors[jobModel.currentStage!.color],
                    ),
                    divider(jobModel.currentStage?.name.isNotEmpty ?? false),

                    ///   in stage
                    JobDetailTile(
                      isVisible: jobModel.jobWorkflow?.stageLastModified?.isNotEmpty ?? false,
                      label: "in_stage_since".tr,
                      description: jobModel.jobWorkflow?.stageLastModified ?? "",
                    ),

                    divider(jobModel.jobWorkflow?.stageLastModified?.isNotEmpty ?? false),

                    ///   job_rep_estimator
                    Visibility(
                      visible: jobModel.estimators?.isNotEmpty ?? false,
                      child: Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///   Label
                            JPText(
                              text: jobModel.isProject! ? 'project_rep_estimator'.tr : "job_rep_estimator".tr,
                              textAlign: TextAlign.start,
                              textSize: JPTextSize.heading5,
                              textColor: JPAppTheme.themeColors.tertiary,
                            ),
                            const SizedBox(height: 10,),
                            ///   Tags
                            JPChipWithAvatar(
                              jpChipType: JPChipType.userWithMoreButton,
                              userLimitedModelList: jobModel.estimators ?? [],
                            ),
                          ],
                        ),
                      ),
                    ),
                    divider(jobModel.estimators?.isNotEmpty ?? false),
                    ///   work_crew
                    HasFeatureAllowed(
                      feature: const [FeatureFlagConstant.production],
                      child: Visibility(
                        visible: jobModel.workCrew?.isNotEmpty ?? false,
                        child: Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///   Label
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  JPText(
                                    text: "work_crew".tr,
                                    textAlign: TextAlign.start,
                                    textSize: JPTextSize.heading5,
                                    textColor: JPAppTheme.themeColors.tertiary,
                                  ),
                                  JPTextButton(
                                    icon: Icons.edit_outlined,
                                    color: JPAppTheme.themeColors.primary,
                                    iconSize: 16,
                                    onPressed: handleEditWorkCrew
                                  )
                                ],
                              ),
                              const SizedBox(height: 10,),
                              ///   Tags
                              JPChipWithAvatar(
                                jpChipType: JPChipType.userWithMoreButton,
                                userLimitedModelList: jobModel.workCrew,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    FromLaunchDarkly(
                      flagKey: LDFlagKeyConstants.jobCanvaser,
                      child: (_) => Visibility(
                        visible: !Helper.isValueNullOrEmpty(jobModel.canvasser) || 
                          !Helper.isValueNullOrEmpty(jobModel.canvasserString),
                        child: Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Label
                              JPText(
                                text: "canvasser".tr,
                                textAlign: TextAlign.start,
                                textSize: JPTextSize.heading5,
                                textColor: JPAppTheme.themeColors.tertiary,
                              ),
                              const SizedBox(height: 10),
                              ///   Tags
                              if(jobModel.canvasser != null)
                              JPChipWithAvatar(
                                jpChipType: JPChipType.userWithMoreButton,
                                userLimitedModelList: [jobModel.canvasser!],
                              ),
                              if(jobModel.canvasser == null)
                              JPText(
                                text: jobModel.canvasserString ?? "",
                                textSize: JPTextSize.heading4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
              Visibility(
                  visible: spaceBtwCustomerAddressNdJobContractTile!(),
                  child: const SizedBox(height: 20,)
              ),
              /// Custom Fields
              Visibility(
                visible: jobModel.customFields?.isNotEmpty ?? false,
                child: CustomMaterialCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: JPText(
                            text: "custom_fields".tr.toUpperCase(),
                            textAlign: TextAlign.start,
                            textSize: JPTextSize.heading5,
                            textColor: JPAppTheme.themeColors.darkGray,
                            fontWeight: JPFontWeight.medium,
                          ),
                        ),
                        CustomFields(customFields: jobModel.customFields ?? [],),
                      ],
                    )
                ),
              ),
              Visibility(
                  visible: jobModel.customFields?.isNotEmpty ?? false,
                  child: const SizedBox(height: 20,)
              ),
              ///   job contract
              CustomMaterialCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///   job contract
                    JobDetailTile(
                      isVisible: true,
                      doShowCancelIcon: !Helper.isValueNullOrEmpty(jobModel.contractSignedDate),
                      label: jobModel.isProject! ? "project_contract_signed_date".tr : "job_contract_signed_date".tr,
                      description: Helper.isValueNullOrEmpty(jobModel.contractSignedDate) ?  "--" : jobModel.contractSignedDate,
                      trailing: AuthService.isPrimeSubUser() ? null : JPTextButton(
                        icon: Icons.edit_outlined,
                        color: JPAppTheme.themeColors.primary,
                        iconSize: 16,
                        onPressed: () {
                          handleJobContractSignedActions?.call(jobModel.id, jobModel.contractSignedDate ?? "");
                        },
                      ),
                      onTapCancel: () {
                        handleJobContractSignedActions?.call(jobModel.id, null);
                      }
                    ),
                    divider(true),
                    ///   job_completion
                    JobDetailTile(
                      isVisible: true,
                      doShowCancelIcon: !Helper.isValueNullOrEmpty(jobModel.completionDate),
                      label: jobModel.isProject! ? "project_completion_date".tr : "job_completion_date".tr,
                      description:Helper.isValueNullOrEmpty(jobModel.completionDate) ? '--' :  jobModel.completionDate,
                      trailing: AuthService.isPrimeSubUser() ? null : JPTextButton(
                        icon: Icons.edit_outlined,
                        color: JPAppTheme.themeColors.primary,
                        iconSize: 16,
                        onPressed: () {
                          handleJobCompletionDateActions?.call(jobModel.id,jobModel.completionDate??"");
                        },
                      ),
                      onTapCancel: () {
                        handleJobCompletionDateActions?.call(jobModel.id, null);
                      },
                    ),
                    divider(true),

                    divider(jobModel.purchaseOrderNumber?.isNotEmpty ?? false),
                    ///   material delivery
                    JobDetailTile(
                      isVisible: !jobModel.isMultiJob,
                      label: "material_delivery_date".tr,
                      descriptionWidget: jobModel.deliveryDates?.isEmpty ?? true
                          ? Row(
                        children: [
                          JPTextButton(
                            text: 'tap_here'.tr,
                            color: JPAppTheme.themeColors.primary,
                            padding: 0,
                            textSize: JPTextSize.heading4,
                            onPressed: () {
                              handleDeliveryDateActions!(-1, 'add');
                            },
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          JPText(
                            text: 'to_add_delivery_date'.tr,
                            textColor: JPAppTheme.themeColors.darkGray,
                          ),
                        ],
                      ) : Wrap(
                        runSpacing: 8,
                        spacing: 5,
                        children: List.generate(jobModel.deliveryDates?.length ?? 0, (index) {

                          final deliveryDate = jobModel.deliveryDates?[index];

                          return JPChip(
                            prefixWidget: deliveryDate?.materialId != null
                                ? JPIcon(Icons.link, size: 14, color: JPAppTheme.themeColors.primary,)
                                : null,
                            text: deliveryDate?.deliveryDate ?? "",
                            textSize: JPTextSize.heading5,
                            textPadding: const EdgeInsets.all(3),
                            onTapChip: () {
                              handleDeliveryDateActions!(index, 'update');
                            },
                            removeIconSize: 14,
                            suffixWidget: deliveryDate?.isSrs ?? false ? Image.asset('assets/images/srs_distribution.png', height: 16, width: 16,) : null,
                            onRemove: deliveryDate?.isSrs ?? false ? null : () {
                              handleDeliveryDateActions!(index, 'remove');
                            },
                          );
                        }),
                      ),
                      trailing: JPTextButton(
                        icon: Icons.add,
                        color: JPAppTheme.themeColors.primary,
                        iconSize: 22,
                        onPressed: () {
                          handleDeliveryDateActions!(-1, 'add');
                        },
                      ),
                    ),
                    divider(!jobModel.isMultiJob),
                    ///   material po
                    JobDetailTile(
                      isVisible: !jobModel.isMultiJob,
                      label: "material_po".tr,
                      description: (jobModel.purchaseOrderNumber ?? "").isEmpty?"--":jobModel.purchaseOrderNumber,
                      trailing: AuthService.isPrimeSubUser() ? null : JPTextButton(
                        icon: Icons.edit_outlined,
                        color: JPAppTheme.themeColors.primary,
                        iconSize: 16,
                        onPressed: () {
                          handleMaterialPOActions?.call(jobModel.id,jobModel.purchaseOrderNumber??"");
                        },
                      ),
                    ),
                    divider(!jobModel.isMultiJob),
                    ///   job record
                    JobDetailTile(
                      isVisible: jobModel.jobWorkflow?.createdAt?.isNotEmpty ?? false,
                      label: jobModel.isProject! ? 'project_record_since'.tr : 'job_record_since'.tr,
                      description: jobModel.jobWorkflow?.createdAt ?? "",
                    ),
                    divider(jobModel.jobWorkflow?.createdAt?.isNotEmpty ?? false),
                    ///   last modified
                    JobDetailTile(
                      isVisible:  jobModel.createdAt?.isNotEmpty ?? false,
                      label: "created_at".tr,
                      description:  DateTimeHelper.formatDate(jobModel.createdAt!, DateFormatConstants.dateTimeFormatWithoutSeconds),
                    ),

                    divider(jobModel.createdAt?.isNotEmpty ?? false),
                    ///   last modified
                    JobDetailTile(
                      isVisible:  jobModel.updatedAt?.isNotEmpty ?? false,
                      label: "last_modified".tr,
                      description:  (DateTime.now().difference(DateTime.parse(jobModel.updatedAt ?? '')))
                        .abs()
                        .inDays == 1
                        ? DateTimeHelper.formatDate(jobModel.updatedAt.toString(), 
                            DateFormatConstants.dateOnlyFormat)
                        : DateTimeHelper.formatDate(jobModel.updatedAt.toString(), 'am_time_ago'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20,),

            ],
          ),
        ),
      ),
    );
  }
}

Widget divider(bool dividerVisibility) => Visibility(
    visible: dividerVisibility,
    child: Divider(height: 1, color: JPAppTheme.themeColors.dimGray,)
);

Widget iconButton({IconData? iconData, String? buttonLabel, Color? labelColor, Function()? onTap}) => Expanded(
  child: Material(
    color: JPColor.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8,),
        child: Column(
          children: [
            Icon(iconData, color: labelColor),
            const SizedBox(height: 3,),
            JPText(
              text: buttonLabel!,
              textSize: JPTextSize.heading5,
              textColor: labelColor,
            ),
          ],
        ),
      ),
    ),
  ),
);