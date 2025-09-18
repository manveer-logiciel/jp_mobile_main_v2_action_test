import 'package:get/get.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/event/view_events.dart';
import '../../common/models/job/job.dart';

class RecentJobController extends GetxController {
  List<JobModel> recentJobList = [];
  bool isLoading = true;
  Future<void> getRecentJobList() async {
    try {
      final Map<String, dynamic> params = {
        'includes[0]': 'division'
      };
      recentJobList = await JobRepository.fetchRecentJob(params);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    MixPanelService.trackEvent(event: MixPanelViewEvent.recentJobsListView);
    getRecentJobList();
  }
}
