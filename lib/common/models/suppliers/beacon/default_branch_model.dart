import 'package:jobprogress/common/models/suppliers/beacon/account.dart';
import 'package:jobprogress/common/models/suppliers/beacon/job.dart';
import 'package:jobprogress/common/models/suppliers/branch.dart';

import '../srs/srs_ship_to_address.dart';

class DefaultBranchModel {
  SrsShipToAddressModel? srsShipToAddress;
  SrsShipToAddressModel? abcAccount;
  BeaconAccountModel? beaconAccount;
  SupplierBranchModel? branch;
  BeaconJobModel? jobAccount;

  DefaultBranchModel({
    this.srsShipToAddress,
    this.beaconAccount,
    this.abcAccount,
    this.branch,
    this.jobAccount
  });

  DefaultBranchModel.fromJson(dynamic json) {
    if(json['address'] is Map) {
      if(json['address']['account_id'] != null) {
        abcAccount = SrsShipToAddressModel(
          shipToId: json['address']['account_id'],
          addressLine1: json['address']['name'],
        );
      } else {
        srsShipToAddress = SrsShipToAddressModel(
          shipToSequenceId: json['address']['ship_to_sequence_id'],
          addressLine2: json['address']['name']
        );
      }
    }
    beaconAccount = json['account'] is Map ? BeaconAccountModel.fromJson(json['account']) : null;
    branch = json['branch'] is Map ? SupplierBranchModel.fromJson(json['branch']) : null;
    jobAccount = json['job_account'] is Map ? BeaconJobModel.fromJson(json['job_account']) : null;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    if(srsShipToAddress != null) {
      data['address'] = {
        'name': srsShipToAddress?.addressLine2,
        'ship_to_sequence_id': srsShipToAddress?.shipToSequenceId
      };
    } else if(abcAccount != null) {
      data['address'] = {
        'account_id': abcAccount?.shipToId,
        'name': abcAccount?.addressLine1
      };
    } else if(beaconAccount != null) {
      data['account'] = beaconAccount?.toJson();
    }
    data['branch'] = branch?.toJson();
    if(jobAccount != null) {
      data['job_account'] = jobAccount?.toJson();
    }
    return data;
  }
}