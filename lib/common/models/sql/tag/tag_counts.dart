class TagCounts {
  int? totalUserCount;
  int? userCount;
  int? subUserCount;
  int? companyContactCount;

  TagCounts(
      {this.totalUserCount,
      this.userCount,
      this.subUserCount,
      this.companyContactCount});

  TagCounts.fromJson(Map<String, dynamic> json) {
    totalUserCount = json['total_user_count'];
    userCount = json['user_count'];
    subUserCount = json['sub_user_count'];
    companyContactCount = json['company_contact_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_user_count'] = totalUserCount;
    data['user_count'] = userCount;
    data['sub_user_count'] = subUserCount;
    data['company_contact_count'] = companyContactCount;
    return data;
  }
}
