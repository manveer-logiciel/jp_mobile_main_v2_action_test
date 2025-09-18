
class LicenseDetail {
  int? id;
  int? position;
  String? number;
  

  LicenseDetail({
    this.id, 
    this.position,  
    this.number,
  });

  LicenseDetail.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    position = json["position"];
    number = json["number"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["id"] = id;
    data["position"] = position;
    data["number"] = number;
    return data;
  }
}
