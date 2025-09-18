
class ProposalShareEmail {
  String? subject;
  String? content;
  String? shareUrl;
  int? newFormat;

  ProposalShareEmail({this.subject, this.content, this.shareUrl, this.newFormat});

  ProposalShareEmail.fromJson(Map<String, dynamic> json) {
    subject = json["subject"];
    content = json["content"];
    shareUrl = json["share_url"];
    newFormat = json["new_format"];
  }

}