import 'dart:convert';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/core/constants/urls.dart';


class ConnectedThirdPartyRepository {
 static void fetchConnectedThirdParty(Map<String, dynamic> connectedThirdPartyParam) async {
    try {
      final response = await dio.get(Urls.connectedThirdParty, queryParameters: connectedThirdPartyParam);
      final jsonData = json.decode(response.toString());
      ConnectedThirdPartyService.setConnectedParty(jsonData['data']);
    } catch (e) {
      rethrow;
    }
  }
}
