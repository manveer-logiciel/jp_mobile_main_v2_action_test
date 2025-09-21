import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/sample_features/sample_models/sample_item.dart';

void main() {
  group('SampleItem Model Tests', () {
    late SampleItem testItem;

    setUp(() {
      testItem = SampleItem(
        id: 'test-1',
        title: 'Test Item',
        description: 'Test Description',
        category: 'Testing',
        isCompleted: false,
        createdAt: DateTime(2024, 1, 1),
      );
    });

    test('should create SampleItem with correct properties', () {
      expect(testItem.id, equals('test-1'));
      expect(testItem.title, equals('Test Item'));
      expect(testItem.description, equals('Test Description'));
      expect(testItem.category, equals('Testing'));
      expect(testItem.isCompleted, equals(false));
      expect(testItem.createdAt, equals(DateTime(2024, 1, 1)));
    });

    test('should return correct status text', () {
      expect(testItem.statusText, equals('Pending'));
      
      final completedItem = testItem.copyWith(isCompleted: true);
      expect(completedItem.statusText, equals('Completed'));
    });

    test('should return correct category color', () {
      expect(testItem.categoryColor, equals('#FF5722'));
      
      final devItem = testItem.copyWith(category: 'Development');
      expect(devItem.categoryColor, equals('#2196F3'));
      
      final qaItem = testItem.copyWith(category: 'QA');
      expect(qaItem.categoryColor, equals('#4CAF50'));
    });

    test('should calculate priority level correctly', () {
      // Testing category priority
      expect(testItem.priorityLevel, equals(3)); // Testing = +2, base = 1
      
      final devItem = testItem.copyWith(category: 'Development');
      expect(devItem.priorityLevel, equals(4)); // Development = +3, base = 1
      
      // Test overdue priority boost
      final oldDate = DateTime.now().subtract(const Duration(days: 10));
      final overdueItem = testItem.copyWith(createdAt: oldDate);
      expect(overdueItem.priorityLevel, equals(5)); // Testing +2, overdue +2, base = 1, clamped to 5
    });

    test('should detect overdue items correctly', () {
      expect(testItem.isOverdue, equals(false)); // Created in 2024, not overdue
      
      final recentItem = testItem.copyWith(createdAt: DateTime.now().subtract(const Duration(days: 3)));
      expect(recentItem.isOverdue, equals(false));
      
      final oldItem = testItem.copyWith(createdAt: DateTime.now().subtract(const Duration(days: 10)));
      expect(oldItem.isOverdue, equals(true));
      
      // Completed items are never overdue
      final completedOldItem = oldItem.copyWith(isCompleted: true);
      expect(completedOldItem.isOverdue, equals(false));
    });

    test('should return correct priority text', () {
      final lowPriorityItem = testItem.copyWith(category: 'Documentation');
      expect(lowPriorityItem.priorityText, equals('Normal')); // Priority 2
      
      expect(testItem.priorityText, equals('Medium')); // Priority 3
      
      final highPriorityItem = testItem.copyWith(category: 'Development');
      expect(highPriorityItem.priorityText, equals('High')); // Priority 4
    });

    test('should serialize to JSON correctly', () {
      final json = testItem.toJson();
      
      expect(json['id'], equals('test-1'));
      expect(json['title'], equals('Test Item'));
      expect(json['description'], equals('Test Description'));
      expect(json['category'], equals('Testing'));
      expect(json['isCompleted'], equals(false));
      expect(json['createdAt'], equals('2024-01-01T00:00:00.000'));
      expect(json['updatedAt'], isNull);
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 'json-1',
        'title': 'JSON Item',
        'description': 'JSON Description',
        'category': 'Development',
        'isCompleted': true,
        'createdAt': '2024-01-01T12:00:00.000',
        'updatedAt': '2024-01-02T12:00:00.000',
      };
      
      final item = SampleItem.fromJson(json);
      
      expect(item.id, equals('json-1'));
      expect(item.title, equals('JSON Item'));
      expect(item.description, equals('JSON Description'));
      expect(item.category, equals('Development'));
      expect(item.isCompleted, equals(true));
      expect(item.createdAt, equals(DateTime.parse('2024-01-01T12:00:00.000')));
      expect(item.updatedAt, equals(DateTime.parse('2024-01-02T12:00:00.000')));
    });

    test('should create copy with updated fields', () {
      final updatedItem = testItem.copyWith(
        title: 'Updated Title',
        isCompleted: true,
      );
      
      expect(updatedItem.id, equals(testItem.id)); // Unchanged
      expect(updatedItem.title, equals('Updated Title')); // Changed
      expect(updatedItem.description, equals(testItem.description)); // Unchanged
      expect(updatedItem.isCompleted, equals(true)); // Changed
      expect(updatedItem.updatedAt, isNotNull); // Should be set
    });

    test('should implement equality correctly', () {
      final sameItem = SampleItem(
        id: 'test-1',
        title: 'Test Item',
        description: 'Test Description',
        category: 'Testing',
        isCompleted: false,
        createdAt: DateTime(2024, 1, 1),
      );
      
      final differentItem = testItem.copyWith(title: 'Different Title');
      
      expect(testItem, equals(sameItem));
      expect(testItem, isNot(equals(differentItem)));
      expect(testItem.hashCode, equals(sameItem.hashCode));
      expect(testItem.hashCode, isNot(equals(differentItem.hashCode)));
    });

    test('should have correct toString implementation', () {
      final string = testItem.toString();
      expect(string, contains('SampleItem'));
      expect(string, contains('test-1'));
      expect(string, contains('Test Item'));
      expect(string, contains('Testing'));
      expect(string, contains('false'));
    });
  });
}
