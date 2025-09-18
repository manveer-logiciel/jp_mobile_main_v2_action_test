class CustomerRep {

  bool? isAllDivisionsAccess;
  String? color;
  String? companyName;
  String? email;
  String? firstName;
  String? fullName;
  String? fullNameMobile;
  int? groupId;
  int? id;
  String? lastName;
  String? paidCommission;
  String? profilePic;
  String? status;
  String? totalCommission;
  String? unpaidCommission;

  CustomerRep({
    this.isAllDivisionsAccess,
    this.color,
    this.companyName,
    this.email,
    this.firstName,
    this.fullName,
    this.fullNameMobile,
    this.groupId,
    this.id,
    this.lastName,
    this.paidCommission,
    this.profilePic,
    this.status,
    this.totalCommission,
    this.unpaidCommission,
  });

  CustomerRep.fromJson(Map<String, dynamic> json) {
    isAllDivisionsAccess = json['all_divisions_access'];
    color = json['color']?.toString();
    companyName = json['company_name']?.toString();
    email = json['email']?.toString();
    firstName = json['first_name']?.toString();
    fullName = json['full_name']?.toString();
    fullNameMobile = json['full_name_mobile']?.toString();
    groupId = json['group_id']?.toInt();
    id = json['id']?.toInt();
    lastName = json['last_name']?.toString();
    paidCommission = json['paid_commission']?.toString();
    profilePic = json['profile_pic']?.toString();
    status = json['status']?.toString();
    totalCommission = json['total_commission']?.toString();
    unpaidCommission = json['unpaid_commission']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['all_divisions_access'] = isAllDivisionsAccess;
    data['color'] = color;
    data['company_name'] = companyName;
    data['email'] = email;
    data['first_name'] = firstName;
    data['full_name'] = fullName;
    data['full_name_mobile'] = fullNameMobile;
    data['group_id'] = groupId;
    data['id'] = id;
    data['last_name'] = lastName;
    data['paid_commission'] = paidCommission;
    data['profile_pic'] = profilePic;
    data['status'] = status;
    data['total_commission'] = totalCommission;
    data['unpaid_commission'] = unpaidCommission;
    return data;
  }
}