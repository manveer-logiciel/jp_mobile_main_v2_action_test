import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:jobprogress/common/enums/appointment_form_type.dart';
import 'package:jobprogress/common/enums/calendars.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/appointment/appointment_limited.dart';
import 'package:jobprogress/common/models/calendars/calendar_filters.dart';
import 'package:jobprogress/common/models/calendars/calendars_request_params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/common/repositories/appointment.dart';
import 'package:jobprogress/common/repositories/company_settings.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/schedule.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/calendars/db_reader.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/calendar_helper/calendar_color_helper.dart';
import 'package:jobprogress/core/utils/color_helper.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/appointment_details/page.dart';
import 'package:jobprogress/modules/calendar/widgets/events/index.dart';
import 'package:jobprogress/modules/schedule/details/page.dart';
import 'package:jp_mobile_flutter_ui/CalendarView/src/day_timeline_view/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../common/enums/event_form_type.dart';
import '../../routes/pages.dart';
import 'widgets/filter_dialog/index.dart';

class CalendarPageController extends GetxController with GetTickerProviderStateMixin {

  CalendarPageController() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    monthViewKey = GlobalKey<MonthViewState>();
    monthWeekViewKey = GlobalKey<MonthWeekViewState>();
    weekViewKey = GlobalKey<WeekViewState>();
    dayViewKey = GlobalKey<DayViewState>();
    timeLineViewKey = GlobalKey<TimeLineViewState>();
    dayTimeLineViewKey = GlobalKey<DayTimeLineViewState>();
    switcherKey = GlobalKey<MonthViewWeekSwitcherState>();
    listKey = GlobalKey<AnimatedListState>();
  }

  late GlobalKey<ScaffoldState> scaffoldKey;// helps in open/close drawer
  late GlobalKey<MonthViewState> monthViewKey; // used to manage month-view state
  late GlobalKey<MonthWeekViewState> monthWeekViewKey; // used to manage month-week-view stage
  late GlobalKey<WeekViewState> weekViewKey; // used to manage week-view stage
  late GlobalKey<DayViewState> dayViewKey; // used to manage day-view state
  late GlobalKey<TimeLineViewState> timeLineViewKey; // used to manage timeline state
  late GlobalKey<DayTimeLineViewState> dayTimeLineViewKey; // used to manage day-timeline state
  late GlobalKey<MonthViewWeekSwitcherState> switcherKey; // used to manage view switcher state
  late GlobalKey<AnimatedListState> listKey; // used to manage animated list state

  EventController eventController = EventController(); // helps in adding events on calendar
  CalendarsRequestParams requestParams = CalendarsRequestParams(); // used to store api request params
  DateTime selectedDate = DateTime.now(); // used to store currently selected date
  CalendarsViewType viewType = CalendarsViewType.month; // helps in managing selected view
  CalendarsEventType eventType = CalendarsEventType.appointment; // helps in filtering request params and api calls
  ScrollController eventListController = ScrollController(); // used to manage scroll for events list
  late TabController pageController;

  List<dynamic> selectedDateEvents = []; // stores selected date events

  JobModel? job;
  CalendarsRequestParams? defaultParams; // helps in resetting filter to default state
  String? selectedColorScheme; // used to store selected color scheme in case of production calendar

  DateTime get selectedDateUTC => DateTime.utc(selectedDate.year, selectedDate.month, selectedDate.day);

  List<JPSingleSelectModel> viewsList = [
    JPSingleSelectModel(label: 'timeline'.tr, id: CalendarsViewType.timeline.toString()),
    JPSingleSelectModel(label: 'day'.tr, id: CalendarsViewType.day.toString()),
    JPSingleSelectModel(label: 'week'.tr, id: CalendarsViewType.week.toString()),
    JPSingleSelectModel(label: 'month'.tr, id: CalendarsViewType.month.toString()),
  ];

  List<JPSingleSelectModel> colorsSchemesList = [
    JPSingleSelectModel(label: 'sales_man_customer_rep'.tr, id: 'customer_rep'),
    JPSingleSelectModel(label: 'estimator'.tr, id: 'estimator'),
    JPSingleSelectModel(label: 'company_crew'.tr, id: 'company_crew'),
    JPSingleSelectModel(label: 'labor_sub'.tr, id: 'labor_sub'),
    JPSingleSelectModel(label: 'trade_type'.tr, id: 'trades'),
    JPSingleSelectModel(label: 'work_type'.tr, id: 'work-type'),
    JPSingleSelectModel(label: 'division'.tr, id: 'divisions'),
  ]; // list of color schemes

  bool isUpdatingDateManually = false;
  bool isProductionCalendar = false;
  bool isLoading = true; // helps in manging loading state
  bool doNeedToReloadOnSwitchingToMonthView = false; // helps in manging loading state
  bool isInitialLoad = true; // helps in identifying initial load
  bool isSixWeekMonth = false; // helps in identifying month have 6 rows


  CalendarType type = Get.arguments?['type'] ?? CalendarType.staff;

  int? jobId = Get.arguments?['job_id'];

  String? previousRouteName = Get.arguments?[NavigationParams.previousRouteName];

  Debouncer clickDeBouncer = Debouncer(delay: const Duration(milliseconds: 150));

  bool get doShowFilterIcon => !(AuthService.isPrimeSubUser() && !isProductionCalendar);

  
  @override
  void onInit() {
    isProductionCalendar = type == CalendarType.production;
    final (initialPage, initialView) = settingsToView();

    viewType = initialView;
    pageController = TabController(length: 4, vsync: this, initialIndex: initialPage);
    // in case of production calendar only schedule events will be there
    eventType = isProductionCalendar ? CalendarsEventType.schedules : CalendarsEventType.appointment;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (viewType == CalendarsViewType.week) {
        monthWeekViewKey.currentState!.weekViewAnimationController.forward();
      }
      fetchEvents();
    });

    super.onInit();
  }

  Future<void> switchCalendar() async{
    if(previousRouteName == "production"){
      Get.back(result: true);
    }
    else if(previousRouteName == "staff"){
      Get.back();
    }
    else{
      String previousRoute = type == CalendarType.staff ? "staff" : "production";
      CalendarType calendarType = type == CalendarType.staff ? CalendarType.production : CalendarType.staff;
      final result = await Get.toNamed(Routes.calendar, arguments: {
        NavigationParams.previousRouteName : previousRoute,
        NavigationParams.type : calendarType
      }, preventDuplicates: false);

      if(result is bool && result){
        fetchEvents();
      }
    }
  }

  (int pageIndex, CalendarsViewType view) settingsToView() {
    dynamic value = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.calendarViewMobile);
    if (value is bool) value = null;
    final viewData = isProductionCalendar ? (value?['production']) : (value?['staff']);
    switch (viewData) {
      case 'month':
        return (1, CalendarsViewType.month);
      case 'week':
        return (0, CalendarsViewType.week);
      case 'day':
        return (2, CalendarsViewType.day);
      case 'timeline':
        return (3, CalendarsViewType.timeline);
    }
    return (1, CalendarsViewType.month);
  }

  WeekDays get weekStartFrom {
    dynamic companyCalenderSetting = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.companyCalendarSetting);
    if(companyCalenderSetting is Map) {
      final value = companyCalenderSetting['week_start_from'] as String?;
      if(value != null) {
        const mapping = {
          '0': WeekDays.sunday,
          '1': WeekDays.monday,
          '2': WeekDays.tuesday,
          '3': WeekDays.wednesday,
          '4': WeekDays.thursday,
          '5': WeekDays.friday,
          '6': WeekDays.saturday,
        };
        return mapping[value] ?? WeekDays.monday;
      }
    } 
    return WeekDays.monday;
  }

  // fetchEvents() : load events from server
  Future<void> fetchEvents() async {
    try {
      toggleIsLoading(true);
      // setting up filters
      if(requestParams.filter == null) await setUpFilters();

      //setting up job
      if(jobId != null){
        job = (await JobRepository.fetchJob(jobId!))['job'];
      } 

      // setting up selection date
      requestParams.setStartEndDate(requestParams.date);

      // removing previous events if having any
      for (var event in eventController.events) {
        eventController.remove(event);
      }

      Map<String, dynamic> appointmentApiParams = {
        ...requestParams.toJson(),
        ...requestParams.eventTypeToIncludes(eventType)
      };

      Map<String, dynamic> scheduleApiParams = {
        ...requestParams.toJson(),
        ...requestParams.eventTypeToIncludes(CalendarsEventType.schedules, isForProductionCalendar: isProductionCalendar, jobId: jobId)
      };

      if(isProductionCalendar) {
        // in case of production calendar only schedules will be loaded
        final response = await eventTypeToApi(scheduleApiParams, localEventType: CalendarsEventType.schedules);
        List<dynamic> sortedEvents = sortCalendarEvents([<String, dynamic>{}, response]);
        eventTypeToParseResponse(sortedEvents);
      } else {
        
        List<dynamic> response = await Future.wait([
          eventTypeToApi(appointmentApiParams),
          if(requestParams.filter!.isScheduleHidden) eventTypeToApi(scheduleApiParams, localEventType: CalendarsEventType.schedules),
        ]);

        List<dynamic> sortedEvents = sortCalendarEvents(response);
        eventTypeToParseResponse(sortedEvents); // parsing response
      }

      setUpEventsList(selectedDate); // setting up selected events list

      if(!isInitialLoad) {
        saveCalendarSetting(); // saving settings on server
      }

    } catch(e) {
      rethrow;
    } finally {
      toggleIsLoading(false);
      isInitialLoad = false;
      loadFilterCategories(showLoader: false);
    }
  }

  void toggleIsLoading(bool val) {
    isLoading = val;
    update();
  }

  // previousPage() : helps in navigating to previous day, week or month
  void previousPage() {
    switch (viewType) {
      case CalendarsViewType.month:
        if(monthViewKey.currentState == null) {
          onPageChanged(DateTime(selectedDate.year, selectedDate.month - 1, 1), -1);
        } else {
          monthViewKey.currentState?.previousPage();
        }
        break;

      case CalendarsViewType.monthWeek:
      case CalendarsViewType.week:
        weekViewKey.currentState?.previousPage();
        monthWeekViewKey.currentState?.previousPage();
        break;

      case CalendarsViewType.day:
        dayViewKey.currentState?.previousPage();
        dayTimeLineViewKey.currentState?.previousPage();
        break;

      case CalendarsViewType.timeline:
        timeLineViewKey.currentState?.previousPage();
        break;
    }
  }

  // nextPage() : helps in navigating to next day, week or month
  void nextPage() {
    switch (viewType) {
      case CalendarsViewType.month:
        if(monthViewKey.currentState == null) {
          onPageChanged(DateTime(selectedDate.year, selectedDate.month + 1, 1), -1);
        } else {
          monthViewKey.currentState?.nextPage();
        }
        break;

      case CalendarsViewType.monthWeek:
      case CalendarsViewType.week:
        weekViewKey.currentState?.nextPage();
        monthWeekViewKey.currentState?.nextPage();
        break;

      case CalendarsViewType.day:
        dayViewKey.currentState?.nextPage();
        dayTimeLineViewKey.currentState?.nextPage();
        break;

      case CalendarsViewType.timeline:
        timeLineViewKey.currentState?.nextPage();
        break;
    }
  }

  // selectDate() : helps in selecting date from picker
  void selectDate() async {
    DateTime? date = await DateTimeHelper.openDatePicker(
      helpText: 'select_month_and_date'.tr,
      initialDate: selectedDate.toString()
    );

    if(date != null) {
      if(date.compareWithoutTime(selectedDate)) return;

      isUpdatingDateManually = true;
      monthViewKey.currentState?.jumpToMonth(date);
      monthWeekViewKey.currentState?.jumpToWeek(date);
      weekViewKey.currentState?.jumpToWeek(date);
      dayViewKey.currentState?.jumpToDate(date);
      timeLineViewKey.currentState?.jumpToMonth(date);
      dayTimeLineViewKey.currentState?.jumpToDate(date);
      setUpEventsList(date); // updating events
    }
  }

  // onTapMonthCell() : handles click on month date cell
  Future<void> onTapMonthCell(List<CalendarEventData<dynamic>>? events, DateTime date) async {

    if(selectedDate.compareWithoutTime(date)) return;
      setUpEventsList(date, events: events,);

  }

  // onPageChanged() : handles next/previous day, week or month switch
  void onPageChanged(DateTime date, int index) {

    clickDeBouncer.call(() {

      bool isDataReloadNeeded = false; // helps in checking if reload needed

      switch(viewType) {
        case CalendarsViewType.month:
        case CalendarsViewType.timeline:
          isDataReloadNeeded = true; // necessary to load data in case of month view
          break;
        case CalendarsViewType.monthWeek:
          isDataReloadNeeded = date.checkIfDateFallsInWeek(startDate: requestParams.startDate, endDate: requestParams.endDate);
          break;
        case CalendarsViewType.day:
          // Subtracting 1 day from end date because while loading data from api
          // we have passed Start data 1-March-2024 and end date is 1-April-2024 then it gives the
          // events up to and including 31-March-2024. But on comparing when selected date is 1-April-2024
          // It was considering that it should not load data from server while it should as events for that
          // day are not been loaded yet. So we are subtracting 1 day from end date.
          isDataReloadNeeded = date.isBefore(DateTime.parse(requestParams.startDate))
              || date.isAfter(DateTime.parse(requestParams.endDate).subtract(const Duration(days: 1)));
          break;

        case CalendarsViewType.week:
          weekViewKey.currentState?.jumpToWeek(date);
          isDataReloadNeeded = date.checkIfDateFallsInWeek(startDate: requestParams.startDate, endDate: requestParams.endDate);
          break;
      }

      if(!isUpdatingDateManually) {
        setUpEventsList(date);
      }

      if(isDataReloadNeeded) {
        requestParams.date = date;
        selectedDateEvents.clear();
        update();
        fetchEvents();
      }
      isUpdatingDateManually = false;
    });
  }

  DateTime parseDate(String date, bool isAllDay) {
    if(isAllDay) {
      return DateTime.parse(DateTimeHelper.formatDate(DateTime.parse(date).toString(), DateFormatConstants.dateTimeServerFormat));
    } else {
      return DateTime.parse(DateTimeHelper.formatDate(date, DateFormatConstants.dateTimeServerFormat));
    }
  }

  // addEventOnCalendar() : filters data and add to calendar events
  void addEventOnCalendar(dynamic event) {

    if(event is AppointmentLimitedModel) {
      addAppointmentOnCalendar(event);
    } else if(event is SchedulesModel){
      addScheduleOnCalendar(event);
    }

  }

  // addAppointmentOnCalendar() : add appointment in calendar events
  void addAppointmentOnCalendar(AppointmentLimitedModel appointment) {

    // checking for start date, end date and all day
    final startDateTime = parseDate(appointment.startDateTime!, appointment.isAllDay);
    final endDateTime = parseDate(appointment.endDateTime!, appointment.isAllDay);

    eventController.filterAndAddEvents(
        event: CalendarEventData<AppointmentLimitedModel>(
            title: appointment.title ?? "",
            event: appointment,
            date: startDateTime,
            color: ColorHelper.getHexColor(appointment.appointmentHexColor!),
            isAllDay: appointment.isAllDay
        ),
        startDateTime: startDateTime,
        endDateTime: endDateTime
    ); // adding event
  }

  // addScheduleOnCalendar() : adds schedule in calendar events
  void addScheduleOnCalendar(SchedulesModel schedule) {

    // checking for start date, end date and all day
    final startDateTime = parseDate(schedule.startDateTime!, schedule.isAllDay);
    final endDateTime = parseDate(schedule.endDateTime!, schedule.isAllDay);
    final eventColor = CalendarColorHelper.getScheduleColor(schedule, selectedColorScheme: selectedColorScheme);

    eventController.filterAndAddEvents(
        event: CalendarEventData<SchedulesModel>(
            title: schedule.title ?? "",
            event: schedule,
            date: startDateTime,
            color: eventColor,
            isAllDay: schedule.isAllDay
        ),
        startDateTime: startDateTime,
        endDateTime: endDateTime
    ); // adding event
  }

  // updateView() : updates selected view state when changed using switcher (finger swipes)
  Future<void> updateView(CalendarsViewType type) async {
    if(type == viewType) return;
    viewType = type;
    update();

    if(viewType == CalendarsViewType.week) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      monthWeekViewKey.currentState!.weekViewAnimationController.forward();
    }

    if(doNeedToReloadOnSwitchingToMonthView) {
      fetchEvents();
    }

    saveViewSettings();
  }


  // eventTypeToApi() : filters api call request
  Future<dynamic> eventTypeToApi(Map<String, dynamic> params, {CalendarsEventType? localEventType}) async {
    switch (localEventType ?? eventType) {
      case CalendarsEventType.appointment:
        return await AppointmentRepository().fetchAppointmentsEvents(params);

      case CalendarsEventType.schedules:
        return await ScheduleRepository().fetchScheduleList(params, useV2Url: true);
    }
  }

  /// [sortCalendarEvents] helps in sorting calendar events
  List<dynamic> sortCalendarEvents(dynamic response) {
    List<dynamic> allEvents = [];
    // adding all the appointments to event list
    if ((response as List).isNotEmpty) {
      allEvents.addAll((response[0]?['list'] ?? <AppointmentLimitedModel>[]));
    }
    // adding all the schedules to events list
    if ((response).length > 1) {
      allEvents.addAll((response[1]?['list'] ?? <SchedulesModel>[]));
    }
    // Sorting events
    allEvents.sort((a, b) {
      // bringing all day events at top
      if (a.isAllDay != b.isAllDay) {
        return a.isAllDay ? -1 : 1;
      }
      // sorting rest of the events on the basis od timings
      return a.startDateTime!.compareTo(b.startDateTime!);
    });
    return allEvents;
  }

  // eventTypeToParseResponse() : filters and parse api response
  void eventTypeToParseResponse(List<dynamic> sortedEvents) {
    for (dynamic event in sortedEvents) {
      if(event is AppointmentLimitedModel) {
        addAppointmentOnCalendar(event);
      } else if(event is SchedulesModel){
        addScheduleOnCalendar(event);
      }
    }
  }

  // toggleSchedule() : helps in enabling/disabling schedule
  Future<void> toggleSchedule(bool val) async {
    requestParams.filter!.isScheduleHidden = val;
    update();
    saveCalendarSetting(isForSchedules: true); // saving calendar settings on schedule change
    fetchEvents();
  }

  Future<void> showFilterDialog() async {
    try {
      await loadFilterCategories();
    } catch (e) {
      rethrow;
    } finally {
      showJPGeneralDialog(
        child: (_) {
          return StaffCalendarFilterDialog(
            params: requestParams,
            defaultParams: defaultParams ?? requestParams,
            onApplyFilter: onApplyFilter,
            isForProductionCalendar: isProductionCalendar,
          );
        },
      );
    }
  }

  // showColorSelector() : displays color selector sheet
  void showColorSelector() {
    SingleSelectHelper.openSingleSelect(
        colorsSchemesList,
        selectedColorScheme,
        'select_color_scheme'.tr,
        (value) {
          selectedColorScheme = value;
          updateEventColors();
        });
  }

  void updateEventColors() {
    saveCalendarSetting(saveColorSettings: true);
    for (var event in eventController.events) {
      if(event.event is SchedulesModel) {
        final schedule = event.event as SchedulesModel;
        event.color = CalendarColorHelper.getScheduleColor(schedule, selectedColorScheme: selectedColorScheme);
      }
    }
    update();
    Get.back();
  }

  void onApplyFilter(CalendarsRequestParams params) {
    requestParams = params;
    fetchEvents().trackFilterEvents();
  }

  Future<void> setUpFilters() async {
    try {

      bool canSelectOtherUsers = canSelectAllUsers();

      requestParams.setOtherUsersSelection(canSelectOtherUsers);

      if(isProductionCalendar) {
        final tempColorScheme = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.productionCalendarColorOrder);
        selectedColorScheme = tempColorScheme is String ? tempColorScheme : null;
      }
      requestParams.filter = getCalendarFilters();
      requestParams.users = await CalendarsDbReader.getAllUsers(
          Helper.isValueNullOrEmpty(requestParams.filter?.users)
              ? [AuthService.userDetails!.id.toString()]
              : requestParams.filter?.users ?? [],
          withSubContractorPrime: true,
          includeUnAssigned: true,
          canSelectOtherUsers: canSelectOtherUsers,
      );
      requestParams.jobId = jobId;
      requestParams.tags = await CalendarsDbReader.getAllTags();
      requestParams.divisions = await CalendarsDbReader.getAllDivisions(requestParams.filter?.divisionIds ?? []);
      requestParams.companyCrew = await CalendarsDbReader.getAllUsers(requestParams.filter?.jobRepIds ?? [], canSelectOtherUsers: canSelectOtherUsers);
      requestParams.labourSub = await CalendarsDbReader.getAllUsers(requestParams.filter?.subIds ?? [],
          onlySub: true,
          canSelectOtherUsers: canSelectOtherUsers,
          useCompanyName: true,
      );
      requestParams.tradeTypes = await CalendarsDbReader.getAllTrades(
          requestParams.filter?.trades ?? [],
          selectedWorkTypeIds: requestParams.filter?.workTypeIds ?? []
      );
      requestParams.jobFlag = await CalendarsDbReader.getAllFlags(requestParams.filter?.jobFlagIds ?? []);
      requestParams.city = await CalendarsDbReader.getAllCities(requestParams.filter?.cities ?? []);
      if(isProductionCalendar) {
        requestParams.workTypes = [];
        requestParams.tradeTypes?.forEach((trade) {
          if (trade.isSelect && trade.subList != null) {
            requestParams.workTypes!.addAll(trade.subList!);
          }
        });
      }
      requestParams.customerName = requestParams.filter?.customerName;
      defaultParams ??= requestParams; // setting up default filters
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadFilterCategories({bool showLoader = true}) async {
    if (requestParams.areCategoriesLoaded) return;
    try {
      if (showLoader) showJPLoader();
      requestParams.category = await CalendarsDbReader.getCategories(requestParams.filter?.categoryIds ?? []);
      requestParams.areCategoriesLoaded = true;
    } catch (e) {
      rethrow;
    } finally {
      if (showLoader) Get.back();
    }
  }

  // getCalendarFilters() : helps in differentiating filters
  CalendarFilterModel getCalendarFilters() {
    return isProductionCalendar
        ? CalendarFilterModel.fromJson(CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.productionCalendarFilter))
        : CalendarFilterModel.fromJson(CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.stCalOpt));
  }

  Future<void> saveViewSettings() async {
    try {
      dynamic localSettings = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.calendarViewMobile, onlyValue: false);
      if (localSettings is bool) localSettings = null;
      localSettings ??= {
        'user_id': AuthService.userDetails?.id,
        'company_id': AuthService.userDetails?.companyDetails?.id,
        'key': CompanySettingConstants.calendarViewMobile,
        'name': CompanySettingConstants.calendarViewMobile,
        'value': {
          'staff': 'month',
          'production': 'month',
        }
      };

      localSettings['value']?[isProductionCalendar ? 'production' : 'staff'] = viewTypeToSetting(viewType);
      await CompanySettingRepository.saveSettings(localSettings);
    } catch (e) {
      rethrow;
    }
  }

  String viewTypeToSetting(CalendarsViewType view) {
    switch (view) {
      case CalendarsViewType.month:
      case CalendarsViewType.monthWeek:
        return 'month';
      case CalendarsViewType.week:
        return 'week';
      case CalendarsViewType.day:
        return 'day';
      case CalendarsViewType.timeline:
        return 'timeline';
    }
  }

  // saveCalendarSetting() : saves calendar settings silently
  Future<void> saveCalendarSetting({bool isForSchedules = false, bool saveColorSettings = false}) async {
    try {
      Map<String, dynamic> params;
      if(saveColorSettings) {
        params = requestParams.filter!.toColorSchemeJson(selectedColorScheme: selectedColorScheme!);
      } else {
        params = requestParams.filter!.toJson(isForSchedules: isForSchedules, isForProductionCalendar: isProductionCalendar);
      }
      await CompanySettingRepository.saveSettings(params);
    } catch (e) {
      rethrow;
    }
  }

  // showViewSelector() : display filters to select view from
  void showViewSelector() {
    SingleSelectHelper.openSingleSelect(
        viewsList,
        getDisplayViewType().toString(),
        'select_view'.tr,
        (value) {
          if(value == viewType.toString()) return;
          Get.back();
          animateToView(value);
        });
  }

  // animateToView() : animates to view selected from the filter
  Future<void> animateToView(String type) async {

    // additional time to animate calendar after bottom sheet closes
    await Future<void>.delayed(const Duration(milliseconds: 200));

    await dayViewKey.currentState?.animationController.reverse(); // in case of day view selected reversing animation
    await monthWeekViewKey.currentState?.weekViewAnimationController.reverse();

    switch (type) {

      case "CalendarsViewType.month":
        await switcherKey.currentState?.animateToMonthView();
        pageController.animateTo(1);
        break;
      case "CalendarsViewType.week":
      case "CalendarsViewType.weekMonth":
        await switcherKey.currentState?.animateToWeekView();
        pageController.animateTo(0);
        break;
      case "CalendarsViewType.day":
        await switcherKey.currentState?.animateToDayView();
        pageController.animateTo(2);
        break;
      case "CalendarsViewType.timeline":
        await switcherKey.currentState?.animateToTimeLineView();
        pageController.animateTo(3);
        break;
    }

  }

  // setUpEventsList() : set up and events list and animated too
  Future<void> setUpEventsList(DateTime date, {List<CalendarEventData<dynamic>>? events}) async {

    doNeedToReloadOnSwitchingToMonthView = date.month != selectedDate.month;

    selectedDate = requestParams.date = date;

    eventController.selectedWeek = date.weekOfMonth;

    final tempEvents = events ?? eventController.getEventsOnDay(date);

      // Removing selected items
      for(int i=0; i <selectedDateEvents.length; i++) {
        listKey.currentState?.removeItem(0, (context, animation) => const SizedBox());
      }
      selectedDateEvents.clear();

      for (int i = 0; i < tempEvents.length; i++) {
        selectedDateEvents.add(tempEvents[i]);
        int animationTime = i < 10 ? (i + 1) * 200 : 0;
        listKey.currentState?.insertItem(i, duration: Duration(milliseconds: animationTime));
      }
      update();

      if(eventListController.hasClients) {
        eventListController.jumpTo(0);
      }

      isSixWeekMonth = selectedDate.isSixWeekMonth();
  }

  CalendarsViewType getDisplayViewType() {
    if(viewType == CalendarsViewType.monthWeek) {
      return CalendarsViewType.month;
    } else {
      return viewType;
    }
  }

  void onTapEvent(List<CalendarEventData<dynamic>> event) {
    if(event.length > 2) {
      showEventBottomSheet(event);
    } else {
      if (event.first.event is AppointmentLimitedModel) {
        navigateToAppointmentDetails(event.first.event);
      } else if (event.first.event is SchedulesModel) {
        navigateToScheduleDetails(event.first.event);
      }
    }
  }

  Future<void> navigateToAppointmentDetails(AppointmentLimitedModel data) async {
    Get.to(() => AppointmentDetailsView(
        appointmentId: data.id,
        onAppointmentDelete: fetchEvents,
        onAppointmentUpdate: (appointment) => fetchEvents,
      ),
      transition: Transition.downToUp
    );
  }

  Future<void> navigateToScheduleDetails(SchedulesModel data) async {
    Get.to(() => ScheduleDetail(
          scheduleId: data.id.toString(),
          onScheduleDelete: fetchEvents,
        ),
        transition: Transition.downToUp
    );
  }
  
  void showEventBottomSheet(List<CalendarEventData> events) {

    selectedDateEvents = events;

    showJPBottomSheet(
        child: (_) {
          return CalendarEvents(
              controller: this,
              scrollController: ScrollController(),
              doLimitHeight: true,
              hideLiftUp: !JPScreen.isMobile,
              bannerDate: events.first.date,
          );
        },
      isScrollControlled: true,
    ).whenComplete(() {
      selectedDateEvents = eventController.getEventsOnDay(selectedDate);
    });
  }

  bool isFilterApplied() {

    var usersCondition = type == CalendarType.staff
        ? (requestParams.users?.isNotEmpty ?? false)
        : (requestParams.customerName?.isNotEmpty ?? false);

    return usersCondition
        || (requestParams.filter?.divisionIds?.isNotEmpty ?? false)
        || (requestParams.filter?.categoryIds?.isNotEmpty ?? false)
        || (requestParams.filter?.jobRepIds?.isNotEmpty ?? false)
        || (requestParams.filter?.subIds?.isNotEmpty ?? false)
        || (requestParams.filter?.trades?.isNotEmpty ?? false)
        || (requestParams.filter?.jobFlagIds?.isNotEmpty ?? false)
        || (requestParams.filter?.cities?.isNotEmpty ?? false);
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

  void onTapAdd() {
    if(type == CalendarType.production) {
      PermissionService.hasUserPermissions([PermissionConstants.manageJobSchedule]) ?
        createMoreActionHeader() : 
        navigateToEvent();
    } else {
      navigateToCreateAppointment();
    }
  }

  // moreActionHeader() : used to handle pop-up menu actions
  void createMoreActionHeader() {
    List<JPQuickActionModel> quickActionList = [
      JPQuickActionModel(id: "event", child: const JPIcon(Icons.event, size: 18), label: 'event'.tr ),
      JPQuickActionModel(id: "job_schedule", child: const JPIcon(Icons.schedule_outlined, size: 18), label: 'job_schedule'.tr ),
    ];
    showJPBottomSheet(child: (_) => JPQuickAction(
      title: "create".tr.toUpperCase(),
      mainList: quickActionList,
      onItemSelect: (value) async {
        Get.back();
        dynamic data;
        switch(value) {
          case "event":
            data = await Get.toNamed(Routes.createEventForm, preventDuplicates: false, arguments: {NavigationParams.pageType: EventFormType.createForm});
            break;
          case "job_schedule":
            data = await Get.toNamed(Routes.jobScheduleListing, preventDuplicates: false, arguments: {NavigationParams.pageType: EventFormType.createForm});
            break;
        }

        if(data != null) {
          fetchEvents();
        }
      },
    ), isScrollControlled: true);
  }

  Future<void> navigateToCreateAppointment() async {
    final result =  await Get.toNamed(Routes.createAppointmentForm, arguments: {
      NavigationParams.pageType: AppointmentFormType.createJobAppointmentForm,
      NavigationParams.appointment: job != null ? AppointmentModel.fromJobModel(job!) : null
    });
    if(result != null && result["status"]) {
      fetchEvents();
    }
  }

  Future<void> navigateToEvent() async {
    final result = await  Get.toNamed(Routes.createEventForm, preventDuplicates: false, arguments: {NavigationParams.pageType: EventFormType.createForm});
    if(result != null) {
      fetchEvents();
    }
  }

  @override
  void dispose() {
    switcherKey.currentState?.scrollController.dispose();
    super.dispose();
  }
}