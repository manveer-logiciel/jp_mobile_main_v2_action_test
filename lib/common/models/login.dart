import 'package:jobprogress/core/constants/login.dart';

class LoginModel {
  late String username;
  late String password;
  String? grantType;
  String? clientId;
  String? clientSecret;
  String? uuid;
  String? appVersion;
  String? platform;
  String? manufacturer;
  String? osVersion;
  String? model;

  LoginModel({
    required this.username,
    required this.password,
    this.grantType = LoginConstants.grantType,
    this.clientId = LoginConstants.clientId,
    this.clientSecret = LoginConstants.clientSecret,
    this.uuid,
    this.appVersion,
    this.platform,
    this.manufacturer,
    this.osVersion,
    this.model
  });

  LoginModel.fromJson(Map<String, dynamic> map) {
    username = map['username'];
    password = map['password'];
    grantType = map['grantType'];
    clientId = map['clientId'];
    clientSecret = map['clientSecret'];
    uuid = map['uuid'];
    appVersion = map['appVersion'];
    platform = map['platform'];
    manufacturer = map['manufacturer'];
    model = map['model'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    data['grant_type'] = grantType;
    data['client_id'] = clientId;
    data['client_secret'] = clientSecret;
    data['uuid'] = uuid;
    data['app_version'] = appVersion;
    data['platform'] = platform;
    data['manufacturer'] = manufacturer;
    data['os_version'] = osVersion;
    data['model'] = model;
    return data;
  }
}