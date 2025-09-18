class JobInvoices {

  String? amount;
  String? createdAt;
  int? customerId;
  String? date;
  String? description;
  String? dueDate;
  String? filePath;
  String? fileSize;
  int? id;
  String? invoiceNumber;
  int? jobId;
  String? lastUpdatedOrigin;
  String? name;
  String? note;
  String? openBalance;
  String? origin;
  String? proposalId;
  String? qbDesktopId;
  String? quickbookInvoiceId;
  String? quickbookSyncStatus;
  String? signature;
  String? status;
  String? taxRate;
  String? taxableAmount;
  String? title;
  double? totalAmount;
  String? type;
  String? unitNumber;
  String? updatedAt;

  JobInvoices({
    this.amount,
    this.createdAt,
    this.customerId,
    this.date,
    this.description,
    this.dueDate,
    this.filePath,
    this.fileSize,
    this.id,
    this.invoiceNumber,
    this.jobId,
    this.lastUpdatedOrigin,
    this.name,
    this.note,
    this.openBalance,
    this.origin,
    this.proposalId,
    this.qbDesktopId,
    this.quickbookInvoiceId,
    this.quickbookSyncStatus,
    this.signature,
    this.status,
    this.taxRate,
    this.taxableAmount,
    this.title,
    this.totalAmount,
    this.type,
    this.unitNumber,
    this.updatedAt,
  });

  JobInvoices.fromJson(Map<String, dynamic> json) {
    amount = json['amount']?.toString();
    createdAt = json['created_at']?.toString();
    customerId = int.tryParse(json['customer_id']?.toString() ?? '');
    date = json['date']?.toString();
    description = json['description']?.toString();
    dueDate = json['due_date']?.toString();
    filePath = json['file_path']?.toString();
    fileSize = json['file_size']?.toString();
    id = int.tryParse(json['id']?.toString() ?? '');
    invoiceNumber = json['invoice_number']?.toString();
    jobId = int.tryParse(json['job_id']?.toString() ?? '');
    lastUpdatedOrigin = json['last_updated_origin']?.toString();
    name = json['name']?.toString();
    note = json['note']?.toString();
    openBalance = json['open_balance']?.toString();
    origin = json['origin']?.toString();
    proposalId = json['proposal_id']?.toString();
    qbDesktopId = json['qb_desktop_id']?.toString();
    quickbookInvoiceId = json['quickbook_invoice_id']?.toString();
    quickbookSyncStatus = json['quickbook_sync_status']?.toString();
    signature = json['signature']?.toString();
    status = json['status']?.toString();
    taxRate = json['tax_rate']?.toString();
    taxableAmount = json['taxable_amount']?.toString();
    title = json['title']?.toString();
    totalAmount = double.tryParse(json['total_amount']?.toString() ?? '');
    type = json['type']?.toString();
    unitNumber = json['unit_number']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['amount'] = amount;
    data['created_at'] = createdAt;
    data['customer_id'] = customerId;
    data['date'] = date;
    data['description'] = description;
    data['due_date'] = dueDate;
    data['file_path'] = filePath;
    data['file_size'] = fileSize;
    data['id'] = id;
    data['invoice_number'] = invoiceNumber;
    data['job_id'] = jobId;
    data['last_updated_origin'] = lastUpdatedOrigin;
    data['name'] = name;
    data['note'] = note;
    data['open_balance'] = openBalance;
    data['origin'] = origin;
    data['proposal_id'] = proposalId;
    data['qb_desktop_id'] = qbDesktopId;
    data['quickbook_invoice_id'] = quickbookInvoiceId;
    data['quickbook_sync_status'] = quickbookSyncStatus;
    data['signature'] = signature;
    data['status'] = status;
    data['tax_rate'] = taxRate;
    data['taxable_amount'] = taxableAmount;
    data['title'] = title;
    data['total_amount'] = totalAmount;
    data['type'] = type;
    data['unit_number'] = unitNumber;
    data['updated_at'] = updatedAt;
    return data;
  }
}
