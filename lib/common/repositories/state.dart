import 'dart:convert';
import 'package:jobprogress/common/models/sql/state/company_state.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class StateRepository {
  Future<dynamic> getStateList() async {
    List<StateModel> stateList = [];

    try {
      final response = await dio.get(Urls.state);
      final dataList = json.decode(response.toString())['data'];

      dataList.forEach((dynamic country) => {
        stateList.add(StateModel.fromJson(country))
      });

      return stateList;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CompanyStateModel>> getCompanyStateList() async {
    List<CompanyStateModel> companyStateList = [];

    try {
      final response = await dio.get(Urls.companyState);
      final dataList = json.decode(response.toString())['data'];

      dataList.forEach((dynamic country) => {
        companyStateList.add(CompanyStateModel.fromJson(country))
      });

      return companyStateList;
    } catch (e) {
      rethrow;
    }
  }
}