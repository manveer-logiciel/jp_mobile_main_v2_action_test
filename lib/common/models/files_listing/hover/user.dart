
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class HoverUserModel {

  int? id;
  String? firstName;
  String? fullName;
  String? lastName;
  String? email;
  String? aasmState;
  String? aclTemplate;

  HoverUserModel({
    required this.id,
    required this.firstName,
    this.lastName,
    this.email,
    this.aasmState,
    this.aclTemplate,
    this.fullName
  });

  HoverUserModel.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    fullName = "${firstName ?? ""} ${lastName ?? ""}";
    email = json['email'];
    aasmState = json['aasm_state'];
    aclTemplate = json['acl_template'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['aasm_state'] = aasmState;
    data['acl_template'] = aclTemplate;
    return data;
  }

  JPSingleSelectModel toSingleSelectModel() {
    return JPSingleSelectModel(
      label: "${firstName ?? ""} ${lastName ?? ""}",
      id: id.toString(),
    );
  }
}