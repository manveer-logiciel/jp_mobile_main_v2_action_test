import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/modules/job_note/listing/controller.dart';

void main(){
   final controller = JobNoteListingController();
  test("Jobnotelisting should be constructed with default values", (){
    expect(controller.canShowLoadMore, false);
    expect(controller.isLoading, true);
    expect(controller.isLoadMore, false);
    expect(controller.jobNoteListOfTotalLength, 0);
    expect(controller.isDeleting, false);
    expect(controller.paramKeys.jobId, null);
    expect(controller.paramKeys.limit, 20);
    expect(controller.paramKeys.page, 1);
    expect(controller.paramKeys.sortBy, null);
    expect(controller.paramKeys.sortOrder, 'desc');
    expect(controller.paramKeys.stageCode, null);
  });

  test('Jobnotelisting should loadmore used when api request for data', () {
    controller.loadMore();
    expect(controller.isLoadMore, true);
    expect(controller.paramKeys.page, 2);
  });

  test('Jobnotelisting should refresh when api request for data with showLoading passes true', () {
    bool showLoading = true;
    controller.refreshList(showLoading: showLoading);
    expect(controller.isLoading, showLoading);
    expect(controller.paramKeys.page, 1);
  });
  
  test('Jobnotelisting should refresh when api request for data', () {
    controller.refreshList();
    expect(controller.isLoading, false);
    expect(controller.paramKeys.page, 1);
  });

  test('Jobnotelisting should sortlist with asc and desc sortoder', () {
    controller.sortJobNoteListing();
    expect(controller.paramKeys.page, 1);
    expect(controller.paramKeys.stageCode, null);
    expect(controller.paramKeys.sortBy, 'updated_at');
    expect(controller.paramKeys.sortOrder, 'asc');
    expect(controller.isLoading, true);
  });

  test('Jobnotelisting should sortlist with stage sortoder', () {
    String selectedStageCode = 'all';
    controller.jobNoteListByStage(selectedStageCode);
    expect(controller.selectedStage, null);
    expect(controller.paramKeys.stageCode, null);
    expect(controller.paramKeys.page, 1);
    expect(controller.isLoading, true);
  });
}