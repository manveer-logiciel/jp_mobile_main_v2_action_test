import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/sql/company/company.dart';
import 'package:jobprogress/common/models/sql/dev_console.dart';
import 'package:jobprogress/common/libraries/global.dart' as global;
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/auth.dart';

void main() {
  DevConsoleModel? model;

  group("DevConsoleModel.fromJson should handle all the possibilities of data types while json parsing", () {
    test("Case 1: When data within json is empty", () {
      final result = DevConsoleModel.fromJson({});
      expect(result.id, equals(-1));
      expect(result.type, equals(""));
      expect(result.description, equals(""));
      expect(result.companyId, equals(-1));
      expect(result.userId, equals(-1));
      expect(result.page, equals(""));
      expect(result.appVersion, equals(global.appVersion));
      expect(result.createdAt, isNotNull);
      expect(result.updatedAt, equals(""));
    });

    test("Case 2: In case of nullable json data", () {
      final result = DevConsoleModel.fromJson({
        "id": null,
        "type": null,
        "description": null,
        "page": null,
        "app_version": null,
        "created_at": null,
        "updated_at": null,
      });
      expect(result.id, equals(-1));
      expect(result.type, equals(""));
      expect(result.description, equals(""));
      expect(result.companyId, equals(-1));
      expect(result.userId, equals(-1));
      expect(result.page, equals(""));
      expect(result.appVersion, equals(global.appVersion));
      expect(result.createdAt, isNotNull);
      expect(result.updatedAt, equals(""));
    });

    test("Case 3: In case of invalid type json data", () {
      final result = DevConsoleModel.fromJson({
        "id": "2",
        "type": 1,
        "description": 2,
        "company_id": "12",
        "user_id": "12",
        "page": 3,
        "app_version": 12,
        "created_at": 1212,
        "updated_at": 1212,
      });
      expect(result.id, equals(2));
      expect(result.type, equals("1"));
      expect(result.description, equals("2"));
      expect(result.companyId, equals(12));
      expect(result.userId, equals(12));
      expect(result.page, equals("3"));
      expect(result.appVersion, equals("12"));
      expect(result.createdAt, isNotNull);
      expect(result.updatedAt, equals("1212"));
    });

    test("Case 4: In case of valid type json data", () {
      final result = DevConsoleModel.fromJson({
        "id": 2,
        "type": "1",
        "description": "2",
        "company_id": 12,
        "user_id": 12,
        "page": "3",
        "app_version": "12",
        "created_at": DateTime.now().toString(),
        "updated_at": DateTime.now().toString(),
      });
      expect(result.id, equals(2));
      expect(result.type, equals("1"));
      expect(result.description, equals("2"));
      expect(result.companyId, equals(12));
      expect(result.userId, equals(12));
      expect(result.page, equals("3"));
      expect(result.appVersion, equals("12"));
      expect(result.createdAt, isNotNull);
      expect(result.updatedAt, isNotNull);
    });
  });

  group("DevConsoleModel.fromError should parse error to DevConsoleModel", () {
    group("In case of invalid error", () {
      setUp(() {
        AuthService.userDetails = null;
        model = DevConsoleModel.fromError(null);
      });

      test("ID should be null by default", () {
        expect(model?.id, isNull);
      });

      test("Type should be Null and Description of error should be empty", () {
        expect(model?.type, equals("Null"));
        expect(model?.description, equals(""));
      });

      test("Page should not be null", () {
        expect(model?.page, isNotNull);
      });

      test("User ID and Company ID should be -1", () {
        expect(model?.companyId, -1);
        expect(model?.userId, -1);
      });

      test("Version Name should be set to apps current version", () {
        expect(model?.appVersion, equals(global.appVersion));
      });

      test("Created At and Updated At should not be null", () {
        expect(model?.createdAt, isNotNull);
        expect(model?.updatedAt, isNotNull);
      });
    });

    group("In case of valid error", () {
      setUp(() {
        AuthService.userDetails = UserModel(
            id: 2,
            firstName: "John",
            fullName: "John Williams",
            email: "",
            companyDetails: CompanyModel(
              id: 3,
              companyName: '',
            )
        );

        model = DevConsoleModel.fromError(
          DioException(
            requestOptions: RequestOptions(path: "https://xyz"),
            message: "Error message goes here",
          ),
        );
      });

      test("ID should be null by default", () {
        expect(model?.id, isNull);
      });

      test("Type and Description of error should be set properly", () {
        expect(model?.type, equals("DioExceptionType.unknown"));
        expect(model?.description, equals("https://xyz\nplease_check_your_internet_connection\nError message goes here"));
      });

      test("Page should not be null", () {
        expect(model?.page, isNotNull);
      });

      test("User ID and Company ID should be set from logged In user", () {
        expect(model?.companyId, 3);
        expect(model?.userId, 2);
      });

      test("Version Name should be set to apps current version", () {
        expect(model?.appVersion, global.appVersion);
      });

      test("Create At and Updated At should be set to current time", () {
        expect(model?.createdAt, isNotNull);
        expect(model?.updatedAt, isNotNull);
      });
    });
  });

  group("DevConsoleModel@toJson should parse DevConsoleModel to json", () {
    test("In case of invalid data, it should be parsed properly", () {
      model = DevConsoleModel();

      final result = model?.toJson();
      expect(result?['id'], isNull);
      expect(result?['type'], isNull);
      expect(result?['description'], isNull);
      expect(result?['company_id'], isNull);
      expect(result?['user_id'], isNull);
      expect(result?['page'], isNull);
      expect(result?['app_version'],isNull);
      expect(result?['created_at'], isNotNull);
      expect(result?['updated_at'], isNotNull);
    });

    test("In case of valid data, it should be parsed properly", () {
      model = DevConsoleModel(
        id: 2,
        type: "1",
        description: "2",
        companyId: 12,
        userId: 12,
        page: "3",
        appVersion: "12",
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
      );

      final result = model?.toJson();
      expect(result?['id'], equals(2));
      expect(result?['type'], equals("1"));
      expect(result?['description'], equals("2"));
      expect(result?['company_id'], equals(12));
      expect(result?['user_id'], equals(12));
      expect(result?['page'], equals("3"));
      expect(result?['app_version'], equals("12"));
      expect(result?['created_at'], isNotNull);
      expect(result?['updated_at'], isNotNull);
    });
  });
}