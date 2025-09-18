import 'dart:convert';

import 'package:get/get.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/common_constants.dart';

import '../../../core/config/app_env.dart';
import '../../../core/utils/helpers.dart';

class ApiGatewayService extends GetxService {

  final Map<String, dynamic> requestInfo = {};

  static ApiGatewayService setUp() => Get.put(ApiGatewayService());

  Future<void> getApiGatewayUrls() async {
    if (Get.testMode) return;
      final response = await dio.get(AppEnv.config[CommonConstants.apiGatewayUrl]);
      requestInfo.clear();
      requestInfo.addAll(json.decode(response.toString()));
  }

  Future<void> init() async {
    try {
      await getApiGatewayUrls();
    } catch(e) {
      Helper.recordError(e);
    }
  }

  bool isL5Url(String url, String method) {
    var version = 'v1';
    if (url.contains('v2')) {
      version = 'v2';
    }
    final finalUrl = url.replaceAll('?', '');
    List<String> apiEndPoint = finalUrl.split(version);

    if (apiEndPoint.length > 1) {
      final RegExp alphaNumericRegExp = RegExp(
          r'(?=[a-zA-Z0-9])(?![0-9]+_\b)[a-zA-Z]*[0-9][a-zA-Z0-9]*');
      apiEndPoint[1] = apiEndPoint[1].replaceAllMapped(
          alphaNumericRegExp, (match) => '{id}');

      var apiToValidate = '$method:$version${apiEndPoint[1]}';

      return Helper.isTrue(requestInfo[apiToValidate]);
    } else {
      return false;
    }
  }
}