import 'dart:convert';
import 'package:jobprogress/common/models/suppliers/beacon/job.dart';
import 'package:jobprogress/common/models/suppliers/branch.dart';
import 'package:jobprogress/common/models/suppliers/srs/srs_ship_to_address.dart';
import 'package:jobprogress/common/models/suppliers/beacon/account.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class MaterialSupplierRepository {
  /// Getting all srs ship to address list
  Future<List<SrsShipToAddressModel>> getAllSRSShipAddress(int? supplierId) async {
    List<SrsShipToAddressModel> list = [];
    try {
      final response = await dio.get(Urls.srsShipToAddress, queryParameters: {
        'includes[]': 'branches',
        'supplier_id': supplierId
      });

      final dataList = json.decode(response.toString())['data'];
      dataList.forEach((dynamic item) {
        list.add(SrsShipToAddressModel.fromJson(item));
      });

      return list;
    } catch (e) {
      rethrow;
    }
  }

  /// Getting all srs branch list
  Future<List<SupplierBranchModel>> getAllSRSBranches(int shipToId, int? supplierId) async {
    List<SupplierBranchModel> list = [];

    try {
      final response = await dio.get(Urls.srsBranchList, queryParameters: {
        'includes': 'divisions',
        'limit': 0,
        'ship_to_id': shipToId,
        'supplier_id': supplierId,
      });
      final dataList = json.decode(response.toString())['data'];

      dataList.forEach((dynamic item) {
        list.add(SupplierBranchModel.fromJson(item));
      });

      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<SupplierBranchModel?> getSRSBranchDetails(String code, int? supplierId) async {
    try {
      final response = await dio.get(Urls.srsBranchDetail(code, supplierId));
      final dataJson = json.decode(response.toString())['data'];

      if (dataJson != null && dataJson is Map<String, dynamic>) {
        return SupplierBranchModel.fromJson(dataJson);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BeaconAccountModel>> getBeaconAccounts() async {
    try {
      List<BeaconAccountModel> list = [];
      final response = await dio.get(Urls.beaconAccounts);
      final dataList = json.decode(response.toString())['data'];
      dataList.forEach((dynamic data) {
        list.add(BeaconAccountModel.fromJson(data));
      });
      return list;
    } catch (e) {
      rethrow;
    }
  }

  /// [getBeaconJobs] - Get all beacon jobs
  static Future<Map<String, dynamic>> getBeaconJobs(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.beaconJobs, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<BeaconJobModel> jobsList = [];
      jsonData['data']?.forEach((dynamic element) {
        jobsList.add(BeaconJobModel.fromJson(element));
      });
      return {
        "list": jobsList,
        "pagination": jsonData["meta"]["pagination"]
      };
    } catch (e) {
      rethrow;
    }
  }

  /// [getSupplierAccounts] - Get all supplier accounts
  Future<List<SrsShipToAddressModel>> getSupplierAccounts(int supplierId, Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.getSupplierAccounts(supplierId), queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<SrsShipToAddressModel> list = [];
      final dataList = jsonData['data'];
      dataList.forEach((dynamic item) {
        list.add(SrsShipToAddressModel.fromJson(item));
      });

      return list;
    } catch (e) {
      rethrow;
    }
  }

  /// [getSupplierBranches] - Get all supplier branches
  Future<List<SupplierBranchModel>> getSupplierBranches(int supplierId, Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.getSupplierBranches(supplierId), queryParameters: params);
      final jsonData = json.decode(response.toString());
      final dataList = jsonData['data'];

      List<SupplierBranchModel> list = [];
      dataList.forEach((dynamic item) {
        list.add(SupplierBranchModel.fromJson(item));
      });

      return list;
    } catch (e) {
      rethrow;
    }
  }
}
