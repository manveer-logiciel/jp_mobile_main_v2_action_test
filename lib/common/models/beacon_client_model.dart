class BeaconClientModel {

  int? id;
  String? refreshExpiryDateTime;
  String? email;

  BeaconClientModel({
      this.id, 
      this.refreshExpiryDateTime, 
      this.email
      });

  BeaconClientModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    refreshExpiryDateTime = json['refresh_expiry_date_time'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['refresh_expiry_date_time'] = refreshExpiryDateTime;
    map['email'] = email;
    return map;
  }

}