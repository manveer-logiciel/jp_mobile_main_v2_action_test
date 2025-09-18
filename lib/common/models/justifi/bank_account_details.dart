class JustifiBankAccountDetails {
  String? id;
  String? accountOwnerName;
  String? accountType;
  String? bankName;
  String? acctLastFour;
  String? token;
  String? metadata;

  JustifiBankAccountDetails({
    this.id,
    this.accountOwnerName,
    this.accountType,
    this.bankName,
    this.acctLastFour,
    this.token,
    this.metadata,
  });

  JustifiBankAccountDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accountOwnerName = json['account_owner_name'];
    accountType = json['account_type'];
    bankName = json['bank_name'];
    acctLastFour = json['acct_last_four'];
    token = json['token'];
    metadata = json['metadata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['account_owner_name'] = accountOwnerName;
    data['account_type'] = accountType;
    data['bank_name'] = bankName;
    data['acct_last_four'] = acctLastFour;
    data['token'] = token;
    data['metadata'] = metadata;
    return data;
  }
}
