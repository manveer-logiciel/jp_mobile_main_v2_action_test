import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_data.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

import '../../core/constants/common_constants.dart';

class MeasurementsRepository {

  static Future<Map<String, dynamic>> fetchFiles(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.measurements, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<FilesListingModel> list = [];
      
      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData?["meta"]?["pagination"]
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic estimate) =>
      { 
        dataToReturn['list'].add(FilesListingModel.fromMeasurementsJson(estimate))});
      
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> fileRename(Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put('${Urls.measurementsRename}/${params['id']}', queryParameters: params);
      final jsonData = json.decode(response.toString());


      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> folderRename(Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put(Urls.measurementsFolderRename(params['id']), queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> showHideOnCustomerWebPage(Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put(Urls.estimationsShareOnHop(params['id']), queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> rotateImage(
    String id, Map<String, dynamic> params) async {
    try {
      final response =
      await dio.post(Urls.measurementsRotateImage(id), queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return FilesListingModel.fromMeasurementsJson(jsonData["data"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> moveFiles(
      Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put(Urls.measurementsMoveFiles, queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> removeFile(String id) async {
    try {
      final response = await dio.delete(Urls.deleteMeasurementFile(id));
      final jsonData = json.decode(response.toString());

      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> removeDirectory(String id) async {
    try {
      final response =
      await dio.delete(Urls.deleteMeasurementFolder(id));
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> saveMeasurement(Map<String,dynamic> params) async {
    try {
      final formData = FormData.fromMap(params);
      final response = await dio.post(Urls.measurements, data: formData);
      final jsonData = json.decode(response.toString());
     
      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> updateMeasurement(Map<String,dynamic> params, int id) async {
    try {
      final response = await dio.put(Urls.measurement(id), queryParameters: params);
      final jsonData = json.decode(response.toString());
     
      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<List<MeasurementDataModel>> fetchMeasurementAttributeList(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.measuremnentAttributeList,queryParameters: params);
      
      List<MeasurementDataModel> list = [];

      final jsonData = json.decode(response.toString());
      
      jsonData["data"].forEach((dynamic v){
        list.add(MeasurementDataModel.fromJson(v));
      });
      // Converting api data to model
      return list;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<MeasurementModel> fetchMeasurementDetail(Map<String, dynamic> params, String id) async {
    try {
      
      final response = await dio.get(Urls.measurement(int.parse(id)), queryParameters: params);

      final jsonData = json.decode(response.toString());
      
      // Converting api data to model
      return MeasurementModel.fromJson(jsonData["data"]);
      
    
    } catch (e) {
      //Handle error
      rethrow;
    }
  }



  static Future<FilesListingModel> createDirectory(
      Map<String, dynamic> params) async {
    try {
      final response =
      await dio.post(Urls.measurementsFolder, queryParameters: params);
      final jsonData = json.decode(response.toString());

      jsonData["data"]['is_dir'] = 1;
      // Converting api data to model
      return FilesListingModel.fromMeasurementsJson(jsonData["data"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> changeDeliverableStatus(
      Map<String, dynamic> params) async {
    try {
      final response =
      await dio.post(Urls.hoverChangeDeliverable, queryParameters: params);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<AttachmentResourceModel> getAttachment(String id) async {
    try {
      final response = await dio.get(Urls.measurementsAttachment(id));
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return AttachmentResourceModel.fromEmailJson(jsonData["data"], FLModule.measurements);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<String?> updateWasteFactor(int hoverJobId, int attributeId) async {
    try {
      final response = await dio.put(Urls.updateWasteFactor(hoverJobId, attributeId), queryParameters: CommonConstants.ignoreToastQueryParam);
      final jsonData = json.decode(response.toString());
      return jsonData?['data']?['waste_factor']?.toString();
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updateMeasurementAttributeValue(String? measurementId, Map<String, dynamic> params) async {
    try {
      final response = await dio.put(Urls.updateMeasurementAttributeValue(measurementId), queryParameters: params);
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

}
