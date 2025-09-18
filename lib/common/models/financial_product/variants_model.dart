import 'package:jobprogress/core/utils/helpers.dart';

class VariantModel {
  int? id;
  int? branchId;
  String? branchCode;
  String? name;
  String? code;
  String? unit;
  List<String>? uom;

  VariantModel({
    this.id,
    this.branchId,
    this.branchCode,
    this.name,
    this.code,
    this.unit,
    this.uom,
  });

  VariantModel.fromJson(dynamic json) {
    if (json == null) return;
    id = int.tryParse(json['id'].toString());
    branchId = int.tryParse(json['branch_id'].toString());
    branchCode = (json['branch_code'] ?? "").toString();
    name = (json['name'] ?? "").toString();
    code = (json['code'] ?? "").toString();
    if (json['uom'] != null) {
      uom = [];
      if (json['uom'] is String && !Helper.isValueNullOrEmpty(json['uom'])) {
        uom = [json['uom']];
      } else if (json['uom'] is List) {
        json['uom']?.forEach((dynamic u) {
          uom!.add(u.toString());
        });
      }
    }
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['branch_id'] = branchId;
    map['branch_code'] = branchCode;
    map['name'] = name;
    map['code'] = code;
    map['uom'] = uom;
    map['unit'] = unit;
    return map;
  }

  /// [toLimitedJson] is used to send limited data as payload
  /// to server for saving a variant.
  Map<String, dynamic> toLimitedJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['code'] = code;
    return map;
  }
}
