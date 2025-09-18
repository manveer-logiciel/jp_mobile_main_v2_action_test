
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/services/dev_console/index.dart';
import 'package:jobprogress/core/config/app_env.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/mix_panel/index.dart';

void main() {
  group("DevConsoleService@getErrorType should give Type of the recorded error", () {
    group("In case of Api Error", () {
      test("When type of DioException is not known, default type should be unknown", () {
        final error = DioException(
          requestOptions: RequestOptions(path: "xyz"),
        );
        expect(DevConsoleService.getErrorType(error), DioExceptionType.unknown.toString());
      });

      group("When type of DioException is known, appropriate type should be returned", () {
        test("In case of Bad Response", () {
          final error = DioException(
            requestOptions: RequestOptions(path: "xyz"),
            type: DioExceptionType.badResponse,
          );
          expect(DevConsoleService.getErrorType(error), DioExceptionType.badResponse.toString());
        });

        test("In case of Cancelled", () {
          final error = DioException(
            requestOptions: RequestOptions(path: "xyz"),
            type: DioExceptionType.cancel,
          );
          expect(DevConsoleService.getErrorType(error), DioExceptionType.cancel.toString());
        });

        test("In case of Connection Timeout", () {
          final error = DioException(
            requestOptions: RequestOptions(path: "xyz"),
            type: DioExceptionType.connectionTimeout,
          );
          expect(DevConsoleService.getErrorType(error), DioExceptionType.connectionTimeout.toString());
        });

        test("In case of Receive Timeout", () {
          final error = DioException(
            requestOptions: RequestOptions(path: "xyz"),
            type: DioExceptionType.receiveTimeout,
          );
          expect(DevConsoleService.getErrorType(error), DioExceptionType.receiveTimeout.toString());
        });

        test("In case of Send Timeout", () {
          final error = DioException(
            requestOptions: RequestOptions(path: "xyz"),
            type: DioExceptionType.sendTimeout,
          );
          expect(DevConsoleService.getErrorType(error), DioExceptionType.sendTimeout.toString());
        });

        test("In case of Bad Certificate", () {
          final error = DioException(
            requestOptions: RequestOptions(path: "xyz"),
            type: DioExceptionType.badCertificate,
          );
          expect(DevConsoleService.getErrorType(error), DioExceptionType.badCertificate.toString());
        });
      });
    });

    group("In case of App Error, Type of the error should be the runtime type of error class", () {
      test("When Error itself is the error class", () {
        final error = Error();
        expect(DevConsoleService.getErrorType(error), 'Error');
      });

      test("When Error is subclass of the error class", () {
        final error = TypeError();
        expect(DevConsoleService.getErrorType(error), 'TypeError');
      });
    });

    group("In case of App Exception, Type of the exception should be the runtime type of exception class", () {
      test("When Exception itself is the exception class", () {
        final error = Exception();
        expect(DevConsoleService.getErrorType(error), '_Exception');
      });

      test("When Exception is subclass of the exception class", () {
        const error = FormatException();
        expect(DevConsoleService.getErrorType(error), 'FormatException');
      });
    });
  });

  group("DevConsoleService@getErrorDescription should give description of the recorded error", () {
    group("In case of Api error", () {
      test("Description should have request path if error is missing", () {
        final error = DioException(
          requestOptions: RequestOptions(path: "https://xyz"),
        );
        expect(DevConsoleService.getErrorDescription(error), contains("https://xyz"));
      });

      test("Description should have error if path is missing", () {
        final error = DioException(
          requestOptions: RequestOptions(path: ""),
          error: DioException(
            requestOptions: RequestOptions(path: ""),
            message: "error message"
          )
        );
        expect(DevConsoleService.getErrorDescription(error), contains("DioException [unknown]: error message"));
      });

      test("Description should have request path and error if both are present", () {
        final error = DioException(
          requestOptions: RequestOptions(path: "https://xyz"),
          error: DioException(
            requestOptions: RequestOptions(path: "https://xyz"),
            message: "error message"
          )
        );
        expect(DevConsoleService.getErrorDescription(error), contains("https://xyz\nplease_check_your_internet_connection\nDioException [unknown]: error message"));
      });

      test("Description should use error as a message if message is missing", () {
        final error = DioException(
          requestOptions: RequestOptions(path: ""),
          error: DioException(
            requestOptions: RequestOptions(path: ""),
          )
        );
        expect(DevConsoleService.getErrorDescription(error), contains("DioException [unknown]: null"));
      });

      test("Description should have error message given from the API in response", () {
        final error = DioException(
            requestOptions: RequestOptions(path: ""),
            type: DioExceptionType.badResponse,
            response: Response(
              statusCode: 412,
              requestOptions: RequestOptions(),
              data: {
                'error': {
                  'message': "Invalid Password"
                }
              }
            ),
            error: DioException(
              requestOptions: RequestOptions(path: ""),
            )
        );

        expect(DevConsoleService.getErrorDescription(error), contains("Invalid Password"));
      });
    });

    group("In case of App Error", () {
      test("Description should be the error itself", () {
        final error = RangeError("greater than 0");
        expect(DevConsoleService.getErrorDescription(error), "RangeError: greater than 0");
      });

      test("Description should be followed for first line of stacktrace", () {
        dynamic error;
        try {
          throw RangeError("greater than 0");
        } catch (e) {
          error = e;
        } finally {
          expect(DevConsoleService.getErrorDescription(error), contains('RangeError: greater than 0\n'
              '#0      main.<anonymous closure>.<anonymous closure>.<anonymous closure>'));
        }
      });
    });

    test("In case of any other error, error itself should be used as description", () {
      const error = FormatException();
      expect(DevConsoleService.getErrorDescription(error), error.toString());
    });
  });

  group("DevConsoleService@setUpTokens should set-up all the tokens to be excluded from console", () {
    setUp(() {
      DevConsoleService.setUpTokens();
    });

    test("Google Maps key should be part of exclusion", () {
      expect(DevConsoleService.tokens.containsKey("GOOGLE_MAPS_KEY"), isTrue);
    });

    test("Mixpanel token key should be part of exclusion", () {
      expect(DevConsoleService.tokens.containsKey(MixPanelConstants.mixPanelTokenKey), isTrue);
    });

    test("Justifi client id should be part of exclusion", () {
      expect(DevConsoleService.tokens.containsKey(CommonConstants.justifiClientId), isTrue);
    });

    test("LD Mobile key should be part of exclusion", () {
      expect(DevConsoleService.tokens.containsKey(CommonConstants.ldMobileKey), isTrue);
    });

    test("Firebase options should be part of exclusion", () {
      expect(DevConsoleService.tokens.containsKey('FIREBASE_OPTIONS-APIKEY'), isTrue);
      expect(DevConsoleService.tokens.containsKey('FIREBASE_OPTIONS-APPID'), isTrue);
      expect(DevConsoleService.tokens.containsKey('FIREBASE_OPTIONS-MESSAGINGSENDERID'), isTrue);
      expect(DevConsoleService.tokens.containsKey('FIREBASE_OPTIONS-PROJECTID'), isTrue);
      expect(DevConsoleService.tokens.containsKey('FIREBASE_OPTIONS-DATABASEURL'), isTrue);
      expect(DevConsoleService.tokens.containsKey('FIREBASE_OPTIONS-STORAGEBUCKET'), isTrue);
      expect(DevConsoleService.tokens.containsKey('FIREBASE_OPTIONS-ANDROIDCLIENTID'), isTrue);
    });

    test("Secondary Firebase options should be part of exclusion", () {
      expect(DevConsoleService.tokens.containsKey('JP_DATA_FIREBASE_PROJECT-APIKEY'), isTrue);
      expect(DevConsoleService.tokens.containsKey('JP_DATA_FIREBASE_PROJECT-APPID'), isTrue);
      expect(DevConsoleService.tokens.containsKey('JP_DATA_FIREBASE_PROJECT-MESSAGINGSENDERID'), isTrue);
      expect(DevConsoleService.tokens.containsKey('JP_DATA_FIREBASE_PROJECT-PROJECTID'), isTrue);
      expect(DevConsoleService.tokens.containsKey('JP_DATA_FIREBASE_PROJECT-DATABASEURL'), isTrue);
      expect(DevConsoleService.tokens.containsKey('JP_DATA_FIREBASE_PROJECT-STORAGEBUCKET'), isTrue);
      expect(DevConsoleService.tokens.containsKey('JP_DATA_FIREBASE_PROJECT-ANDROIDCLIENTID'), isTrue);
    });
  });

  group("DevConsoleService@parseFirebaseTokens should parse firebase options to key-value pair to be included from console errors", () {
    test("When options do not exist", () {
      expect(DevConsoleService.parseFirebaseTokens("NO_OPTIONS"), <String, dynamic>{});
    });
    
    test("When options exist, they should be parsed with proper names", () {
      final options = DevConsoleService.parseFirebaseTokens("FIREBASE_OPTIONS");
      expect(options.containsKey('FIREBASE_OPTIONS-APIKEY'), isTrue);
    });
  });
  
  group("DevConsoleService@removeTokens should remove tokens from error log with its key", () {
    setUp(() {
      DevConsoleService.setUpTokens();
    });

    test("When there is no token in error log, error should be returned", () {
      final error = RangeError("greater than 0");
      expect(DevConsoleService.removeTokens(DevConsoleService.getErrorDescription(error)), error.toString());
    });

    test("When there are tokens in error log, token should be replaced", () {
      final error = RangeError("greater than 0 ${AppEnv.envConfig["GOOGLE_MAPS_KEY"]}");
      expect(DevConsoleService.removeTokens(DevConsoleService.getErrorDescription(error)), 'RangeError: greater than 0 [GOOGLE_MAPS_KEY]');
    });
  });
}