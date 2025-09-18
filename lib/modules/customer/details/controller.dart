import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/common/repositories/customer_listing.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import '../../../common/enums/file_listing.dart';
import '../../../common/models/customer/customer.dart';
import '../../../common/repositories/customer.dart';
import '../../../core/constants/navigation_parms_constants.dart';
import '../../../core/utils/location_helper.dart';
import '../../../routes/pages.dart';


class CustomerDetailController extends GetxController {

  CustomerModel? customer;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = true;

  int metaDataCount = 0;

  List<JPMultiSelectModel> filterByMultiList = [];

  @override
  void onInit() {
    fetchCustomer(id: Get.arguments[NavigationParams.customerId]);
    super.onInit();
  }

  void refreshPage() {
    customer = null;
    isLoading = true;
    update();
    fetchCustomer(id: Get.arguments[NavigationParams.customerId]);
  }

  Map<String, dynamic> getQueryParams(int id) => {
    "includes[0]": "address",
    "includes[1]": "billing",
    "includes[2]": "phones",
    "includes[3]": "rep",
    "includes[4]": "referred_by",
    "includes[5]": "flags",
    "includes[6]": "contacts",
    "includes[7]": "custom_fields.options.sub_options",
    "includes[8]": "canvasser",
    "includes[9]": "call_center_rep",
    "includes[10]": "flags.color",
    "includes[11]" : "appointments",
    "includes[12]" : 'custom_fields.users',
    "id": id
  };

  ////////////////////////////    LAUNCH MAP    ////////////////////////////////

  void launchMapCallback({bool? isBillingAddress}) {
    if(isBillingAddress ?? false) {
      LocationHelper.openMapBottomSheet(query: customer!.billingAddressString!);
    } else {
      LocationHelper.openMapBottomSheet(query: customer!.addressString!);
    }

  }

  ///////////////////////    NAVIGATE TO JOB LISTING SCREEN   ///////////////////////

  void navigateToJobListingScreen({int? customerID}){
    Get.toNamed(Routes.jobListing, arguments: {"customerID": customerID});
  }

  ///////////////////    NAVIGATE TO CUSTOMER FILES SCREEN   ///////////////////

  void navigateToCustomerFilesScreen(int customerID){
    Get.toNamed(Routes.filesListing, arguments: {'type': FLModule.customerFiles, "customerId": customerID}, preventDuplicates: false);
  }

  ///////////////////////    NAVIGATE TO ADD JOB SCREEN   ///////////////////////

  void navigateToAddJobScreen(){
    Get.toNamed(Routes.jobForm, arguments: {
      NavigationParams.type: JobFormType.add,
      NavigationParams.customerId: customer?.id,
    });
  }

  /////////////////////////////   FETCH CUSTOMER   /////////////////////////////

  void fetchCustomer({int? id}) async {
    try {
      customer = await CustomerRepository.getCustomer(getQueryParams(id!)); 
      await fetchMeta();
      update();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchMeta() async {
    Map<String, dynamic> queryParameters = {
      "type[0]": "phone_consents",
      "customer_ids[]": customer?.id,
    };
    try {
      Map<String, dynamic> response = await CustomerListingRepository().fetchMetaList(queryParameters);
      List<CustomerModel> list = response["list"];
      CustomerModel? metaData = list.isNotEmpty ? list.first : null;
        if (customer?.id == metaData?.id) {
          for (var phoneIndex = 0; phoneIndex < (customer?.phones?.length ?? 0); phoneIndex++) {
            if (customer?.phones?[phoneIndex].number.toString() == metaData?.phoneConsents?[phoneIndex].phoneNumber) {
              customer?.phones?[phoneIndex].consentStatus = metaData?.phoneConsents?[phoneIndex].status;
              customer?.phones?[phoneIndex].consentCreatedAt = metaData?.phoneConsents?[phoneIndex].createdAt;
              customer?.phones?[phoneIndex].consentEmail = metaData?.phoneConsents?[phoneIndex].email;
            }
          }
        }
    } catch (e) {
      rethrow;
    }
  }

  // onWillPop(): will return customer model on navigating back to customer listing screen
  Future<bool> onWillPop() async {
   Get.back(result: customer);
   return false;
  }
}
