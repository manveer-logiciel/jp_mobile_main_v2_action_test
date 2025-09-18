class JobMetaModel {
  String? resourceId;
  String? defaultPhotoDir;
  String? companyCamId;

  JobMetaModel({this.resourceId, this.defaultPhotoDir, this.companyCamId});

  JobMetaModel.fromJson(Map<String, dynamic> json) {
    resourceId = json['resource_id'];
    defaultPhotoDir = json['default_photo_dir'];
    companyCamId = json['company_cam_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resource_id'] = resourceId;
    data['default_photo_dir'] = defaultPhotoDir;
    data['company_cam_id'] = companyCamId;
    return data;
  }
}
