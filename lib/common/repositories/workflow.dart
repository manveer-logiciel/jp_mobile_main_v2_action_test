import 'dart:convert';

import 'package:dio/dio.dart';

import '../../core/constants/urls.dart';
import '../providers/http/interceptor.dart';

class WorkflowRepository {
   static Future<dynamic> updateWorkflowSetting(Map<String, dynamic> params) async {
     try {
       final formData = FormData.fromMap(params);
       final response = await dio.post(Urls.companySettings, data: formData);
       final jsonData = json.decode(response.toString());
       return jsonData["status"];
     } catch (e) {
       rethrow;
     }
   }
}