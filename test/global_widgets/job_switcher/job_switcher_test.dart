import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/job_switcher.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/global_widgets/job_switcher/controller.dart';

void main(){
  final controllerJob = JobSwitcherController(type: JobSwitcherType.job,currentJob: JobModel(id: 1, customerId: 2), customerId: null);
  final controllerProject = JobSwitcherController(type: JobSwitcherType.project, currentJob: JobModel(id: 1, customerId: 2), customerId: null);
  test("JobSwitcher should be constructed with default values", () {
    expect(controllerJob.canShowLoadMore, false);
    expect(controllerJob.isLoading, true);
    expect(controllerJob.isLoadMore, false);
    expect(controllerJob.isLoadMoreProject, false);
    expect(controllerJob.canShowLoadMoreProject, false);
    expect(controllerJob.customerId, null);
    expect(controllerJob.jobListToatlLength, 0);
    expect(controllerJob.jobProjectToatlLength, 0);
    expect(controllerJob.paramKey.customerId, null);
    expect(controllerJob.paramKey.limit, 20);
    expect(controllerJob.paramKey.optimized, null);
    expect(controllerJob.paramKey.page, 1);
    expect(controllerJob.paramKey.parentId, null);
    expect(controllerJob.paramKey.sortBy, null);
    expect(controllerJob.paramKey.sortBy, null);
  });

  test('JobSwitcher should loadmore used when api request for data with type job', () {
    controllerJob.loadMore();
    expect(controllerJob.paramKey.page, 2);
    expect(controllerJob.isLoadMore, true);
    expect(controllerJob.isLoadMoreProject, false);
  });

  test('JobSwitcher should loadmore used when api request for data with type project', () {
    controllerProject.loadMore();
    expect(controllerProject.paramKey.page, 2);
    expect(controllerProject.isLoadMore, false);
    expect(controllerProject.isLoadMoreProject, true);
  });

  group("JobSwitcherController@setJobListing should correctly load more jobs", () {
    test('Should load more jobs when more data is available for loading', () {
      Map<String, dynamic> response = {
        "list": [
          JobModel(id: 1, customerId: 2),
          JobModel(id: 2, customerId: 3),
        ],
        "pagination": {"total": 3, "count": 2}
      };

      controllerJob.setJobListing(response);

      expect(controllerJob.jobListing.length, equals(2));
      expect(controllerJob.canShowLoadMore, isTrue);
    });

    test('Should not load more jobs when more data is available for loading', () {
      Map<String, dynamic> response = {
        "list": [
          JobModel(id: 1, customerId: 2),
          JobModel(id: 2, customerId: 3),
          JobModel(id: 3, customerId: 4)
        ],
        "pagination": {"total": 3, "count": 3}
      };

      controllerJob.setJobListing(response);

      expect(controllerJob.jobListing.length, equals(4));
      expect(controllerJob.canShowLoadMore, isFalse);
    });
  });

  group("JobSwitcherController@setJobListingProject should correctly load more project jobs", () {
    test('Should load more project jobs when more data is available for loading', () {
      Map<String, dynamic> response = {
        "list": [
          JobModel(id: 1, customerId: 2),
          JobModel(id: 2, customerId: 3),
        ],
        "pagination": {"total": 3, "count": 2}
      };

      controllerJob.setJobListingProject(response);

      expect(controllerJob.jobMutliProjectListing.length, equals(2));
      expect(controllerJob.canShowLoadMoreProject, isTrue);
    });

    test('Should not load more project jobs when more data is available for loading', () {
      Map<String, dynamic> response = {
        "list": [
          JobModel(id: 1, customerId: 2),
          JobModel(id: 2, customerId: 3),
          JobModel(id: 3, customerId: 4)
        ],
        "pagination": {"total": 3, "count": 3}
      };

      controllerJob.setJobListingProject(response);

      expect(controllerJob.jobMutliProjectListing.length, equals(3));
      expect(controllerJob.canShowLoadMoreProject, isFalse);
    });
  });

}
