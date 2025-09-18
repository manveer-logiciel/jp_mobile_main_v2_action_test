import 'package:flutter_test/flutter_test.dart';
import 'package:jiffy/jiffy.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/models/task_listing/task_listing_filter.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/modules/task/listing/controller.dart';

void main(){
   final controller = TaskListingController();
  test("TaskListModel should be constructed with default values", (){
    expect(controller.canShowLoadMore, false);
    expect(controller.isLoading, true);
    expect(controller.isLoadMore, false);
    expect(controller.filterKeys.dateRangeType, null);
    expect(controller.filterKeys.duration, 'none');
    expect(controller.filterKeys.endDate, null);
    expect(controller.filterKeys.includeLockedTask, false);    
    expect(controller.filterKeys.limit, 20);
    expect(controller.filterKeys.onlyHighPriorityTask, false);
    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.reminderNotification, false);
    expect(controller.filterKeys.sortBy, 'due_date');
    expect(controller.filterKeys.sortOrder, 'ASC');
    expect(controller.filterKeys.status, 'pending');
    expect(controller.filterKeys.type, 'assigned');
    expect(controller.selectedFilterByOptions, 'my_pending_tasks');
  });


  test('TaskList should sortlist with ASC and DESC sortoder', () {
    controller.sortListing();

    expect(controller.filterKeys.page, 1);
    expect(controller.filterKeys.sortOrder, 'DESC');
    expect(controller.isLoading, true);
  });

  test('Tasklist should sortfilter with due date, completed date and created date',(){
    controller.applySortFilters();

    expect(controller.filterKeys.page, 1);
    expect(controller.isLoading, true);
    expect(controller.filterKeys.sortBy, 'due_date');
  });

  test("TaskListing should be constructed with parameters", (){
    TaskListingFilterModel params = TaskListingFilterModel(
      duration : 'today',
      status : 'all',
      limit: 20,
      includeLockedTask : true,
      onlyHighPriorityTask : true,
      reminderNotification : true,     
    );
    controller.applyFilters(params);
    
    expect(controller.filterKeys.page, 1);
    expect(controller.isLoading, true);
  });

  test('TaskListing should loadmore used when api request for data ', () {
    controller.loadMore();
    expect(controller.isLoadMore, true);
    expect(controller.filterKeys.page, 2);
  });

  test('TaskListing should validate switch cases of Pending task', () {
    controller.selectedFilterByOptions = 'my_pending_tasks';

    controller.setFilterKeys(null);
    
    expect(controller.filterKeys.sortOrder, 'ASC');
    expect(controller.filterKeys.status, 'pending');
    expect(controller.filterKeys.sortBy, 'due_date');
  });

  test('TaskListing should validate switch cases of Toady task', (){    
    controller.selectedFilterByOptions = 'my_todays_tasks';

    controller.setFilterKeys(null);

    expect(controller. filterKeys.sortOrder , 'ASC');
    expect(controller. filterKeys.status , 'all');
    expect(controller. filterKeys.sortBy , 'created_at');
    expect(controller. filterKeys.duration , 'today');
  });

  test('TaskListing should validate switch cases of Future task', (){    
    controller.selectedFilterByOptions = 'my_future_tasks';

    controller.setFilterKeys(null);

    expect(controller. filterKeys.sortOrder , 'ASC');
    expect(controller. filterKeys.status , 'all');
    expect(controller. filterKeys.sortBy , 'due_date');
    expect(controller. filterKeys.duration , 'upcoming');
    expect(controller.filterKeys.dateRangeType, 'task_due_date');
    expect(controller.filterKeys.startDate, Jiffy.now().add(days: 1).format(pattern: DateFormatConstants.dateServerFormat));
  });

  test('TaskListing should validate switch cases of Past task', (){    
    controller.selectedFilterByOptions = 'my_past_tasks';

    controller.setFilterKeys(null);

    expect(controller. filterKeys.sortOrder , 'DESC');
    expect(controller. filterKeys.status , 'all');
    expect(controller. filterKeys.sortBy , 'due_date');
    expect(controller. filterKeys.duration , 'past');
    expect(controller.filterKeys.dateRangeType, 'task_due_date');
  });

  test('TaskListing should validate switch cases of Completed task', (){    
    controller.selectedFilterByOptions = 'my_completed_tasks';

    controller.setFilterKeys(null);

    expect(controller. filterKeys.sortOrder , 'DESC');
    expect(controller. filterKeys.status , 'completed');
    expect(controller. filterKeys.sortBy , 'completed');
  });


  test('TaskListing should validate switch cases of created by me task', (){    
    controller.selectedFilterByOptions = 'tasks_created_by_me';

    controller.setFilterKeys(null);

    expect(controller. filterKeys.sortOrder , 'DESC');
    expect(controller. filterKeys.status , 'all');
    expect(controller. filterKeys.sortBy , 'created_at');
    expect(controller. filterKeys.type , 'created');
  });

  test('TaskListing should validate switch cases of all task', (){    
    controller.selectedFilterByOptions = 'all_tasks';

    controller.setFilterKeys(null);

    expect(controller. filterKeys.sortOrder , 'DESC');
    expect(controller. filterKeys.status , 'all');
    expect(controller. filterKeys.sortBy , 'created_at');
  });

    test('TaskListing should validate switch cases of custom when status all', (){    
      controller.selectedFilterByOptions = 'custom';      

      TaskListingFilterModel params = TaskListingFilterModel(
          duration : 'today',
          status : 'all',
          includeLockedTask : true,
          onlyHighPriorityTask : true,
          reminderNotification : true,     
      );

      controller.setFilterKeys(params);

      expect(controller. filterKeys.duration , params.duration);
      expect(controller.filterKeys.dateRangeType, params.dateRangeType);
      expect(controller.filterKeys.startDate, params.startDate);
      expect(controller.filterKeys.endDate, params.endDate);
  });

      test('TaskListing should validate switch cases of custom when status pending', (){    
      controller.selectedFilterByOptions = 'custom';      

        TaskListingFilterModel params = TaskListingFilterModel(
            duration : 'today',
            status : 'pending',
            includeLockedTask : true,
            onlyHighPriorityTask : true,
            reminderNotification : true,     
        );

      controller.setFilterKeys(params);

      expect(controller. filterKeys.duration , params.duration);
      expect(controller.filterKeys.dateRangeType, params.dateRangeType);
      expect(controller.filterKeys.startDate, params.startDate);
      expect(controller.filterKeys.endDate, params.endDate);
  });


    test('TaskListing should validate switch cases of custom when status completed', (){    
      controller.selectedFilterByOptions = 'custom';      

        TaskListingFilterModel params = TaskListingFilterModel(
            duration : 'today',
            status : 'completed',
            includeLockedTask : true,
            onlyHighPriorityTask : true,
            reminderNotification : true,     
        );

      controller.setFilterKeys(params);

      expect(controller. filterKeys.duration , params.duration);
      expect(controller.filterKeys.dateRangeType, params.dateRangeType);
      expect(controller.filterKeys.startDate, params.startDate);
      expect(controller.filterKeys.endDate, params.endDate);
  });


  test('TaskListing should validate switch cases of custom when duration next_week', (){    
      controller.selectedFilterByOptions = 'custom';

      DateTime nextWeek = Jiffy.now().add(weeks: 1).dateTime;
      DateTime startDate = nextWeek.subtract(Duration(days: nextWeek.weekday - 1));
      DateTime endDate = nextWeek.add(Duration(days: DateTime.daysPerWeek - nextWeek.weekday));

      TaskListingFilterModel params = TaskListingFilterModel(
        duration: 'next_week',
        dateRangeType: 'task_due_date', 
        startDate: DateTimeHelper.format(startDate, DateFormatConstants.dateServerFormat),
        endDate: DateTimeHelper.format(endDate, DateFormatConstants.dateServerFormat)
      );

      controller.setFilterKeys(params);

      expect(controller. filterKeys.duration , params.duration);
      expect(controller.filterKeys.dateRangeType, params.dateRangeType);
      expect(controller.filterKeys.startDate, params.startDate);
      expect(controller.filterKeys.endDate, params.endDate);
  });


  
  test('TaskListing should validate switch cases of custom when duration last_month', (){    
      controller.selectedFilterByOptions = 'custom';

      TaskListingFilterModel params = TaskListingFilterModel(
        duration: 'last_month',
        dateRangeType: 'task_due_date', 
        startDate: Jiffy.now().add(months: -1).startOf(Unit.month).format(pattern: DateFormatConstants.dateServerFormat),
        endDate:Jiffy.now().add(months: -1).endOf(Unit.month).format(pattern: DateFormatConstants.dateServerFormat)
      );

      controller.setFilterKeys(params);

      expect(controller. filterKeys.duration , params.duration);
      expect(controller.filterKeys.dateRangeType, params.dateRangeType);
      expect(controller.filterKeys.startDate, params.startDate);
      expect(controller.filterKeys.endDate, params.endDate);
  });

   group('TaskListingController@handleQuickActionUpdate Should handle quick actions', () {
     test('Should return -1 if the task is not found in the task list', () {
       TaskListModel task = TaskListModel(id: 1, completed: 'true', title: '');
       int index = controller.taskList.indexWhere((element) => element.id == task.id);

       expect(index, -1);
     });

     test('Should delete the task and return -1 when the task ID is removed from the task list', () {
       TaskListModel task = TaskListModel(id: 1, completed: 'true', title: '');
       controller.taskList.add(task);

       controller.handleQuickActionUpdate(task, 'delete');
       int index = controller.taskList.indexWhere((element) => element.id == task.id);

       expect(index, -1);
     });

     test('Should mark the task as completed when the task is completed.', () {
       TaskListModel task = TaskListModel(id: 1, completed: 'true', title: '');
       controller.taskList.add(task);

       controller.handleQuickActionUpdate(task, 'mark_as_complete');
       int index = controller.taskList.indexWhere((element) => element.id == task.id);

       expect(controller.taskList[index].completed, 'true');
     });
   });
}