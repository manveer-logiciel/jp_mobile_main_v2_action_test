import '../../core/utils/helpers.dart';

class ApplicationInfo {
  int? id;
  String? device;
  String? version;
  String? description;
  bool? isForced;
  String? url;
  late bool isApproved;

  ApplicationInfo({
    this.id,
    this.device,
    this.version,
    this.description,
    this.isForced,
    this.url,
    this.isApproved = false,
  });

  ApplicationInfo.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    device = json['device']?.toString();
    version = json['version']?.toString();
    description = json['description']?.toString();
    isForced = Helper.isTrue(json['forced']);
    url = json['url']?.toString();
    isApproved = Helper.isTrue(json['approved']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['device'] = device;
    data['version'] = version;
    data['description'] = description;
    data['forced'] = isForced ?? false ? 1 : 0;
    data['url'] = url;
    data['approved'] = isApproved ? 1 : 0;
    return data;
  }
}