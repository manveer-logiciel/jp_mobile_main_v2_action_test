import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/models/subscriber/subscriber_details.dart';
import 'files_listing_model.dart';

class FilesListingQuickActionParams {
  final List<FilesListingModel> fileList;
  final List<String>? sharedFilesPath;
  final bool? isInSelectionMode;
  final FLModule type;
  final List<FinancialListingModel>? unAppliedCreditList;
  final JobModel? jobModel;
  CustomerModel? customerModel;
  SubscriberDetailsModel? subscriberDetails;
  FLModule? tempModule;
  bool? doShowThankYouEmailToggle;

  final Function(FilesListingModel model, dynamic action) onActionComplete;

  FilesListingQuickActionParams({
    required this.fileList,
    required this.onActionComplete,
    this.jobModel,
    this.unAppliedCreditList,
    this.isInSelectionMode = false,
    this.doShowThankYouEmailToggle = false,
    this.type = FLModule.companyFiles,
    this.customerModel,
    this.subscriberDetails,
    this.sharedFilesPath,
    this.tempModule
  });
}
