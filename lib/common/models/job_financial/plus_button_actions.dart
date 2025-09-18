import '../job/job.dart';

class PlusButtonActions {
  final int jobId;
  final int customerId;
  final JobModel? job;
  final Function onActionComplete;
  
  PlusButtonActions({
    required this.jobId,
    this.job,
    required this.customerId,
    required this.onActionComplete,
  });
}