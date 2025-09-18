import 'package:flutter/foundation.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/InputBox/controller.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';
import '../../../../core/utils/date_time_helpers.dart';
import '../../attachment.dart';
import '../../job_financial/financial_listing.dart';

class BillFormData {

  BillFormData({
    required this.update,
  });

  final VoidCallback update; // update method from respective controller to refresh ui from service itself
  Map<String,dynamic> initialJson = {};

  JPInputBoxController vendorController = JPInputBoxController();
  JPInputBoxController billNumberController = JPInputBoxController();
  JPInputBoxController billDateController = JPInputBoxController();
  JPInputBoxController dueDateController = JPInputBoxController();
  JPInputBoxController addressController = JPInputBoxController();

  JPSingleSelectModel? selectVendor;

  List<SheetLineItemModel> billItems = [];
  List<AttachmentResourceModel> attachments = [];
  List<AttachmentResourceModel> uploadedAttachments = [];
  List<JPSingleSelectModel> accountingHeads = [];

  String note = '';

  int? billId;
  int jobId = 0;

  double totalPrice = 0;

  Map<String,dynamic> createBillFormJson() {

    Map<String,dynamic> params = {};
    params['job_id'] = jobId;
    params['bill_date'] = DateTimeHelper.convertSlashIntoHyphen(billDateController.text.toString());
    params['due_date'] = DateTimeHelper.convertSlashIntoHyphen(dueDateController.text.toString());

    if(note.isNotEmpty) {
      params['note'] = note;
    }

    params['bill_number'] = billNumberController.text.toString();
    params['address'] = addressController.text.toString();
    params['vendor_id'] = selectVendor?.id ?? CommonConstants.noneId;

    for(int i =0; i<billItems.length; i++) {
      final SheetLineItemModel itemModel = billItems[i];
      params['lines[$i][total]'] = itemModel.totalPrice;
      params['lines[$i][rate]'] = itemModel.price;
      params['lines[$i][description]'] = itemModel.title;
      params['lines[$i][quantity]'] = itemModel.qty;
      params['lines[$i][financial_account_id]'] = itemModel.productId;
    }

    // Attachments section
    if(attachments.isNotEmpty || uploadedAttachments.isNotEmpty) {

      List<AttachmentResourceModel> attachmentsToUpload = [];
      List<AttachmentResourceModel> attachmentsToDelete = [];

      attachmentsToUpload = attachments.where((attachment) => !uploadedAttachments.contains(attachment)).toList();
      attachmentsToDelete = uploadedAttachments.where((attachment) => attachments.isEmpty || !attachments.contains(attachment)).toList();

      params['attachments'] = attachmentsToUpload.map((attachment) => {
        'type': attachment.type ?? "resource",
        'value': attachment.id,
      }).toList();

      params['delete_attachments[]'] = attachmentsToDelete.map((attachment) => attachment.id).toList();
    }

    return params;
  }

  void setFormData(FinancialListingModel listingModel) {
    if(!Helper.isValueNullOrEmpty(listingModel.vendorId)) {
      selectVendor = JPSingleSelectModel(
        label: listingModel.vendorName ?? '', 
        id: listingModel.vendorId ?? ''
      );
      vendorController.text = selectVendor?.label ?? '';
    }
    billNumberController.text = listingModel.billNumber ?? '';
    billDateController.text = listingModel.date ?? '';
    dueDateController.text = listingModel.dueDate ?? '';
    addressController.text = listingModel.address ?? '';
    note = listingModel.note ?? '';
    for (SheetLineItemModel element in listingModel.lines ?? []) {
      element.pageType = AddLineItemFormType.billForm;
    }
    billItems = listingModel.lines ?? [];

    // setting up attachment section
    uploadedAttachments.addAll(listingModel.attachments ?? []);
    attachments.addAll(uploadedAttachments);

    billId = listingModel.id;
  }

  bool checkIfNewDataAdded() {
    final currentJson = createBillFormJson();
    return initialJson.toString() != currentJson.toString();
  }
}