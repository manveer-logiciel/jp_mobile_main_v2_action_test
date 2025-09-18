import '../../../../modules/job_financial/form/invoice_form/controller.dart';
import '../../../enums/invoice_form_type.dart';
import '../../job/job.dart';
import '../../job_financial/financial_listing.dart';

class InvoiceFormParam {
  final InvoiceFormController? controller;
  final JobModel? jobModel;
  final FinancialListingModel? financialListingModel;
  final InvoiceFormType? pageType;
  final Function(dynamic val)? onUpdate;

  InvoiceFormParam({
    this.controller,
    this.jobModel,
    this.financialListingModel,
    this.pageType,
    this.onUpdate
  });
}