import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/dev_console.dart';
import 'package:jobprogress/common/providers/http/dio_exception_handler.dart';
import 'package:jobprogress/common/repositories/sql/dev_console.dart';
import 'package:jobprogress/core/config/app_env.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/mix_panel/index.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/routes/pages.dart';

class DevConsoleService {

  static Map<String, dynamic> tokens = {};
  static int devConsoleTapCount = 0;

  /// [init] - initializes the dev console service
  static void init() {
    DevConsoleService.setUpTokens();
    DevConsoleService.clearOldDevLogs();
  }

  static void recordError(Object? error) async {
    try {
      await SqlDevConsoleRepository.insertLog(DevConsoleModel.fromError(error));
    } catch (e) {
      // reason for not rethrowing this error or recording it with Helper.recordError()
      // so if any case somehow [insertLog] fails It can result in infinite loop of error recording
      debugPrint(e.toString());
    }
  }

  /// [getErrorType] will return type of error in case of Api Error i.e., [DioException]
  /// it's going to return [Type] of [Error] while for any other error it's going to give
  /// the [runtimeType] directly which can be further used to display the error type
  static String getErrorType(Object? e) {
    if (e is DioException) {
      return e.type.toString();
    }
    return e.runtimeType.toString();
  }

  /// [getErrorDescription] will return description of error in case of Api Error i.e., [DioException]
  /// it's going to return [Message] of [Error] appended after [path] while for any other error
  /// it's going to give the error itself as description
  static String getErrorDescription(Object? e) {
    String description = '';
    if (e is DioException) {
      String errorMessage = "${DioExceptions.fromDioError(e)}\n";
      errorMessage += (e.message ?? e.error.toString());
      description += !Helper.isValueNullOrEmpty(e.requestOptions.path) ? ("${e.requestOptions.path}\n") : "";
      description += !Helper.isValueNullOrEmpty(errorMessage) ? errorMessage : "";
    } else if (e is Error) {
      description += !Helper.isValueNullOrEmpty(e.toString()) ? ('$e\n') : "";
      description += (e.stackTrace?.toString().split("\n")[0] ?? "");
    } else {
      description = e?.toString() ?? "";
    }
    return removeTokens(description.trim());
  }

  /// [setUpTokens] is used to set up tokens that should be removed explicitly from
  /// dev console so they are not visible to user
  static void setUpTokens() {
    tokens = {
      "GOOGLE_MAPS_KEY": AppEnv.envConfig["GOOGLE_MAPS_KEY"] ?? "",
      MixPanelConstants.mixPanelTokenKey: AppEnv.envConfig[MixPanelConstants.mixPanelTokenKey],
      CommonConstants.justifiClientId: AppEnv.envConfig[CommonConstants.justifiClientId],
      CommonConstants.ldMobileKey: AppEnv.envConfig[CommonConstants.ldMobileKey],
      ...parseFirebaseTokens("FIREBASE_OPTIONS"),
      ...parseFirebaseTokens(CommonConstants.secondFirebaseAppName),
      CommonConstants.beaconClientId: AppEnv.envConfig[CommonConstants.beaconClientId]
    };
    tokens.removeWhere((key, value) => Helper.isValueNullOrEmpty(value));
  }

  /// [removeTokens] is responsible for remove the token from error description
  /// any available token will be replaced by the which token it is e.g.,
  /// With token -> Error: Invalid mixpanel token: actual_token_from_mixpanel
  /// After Removing Token -> Error: Invalid mixpanel token: MIX_PANEL_TOKEN
  static String removeTokens(String description) {
    tokens.forEach((key, value) {
      description = description.replaceAll(value, "[$key]");
    });
    return description;
  }

  /// [parseFirebaseTokens] converts the firebase options to a map so, any token
  /// related to firebase can be removed from Dev Console log
  static Map<String, dynamic> parseFirebaseTokens(String key) {
    Map<String, dynamic> firebaseTokens = {};
    (AppEnv.envConfig[key] as FirebaseOptions?)?.asMap.forEach((subKey, value) {
      firebaseTokens.putIfAbsent(("$key-$subKey".toUpperCase()), () => value.toString());
    });
    return firebaseTokens;
  }

  /// [clearOldDevLogs] - is responsible for clearing dev logs that are older than 7 days
  static Future<void> clearOldDevLogs() async {
    try {
      await SqlDevConsoleRepository.clearOldLogs();
    } catch (e) {
      Helper.recordError(e);
    }
  }

  static void forceOpenDevConsole() {
    if (devConsoleTapCount == 0) {
      Future.delayed(const Duration(seconds: 1), () {
        devConsoleTapCount = 0;
      });
    }
    devConsoleTapCount++;
    if (devConsoleTapCount == 3) {
      devConsoleTapCount = 0;
      Get.toNamed(Routes.devConsole);
    }
  }
}