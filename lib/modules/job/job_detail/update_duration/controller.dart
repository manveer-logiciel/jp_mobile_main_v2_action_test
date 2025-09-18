import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class UpdateDurationController extends GetxController {
  final String currentDuration;

  late JPInputBoxController daysController;
  late JPInputBoxController hoursController;
  late JPInputBoxController minutesController;

  bool isUpdatingDurationStatus = false;

  UpdateDurationController(this.currentDuration) {
    final daySplitResult = Helper.splitDurationintoMap('day', currentDuration);
    final hourSplitResult = Helper.splitDurationintoMap('hour', daySplitResult['remainingData']!);
    final minuteSplitResult = Helper.splitDurationintoMap('minute', hourSplitResult['remainingData']!);


    if(daySplitResult['result'] != ''){
      daysController = JPInputBoxController(text: daySplitResult['result']);
    } else {
      daysController = JPInputBoxController();
    }
    if(hourSplitResult['result'] != ''){
      hoursController = JPInputBoxController(text: hourSplitResult['result']);
    } else {
      hoursController = JPInputBoxController();
    }
    if(minuteSplitResult['result'] != ''){
      minutesController = JPInputBoxController(text: minuteSplitResult['result']);
    } else {
      minutesController = JPInputBoxController();
    }
  }

  /// update duration value
  Future<void> updateDuration(int jobId,Function(String?)? updateDurationCallback) async {
    toggleDuration();
    try {
      Map<String,dynamic> params = {
        'duration':'${daysController.text}:${hoursController.text}:${minutesController.text}',
      };

      JobModel jobModel = await JobRepository.editJobDuration(params, jobId.toString());

      updateDurationCallback?.call(jobModel.duration);

      Get.back();
    } catch(e){
      rethrow;
    } finally {
      toggleDuration();
    }
  }

  void toggleDuration() {
    isUpdatingDurationStatus = !isUpdatingDurationStatus;
    update();
  }
}