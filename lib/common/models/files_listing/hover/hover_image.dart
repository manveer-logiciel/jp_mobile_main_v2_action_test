class HoverImage {
  int? id;
  int? hoverJobId;
  int? companyId;
  String? url;

  HoverImage({this.id, this.hoverJobId, this.companyId, this.url});

  HoverImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hoverJobId = json['hover_job_id'];
    companyId = json['company_id'];
    url = json['url'];
  }

}
