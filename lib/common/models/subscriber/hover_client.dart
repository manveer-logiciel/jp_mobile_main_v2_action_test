
class HoverClient {
  int? id;
  int? ownerId;
  int? hoverUserId;
  String? hoverUserFirstName;
  String? hoverUserLastName;
  String? hoverUserEmail;

  HoverClient({this.id, this.ownerId, this.hoverUserId, this.hoverUserFirstName, this.hoverUserLastName, this.hoverUserEmail});

  HoverClient.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    ownerId = json["owner_id"];
    hoverUserId = json["hover_user_id"];
    hoverUserFirstName = json["hover_user_first_name"];
    hoverUserLastName = json["hover_user_last_name"];
    hoverUserEmail = json["hover_user_email"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["id"] = id;
    data["owner_id"] = ownerId;
    data["hover_user_id"] = hoverUserId;
    data["hover_user_first_name"] = hoverUserFirstName;
    data["hover_user_last_name"] = hoverUserLastName;
    data["hover_user_email"] = hoverUserEmail;
    return data;
  }
}
