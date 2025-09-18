import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/workflow/workflow_stage_group.dart';

void main() {
  group('WorkFlowStageGroupModel Tests', () {
    group('Constructor - Basic object creation with required and optional parameters', () {
      test('should create WorkFlowStageGroupModel with required parameters', () {
        final group = WorkFlowStageGroupModel(
          id: 1,
          name: 'Test Group',
        );

        expect(group.id, 1);
        expect(group.name, 'Test Group');
        expect(group.companyId, isNull);
        expect(group.color, isNull);
        expect(group.createdAt, isNull);
        expect(group.updatedAt, isNull);
      });

      test('should create WorkFlowStageGroupModel with all parameters', () {
        final group = WorkFlowStageGroupModel(
          id: 2,
          name: 'Complete Group',
          companyId: 123,
          color: '#FF5733',
          createdAt: '2023-01-01 10:00:00',
          updatedAt: '2023-01-02 15:30:00',
        );

        expect(group.id, 2);
        expect(group.name, 'Complete Group');
        expect(group.companyId, 123);
        expect(group.color, '#FF5733');
        expect(group.createdAt, '2023-01-01 10:00:00');
        expect(group.updatedAt, '2023-01-02 15:30:00');
      });
    });

    group('JSON Serialization - fromJson parsing and validation of API response data', () {
      test('should create WorkFlowStageGroupModel from JSON with all fields', () {
        final json = {
          'id': 1,
          'name': 'Development Team',
          'company_id': 456,
          'color': '#4CAF50',
          'created_at': '2023-01-01 08:00:00',
          'updated_at': '2023-01-01 18:00:00',
        };

        final group = WorkFlowStageGroupModel.fromJson(json);

        expect(group.id, 1);
        expect(group.name, 'Development Team');
        expect(group.companyId, 456);
        expect(group.color, '#4CAF50');
        expect(group.createdAt, '2023-01-01 08:00:00');
        expect(group.updatedAt, '2023-01-01 18:00:00');
      });

      test('should create WorkFlowStageGroupModel from JSON with minimal fields', () {
        final json = {
          'id': 2,
          'name': 'QA Team',
        };

        final group = WorkFlowStageGroupModel.fromJson(json);

        expect(group.id, 2);
        expect(group.name, 'QA Team');
        expect(group.companyId, isNull);
        expect(group.color, isNull);
        expect(group.createdAt, isNull);
        expect(group.updatedAt, isNull);
      });

      test('should handle null values in JSON gracefully', () {
        final json = {
          'id': 3,
          'name': 'Design Team',
          'company_id': null,
          'color': null,
          'created_at': null,
          'updated_at': null,
        };

        final group = WorkFlowStageGroupModel.fromJson(json);

        expect(group.id, 3);
        expect(group.name, 'Design Team');
        expect(group.companyId, isNull);
        expect(group.color, isNull);
        expect(group.createdAt, isNull);
        expect(group.updatedAt, isNull);
      });
    });

    group('JSON Export - toJson serialization for API requests and data persistence', () {
      test('should export to JSON with all fields', () {
        final group = WorkFlowStageGroupModel(
          id: 1,
          name: 'Backend Team',
          companyId: 789,
          color: '#2196F3',
          createdAt: '2023-02-01 09:00:00',
          updatedAt: '2023-02-01 17:30:00',
        );

        final json = group.toJson();

        expect(json['id'], 1);
        expect(json['name'], 'Backend Team');
        expect(json['company_id'], 789);
        expect(json['color'], '#2196F3');
        expect(json['created_at'], '2023-02-01 09:00:00');
        expect(json['updated_at'], '2023-02-01 17:30:00');
      });

      test('should export to JSON excluding null fields', () {
        final group = WorkFlowStageGroupModel(
          id: 2,
          name: 'Frontend Team',
        );

        final json = group.toJson();

        expect(json['id'], 2);
        expect(json['name'], 'Frontend Team');
        expect(json.containsKey('company_id'), false);
        expect(json.containsKey('color'), false);
        expect(json.containsKey('created_at'), false);
        expect(json.containsKey('updated_at'), false);
      });

      test('should export to JSON with partial null fields', () {
        final group = WorkFlowStageGroupModel(
          id: 3,
          name: 'DevOps Team',
          companyId: 101,
          color: null,
          createdAt: '2023-03-01 12:00:00',
          updatedAt: null,
        );

        final json = group.toJson();

        expect(json['id'], 3);
        expect(json['name'], 'DevOps Team');
        expect(json['company_id'], 101);
        expect(json['created_at'], '2023-03-01 12:00:00');
        expect(json.containsKey('color'), false);
        expect(json.containsKey('updated_at'), false);
      });
    });

    group('Local Database JSON - toLocalDbJson with optimized structure for local storage', () {
      test('should export to local DB JSON excluding timestamps', () {
        final group = WorkFlowStageGroupModel(
          id: 1,
          name: 'Mobile Team',
          companyId: 555,
          color: '#FF9800',
          createdAt: '2023-04-01 10:00:00',
          updatedAt: '2023-04-01 16:00:00',
        );

        final localJson = group.toLocalDbJson();

        expect(localJson['id'], 1);
        expect(localJson['name'], 'Mobile Team');
        expect(localJson['company_id'], 555);
        expect(localJson['color'], '#FF9800');
        expect(localJson.containsKey('created_at'), false);
        expect(localJson.containsKey('updated_at'), false);
      });

      test('should export to local DB JSON with minimal fields', () {
        final group = WorkFlowStageGroupModel(
          id: 2,
          name: 'Testing Team',
        );

        final localJson = group.toLocalDbJson();

        expect(localJson['id'], 2);
        expect(localJson['name'], 'Testing Team');
        expect(localJson.containsKey('company_id'), false);
        expect(localJson.containsKey('color'), false);
        expect(localJson.containsKey('created_at'), false);
        expect(localJson.containsKey('updated_at'), false);
      });

      test('should export to local DB JSON excluding null values', () {
        final group = WorkFlowStageGroupModel(
          id: 3,
          name: 'Security Team',
          companyId: null,
          color: '#9C27B0',
          createdAt: '2023-05-01 14:00:00',
          updatedAt: null,
        );

        final localJson = group.toLocalDbJson();

        expect(localJson['id'], 3);
        expect(localJson['name'], 'Security Team');
        expect(localJson['color'], '#9C27B0');
        expect(localJson.containsKey('company_id'), false);
        expect(localJson.containsKey('created_at'), false);
        expect(localJson.containsKey('updated_at'), false);
      });
    });

    group('Equality and HashCode - Object comparison and hash consistency validation', () {
      test('should be equal when IDs are the same', () {
        final group1 = WorkFlowStageGroupModel(
          id: 1,
          name: 'Team A',
          companyId: 100,
        );
        final group2 = WorkFlowStageGroupModel(
          id: 1,
          name: 'Team B',
          companyId: 200,
        );

        expect(group1, equals(group2));
        expect(group1.hashCode, equals(group2.hashCode));
      });

      test('should not be equal when IDs are different', () {
        final group1 = WorkFlowStageGroupModel(
          id: 1,
          name: 'Team A',
        );
        final group2 = WorkFlowStageGroupModel(
          id: 2,
          name: 'Team A',
        );

        expect(group1, isNot(equals(group2)));
        expect(group1.hashCode, isNot(equals(group2.hashCode)));
      });

      test('should be equal to itself', () {
        final group = WorkFlowStageGroupModel(
          id: 1,
          name: 'Team A',
        );

        expect(group, equals(group));
        expect(group.hashCode, equals(group.hashCode));
      });

      test('should not be equal to different object type', () {
        final group = WorkFlowStageGroupModel(
          id: 1,
          name: 'Team A',
        );

        expect(group, isNot(equals('not a group')));
        expect(group, isNot(equals(123)));
        expect(group, isNot(equals(null)));
      });
    });

    group('toString - String representation formatting and debugging output', () {
      test('should return formatted string with all fields', () {
        final group = WorkFlowStageGroupModel(
          id: 1,
          name: 'Product Team',
          companyId: 999,
          color: '#E91E63',
        );

        final string = group.toString();

        expect(string, contains('WorkFlowStageGroupModel'));
        expect(string, contains('id: 1'));
        expect(string, contains('name: Product Team'));
        expect(string, contains('companyId: 999'));
        expect(string, contains('color: #E91E63'));
      });

      test('should return formatted string with null fields', () {
        final group = WorkFlowStageGroupModel(
          id: 2,
          name: 'Marketing Team',
        );

        final string = group.toString();

        expect(string, contains('WorkFlowStageGroupModel'));
        expect(string, contains('id: 2'));
        expect(string, contains('name: Marketing Team'));
        expect(string, contains('companyId: null'));
        expect(string, contains('color: null'));
      });
    });

    group('Edge Cases and Error Handling - Malformed data, null values, and boundary conditions', () {
      test('should handle empty string name', () {
        final group = WorkFlowStageGroupModel(
          id: 1,
          name: '',
        );

        expect(group.name, '');
        expect(group.id, 1);
      });

      test('should handle very long name', () {
        final longName = 'A' * 1000;
        final group = WorkFlowStageGroupModel(
          id: 1,
          name: longName,
        );

        expect(group.name, longName);
        expect(group.name.length, 1000);
      });

      test('should handle special characters in name', () {
        const specialName = 'Team @#\$%^&*()_+-=[]{}|;:,.<>?';
        final group = WorkFlowStageGroupModel(
          id: 1,
          name: specialName,
        );

        expect(group.name, specialName);
      });

      test('should handle negative company ID', () {
        final group = WorkFlowStageGroupModel(
          id: 1,
          name: 'Test Team',
          companyId: -1,
        );

        expect(group.companyId, -1);
      });

      test('should handle zero ID', () {
        final group = WorkFlowStageGroupModel(
          id: 0,
          name: 'Zero Team',
        );

        expect(group.id, 0);
      });

      test('should handle very large ID', () {
        final group = WorkFlowStageGroupModel(
          id: 999999999,
          name: 'Large ID Team',
        );

        expect(group.id, 999999999);
      });
    });

    group('Round-trip Serialization - Data integrity through serialize/deserialize cycles', () {
      test('should maintain data integrity through JSON round-trip', () {
        final originalGroup = WorkFlowStageGroupModel(
          id: 42,
          name: 'Round Trip Team',
          companyId: 777,
          color: '#607D8B',
          createdAt: '2023-06-01 11:30:00',
          updatedAt: '2023-06-01 18:45:00',
        );

        final json = originalGroup.toJson();
        final reconstructedGroup = WorkFlowStageGroupModel.fromJson(json);

        expect(reconstructedGroup.id, originalGroup.id);
        expect(reconstructedGroup.name, originalGroup.name);
        expect(reconstructedGroup.companyId, originalGroup.companyId);
        expect(reconstructedGroup.color, originalGroup.color);
        expect(reconstructedGroup.createdAt, originalGroup.createdAt);
        expect(reconstructedGroup.updatedAt, originalGroup.updatedAt);
        expect(reconstructedGroup, equals(originalGroup));
      });

      test('should maintain data integrity through local DB JSON round-trip', () {
        final originalGroup = WorkFlowStageGroupModel(
          id: 33,
          name: 'Local DB Team',
          companyId: 888,
          color: '#795548',
          createdAt: '2023-07-01 09:15:00',
          updatedAt: '2023-07-01 17:20:00',
        );

        final localJson = originalGroup.toLocalDbJson();
        // Simulate loading from local DB (no timestamps)
        final reconstructedGroup = WorkFlowStageGroupModel.fromJson(localJson);

        expect(reconstructedGroup.id, originalGroup.id);
        expect(reconstructedGroup.name, originalGroup.name);
        expect(reconstructedGroup.companyId, originalGroup.companyId);
        expect(reconstructedGroup.color, originalGroup.color);
        expect(reconstructedGroup.createdAt, isNull);
        expect(reconstructedGroup.updatedAt, isNull);
        expect(reconstructedGroup, equals(originalGroup)); // Equal by ID
      });
    });
  });
}
