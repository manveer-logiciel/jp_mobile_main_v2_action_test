import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/home.dart';
import 'package:jobprogress/core/constants/server_code.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/modules/home/controller.dart';

import '../../../../integration_test/mock_responses/common/mock_duration.dart';
import '../../../../integration_test/mock_responses/feature_flag_mock_response.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late DioAdapter dioAdapter;
  late HomeService service;
  bool isAccountLocked = false;

  setUpAll(() {
    dioAdapter = DioAdapter(dio: dio);
    service = HomeService(update: () {}, homeController: HomeController());
  });

  setUp(() {
    isAccountLocked = false;
  });

  group('Dio exception handling in case of account is locked', () {
    test('Account should be locked when server responds as account is locked', () async {
      try {
        dioAdapter.onGet(
            Urls.featureFlag,
                (server) => server.reply(ServerCode.accountLocked,
                    null,
                    delay: MockDuration.value)
        );

        await service.getFeatureFlags();
      } catch (e) {
        expect((e as DioException).response?.statusCode,
            equals(ServerCode.accountLocked));
        isAccountLocked = true;
      }

      expect(isAccountLocked, isTrue);
    });

    test('Account should not be locked when server responds as account is ok', () async {
        dioAdapter.onGet(
            Urls.featureFlag,
                (server) => server.reply(ServerCode.ok,
                    FeatureFlagMockResponse.okResponse,
                    delay: MockDuration.value)
        );

        await service.getFeatureFlags();
        
        expect(isAccountLocked, isFalse);
    });
  });

}