import 'package:dio/dio.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/forms/payment/method.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'dart:convert';
import 'package:get/get_utils/get_utils.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/download.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import '../models/accounting_head/accounting_head_model.dart';
import '../models/worksheet/worksheet_model.dart';

class JobFinancialRepository {

  static Future<String> fetchjobFinancialNote({required int id})  async {
    try{
      final response = await dio.get('${Urls.jobs}/$id/financial_notes');
      final jsonData = json.decode(response.toString());
      if(jsonData['data'] != null){
        return jsonData['data']['note'];
      } else {
        return '';
      }
    } catch(e) {
      //Handle error
      rethrow;
    }
  }

  static Future<AttachmentResourceModel> getInvoiceAttachment(String id)async{
    try {
      final response =
      await dio.get(Urls.singleInvoiceAttachment(id));
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return AttachmentResourceModel.fromInvoiceListJson(jsonData["job_invoice"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<AttachmentResourceModel> getPaymentSlipAsAttachment(String id, Map<String, dynamic> query) async {
    try {
      final response = await dio.get(Urls.paymentSlipAsAttachment(id),queryParameters: query);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return AttachmentResourceModel.fromPaymentSlipJson(jsonData["file"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<dynamic> jobPriceApproveRejectRequest(Map<String,dynamic> jobPriceUpdatedParams, int id)  async {
    try{
      await dio.put('${Urls.jobPriceRequest}/$id/change_status', data:jobPriceUpdatedParams);
    } catch(e) {
      //Handle error
      rethrow;
    }
  }

  Future<dynamic> addJobFinancialNote(int jobId, Map<String,dynamic> addjobFinancialNote) async {
    try {
      String url = '${Urls.jobs}/$jobId/financial_notes';
      var formData = FormData.fromMap(addjobFinancialNote);
      await dio.post(url, data: formData);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<dynamic> cancelPayment(Map<String, dynamic> addCancelPaymentReceivedParams) async {
    try {
      String url = Urls.paymentCancel;
      await dio.put(url, data: addCancelPaymentReceivedParams);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<bool> applyCredit(Map<String, dynamic> params) async {
    try {
      String url = Urls.credits;
      final response =  await dio.post(url, data: params);
      final jsonData = json.decode(response.toString());
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<dynamic> cancelRefund(
      Map<String, dynamic> addcancelRefundParams, int id) async {
    try {
      String url ='${Urls.jobs}/refunds/$id/cancel';
      await dio.put(url, data: addcancelRefundParams);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<dynamic> linkorUnlinkProposal(Map<String, dynamic> proposalReceivedParams) async {
    try {
      String url = Urls.proposalLink;
      await dio.put(url, data: proposalReceivedParams);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<dynamic> cancelChangeOrder({required int id}) async {
    try {
      String url = '${Urls.changeOrderCancel}/$id';
      await dio.put(url);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<dynamic> cancelCommission({required int id}) async {

    try {
      String url = '${Urls.commissions}/$id/cancel';
      await dio.post(url);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<dynamic> cancelCommissionPayment(Map<String, dynamic> cancelCommissionPaymentParams) async {
    try {
      String url = '${Urls.commissions}/payment_cancel';
      await dio.put(url,queryParameters:cancelCommissionPaymentParams);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<void> deleteCommissionPayments({required int id}) async {
    try {
      String url = '${Urls.commissions}/payments/$id';
      final response = await dio.delete(url);
      final jsonData = json.decode(response.toString());
      return jsonData;

    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<dynamic> payCommission({required Map<String, dynamic> payCommissionParams})async {
    try {
      String url = '${Urls.commissions}/payments';
      await dio.post(url, queryParameters: payCommissionParams);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }


  Future<dynamic> cancelCredit({required int id}) async {
    try {
      String url = '${Urls.credits}/$id/cancel';
      await dio.put(url);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<void> openInvoice({required FinancialListingModel modal}) async{
    try {
      showJPLoader(msg: 'downloading'.tr);
      String url = '${Urls.invoice}/${modal.invoiceId}';
      String fileName = '${FileHelper.getFileName(url.toString())}.pdf';
      await DownloadService.downloadFile(
        url.toString(), fileName,
        action:'open',
      );
    } catch(e) {
      rethrow;
    }
  }

  static Future<List<FinancialListingModel>> fetchChangeOrderList(Map<String, dynamic> changeOrderParams) async {
    try {
      final response = await dio.get(Urls.changeOrderHistory,queryParameters: changeOrderParams);
      final jsonData = json.decode(response.toString());
      List<FinancialListingModel> list = [];
      jsonData["data"].forEach((dynamic job) => {
        list.add(FinancialListingModel.fromChangeOrderJson(job))
      });

      return list;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<List<FinancialListingModel>> fetchAccountsPayableList(Map<String, dynamic> accountsPayableParams) async {
    try {
      final response = await dio.get(Urls.vendor, queryParameters: accountsPayableParams);
      final jsonData = json.decode(response.toString());
      List<FinancialListingModel> list = [];
      jsonData["data"].forEach((dynamic job) => {
        list.add(FinancialListingModel.fromAccountsPayableJson(job))
      });
      return list;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<List<FinancialListingModel>> fetchCommisionsList(Map<String, dynamic> commissionsParams) async {
    try {
      final response = await dio.get(Urls.commissions, queryParameters: commissionsParams);
      final jsonData = json.decode(response.toString());
      List<FinancialListingModel> list = [];
      jsonData["data"].forEach((dynamic job) => {
        list.add(FinancialListingModel.fromCommissionJson(job))
      });
      return list;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<List<FinancialListingModel>> fetchCommisionPaymentList(Map<String, dynamic> params,int id) async {
    try {
      final response = await dio.get(Urls.commissionPayment(id), queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<FinancialListingModel> list = [];
      jsonData["data"].forEach((dynamic job) => {
        list.add(FinancialListingModel.fromCommissionPaymentJson(job))
      });
      return list;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<List<FinancialListingModel>> fetchpaymentsReceivedList(int id, Map<String, dynamic> paymentReceivedParams) async {
    try {
      final response = await dio.get('${Urls.paymentHistory}/$id',queryParameters: paymentReceivedParams);
      final jsonData = json.decode(response.toString());
      List<FinancialListingModel> list = [];
      jsonData["data"].forEach((dynamic job) => {
        list.add(FinancialListingModel.fromPaymentsReceivedJson(job))
      });

      return list;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<List<FinancialListingModel>> fetchJobPriceHistoryList(int id, Map<String, dynamic> jobPriceHistoryParams) async {
    try {
      final response = await dio.get('${Urls.jobs}/pricing_history/$id',queryParameters: jobPriceHistoryParams);
      final jsonData = json.decode(response.toString());
      List<FinancialListingModel> list = [];
      jsonData["data"].forEach((dynamic job) => {
        list.add(FinancialListingModel.fromJobPriceHistoryJson(job))
      });

      return list;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<List<FinancialListingModel>> fetchCreditList(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.credits, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<FinancialListingModel> list =[];

      jsonData["data"].forEach((dynamic job) => {
        list.add(FinancialListingModel.fromCreditsJson(job))
      });

      return list;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<List<FinancialListingModel>> fetchJobInvoiceList(int id, Map<String, dynamic> jobInvoiceParams) async {
    try {
      final response = await dio.get('${Urls.jobs}/$id', queryParameters: jobInvoiceParams);
      final jsonData = json.decode(response.toString());
      List<FinancialListingModel> list = [];
      jsonData["data"]?["job_invoices"]?["data"]?.forEach((dynamic job) => {
        list.add(FinancialListingModel.fromJobInvoicesJson(job))
      });

      return list;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchFiles(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.financialInvoice(params['id']), queryParameters: params);
      final jsonData = json.decode(response.toString());

      List<FilesListingModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic file) =>
      {dataToReturn['list'].add(FilesListingModel.fromFinancialInvoiceJson(file))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchPaymentReceiveForFileListing(Map<String, dynamic> params) async {
    try {
     final response = await dio.get('${Urls.paymentHistory}/${params['id']}',queryParameters: params);
      final jsonData = json.decode(response.toString());

      List<FilesListingModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic file) =>
      {dataToReturn['list'].add(FilesListingModel.fromPaymentReceive(file))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<List<FinancialListingModel>> fetchRefundsList(Map<String, dynamic> params) async {
    try {
      final response = await dio.get('${Urls.jobs}/refunds',queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<FinancialListingModel> list =[];

      jsonData["data"].forEach((dynamic job) => {
        list.add(FinancialListingModel.fromRefundsJson(job))
      });

      return list;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<String> removeFinancialInvoice(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.delete(Urls.financialInvoiceDelete, queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData["message"];
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> ajdustUnappliedCredit(Map<String, dynamic> params) async{
    try {
      final response = await dio.post(Urls.applyCredit, queryParameters: params);
      final jsonData = json.decode(response.toString());
      return jsonData['status'] == 200;

    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> fetchProfitLossSummary(Map<String, dynamic> params) async{
    try {
      final response = await dio.get(Urls.financialWorksheetDetail(params["id"]), queryParameters: params);
      return WorksheetModel.fromProfitLossSummaryJson(json.decode(response.toString())["data"]);
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<MethodModel>> fetchMethodList() async {
    try {
      final response = await dio.get(Urls.paymentMethod);
      final jsonData = json.decode(response.toString());
      List<MethodModel> list =[];

      jsonData["data"].forEach((dynamic method) => {
        list.add(MethodModel.fromJson(method))
      });
      return list;

    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> applyPayment(Map<String,dynamic> params) async {
    try {
      var formData = FormData.fromMap(params);
      final response = await dio.post(Urls.jobsPayment,data: formData);
      final jsonData = json.decode(response.toString());
      return jsonData['status'] == 200;

    } catch (e) {
      rethrow;
    }
  }

  static Future<List<AccountingHeadModel>> getRefunds() async {
    try {
      final response = await dio.get("${Urls.refunds}?limit=200");
      final jsonData = json.decode(response.toString());
      final List<AccountingHeadModel> refunds = [];
      jsonData['data'].forEach((dynamic val) {
        refunds.add(AccountingHeadModel.fromJson(val));
      });
      return refunds;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> saveRefund(Map<String,dynamic> params) async {
    try {
      final formData = FormData.fromMap(params);
      final response = await dio.post(Urls.saveRefund,data: formData);
      final jsonData = json.decode(response.toString());
      return jsonData['status'] == 200;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> saveBill(Map<String,dynamic> params) async {
    try {
      final formData = FormData.fromMap(params);
      final response = await dio.post(Urls.vendor,data: formData);
      final jsonData = json.decode(response.toString());
      return jsonData['status'] == 200;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> updateBill(Map<String,dynamic> params, int id) async {
    try {
      final response = await dio.put('${Urls.vendor}/$id', queryParameters: params);
      final jsonData = json.decode(response.toString());
      return jsonData['status'] == 200;
    } catch (e) {
      rethrow;
    }
  }

  static Future<WorksheetModel> fetchWorkSheet(Map<String, dynamic> params) async{
    try {
      final response = await dio.get(Urls.financialWorksheetDetail(params["id"].toString()), queryParameters: params);
      final jsonData = json.decode(response.toString());
      final workSheet = jsonData?['data']?['worksheet'];
      return WorksheetModel.fromJson(workSheet ?? {});
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchChangeOrderDetail(int? orderId, Map<String, dynamic> params) async {
    try {
      final response = await dio.get("${Urls.changeOrder}?id=$orderId", queryParameters: params);
      final jsonData = json.decode(response.toString());
      FinancialListingModel changeOrder = FinancialListingModel.fromChangeOrderJson(jsonData['data']);
      Map<String, dynamic> data = {
        "data" : changeOrder,
        "status" : jsonData['status'] == 200
      };
      return data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchChangeOrderDetailFromInvoice(int invoiceId) async {
    try {
      final response = await dio.get(Urls.changeOrderFromInvoice(invoiceId));
      final jsonData = json.decode(response.toString());
      FinancialListingModel changeOrder = FinancialListingModel.fromChangeOrderJson(jsonData['data']);
      Map<String, dynamic> data = {
        "data" : changeOrder,
        "status" : jsonData['status'] == 200
      };
      return data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> createChangeOrder(Map<String,dynamic> params) async {
    try {
      final response = await dio.post(Urls.changeOrder, data: params);
      final jsonData = json.decode(response.toString());
      FinancialListingModel changeOrder = FinancialListingModel.fromChangeOrderJson(jsonData['change_order']);
      Map<String, dynamic> data = {
        "data" : changeOrder,
        "status" : jsonData['status'] == 200
      };
      return data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updateChangeOrder(int? orderId, Map<String, dynamic> params) async {
    try {
      final response = await dio.put("${Urls.changeOrder}/$orderId", data: params);
      final jsonData = json.decode(response.toString());
      FinancialListingModel changeOrder = FinancialListingModel.fromChangeOrderJson(jsonData['change_order']);
      Map<String, dynamic> data = {
        "data" : changeOrder,
        "status" : jsonData['status'] == 200
      };
      return data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchInvoiceDetail(int? invoiceId, Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.singleInvoiceAttachment(invoiceId.toString()), queryParameters: params);
      final jsonData = json.decode(response.toString());
      FinancialListingModel invoice = FinancialListingModel.fromJobInvoicesJson(jsonData['job_invoice']);
      Map<String, dynamic> data = {
        "data" : invoice,
        "status" : jsonData['status'] == 200
      };
      return data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> createInvoice(Map<String,dynamic> params) async {
    try {
      final response = await dio.post(Urls.jobinvoice, data: params);
      final jsonData = json.decode(response.toString());
      FinancialListingModel invoice = FinancialListingModel.fromJobInvoicesJson(jsonData['job_invoice']);
      Map<String, dynamic> data = {
        "data" : invoice,
        "status" : jsonData['status'] == 200
      };
      return data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updateInvoice(int? invoiceId, Map<String, dynamic> params) async {
    try {
      final response = await dio.put("${Urls.jobinvoice}/$invoiceId", data: params, options: putRequestFormOptions);
      final jsonData = json.decode(response.toString());
      FinancialListingModel invoice = FinancialListingModel.fromJobInvoicesJson(jsonData['job_invoice']);
      Map<String, dynamic> data = {
        "data" : invoice,
        "status" : jsonData['status'] == 200
      };
      return data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<int?> fetchChangeOrderIdByInvoiceId(int? invoiceId) async {
    try {
      final response = await dio.get(Urls.changeOrderByInvoiceId(invoiceId ?? 0));
      final jsonData = json.decode(response.toString());

      if(jsonData['data']['id'] != null) {
       return jsonData['data']['id'];
      } else {
       return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<FinancialListingModel> updateLeapPayPreferences({required int id, required Map<String, dynamic> params})  async {
    try{
      final response = await dio.put(Urls.changePaymentSetting(id), queryParameters: params);
      final jsonData = json.decode(response.toString());
      FinancialListingModel updatedModel = FinancialListingModel.fromJobInvoicesJson(jsonData['job_invoice']);
      return updatedModel;
    } catch(e) {
      //Handle error
      rethrow;
    }
  }

}

  