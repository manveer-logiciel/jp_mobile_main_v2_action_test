import 'package:get/get.dart';
import 'package:jobprogress/common/services/customer/quick_actions.dart';
import 'package:jobprogress/common/services/job_customer_flags.dart';
import 'package:jobprogress/global_widgets/delete_dialog/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import '../../../core/constants/navigation_parms_constants.dart';
import '../../../core/constants/quick_book_error.dart';
import '../../../core/utils/call_log_helper.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/location_helper.dart';
import '../../../global_widgets/bottom_sheet/index.dart';
import '../../../modules/call_logs/index.dart';
import '../../../routes/pages.dart';
import '../../enums/file_listing.dart';
import '../../enums/job.dart';
import '../../enums/map_type.dart';
import '../../models/call_logs/call_log.dart';
import '../../models/customer/customer.dart';
import '../quick_book.dart';

class CustomerQuickActionHelper {

  late final void Function({int? customerID, int? index})? navigateToDetailScreenCallback;
  late final void Function({int? customerID, int? index})? navigateToEditScreenCallback;
  late final void Function(dynamic model, dynamic action)? deleteCallback;
  late final void Function({CustomerModel? customer, int? customerIndex})? flagCallback;
  late final void Function({CustomerModel? customer})? appointmentCallback;
  List<JPMultiSelectModel>? filterByMultiList;

  void openQuickActions({
    bool? enableMasking,
    CustomerModel? customer,
    int? index,
    Function({int? customerID, int? index})? navigateToDetailScreen,
    Function({int? customerID, int? index})? navigateToEditScreen,
    Function(dynamic model, dynamic action)? deleteCallback,
    Function({CustomerModel? customer, int? customerIndex})? flagCallback,
    Function({CustomerModel? customer})? appointmentCallback,
  }) {

    navigateToDetailScreenCallback = navigateToDetailScreen;
    navigateToEditScreenCallback = navigateToEditScreen;
    this.deleteCallback = deleteCallback;
    this.flagCallback = flagCallback;
    this.appointmentCallback = appointmentCallback;

    CustomerService.openQuickActions(customer: customer!, customerIndex: index!, callback: handleQuickActionCallback, enableMasking: enableMasking);
  }

  void handleQuickActionCallback(CustomerModel customer, String action, int customerIndex) async {
    switch (action) {
      case "edit":
       navigateToEditScreenCallback?.call(customerID: customer.id!, index: customerIndex);
        break;
      case "view":
        navigateToDetailScreenCallback!(customerID: customer.id!, index: customerIndex);
        break;
      case "call":
        SaveCallLogHelper.saveCallLogs(CallLogCaptureModel(customerId: customer.id!, phoneLabel: customer.phones![0].label!, phoneNumber: customer.phones![0].number! ));
        break;
      case "email":
         Helper.navigateToComposeScreen(
          arguments: {'customer_id': customer.id});
        break;
      case "add_job":
        navigateToAddJob(customerId: customer.id);
        break;
      case "customer_flag":
        JobCustomerFlags.showFlagsBottomSheet(
          isQuickAction: true,
          customer: customer,
          index: customerIndex,
          flagCallbackForCustomer: flagCallback,
          id: customer.id,
        );
        break;
      case "map":
        LocationHelper.openMapBottomSheet(query: customer.addressString!);
        break;
      case "appleMap":
      case "googleMap":
        if((customer.address!.lat != null) && (customer.address!.long != null )) {
          LocationHelper.launchMap(query: "${customer.address!.lat!},${customer.address!.long!}",
              mapType: action == "appleMap" ? MapType.appleMap : MapType.googleMap);
        } else {
          LocationHelper.launchMap(query: customer.addressString!,
              mapType: action == "appleMap" ? MapType.appleMap : MapType.googleMap);
        }
        break;
      case "call_logs":
        openCallLogList(customer);
        break;
      case "delete":
        deleteCustomer(customer: customer);
        break;
      case "quick_sync":
      ///   TODO - Customer Listing (Quick-Action): Quick sync implementation is pending
        Helper.showToastMessage('to_be_implemented'.tr);
        break;
      case "quick_book_sync_error":
        QuickBookService.openQuickBookErrorBottomSheet(QuickBookSyncErrorConstants.customerEntity, customer.id.toString());
        break;
      case "customer_files":
        navigateToCustomerFilesScreen(customer.id!);
        break;
      case "create_appointment":
        appointmentCallback?.call(customer: customer);
        break;
      case "appointment":
        Get.toNamed(Routes.appointmentListing, arguments: {
          NavigationParams.customerId: customer.id
        });
        break;
      default:
    }
  }

  ///////////////////    NAVIGATE TO CUSTOMER FILES SCREEN   ///////////////////

  void navigateToCustomerFilesScreen(int customerID){
    Get.toNamed(Routes.filesListing, arguments: {'type': FLModule.customerFiles, "customerId": customerID}, preventDuplicates: false);
  }

  ////////    DELETE CUSTOMER   ///////

  void deleteCustomer({required CustomerModel customer}) {
    showJPGeneralDialog(child:(controller) =>
      DeleteDialogWithPassword(
        model: customer,
        title: "delete_customer".tr.toUpperCase(), 
        actionFrom: 'customer',
        noteFieldLabel: "note".tr,
        deleteCallback: deleteCallback,
      )
    );
  }
  ////////    CALL LOG    ///////

  void openCallLogList(CustomerModel customer){
    showJPBottomSheet( child : (_) => CallLogListingBottomSheet(customer: customer), isScrollControlled: true);
  }

  void navigateToAddJob({int? customerId}) {
    Get.toNamed(Routes.jobForm, arguments: {
      NavigationParams.type: JobFormType.add,
      NavigationParams.customerId: customerId,
    });
  }
}