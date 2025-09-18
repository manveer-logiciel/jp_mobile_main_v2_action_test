import 'dart:convert';
import 'package:jobprogress/common/models/sql/flag/flag.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class FlagsRepository {
  Future<dynamic> getFlagList(Map<String, dynamic> params) async {
    List<FlagModel> flags = [];
    try {
      final response = await dio.get(Urls.flags, queryParameters: params);
      final dataList = json.decode(response.toString())['data'];
      dataList.forEach((dynamic flag) => {
        flags.add(FlagModel.fromApiJson(flag))
      });
      return flags;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> assignFlags(Map<String, dynamic> params) async {
    try {
      final response = await dio.put(Urls.assignFlags, data: params);
      return jsonDecode(response.toString())['message'];
    } catch (e) {
      rethrow;
    }
  }
  
  Future<dynamic> assignCommunicationFlags(Map<String, dynamic> params, int jobId) async {
    try {
      final response = await dio.put(Urls.communication(jobId.toString()), data: params);
      return jsonDecode(response.toString())['message'];
    } catch (e) {
      rethrow;
    }
  }
}