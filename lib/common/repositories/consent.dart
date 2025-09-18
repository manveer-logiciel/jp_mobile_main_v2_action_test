import 'dart:convert';
import 'package:jobprogress/common/models/twilio_status.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

import '../models/phone_consents.dart';

class ConsentRepository {
  static Future<TwilioStatusModel> getTwilioStatus() async {
    try {
      final response = await dio.get(Urls.twilioStatus);
      final jsonData = json.decode(response.toString())['data'];
      return TwilioStatusModel.fromJson(jsonData);
    } catch (e) {
      rethrow;
    }
  }

  static Future<PhoneConsentModel> setNoMessageConsent({Map<String, dynamic>? params}) async {
    try {
      final response = await dio.post(Urls.noMessageConsent, queryParameters: params);
      final jsonData = json.decode(response.toString())['data'];
      return PhoneConsentModel.fromJson(jsonData ?? {});
    } catch (e) {
      rethrow;
    }
  }

  static Future<PhoneConsentModel> setExpressConsent({Map<String, dynamic>? params}) async {
    try {
      final response = await dio.post(Urls.expressConsent, queryParameters: params);
      final jsonData = json.decode(response.toString())['data'];
      return PhoneConsentModel.fromJson(jsonData);
    } catch (e) {
      rethrow;
    }
  }
}