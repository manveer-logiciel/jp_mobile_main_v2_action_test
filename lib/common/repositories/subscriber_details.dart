
import 'dart:convert';
import 'package:jobprogress/common/models/subscriber/subscriber_details.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/subscriber_details.dart';
import 'package:jobprogress/core/constants/urls.dart';

class SubscriberDetailsRepo {
  static Future<Map<String, dynamic>> getDetails() async {

    try {

      Map<String, dynamic> params = {
        'includes[0]': 'company_cam',
        'includes[1]': 'quickbook',
        'includes[2]': 'ev_client',
        'includes[3]': 'sm_client',
        'includes[4]': 'hover_client',
        'includes[5]': 'license_numbers',
        'includes[6]': 'logos',
        'includes[7]': 'subscription',
        'includes[8]': 'third_party_connections',
      };

      final response = await dio.get(Urls.subscriberDetails, queryParameters: params);
      final jsonData = json.decode(response.toString())['data'];

      Map<String, dynamic> dataToReturn = {
        "details": SubscriberDetailsModel.fromJson(jsonData),
      };
      SubscriberDetailsService.setSubscriberDetails(dataToReturn['details']);
      return dataToReturn;
    } catch (e) {
      rethrow;
    }
  }
}