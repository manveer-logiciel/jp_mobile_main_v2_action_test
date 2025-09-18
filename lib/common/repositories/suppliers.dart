import 'dart:convert';
import 'package:jobprogress/common/models/suppliers/suppliers.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class SuppliersRepository {

  static Future<List<SuppliersModel>> fetchCompanySuppliers(Map<String, dynamic> params) async {
    List<SuppliersModel> suppliers = [];

    try {
      final response = await dio.get(Urls.companySuppliers, queryParameters: params);
      final dataList = json.decode(response.toString())['data'];

      dataList.forEach((dynamic supplier) {
        final tempSupplier = SuppliersModel.fromJson(supplier);
        suppliers.add(tempSupplier);
      });

      return suppliers;
    } catch (e) {
      rethrow;
    }
  }

}