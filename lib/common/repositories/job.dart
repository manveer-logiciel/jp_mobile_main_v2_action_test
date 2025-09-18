import 'dart:convert';
import 'package:get/route_manager.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/email/template_list.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/recurring_email.dart';
import 'package:jobprogress/common/models/job/request_params.dart';
import 'package:jobprogress/common/models/job/serial_number.dart';
import 'package:jobprogress/common/models/job_financial/financial_job_price_detail.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/common/models/vendor/active_vendor_model.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import '../models/accounting_head/accounting_head_model.dart';
import '../models/job/job_production_board.dart';
import '../models/job_financial/tax_model.dart';

class JobRepository {
  static Future<Map<String, dynamic>> fetchJob(int id,{Map<String, dynamic>? params, bool loadJobWithCounts = false}) async {
    try {

      if (loadJobWithCounts) {
        params ??= {};
        final paramsWithIncludes = Helper.extractIncludesFormParams(params);
        params.addAll(JobRequestParams.forJobSummary(id, additionalIncludes: paramsWithIncludes));
      }
      final response = await dio.get('${Urls.jobs}/$id', queryParameters: params);
      final jsonData = json.decode(response.toString());

      Map<String, dynamic> dataToReturn = {
        "job": JobModel.fromJson(jsonData['data']),
      };

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<JobModel> addJob(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.jobs, queryParameters: params);
      final jsonData = json.decode(response.toString());
      return JobModel.fromJson(jsonData['job']);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<String> getJobAwardedStage() async {
    try {
      final response = await dio.get(Urls.jobAwardedStage);
      final jsonData = json.decode(response.toString());
      return jsonData['data']?['stage'] ?? "";
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<JobModel> updateJob(int jobId, Map<String, dynamic> params) async {
    try {
      final response = await dio.put("${Urls.jobs}/$jobId", queryParameters: params);
      final jsonData = json.decode(response.toString());
      return JobModel.fromJson(jsonData['job']);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchEmailDetailView(int id,{Map<String, dynamic>? params}) async {
    try {
      showJPLoader();
      final response = await dio.get('${Urls.emailDetail}/$id', queryParameters: params);
      final jsonData = json.decode(response.toString());

      Map<String, dynamic> dataToReturn = {
        "email_detail": EmailTemplateListingModel.fromReccuringEmailJson(jsonData['data']),
      };
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    } finally {
      Get.back();
    }
  }

  Future<dynamic> cancelRecurringEmail(Map<String, dynamic> params, int id) async {
    try {
      // getting request params
      String url = Urls.cancelRecurring(id);
      await dio.put(url, data: params);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<AttachmentResourceModel> getAttachment(String id, Map<String, dynamic> query) async {
    try {
      final response = await dio.get(Urls.jobScheduleAsAttachment(id),queryParameters: query);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return AttachmentResourceModel.fromPaymentSlipJson(jsonData["file"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<List<RecurringEmailModel>> fetchRecurringEmailList({Map<String, dynamic>? params}) async {
    try {
      final response = await dio.get(Urls.dripCampaigns, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<RecurringEmailModel> list = [];
      (jsonData["data"] ?? <dynamic>[]).forEach((dynamic email) => {list.add(RecurringEmailModel.fromJson(email))});
      return list;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<List<dynamic>> fetchProjectStatus() async {
    Map<String, dynamic> params = {
      'limit': 0,
    };
    final response = await dio.get(Urls.projectStatusManager, queryParameters: params);
    final jsonData = json.decode(response.toString());
    return jsonData['data'];
  }

  static Future<List<FinancialJobPriceRequestDetail>> fetchJobPriceUpdateRequest({Map<String, dynamic>? params}) async {
    try {
      final response = await dio.get(Urls.jobPriceRequest, queryParameters: params);
      final jsonData = json.decode(response.toString());

      List<FinancialJobPriceRequestDetail> dataToReturn = [];

      if (jsonData['data'].length != 0) {
        dataToReturn.add(FinancialJobPriceRequestDetail.fromJson(jsonData['data'][0]));
      }

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<List<JobModel>> fetchRecentJob(Map<String, dynamic> params) async {
    try {
      final response = await dio.get('${Urls.jobs}/recent_viewed', queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<JobModel> list = [];
      jsonData["data"].forEach((dynamic job) => {list.add(JobModel.fromJson(job))});
      return list;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchUpcomingJobAppointmentSchedule(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.upcomingAppointmentSchedule(params['id'].toString()), queryParameters: params);
      final jsonData = json.decode(response.toString());
      AppointmentModel appointment = AppointmentModel();
      SchedulesModel schedule = SchedulesModel();

      if (jsonData["data"] is Map) {
        appointment = AppointmentModel.fromJson(jsonData["data"]?['upcoming_appointment'] ?? {});
        schedule = SchedulesModel.fromApiJson(jsonData["data"]?['upcoming_schedule'] ?? {});
      }

      return {
        'appointment': appointment,
        'schedule': schedule,
      };
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> deleteJobSchedule(Map<String, dynamic> deleteJobScheduleParams, String id) async {
    try {
      String url = '${Urls.schedules}/$id';
      final response = await dio.delete(url, queryParameters: deleteJobScheduleParams);
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchJobList({Map<String, dynamic>? params}) async {
    try {
      final response = await dio.get(Urls.jobsListing, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<JobModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData["meta"]?["pagination"]
      };

      jsonData["data"].forEach((dynamic jobs) => dataToReturn['list'].add(JobModel.fromJson(jobs)));

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<dynamic> deleteJob(Map<String, dynamic> params) async {
    try {
      final response = await dio.delete('${Urls.jobs}/${params['id']}',queryParameters: params);
      return json.decode(response.toString())['message'];
    } catch (e) {
      rethrow;
    }
  }

  static Future<JobModel> editJobDuration(Map<String, dynamic> params, String jobId) async {
    try {
      final response = await dio.put(Urls.updateJobFields(jobId),queryParameters: params);
      final jsonData = json.decode(response.toString());
      return JobModel.fromJson(jsonData["data"]);
    } catch (e) {
      rethrow;
    }
  }

  static Future<JobModel> updateJobFields(Map<String, dynamic> params, String jobId) async {
    try {
      final response = await dio.put(Urls.updateJobFields(jobId),queryParameters: params);
      final jsonData = json.decode(response.toString());
      return JobModel.fromJson(jsonData["data"]);
    } catch (e) {
      rethrow;
    }
  }

  static Future<JobModel> updateCategory(Map<String, dynamic> params, String jobId) async {
    try {
      final response = await dio.put(Urls.updateJobFields(jobId),data: params);
      final jsonData = json.decode(response.toString());
      return JobModel.fromJson(jsonData["data"]);
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> searchJob({Map<String, dynamic>? params}) async {
    try {
      final response = await dio.get(Urls.jobsSearch, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<JobModel> list = [];
      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData["meta"]["pagination"]
      };
      jsonData["data"].forEach((dynamic jobs) =>dataToReturn['list'].add(JobModel.fromSearchJson(jobs)));
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
  
  static Future<bool> markCompleteJobSchedule(Map<String, dynamic> params, String id) async{
    try {
      String url = '${Urls.schedules}/$id/mark_as_completed';
      final response = await dio.put(url, queryParameters: params);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
  
  static Future<bool> contractSignedDateAction(String jobId, String date) async{
    Map<String,dynamic> params = {
      'job_id': jobId,
      'date': date,
    };
    
    try {
      String url = Urls.contractSigned;
      final response = await dio.put(url, data: params);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> jobCompletionDateAction(String jobId, String date) async{
    Map<String,dynamic> params = {
      'date': date
    };
    try {
      String url = Urls.jobCompletionDate(jobId);
      final response = await dio.put(url, data: params);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> markAction(Map<String, dynamic> params, String id, String key) async {
    try {
      String url = '';
      if (key == 'mark_as_accept') {
        url = '${Urls.schedules}/$id/mark_as_accept';
      } else if (key == 'mark_as_pending') {
        url = '${Urls.schedules}/$id/mark_as_pending';
      } else {
        url = '${Urls.schedules}/$id/mark_as_decline';
      }
      final response = await dio.put(url, queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<dynamic> updateDescription(Map<String, dynamic> params) async {
    try {
      final response = await dio.put( '${Urls.jobsDescription}/${params['id']}',queryParameters: params);
      return json.decode(response.toString())['message'];
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> markAsLostJob(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.markAsLostJob,queryParameters: params);
      return json.decode(response.toString());
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> reinstateJob(Map<String, dynamic> params) async {
    try {
      final response = await dio.delete('${Urls.followUpNote}/${params['id']}');
      return json.decode(response.toString())['status'];
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> archiveJob(String jobId, Map<String, dynamic> params) async {
    try {
      final response = await dio.put("${Urls.jobs}/$jobId/archive",queryParameters: params);
      return json.decode(response.toString())['status'];
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> fetchProgressBoards(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.progressBoards, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<JobProductionBoardModel> list = [];
      jsonData["data"].forEach((dynamic progressBoard) =>list.add(JobProductionBoardModel.fromJson(progressBoard)));
      return list;
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> updateProgressBoards(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.addToProgressBoards,queryParameters: params);
      return json.decode(response.toString())['status'];
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> shareJobToCustomerWebPage(int jobId) async {
    try {
      final response = await dio.get(Urls.shareJobToCustomerWebPage(jobId));
      return json.decode(response.toString())['status'];
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> fetchMetaList(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.jobMeta, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<JobModel> list = [];
      Map<String, dynamic> dataToReturn = {
        "list": list,
      };
      //Converting api data to model
      jsonData["data"].forEach((dynamic customer) => dataToReturn['list'].add(JobModel.fromJson(customer)));
      return dataToReturn;

    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<dynamic> updateJobPrice(Map<String, dynamic> params, bool isAllowedToUpdate) async {
    try {
      final response = isAllowedToUpdate
          ? await dio.post(Urls.jobPriceRequest, queryParameters: params)
          : await dio.put(Urls.jobPriceUpdateRequest(params["id"]),queryParameters: params);
      return json.decode(response.toString())['status'] == 200;
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> fetchProjectJobs(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.jobMeta, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<JobModel> list = [];
      Map<String, dynamic> dataToReturn = {
        "list": list,
      };
      //Converting api data to model
      jsonData["data"].forEach((dynamic customer) => dataToReturn['list'].add(JobModel.fromJson(customer)));
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<dynamic> fetchCustomTax(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.customTaxList, queryParameters: params);
      List<TaxModel> list = [];
      json.decode(response.toString())["data"].forEach((dynamic tax) => list.add(TaxModel.fromJson(tax)));
      return list;
    } catch (e) {
      rethrow;
    }
  }

  static Future<SerialNumberModel> generateSerialNumber(Map<String, dynamic> params) async{
    try {
      final response = await dio.put(Urls.generateSerialNumber, queryParameters: params);
      return SerialNumberModel.fromJson(jsonDecode(response.toString())['data']);
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<AccountingHeadModel>> fetchVendors(Map<String, dynamic> params) async{
    try {
      final response = await dio.get(Urls.vendors, queryParameters: params);
      List<AccountingHeadModel> list = [];
      json.decode(response.toString())["data"].forEach((dynamic vendor) => list.add(AccountingHeadModel.fromJson(vendor)));
      return list;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchActiveVendors(Map<String, dynamic> params) async{
    try {
      final response = await dio.get(Urls.activeVendors, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<ActiveVendorModel> list = [];
      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData["meta"]["pagination"]
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic user) =>
          dataToReturn['list'].add(ActiveVendorModel.fromJson(user)));
      return dataToReturn;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<dynamic>> fetchMaterialDeliveryDate(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.materialDeliveryDates(params['job_id']), queryParameters: params);
      final jsonData = json.decode(response.toString());
      return jsonData["data"];
    } catch (e) {
      rethrow;
    }
  }


}
