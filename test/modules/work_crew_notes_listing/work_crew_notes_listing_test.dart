import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/modules/work_crew_notes/listing/controller.dart';

void main(){
   final controller = WorkCrewNotesListingController();
   Map<String, dynamic> jobJson = {
     "id":12883,
     "number":"2105-9601-06",
     "work_types":[
       {
         "id":745,
         "trade_id":35,
         "name":"Square Ft",
         "type":2,
         "order":0,
         "color":"#9C2542",
         "deleted_at":null,
         "qb_id":"55",
         "qb_account_id":"207",
       }
     ],
     "archived":null,
     "order":20,
     "job_archived":null,
     "multi_job":0,
   };

  test("workCrewNoteListing should be constructed with default values", (){
    expect(controller.canShowLoadMore, false);
    expect(controller.isLoading, true);
    expect(controller.isLoadMore, false);
    expect(controller.workCrewListOfTotalLength, 0);
    expect(controller.paramkeys.jobId, null);
    expect(controller.paramkeys.limit, 20);
    expect(controller.paramkeys.page, 1);
    expect(controller.paramkeys.sortBy, null);    
    expect(controller.paramkeys.sortOrder, 'desc');
  });

  test('workCrewNoteListing should loadmore used when api request for data', () {
    controller.loadMore();
    expect(controller.isLoadMore, true);
    expect(controller.paramkeys.page, 2);
  });

  test('workCrewNoteListing should refresh when api request for data with showLoading passes true', () {
    bool showLoading = true;
    controller.refreshList(showLoading: showLoading);
    expect(controller.isLoading, showLoading);
    expect(controller.paramkeys.page, 1);
  });
  
  test('workCrewNoteListing should refresh when api request for data', () {
    controller.refreshList();
    expect(controller.isLoading, false);
    expect(controller.paramkeys.page, 1);
  });

  group("For selection mode", () {
    controller.job = JobModel.fromJson(jobJson);
    test('workCrewNoteListing should be in selection mode', () {
      controller.isInSelectMode =  true;
      expect(controller.doShowFloatingActionButton, false);
      expect(controller.canShowSecondaryHeader, false);
    });

    test('workCrewNoteListing should not be in selection mode', () {
      controller.isInSelectMode =  false;
      expect(controller.doShowFloatingActionButton, true);
      expect(controller.canShowSecondaryHeader, true);
    });
  });
}