import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/photo_viewer_model.dart';
import 'package:jobprogress/core/constants/locale.dart';
import 'package:jobprogress/translations/index.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';

void main() {
  // Setup GetX translations for 'photos'.tr usage in tests
  setUpAll(() {
    Get.testMode = true;
    Get.addTranslations(JPTranslations().keys);
    Get.locale = LocaleConst.usa;
  });
  
  tearDownAll(() {
    Get.reset();
  });
  group("FilesListingModel.fromContractsJson should handle data correctly", () {
    group("[id] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.id, isNull);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.id, isNull);
      });

      test("In case json data is invalid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"id": "1"});
        expect(result.id, "1");
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"id": 1});
        expect(result.id, "1");
      });
    });

    group("[parentId] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.parentId, isNull);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.parentId, isNull);
      });

      test("In case json data is invalid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"parent_id": "1"});
        expect(result.parentId, 1);
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"parent_id": 1});
        expect(result.parentId, 1);
      });
    });

    group("[name] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.name, isEmpty);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.name, isEmpty);
      });

      test("In case json data is invalid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"title": 1});
        expect(result.name, "1");
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"title": "Contract"});
        expect(result.name, "Contract");
      });
    });

    group("[jobId] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.jobId, isNull);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.jobId, isNull);
      });

      test("In case json data is invalid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"job_id": "1"});
        expect(result.jobId, 1);
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"job_id": 1});
        expect(result.jobId, 1);
      });
    });

    group("[isDir] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.isDir, 0);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.isDir, 0);
      });

      test("In case json data is invalid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"is_dir": "1"});
        expect(result.isDir, 1);
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"is_dir": 1});
        expect(result.isDir, 1);
      });
    });

    group("[path] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.path, isNull);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.path, isNull);
      });

      test("In case json data is invalid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"file_path": 1});
        expect(result.path, "1");
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"file_path": "https://example.com/1"});
        expect(result.path, "https://example.com/1");
      });
    });

    group("[isFile] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.isFile, false);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.isFile, false);
      });

      test("In case json data is invalid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"is_file": "1"});
        expect(result.isFile, true);
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"is_file": 1});
        expect(result.isFile, true);
      });
    });

    group("[relativePath] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.relativePath, isNull);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.relativePath, isNull);
      });

      test("In case json data is invalid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"path": 1});
        expect(result.relativePath, "1");
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"path": "https://example.com/1"});
        expect(result.relativePath, "https://example.com/1");
      });
    });

    group("[meta] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.meta, isEmpty);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.meta, isEmpty);
      });

      test("In case json data is invalid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"meta": 1});
        expect(result.meta, isEmpty);
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"meta": ["meta"]});
        expect(result.meta, ["meta"]);
      });
    });

    group("[createdAt] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.createdAt, isNull);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.createdAt, isNull);
      });

      test("In case json data is invalid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"created_at": 1});
        expect(result.createdAt, "1");
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"created_at": "2022-01-01"});
        expect(result.createdAt, "2022-01-01");
      });
    });

    group("[updatedAt] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.updatedAt, isNull);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.updatedAt, isNull);
      });

      test("In case json data is invalid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"updated_at": 1});
        expect(result.updatedAt, "1");
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"updated_at": "2022-01-01"});
        expect(result.updatedAt, "2022-01-01");
      });
    });

    group("[type] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.type, isNull);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.type, isNull);
      });

      test("In case json data is invalid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"type": 1});
        expect(result.type, "1");
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"type": "image"});
        expect(result.type, "image");
      });
    });

    group("[createdBy] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.createdBy, isNull);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.createdBy, isNull);
      });

      test("In case json data is invalid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"created_by": "test"});
        expect(result.createdBy, isNull);
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"created_by": 1});
        expect(result.createdBy, 1);
      });
    });

    group("[origin] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.origin, isNull);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.origin, isNull);
      });

      test("In case json data is invalid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"origin": "test"});
        expect(result.origin, "test");
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"origin": 1});
        expect(result.origin, 1);
      });
    });

    group("[url] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.url, isNull);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.url, isNull);
      });

      test("In case json data is invalid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"url": 1});
        expect(result.url, "1");
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"url": 'https://google.com'});
        expect(result.url, 'https://google.com');
      });
    });

    group("[thumbUrl] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.thumbUrl, isNull);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.thumbUrl, isNull);
      });

      test("In case json data is invalid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"thumb": 1});
        expect(result.thumbUrl, "1");
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"thumb": 'https://google.com'});
        expect(result.thumbUrl, 'https://google.com');
      });
    });

    group("[originalFilePath] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.originalFilePath, isNull);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.originalFilePath, isNull);
      });

      test("In case json data is invalid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"file_path": 1});
        expect(result.originalFilePath, "1");
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"file_path": 'https://google.com'});
        expect(result.originalFilePath, 'https://google.com');
      });
    });

    group("[multiSizeImages] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.multiSizeImages, isNull);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.multiSizeImages, isNull);
      });

      test("In case json data is invalid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"multi_size_images": 1});
        expect(result.multiSizeImages, isNull);
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"multi_size_images": ['https://google.com']});
        expect(result.multiSizeImages, ['https://google.com']);
      });
    });

    group("[showThumb] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.showThumbImage, false);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.showThumbImage, false);
      });

      test("In case json data is valid and not empty and contract is a file and has thumb", () {
        final result = FilesListingModel.fromContractsJson({"is_file": true, "thumb": 'https://google.com'});
        expect(result.showThumbImage, true);
      });
    });

    group("[jpThumbType] should be set correctly", () {
      test("In case of folder, thumb type should be [JPThumbType.folder]", () {
        final result = FilesListingModel.fromContractsJson({"is_dir": 1});
        expect(result.jpThumbType, JPThumbType.folder);
      });

      test("In case of file, thumb type should be [JPThumbType.icon]", () {
        final result = FilesListingModel.fromContractsJson({"is_dir": 0});
        expect(result.jpThumbType, JPThumbType.icon);
      });

      test("In case of image file, thumb type should be [JPThumbType.image]", () {
        final result = FilesListingModel.fromContractsJson({"is_dir": 0, "file_path": ['https://google.png']});
        expect(result.jpThumbType, JPThumbType.image);
      });
    });

    group("[file_size] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.size, isNull);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.size, isNull);
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"file_size": 1});
        expect(result.size, 1);
      });
    });

    group("[share_on_hop] should be set correctly", () {
      test("In case json data is null", () {
        final result = FilesListingModel.fromContractsJson(null);
        expect(result.isShownOnCustomerWebPage, isFalse);
      });

      test("In case json data is empty", () {
        final result = FilesListingModel.fromContractsJson({});
        expect(result.isShownOnCustomerWebPage, isFalse);
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromContractsJson({"share_on_hop": "1"});
        expect(result.isShownOnCustomerWebPage, isTrue);
      });
    });
  });

  group("FilesListingModel.fromFavouriteListingJson should handle data correctly", () {
    group("[division] should be set correctly", () {
      test("In case json data is empty", () {
        final result = FilesListingModel.fromFavouriteListingJson({});
        expect(result.division, isNull);
      });

      test("In case json data is not valid and not empty", () {
        final result = FilesListingModel.fromFavouriteListingJson({"division": 1});
        expect(result.division, isNull);
      });

      test("In case json data is valid and not empty", () {
        final result = FilesListingModel.fromFavouriteListingJson(
            {
              "division": {
                "id": 1,
                "name": "Division 1"
              },
            },
        );
        expect(result.division, isNotNull);
        expect(result.division!.id, 1);
        expect(result.division!.name, "Division 1");
      });

      test("In case json data is valid and not empty and division is null", () {
        final result = FilesListingModel.fromFavouriteListingJson({"division": null});
        expect(result.division, isNull);
      });
    });
  });
  
  group('FilesListingModel@toPhotoDetailModel - tests conversion to PhotoDetails model', () {
    test('FilesListingModel@toPhotoDetailModel should convert basic properties correctly', () {
      // Arrange
      final model = FilesListingModel()
        ..id = '123'
        ..name = 'test_photo.jpg'
        ..parentId = 456
        ..originalFilePath = 'https://example.com/original.jpg'
        ..thumbUrl = 'https://example.com/thumb.jpg';
      
      // Act
      final result = model.toPhotoDetailModel(FLModule.jobPhotos);
      
      // Assert
      expect(result, isA<PhotoDetails>());
      expect(result.name, 'test_photo.jpg');
      expect(result.id, '123');
      expect(result.parentId, '456');
      expect(result.urls, contains('https://example.com/original.jpg'));
      expect(result.urls, contains('https://example.com/thumb.jpg'));
      expect(result.urls!.first, 'https://example.com/thumb.jpg'); // Thumb URL should be first for non-Dropbox
    });
    
    test('FilesListingModel@toPhotoDetailModel should use default name when name is null', () {
      // Arrange
      final model = FilesListingModel()
        ..id = '123'
        ..name = null
        ..parentId = 456
        ..originalFilePath = 'https://example.com/original.jpg'
        ..thumbUrl = 'https://example.com/thumb.jpg';
      
      // Act
      final result = model.toPhotoDetailModel(FLModule.jobPhotos);
      
      // Assert
      expect(result.name, 'Photos'); // Should use the translated 'photos' value
    });
    
    test('FilesListingModel@toPhotoDetailModel should handle multiSizeImages correctly', () {
      // Arrange
      final model = FilesListingModel()
        ..id = '123'
        ..name = 'test_photo.jpg'
        ..multiSizeImages = [
          'https://example.com/small.jpg',
          'https://example.com/medium.jpg',
          'https://example.com/large.jpg'
        ]
        ..thumbUrl = 'https://example.com/thumb.jpg';
      
      // Act
      final result = model.toPhotoDetailModel(FLModule.jobPhotos);
      
      // Assert
      expect(result.urls!.length, 4); // 3 multi-size images + 1 thumb
      expect(result.urls!.first, 'https://example.com/thumb.jpg');
      expect(result.urls!.contains('https://example.com/small.jpg'), true);
      expect(result.urls!.contains('https://example.com/medium.jpg'), true);
      expect(result.urls!.contains('https://example.com/large.jpg'), true);
    });
    
    test('FilesListingModel@toPhotoDetailModel should handle base64Image correctly', () {
      // Arrange
      final base64Data = Uint8List.fromList([1, 2, 3, 4, 5]);
      final model = FilesListingModel()
        ..id = '123'
        ..name = 'test_photo.jpg'
        ..originalFilePath = 'https://example.com/original.jpg'
        ..thumbUrl = 'https://example.com/thumb.jpg'
        ..base64Image = base64Data;
      
      // Act
      final result = model.toPhotoDetailModel(FLModule.jobPhotos);
      
      // Assert
      expect(result.base64Image, same(base64Data));
    });
    
    test('FilesListingModel@toPhotoDetailModel should handle Dropbox module type correctly', () {
      // Arrange
      final model = FilesListingModel()
        ..id = '123'
        ..name = 'test_photo.jpg'
        ..originalFilePath = 'https://example.com/original.jpg'
        ..thumbUrl = 'https://example.com/thumb.jpg';
      
      // Act
      final result = model.toPhotoDetailModel(FLModule.dropBoxListing);
      
      // Assert
      expect(result.urls!.length, 1);
      expect(result.urls!.first, 'https://example.com/original.jpg');
      // Thumb URL should NOT be inserted for Dropbox listings
      expect(result.urls!.contains('https://example.com/thumb.jpg'), false);
    });
    
    test('FilesListingModel@toPhotoDetailModel should handle null originalFilePath and multiSizeImages', () {
      // Arrange
      final model = FilesListingModel()
        ..id = '123'
        ..name = 'test_photo.jpg'
        ..originalFilePath = null
        ..multiSizeImages = []
        ..thumbUrl = 'https://example.com/thumb.jpg';
      
      // Act
      final result = model.toPhotoDetailModel(FLModule.jobPhotos);
      
      // Assert
      expect(result.urls!.length, 1);
      expect(result.urls!.first, 'https://example.com/thumb.jpg');
    });
    
    test('FilesListingModel@toPhotoDetailModel should handle null thumbUrl for non-Dropbox module', () {
      // Arrange
      final model = FilesListingModel()
        ..id = '123'
        ..name = 'test_photo.jpg'
        ..originalFilePath = 'https://example.com/original.jpg'
        ..thumbUrl = null;
      
      // Act & Assert
      expect(() => model.toPhotoDetailModel(FLModule.jobPhotos), throwsA(isA<Error>()));
    });
  });
}
