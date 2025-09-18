import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/global_widgets/quick_book_sync_error/controller.dart';

void main(){
  test("QuickBookSyncErrorController should be constructed with default values", () {

    final controllerJob = QuickBookSyncErrorController(entity: 'Job', entityId: '14736');
    expect(controllerJob.isLoading, true);
    expect(controllerJob.height, 1.0);
    expect(controllerJob.isSolutionExpanded, false);
    expect(controllerJob.quickBookSyncError, null);
  });

   test("QuickBookSyncErrorController should be constructed with customer and customer_id", () {

    final controllerCustomer = QuickBookSyncErrorController(entity: 'customer', entityId: '14523');
    expect(controllerCustomer.entity, 'customer');
    expect(controllerCustomer.entityId,'14523');
  });

   test("QuickBookSyncErrorController should be constructed with job and job_id", () {

    final controllerJob = QuickBookSyncErrorController(entity: 'Job', entityId: '14736');
    expect(controllerJob.entity, 'Job');
    expect(controllerJob.entityId,'14736');
  });

  test("QuickBookSyncErrorController@isSolutionExpandedChange function should toggle isSolutionExpanded", () {

    final controllerJob = QuickBookSyncErrorController(entity: 'Job', entityId: '14736');
    controllerJob.isSolutionExpandedChange();
    expect(controllerJob.isSolutionExpanded, true);
  });

   test("QuickBookSyncErrorController@callBackForHeight function should  set height value", () {

    final controllerJob = QuickBookSyncErrorController(entity: 'Job', entityId: '14736');
    double height = 12;
    controllerJob.callBackForHeight(height);
    expect(controllerJob.height, 12);
  });
  
}
