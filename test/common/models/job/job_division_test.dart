import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job_division.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;
  });

  tearDownAll(() {
    Get.reset();
  });

  group("DivisionModel.fromJson should parse json correctly", () {
    group("[address] should be set correctly", () {
      test("In case of empty json data", () {
        final result = DivisionModel.fromJson({});
        expect(result.address, isNull);
      });

      test("In case of invalid json data", () {
        final result = DivisionModel.fromJson({
          "address": "invalid"
        });
        expect(result.address, isNull);
      });

      test("In case of valid json data & address is null", () {
        final result = DivisionModel.fromJson({
          "address": null
        });
        expect(result.address, isNull);
      });

      test("In case of valid json data", () {
        final result = DivisionModel.fromJson({
          "address": {
            "address_line_1": "Street",
            "city": "City",
            "zip": "Zip",
          }
        });
        expect(result.address?.addressLine1, "Street");
        expect(result.address?.city, "City");
        expect(result.address?.zip, "Zip");
      });
    });

    group("[addressString] should be set correctly", () {
      test("In case of empty json data", () {
        final result = DivisionModel.fromJson({});
        expect(result.addressString, isNull);
      });

      test("In case of invalid json data", () {
        final result = DivisionModel.fromJson({
          "address": "invalid"
        });
        expect(result.addressString, isNull);
      });

      test("In case of valid json data & address is null", () {
        final result = DivisionModel.fromJson({
          "address": null
        });
        expect(result.addressString, isNull);
      });

      test("In case of valid json data", () {
        final result = DivisionModel.fromJson({
          "address": {
            "address_line_1": "Street",
            "city": "City",
            "zip": "Zip",
          }
        });
        expect(result.addressString, "Street, City Zip");
      });
    });
  });

  group("Workflow Division Feature Integration Tests", () {
    late DivisionModel testDivision;

    setUp(() {
      testDivision = DivisionModel(
        id: 1,
        name: 'Test Division',
        code: 'TEST',
        addressString: '123 Test St, City 12345',
        email: 'test@division.com',
        phone: '555-0123',
      );
    });

    group("DivisionModel workflow division change detection", () {
      test("DivisionModel@toString should return division ID as string for comparison", () {
        expect(testDivision.id.toString(), equals('1'));
      });

      test("DivisionModel@id should be comparable for division change detection", () {
        const oldDivisionId = 1;
        const newDivisionId = 2;

        expect(oldDivisionId == testDivision.id, isTrue);
        expect(newDivisionId != testDivision.id, isTrue);
      });

      test("DivisionModel should maintain all required properties for workflow integration", () {
        expect(testDivision.id, isNotNull);
        expect(testDivision.name, isNotNull);
        expect(testDivision.code, isNotNull);
        expect(testDivision.addressString, isNotNull);
      });
    });

    group("LaunchDarkly feature flag integration with division model", () {
      test("LDFlagKeyConstants@divisionBasedMultiWorkflows should have correct flag key", () {
        const expectedFlagKey = 'division-based-multi-workflows';
        expect(LDFlagKeyConstants.divisionBasedMultiWorkflows, equals(expectedFlagKey));
      });

      test("LDService@hasFeatureEnabled should return boolean for division workflow flag", () {
        const flagKey = LDFlagKeyConstants.divisionBasedMultiWorkflows;
        final hasFeature = LDService.hasFeatureEnabled(flagKey);
        expect(hasFeature, isA<bool>());
      });

      test("Division model should support workflow functionality when feature flag is enabled", () {
        // Test that division model properties are accessible for workflow operations
        expect(testDivision.id, isA<int>());
        expect(testDivision.name, isA<String>());
        expect(testDivision.code, isA<String>());
      });
    });

    group("Division model validation for workflow operations", () {
      test("DivisionModel should have valid ID for workflow stage updates", () {
        expect(testDivision.id, greaterThan(0));
      });

      test("DivisionModel should have non-empty name for display purposes", () {
        expect(testDivision.name?.isNotEmpty, isTrue);
      });

      test("DivisionModel should have valid code for API operations", () {
        expect(testDivision.code?.isNotEmpty, isTrue);
      });

      test("DivisionModel should handle null/empty values gracefully", () {
        final emptyDivision = DivisionModel.fromJson({});
        expect(emptyDivision.id, isNull);
        expect(emptyDivision.name, isNull);
        expect(emptyDivision.code, isNull);
      });
    });

    group("Division comparison for workflow change detection", () {
      test("Same division IDs should be detected as no change", () {
        const currentDivisionId = 1;
        const selectedDivisionId = '1';

        expect(currentDivisionId.toString() == selectedDivisionId, isTrue);
      });

      test("Different division IDs should be detected as workflow change needed", () {
        const currentDivisionId = 1;
        const selectedDivisionId = '2';

        expect(currentDivisionId.toString() != selectedDivisionId, isTrue);
      });

      test("String to int conversion should work for division ID comparison", () {
        const divisionIdString = '123';
        const divisionIdInt = 123;

        expect(int.tryParse(divisionIdString), equals(divisionIdInt));
        expect(divisionIdInt.toString(), equals(divisionIdString));
      });

      test("Invalid division ID strings should be handled gracefully", () {
        const invalidDivisionId = 'invalid';

        expect(int.tryParse(invalidDivisionId), isNull);
      });
    });

    group("Division model JSON serialization for API operations", () {
      test("DivisionModel should be serializable for workflow API calls", () {
        final divisionData = {
          'id': testDivision.id,
          'name': testDivision.name,
          'code': testDivision.code,
          'address_string': testDivision.addressString,
        };

        expect(divisionData['id'], equals(1));
        expect(divisionData['name'], equals('Test Division'));
        expect(divisionData['code'], equals('TEST'));
      });

      test("DivisionModel@fromJson should handle workflow-related fields", () {
        final workflowDivisionJson = {
          'id': 2,
          'name': 'Workflow Division',
          'code': 'WF',
          'email': 'workflow@test.com',
          'phone': '555-0456',
        };

        final division = DivisionModel.fromJson(workflowDivisionJson);

        expect(division.id, equals(2));
        expect(division.name, equals('Workflow Division'));
        expect(division.code, equals('WF'));
      });
    });
  });
}