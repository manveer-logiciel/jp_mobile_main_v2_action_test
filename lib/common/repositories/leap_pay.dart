import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/models/justifi/sync_status.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/urls.dart';

class LeapPayRepository {
  static Future<FinancialListingModel?> processPayment(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.leapPayPayment, queryParameters: params);
      final jsonData = json.decode(response.toString());
      return FinancialListingModel.fromPaymentsReceivedJson(jsonData['data']['payment']);
    } catch (e) {
      rethrow;
    }
  }

  static Future<PaymentStatusSyncModel> syncPaymentStatus(String paymentId, CancelToken? cancelToken) async {
    try {
      final response = await dio.post(Urls.leapPayPaymentSyncStatus(paymentId),
          cancelToken: cancelToken,
          queryParameters: {
            ...CommonConstants.avoidGlobalCancelToken,
            ...CommonConstants.ignoreToastQueryParam,
          }
      );
      final jsonData = json.decode(response.toString());
      return PaymentStatusSyncModel.fromJson(jsonData?['data']);
    } catch (e) {
      rethrow;
    }
  }
}