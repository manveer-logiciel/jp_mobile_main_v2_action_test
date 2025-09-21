import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import '../sample_models/sample_item.dart';
import '../sample_pages/sample_detail_page.dart';

/// Sample Controller for testing various app functionalities
/// Demonstrates GetX state management, networking, storage, etc.
class SampleController extends GetxController {
  // Observable variables
  final RxInt counter = 0.obs;
  final RxList<SampleItem> sampleItems = <SampleItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString statusMessage = ''.obs;

  // Dependencies
  late Dio _dio;
  SharedPreferences? _prefs;

  @override
  void onInit() {
    super.onInit();
    _initializeDio();
    _loadInitialData();
    _loadCounterFromStorage();
  }

  /// Initialize Dio for networking
  void _initializeDio() {
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'SampleApp/1.0',
      },
    ));
  }

  /// Load initial sample data
  void _loadInitialData() {
    sampleItems.addAll([
      SampleItem(
        id: '1',
        title: 'Sample Item 1',
        description: 'This is a test item for GitHub Actions',
        category: 'Testing',
        isCompleted: false,
      ),
      SampleItem(
        id: '2',
        title: 'Sample Item 2',
        description: 'Another test item with different properties',
        category: 'Development',
        isCompleted: true,
      ),
      SampleItem(
        id: '3',
        title: 'Sample Item 3',
        description: 'Third test item for comprehensive testing',
        category: 'QA',
        isCompleted: false,
      ),
    ]);
  }

  /// Load counter from local storage
  Future<void> _loadCounterFromStorage() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      counter.value = _prefs?.getInt('sample_counter') ?? 0;
    } catch (e) {
      debugPrint('Error loading counter: $e');
    }
  }

  /// Save counter to local storage
  Future<void> _saveCounterToStorage() async {
    try {
      await _prefs?.setInt('sample_counter', counter.value);
    } catch (e) {
      debugPrint('Error saving counter: $e');
    }
  }

  /// Increment counter
  void increment() {
    counter.value++;
    _saveCounterToStorage();
    statusMessage.value = 'Counter incremented to ${counter.value}';
  }

  /// Decrement counter
  void decrement() {
    if (counter.value > 0) {
      counter.value--;
      _saveCounterToStorage();
      statusMessage.value = 'Counter decremented to ${counter.value}';
    }
  }

  /// Refresh all data
  void refreshData() {
    isLoading.value = true;
    
    // Simulate data refresh
    Future.delayed(const Duration(seconds: 2), () {
      _loadInitialData();
      isLoading.value = false;
      statusMessage.value = 'Data refreshed successfully';
      
      Get.snackbar(
        'Success',
        'Data has been refreshed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    });
  }

  /// Test networking functionality
  Future<void> testNetworking() async {
    try {
      isLoading.value = true;
      statusMessage.value = 'Testing network connection...';
      
      // Test with a public API
      final response = await _dio.get('https://jsonplaceholder.typicode.com/posts/1');
      
      if (response.statusCode == 200) {
        statusMessage.value = 'Network test successful';
        Get.snackbar(
          'Network Test',
          'Successfully connected to API',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      statusMessage.value = 'Network test failed: $e';
      Get.snackbar(
        'Network Test',
        'Failed to connect: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Test local storage functionality
  Future<void> testLocalStorage() async {
    try {
      isLoading.value = true;
      statusMessage.value = 'Testing local storage...';
      
      const testKey = 'sample_test_key';
      const testValue = 'Sample test value';
      
      // Save test data
      await _prefs?.setString(testKey, testValue);
      
      // Retrieve test data
      final retrievedValue = _prefs?.getString(testKey);
      
      if (retrievedValue == testValue) {
        statusMessage.value = 'Local storage test successful';
        Get.snackbar(
          'Storage Test',
          'Local storage is working correctly',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Retrieved value does not match saved value');
      }
    } catch (e) {
      statusMessage.value = 'Storage test failed: $e';
      Get.snackbar(
        'Storage Test',
        'Failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Test navigation functionality
  void testNavigation() {
    Get.to(() => const SampleDetailPage(
      title: 'Navigation Test',
      content: 'This page demonstrates navigation functionality in the sample app.',
    ));
  }

  /// Test permissions functionality
  Future<void> testPermissions() async {
    try {
      isLoading.value = true;
      statusMessage.value = 'Testing permissions...';
      
      // Test camera permission (safe for testing)
      final cameraStatus = await Permission.camera.status;
      
      String message = 'Camera permission status: ';
      switch (cameraStatus) {
        case PermissionStatus.granted:
          message += 'Granted';
          break;
        case PermissionStatus.denied:
          message += 'Denied';
          break;
        case PermissionStatus.restricted:
          message += 'Restricted';
          break;
        case PermissionStatus.limited:
          message += 'Limited';
          break;
        case PermissionStatus.permanentlyDenied:
          message += 'Permanently Denied';
          break;
        default:
          message += 'Unknown';
      }
      
      statusMessage.value = message;
      Get.snackbar(
        'Permission Test',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      statusMessage.value = 'Permission test failed: $e';
      Get.snackbar(
        'Permission Test',
        'Failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Show sample dialog
  void showSampleDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Sample Dialog'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('This is a sample dialog for testing purposes.'),
            const SizedBox(height: 16),
            Obx(() => Text('Current counter: ${counter.value}')),
            const SizedBox(height: 8),
            Obx(() => Text('Status: ${statusMessage.value}')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              increment();
              Get.back();
            },
            child: const Text('Increment & Close'),
          ),
        ],
      ),
    );
  }

  /// Toggle item completion status
  void toggleItemCompletion(String itemId) {
    final index = sampleItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      sampleItems[index] = sampleItems[index].copyWith(
        isCompleted: !sampleItems[index].isCompleted,
      );
      sampleItems.refresh();
    }
  }

  /// Add new sample item
  void addSampleItem(String title, String description, String category) {
    final newItem = SampleItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      category: category,
      isCompleted: false,
    );
    sampleItems.add(newItem);
  }

  /// Remove sample item
  void removeSampleItem(String itemId) {
    sampleItems.removeWhere((item) => item.id == itemId);
  }
}
