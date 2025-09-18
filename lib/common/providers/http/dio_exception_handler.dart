
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/location/background_location_service.dart';
import 'package:jobprogress/common/services/shared_pref.dart';
import 'package:jobprogress/routes/pages.dart';

import '../../../core/constants/urls.dart';

SharedPrefService preferences = SharedPrefService();

class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = "request_to_api_was_cancelled".tr;
        break;
      case DioExceptionType.connectionTimeout:
        message = "connect_time_out_from_api".tr;
        break;
      case DioExceptionType.unknown:
      case DioExceptionType.connectionError:
        message = "please_check_your_internet_connection".tr;
        break;
      case DioExceptionType.receiveTimeout:
        message = "receive_timeout_in_connection_with_api_server".tr;
        break;
      case DioExceptionType.badResponse:
        message = _handleError(
            dioError.response!.statusCode, dioError.response!.data, path: dioError.requestOptions.path);
        break;
      case DioExceptionType.sendTimeout:
        message = "send_timeout_in_connection_with_api_server".tr;
        break;
      default:
        message = 'something_went_wrong'.tr;
        break;
    }
  }

  late String message;

  String _handleError(int? statusCode, dynamic error, { String? path }) {
  
    switch (statusCode) {
      case 400:
        return 'bad_request'.tr;
      case 401:
        BackgroundLocationService.stopTracking();
        if(Get.currentRoute != Routes.login) {
          Get.offNamedUntil(Routes.login, (route) => false);
          preferences.removeAll();
        }
        return 'access_denied_please_login_again'.tr;
      case 402:
        if (path == Urls.switchCompany) {
          Get.back();
        } else if(Get.currentRoute != Routes.login) {
          Get.offNamedUntil(Routes.login, (route) => false);
          preferences.removeAll();
        }      
       return error["error"]["message"];
      case 404:
      case 403:
      case 500:
        return error["error"]["message"];
      case 412:
        if (error["error"]["validation"] != null) {
          var firstKey = "";

          var validations = error["error"]["validation"];

          for (var key in error["error"]["validation"].keys.toList()) {
            firstKey = key;
            break;
          }

          if (validations[firstKey] != null &&
              validations[firstKey][0] != null) {
            return validations[firstKey][0];
          } else {
            return validations[firstKey];
          }
        } else if(error["error"]["message"] is! String){
          return '';
        }
         else if (error["error"]["message"] != null) {
          return error["error"]["message"];
        }
         else {
          return 'something_went_wrong'.tr;
        }
      default:
        return 'something_went_wrong'.tr;
    }
  }

  @override
  String toString() => message;
}
