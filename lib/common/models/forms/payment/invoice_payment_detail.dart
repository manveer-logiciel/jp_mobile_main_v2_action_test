class InvoicePaymentDetailModel {
  String? amount;
  String? invoiceId;

  InvoicePaymentDetailModel({
    this.invoiceId,
    this.amount,
  });

  InvoicePaymentDetailModel.fromJson(Map<String, dynamic> json) {
    invoiceId = json['invoice_id'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['invoice_id'] = invoiceId;
    data['amount'] = amount;
    return data;
  }
}
