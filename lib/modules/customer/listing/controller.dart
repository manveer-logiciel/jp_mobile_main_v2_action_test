import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/appointment_form_type.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/models/email/profile_detail.dart';
import 'package:jobprogress/common/services/user_preferences.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/consent_status_constants.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/enums/file_listing.dart';
import '../../../common/models/appointment/appointment.dart';
import '../../../common/models/customer/customer.dart';
import '../../../common/models/customer_list/customer_listing_filter.dart';
import '../../../common/models/sql/state/state.dart';
import '../../../common/models/sql/user/user.dart';
import '../../../common/repositories/customer_listing.dart';
import '../../../common/services/customer/quick_action_helper.dart';
import '../../../common/services/location/loaction_service.dart';
import '../../../routes/pages.dart';

class CustomerListingController extends GetxController {

  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = true;
  bool isLoadMore = false;
  bool canShowLoadMore = false;
  bool isDeleting = false;
  bool hasNearByJobAccess = true;
  bool isMetaDataLoaded = false;
  bool? enableMasking;

  List<CustomerModel> customerList = [];
  List<JPMultiSelectModel> filterByMultiList = [];
  List<StateModel?> stateList = [];
  List<UserModel>? users;

  final GlobalKey<FormState> filterFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> deleteFormKey = GlobalKey<FormState>();

  AutovalidateMode autoValidate = AutovalidateMode.always;
  CustomerListingFilterModel filterKeys = CustomerListingFilterModel();
  CustomerListingFilterModel defaultFilterKeys = CustomerListingFilterModel()..repIds = [0];

  Position? location;
  UserModel? selectedUser;
  StateModel? selectedState;
  String? deleteDialogPassword;
  String? deleteNote;
  String? selectedUserID;
  String? selectedStateID;
  int metaDataCount = 0;

  List<JPSingleSelectModel>? sortByList;

  @override
  void onInit() {
    super.onInit();
    hasNearByJobAccess = UserPreferences.hasNearByAccess ?? true;
    fetchCustomers();
    getCurrentLatLong().then((location) async {
      this.location = location;
    });
  }

  Future<Position> getCurrentLatLong () => LocationService.getCoordinates().then((location) => location);

  Map<String, dynamic> getQueryParams() {
    Map<String, dynamic> queryParams = {
      "includes[0]" : "address",
      "includes[1]" : "phones",
      "includes[2]" : "appointments",
      "includes[3]" : "flags",
      "includes[4]" : "referred_by",
      "includes[5]" : "custom_fields",
      "includes[6]" : "flags.color",
      ...filterKeys.toJson()..removeWhere((dynamic key, dynamic value) =>
      (key == null || key == "rep_ids" || key == "state_id" || key == "flags") || value == null),
    };
    for(int i = 0; i < (filterKeys.repIds?.length ?? 0) ; i++) {
      queryParams.addEntries({"rep_ids[$i]" : filterKeys.repIds![i]}.entries);
    }
    for(int i = 0; i < (filterKeys.stateIds?.length ?? 0) ; i++) {
      queryParams.addEntries({"state_id[$i]" : filterKeys.stateIds![i]}.entries);
    }
    for(int i = 0; i < (filterKeys.flags?.length ?? 0) ; i++) {
      queryParams.addEntries({"flag_ids[$i]" : filterKeys.flags![i]}.entries);
    }
    return queryParams;
  }

  void setSortByList() {

    sortByList = [
      JPSingleSelectModel(id: 'created_at', label: "last_added".tr),
      JPSingleSelectModel(id: 'updated_at', label: "last_Modified".tr),
      JPSingleSelectModel(id: 'last_name', label: "last_Named".tr),
    ];
    sortByList?.addAllIf(UserPreferences.hasNearByAccess ?? false, [
      JPSingleSelectModel(id: 'sub_title', label: "nearby".tr.toUpperCase()),
      JPSingleSelectModel(id: 'distance_0_25', label: "1_4_mile".tr),
      JPSingleSelectModel(id: 'distance_0_5', label: "1_2_mile".tr),
      JPSingleSelectModel(id: 'distance_1', label: "1_mile".tr),
      JPSingleSelectModel(id: 'distance_5', label: "5_mile".tr),
      JPSingleSelectModel(id: 'distance_10', label: "10_mile".tr)
    ]);
    update();
  }

  ///////////////////////    NAVIGATE TO DETAIL SCREEN   ///////////////////////

  void navigateToDetailScreen({int? customerID, int? index}) {
    Get.toNamed(Routes.customerDetailing, arguments: {NavigationParams.customerId: customerID})
    ?.then((value) {
      if(!Helper.isValueNullOrEmpty(value)){
        customerList[index!] = value;
        update();
      }
    }); 
  }

  void navigateToEditScreen({int? customerID, int? index}) {
    Get.toNamed(Routes.customerForm, arguments: {
      NavigationParams.customerId: customerID
    })?.then((value) {
      if (value != null) {
        refreshList(showShimmer: true);
      }
    });
  }

  void navigateToAddScreen() {
    Get.toNamed(Routes.customerForm)?.then((value) {
      if (value != null && value) {
        refreshList(showShimmer: true);
      }
    });
  }

  ///////////////////    NAVIGATE TO CUSTOMER FILES SCREEN   ///////////////////

  void navigateToCustomerFilesScreen(int customerID){
    Get.toNamed(Routes.filesListing, arguments: {NavigationParams.type: FLModule.customerFiles, NavigationParams.customerId: customerID}, preventDuplicates: false);
  }

  /////////////////////////////   FETCH CUSTOMERS   ////////////////////////////

  Future<void> fetchCustomers() async {
    try {
      Map<String, dynamic> queryParams = getQueryParams();
      Map<String, dynamic> response = await CustomerListingRepository().fetchCustomerList(queryParams);
      List<CustomerModel> list = response["list"];
      if (!isLoadMore) {
        customerList = [];
        metaDataCount = 0;
      }
      customerList.addAll(list);
      addmaskingPropertyinPermissionList();
      canShowLoadMore = customerList.length < response["pagination"]["total"];
      update();
      await fetchMeta();
    } catch (e) {
      rethrow;
    } finally {
      setSortByList();
      isLoading = false;
      isLoadMore = false;
      update();
    }
  }

  void addmaskingPropertyinPermissionList() async {
    UserModel loggedInUser = await AuthService.getLoggedInUser();
    if(loggedInUser.dataMasking) {
      enableMasking = true;
      if(AuthService.isPrimeSubUser()){
        PermissionService.permissionList.add(PermissionConstants.enableMasking);
      }
    }
  }

  /////////////////////////////   FETCH META   ////////////////////////////

  /// [fetchMeta] is used to fetch meta data of customers
  /// [index] - If available, loads the meta data of the customer at that index
  Future<void> fetchMeta({int? index}) async {
    Map<String, dynamic> queryParams = {
      "type[0]" : "jobs_count",
      "type[1]" : "appointment_details",
      "type[2]": "phone_consents"
    };

    try {
      if (index != null) {
        queryParams.addEntries({"customer_ids[0]" : customerList[index].id}.entries);
        Map<String, dynamic> response = await CustomerListingRepository().fetchMetaList(queryParams);
        if (!Helper.isValueNullOrEmpty(response["list"])) {
          updateCustomerMeta(customerList[index], response["list"][0]);
        }
      } else {
        for(int i = metaDataCount; i < (customerList.length) ; i++) {
          queryParams.addEntries({"customer_ids[$i]" : customerList[i].id}.entries);
        }
        Map<String, dynamic> response = await CustomerListingRepository().fetchMetaList(queryParams);
        List<CustomerModel> list = response["list"];
        for (int customerIndex = 0; customerIndex < customerList.length; customerIndex++) {
          for (int listIndex = 0; listIndex < list.length; listIndex++) {
            if (customerList[customerIndex].id == list[listIndex].id) {
              updateCustomerMeta(customerList[customerIndex], list[listIndex]);
            }
          }
        }
        metaDataCount = customerList.length;
      }
      update();
    } catch (e) {
      rethrow;
    } 
  }

  /// [updateCustomerMeta] is used to update meta data of customers that are already loaded
  void updateCustomerMeta(CustomerModel customer, CustomerModel customerMeta) {
    customer.jobsCount = customerMeta.jobsCount;
    customer.appointmentDate = customerMeta.appointmentDate;
    customer.appointments = customerMeta.appointments;
    for (var phoneIndex = 0; phoneIndex < (customer.phones?.length ?? 0); phoneIndex++) {
      if (customer.phones?[phoneIndex].number.toString() == customerMeta.phoneConsents?[phoneIndex].phoneNumber) {
        customer.phones?[phoneIndex].consentStatus = customerMeta.phoneConsents?[phoneIndex].status;
        customer.phones?[phoneIndex].consentCreatedAt = customerMeta.phoneConsents?[phoneIndex].createdAt;
        customer.phones?[phoneIndex].consentEmail = customerMeta.phoneConsents?[phoneIndex].email;
      }
    }
  }

  //////////////////////////////   REFRESH LIST   //////////////////////////////

  ///showLoading is used to show shimmer if refresh is pressed from main drawer
  Future<void> refreshList({bool? showShimmer}) async {
    filterKeys.page = 1;
    if((filterKeys.repIds?.isNotEmpty ?? false) && (filterKeys.repIds!.length == 1) && (filterKeys.repIds![0] == 0)) {
      filterKeys.repIds = null;
    }
    ///   show shimmer if showLoading = true
    isLoading = showShimmer ?? false;
    update();
    await fetchCustomers();
  }

  void updateConsentStatus(int index){
    customerList[index].phones?.first.consentStatus = ConsentStatusConstants.pending;
    update();
  }

  void onTapEmailAction({String? email, String? fullName, int? jobId, int? customerId, int? contactId, String? actionFrom}) {
    Map<String, dynamic> args = {};

    if(jobId != null) {
      args = {'jobId': jobId};
    }

    if(customerId != null) {
      args['customer_id'] = customerId;
    }

    if(contactId != null) {
      args = {'contact_id': contactId, 'to' : EmailProfileDetail(name: fullName!, email: email!)};
    }

    if(email != null && fullName != null){
      args['to'] = EmailProfileDetail(name: fullName, email: email);
    }

    args['action'] = actionFrom;
    
    Helper.navigateToComposeScreen(arguments: args);
  }

  ////////////////////////////   FETCH NEXT PAGE   /////////////////////////////

  Future<void> loadMore() async {
    filterKeys.page += 1;
    isLoadMore = true;
    await fetchCustomers();
  }

  ///////////////////////////////   SORT LIST   ////////////////////////////////

  Future<void> applySortFilters(dynamic value) async {
    if((location?.latitude == null || location?.longitude == null) && value.contains("distance")) {
      bool canAccessLocation = await LocationService.checkAndReRequestPermission();
      if(canAccessLocation) {
        location = await LocationService.getCoordinates(lastKnownCoordinates: true);
      } else {
        Helper.showToastMessage("provide_location_permissions".tr);
      }
      if (location?.latitude == null || location?.longitude == null) return;
    }

    filterKeys.page = 1;
    filterKeys.selectedItem = value;
    filterKeys.sortOrder = "desc";
    filterKeys.distance = 0;
    filterKeys.lat = null;
    filterKeys.long = null;

    switch(value){
      case "last_name":
        filterKeys.sortBy = value;
        filterKeys.sortOrder = "asc";
      break;
      case "distance_0_25":
        filterKeys.distance = 0.25;
        filterKeys.sortBy = "distance";
        filterKeys.lat = location?.latitude;
        filterKeys.long = location?.longitude;
        filterKeys.sortOrder = "asc";
      break;
      case "distance_0_5":
        filterKeys.distance = 0.5;
        filterKeys.sortBy = "distance";
        filterKeys.lat = location?.latitude;
        filterKeys.long = location?.longitude;
        filterKeys.sortOrder = "asc";
      break;
      case "distance_1":
        filterKeys.distance = 1;
        filterKeys.sortBy = "distance";
        filterKeys.lat = location?.latitude;
        filterKeys.long = location?.longitude;
        filterKeys.sortOrder = "asc";
      break;
      case "distance_5":
        filterKeys.distance = 5;
        filterKeys.sortBy = "distance";
        filterKeys.lat = location?.latitude;
        filterKeys.long = location?.longitude;
        filterKeys.sortOrder = "asc";
      break;
      case "distance_10":
        filterKeys.distance = 10;
        filterKeys.sortBy = "distance";
        filterKeys.lat = location?.latitude;
        filterKeys.long = location?.longitude;
        filterKeys.sortOrder = "asc";
      break;
      default:
        filterKeys.sortBy = value;
      break;
    }
    isLoading = true;
    update();
    fetchCustomers().trackSortFilterEvents();
  }

  /////////////////////////////   FILTER LIST   ////////////////////////////////

  void applyFilters(CustomerListingFilterModel params) {
    filterKeys = params;
    filterKeys.page = 1;
    if(!filterKeys.sortBy!.contains("last_name")) {
      filterKeys.sortOrder = "desc";
    }
    if(!filterKeys.sortBy!.contains("distance")) {
      filterKeys.distance = 0;
    }
    isLoading = true;
    update();
    fetchCustomers().trackFilterEvents();
  }

  /////////////////////////    QUICK ACTION HANDLER    /////////////////////////

  void openQuickActions({CustomerModel? customer, int? index}) {
    CustomerQuickActionHelper().openQuickActions(
      enableMasking: enableMasking,
      customer: customer!,
      index: index!,
      navigateToDetailScreen: navigateToDetailScreen,
      navigateToEditScreen: navigateToEditScreen,
      deleteCallback: deleteCallback,
      flagCallback: flagCallback,
      appointmentCallback: navigateToCreateAppointmentScreen,
    );
  }
  ////////    DELETE    ///////
  void deleteCallback(dynamic modal, dynamic action) {
    customerList.removeAt(customerList.indexWhere((element) => element.id == modal!.id));
    Get.back();
    update();
  }

  ////////    FLAGS    ///////

  flagCallback({CustomerModel? customer, int? customerIndex}) {
    customerList[customerIndex!] = customer!;
    update();
  }

  Future<void> navigateToCreateAppointmentScreen({CustomerModel? customer}) async {
    final result = await Get.toNamed(
      Routes.createAppointmentForm , arguments: {
        NavigationParams.customer: customer,
        NavigationParams.pageType: AppointmentFormType.createForm,
      }
    );
    if(result != null) {
      refreshList(showShimmer: true);
    }
  }

  //////////////////////////////////////////////////////////////////////////////

  bool isMetaDataLoading(int index) => metaDataCount <= index;

  /// [openAppointment] opens appointment details screen
  Future<void> openAppointment(int index) async {
    // Get the appointment for the customer at the given index.
    AppointmentModel? appointment = customerList[index].getAppointment();

    // If the appointment is recurring, open the details screen for it.
    if (appointment?.recurringId == null) return;

    // Navigate to the appointment details screen, passing the recurring ID as an argument.
    final response = await Get.toNamed(
      Routes.appointmentDetails,
      arguments: {
        NavigationParams.appointmentId : appointment?.recurringId
      },
    );

    // If the appointment was updated or deleted in the details screen, refresh the data.
    if (Helper.isTrue(response['status']) || response['action'] == 'delete') {
      fetchMeta(index: index);
    }
  }
}
