import 'package:jp_mobile_flutter_ui/InputBox/controller.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';
import '../../../../core/constants/date_formats.dart';
import '../../../../core/utils/date_time_helpers.dart';
import '../../accounting_head/accounting_head_model.dart';
import '../../sheet_line_item/sheet_line_item_model.dart';

class RefundFormData {
  JPInputBoxController paymentMethodController = JPInputBoxController();
  JPInputBoxController refundFromController = JPInputBoxController();
  JPInputBoxController receiptDateController = JPInputBoxController(
      text: DateTimeHelper.format(DateTimeHelper.now().toString(), DateFormatConstants.dateOnlyFormat));
  JPInputBoxController addressController = JPInputBoxController();

  List<JPSingleSelectModel> refundFromList = [];
  List<AccountingHeadModel> refunds = [];
  List<JPSingleSelectModel> paymentMethods = [];
  List<SheetLineItemModel> refundItems = [];

  JPSingleSelectModel selectedRefundFrom = JPSingleSelectModel(label: '', id: '-1');
  JPSingleSelectModel? selectedPaymentMethod;

  Map<String,dynamic> initialJson = {};

  double totalPrice = 0.0;

  String note = '';

  Map<String,dynamic> createRefundFormJson(String customerId, String jobId) {

    Map<String,dynamic> params = {};
    params['customer_id'] = customerId;
    params['job_id'] = jobId;
    params['refund_date'] = DateTimeHelper.convertSlashIntoHyphen(receiptDateController.text.toString());
    params['financial_account_id'] = selectedRefundFrom.id.toString();

    for(int i = 0; i < refundItems.length; i++) {
      final item = refundItems[i];
      params['lines[$i][rate]'] = item.price;
      params['lines[$i][quantity]'] = item.qty;
      params['lines[$i][description]'] = item.title;
      params['lines[$i][financial_product_id]'] = item.productId;
    }

    if(selectedPaymentMethod?.id != '-1') {
      params['payment_method'] = selectedPaymentMethod?.id;
    }
    params['note'] = note;
    if(addressController.text.isNotEmpty) {
      params['address'] = addressController.text.toString();
    }
    return params;
  }
}