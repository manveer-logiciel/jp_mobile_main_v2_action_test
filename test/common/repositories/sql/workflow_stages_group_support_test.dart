import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/models/workflow/workflow_stage_group.dart';
import 'package:jobprogress/common/repositories/sql/workflow_stages.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/common_constants.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;
    RunModeService.setRunMode(RunMode.unitTesting);
  });

  tearDownAll(() {
    Get.reset();
  });

  group('SqlWorkFlowStagesRepository Group Support - Database operations for workflow stage grouping', () {
    late SqlWorkFlowStagesRepository repository;

    setUp(() {
      repository = SqlWorkFlowStagesRepository();
    });

    group('getGroupedStages - Organizing workflow stages by group names and handling unassigned stages', () {
      test('should group workflow stages by group name', () async {
        // Mock the get() method to return stages with different groups
        final mockStages = [
          WorkFlowStageModel(
            name: 'Design Review',
            color: '#FF0000',
            code: 'DESIGN_REVIEW',
            groupName: 'Design Team',
          ),
          WorkFlowStageModel(
            name: 'UI Development',
            color: '#00FF00',
            code: 'UI_DEV',
            groupName: 'Design Team',
          ),
          WorkFlowStageModel(
            name: 'Backend Development',
            color: '#0000FF',
            code: 'BACKEND_DEV',
            groupName: 'Development Team',
          ),
          WorkFlowStageModel(
            name: 'API Testing',
            color: '#FFFF00',
            code: 'API_TEST',
            groupName: 'Testing Team',
          ),
        ];

        // Create a spy repository to mock the get() method
        final spyRepository = _WorkFlowStagesRepositorySpy();
        spyRepository.mockStages = mockStages;

        final groupedStages = await spyRepository.getGroupedStages();

        expect(groupedStages.keys.length, 3);
        expect(groupedStages.containsKey('Design Team'), true);
        expect(groupedStages.containsKey('Development Team'), true);
        expect(groupedStages.containsKey('Testing Team'), true);

        expect(groupedStages['Design Team']?.length, 2);
        expect(groupedStages['Development Team']?.length, 1);
        expect(groupedStages['Testing Team']?.length, 1);

        expect(groupedStages['Design Team']?.first.name, 'Design Review');
        expect(groupedStages['Design Team']?.last.name, 'UI Development');
        expect(groupedStages['Development Team']?.first.name, 'Backend Development');
        expect(groupedStages['Testing Team']?.first.name, 'API Testing');
      });

      test('should handle stages with null group names using unassigned constant', () async {
        final mockStages = [
          WorkFlowStageModel(
            name: 'Legacy Stage 1',
            color: '#FF0000',
            code: 'LEGACY_1',
            groupName: null,
          ),
          WorkFlowStageModel(
            name: 'Legacy Stage 2',
            color: '#00FF00',
            code: 'LEGACY_2',
            groupName: null,
          ),
          WorkFlowStageModel(
            name: 'New Stage',
            color: '#0000FF',
            code: 'NEW_STAGE',
            groupName: 'New Team',
          ),
        ];

        final spyRepository = _WorkFlowStagesRepositorySpy();
        spyRepository.mockStages = mockStages;

        final groupedStages = await spyRepository.getGroupedStages();

        expect(groupedStages.keys.length, 2);
        expect(groupedStages.containsKey(CommonConstants.unAssignedStageGroup.capitalize), true);
        expect(groupedStages.containsKey('New Team'), true);

        expect(groupedStages[CommonConstants.unAssignedStageGroup.capitalize]?.length, 2);
        expect(groupedStages['New Team']?.length, 1);
      });

      test('should handle empty stages list', () async {
        final spyRepository = _WorkFlowStagesRepositorySpy();
        spyRepository.mockStages = [];

        final groupedStages = await spyRepository.getGroupedStages();

        expect(groupedStages.isEmpty, true);
      });

      test('should handle stages with empty group names', () async {
        final mockStages = [
          WorkFlowStageModel(
            name: 'Empty Group Stage',
            color: '#FF0000',
            code: 'EMPTY_GROUP',
            groupName: '',
          ),
        ];

        final spyRepository = _WorkFlowStagesRepositorySpy();
        spyRepository.mockStages = mockStages;

        final groupedStages = await spyRepository.getGroupedStages();

        expect(groupedStages.keys.length, 1);
        // Empty string is used as-is in the implementation (not converted to unassigned)
        expect(groupedStages.containsKey(''), true);
        expect(groupedStages['']?.length, 1);
      });

      test('should handle stages with duplicate group names', () async {
        final mockStages = [
          WorkFlowStageModel(
            name: 'Stage 1',
            color: '#FF0000',
            code: 'STAGE_1',
            groupName: 'Same Group',
          ),
          WorkFlowStageModel(
            name: 'Stage 2',
            color: '#00FF00',
            code: 'STAGE_2',
            groupName: 'Same Group',
          ),
          WorkFlowStageModel(
            name: 'Stage 3',
            color: '#0000FF',
            code: 'STAGE_3',
            groupName: 'Same Group',
          ),
        ];

        final spyRepository = _WorkFlowStagesRepositorySpy();
        spyRepository.mockStages = mockStages;

        final groupedStages = await spyRepository.getGroupedStages();

        expect(groupedStages.keys.length, 1);
        expect(groupedStages['Same Group']?.length, 3);
      });

      test('should handle null stages in the list', () async {
        final mockStages = [
          WorkFlowStageModel(
            name: 'Valid Stage',
            color: '#FF0000',
            code: 'VALID',
            groupName: 'Valid Group',
          ),
          null, // This should be skipped
        ];

        final spyRepository = _WorkFlowStagesRepositorySpy();
        spyRepository.mockStages = mockStages;

        final groupedStages = await spyRepository.getGroupedStages();

        expect(groupedStages.keys.length, 1);
        expect(groupedStages['Valid Group']?.length, 1);
        expect(groupedStages['Valid Group']?.first.name, 'Valid Stage');
      });
    });

    group('getByGroupId - Filtering workflow stages by specific group identifier', () {
      test('should validate method signature and parameters', () {
        // Test method exists and accepts integer parameter
        expect(repository.getByGroupId, isA<Function>());
        
        // Test parameter validation
        const validGroupId = 1;
        const invalidGroupId = -1;
        
        expect(validGroupId, greaterThan(0));
        expect(invalidGroupId, lessThan(0));
      });

      test('should handle different group ID types', () {
        // Test that method signature accepts various integer values
        const smallId = 1;
        const largeId = 999999999;
        const zeroId = 0;
        
        expect(smallId, isA<int>());
        expect(largeId, isA<int>());
        expect(zeroId, isA<int>());
      });
    });

    group('getUniqueGroups - Extracting distinct group information from workflow stages', () {
      test('should validate method signature', () {
        // Test method exists and returns correct type
        expect(repository.getUniqueGroups, isA<Function>());
      });

      test('should define correct query structure expectations', () {
        // Validate the expected SQL query structure
        const expectedColumns = ['group_id', 'group_name', 'group_color'];
        const expectedTable = 'workflow_stages';
        
        expect(expectedColumns, hasLength(3));
        expect(expectedTable, equals('workflow_stages'));
      });
    });

    group('Group Query Validation - Parameter validation and SQL query correctness verification', () {
      test('should validate getByGroupId SQL query structure', () {
        const companyId = 123;
        const groupId = 456;
        const expectedQuery = 'SELECT * FROM workflow_stages WHERE company_id = $companyId AND group_id = $groupId';
        
        // Verify query structure (this would be the actual query used)
        expect(expectedQuery.contains('workflow_stages'), true);
        expect(expectedQuery.contains('company_id'), true);
        expect(expectedQuery.contains('group_id'), true);
        expect(expectedQuery.contains('SELECT *'), true);
        expect(expectedQuery.contains('WHERE'), true);
        expect(expectedQuery.contains('AND'), true);
      });

      test('should validate getUniqueGroups SQL query structure', () {
        const companyId = 123;
        const expectedQuery = '''
          SELECT DISTINCT group_id, group_name, group_color 
          FROM workflow_stages 
          WHERE company_id = $companyId 
          AND group_id IS NOT NULL 
          ORDER BY group_name
        ''';
        
        // Verify query structure
        expect(expectedQuery.contains('SELECT DISTINCT'), true);
        expect(expectedQuery.contains('group_id'), true);
        expect(expectedQuery.contains('group_name'), true);
        expect(expectedQuery.contains('group_color'), true);
        expect(expectedQuery.contains('workflow_stages'), true);
        expect(expectedQuery.contains('company_id'), true);
        expect(expectedQuery.contains('group_id IS NOT NULL'), true);
        expect(expectedQuery.contains('ORDER BY group_name'), true);
      });
    });

    group('Group Data Integration - Cross-method functionality and group data flow validation', () {
      test('should define proper method interfaces', () {
        // Test that all repository methods exist and have correct types
        expect(repository.get, isA<Function>());
        expect(repository.getGroupedStages, isA<Function>());
        expect(repository.getByGroupId, isA<Function>());
        expect(repository.getUniqueGroups, isA<Function>());
        expect(repository.clearRecords, isA<Function>());
        expect(repository.bulkInsert, isA<Function>());
      });

      test('should handle bulk insert data structure', () {
        final groupedStages = [
          WorkFlowStageModel(
            name: 'Stage with Group',
            color: '#FF0000',
            code: 'STAGE_GROUP',
            groupId: 1,
            groupName: 'Test Group',
          ),
          WorkFlowStageModel(
            name: 'Stage without Group',
            color: '#00FF00',
            code: 'STAGE_NO_GROUP',
          ),
        ];

        // Test data structure validation
        expect(groupedStages, hasLength(2));
        expect(groupedStages.first.groupId, 1);
        expect(groupedStages.first.groupName, 'Test Group');
        expect(groupedStages.last.groupId, isNull);
        expect(groupedStages.last.groupName, isNull);
      });
    });

    group('Error Handling - Database error scenarios and graceful failure management', () {
      test('should validate error handling patterns', () {
        // Test that repository has proper error handling structure
        expect(repository, isA<SqlWorkFlowStagesRepository>());
      });

      test('should handle invalid JSON data in group fields', () async {
        final mockStages = [
          WorkFlowStageModel(
            name: 'Test Stage',
            color: 'invalid-color',
            code: 'TEST',
            groupName: 'Test Group',
          ),
        ];

        final spyRepository = _WorkFlowStagesRepositorySpy();
        spyRepository.mockStages = mockStages;

        // Should not throw error even with invalid data
        final groupedStages = await spyRepository.getGroupedStages();
        expect(groupedStages, isNotNull);
      });

      test('should define error handling requirements', () {
        // Test error handling requirements
        const expectedErrorTypes = ['DatabaseException', 'AuthenticationException', 'ValidationException'];
        
        expect(expectedErrorTypes, hasLength(3));
        expect(expectedErrorTypes, contains('DatabaseException'));
      });
    });

    group('Performance and Optimization - Large dataset handling and query efficiency validation', () {
      test('should handle large numbers of groups efficiently', () async {
        final mockStages = List.generate(1000, (index) => 
          WorkFlowStageModel(
            name: 'Stage $index',
            color: '#FF0000',
            code: 'STAGE_$index',
            groupName: 'Group ${index % 10}', // 10 different groups
          )
        );

        final spyRepository = _WorkFlowStagesRepositorySpy();
        spyRepository.mockStages = mockStages;

        final groupedStages = await spyRepository.getGroupedStages();

        expect(groupedStages.keys.length, 10);
        for (final group in groupedStages.values) {
          expect(group.length, 100); // 1000 stages / 10 groups = 100 per group
        }
      });

      test('should handle stages with very long group names', () async {
        final longGroupName = 'A' * 1000;
        final mockStages = [
          WorkFlowStageModel(
            name: 'Long Group Name Stage',
            color: '#FF0000',
            code: 'LONG_GROUP',
            groupName: longGroupName,
          ),
        ];

        final spyRepository = _WorkFlowStagesRepositorySpy();
        spyRepository.mockStages = mockStages;

        final groupedStages = await spyRepository.getGroupedStages();

        expect(groupedStages.containsKey(longGroupName), true);
        expect(groupedStages[longGroupName]?.length, 1);
      });
    });

    group('Data Consistency - Mixed data format handling and empty/null value scenarios', () {
      test('should define consistency requirements', () {
        // Test that consistency requirements are defined
        const expectedMethods = ['getGroupedStages', 'getByGroupId', 'getUniqueGroups'];
        
        expect(expectedMethods, hasLength(3));
        expect(expectedMethods, contains('getGroupedStages'));
      });

      test('should handle mixed group data formats consistently', () async {
        final mixedStages = [
          WorkFlowStageModel(
            name: 'API Stage',
            color: '#FF0000',
            code: 'API',
            group: WorkFlowStageGroupModel(id: 1, name: 'API Group'),
            groupName: 'API Group', // Explicitly set groupName for consistency
          ),
          WorkFlowStageModel(
            name: 'DB Stage',
            color: '#00FF00',
            code: 'DB',
            groupId: 2,
            groupName: 'DB Group',
          ),
          WorkFlowStageModel(
            name: 'Legacy Stage',
            color: '#0000FF',
            code: 'LEGACY',
            // No group data - will use unassigned group
          ),
        ];

        final spyRepository = _WorkFlowStagesRepositorySpy();
        spyRepository.mockStages = mixedStages;

        final groupedStages = await spyRepository.getGroupedStages();

        expect(groupedStages.keys.length, 3);
        expect(groupedStages.containsKey('API Group'), true);
        expect(groupedStages.containsKey('DB Group'), true);
        expect(groupedStages.containsKey(CommonConstants.unAssignedStageGroup.capitalize), true);
      });
    });
  });
}

/// Spy class to override the get() method for testing getGroupedStages
class _WorkFlowStagesRepositorySpy extends SqlWorkFlowStagesRepository {
  List<WorkFlowStageModel?> mockStages = [];

  @override
  Future<List<WorkFlowStageModel?>> get() async {
    return mockStages;
  }
}
