import 'package:jobprogress/common/enums/hover.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/files_listing/hover/job.dart';
import 'package:jobprogress/common/models/files_listing/hover/user.dart';

class HoverOrderFormParams {

  final CustomerModel? customer;
  final int? jobId;
  final HoverUserModel? hoverUser;
  final HoverFormType? formType;
  final HoverJob? hoverJob;
  final Function(HoverJob, Map<String, dynamic>)? onHoverLinked;

  HoverOrderFormParams({
    this.customer,
    this.jobId,
    this.hoverUser,
    this.hoverJob,
    this.formType = HoverFormType.add,
    this.onHoverLinked
  });
}
