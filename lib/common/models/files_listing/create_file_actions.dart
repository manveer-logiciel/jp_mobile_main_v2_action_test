import '../../enums/file_listing.dart';
import '../customer/customer.dart';
import '../job/job.dart';
import '../job_financial/financial_listing.dart';
import '../subscriber/subscriber_details.dart';
import 'files_listing_model.dart';

class CreateFileActions {
  final List<FilesListingModel> fileList;
  final List<String>? sharedFilesPath;
  final bool? isInSelectionMode;
  final FLModule type;
  final List<FinancialListingModel>? unAppliedCreditList ;
  final JobModel? jobModel;
  final String? templateId;
  CustomerModel? customerModel;
  SubscriberDetailsModel? subscriberDetails;
  final Function(FilesListingModel model, dynamic action) onActionComplete;

  CreateFileActions({
    required this.fileList,
    required this.onActionComplete,
    this.jobModel,
    this.unAppliedCreditList,
    this.isInSelectionMode = false,
    this.type = FLModule.companyFiles,
    this.customerModel,
    this.subscriberDetails,
    this.sharedFilesPath,
    this.templateId,
  });
}