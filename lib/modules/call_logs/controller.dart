import 'package:get/get.dart';
import 'package:jobprogress/common/models/call_logs/call_log_listing.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/repositories/call_log.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/event/view_events.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';

class CallLogListingController extends GetxController {
  List<CallLogModel> callLogList = [];
  bool isLoading = true;
  bool canShowLoadMore = false;
  bool isLoadMore = false;
  int? callLogTotalLength = 0;
  CustomerModel? customer;
  UserModel? loggedInUser;
  int page = 1;

  Future<void> getCallLogList() async {
    try {
      if(customer != null){
         customer!.id;
      }
      
      final callLogParams = <String, dynamic>{
        'includes[0]': ['customer'],
        'includes[1]': ['job_contact'],
        'includes[2]': ['created_by'],
        'includes[3]': ['job'],
        'customer_id': customer!.id,
        'limit': PaginationConstants.pageLimit,
        'page': page
      };

      Map<String, dynamic> response = await CallLogListRepository().fetchCallLogList(callLogParams);
      setCallLog(response);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadMore = false;
      update();
    }
  }

  setCallLog(Map<String, dynamic> response) {
    List<CallLogModel> list = response['list'];

    PaginationModel pagination = response['pagination'];

    callLogTotalLength = pagination.total!;

    if (!isLoadMore) {
      callLogList = [];
    }
   
    callLogList.addAll(list);

    canShowLoadMore = callLogList.length < callLogTotalLength!;
  }

  Future<void> loadMore() async {
    page += 1;
    isLoadMore = true;
    if(customer != null){
      await getCallLogList();
    }
  }

   Future<dynamic> getLoggedInData() async {
    loggedInUser = await AuthService.getLoggedInUser();
  }
  
  @override
  void onInit() {
    super.onInit();
    MixPanelService.trackEvent(event: MixPanelViewEvent.callLogsListing);
    getLoggedInData();
  }
}