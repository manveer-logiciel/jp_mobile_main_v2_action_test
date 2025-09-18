class DeviceInfo {
  String? appVersion;
  String? platform;
  String? deviceVersion;
  String? deviceModel;
  String? manufacturer;
  String? uuid;

  DeviceInfo({
    this.appVersion,
    this.platform,
    this.deviceVersion,
    this.deviceModel,
    this.manufacturer,
    this.uuid,
  });

  DeviceInfo.fromJson(Map<String, dynamic> json) {
    appVersion = json['app_version'];
    platform = json['platform'];
    deviceVersion = json['os_version'];
    deviceModel = json['model'];
    manufacturer = json['manufacturer'];
    uuid = json['uuid'];
  }
}