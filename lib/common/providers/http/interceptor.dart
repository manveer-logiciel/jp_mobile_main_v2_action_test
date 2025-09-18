import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/providers/http/dio_exception_handler.dart';
import 'package:jobprogress/common/services/api_gateway/index.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/shared_pref.dart';
import 'package:jobprogress/core/config/app_env.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/shared_pref_constants.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/common/libraries/global.dart' as globals;
import 'package:jobprogress/routes/pages.dart';

SharedPrefService preferences = SharedPrefService();

ApiGatewayService apiGatewayService = Get.find();

var dio = Dio();

Options putRequestFormOptions = Options(
    contentType: Headers.formUrlEncodedContentType
);

CancelToken? cancelToken = CancelToken();

class ApiProvider {

  static bool isUnstableConnection = false;

  static void setAuthInterceptor() async {
    dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () =>
        /// Connection established idle timeout changed from 3 sec to 5 minutes
        HttpClient()..idleTimeout = const Duration(minutes: 5));

    dio.options
      ..connectTimeout = const Duration(minutes: 2) //2m
      ..receiveTimeout = const Duration(minutes: 2); //2m
    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      var customHeaders = {
        'content-type': options.contentType ?? Headers.jsonContentType,
        'mobile': 1,
        'Authorization':
        await preferences.read(PrefConstants.accessToken) != null
            ? 'Bearer ${await preferences.read(PrefConstants.accessToken)}'
            : '',
        'app-version': globals.appVersion,
      };

      if(apiGatewayService.isL5Url(options.path, options.method)) {
        customHeaders['X-Api-Version'] = 'L5';
      }

      if (!(options.queryParameters['isGlobalCancelTokenAvoided'] ?? false)) {
        options.cancelToken = cancelToken = CancelToken();
      }
      options.headers.addAll(customHeaders);
      isUnstableConnection = false;
      if (doResetTimeOut(options.path)) {
        options.connectTimeout = const Duration(seconds: 45);
        options.receiveTimeout = const Duration(seconds: 45);
      }
      return handler.next(options);
    }, onResponse: (response, handler) {
      return handler.next(response); // continue
    }, onError: (DioException error, handler) {
      if (error.type != DioExceptionType.cancel) {
        final params = error.requestOptions.queryParameters;
        final errorMessage = DioExceptions.fromDioError(error).toString();
        if (!isUnstableConnection && !(params['ignoreToast'] ?? false)) {
          isUnstableConnection = checkIsUnstableConnection(error);
          if (!isUnstableConnection && !Helper.isValueNullOrEmpty(errorMessage)) Helper.showToastMessage(errorMessage);
        }
        return handler.next(error);
      }
    }));
  }

  /// [checkIsUnstableConnection] - checks whether the connection is unstable or not
  /// This check will be performed only on the [HomeView]/[Routes.home] for now which is the first screen
  /// and is responsible for loading required data for application to function
  static bool checkIsUnstableConnection(DioException error) {
    return error.response?.statusCode == 409
        || (Get.currentRoute == Routes.home
            && (error.type == DioExceptionType.connectionError
            || error.type == DioExceptionType.connectionTimeout
            || error.type == DioExceptionType.receiveTimeout)
           );
  }

  /// [doResetTimeOut] decides for some of the requests to reset the time out to 45 sec
  /// so connection can be considered as unstable if it takes more than 45 sec
  static bool doResetTimeOut(String endPoint) {
    List<String> endPointsWithLessTimeOut = [
      AppEnv.config[CommonConstants.apiGatewayUrl],
      Urls.setCookie,
      Urls.subscriberDetails,
      Urls.companySettings,
      Urls.featureFlag,
      Urls.permissions,
      Urls.connectedThirdParty,
      Urls.lastEntityUpdate,
      '${Urls.user}/${AuthService.userDetails?.id}'
    ];

    return endPointsWithLessTimeOut.contains(endPoint);
  }

}
