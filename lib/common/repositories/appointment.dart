import 'dart:convert';
import 'package:jobprogress/common/models/appointment/appointment_limited.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/models/appointment/appointment_result/appointment_result_options.dart';
import 'package:jobprogress/common/services/count.dart';
import '../../core/constants/urls.dart';
import '../models/appointment/appointment.dart';
import '../providers/http/interceptor.dart';

class AppointmentRepository {

  Future<AppointmentModel> fetchAppointment(
      Map<String, dynamic> params) async {
    try {
      final response =
      await dio.get('${Urls.appointments}/${params['id']}', queryParameters: params);
      final jsonData = json.decode(response.toString());

      return AppointmentModel.fromJson(jsonData['data']);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  /// fetchAppointmentsList() : fetches appointments and parse all data
  Future<Map<String, dynamic>> fetchAppointmentsList(
      Map<String, dynamic> params) async {
    try {
      final response =
          await dio.get(Urls.appointments, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<AppointmentModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list
      };

      if(jsonData["meta"] != null && jsonData["meta"]['pagination'] != null) {
        dataToReturn['pagination'] = PaginationModel.fromJson(jsonData["meta"]["pagination"]);
      }

      jsonData["data"].forEach((dynamic appointments) =>
          {dataToReturn['list'].add(AppointmentModel.fromJson(appointments))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  /// fetchAppointmentsList() : fetches appointments and parse limited data,
  /// helps in improving calendars performance.
  Future<Map<String, dynamic>> fetchAppointmentsEvents(
      Map<String, dynamic> params) async {
    try {

      final response =
      await dio.get(Urls.appointments, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<AppointmentLimitedModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list
      };

      jsonData["data"].forEach((dynamic appointments) =>
      {dataToReturn['list'].add(AppointmentLimitedModel.fromJson(appointments))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchReportAppointmentsList(
      Map<String, dynamic> params) async {
    try {
      final response =
          await dio.get(Urls.reportsAppointments, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<AppointmentModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list
      };

      if(jsonData["meta"] != null && jsonData["meta"]['pagination'] != null) {
        dataToReturn['pagination'] = PaginationModel.fromJson(jsonData["meta"]["pagination"]);
      }

      jsonData["data"].forEach((dynamic appointments) =>
          {dataToReturn['list'].add(AppointmentModel.fromJson(appointments))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteRecurringAppointment(
      Map<String, dynamic> deleteRecursiveParams, String id) async {
    try {
      String url = '${Urls.appointments}/$id';
      final response =
          await dio.delete(url, queryParameters: deleteRecursiveParams);
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteNonRecurringAppointment(String id) async {
    try {
      String url = '${Urls.appointments}/$id';
      final response = await dio.delete(url);
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchAppointmentResultsOptions(
    Map<String, dynamic> params) async {
      try {
        final response =
            await dio.get(Urls.appointmentsResultOptions, queryParameters: params);
        final jsonData = json.decode(response.toString());
        List<AppointmentResultOptionsModel> list = [];

        Map<String, dynamic> dataToReturn = {
          "list": list
        };

        jsonData["data"].forEach((dynamic appointments) =>
            {dataToReturn['list'].add(AppointmentResultOptionsModel.fromJson(appointments))});
        return dataToReturn;
      } catch (e) {
        //Handle error
        rethrow;
      }
  }

  Future<List<AppointmentResultOptionsModel>> loadAppointmentResultOptions(Map<String, dynamic> params) async {
    try {

      final response = await dio.get(Urls.appointmentResultOptions, queryParameters: params);

      List<AppointmentResultOptionsModel> list = [];

      final jsonData = json.decode(response.toString());

      jsonData["data"].forEach((dynamic v){
        list.add(AppointmentResultOptionsModel.fromJson(v));
      });

      return list;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<AppointmentModel> saveAppointmentResults(Map<String, dynamic> params) async {
    try {

      final response = await dio.put(Urls.saveAppointmentResultOptions(params['id']), queryParameters: params);

      final jsonData = json.decode(response.toString());

      return AppointmentModel.fromJson(jsonData['data']);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<AppointmentModel> markAsCompleted(Map<String, dynamic> params) async {
    try {

      final response = await dio.put(Urls.appointmentMarkAsCompleted(params['id']), queryParameters: params);

      final jsonData = json.decode(response.toString());

      return AppointmentModel.fromJson(jsonData['data']);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<void> fetchAppointmentCount() async {
    try {
      final response = await dio.get(Urls.appointmentCount);
      final jsonData = json.decode(response.toString());
      if(jsonData['status'] == 200 ) {
        CountService.appointmentCount =  jsonData['data']['upcoming_appointments_count_without_recurrings'];
      }
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createAppointment(Map<String, dynamic> params) async {
    
    try {
      final response = await dio.post(Urls.appointments, data: params);
      
      final jsonData = json.decode(response.toString());
     AppointmentModel appointment = AppointmentModel.fromJson(jsonData['appointment']);
      Map<String, dynamic> data = {
        "appointment" : appointment,
        "status" : jsonData['status'] == 200
      };
      return data;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateAppointment(Map<String, dynamic> params) async {
    try {
      final response = await dio.put("${Urls.appointments}/${params['id']}", data: params);
      final jsonData = json.decode(response.toString());
      AppointmentModel appointment = AppointmentModel.fromJson(jsonData['appointment']);
      Map<String, dynamic> data = {
        "appointment" : appointment,
        "status" : jsonData['status'] == 200
      };
      return data;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<List<AppointmentModel>> fetchAppointmentByCustomerId(Map<String, dynamic> params) async {
    try {
      final response =
      await dio.get(Urls.appointments, queryParameters: params);
      final jsonData = json.decode(response.toString());

      List<AppointmentModel> list = [];
      if(jsonData['data'] is List) {
        jsonData["data"].forEach((dynamic v) {
          list.add(AppointmentModel.fromJson(v));
        });
      } else {
        list.add(AppointmentModel.fromJson(jsonData['data']));
      }
      return list;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}
