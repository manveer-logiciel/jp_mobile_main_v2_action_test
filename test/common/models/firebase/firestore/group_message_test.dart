
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/models/firebase/firestore/group_message.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';

void main() {
  final tempGroupMessage = GroupMessageModel(
    companyId: "1",
    groupId: "1",
    updatedAt: DateTime.parse("2021-01-01 00:00:00"),
  );

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    RunModeService.setRunMode(RunMode.unitTesting);
    Get.testMode = true;
  });

  group("GroupMessageModel@getConvertedTime should convert `updatedAt` as per user's timezone ", () {
    // It is expected that `updatedAt` is always going to be there and in a valid format
    // from the api side
    test("In case time zone conversion fails, server date time should be used", () {
      // This is a failure case where-in app time zone is not initialized
      final convertedTime = tempGroupMessage.getConvertedTime({
        "created_at": "2020-01-01 00:00:00"
      });

      expect(convertedTime, "2020-01-01 00:00:00");
    });

    test("In case of invalid time, Time should not be set", () {
      final convertedTime = tempGroupMessage.getConvertedTime({
        "created_at": "2020-01-01"
      });

      expect(convertedTime, "");
    });

    test("In case timezone conversion passes, converted time should be used", () {
      CompanySettingsService.setCompanySettings([
        {
          'key': CompanySettingConstants.timeZone,
          'value': 'America/New_York'
        }
      ]);
      DateTimeHelper.setUpTimeZone();

      final convertedTime = tempGroupMessage.getConvertedTime({
        "created_at": "2020-01-01 00:00:00"
      });

      expect(convertedTime, '2019-12-31 19:00:00');
    });
  });

  group("GroupMessageModel.fromApiJson should parse fields properly", () {
    group("[sender] should be set properly", () {
      test("In case sender is null, it should not be set", () {
        final result = GroupMessageModel.fromApiJson({
          "sender": null,
          "created_at": "2021-01-01 00:00:00",
          "thread_id": "1"
        });
        expect(result.sender, null);
      });

      test("In case sender is not null, it should be set", () {
        final result = GroupMessageModel.fromApiJson({
          "sender": {
            "id": "1",
            "first_name": "Test",
            "last_name": "User",
          },
          "created_at": "2021-01-01 00:00:00",
          "thread_id": "1"
        });
        expect(result.sender, "1");
      });

      test("In case sender is not available, it should not be set", () {
        final result = GroupMessageModel.fromApiJson({
          "created_at": "2021-01-01 00:00:00",
          "thread_id": "1"
        });
        expect(result.sender, null);
      });
    });

    group("[isMyMessage] should be set properly", () {
      setUp(() {
        AuthService.userDetails = UserModel(
          id: 1,
          firstName: "Test",
          fullName: "Test User",
          email: "test@example.com",
        );
      });

      test("In case sender is not available, it should not be set", () {
        final result = GroupMessageModel.fromApiJson({
          "created_at": "2021-01-01 00:00:00",
          "thread_id": "1"
        });
        expect(result.isMyMessage, false);
      });

      test("In case sender is available and is equal to logged in user id, it should be set", () {
        final result = GroupMessageModel.fromApiJson({
          "sender": {
            "id": "1",
            "first_name": "Test",
            "last_name": "User",
          },
          "created_at": "2021-01-01 00:00:00",
          "thread_id": "1"
        });
        expect(result.isMyMessage, true);
      });

      test("In case sender is available and is not equal to logged in user id, it should not be set", () {
        final result = GroupMessageModel.fromApiJson({
          "sender": {
            "id": "2",
            "first_name": "Test",
            "last_name": "User",
          },
          "created_at": "2021-01-01 00:00:00",
          "thread_id": "1"
        });
        expect(result.isMyMessage, false);
      });
    });
  });
}