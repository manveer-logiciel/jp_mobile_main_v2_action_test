import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/services/task/quick_actions.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  group("Task Service getQuickActionList function Cases when different value pass in  'action From' String ",(){
    List<JPQuickActionModel> list;
    test("Should remain three element in list  In case 'action from' String  is not passed ",(){
      list = TaskService.getQuickActionList(TaskListModel(id: 1, title: 'Dummy',));
      expect(list.length, 6);
    });

    test("Should not delete element with id 'view' in list,  In case 'action from' String  is not passed",(){
      list = TaskService.getQuickActionList(TaskListModel(id: 1, title: 'Dummy',));
      expect(list[0].id, 'view');
      expect(list[1].id, 'mark_as_complete');
      expect(list[2].id, 'edit');
      expect(list[3].id, 'add_to_daily_plan');
      expect(list[4].id, 'link_to_job_project');
      expect(list[5].id, 'delete');
    });

    test("Should remain three element in list,  In case 'action from' String  is  passed  null",(){
      list = TaskService.getQuickActionList(TaskListModel(id: 1, title: 'Dummy',), actionFrom: '');
      expect(list.length, 6);
    });

    test("Should not deleted element with id 'view' in list,  In case 'action from' String  is  passed  null",(){
      list = TaskService.getQuickActionList(TaskListModel(id: 1, title: 'Dummy',),actionFrom: '');
      expect(list[0].id, 'view');
      expect(list[1].id, 'mark_as_complete');
      expect(list[2].id, 'edit');
      expect(list[3].id, 'add_to_daily_plan');
      expect(list[4].id, 'link_to_job_project');
      expect(list[5].id, 'delete');
    });

    test("Should remain three element in list In Case 'action from' String pass other  than task_detail ",(){
      list = TaskService.getQuickActionList(TaskListModel(id: 1, title: 'Dummy',), actionFrom: 'task view');
      expect(list.length, 6);
    });

    test("Should not  deleted element with id 'view' in list  In Case 'action from' String pass  than task_detail",(){
      list = TaskService.getQuickActionList(TaskListModel(id: 1, title: 'Dummy',),actionFrom: 'task_view');
      expect(list[0].id, 'view');
      expect(list[1].id, 'mark_as_complete');
      expect(list[2].id, 'edit');
      expect(list[3].id, 'add_to_daily_plan');
      expect(list[4].id, 'link_to_job_project');
      expect(list[5].id, 'delete');
    });

    test("Should remain two element in list In case task_detail pass in 'action from' String",() {
      list = TaskService.getQuickActionList(TaskListModel(id: 1, title: 'Dummy',), actionFrom: 'task_detail');
      expect(list.length, 4);
    });
    
    test("Should delete element with id 'view' in list In case task_detail pass in 'action from' String",() {
      list = TaskService.getQuickActionList(TaskListModel(id: 1, title: 'Dummy',), actionFrom: 'task_detail');
      expect(list[0].id, 'mark_as_complete');
      expect(list[1].id, 'edit');
      expect(list[2].id, 'link_to_job_project');
      expect(list[3].id, 'delete');
    });
  });
  
 
  group("Task Service getQuickActionList function Cases when completed String pass or not pass to TaskListModal 'task'",(){
    test("Should remove element with id 'mark_as_uncompleted' In Case no data pass",(){
      List<JPQuickActionModel>  list =  TaskService.getQuickActionList(TaskListModel(id: 1, title: 'Dummy'), actionFrom: 'task_view');
      expect(list[1].id, 'mark_as_complete');
    });

    test("Should remove element with id 'mark_as_completed' in List if  data pass to String  'completed'",(){
      List<JPQuickActionModel> list = TaskService.getQuickActionList(TaskListModel(id: 1, title: 'Dummy',completed: '10'), actionFrom: 'task_view');
      expect(list[1].id, 'mark_as_uncomplete');
    });
  });
}