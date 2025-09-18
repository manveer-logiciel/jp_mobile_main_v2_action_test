import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/modules/cutomer_job_list/controller.dart';

void main(){
   final controller = CustomerJobListingController(customerJobId: 1);
  test("CustomerJobListing should be constructed with default values", (){
    expect(controller.customerJobId, 1);
    expect(controller.canShowLoadMore, false);
    expect(controller.isLoading, true);
    expect(controller.isLoadMore, false);
    expect(controller.customerJobListToatalLength, 0);
    expect(controller.paramKey.customerId, 1);
    expect(controller.paramKey.limit, 20);
    expect(controller.paramKey.page, 1);
    expect(controller.paramKey.optimized, null);
    expect(controller.paramKey.parentId, null);
    expect(controller.paramKey.sortBy, null);
    expect(controller.paramKey.sortOrder, null);
  });

  test('CustomerJobListing should loadmore used when api request for data', () {
    controller.loadMore();
    expect(controller.isLoadMore, true);
    expect(controller.paramKey.page, 2);
  });

}