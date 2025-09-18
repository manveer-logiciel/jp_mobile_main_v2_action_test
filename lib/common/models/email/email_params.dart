import 'package:jobprogress/common/models/attachment.dart';

class EmailListingParamModel {
  String? keyword;
  int? limit;
  late int page;
  int? users;
  int? labelId;
  bool? withReply;
  int? jobId;
  int? customerId;
  List<AttachmentResourceModel>? attachments;
  EmailListingParamModel({
    this.limit = 20,
    this.page = 1,
    this.withReply = true,
    this.keyword,
    this.labelId,
    this.attachments,
    this.users,
    this.jobId,
    this.customerId
  });

  EmailListingParamModel.fromJson(Map<String, dynamic> json) {
    keyword = json['keyword'];
    labelId = json['label_id'];
    limit = json['limit'];
    page = json['page'];
    withReply = json['with_reply'];
    users = json['users'];
    jobId = json['job_id'];
    customerId = json['customer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['keyword'] = keyword;
    data['label_id'] = labelId;
    data['limit'] = limit;
    data['page'] = page;

    if(withReply != null) {
      data['with_reply'] = withReply! ? 1 : 0;
    }

    data['users'] = users;
    data['job_id'] = jobId;
    data['customer_id'] = customerId;
    return data;
  }
}
