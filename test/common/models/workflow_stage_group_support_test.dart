import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/models/workflow/workflow_stage_group.dart';

void main() {
  group('WorkFlowStageModel Group Support - Integration of group functionality into workflow stages', () {
    group('Constructor with Group Properties - Object creation with group, groupId, and groupName parameters', () {
      test('should create WorkFlowStageModel with group object', () {
        final group = WorkFlowStageGroupModel(
          id: 1,
          name: 'Design Group',
          color: '#4CAF50',
        );

        final stage = WorkFlowStageModel(
          name: 'Design Review',
          color: '#2196F3',
          code: 'DESIGN_REVIEW',
          group: group,
        );

        expect(stage.name, 'Design Review');
        expect(stage.color, '#2196F3');
        expect(stage.code, 'DESIGN_REVIEW');
        expect(stage.group, equals(group));
        expect(stage.groupId, isNull); // Not set when group object is provided
        expect(stage.groupName, isNull); // Not set when group object is provided
      });

      test('should create WorkFlowStageModel with separate group properties', () {
        final stage = WorkFlowStageModel(
          name: 'Development Phase',
          color: '#FF9800',
          code: 'DEV_PHASE',
          groupId: 2,
          groupName: 'Development Group',
        );

        expect(stage.name, 'Development Phase');
        expect(stage.color, '#FF9800');
        expect(stage.code, 'DEV_PHASE');
        expect(stage.groupId, 2);
        expect(stage.groupName, 'Development Group');
        expect(stage.group, isNull);
      });

      test('should create WorkFlowStageModel with both group object and separate properties', () {
        final group = WorkFlowStageGroupModel(
          id: 3,
          name: 'QA Group',
          color: '#9C27B0',
        );

        final stage = WorkFlowStageModel(
          name: 'Testing Phase',
          color: '#E91E63',
          code: 'TESTING',
          group: group,
          groupId: 4, // This should be overridden by group.id
          groupName: 'Different Group Name', // This should be overridden by group.name
        );

        expect(stage.group, equals(group));
        expect(stage.groupId, 4); // Constructor parameter takes precedence
        expect(stage.groupName, 'Different Group Name'); // Constructor parameter takes precedence
      });
    });

    group('JSON Deserialization with Group Data from API - Parsing nested group objects from server responses', () {
      test('should parse WorkFlowStageModel from JSON with nested group object', () {
        final json = {
          'name': 'API Development',
          'color': '#3F51B5',
          'code': 'API_DEV',
          'position': 1,
          'resource_id': 123,
          'jobs_count': 5,
          'group': {
            'id': 10,
            'name': 'Backend Team',
            'company_id': 456,
            'color': '#607D8B',
            'created_at': '2023-01-01 10:00:00',
            'updated_at': '2023-01-01 18:00:00',
          },
        };

        final stage = WorkFlowStageModel.fromJson(json);

        expect(stage.name, 'API Development');
        expect(stage.color, '#3F51B5');
        expect(stage.code, 'API_DEV');
        expect(stage.position, 1);
        expect(stage.resourceId, 123);
        expect(stage.jobsCount, 5);

        // Group data should be properly parsed
        expect(stage.group, isNotNull);
        expect(stage.group!.id, 10);
        expect(stage.group!.name, 'Backend Team');
        expect(stage.group!.companyId, 456);
        expect(stage.group!.color, '#607D8B');
        expect(stage.groupId, 10);
        expect(stage.groupName, 'Backend Team');
      });

      test('should handle empty group object in JSON', () {
        final json = <String, dynamic>{
          'name': 'Database Design',
          'color': '#795548',
          'code': 'DB_DESIGN',
          'group': <String, dynamic>{},
        };

        expect(WorkFlowStageModel.fromJson(json).group, isA<WorkFlowStageGroupModel>());
        expect(WorkFlowStageModel.fromJson(json).group?.id, 0);
      });

      test('should handle null group object in JSON', () {
        final json = {
          'name': 'Frontend Development',
          'color': '#FF5722',
          'code': 'FRONTEND_DEV',
          'group': null,
        };

        final stage = WorkFlowStageModel.fromJson(json);

        expect(stage.name, 'Frontend Development');
        expect(stage.group, isNull);
        expect(stage.groupId, isNull);
        expect(stage.groupName, isNull);
      });
    });

    group('JSON Deserialization with Group Data from Local DB - Parsing flattened group fields from database', () {
      test('should parse WorkFlowStageModel from JSON with separate group fields', () {
        final json = {
          'name': 'Code Review',
          'color': '#009688',
          'code': 'CODE_REVIEW',
          'position': 2,
          'resource_id': 789,
          'group_id': 15,
          'group_name': 'Review Team',
          'group_color': '#00BCD4',
        };

        final stage = WorkFlowStageModel.fromJson(json);

        expect(stage.name, 'Code Review');
        expect(stage.color, '#009688');
        expect(stage.code, 'CODE_REVIEW');
        expect(stage.position, 2);
        expect(stage.resourceId, 789);

        // Group should be reconstructed from separate fields
        expect(stage.groupId, 15);
        expect(stage.groupName, 'Review Team');
        expect(stage.group, isNotNull);
        expect(stage.group!.id, 15);
        expect(stage.group!.name, 'Review Team');
        expect(stage.group!.color, '#00BCD4');
      });

      test('should handle partial group data from local DB', () {
        final json = {
          'name': 'Deployment',
          'color': '#8BC34A',
          'code': 'DEPLOY',
          'group_id': 20,
          'group_name': 'DevOps Team',
          // Missing group_color
        };

        final stage = WorkFlowStageModel.fromJson(json);

        expect(stage.groupId, 20);
        expect(stage.groupName, 'DevOps Team');
        expect(stage.group, isNotNull);
        expect(stage.group!.id, 20);
        expect(stage.group!.name, 'DevOps Team');
        expect(stage.group!.color, isNull);
      });

      test('should handle missing group ID but present group name', () {
        final json = {
          'name': 'Documentation',
          'color': '#CDDC39',
          'code': 'DOCS',
          'group_name': 'Documentation Team',
          // Missing group_id
        };

        final stage = WorkFlowStageModel.fromJson(json);

        expect(stage.groupId, isNull);
        expect(stage.groupName, 'Documentation Team');
        expect(stage.group, isNull); // Cannot reconstruct without group_id
      });

      test('should handle missing group name but present group ID', () {
        final json = {
          'name': 'Security Audit',
          'color': '#FFC107',
          'code': 'SECURITY',
          'group_id': 25,
          // Missing group_name
        };

        final stage = WorkFlowStageModel.fromJson(json);

        expect(stage.groupId, 25);
        expect(stage.groupName, isNull);
        expect(stage.group, isNull); // Cannot reconstruct without group_name
      });

      test('should handle null group fields from local DB', () {
        final json = {
          'name': 'Final Review',
          'color': '#FF9800',
          'code': 'FINAL',
          'group_id': null,
          'group_name': null,
          'group_color': null,
        };

        final stage = WorkFlowStageModel.fromJson(json);

        expect(stage.groupId, isNull);
        expect(stage.groupName, isNull);
        expect(stage.group, isNull);
      });
    });

    group('JSON Serialization with Group Data - Export group information in API-compatible format', () {
      test('should include group data in toJson output for local DB storage', () {
        final group = WorkFlowStageGroupModel(
          id: 30,
          name: 'Integration Team',
          color: '#3F51B5',
        );

        final stage = WorkFlowStageModel(
          name: 'Integration Testing',
          color: '#E91E63',
          code: 'INTEGRATION',
          group: group,
          groupId: 30,
          groupName: 'Integration Team',
        );

        final json = stage.toJson();

        expect(json['name'], 'Integration Testing');
        expect(json['color'], '#E91E63');
        expect(json['code'], 'INTEGRATION');
        expect(json['group_id'], 30);
        expect(json['group_name'], 'Integration Team');
        expect(json['group_color'], '#3F51B5');
      });

      test('should handle null group object in toJson', () {
        final stage = WorkFlowStageModel(
          name: 'Manual Testing',
          color: '#9C27B0',
          code: 'MANUAL_TEST',
        );

        final json = stage.toJson();

        expect(json['name'], 'Manual Testing');
        expect(json['color'], '#9C27B0');
        expect(json['code'], 'MANUAL_TEST');
        expect(json.containsKey('group_id'), false);
        expect(json.containsKey('group_name'), false);
        expect(json.containsKey('group_color'), false);
      });

      test('should include partial group data in toJson', () {
        final stage = WorkFlowStageModel(
          name: 'Performance Testing',
          color: '#607D8B',
          code: 'PERF_TEST',
          groupId: 35,
          groupName: 'Performance Team',
          // No group object or group.color
        );

        final json = stage.toJson();

        expect(json['group_id'], 35);
        expect(json['group_name'], 'Performance Team');
        expect(json.containsKey('group_color'), false);
      });

      test('should prioritize group object properties over separate properties in toJson', () {
        final group = WorkFlowStageGroupModel(
          id: 40,
          name: 'Security Team',
          color: '#F44336',
        );

        final stage = WorkFlowStageModel(
          name: 'Security Review',
          color: '#FF5722',
          code: 'SEC_REVIEW',
          group: group,
          groupId: 999, // Should be overridden by group.id in output
          groupName: 'Different Name', // Should be overridden by group.name in output
        );

        final json = stage.toJson();

        expect(json['group_id'], 999); // Constructor parameter takes precedence
        expect(json['group_name'], 'Different Name'); // Constructor parameter takes precedence
        expect(json['group_color'], '#F44336'); // From group object
      });
    });

    group('Group Data Consistency - Synchronization between group object and individual group fields', () {
      test('should maintain group data consistency when group object is provided', () {
        final group = WorkFlowStageGroupModel(
          id: 50,
          name: 'Mobile Team',
          color: '#009688',
        );

        final stage = WorkFlowStageModel(
          name: 'Mobile App Development',
          color: '#4CAF50',
          code: 'MOBILE_DEV',
          group: group,
        );

        // When group object is provided, groupId and groupName should be derivable
        expect(stage.group!.id, 50);
        expect(stage.group!.name, 'Mobile Team');
        expect(stage.group!.color, '#009688');
      });

      test('should handle group data updates properly', () {
        var stage = WorkFlowStageModel(
          name: 'UI Development',
          color: '#FF9800',
          code: 'UI_DEV',
        );

        // Initially no group
        expect(stage.group, isNull);
        expect(stage.groupId, isNull);
        expect(stage.groupName, isNull);

        // Simulate updating with group data
        final group = WorkFlowStageGroupModel(
          id: 60,
          name: 'UI Team',
          color: '#2196F3',
        );

        stage = WorkFlowStageModel(
          name: stage.name,
          color: stage.color,
          code: stage.code,
          group: group,
          groupId: group.id,
          groupName: group.name,
        );

        expect(stage.group, equals(group));
        expect(stage.groupId, 60);
        expect(stage.groupName, 'UI Team');
      });
    });

    group('Edge Cases and Error Handling - Malformed group data and mixed source validation', () {
      test('should handle stage creation with empty group data', () {
        final stage = WorkFlowStageModel(
          name: 'Empty Group Test',
          color: '#000000',
          code: 'EMPTY_GROUP',
          groupId: 0,
          groupName: '',
        );

        expect(stage.groupId, 0);
        expect(stage.groupName, '');
        expect(stage.group, isNull); // Cannot create group with empty name
      });

      test('should handle very large group IDs', () {
        final stage = WorkFlowStageModel(
          name: 'Large ID Test',
          color: '#FFFFFF',
          code: 'LARGE_ID',
          groupId: 999999999,
          groupName: 'Large ID Group',
        );

        expect(stage.groupId, 999999999);
        expect(stage.groupName, 'Large ID Group');
      });

      test('should handle special characters in group name', () {
        const specialGroupName = 'Group @#\$%^&*()_+-=[]{}|;:,.<>?';
        final stage = WorkFlowStageModel(
          name: 'Special Chars Test',
          color: '#123456',
          code: 'SPECIAL',
          groupId: 123,
          groupName: specialGroupName,
        );

        expect(stage.groupName, specialGroupName);
      });

      test('should handle JSON with malformed group object', () {
        final json = {
          'name': 'Malformed Group Test',
          'color': '#ABCDEF',
          'code': 'MALFORMED',
          'group': 'not an object', // Invalid - should be Map
        };

        // The model should handle malformed data gracefully instead of throwing
        final stage = WorkFlowStageModel.fromJson(json);
        expect(stage.name, 'Malformed Group Test');
        expect(stage.group, isNull); // Should not create group from invalid data
      });
    });

    group('Round-trip Serialization with Group Data - Data integrity through full serialize/deserialize cycles', () {
      test('should maintain group data integrity through API JSON round-trip', () {
        final originalJson = {
          'name': 'Round Trip API Test',
          'color': '#111111',
          'code': 'ROUND_TRIP_API',
          'group': {
            'id': 100,
            'name': 'API Test Group',
            'color': '#222222',
          },
        };

        final stage = WorkFlowStageModel.fromJson(originalJson);
        final outputJson = stage.toJson();

        expect(stage.group!.id, 100);
        expect(stage.group!.name, 'API Test Group');
        expect(stage.group!.color, '#222222');
        expect(outputJson['group_id'], stage.groupId);
        expect(outputJson['group_name'], stage.groupName);
        expect(outputJson['group_color'], '#222222');
      });

      test('should maintain group data integrity through local DB JSON round-trip', () {
        final originalJson = {
          'name': 'Round Trip DB Test',
          'color': '#333333',
          'code': 'ROUND_TRIP_DB',
          'group_id': 200,
          'group_name': 'DB Test Group',
          'group_color': '#444444',
        };

        final stage = WorkFlowStageModel.fromJson(originalJson);
        final outputJson = stage.toJson();

        expect(stage.groupId, 200);
        expect(stage.groupName, 'DB Test Group');
        expect(stage.group!.id, 200);
        expect(stage.group!.name, 'DB Test Group');
        expect(stage.group!.color, '#444444');
        expect(outputJson['group_id'], 200);
        expect(outputJson['group_name'], 'DB Test Group');
        expect(outputJson['group_color'], '#444444');
      });
    });
  });
}
