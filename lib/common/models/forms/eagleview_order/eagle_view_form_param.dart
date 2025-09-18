import '../../../../modules/files_listing/forms/eagle_view_form/controller.dart';
import '../../../enums/eagle_view_form_type.dart';
import '../../job/job.dart';

class EagleViewFormParam {
  final EagleViewFormController? controller;
  final JobModel? jobModel;
  final EagleViewFormType? pageType;
  final Function(dynamic val)? onUpdate;

  EagleViewFormParam({
    this.controller,
    this.jobModel,
    this.pageType,
    this.onUpdate
  });
}