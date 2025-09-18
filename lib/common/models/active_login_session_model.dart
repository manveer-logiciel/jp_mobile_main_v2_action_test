
class ActiveLoginSessionModel {
  int? id;
  int? userId;
  int? authSessionId;
  String? deviceId;
  String? deviceType;
  String? os;
  String? platform;
  String? ip;
  String? lastActivityAt;
  String? userAgent;
  String? lat;
  String? long;

  ActiveLoginSessionModel({
      this.id, 
      this.userId, 
      this.authSessionId, 
      this.deviceId, 
      this.deviceType, 
      this.os, 
      this.platform, 
      this.ip, 
      this.lastActivityAt, 
      this.userAgent, 
      this.lat, 
      this.long
  });

  ActiveLoginSessionModel.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    authSessionId = json['auth_session_id'];
    deviceId = json['device_id'];
    deviceType = json['device_type'];
    os = json['os'];
    platform = json['platform'];
    ip = json['ip'];
    lastActivityAt = json['last_activity_at'];
    userAgent = json['user_agent'];
    lat = json['lat']?.toString();
    long = json['long']?.toString();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['auth_session_id'] = authSessionId;
    map['device_id'] = deviceId;
    map['device_type'] = deviceType;
    map['os'] = os;
    map['platform'] = platform;
    map['ip'] = ip;
    map['last_activity_at'] = lastActivityAt;
    map['user_agent'] = userAgent;
    map['lat'] = lat;
    map['long'] = long;
    return map;
  }

}