import 'package:get/get.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/delivery_service_constant.dart';
import 'package:jobprogress/core/constants/delivery_time_type_constant.dart';
import 'package:jobprogress/core/constants/delivery_type_constant.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/constants/recurring_constant.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class DropdownListConstants {

  bool isProductionFeatureAllowed = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.production]);
  bool isPrimeUser = AuthService.isPrimeSubUser();
  bool hasFinancialPermission = PermissionService.hasUserPermissions([PermissionConstants.manageFinancial, PermissionConstants.viewFinancial]);

  /// [salesProForEstimates] helps to remove the estimate from dropdown
  /// list when [LDFlagKeyConstants.salesProForEstimate] flag is enabled
  static bool get salesProForEstimates => LDService.hasFeatureEnabled(LDFlagKeyConstants.salesProForEstimate);

  static List<JPSingleSelectModel> durationsList = [
    JPSingleSelectModel(label: 'WTD'.tr, id: "WTD"),
    JPSingleSelectModel(label: 'MTD'.tr, id: "MTD"),
    JPSingleSelectModel(label: 'YTD'.tr, id: "YTD"),
    JPSingleSelectModel(label: 'previous_month'.tr, id: "last_month"),
    JPSingleSelectModel(label: 'since_inception'.tr, id: "since_inception"),
    JPSingleSelectModel(label: 'custom'.tr, id: "custom"),
  ];

  List<JPSingleSelectModel> get dataRangeTypeList => [
    JPSingleSelectModel(id: "job_stage_changed_date", label: 'last_moved'.tr,),
    JPSingleSelectModel(id: "job_updated_date", label: 'last_modified'.tr,),
    ...DropdownListConstants().homeFilterDataRangeTypeList,
    JPSingleSelectModel(id: "job_awarded_date", label: 'job_awarded_date'.tr,),
    JPSingleSelectModel(id: "job_completion_date", label: 'job_completion_date'.tr,),
    if(!isPrimeUser && hasFinancialPermission)...{
      JPSingleSelectModel(id: "job_invoiced_date", label: 'job_invoiced_date'.tr,),
    },
    JPSingleSelectModel(id: "contract_signed_date", label: 'contract_signed_date'.tr,),
  ];

  List<JPSingleSelectModel> get homeFilterDataRangeTypeList => [
    JPSingleSelectModel(id: "job_created_date", label: 'job_created_date'.tr,),
    JPSingleSelectModel(id: "job_appointment_date", label: 'job_appointment_date'.tr,),
    if(isProductionFeatureAllowed)
      JPSingleSelectModel(id: "job_schedule_date", label: 'job_schedule_date'.tr,),
  ];

  static List<JPSingleSelectModel> get copyToJobTypeList => [
    if (!salesProForEstimates)
      JPSingleSelectModel(label: "estimates".tr, id: "estimating"),
    JPSingleSelectModel(label: "form_proposals".tr, id: "form_proposals"),
    JPSingleSelectModel(label: "photos_and_documents".tr, id: "photos_and_documents")
  ];

  static List<JPSingleSelectModel> jobStatusList = [
    JPSingleSelectModel(id: "archive", label: "active".tr),
    JPSingleSelectModel(id: "pb_only_archived_jobs", label: "archived".tr),
    JPSingleSelectModel(id: "pb_with_archived_jobs", label: "all".tr)
  ];

  static List<JPSingleSelectModel> nameFilterTypeList = [
    JPSingleSelectModel(id: "name", label: "customer".tr),
    JPSingleSelectModel(id: "company_name", label: "company".tr),
    JPSingleSelectModel(id: "management_company", label: "management_company".tr),
    JPSingleSelectModel(id: "job_contact_person", label: "contact_person".tr.capitalize ?? ""),
    JPSingleSelectModel(id: "property_name", label: "property".tr),
  ];

  static List<JPSingleSelectModel> recurringDurationList = [
    JPSingleSelectModel(label: 'daily'.tr.capitalizeFirst!, id: RecurringConstants.daily),
    JPSingleSelectModel(label: 'weekly'.tr.capitalizeFirst!, id: RecurringConstants.weekly),
    JPSingleSelectModel(label: 'monthly'.tr.capitalizeFirst!, id: RecurringConstants.monthly),
    JPSingleSelectModel(label: 'yearly'.tr.capitalizeFirst!, id: RecurringConstants.yearly),
  ];

  static List<JPSingleSelectModel> updateScheduleTypeList = [
    JPSingleSelectModel(id: "this", label: 'this_schedule'.tr,),
    JPSingleSelectModel(id: "all", label: 'this_and_following_schedule'.tr,),
  ];

  static List<JPSingleSelectModel> updateEventTypeList = [
    JPSingleSelectModel(id: "this", label: 'this_event'.tr,),
    JPSingleSelectModel(id: "all", label: 'this_and_following_event'.tr,),
  ];

  static List<JPSingleSelectModel> productTypeList = [
    JPSingleSelectModel(label: 'single_family'.tr.capitalize!, id: "SF"),
    JPSingleSelectModel(label: 'multi_family'.tr.capitalize!, id: "MF"),
    JPSingleSelectModel(label: 'commercial'.tr.capitalize!, id: "CM"),
  ];

  static List<JPSingleSelectModel> updateAppointmentTypeList = [
    JPSingleSelectModel(id: "only_this", label: 'this_appointment'.tr,),
    JPSingleSelectModel(id: "this_and_following_event", label: 'this_and_following_appointments'.tr,),
    JPSingleSelectModel(id: "all", label: 'all_appointment'.tr,
    ),
  ];

  static List<JPSingleSelectModel> tableCellTextAlignList = [
    JPSingleSelectModel(id: "start", label: 'start'.tr,),
    JPSingleSelectModel(id: "center", label: 'center'.tr,),
    JPSingleSelectModel(id: "right", label: 'right'.tr,
    ),
  ];

  static List<JPSingleSelectModel> tableCellVerticalAlignList = [
    JPSingleSelectModel(id: "top", label: 'top'.tr,),
    JPSingleSelectModel(id: "middle", label: 'middle'.tr,),
    JPSingleSelectModel(id: "bottom", label: 'bottom'.tr,
    ),
  ];

  static List<JPSingleSelectModel> saveWithOrWithoutInvoice = [
    JPSingleSelectModel(id: "with_invoice", label: 'save_with_invoice'.tr,),
    JPSingleSelectModel(id: "without_invoice", label: 'save_without_invoice'.tr,),
  ];

  static List<JPSingleSelectModel> updateWithOrWithoutInvoice = [
    JPSingleSelectModel(id: "with_invoice", label: 'update_with_invoice'.tr,),
    JPSingleSelectModel(id: "without_invoice", label: 'update_without_invoice'.tr,),
  ];

  static List<JPSingleSelectModel> hoverDeliverables = [
    JPSingleSelectModel(id: '2', label: 'roof_only'.tr),
    JPSingleSelectModel(id: '3', label: 'complete'.tr),
    JPSingleSelectModel(id: '1', label: 'hover_now'.tr)
  ];

  static List<JPSingleSelectModel> jobProjectList = [
    JPSingleSelectModel(id: 'job', label: '${ 'job'.tr.capitalize } #'),
    JPSingleSelectModel(id: 'project', label: '${ 'project'.tr.capitalize } #')
  ];

  static List<JPSingleSelectModel> jobProjectIdList = [
    JPSingleSelectModel(id: 'job_id', label: '${ 'job_id'.tr.capitalize }'),
    JPSingleSelectModel(id: 'project_id', label: '${ 'project_id'.tr.capitalize }')
  ];

  static List<JPSingleSelectModel> templateTypeList = [
    JPSingleSelectModel(id: 'estimate', label: '${'handwritten_template'.tr.capitalize }'),
    JPSingleSelectModel(id: 'proposal', label: '${'form_proposal_template'.tr.capitalize }')
  ];

  static List<JPSingleSelectModel> beaconOrderPickUpTypes = [
    JPSingleSelectModel(id: '8 am', label: '8 AM'),
    JPSingleSelectModel(id: '9 am', label: '9 AM'),
    JPSingleSelectModel(id: '10 am', label: '10 AM'),
    JPSingleSelectModel(id: '11 am', label: '11 AM'),
    JPSingleSelectModel(id: '12 pm', label: '12 PM'),
    JPSingleSelectModel(id: '1 pm', label: '1 PM'),
    JPSingleSelectModel(id: '2 pm', label: '2 PM'),
    JPSingleSelectModel(id: '3 pm', label: '3 PM'),
    JPSingleSelectModel(id: '4 pm', label: '4 PM'),
  ];

  static List<JPSingleSelectModel> beaconOrderDeliveryTypes = [
    JPSingleSelectModel(id: 'morning'.tr, label: 'morning'.tr),
    JPSingleSelectModel(id: 'afternoon'.tr, label: 'afternoon'.tr),
    JPSingleSelectModel(id: 'anytime'.tr, label: 'anytime'.tr),
    JPSingleSelectModel(id: 'special_request'.tr, label: 'special_request'.tr),
  ];

  static List<JPSingleSelectModel> deliveryServices = [
    JPSingleSelectModel(id: DeliveryServiceConstant.deliveryCode, label: 'delivery'.tr),
    JPSingleSelectModel(id: DeliveryServiceConstant.willCallCode, label: 'will_call'.tr),
    JPSingleSelectModel(id: DeliveryServiceConstant.expressPickupCode, label: 'express_pickup'.tr)
  ];

  static List<JPSingleSelectModel> abcOrderDeliveryTypes = [
    JPSingleSelectModel(id: DeliveryTypeConstant.otgCode, label: 'ground_drop'.tr),
    JPSingleSelectModel(id: DeliveryTypeConstant.otrCode, label: 'roof_top'.tr)
  ];

  static List<JPSingleSelectModel> abcRequestedDeliveryTimes = [
    JPSingleSelectModel(id: DeliveryTimeTypeConstant.anytime, label: 'anytime'.tr),
    JPSingleSelectModel(id: DeliveryTimeTypeConstant.am, label: 'am'.tr),
    JPSingleSelectModel(id: DeliveryTimeTypeConstant.pm, label: 'pm'.tr),
    JPSingleSelectModel(id: DeliveryTimeTypeConstant.specificTime, label: 'specific_time'.tr),
    JPSingleSelectModel(id: DeliveryTimeTypeConstant.timeRange, label: 'time_range'.tr)
  ];

  static List<JPSingleSelectModel> srsRequestedDeliveryTimes = [
    JPSingleSelectModel(id: DeliveryTimeTypeConstant.am, label: 'am'.tr),
    JPSingleSelectModel(id: DeliveryTimeTypeConstant.pm, label: 'pm'.tr),
    JPSingleSelectModel(id: DeliveryTimeTypeConstant.anytime, label: 'anytime'.tr)
  ];
}
