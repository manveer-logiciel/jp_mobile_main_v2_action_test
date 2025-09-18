import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/modules/follow_ups_notes/listing/controller.dart';

void main(){
   final controller = FollowUpsNotesListingController();
  test("FollowupsNoteListing should be constructed with default values", (){
    expect(controller.canShowLoadMore, false);
    expect(controller.isLoading, true);
    expect(controller.isLoadMore, false);
    expect(controller.isDeleting, false);
    expect(controller.followUpNoteListOfTotalLength, 0);
    expect(controller.noteParamKey.jobId, null);
    expect(controller.noteParamKey.limit, 20);
    expect(controller.noteParamKey.page, 1);
    expect(controller.noteParamKey.sortBy, null);    
    expect(controller.noteParamKey.sortOrder, 'desc');
  });

  test('FollowupsNoteListing should loadmore used when api request for data', () {
    controller.loadMore();
    expect(controller.noteParamKey.page, 2);
    expect(controller.isLoadMore, true);
  });

  test('FollowupsNoteListing should refresh when api request for data with showLoading passes true', () {
    controller.jobId = 1;
    bool showLoading = true;
    controller.refreshList(showLoading: showLoading);
    expect(controller.noteParamKey.page, 1);
    expect(controller.isLoading, showLoading);
  });
  
  test('FollowupsNoteListing should refresh when api request for data', () {
    controller.refreshList();
    expect(controller.noteParamKey.page, 1);
    expect(controller.isLoading, false);
  });
}