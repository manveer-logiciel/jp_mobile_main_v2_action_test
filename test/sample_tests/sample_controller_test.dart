import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/sample_features/sample_controllers/sample_controller.dart';

void main() {
  group('SampleController Tests', () {
    late SampleController controller;

    setUp(() {
      // Initialize GetX for testing
      Get.testMode = true;
      controller = SampleController();
    });

    tearDown(() {
      // Clean up after each test
      Get.reset();
    });

    test('should initialize with default values', () {
      expect(controller.counter.value, equals(0));
      expect(controller.sampleItems.length, equals(3)); // Initial sample data
      expect(controller.isLoading.value, equals(false));
      expect(controller.statusMessage.value, equals(''));
    });

    test('should increment counter correctly', () {
      final initialValue = controller.counter.value;
      
      controller.increment();
      
      expect(controller.counter.value, equals(initialValue + 1));
      expect(controller.statusMessage.value, contains('incremented'));
    });

    test('should decrement counter correctly', () {
      // Set counter to a positive value first
      controller.counter.value = 5;
      
      controller.decrement();
      
      expect(controller.counter.value, equals(4));
      expect(controller.statusMessage.value, contains('decremented'));
    });

    test('should not decrement counter below zero', () {
      controller.counter.value = 0;
      
      controller.decrement();
      
      expect(controller.counter.value, equals(0));
    });

    test('should toggle item completion status', () {
      final firstItem = controller.sampleItems.first;
      final initialStatus = firstItem.isCompleted;
      
      controller.toggleItemCompletion(firstItem.id);
      
      final updatedItem = controller.sampleItems.firstWhere((item) => item.id == firstItem.id);
      expect(updatedItem.isCompleted, equals(!initialStatus));
    });

    test('should add new sample item', () {
      final initialCount = controller.sampleItems.length;
      
      controller.addSampleItem('New Item', 'New Description', 'Testing');
      
      expect(controller.sampleItems.length, equals(initialCount + 1));
      
      final newItem = controller.sampleItems.last;
      expect(newItem.title, equals('New Item'));
      expect(newItem.description, equals('New Description'));
      expect(newItem.category, equals('Testing'));
      expect(newItem.isCompleted, equals(false));
    });

    test('should remove sample item', () {
      final firstItem = controller.sampleItems.first;
      final initialCount = controller.sampleItems.length;
      
      controller.removeSampleItem(firstItem.id);
      
      expect(controller.sampleItems.length, equals(initialCount - 1));
      expect(
        controller.sampleItems.any((item) => item.id == firstItem.id),
        equals(false),
      );
    });

    test('should handle non-existent item operations gracefully', () {
      final initialCount = controller.sampleItems.length;
      
      // Try to toggle non-existent item
      controller.toggleItemCompletion('non-existent-id');
      expect(controller.sampleItems.length, equals(initialCount));
      
      // Try to remove non-existent item
      controller.removeSampleItem('non-existent-id');
      expect(controller.sampleItems.length, equals(initialCount));
    });

    test('should refresh data correctly', () async {
      // This test verifies the refresh mechanism
      expect(controller.isLoading.value, equals(false));
      
      controller.refreshData();
      
      // Should be loading immediately after calling refresh
      expect(controller.isLoading.value, equals(true));
      
      // Wait for the simulated delay to complete
      await Future<void>.delayed(const Duration(seconds: 3));
      
      expect(controller.isLoading.value, equals(false));
      expect(controller.statusMessage.value, contains('refreshed'));
    });

    test('should have correct initial sample data', () {
      expect(controller.sampleItems.length, equals(3));
      
      final items = controller.sampleItems;
      expect(items[0].title, equals('Sample Item 1'));
      expect(items[0].category, equals('Testing'));
      expect(items[0].isCompleted, equals(false));
      
      expect(items[1].title, equals('Sample Item 2'));
      expect(items[1].category, equals('Development'));
      expect(items[1].isCompleted, equals(true));
      
      expect(items[2].title, equals('Sample Item 3'));
      expect(items[2].category, equals('QA'));
      expect(items[2].isCompleted, equals(false));
    });

    test('should generate unique IDs for new items', () {
      controller.addSampleItem('Item 1', 'Description 1', 'Category 1');
      controller.addSampleItem('Item 2', 'Description 2', 'Category 2');
      
      final lastTwoItems = controller.sampleItems.skip(controller.sampleItems.length - 2);
      final ids = lastTwoItems.map((item) => item.id).toList();
      
      expect(ids[0], isNot(equals(ids[1])));
      expect(ids[0], isNotEmpty);
      expect(ids[1], isNotEmpty);
    });

    test('should maintain reactive state', () {
      bool counterChanged = false;
      bool itemsChanged = false;
      
      // Listen to reactive changes
      controller.counter.listen((_) => counterChanged = true);
      controller.sampleItems.listen((_) => itemsChanged = true);
      
      // Make changes
      controller.increment();
      controller.addSampleItem('Test', 'Test', 'Test');
      
      expect(counterChanged, equals(true));
      expect(itemsChanged, equals(true));
    });
  });
}
