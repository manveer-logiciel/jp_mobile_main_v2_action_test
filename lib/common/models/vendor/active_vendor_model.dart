
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class ActiveVendorModel {
  int? id;
  String? firstName;
  String? lastName;
  int? typeId;
  String? displayName;
  String? createdAt;
  String? updatedAt;
  int? quickbookSyncStatus;
  String? origin;
  int? quickbookId;
  int? isActive;
  String? qbDesktopId;
  String? address;

  ActiveVendorModel({
      this.id, 
      this.firstName, 
      this.lastName, 
      this.typeId, 
      this.displayName, 
      this.createdAt, 
      this.updatedAt, 
      this.quickbookSyncStatus, 
      this.origin, 
      this.quickbookId, 
      this.isActive, 
      this.qbDesktopId,});

  ActiveVendorModel.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    typeId = json['type_id'];
    displayName = json['display_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    quickbookSyncStatus = json['quickbook_sync_status'];
    origin = json['origin'];
    quickbookId = json['quickbook_id'];
    isActive = json['is_active'];
    qbDesktopId = json['qb_desktop_id'];
    if(json['address'] != null) {
      address = Helper.convertAddress(AddressModel.fromJson(json['address']));
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['type_id'] = typeId;
    map['display_name'] = displayName;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['quickbook_sync_status'] = quickbookSyncStatus;
    map['origin'] = origin;
    map['quickbook_id'] = quickbookId;
    map['is_active'] = isActive;
    map['qb_desktop_id'] = qbDesktopId;
    return map;
  }

}