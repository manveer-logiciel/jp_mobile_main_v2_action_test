import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/enums/appointment_form_type.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/appointment/appointment_param.dart';
import 'package:jobprogress/common/models/appointment/appointment_result/appointment_result_options.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/sql/user/user_param.dart';
import 'package:jobprogress/common/models/sql/user/user_response.dart';
import 'package:jobprogress/common/repositories/appointment.dart';
import 'package:jobprogress/common/repositories/company_settings.dart';
import 'package:jobprogress/common/repositories/sql/user.dart';
import 'package:jobprogress/common/services/appointment/quick_actions.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/appointment.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AppointmentListingController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  
  bool isLoading = true;
  bool isLoadMore = false;
  bool canShowLoadMore = false;

  List<UserModel> userList = [];
  List<AppointmentModel> appointmentList = [];
  List<AppointmentResultOptionsModel> appointmentResultList = [];

  int appointmentListOfTotalLength = 0;

  String? selectedFilterId;

  bool isCustomerAppointments = Get.arguments?[NavigationParams.customerId] != null;
  int? customerId = Get.arguments?[NavigationParams.customerId];

  AppointmentListingParamModel paramKeys = AppointmentListingParamModel();

  List<JPSingleSelectModel> sortByList = [
    JPSingleSelectModel(id: 'start_date_time', label: "start_date".tr),
    JPSingleSelectModel(id: 'end_date_time', label: "end_date".tr),
    JPSingleSelectModel(id: 'created_at', label: "created_date".tr),
  ];

  List<JPSingleSelectModel> filterByList = [
    JPSingleSelectModel(id: 'upcoming', label: "upcoming".tr),
    JPSingleSelectModel(id: 'past', label: "past".tr),
  ];

  Map<String, dynamic> getQueryParams() {

     Map<String, dynamic> params = {
      'includes[0]': ['created_by'],
      'includes[1]': ['attachments'],
      'includes[2]': ['jobs'],
      'includes[3]': ['attendees'],
      'includes[4]': ['customer'],
      'includes[5]': ['reminders'],
    };

    if(isCustomerAppointments) {
      params['customer_id'] = customerId.toString();
      params['duration'] = selectedFilterId ?? AppointmentConstants.upcoming;
    } else {
      paramKeys.canSelectOtherUser = canSelectAllUsers();
      if(!paramKeys.canSelectOtherUser!) {
        paramKeys.assignedTo = [AuthService.userDetails!.id.toString()];
      }

      if(!Helper.isValueNullOrEmpty(paramKeys.assignedTo)){
        paramKeys.resultFor = 'users';
      }

      if(!Helper.isValueNullOrEmpty(paramKeys.appointmentResultOption)){
        paramKeys.resultFor = 'results';
      } 

      params.addAll(paramKeys.toJson());
      params.removeWhere((key, value) => value == null);

      if(!Helper.isValueNullOrEmpty(params['date_range_type']) && params['duration'] != AppointmentConstants.upcoming){
        for (int i = 0; i < params['date_range_type'].length; i++) {
          params['date_range_type[$i]'] = params['date_range_type'][i];
        }
      }

      if(!Helper.isValueNullOrEmpty(params['users'])) {
        for (int i = 0; i < params['users'].length; i++) {
          params['users[$i]'] = params['users'][i];
        }
      }

      params.remove('date_range_type');
      params.remove('users');
    }
    return params;
  }

  void openFilterBy() {
    SingleSelectHelper.openSingleSelect(
      filterByList,
      selectedFilterId ?? filterByList[0].id,
      'filter_by'.tr, (value) {
        setSelectedFilterIdAndFetch(value);
      },
      isFilterSheet: true
    );
  }

  Future<void> setSelectedFilterIdAndFetch(String value) async {
    selectedFilterId = value;
    paramKeys.page = 1;
    isLoading = true;
    update();
    Get.back();
    await fetchAppointmentList();
  }
      

  void setPreservedFilter() {
    dynamic preservedFilter = CompanySettingsService.getCompanySettingByKey(
        CompanySettingConstants.appointmentListingFilterMobile,
        onlyValue: true,
    );
    preservedFilter = preservedFilter is Map<String, dynamic> ? preservedFilter : <String, dynamic>{};
    paramKeys = AppointmentListingParamModel.fromJson(preservedFilter);
  }

  Future<void> fetchAppointmentList() async {
    try {
      final appointmentResultParams = getQueryParams();
   
      Map<String, dynamic> response = await AppointmentRepository().fetchReportAppointmentsList(appointmentResultParams);
      setAppointmentList(response);
    } catch (e) {
      rethrow;
    } finally {
      isLoadMore = false;
      isLoading = false;
      update();
    }
  }

  void setAppointmentList(Map<String, dynamic> response) {
    List<AppointmentModel> list = response['list'];

    PaginationModel pagination = response['pagination'];

    appointmentListOfTotalLength = pagination.total!;

    if (!isLoadMore) {
      appointmentList = [];
    }

    appointmentList.addAll(list);

    canShowLoadMore = appointmentList.length < appointmentListOfTotalLength;
  }

  Future<void> loadMore() async {
    paramKeys.page += 1;
    isLoadMore = true;
    await fetchAppointmentList();
  }

  /// showLoading is used to show shimmer if refresh is pressed from main drawer
  Future<void> refreshList({bool? showLoading}) async {
    paramKeys.page = 1;

  /// show shimmer if showLoading = true
    isLoading = showLoading ?? false;
    update();
    await fetchAppointmentList();
  }

  Future<void> saveAppointmentFilter() async {
    paramKeys.page = 1;
    isLoading = true;
    update();
    saveFilters();
    await fetchAppointmentList().trackSortFilterEvents();
  }

  void sortAppointmentListing() async { 
    paramKeys.sortOrder = paramKeys.sortOrder == 'desc' ? 'asc' : 'desc';
    await saveAppointmentFilter();
  }
    
  void applySortByFilters(String sortBy) async { 
    paramKeys.sortBy = sortBy;
    Get.back();
    await saveAppointmentFilter();
  }

   /////////////////////////////   FILTER LIST   ////////////////////////////////

  void applyFilters(AppointmentListingParamModel params) async {
    paramKeys = params;
    await saveAppointmentFilter();
  }


  Future<void> saveFilters() async {
    try {
      dynamic preservedFilter = CompanySettingsService.getCompanySettingByKey(
        CompanySettingConstants.appointmentListingFilterMobile,
        onlyValue: false
      );
      // Creating settings for the first time
      if (preservedFilter is bool || preservedFilter == null) {
        preservedFilter = {
          "name": CompanySettingConstants.appointmentListingFilterMobile,
          "key": CompanySettingConstants.appointmentListingFilterMobile,
          "user_id": AuthService.userDetails?.id,
          "company_id": AuthService.userDetails?.companyDetails?.id
        };
      }
      // updating the filter keys
      preservedFilter['value'] = jsonEncode(paramKeys.toFilterJson());
      await CompanySettingRepository.saveSettings(preservedFilter);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getAllUser() async {
    UserParamModel requestParams = UserParamModel(
      includes: ['tags', 'divisions'], 
      limit: 0, 
      onlySub: AuthService.isPrimeSubUser(),
      withSubContractorPrime: true,
      );

    UserResponseModel userResponse = await SqlUserRepository().get(params: requestParams);

    userResponse.data.insert(0, UserModel.unAssignedUser);

    userList = userResponse.data;
  }

  Future<void> fetchAppointmentResults() async {
    try {
      final appointmentsResult = <String, dynamic>{ 'limit' : 0 };

      Map<String, dynamic> response = await AppointmentRepository().fetchAppointmentResultsOptions(appointmentsResult);
      List<AppointmentResultOptionsModel> list = response['list'];

      appointmentResultList.addAll(list);

    } catch (e) {
      rethrow;
    }
  }

  void handleAppointmentQuickActionUpdate(AppointmentModel task, String action,
    {String? actionFrom}) {
    int index = appointmentList.indexWhere((element) => element.id == task.id);
    switch (action) {
      case 'delete':
        appointmentList.removeAt(index);
        break;
      case 'view':
        navigateToAppointmentDetails(index);
        break;   
      case 'edit':
        refreshList(showLoading: true);
        break;
      default:
    }

    update();
  }


  Future<void> navigateToAppointmentDetails(int i) async {
    final response = await Get.toNamed(
      Routes.appointmentDetails,
      arguments: {
        'appointment_id' : appointmentList[i].id
      },
    );

    if(response != null && response['action'] != null) {
      handleAppointmentQuickActionUpdate(appointmentList[i], response['action']);
    } else if(response?['appointment'] != null){

      Timer(const Duration(milliseconds: 300), () {
        appointmentList[i] = response['appointment'];
        update();
      });
    } else if(response != null && response["status"]){
      refreshList(showLoading: true);
    } else {
      Timer(const Duration(milliseconds: 300), () {
        update();
      });
    }
  }

  // Navigate to create appointment page
  Future<void> navigateToCreateAppointment() async{
    final result = await Get.toNamed(Routes.createAppointmentForm,arguments: {
      NavigationParams.pageType:  AppointmentFormType.createForm,
    });

    if(result != null) {
      refreshList(showLoading: true);
    }
  }
  
  void openQuickActions(AppointmentModel appointment) {
    AppointmentService.openQuickActions(appointment, handleAppointmentQuickActionUpdate);
  }

  bool canSelectAllUsers() {
    if(AuthService.isPrimeSubUser()) {
      return false;
    } else if(AuthService.isStandardUser()) {
      return (!AuthService.isRestricted
          || PermissionService.hasUserPermissions([PermissionConstants.viewAllUserCalendar]));
    } else {
      return true;
    }
  }

  @override
  void onInit() {
    super.onInit();
    setPreservedFilter();
    fetchAppointmentList();
    getAllUser();
    fetchAppointmentResults();
  }
}
