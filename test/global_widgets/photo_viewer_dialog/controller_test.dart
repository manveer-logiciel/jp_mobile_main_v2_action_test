
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/file_listing_type_to_api_params.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/photo_viewer_model.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/locale.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/global_widgets/photo_viewer_dialog/controller.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jobprogress/translations/index.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

// Manual mock for FilesListingController to test pagination functionality
class MockFilesListingController extends FilesListingController {
  bool _canShowLoadMore = true;
  dynamic _apiResponse;
  Exception? _apiException;
  FileListingTypeToApiParams? lastParams;
  
  void setCanShowLoadMore(bool value) {
    _canShowLoadMore = value;
  }
  
  void setApiResponse(dynamic response) {
    _apiResponse = response;
    _apiException = null;
  }
  
  void setApiException(Exception exception) {
    _apiException = exception;
    _apiResponse = null;
  }
  
  @override
  bool get canShowLoadMore => _canShowLoadMore;
  
  @override
  Future<dynamic> typeToApi(FileListingTypeToApiParams params) async {
    lastParams = params;
    if (_apiException != null) {
      throw _apiException!;
    }
    return _apiResponse ?? {'list': <FilesListingModel>[]};
  }
}

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  List<PhotoDetails> tempPhotoList = [
    PhotoDetails('file_1'),
    PhotoDetails('file_2'),
  ];

  group("PhotosViewerController@doShowEditButton - Edit Icon Visibility Conditions", () {
    test("When open from Job photos", () {
      final controller = PhotosViewerController(PhotoViewerModel<FilesListingController>(0, tempPhotoList), FLModule.jobPhotos, null);

      expect(controller.doShowEditButton, isTrue);
    });

    test("When open from Job Estimates", () {
      final controller = PhotosViewerController(PhotoViewerModel<FilesListingController>(0, tempPhotoList), FLModule.estimate, null);

      expect(controller.doShowEditButton, isTrue);
    });

    test("When open from Job proposals and user has manage proposals permission", () {
      PermissionService.permissionList = [PermissionConstants.manageProposals];
      final controller = PhotosViewerController(PhotoViewerModel<FilesListingController>(0, tempPhotoList), FLModule.jobProposal, null);

      expect(controller.doShowEditButton, isTrue);
    });
    
  });

  group("PhotosViewerController@doShowEditButton - Edit Icon Hiding Conditions", () {
    
    test("When open from Job proposals and user does not has manage proposals permission", () {
      PermissionService.permissionList.clear();
      final controller = PhotosViewerController(PhotoViewerModel<FilesListingController>(0, tempPhotoList), FLModule.jobProposal, null);

      expect(controller.doShowEditButton, isFalse);
    });
    
  });

  group("PhotosViewerController@addUpdateImageList - Image List Updates", () {
    final tempResult = {
      'files' : [
        FilesListingModel(),
        FilesListingModel()
      ],
      'action' : 'save_as'
    };
    
    test("When user perform save as on image", () {
      final controller = PhotosViewerController(PhotoViewerModel<FilesListingController>(0, tempPhotoList), FLModule.jobPhotos, null);
      controller.tabController = TabController(length: tempPhotoList.length, vsync: controller);
      controller.addUpdateImageList(tempResult);

      expect(controller.tabController.length, 4);
    });
  });

  group("PhotosViewerController@addUpdateImageList - Image List Preservation", () {
    final tempResult = {
      'file' : FilesListingModel(),
      'action' : 'save'
    };

    List<PhotoDetails> tempPhotoList = [
      PhotoDetails('file_1'),
      PhotoDetails('file_2'),
    ];
    
    test("When user perform save on image", () {
      final controller = PhotosViewerController(PhotoViewerModel<FilesListingController>(0, tempPhotoList), FLModule.jobPhotos, null);
      controller.tabController = TabController(length: tempPhotoList.length, vsync: controller);
      controller.addUpdateImageList(tempResult);

      expect(controller.tabController.length, 2);
    });
  });

  group("PhotosViewerController@updateImageList - Selected Image Index Updates", () {
    final tempResult = {
      'files' : [
        FilesListingModel(),
        FilesListingModel()
      ],
      'action' : 'save_as'
    };
    
    test("When user perform save as on image", () {
      final controller = PhotosViewerController(PhotoViewerModel<FilesListingController>(1, tempPhotoList), FLModule.jobPhotos, null);
      controller.tabController = TabController(length: tempPhotoList.length, vsync: controller);
      controller.addUpdateImageList(tempResult);

      expect(controller.tabController.index, 0);
    });
  });

  group("Photo viewer selected image index should not update", () {
    final tempResult = {
      'file' : FilesListingModel(),
      'action' : 'save'
    };
    
    test("When user perform save on image", () {
      final controller = PhotosViewerController(PhotoViewerModel<FilesListingController>(1, tempPhotoList), FLModule.jobPhotos, null);
      controller.tabController = TabController(length: tempPhotoList.length, vsync: controller)..animateTo(controller.data.scrollTo);
      controller.addUpdateImageList(tempResult);

      expect(controller.tabController.index, 1);
    });
  });

  group('PhotosViewerController@loadMorePhotos - Pagination Feature Tests', () {
    late MockFilesListingController mockFilesListingController;
    late PhotosViewerController<FilesListingController> controller;
    late List<PhotoDetails> initialPhotoList;

    setUp(() {
      mockFilesListingController = MockFilesListingController();
      
      // Setup GetX translations for 'photos'.tr usage in tests
      Get.testMode = true;
      Get.addTranslations(JPTranslations().keys);
      Get.locale = LocaleConst.usa;
      
      // Create initial photo list
      initialPhotoList = <PhotoDetails>[
        PhotoDetails('photo_1', id: '1', urls: <String>['https://example.com/photo1.jpg']),
        PhotoDetails('photo_2', id: '2', urls: <String>['https://example.com/photo2.jpg']),
      ];
      
      // Create controller with mock FilesListingController
      controller = PhotosViewerController(
        PhotoViewerModel<FilesListingController>(
          0, 
          initialPhotoList,
          controller: mockFilesListingController
        ),
        FLModule.jobPhotos,
        123 // jobId
      );
      
      // Initialize tab controller for testing
      controller.tabController = TabController(length: initialPhotoList.length, vsync: controller);
      
      // Initialize thumbnail scroll controller to prevent errors in onClose()
      controller.thumbnailScrollController = AutoScrollController();
    });

    tearDown(() {
      controller.onClose();
    });

    test('should initialize with correct pagination state', () {
      // Assert
      expect(controller.isLoadingMore, isFalse);
      expect(controller.hasMorePhotos, isTrue);
      expect(controller.shimmerPlaceholderCount, 1);
    });
    
    test('toggleLoadingMore should update loading state', () {
      // Act
      controller.toggleLoadingMore(true);
      
      // Assert
      expect(controller.isLoadingMore, isTrue);
      
      // Act again
      controller.toggleLoadingMore(false);
      
      // Assert again
      expect(controller.isLoadingMore, isFalse);
    });
    
    test('canPerformLoadMore should return true only for job photos module', () {
      // Act & Assert - Job photos should support pagination
      expect(controller.canPerformLoadMore(), isTrue);
      
      // Create controllers for other module types
      final dropboxController = PhotosViewerController(
        PhotoViewerModel<FilesListingController>(0, initialPhotoList),
        FLModule.dropBoxListing,
        null
      );
      dropboxController.tabController = TabController(length: initialPhotoList.length, vsync: dropboxController);
      dropboxController.thumbnailScrollController = AutoScrollController();
      
      final estimateController = PhotosViewerController(
        PhotoViewerModel<FilesListingController>(0, initialPhotoList),
        FLModule.estimate,
        null
      );
      estimateController.tabController = TabController(length: initialPhotoList.length, vsync: estimateController);
      estimateController.thumbnailScrollController = AutoScrollController();
      
      // Act & Assert - Dropbox should not support pagination, but estimate should
      expect(dropboxController.canPerformLoadMore(), isFalse);
      expect(estimateController.canPerformLoadMore(), isTrue); // Updated to expect true since estimate now supports pagination
      
      // Clean up
      dropboxController.onClose();
      estimateController.onClose();
    });

    test('loadMorePhotos should not proceed when already loading', () async {
      // Arrange
      controller.isLoadingMore = true;
      
      // Act
      await controller.loadMorePhotos();
      
      // Assert - verify the controller didn't try to load more photos
      expect(mockFilesListingController.lastParams, isNull);
    });
    
    test('loadMorePhotos should not proceed when hasMorePhotos is false', () async {
      // Arrange
      controller.hasMorePhotos = false;
      
      // Act
      await controller.loadMorePhotos();
      
      // Assert - verify the controller didn't try to load more photos
      expect(mockFilesListingController.lastParams, isNull);
    });
    
    test('loadMorePhotos should handle successful API response with photos', () async {
      // Arrange
      final mockFile1 = FilesListingModel()
        ..id = '3'
        ..name = 'photo_3'
        ..originalFilePath = 'https://example.com/photo3.jpg'
        ..thumbUrl = 'https://example.com/thumb3.jpg';
        
      final mockFile2 = FilesListingModel()
        ..id = '4'
        ..name = 'photo_4'
        ..originalFilePath = 'https://example.com/photo4.jpg'
        ..thumbUrl = 'https://example.com/thumb4.jpg';
      
      // Setup the mock API response
      mockFilesListingController.setApiResponse({
        'list': <FilesListingModel>[mockFile1, mockFile2]
      });
      
      mockFilesListingController.setCanShowLoadMore(true);
      
      // Act
      await controller.loadMorePhotos();
      
      // Assert
      expect(controller.isLoadingMore, isFalse);
      expect(controller.hasMorePhotos, isTrue);
      expect(controller.data.allImages.length, 4); // 2 initial + 2 loaded
      expect(controller.tabController.length, 4);
      
      // Verify correct API params were used
      expect(mockFilesListingController.lastParams?.onlyImages, isTrue);
      expect(mockFilesListingController.lastParams?.cursorId, '2'); // ID of the last photo in the initial list
    });
    
    test('loadMorePhotos should handle empty API response', () async {
      // Arrange
      mockFilesListingController.setApiResponse({
        'list': <FilesListingModel>[]
      });
      
      mockFilesListingController.setCanShowLoadMore(true);
      
      // Act
      await controller.loadMorePhotos();
      
      // Assert
      expect(controller.isLoadingMore, isFalse);
      expect(controller.hasMorePhotos, isFalse); // Should be set to false when empty response
      expect(controller.data.allImages.length, 2); // Still only the initial 2
    });
    
    test('loadMorePhotos should handle API errors', () async {
      // Arrange
      mockFilesListingController.setApiException(Exception('API error'));
      mockFilesListingController.setCanShowLoadMore(true);
      
      // Act & Assert - Verify that the exception is thrown
      expect(() => controller.loadMorePhotos(), throwsException);
    });
    
    test('loadMorePhotos should handle controller indicating no more photos', () async {
      // Arrange
      mockFilesListingController.setCanShowLoadMore(false);
      
      // Act
      await controller.loadMorePhotos();
      
      // Assert
      expect(controller.hasMorePhotos, isFalse);
      expect(mockFilesListingController.lastParams, isNull);
    });
    
    test('getItemCount should include shimmer placeholders when loading or has more photos', () {
      // Initial state - has more photos but not loading
      expect(controller.getItemCount, initialPhotoList.length + 1); // +1 for shimmer
      
      // When loading
      controller.toggleLoadingMore(true);
      expect(controller.getItemCount, initialPhotoList.length + 1);
      
      // When no more photos and not loading
      controller.toggleLoadingMore(false);
      controller.hasMorePhotos = false;
      expect(controller.getItemCount, initialPhotoList.length); // No shimmer
    });
    
    test('updateTabController should preserve current tab index', () {
      // Arrange
      controller.tabController.index = 1; // Set current tab to second photo
      
      // Add a new photo to simulate pagination result
      controller.data.allImages.add(
        PhotoDetails('photo_3', id: '3', urls: <String>['https://example.com/photo3.jpg'])
      );
      
      // Act
      controller.updateTabController();
      
      // Assert
      expect(controller.tabController.length, 3); // Length increased
      expect(controller.tabController.index, 1); // Index preserved
    });
  });

  group('PhotosViewerController@loadMoreWithFilesListingController - Cursor-based Pagination', () {
    late PhotosViewerController<FilesListingController> controller;
    late MockFilesListingController mockFilesListingController;
    late List<PhotoDetails> initialPhotoList;
    
    setUp(() {
      // Initialize with mock data
      initialPhotoList = [
        PhotoDetails('photo_1', id: '1', urls: <String>['https://example.com/photo1.jpg']),
        PhotoDetails('photo_2', id: '2', urls: <String>['https://example.com/photo2.jpg']),
      ];
      
      mockFilesListingController = MockFilesListingController();
      controller = PhotosViewerController<FilesListingController>(
        PhotoViewerModel<FilesListingController>(0, initialPhotoList, controller: mockFilesListingController),
        FLModule.jobPhotos,
        null
      );
      controller.tabController = TabController(length: initialPhotoList.length, vsync: controller);
    });
    
    test('loadMorePhotos should not attempt to load when hasMorePhotos is false', () async {
      // Arrange
      controller.hasMorePhotos = false;
      
      // Act
      await controller.loadMorePhotos();
      
      // Assert
      expect(mockFilesListingController.lastParams, isNull);
    });
    
    group('canPerformLoadMore', () {
      test('should return true for modules with pagination support', () {
        // Test all supported modules
        final supportedModules = [
          FLModule.jobPhotos,
          FLModule.companyFiles,
          FLModule.estimate,
          FLModule.jobProposal,
          FLModule.measurements,
          FLModule.materialLists,
          FLModule.workOrder,
          FLModule.stageResources,
          FLModule.customerFiles,
          FLModule.instantPhotoGallery,
        ];
        
        for (final module in supportedModules) {
          // Create a new controller for each module type since type is final
          final moduleController = PhotosViewerController<FilesListingController>(
            PhotoViewerModel<FilesListingController>(0, initialPhotoList),
            module,
            null
          );
          expect(moduleController.canPerformLoadMore(), isTrue, reason: '${module.toString()} should support pagination');
        }
      });
      
      test('should return false for modules without pagination support', () {
        // Test a few unsupported modules
        final unsupportedModules = [
          FLModule.dropBoxListing,
          FLModule.userDocuments,
          FLModule.companyCamProjectImages, // Using a valid enum value
        ];
        
        for (final module in unsupportedModules) {
          // Create a new controller for each module type since type is final
          final moduleController = PhotosViewerController<FilesListingController>(
            PhotoViewerModel<FilesListingController>(0, initialPhotoList),
            module,
            null
          );
          expect(moduleController.canPerformLoadMore(), isFalse, reason: '${module.toString()} should not support pagination');
        }
      });
    });
    
    test('loadMoreWithFilesListingController should fetch more photos using cursor-based pagination', () async {
      // Arrange
      final mockFile = FilesListingModel()
        ..id = '3'
        ..name = 'photo_3'
        ..originalFilePath = 'https://example.com/photo3.jpg'
        ..thumbUrl = 'https://example.com/thumb3.jpg';
      
      mockFilesListingController.setApiResponse({
        'list': <FilesListingModel>[mockFile]
      });
      
      // Act
      await controller.loadMoreWithFilesListingController(mockFilesListingController);
      
      // Assert
      // Verify correct pagination parameters were passed
      expect(mockFilesListingController.lastParams?.onlyImages, isTrue);
      expect(mockFilesListingController.lastParams?.cursorId, '2'); // ID of the last image
      
      // Verify the new image was added
      expect(controller.data.allImages.length, 3); // 2 initial + 1 loaded
      expect(controller.data.allImages.last.id, '3');
    });
    
    test('loadMoreWithFilesListingController should handle empty response', () async {
      // Arrange
      mockFilesListingController.setApiResponse({
        'list': <FilesListingModel>[]
      });
      
      // Act
      await controller.loadMoreWithFilesListingController(mockFilesListingController);
      
      // Assert
      expect(controller.hasMorePhotos, isFalse);
      expect(controller.data.allImages.length, 2); // Still only the initial 2
    });
  });
}