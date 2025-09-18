import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/recurring_email.dart';
import 'package:jobprogress/common/models/job/recurring_email_scheduler.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/modules/job/job_recurring_email/controller.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

void main(){
  final controller = JobRecurringEmailController();
  
  JobModel jobModel = JobModel(
    id: 1, 
    customerId: 12,
    stages: [
      WorkFlowStageModel(name:'Paid', color:'cl-blue', code: '142'),
      WorkFlowStageModel(name:'Next Stage', color:'cl-red', code: '142'),
      WorkFlowStageModel(name:'Final Stage', color:'cl-yellow', code: '132'),
    ]
  );
  
  RecurringEmailSchedulerModel item = RecurringEmailSchedulerModel(
    isFirstEmail: true,
  );
  RecurringEmailSchedulerModel item1 = RecurringEmailSchedulerModel(
    isLastEmail: true,
  );
  RecurringEmailSchedulerModel item2 = RecurringEmailSchedulerModel(
    status: 'closed',
  );
  RecurringEmailSchedulerModel item3 = RecurringEmailSchedulerModel(
    status: 'canceled',
  );
  RecurringEmailSchedulerModel item4 = RecurringEmailSchedulerModel(
    status: 'ready',
  );
  RecurringEmailSchedulerModel item5 = RecurringEmailSchedulerModel(
    status: 'success',
  );  
  RecurringEmailSchedulerModel item6 = RecurringEmailSchedulerModel(
    status: 'xyz',
  );
  
  List<RecurringEmailModel> recurringEmailList = [
    RecurringEmailModel(
      scheduleEmail: [
        RecurringEmailSchedulerModel(
          id: -4,
          statusUpdatedAt:'2022-07-05 06:48:21',
          status: 'canceled'
        ),
        RecurringEmailSchedulerModel(
          id: -3,
          statusUpdatedAt:'2022-07-04 06:48:21',
          status: 'canceled'
        ),
        RecurringEmailSchedulerModel(
          id: -2,
          statusUpdatedAt:'2022-08-30 06:48:21',
          status: 'closed'
        ),
        RecurringEmailSchedulerModel(
          id: -1,
          statusUpdatedAt: '2022-08-21 06:48:21',
          status: 'closed'
        ),
        RecurringEmailSchedulerModel(
          id: 0,
          statusUpdatedAt: '2022-08-25 06:48:21',
          status: 'closed'
        ),
        RecurringEmailSchedulerModel(
          id: 1,
          scheduleDate: '2022-09-05 06:48:21',
          status: 'ready'
        ),
        RecurringEmailSchedulerModel(
          id: 2,
          scheduleDate: '2022-09-01 06:48:21',
          status: 'ready'
        ),
        RecurringEmailSchedulerModel(
          id: 3,
          createdAt: '2022-09-09 06:48:21',
          status: 'success'
        ),
        RecurringEmailSchedulerModel(
          id: 4,
          createdAt: '2022-09-08 06:48:21',
          status: 'success'
        ),
        RecurringEmailSchedulerModel(
          id: 5,
          createdAt: '2022-09-10 06:48:21',
          status: 'success'
        ),
        RecurringEmailSchedulerModel(
          id: 6,
          scheduleDate: '2022-09-02 06:48:21',
          status: 'ready'
        ),
        
      ]
    ),
  ];
  List<RecurringEmailModel> recurringEmailList1 =[
    RecurringEmailModel(
      scheduleEmail: [
        RecurringEmailSchedulerModel(
          id: 5,
          createdAt: '2022-09-10 06:48:21',
          status: 'success'
        ),
        RecurringEmailSchedulerModel(
          id: 6,
          scheduleDate: '2022-09-02 06:48:21',
          status: 'ready'
        ),
      ],
    ) 
  ];
  group('JobRecurringEmailController@getStageName function case when correct or incorrect stage code pass as parameter',(){
    test("Should return stage name when correct  stage code pass a parameter", (){
      String stageName = controller.getStageName(stageCode: '142', job: jobModel);
      expect(stageName, 'Paid');
    });
  });

  group('JobRecurringEmailController@getStageColor function when correct or incorrect stage code pass as parameter',(){
    test("Should return stageColor  when correct stage code pass a parameter", (){
      Color? stageColor = controller.getStageColor(stageCode: '142', job: jobModel);
      expect(stageColor,const Color(0xff0000ff));
    });
  });
    
  group('JobRecurringEmailController@getEmailSchedulerTitle function different cases when different value pass in item RecurringEmailSchedulerModel',(){  
    test('Should return (First Email sent on ) String when item modal isFirstEmail bool is true', (){
      String title = controller.getEmailSchedulerTitle(item: item);
      expect(title,'First Email sent on ');
    });
    test('Should return (Last Email sent on ) String when item modal isLastEmail bool is true', (){
      String title = controller.getEmailSchedulerTitle(item: item1);
      expect(title,'Last Email sent on ');
    });
    test('Should return (Closed on ) String when item modal status string is closed', (){
      String title = controller.getEmailSchedulerTitle(item: item2);
      expect(title,'Closed on ');
    });
    test('Should return (Recurring Email cancelled by Dikshit Sharma on) String when item modal status string is canceled and name pass Dikshi Sharma',(){
      String title = controller.getEmailSchedulerTitle(item: item3, name: 'Dikshit Sharma');
      expect(title,'Recurring Email cancelled by Dikshit Sharma on ');
    });
    test('Should return "Next Email scheduled for " String when item modal status String is ready',(){
      String title = controller.getEmailSchedulerTitle(item: item4);
      expect(title,'Next Email scheduled for ');
    });
    test('Should return "Email Sent on " String when item modal isFirstEmail bool & isLastEmail bool is false and status String is success', (){
      String title = controller.getEmailSchedulerTitle(item: item5);
      expect(title,'Email Sent on ');
    });
    test('Should return empty String when item modal  status String has some unexpectional value', (){
      String title = controller.getEmailSchedulerTitle(item: item6);
      expect(title,'');
    });
  });
  
  group('JobRecurringEmailController@getEmailSchedulerProcessDotColor function different cases when different value pass in item RecurringEmailSchedulerModel status property', (){
    test('Should return JPAppTheme.themeColors.primary color when status String is success',(){
      Color color = controller.getEmailSchedulerProcessDotColor(item5);
      expect(color, JPAppTheme.themeColors.primary);
    });
    test('Should return JPAppTheme.themeColors.primary color when status String is closed', (){
      Color color = controller.getEmailSchedulerProcessDotColor(item2);
      expect(color, JPAppTheme.themeColors.primary);
    });
    test('Should return JPAppTheme.themeColors.secondary color when status String is canceled', (){
      Color color = controller.getEmailSchedulerProcessDotColor(item3);
      expect(color, JPAppTheme.themeColors.secondary);
    });
    test('Should return JPAppTheme.themeColors.warning color when status String is ready', (){
      Color color = controller.getEmailSchedulerProcessDotColor(item4);
      expect(color, JPAppTheme.themeColors.warning);
    });
    test('Should return JPAppTheme.themeColors.text color when item modal  status String has some unexpectional value', (){
      Color color = controller.getEmailSchedulerProcessDotColor(item6);
      expect(color, JPAppTheme.themeColors.text);
    });
  });

  group('JobRecurringEmailController@getEmailSchedulerProcessspreadRadiusColor function different cases when different value pass in item RecurringEmailSchedulerModel status property', (){
    test('Should return JPAppTheme.themeColors.lightBlue color when status String is success', (){
      Color color = controller.getEmailSchedulerProcessSpreadRadiusColor(item2);
      expect(color, JPAppTheme.themeColors.lightBlue);
    });
    test('Should return JPAppTheme.themeColors.lightBlue color when status String is closed', (){
      Color color = controller.getEmailSchedulerProcessSpreadRadiusColor(item5);
      expect(color, JPAppTheme.themeColors.lightBlue);
    });
    test('Should return JPAppTheme.themeColors.lightRed color when status String is canceled', (){
      Color color = controller.getEmailSchedulerProcessSpreadRadiusColor(item3);
      expect(color, JPAppTheme.themeColors.lightRed);
    });
    test('Should return JPAppTheme.themeColors.lightYellow color when status String is ready', (){
      Color color = controller.getEmailSchedulerProcessSpreadRadiusColor(item4);
      expect(color, JPAppTheme.themeColors.lightYellow);
    });
    test('Should return JPAppTheme.themeColors.text color when item modal  status String has some unexpectional value', (){
      Color color = controller.getEmailSchedulerProcessSpreadRadiusColor(item6);
      expect(color, JPAppTheme.themeColors.text);
    });
  });

  group('JobRecurringEmailController@setData function different actions test cases',(){
    controller.setData(recurringEmailList);
    group('JobRecurringEmailController@setData function test cases when sort action perform & data add on basic of status',(){
      test('Should sort data on basic of created at String when status is success & add item in order of id  4,6,5 in list', (){
        expect(recurringEmailList[0].scheduleEmail![0].status, 'success');
        expect(recurringEmailList[0].scheduleEmail![0].id, 4);
        expect(recurringEmailList[0].scheduleEmail![1].status, 'success');
        expect(recurringEmailList[0].scheduleEmail![1].id, 3);
        expect(recurringEmailList[0].scheduleEmail![2].status, 'success');
        expect(recurringEmailList[0].scheduleEmail![2].id, 5);
      });
      test('Should sort the list on basic of scheduledDate when status is ready & add 1st item of id 2 in main list',(){
        expect(recurringEmailList[0].scheduleEmail![3].id, 2);
        expect(recurringEmailList[0].scheduleEmail![3].status, 'ready');
      });
      test('Should sort the list on basic of statusUpdatedAt when status is closed & add 1 item of id -1 in list',(){
        expect(recurringEmailList[0].scheduleEmail![4].id, -1);
        expect(recurringEmailList[0].scheduleEmail![4].status, 'closed');
      });
      test('Should sort the list on basic of statusUpdatedAt when status is canceled & add 1 item of id -3 in list',(){
        expect(recurringEmailList[0].scheduleEmail![5].id, -3);
        expect(recurringEmailList[0].scheduleEmail![5].status, 'canceled');
      });
  });
  
    test('Should return isFirstEmail true on 1st element of ScheduledEmaillist',(){
     expect(recurringEmailList[0].scheduleEmail![0].isFirstEmail, true);
    });
    test('Should return isFirstEmail false on other than 1st element of ScheduledEmaillist',(){
      expect(recurringEmailList[0].scheduleEmail![1].isFirstEmail, false);
      expect(recurringEmailList[0].scheduleEmail![2].isFirstEmail, false);
      expect(recurringEmailList[0].scheduleEmail![3].isFirstEmail, false);
      expect(recurringEmailList[0].scheduleEmail![4].isFirstEmail, false);
      expect(recurringEmailList[0].scheduleEmail![5].isFirstEmail, false);
    });

    test('Should return isLastEmail true on last element of which status is success',(){
     expect(recurringEmailList[0].scheduleEmail![2].isLastEmail, true);
    });
    test('Should return isLastEmail false on other than last element of which status is success',(){
      expect(recurringEmailList[0].scheduleEmail![0].isLastEmail, false);
      expect(recurringEmailList[0].scheduleEmail![1].isLastEmail, false);
      expect(recurringEmailList[0].scheduleEmail![3].isLastEmail, false);
      expect(recurringEmailList[0].scheduleEmail![4].isLastEmail, false);
      expect(recurringEmailList[0].scheduleEmail![5].isLastEmail, false);
    });
    test('Should return isLastEmail false in all element of scheduledEmailList  when there is only one item with status success',(){
      expect(recurringEmailList1[0].scheduleEmail![0].isLastEmail, false);
      expect(recurringEmailList1[0].scheduleEmail![1].isLastEmail, false);
    });
  
    test('Should return recurringEmailList showHistorybutton true when scheduledEmaillist has more than two element with status property "success" ',(){
      expect(recurringEmailList[0].showHistoryButton, true);
    });
    test('Should return recurringEmailList showHistorybutton false when scheduledEmaillist has less than or equal two element with status property "success" ',(){
      expect(recurringEmailList1[0].showHistoryButton, false);
    });
  });
}