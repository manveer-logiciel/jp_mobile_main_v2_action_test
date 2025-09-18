import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/enums/unsaved_resource_type.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_financial/tax_model.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/suppliers/beacon/job.dart';
import 'package:jobprogress/common/models/suppliers/srs/srs_ship_to_address.dart';
import 'package:jobprogress/common/models/suppliers/branch.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

import '../../enums/sheet_line_item_type.dart';
import '../job/job_invoices.dart';
import '../sheet_line_item/sheet_line_item_model.dart';
import '../sql/division/division.dart';
import '../suppliers/beacon/account.dart';
import '../suppliers/suppliers.dart';

class FinancialListingModel {
  String? origin;
  String? qbDesktopId;
  String? quickbookId;
  String? financialAccountName;
  String? billNumber;
  String? title;
  String? vendorName;
  String? vendorId;
  String? address;
  String? dueDate;
  num? amount;
  String? description;
  String? url;
  String? totalAmount;
  String? openBalance;
  String? taxableAmount;
  String? proposalUrl;
  int? size;
  String? qbInvoiceId;
  String? type;
  String? name;
  String? unitNumber;
  int? proposalId;
  int? invoiceId;
  int? quickBookSyncStatus;
  String? invoiceNumber;
  String? unAppliedAmount;
  String? invoiceNo;
  String? note;
  int? taxAmount;
  late bool taxable = false;
  String? taxRate;
  String? canceled;
  num? invoiceTotalAmount;
  int? order;
  String? createdAt;
  String? method;
  String? date;
  String? updatedAt;
  String? echequeNumber;
  String? dueAmount;
  String? cancelNote;
  int ? refTo;
  int? id;
  int? unsavedResourceId;
  JobModel? refJob;
  String? createdBy;
  String? status;
  UserLimitedModel? paidTo;
  FinancialListingModel? transferToPayment;
  FinancialListingModel? transferFromPayment;
  List<AttachmentResourceModel>? attachments;
  List<SheetLineItemModel>? lines;

  String? invoiceNote;
  int? divisionId;
  DivisionModel? division;
  JobInvoices? invoices;
  TaxModel? customTax;
  SrsShipToAddressModel? srsShipToAddressModel;
  SupplierBranchModel? supplierBranch;
  String? paymentStatus;
  bool? isLeapPayPayment;
  MaterialSupplierType? supplierType;
  String? beaconJobNumber;
  String? beaconAccountId;
  BeaconJobModel? beaconJob;
  BeaconAccountModel? beaconAccountModel;
  bool? isAcceptingLeapPay;
  bool? isFeePassoverEnabled;
  String? defaultPaymentMethod;
  List<SuppliersModel>? suppliers;
  SrsShipToAddressModel? abcAccountModel;


  FinancialListingModel({
    this.totalAmount,
    this.unAppliedAmount,
    this.attachments,
    this.billNumber,
    this.vendorName,
    this.description,
    this.title,
    this.dueAmount,
    this.taxAmount,
    this.origin,
    this.financialAccountName,
    this.quickBookSyncStatus,
    this.qbDesktopId,
    this.quickbookId,
    this.taxableAmount,
    this.invoiceTotalAmount,
    this.openBalance,
    this.proposalUrl,
    this.name,
    this.unitNumber,
    this.amount,
    this.url,
    this.qbInvoiceId,
    this.invoiceId,
    this.proposalId,
    this.invoiceNumber,
    this.taxRate,
    this.invoiceNo,
    this.taxable = false,
    this.canceled,
    this.order,
    this.createdAt,
    this.method,
    this.date,
    this.updatedAt,
    this.id,
    this.echequeNumber,
    this.cancelNote,
    this.refTo,
    this.refJob,
    this.status,
    this.transferToPayment,
    this.transferFromPayment,
    this.vendorId,
    this.dueDate,
    this.address,
    this.invoiceNote,
    this.divisionId,
    this.division,
    this.invoices,
    this.customTax,
    this.srsShipToAddressModel,
    this.supplierBranch,
    this.isLeapPayPayment,
    this.suppliers
  });

  FinancialListingModel.fromChangeOrderJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    taxable = json['taxable'] == 0 ? false : true;
    taxRate = json['tax_rate']?.toString();
    totalAmount = json['total_amount'].toString();
    if(json['invoice']?['total_amount'] != null){
      invoiceTotalAmount = json['invoice']['total_amount'];
    }
    canceled = json['canceled'];
    order = int.tryParse(json['order']?.toString() ?? '');
    invoiceId = int.tryParse(json['invoice_id']?.toString() ?? '');
    invoiceNote = json['invoice_note']?.toString();
    name = json['name']?.toString();
    unitNumber = json['unit_number']?.toString();
    divisionId = int.tryParse(json['division_id']?.toString() ?? '');
    taxableAmount = json['taxable_amount']?.toString();
    invoices = (json['invoice'] != null && (json['invoice'] is Map))
        ? JobInvoices.fromJson(json["invoice"]) : null;
    if (json['entities'] != null) {
      lines = <SheetLineItemModel>[];
      json['entities'].forEach((dynamic value) {
        lines!.add(SheetLineItemModel.fromChangeOrderJson(value)..pageType = AddLineItemFormType.changeOrderForm);
      });
    }
    division = (json['division'] != null && (json['division'] is Map))
        ? DivisionModel.fromApiJson(json["division"]) : null;
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    customTax = (json["custom_tax"] != null && (json["custom_tax"] is Map))
        ? TaxModel.fromJson(json["custom_tax"])
        : null;
    supplierBranch = (json["branch"] != null && (json["branch"] is Map))
        ? SupplierBranchModel.fromJson(json["branch"])
        : null;
    beaconJobNumber = json['beacon_job_number']?.toString();
    beaconAccountId = json['beacon_account_id']?.toString();
    beaconJob = json['beacon_job'] is Map ? BeaconJobModel.fromJson(json['beacon_job']) : null;
    isAcceptingLeapPay = json['invoice']?['leap_pay_enabled'] == null ? true : Helper.isTrue(json['invoice']?['leap_pay_enabled']);
    isFeePassoverEnabled = Helper.isTrue(json['invoice']?['fee_passover_enabled']);
    defaultPaymentMethod = json['invoice']?["payment_method"];
    if (json['suppliers']?['data'] != null && (json['suppliers']?['data'] is List)) {
      suppliers = <SuppliersModel>[];
      json['suppliers']['data'].forEach((dynamic v) {
        suppliers!.add(SuppliersModel.fromJson(v)) ;
      });
    }
    setSupplier(json);
  }

  FinancialListingModel.fromPaymentsReceivedJson(Map<String, dynamic> json) {
    id = json['id'];
    cancelNote = json['cancel_note'];
    canceled = json['canceled'];
    method = json['method'];
    totalAmount = json['payment'];
    date = json['date'];
    updatedAt = json['updated_at'];
    echequeNumber = json['echeque_number'];
    refTo = json['ref_to'];
    paymentStatus = canceled ?? json['leap_pay_status'];
    isLeapPayPayment = json['leap_pay_payment_id'] != null;
    refJob = json['ref_job'] != null ?  JobModel.fromFinancialJson(json['ref_job']) : null;
    transferToPayment = json['transfer_to_payment'] != null ? FinancialListingModel.fromPaymentsReceivedJson(json['transfer_to_payment']) : null;
    transferFromPayment = json['transfer_from_payment'] != null ?FinancialListingModel.fromPaymentsReceivedJson(json['transfer_from_payment']) : null;
  }

  FinancialListingModel.fromJobPriceHistoryJson(Map<String, dynamic> json) {
    id = json['id'];
    totalAmount = json['amount'];
    date = json['created_at'];
    taxable = json['taxable'] == 0 ? false : true;
    taxRate = json['tax_rate']?.toString();
    createdBy = json['created_by']['full_name'];
  }
  FinancialListingModel.fromCreditsJson(Map<String, dynamic> json){
    id = json['id'];
    date = json['date'];
    totalAmount = json['amount'];
    unAppliedAmount = json['unapplied_amount'];
    if(json['invoice'] != null && json['invoice']['data'].length != 0){
      invoiceNo = '${'invoice'.tr.toUpperCase()} #: ' + json['invoice']['data'][0]['number'] ;
    }
    if(json['invoice'] != null && json['invoice']['data'].length != 0){
      invoiceId = json['invoice']['data'][0]['id'];
    }
    note = json['note'];
    canceled = json['canceled'];
  }

  FinancialListingModel.fromRefundsJson(Map<String, dynamic> json){
    id = json['id'];
    date = json['refund_date'];
    totalAmount = json['total_amount'].toString();
    canceled = json['canceled_at'];
    method = json['payment_method'];
    url = json['file_path'];
    origin = json['origin'];
    qbDesktopId = json['qb_desktop_id'];
    quickBookSyncStatus = json['quickbook_sync_status'];
    quickbookId = json['quickbook_id'].toString();
    financialAccountName = json['financial_account']['name'];
  }

  FinancialListingModel.fromAccountsPayableJson(Map<String, dynamic> json) {
    id = json['id'];
    totalAmount = json['total_amount'].toString();
    date = json['bill_date'];
    billNumber = json['bill_number'];
    origin = json['origin'];
    qbDesktopId = json['qb_desktop_id'];
    quickBookSyncStatus = json['quickbook_sync_status'];
    taxAmount = json['tax_amount'];
    quickbookId = json['quickbook_id'].toString();
    vendorName = json['vendor']['display_name'];
    vendorId = json['vendor']['id'].toString();
    dueDate = json['due_date'];
    address = json['address'];
    note = json['note'];
    if(json['file_path'] != null){
      url = json['file_path'];
    }
    if (json['attachments'] != null) {
      attachments = <AttachmentResourceModel>[];
      json['attachments']['data'].forEach((dynamic v) {
        attachments!.add(AttachmentResourceModel.fromJson(v));
      });
    }
    if (json['lines'] != null) {
      lines = <SheetLineItemModel>[];
      json['lines']['data'].forEach((dynamic v) {
        lines!.add(SheetLineItemModel.fromJson(v));
      });
    }
  }

  FinancialListingModel.fromJobInvoicesJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    updatedAt = json['updated_at'];
    title = json['title'];
    createdAt = json['created_at'];
    invoiceNumber = json['invoice_number'];
    taxableAmount = json['taxable_amount']?.toString();
    unitNumber = json['unit_number'];
    date = json['date'];
    dueDate = json["due_date"];
    size = int.parse(json['file_size'].toString());
    totalAmount = json['amount'];
    openBalance = json['open_balance'];
    invoiceTotalAmount = json['total_amount'];
    proposalId = int.tryParse(json['proposal_id'].toString());
    if(json['proposal'] != null) {
      proposalUrl = json['proposal']?['file_path'];
    } else {
      proposalUrl = json['file_path'];
    }
    qbInvoiceId  = json['quickbook_invoice_id'];
    quickBookSyncStatus = json['quickbook_sync_status'];
    type = json['type'];
    url = json['file_path'];
    status = json['status'];
    taxable = Helper.isTrue(json['taxable']);
    final parsedTextRate = double.tryParse(json['tax_rate'].toString());
    taxRate = (parsedTextRate?.isFinite ?? false) ? parsedTextRate?.toString() : null;
    totalAmount = json['total_amount'].toString();
    invoiceNote = json['note']?.toString();
    if (json['lines']?["data"] != null) {
      lines = <SheetLineItemModel>[];
      json['lines']["data"].forEach((dynamic value) {
        lines!.add(SheetLineItemModel.fromChangeOrderJson(value)..pageType = AddLineItemFormType.changeOrderForm);
      });
    }
    division = (json['division'] is Map) ? DivisionModel.fromApiJson(json["division"]) : null;
    customTax = (json["custom_tax"] is Map) ? TaxModel.fromJson(json["custom_tax"]) : null;
    if(json['financial_details'] is Map) FinancialListingModel.fromAccountsPayableJson(json['financial_details']);
    supplierBranch = (json["branch"] != null && (json["branch"] is Map))
        ? SupplierBranchModel.fromJson(json["branch"])
        : null;
    beaconJobNumber = json['beacon_job_number']?.toString();
    beaconAccountId = json['beacon_account_id']?.toString();
    beaconJob = json['beacon_job'] is Map ? BeaconJobModel.fromJson(json['beacon_job']) : null;
    unsavedResourceId = json["unsaved_resource_id"];
    isAcceptingLeapPay = json['leap_pay_enabled'] == null ? true : Helper.isTrue(json['leap_pay_enabled']);
    isFeePassoverEnabled = json['fee_passover_enabled'] == null ? false : Helper.isTrue(json['fee_passover_enabled']);
    defaultPaymentMethod = json["payment_method"];
    if (json['suppliers']?['data'] != null && (json['suppliers']?['data'] is List)) {
      suppliers = <SuppliersModel>[];
      json['suppliers']['data'].forEach((dynamic v) {
        suppliers!.add(SuppliersModel.fromJson(v)) ;
      });
    }
    setSupplier(json);
  }

  FinancialListingModel.fromCommissionJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    description = json['description'];
    dueAmount = json['due_amount'];
    totalAmount = json['amount'];
    paidTo = json['user'] != null ? UserLimitedModel.fromJson(json['user']) : null;
    canceled = json['canceled_at'];
    status = json['status'];
  }

  FinancialListingModel.fromCommissionPaymentJson(Map<String, dynamic> json) {
    id = json['id'];
    totalAmount = json['amount'];
    canceled = json['canceled_at'];
    date = json['paid_on'];
  }

  FinancialListingModel.fromUnsavedResourcedJson(Map<String, dynamic> data, UnsavedResourceType type) {
    unsavedResourceId = data['id'];
    Map<String, dynamic> temp = json.decode(data['data']);
    id = temp["order_id"];
    date = temp["date"];
    dueDate = temp["due_date"];
    invoices = JobInvoices(date: temp["date"], dueDate: temp["due_date"]);
    customTax = TaxModel(id: int.tryParse(temp["custom_tax_id"]?.toString() ?? ""));
    taxable = Helper.isTrue(temp["taxable"] ?? temp["is_taxable"]);
    division = DivisionModel(id: temp["division_id"], companyId: -1, name: "");
    taxRate = temp["tax_rate"]?.toString();
    invoiceNote = temp["invoice_note"]?.toString();
    unitNumber = temp["unit_number"]?.toString();
    totalAmount = temp["total_price"]?.toString() ?? getTotalFromOldJson(temp['entities']);
    createdAt = data["created_at"];
    updatedAt = data["updated_at"];
    name = temp["name"]?.toString();

    switch(type) {
      case UnsavedResourceType.changeOrder:
        if (temp['entities'] != null) {
          lines = <SheetLineItemModel>[];
          temp['entities'].forEach((dynamic value) => lines!.add(SheetLineItemModel.fromChangeOrderJson(value)..pageType = AddLineItemFormType.changeOrderForm));
        }
        break;
      case UnsavedResourceType.invoice:
        status = 'open';
        taxableAmount = temp['taxable_amount']?.toString();
        invoiceTotalAmount = num.parse(temp['total_price']?.toString() ?? "");
        if (temp['lines'] != null) {
          lines = <SheetLineItemModel>[];
          temp['lines'].forEach((dynamic value) => lines!.add(SheetLineItemModel.fromChangeOrderJson(value)..pageType = AddLineItemFormType.changeOrderForm));
        }
        break;
      default:
        break;
    }

  }

  String getTotalFromOldJson(dynamic temp) {
    num total = 0;
    if (temp != null) {
      lines = <SheetLineItemModel>[];
      temp.forEach((dynamic value) => lines!.add(SheetLineItemModel.fromChangeOrderJson(value)..pageType = AddLineItemFormType.changeOrderForm));
      for (var element in lines!) {
        total = total + num.parse(element.totalPrice ?? "0");
      }
    }
    return total.toString();
  }


  Map<String, dynamic> toJobInvoiceJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id ;
    data['name']= name ;
    data['updated_at']= updatedAt;
    data['created_at']= createdAt;
    data['invoice_number'] = invoiceNumber ;
    data['taxable_amount'] = taxableAmount;
    data['unit_number'] =  unitNumber ;
    data['title'] = title;
    data['date']= date ;
    data['file_size'] = size.toString() ;
    data['amount']= totalAmount ;
    data['open_balance']= openBalance ;
    data['tax_rate']= taxRate;
    data['total_amount']= invoiceTotalAmount;
    data['proposal_id']= proposalId;
    data['proposal_share_url'] = proposalUrl;
    data['quickbook_invoice_id'] = qbInvoiceId ;
    data['quickbook_sync_status'] = quickBookSyncStatus;
    data['type'] =type;
    data['file_path'] = url;
    data['payment_method'] = defaultPaymentMethod;
    data['leap_pay_enabled'] = Helper.isTrueReverse(isAcceptingLeapPay);
    data['fee_passover_enabled'] = Helper.isTrueReverse(isFeePassoverEnabled);
    return data;
  }

  String getPaymentStatus() {
    if (canceled != null) {
      return "cancelled".tr;
    }
    switch (paymentStatus) {
      case "pending":
        return "pending".tr;
      default:
        return "success".tr;
    }
  }

  Color getPaymentStatusColor() {
    if (canceled != null) {
      return JPAppTheme.themeColors.red;
    }
    switch (paymentStatus) {
      case "pending":
        return JPAppTheme.themeColors.warning;
      default:
        return JPAppTheme.themeColors.success;
    }
  }

  /// [setSupplier] Sets the worksheet supplier based on the provided JSON data.
  void setSupplier(Map<String, dynamic> json) {
    if (json["srs_ship_to_address"] is Map) {
      supplierType = MaterialSupplierType.srs;
      srsShipToAddressModel = SrsShipToAddressModel.fromJson(json["srs_ship_to_address"]);
    } else if (json["beacon_account"] is Map) {
      supplierType = MaterialSupplierType.beacon;
      beaconAccountModel = BeaconAccountModel.fromJson(json["beacon_account"]);
    } else if(json['supplier_account'] is Map) {
      supplierType = MaterialSupplierType.abc;
      abcAccountModel = SrsShipToAddressModel.fromJson(json["supplier_account"]);
    } else if(Helper.isSupplierHaveABCItem(suppliers) && json["supplier_account_id"] != null) {
      supplierType = MaterialSupplierType.abc;
      abcAccountModel =SrsShipToAddressModel(shipToId: json["supplier_account_id"]?.toString());
    } else {
      supplierType = null;
      srsShipToAddressModel = null;
      beaconAccountModel = null;
      abcAccountModel = null;
    }

  }
}