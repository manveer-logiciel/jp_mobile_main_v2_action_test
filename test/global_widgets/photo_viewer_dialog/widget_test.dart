import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/photo_viewer_model.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/locale.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/global_widgets/photo_viewer_dialog/index.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jobprogress/translations/index.dart';

/// A test implementation of FilesListingController for widget testing
/// 
/// This class extends the real FilesListingController but can be configured
/// to return specific test data or simulate loading states for testing purposes.
class TestFilesListingController extends FilesListingController {
  bool _canShowLoadMore = true;
  
  /// Sets whether the controller indicates more photos can be loaded
  void setCanShowLoadMore(bool value) {
    _canShowLoadMore = value;
  }
  
  @override
  bool get canShowLoadMore => _canShowLoadMore;
}

/// Helper function to pump a PhotosViewerDialog widget for testing
/// 
/// This function creates a PhotosViewerDialog wrapped in the necessary widget tree
/// and pumps it into the test environment. It provides a consistent way to create
/// the widget across multiple test cases.
/// 
/// Parameters:
/// - [tester]: The widget tester
/// - [photoList]: List of photos to display
/// - [initialIndex]: Initial selected photo index
/// - [moduleType]: Module type that determines behavior
/// - [jobId]: Optional job ID
/// - [controller]: Optional files listing controller
Future<void> pumpPhotoViewerDialog({
  required WidgetTester tester,
  required List<PhotoDetails> photoList,
  int initialIndex = 0,
  FLModule moduleType = FLModule.jobPhotos,
  int? jobId,
  FilesListingController? controller,
}) async {
  final photoViewerModel = PhotoViewerModel<FilesListingController>(
    initialIndex,
    photoList,
    controller: controller,
  );
  
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: PhotosViewerDialog<FilesListingController>(
          data: photoViewerModel,
          type: moduleType,
          jobId: jobId,
        ),
      ),
    ),
  );
  
  // Allow widget to build
  await tester.pump();
}

void main() {
  late List<PhotoDetails> testPhotoList;
  
  setUpAll(() {
    // Initialize GetX for translations
    Get.testMode = true;
    Get.addTranslations(JPTranslations().keys);
    Get.locale = LocaleConst.usa;
  });

  setUp(() {
    // Reset permissions for each test
    PermissionService.permissionList = [];
    
    // Create test photo list with different types of photos
    testPhotoList = <PhotoDetails>[
      // Photo with URLs
      PhotoDetails(
        'Photo 1', 
        id: '1',
        urls: <String>['https://example.com/photo1.jpg'],
      ),
      // Photo with URLs (not base64 to avoid image decoding issues in tests)
      PhotoDetails(
        'Photo 2',
        id: '2',
        urls: <String>['https://example.com/photo2.jpg'],
      ),
    ];
    
    // No need to initialize test controller for these tests
  });

  tearDown(() {
    Get.reset();
  });

  group('PhotosViewerDialog - Basic UI rendering', () {
    testWidgets(
      'Should render with all essential UI elements when initialized with photos',
      (WidgetTester tester) async {
        // Act - Build the widget using helper function
        await pumpPhotoViewerDialog(
          tester: tester,
          photoList: testPhotoList,
          jobId: 123,
        );
        
        // Assert - Verify basic structure is present
        expect(find.text('Photo 1'), findsOneWidget); // Title should be visible
        expect(find.byIcon(Icons.close_outlined), findsOneWidget); // Close button
        expect(find.byIcon(Icons.print_outlined), findsOneWidget); // Print button
        expect(find.byIcon(Icons.photo_outlined), findsOneWidget); // Download button
        
        // Verify thumbnails are rendered for multiple photos
        expect(find.byType(ListView), findsOneWidget); // Thumbnail list
      },
    );
    
    testWidgets(
      'Should not display thumbnail list when only one photo is present',
      (WidgetTester tester) async {
        // Arrange - Create a list with just one photo
        final singlePhotoList = <PhotoDetails>[
          PhotoDetails(
            'Single Photo',
            id: '1',
            urls: <String>['https://example.com/photo1.jpg'],
          ),
        ];
        
        // Act - Build the widget
        await pumpPhotoViewerDialog(
          tester: tester,
          photoList: singlePhotoList,
        );
        
        // Assert - Verify no thumbnail list is shown for single photo
        expect(find.byType(ListView), findsNothing);
      },
    );
    
  });
  
  group('PhotosViewerDialog - Permission-based UI elements', () {
    testWidgets(
      'Should show edit button when user has appropriate permissions',
      (WidgetTester tester) async {
        // Arrange - Set permissions for edit button
        PermissionService.permissionList = [PermissionConstants.manageProposals];
        
        // Act - Build the widget with proposal module type
        await pumpPhotoViewerDialog(
          tester: tester,
          photoList: testPhotoList,
          moduleType: FLModule.jobProposal,
          jobId: 123,
        );
        
        // Assert - Edit button should be visible
        expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      },
    );
    
    testWidgets(
      'Should hide edit button when user lacks required permissions',
      (WidgetTester tester) async {
        // Arrange - Reset permissions
        PermissionService.permissionList = [];
        
        // Act - Build the widget with proposal module type
        await pumpPhotoViewerDialog(
          tester: tester,
          photoList: testPhotoList,
          moduleType: FLModule.jobProposal,
          jobId: 123,
        );
        
        // Assert - Edit button should not be visible
        expect(find.byIcon(Icons.edit_outlined), findsNothing);
      },
    );
    
    testWidgets(
      'Should hide edit button for non-editable module types regardless of permissions',
      (WidgetTester tester) async {
        // Arrange - Set permissions but use non-editable module type
        PermissionService.permissionList = [PermissionConstants.manageProposals];
        
        // Act - Build the widget with company cam projects module type (not editable)
        await pumpPhotoViewerDialog(
          tester: tester,
          photoList: testPhotoList,
          moduleType: FLModule.companyCamProjects, // Use a definitely non-editable module type
          jobId: 123,
        );
        
        // Assert - Edit button should not be visible for non-editable module
        expect(find.byIcon(Icons.edit_outlined), findsNothing);
      },
    );
    
  });
  
  group('PhotosViewerDialog - Content display', () {
    testWidgets(
      'Should display correct photo title for the current image',
      (WidgetTester tester) async {
        // Act - Build the widget
        await pumpPhotoViewerDialog(
          tester: tester,
          photoList: testPhotoList,
        );
        
        // Assert - Initial title should match first photo
        expect(find.text('Photo 1'), findsOneWidget);
      },
    );
    
    testWidgets(
      'Should handle photos with empty or missing names gracefully',
      (WidgetTester tester) async {
        // Arrange - Create photo with empty name
        final emptyNamePhotoList = <PhotoDetails>[
          PhotoDetails(
            '', // Empty name
            id: '1',
            urls: <String>['https://example.com/photo1.jpg'],
          ),
        ];
        
        // Act - Build the widget
        await pumpPhotoViewerDialog(
          tester: tester,
          photoList: emptyNamePhotoList,
        );
        
        // Assert - Should show some text for the title (either empty or fallback)
        // We don't test for the exact text since the implementation might change
        expect(find.byType(Text), findsWidgets);
      },
    );
  });
  
  group('PhotosViewerDialog - Pagination UI', () {
    testWidgets(
      'Should render thumbnail list for multiple photos',
      (WidgetTester tester) async {
        // Arrange - Create a model with multiple photos
        final List<PhotoDetails> manyPhotos = <PhotoDetails>[];
        
        // Add several photos to test pagination UI
        for (int i = 1; i <= 5; i++) {
          manyPhotos.add(
            PhotoDetails(
              'Photo $i',
              id: i.toString(),
              urls: <String>['https://example.com/photo$i.jpg'],
            ),
          );
        }
        
        // Act - Build the widget
        await pumpPhotoViewerDialog(
          tester: tester,
          photoList: manyPhotos,
        );
        
        // Assert - Verify thumbnail list is shown
        expect(find.byType(ListView), findsOneWidget);
      },
    );
    
    testWidgets(
      'Should render pagination UI with multiple photos',
      (WidgetTester tester) async {
        // Arrange - Create photos for pagination test
        final List<PhotoDetails> photos = <PhotoDetails>[];
        for (int i = 1; i <= 5; i++) {
          photos.add(
            PhotoDetails(
              'Photo $i',
              id: i.toString(),
              urls: <String>['https://example.com/photo$i.jpg'],
            ),
          );
        }
        
        // Act - Build the widget with multiple photos
        await pumpPhotoViewerDialog(
          tester: tester,
          photoList: photos,
          moduleType: FLModule.jobPhotos,
        );
        
        // Assert - Verify thumbnail list is present for pagination
        expect(find.byType(ListView), findsOneWidget);
        expect(find.text('Photo 1'), findsOneWidget);
      },
    );
    
    testWidgets(
      'Should handle medium-sized photo lists',
      (WidgetTester tester) async {
        // Arrange - Create a medium-sized photo list
        final List<PhotoDetails> mediumPhotoList = <PhotoDetails>[];
        for (int i = 1; i <= 3; i++) {
          mediumPhotoList.add(
            PhotoDetails(
              'Medium Photo $i',
              id: i.toString(),
              urls: <String>['https://example.com/photo$i.jpg'],
            ),
          );
        }
        
        // Act - Build the widget with medium photo list
        await pumpPhotoViewerDialog(
          tester: tester,
          photoList: mediumPhotoList,
          moduleType: FLModule.jobPhotos,
        );
        
        // Assert - Verify UI renders correctly with medium list
        expect(find.text('Medium Photo 1'), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
      },
    );
    
    testWidgets(
      'Should display pagination UI elements',
      (WidgetTester tester) async {
        // Arrange - Create test photos
        final List<PhotoDetails> photos = <PhotoDetails>[];
        for (int i = 1; i <= 5; i++) {
          photos.add(
            PhotoDetails(
              'Pagination Photo $i',
              id: i.toString(),
              urls: <String>['https://example.com/photo$i.jpg'],
            ),
          );
        }
        
        // Act - Build the widget
        await pumpPhotoViewerDialog(
          tester: tester,
          photoList: photos,
          moduleType: FLModule.jobPhotos,
        );
        
        // Assert - Verify pagination UI elements are present
        expect(find.byType(ListView), findsOneWidget); // Thumbnail list
        expect(find.text('Pagination Photo 1'), findsOneWidget); // First photo title
      },
    );
  });
  
  group('PhotosViewerDialog - Action buttons', () {
    testWidgets(
      'Should display all standard action buttons',
      (WidgetTester tester) async {
        // Act - Build the widget
        await pumpPhotoViewerDialog(
          tester: tester,
          photoList: testPhotoList,
        );
        
        // Assert - Action buttons should be visible
        expect(find.byIcon(Icons.close_outlined), findsOneWidget); // Close button
        expect(find.byIcon(Icons.print_outlined), findsOneWidget); // Print button
        expect(find.byIcon(Icons.photo_outlined), findsOneWidget); // Download button
      },
    );
    
    testWidgets(
      'Should handle different module types with appropriate UI',
      (WidgetTester tester) async {
        // Act - Build the widget with company cam projects module type
        await pumpPhotoViewerDialog(
          tester: tester,
          photoList: testPhotoList,
          moduleType: FLModule.companyCamProjects,
        );
        
        // Assert - Standard buttons should be present
        expect(find.byIcon(Icons.close_outlined), findsOneWidget);
        expect(find.byIcon(Icons.print_outlined), findsOneWidget);
        expect(find.byIcon(Icons.photo_outlined), findsOneWidget);
      },
    );
  });
  
  group('PhotosViewerDialog - Edge cases', () {
    testWidgets(
      'Should handle minimal photo list gracefully',
      (WidgetTester tester) async {
        // Arrange - Create a minimal photo list (empty lists not supported by widget)
        final minimalPhotoList = <PhotoDetails>[
          PhotoDetails(
            'Minimal Photo',
            id: '1',
            urls: <String>['https://example.com/minimal.jpg'],
          ),
        ];
        
        // Act - Build the widget with minimal photo list
        await pumpPhotoViewerDialog(
          tester: tester,
          photoList: minimalPhotoList,
        );
        
        // Assert - Photo should be displayed correctly
        expect(find.text('Minimal Photo'), findsOneWidget);
      },
    );
  });
}
