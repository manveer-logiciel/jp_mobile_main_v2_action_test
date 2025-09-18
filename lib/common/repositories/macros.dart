import 'dart:convert';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import '../../core/constants/urls.dart';
import '../../global_widgets/loader/index.dart';
import '../models/macros/index.dart';
import '../models/sheet_line_item/sheet_line_item_model.dart';
import '../providers/http/interceptor.dart';

class MacrosRepository {

  Future<Map<String, dynamic>> fetchMacroList(Map<String, dynamic> params) async {
    
    try {
      final response = await dio.get(Urls.macros, queryParameters: params);
      final jsonData = json.decode(response.toString());

      List<MacroListingModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic snippet) =>
      {dataToReturn['list'].add(MacroListingModel.fromJson(snippet))});
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchMacroDetail(Map<String, dynamic> params,String macroId) async {
    try {
      final response = await dio.get('${Urls.macrosV2}/$macroId', queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<SheetLineItemModel> list = [];

      Map<String, dynamic> dataToReturn = {
        'data': <String, dynamic>{},
        "list": list,
      };

      //Converting api data to model
      if(jsonData["data"]["branch"] is Map) {
        dataToReturn['data'] = jsonData["data"]["branch"];
      }
      jsonData["data"]["details"]["data"].forEach((dynamic snippet) =>
      {dataToReturn['list'].add(SheetLineItemModel.fromEstimateJson(snippet))});
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<List<MacroListingModel>> fetchSelectedMacrosData(Map<String, dynamic> params, {
    AddLineItemFormType? type
  }) async {
    try {
      showJPLoader();
      final response = await dio.get(Urls.selectedMacrosDetail, queryParameters: params);
      final jsonData = json.decode(response.toString());

      List<MacroListingModel> tempValues = [];

      //Converting api data to model
      jsonData["data"].forEach((dynamic macro) {
        tempValues.add(MacroListingModel.fromJson(macro, pageType: type));
      });

      return tempValues;
    } catch (e) {
      //Handle error
      rethrow;
    }
    finally{
      Get.back();
    }
  }
}
