import 'dart:convert';
import 'package:jobprogress/common/models/automation/automation.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/automation.dart';
import 'package:jobprogress/common/services/count.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/utils/helpers.dart';


class AutomationRepository {
  Future<Map<String, dynamic>> fetchAutomation(Map<String, dynamic> paramKey, {bool fromHomeScreen = false}) async {
    try {
      final response = await dio.get(Urls.automationFeed, queryParameters: paramKey);
      final jsonData = json.decode(response.toString());
      List<AutomationModel> list = [];
      Map<String, dynamic> dataToReturn = {};
      dataToReturn = {
        "data": list,
        "pagination": jsonData["meta"]["pagination"]
      };

      jsonData["data"].forEach((dynamic automation) => {
        dataToReturn['data'].add(AutomationModel.fromJson(automation))
      });
      if(!Helper.isValueNullOrEmpty(list) && fromHomeScreen) {
        AutomationService.setAutomationId(list[0].id);
      }
      return dataToReturn;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchNewAutomationCount(String id) async {
    try{
      final response = await dio.get(Urls.fetchNewAutomationCount(id));
      final jsonData = json.decode(response.toString())['count'];
      CountService.automationCount = jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<WorkFlowStageModel>> fetchWorkflow(Map<String, dynamic> param) async {
    try{
      final response = await dio.get(Urls.workFlow, queryParameters: param);
      List<dynamic> jsonResponse = jsonDecode(response.toString())['workflow']['stages'];
      return jsonResponse.map((data) => WorkFlowStageModel.fromJson(data)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> undoAutomation(String id) async {
    try{
      final response = await dio.put(Urls.undoAutomation(id));
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateEmailTaskAutomationStatus({String? id, Map<String, dynamic>? params}) async {
    try{
      final response = await dio.put("${Urls.automationFeed}/$id", queryParameters: params);
      final jsonData = json.decode(response.toString());
      return jsonData['status'] == 200;
    } catch (e) {
      rethrow;
    }
  }

  Future<AutomationModel> updateStageProgression(String id) async {
    try{
      final response = await dio.put(Urls.updateStageProgression(id));
      final jsonData = json.decode(response.toString());
      return AutomationModel.fromJson(jsonData);
    } catch (e) {
      rethrow;
    }
  }
}
