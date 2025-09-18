import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// ApplyCreditFormData is responsible for providing data to be used by form
/// - Helps in setting up form data
/// - Helps in proving json to be used while making api request
class ApplyCreditFormData {

  ApplyCreditFormData( {
    this.selectedInvoiceId,
    this.job,
    });

  // form field controllers
  JPInputBoxController dateController = JPInputBoxController();
  JPInputBoxController linkInvoiceListController = JPInputBoxController();
  JPInputBoxController creditAmountController = JPInputBoxController();
  JPInputBoxController noteController = JPInputBoxController();

  JobModel? job; // used to store selected job data
  
  List<FilesListingModel>? invoiceList;
  
  String? selectedInvoiceId;
  
  DateTime dueOnDate = DateTime.now(); // used to select  due date
  
  bool showLinkInvoiceField = true;
  
  List<JPSingleSelectModel> linkInvoiceList = []; // used to store linkInvoicelist

   Map<String, dynamic> applyCreditFormJson() {
    final Map<String, dynamic> data = {};
    
    data['amount'] = num.parse(creditAmountController.text);  
    data['customer_id'] = job!.customerId;
    data['invoice_id'] = selectedInvoiceId;
    data['date'] = DateTimeHelper.formatDate(dueOnDate.toString(), DateFormatConstants.dateServerFormat);
    data['method'] = 'cash';
    data['job_id'] = job!.id;
    data['note'] = noteController.text;
    
    return data;
  }
}