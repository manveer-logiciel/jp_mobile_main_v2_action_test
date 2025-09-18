import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/modules/call_logs/controller.dart';

void main(){
   final controller = CallLogListingController();
  test("CallLogListing should be constructed with default values", (){
    expect(controller.canShowLoadMore, false);
    expect(controller.isLoading, true);
    expect(controller.isLoadMore, false);
    expect(controller.callLogTotalLength, 0);
    expect(controller.page, 1);
  });

  test('CallLogListing should loadmore used when api request for data', () {
    controller.loadMore();
    expect(controller.isLoadMore, true);
    expect(controller.page, 2);
  });
}