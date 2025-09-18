
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/clock_summary.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_entry.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_request_params.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_timelog.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/models/sql/division/division.dart';
import 'package:jobprogress/common/models/sql/division/division_param.dart';
import 'package:jobprogress/common/models/sql/division/division_response.dart';
import 'package:jobprogress/common/models/sql/tag/tag_param.dart';
import 'package:jobprogress/common/models/sql/trade_type/trade_type.dart';
import 'package:jobprogress/common/models/sql/trade_type/trade_type_param.dart';
import 'package:jobprogress/common/models/sql/trade_type/trade_type_response.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/sql/user/user_param.dart';
import 'package:jobprogress/common/models/sql/user/user_response.dart';
import 'package:jobprogress/common/repositories/clock_summary.dart';
import 'package:jobprogress/common/repositories/sql/division.dart';
import 'package:jobprogress/common/repositories/sql/tag.dart';
import 'package:jobprogress/common/repositories/sql/trade_type.dart';
import 'package:jobprogress/common/repositories/sql/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/user_roles.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/modules/clock_summary/listing/widgets/filter_dialog/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/tag_modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ClockSummaryController extends GetxController {

  bool isLoading = true;
  bool isLoadMore = false;
  bool canShowLoadMore = false;

  String selectedGroupByFilter = 'job'; // 'job' is default groupBy filter
  String selectedSortByFilter = 'start_date_time'; // 'start_date_time' is default sort by filter

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<JPSingleSelectModel> groupByFilter = [
    JPSingleSelectModel(label: 'job'.tr, id: 'job',),
    JPSingleSelectModel(label: 'user'.tr, id: 'user'),
    JPSingleSelectModel(label: 'date'.tr, id: 'date'),
  ];

  List<JPMultiSelectModel> customerType = [
    JPMultiSelectModel(id: 'residential_customers', label: 'residential'.tr, isSelect: false),
    JPMultiSelectModel(id: 'commercial_customers', label: 'commercial'.tr, isSelect: false),
    JPMultiSelectModel(id: 'bid_customers', label: 'bid'.tr, isSelect: false),
  ]; // static list for displaying customer type filter options

  List<JPSingleSelectModel> sortByFilter = []; // will store sort by filters
  List<ClockSummaryTimeLog> timeLogs = []; // will store time logs data (first screen)
  List<ClockSummaryEntry> timeEntries = []; // will store time entries data (second screen)
  List<String> appliedFiltersList = []; // Will contain list of applied filters to display on header

  String? totalHours;
  String? startDate;
  String? endDate;

  late ClockSummaryRequestParams defaultParams; // defaultParams is used to reset applied filters

  ClockSummaryListingType listingType = Get.arguments == null || Get.arguments['listingType'] == null ? ClockSummaryListingType.groupBy : Get.arguments['listingType']; // Used to differentiate between listing
  ClockSummaryRequestParams requestParams = Get.arguments == null || Get.arguments['defaultParams'] == null ? ClockSummaryRequestParams() : Get.arguments['defaultParams']; // requestParams is used in api call params (with filters)
  bool isOpenedFromSecondaryDrawer = Get.arguments == null || Get.arguments['isOpenedFromSecondaryDrawer'] == null ? false : Get.arguments['isOpenedFromSecondaryDrawer'];

  @override
  void onInit() {
    defaultParams = requestParams; // initializing default params
    readLocalDB().then((value) {
      fetchData();
    });
    super.onInit();
  }

  // initParams() will set api request parameters as per listing type
  Future<void> initParams() async {

    if(listingType == ClockSummaryListingType.sortBy) {

      setAppliedFiltersList();

      sortByFilter = [
        if(requestParams.jobId == null)
          JPSingleSelectModel(label: 'job'.tr, id: 'job_id',),
        if(requestParams.userName == null)
          JPSingleSelectModel(label: 'user'.tr, id: 'user_name'),
        JPSingleSelectModel(label: 'date'.tr, id: 'start_date_time'),
      ]; // setting required sort by filters
    }

    // in case request params are already initialized not need to initialize them again
    if(requestParams.startDate == null) {

      setDuration();

      requestParams.customerType = customerType;

      setAppliedFiltersList();

      defaultParams = requestParams; // setting default params
    }
  }

  Future<void> readLocalDB() async {

    if(requestParams.users != null) return; // No need to read if already read

    await Future.wait([
      getAllTags(),
      getAllUsers(),
      getAllTrades(),
      getAllDivisions(),
    ]); // reading local database
  }

  // showFilterDialog() will display filter dialog
  void showFilterDialog() {
    showJPGeneralDialog(
        child: (_) {
          return ClockSummaryFilterDialog(
            filterKeys: requestParams,
            defaultKeys: defaultParams,
            onApply: onApplyFilter,
          );
        },
    );
  }

  // onApplyFilter() filter data on the basis of filters selected from filter dialog
  void onApplyFilter(ClockSummaryRequestParams params) {
    requestParams = params;
    requestParams.page = 1;
    isLoading = true;
    setAppliedFiltersList();
    fetchData().trackFilterEvents();
  }

  // fetchData() will load data from api
  Future<void> fetchData() async {
    try {

      await initParams();

      await Future.wait([
        callTotalDurationApi(),
        listingTypeToApi(),
      ]);

    } catch (e) {
      Helper.handleError(e);
    } finally {
      isLoading = false;
      isLoadMore = false;
      update();
    }
  }

  Future<void> listingTypeToApi() async {
    switch (listingType) {
      case ClockSummaryListingType.groupBy:
        return await callTimeLogsApi();

      case ClockSummaryListingType.sortBy:
        return callTimeEntriesApi();
    }
  }

  Future<void> callTimeLogsApi() async {

    Map<String, dynamic> params = ClockSummaryRequestParams.getParams(requestParams);

    Map<String, dynamic> response = await ClockSummaryRepository.fetchTimeLogs(params);

    List<ClockSummaryTimeLog> list = response['list'];
    PaginationModel pagination = PaginationModel.fromJson(response["pagination"]);

    if (!isLoadMore) {
      timeLogs = [];
    }

    timeLogs.addAll(list);
    canShowLoadMore = timeLogs.length < pagination.total!;

  }

  Future<void> callTimeEntriesApi() async {

    Map<String, dynamic> params = ClockSummaryRequestParams.getParams(requestParams);

    Map<String, dynamic> response = await ClockSummaryRepository.fetchTimeEntries(params);

    List<ClockSummaryEntry> list = response['list'];
    PaginationModel pagination = PaginationModel.fromJson(response["pagination"]);

    if (!isLoadMore) {
      timeEntries = [];
    }

    timeEntries.addAll(list);
    canShowLoadMore = timeEntries.length < pagination.total!;

  }

  Future<void> callTotalDurationApi() async {

    Map<String, dynamic> params = ClockSummaryRequestParams.getParams(requestParams, isDurationParams: true);

    String? response = await ClockSummaryRepository.fetchTotalDuration(params);
    totalHours = response;

  }

  // getDuration() :- This function will help in filtering start date and end date
  void setDuration() {

    late DateTime tempStartDate;
    late DateTime tempEndDate;
    DateTime today = DateTime.now();

    switch (requestParams.durationType) {
      case DurationType.wtd:
        tempStartDate = today.subtract(Duration(days: today.weekday));
        tempEndDate = today;
        break;

      case DurationType.mtd:
        tempStartDate = DateTime(today.year, today.month, 1);
        tempEndDate = today;
        break;

      case DurationType.ytd:
        tempStartDate = DateTime(today.year, 1, 1);
        tempEndDate = today;
        break;

      case DurationType.lastMonth:
        tempStartDate = DateTime(today.year, today.month - 1, 1);
        tempEndDate = today.subtract(Duration(days: today.day));
        break;

      case DurationType.custom:
        tempStartDate = DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(requestParams.startDate!));
        tempEndDate = DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(requestParams.endDate!));
        break;

      default:
        tempStartDate = DateTime(today.year, today.month, 1);
        tempEndDate = today;
    }

    requestParams.startDate = DateTimeHelper.format(tempStartDate, DateFormatConstants.dateServerFormat);
    requestParams.endDate = DateTimeHelper.format(tempEndDate, DateFormatConstants.dateServerFormat);
  }

  // setAppliedFiltersList() will set filters list to be displayed
  void setAppliedFiltersList() {

    if(requestParams.startDate == null) return;

    setDuration();

    appliedFiltersList.clear(); // making applied filters list empty

    if(requestParams.date == null) {
      String formattedStartDate = DateTimeHelper.convertHyphenIntoSlash(requestParams.startDate!);
      String formattedEndDate = DateTimeHelper.convertHyphenIntoSlash(requestParams.endDate!);
      appliedFiltersList.add('$formattedStartDate - $formattedEndDate'); // adding date filter to list
    } else {
      final formattedDate = DateTimeHelper.convertHyphenIntoSlash(requestParams.date!);
      appliedFiltersList.add(formattedDate); // adding date filter to list
    }
    checkAndAddToAppliedFilter(requestParams.users, 'users_selected'.tr, filterText: requestParams.userName);
    checkAndAddToAppliedFilter(requestParams.divisions, 'divisions_selected'.tr);
    checkAndAddToAppliedFilter([], '', filterText: requestParams.jobName);
    checkAndAddToAppliedFilter(requestParams.tradeTypes, 'trades_selected'.tr);
    checkAndAddToAppliedFilter(requestParams.customerType, 'customer_type'.tr, showInCommas: true);

    update();

  }

  void checkAndAddToAppliedFilter(List<JPMultiSelectModel>? list, String label, {bool showInCommas = false, String? filterText}) {

    if(filterText != null) {

      if(filterText.isEmpty) return;

      appliedFiltersList.add(filterText);
      return;
    }

    final selectedValuesList = list?.where((element) => element.isSelect) ?? [];
    if(selectedValuesList.isNotEmpty) {
      if(!showInCommas) {
        appliedFiltersList.add(
            selectedValuesList.length == 1
                ? selectedValuesList.first.label
                : '${selectedValuesList.length} $label'
        );
      } else {
        List<String> selectedFilterNames = [];
        for (var filterName in selectedValuesList) {
          selectedFilterNames.add(filterName.label);
        }
        appliedFiltersList.add(
          '$label ( ${selectedFilterNames.join(', ')} )'
        );
      }
    }
  }

  // openGroupByFilter() will open group by filters to be selected from
  void openGroupByFilter() {
    SingleSelectHelper.openSingleSelect(
        groupByFilter,
        selectedGroupByFilter,
        'group_by'.tr.toUpperCase(),
         (value) {
          filterDataGroupBy(value);
          Get.back();
        },
        isFilterSheet: true
    );
  }

  // openSortByFilter() will open sort by filters to be selected from
  void openSortByFilter() {
    SingleSelectHelper.openSingleSelect(
        sortByFilter,
        selectedSortByFilter,
        'sort_by'.tr.toUpperCase(),
         (value) {
          filterDataSortBy(value);
          Get.back();
        },
        isFilterSheet: true
    );
  }

  void filterDataGroupBy(String selectedFilter) {
    selectedGroupByFilter = selectedFilter;
    requestParams.group = selectedFilter;
    requestParams.page = 1;
    isLoading = true;
    if(selectedFilter == 'date') {
      requestParams.sortOrder = 'desc';
    } else {
      requestParams.sortOrder = 'asc';
    }
    update();
    fetchData().trackSortFilterEvents();
  }

  void filterDataSortBy(String selectedFilter) {
    selectedSortByFilter = selectedFilter;
    requestParams.sortBy = selectedFilter;
    requestParams.page = 1;
    isLoading = true;
    update();
    fetchData().trackSortFilterEvents();
  }

  // getAllTrades() will load all trades from sql and parse it to multiselect
  Future<void> getAllTrades() async {
    requestParams.tradeTypes = [];
    TradeTypeParamModel params = TradeTypeParamModel(
        withInactive: true,
        includes: ['work_type'],
        withInActiveWorkType: true,
        limit: -1
    );

    TradeTypeResponseModel trades = await SqlTradeTypeRepository().get(params: params);
    for (TradeTypeModel trade in trades.data) {
      requestParams.tradeTypes!.add(
        JPMultiSelectModel(
          label: trade.name,
          id: trade.id.toString(),
          isSelect: false,
        ),
      );
    }
  }

    // getAllTags() will load all trades from sql and parse it to multiselect
  Future<void> getAllTags() async {
    requestParams.tags = [];
    /// Fetch Tags
    TagParamModel tagsParams = TagParamModel(
      includes: ['users'],
    );

    SqlTagsRepository().get(params:tagsParams ).then((tags) {
        for (var element in tags.data) {
          requestParams.tags!.add(JPMultiSelectModel(
              id: element.id.toString(), label: element.name, isSelect: false,subListLength: element.users?.length, ));
        }
      });
  }

  // getAllUsers() will load all users from sql and parse it to multiselect
  Future<void> getAllUsers() async {

    // getting user details from AuthService class
    final authUser = AuthService.userDetails!;
    requestParams.users = []; // initializing list

    UserParamModel params = UserParamModel(
        limit: -1,
        withSubContractorPrime: true,
        includes: ['tags']
    );

    UserResponseModel allUsers = await SqlUserRepository().get(params: params);
    for (UserModel user in allUsers.data) {
        List<TagLimitedModel> tag = [];
            if(user.tags != null){
              for(var e in user.tags! ){
                tag.add(TagLimitedModel(id: e.id,name: e.name));
              }
            }
          requestParams.users!.add(JPMultiSelectModel(
            id: user.id.toString(),
            label: user.groupId == UserGroupIdConstants.subContractorPrime ? '${user.fullName} (${'sub'.tr})' : user.fullName,
            isSelect: authUser.id == user.id,
            child: JPProfileImage(
              size: JPAvatarSize.small,
              src: user.profilePic,
              color: user.color,
              initial: user.intial,
            ),
            tags: tag,
          ));
          tag=[];
    }
  }

  // getAllDivisions() will load all users from sql and parse it to multiselect
  Future<void> getAllDivisions() async {
    requestParams.divisions = [];
    DivisionParamModel params = DivisionParamModel(
      includes: ['users'],
      limit: -1
    );

    DivisionResponseModel divisionData = await SqlDivisionRepository().get(params: params);
    requestParams.divisions!.insert(0, JPMultiSelectModel(id: "0", label: "unassigned".tr, isSelect: false));
    for (DivisionModel division in divisionData.data) {
      requestParams.divisions!.add(
        JPMultiSelectModel(
          label: division.name,
          id: division.id.toString(),
          isSelect: false,
        ),
      );
    }
  }

  // openEntries() will move to second screen for displaying clock entries
  void openEntries(int index) {
    ClockSummaryRequestParams argParams = getArgParams(index);
    Get.toNamed(
        Routes.clockSummary ,
        arguments: {
          'listingType' : ClockSummaryListingType.sortBy,
          'defaultParams' :  argParams,
        },
        preventDuplicates: false,
    );
  }

  // getArgParams() will filter arguments to be sent to second screen
  // based on currently selected group by filter
  ClockSummaryRequestParams getArgParams(int index) {

    ClockSummaryRequestParams argParams = ClockSummaryRequestParams.copy(requestParams);

    switch (selectedGroupByFilter) {
      case 'date':
        argParams.title = timeLogs[index].date;
        argParams.date = DateTimeHelper.convertSlashIntoHyphen(timeLogs[index].date!);
        break;

      case 'job':
        final jobName = timeLogs[index].jobId == null ? 'without_job'.tr : "${timeLogs[index].jobModel?.customer?.fullNameMobile} / ${Helper.getJobName(timeLogs[index].jobModel!)}";
        argParams.withOutJobEntries = timeLogs[index].jobId == null ? 1 : 0;
        argParams.jobId = timeLogs[index].jobId;
        argParams.jobName = argParams.title = jobName;
        argParams.jobModel = timeLogs[index].jobModel;
        break;

      case 'user':
        final userName = timeLogs[index].userName;
        final userId = timeLogs[index].userId;
        argParams.userName = argParams.title = userName;
        argParams.users = [JPMultiSelectModel(label: userName ?? "", id: userId.toString(), isSelect: true)];
        break;
    }
    argParams.sortBy = 'start_date_time';
    argParams.sortOrder = 'desc';
    return argParams;
  }

  Future<void> loadMore() async {
    requestParams.page += 1;
    isLoadMore = true;
    await fetchData();
  }

  Future<void> refreshList({bool? showLoading}) async {
    requestParams.page = 1;
    isLoadMore = false;
    isLoading = showLoading ?? false;
    update();
    await fetchData();
  }

  void openLogDetails(int index) {
    Get.toNamed(
      Routes.timeLogDetails,
      arguments: {
        'id' : timeEntries[index].entryId,
        'title' : timeEntries[index].userName,
        'job' : timeEntries[index].jobModel
      }
    );
  }

  void cancelOnGoingApiRequest() {
    Helper.cancelApiRequest();
  }

  // getHeaderTitle() : will return appropriate header title to be displayed
  String getHeaderTitle() {
    if(requestParams.jobModel?.customer?.fullName != null
        && listingType == ClockSummaryListingType.sortBy) {
      return requestParams.jobModel!.customer!.fullName!;
    } else {
      return 'clockin_clockout_report'.tr;
    }
  }

  @override
  void dispose() {
    cancelOnGoingApiRequest();
    super.dispose();
  }

}