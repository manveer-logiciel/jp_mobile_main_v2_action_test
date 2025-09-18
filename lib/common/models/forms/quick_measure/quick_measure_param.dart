import '../../../../modules/files_listing/forms/quick_measure/controller.dart';
import '../../job/job.dart';

class QuickMeasureParams {

  final QuickMeasureFormController? controller;
  final JobModel? jobModel;
  final Function(dynamic val)? onUpdate;

  QuickMeasureParams({
    this.controller,
    this.jobModel,
    this.onUpdate,
  });


}