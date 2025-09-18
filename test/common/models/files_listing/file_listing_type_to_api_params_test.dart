import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/files_listing/file_listing_type_to_api_params.dart';

void main() {
  group('FileListingTypeToApiParams constructor - tests initialization with various parameter values', () {
    test("FileListingTypeToApiParams constructor should initialize with default values when no parameters are provided", () {
      final params = FileListingTypeToApiParams();
      
      expect(params.search, false);
      expect(params.index, null);
      expect(params.cursorId, null);
      expect(params.onlyImages, false);
    });

    test("FileListingTypeToApiParams constructor should initialize with provided values correctly", () {
      final params = FileListingTypeToApiParams(
        search: true,
        index: 10,
        cursorId: 'test-cursor-id',
        onlyImages: true,
      );
      
      expect(params.search, true);
      expect(params.index, 10);
      expect(params.cursorId, 'test-cursor-id');
      expect(params.onlyImages, true);
    });
    
    test("FileListingTypeToApiParams constructor should handle empty string cursor ID correctly", () {
      final params = FileListingTypeToApiParams(cursorId: '', onlyImages: true);
      
      expect(params.cursorId, '');
      
      final result = params.toOnlyImages();
      expect(result['cursor_id'], '');
    });
    
    test("FileListingTypeToApiParams constructor should accept zero as a valid index value", () {
      final params = FileListingTypeToApiParams(index: 0);
      
      expect(params.index, 0);
    });
    
    test("FileListingTypeToApiParams constructor should accept negative index values", () {
      final params = FileListingTypeToApiParams(index: -5);
      
      expect(params.index, -5);
    });
  });

  group('FileListingTypeToApiParams@toOnlyImages - tests map generation based on onlyImages flag', () {
    test('FileListingTypeToApiParams@toOnlyImages should return empty map when onlyImages is false', () {
      final params = FileListingTypeToApiParams(
        cursorId: 'test-cursor-id',
        onlyImages: false,
      );
      
      final result = params.toOnlyImages();
      
      expect(result, isEmpty);
    });

    test('FileListingTypeToApiParams@toOnlyImages should return map with cursor_id and mime_type when onlyImages is true with cursor ID', () {
      final params = FileListingTypeToApiParams(
        cursorId: 'test-cursor-id',
        onlyImages: true,
      );
      
      final result = params.toOnlyImages();
      
      expect(result, {
        'cursor_id': 'test-cursor-id',
        'mime_type': 'images',
      });
    });

    test('FileListingTypeToApiParams@toOnlyImages should include cursor_id as null when not provided and onlyImages is true', () {
      final params = FileListingTypeToApiParams(
        onlyImages: true,
      );
      
      final result = params.toOnlyImages();
      
      expect(result, {
        'cursor_id': null,
        'mime_type': 'images',
      });
    });
    
    test('FileListingTypeToApiParams@toOnlyImages should return correct mime_type value regardless of other parameters', () {
      final params = FileListingTypeToApiParams(
        search: true,
        index: 999,
        onlyImages: true,
      );
      
      final result = params.toOnlyImages();
      
      expect(result['mime_type'], 'images');
    });
    
    test('FileListingTypeToApiParams@toOnlyImages should return empty map when onlyImages is explicitly set to false', () {
      final params = FileListingTypeToApiParams(
        cursorId: 'test-cursor-id',
        onlyImages: false,
        search: true,
        index: 5,
      );
      
      final result = params.toOnlyImages();
      
      expect(result, isEmpty);
    });
  });
  
  group('FileListingTypeToApiParams edge cases and error handling - tests behavior with extreme values and special inputs', () {
    test('FileListingTypeToApiParams should handle all parameters set to extreme values', () {
      final params = FileListingTypeToApiParams(
        search: true,
        index: -999999,
        cursorId: String.fromCharCodes(List.filled(1000, 65)), // Very long string
        onlyImages: true,
      );
      
      expect(params.search, true);
      expect(params.index, -999999);
      expect(params.cursorId!.length, 1000);
      expect(params.onlyImages, true);
      
      final result = params.toOnlyImages();
      expect(result['cursor_id']!.length, 1000);
    });
    
    test('FileListingTypeToApiParams should handle search parameter correctly regardless of other parameters', () {
      final params1 = FileListingTypeToApiParams(search: true, onlyImages: false);
      final params2 = FileListingTypeToApiParams(search: false, onlyImages: true);
      
      expect(params1.search, true);
      expect(params2.search, false);
      
      final result1 = params1.toOnlyImages();
      final result2 = params2.toOnlyImages();
      
      expect(result1, isEmpty);
      expect(result2, isNotEmpty);
    });
    
    test('FileListingTypeToApiParams should handle null cursorId when onlyImages is true', () {
      final params = FileListingTypeToApiParams(
        onlyImages: true,
        cursorId: null,
      );
      
      final result = params.toOnlyImages();
      
      expect(result, {
        'cursor_id': null,
        'mime_type': 'images',
      });
    });
    
    test('FileListingTypeToApiParams should handle special characters in cursorId', () {
      const specialCursorId = '!@#\$%^&*()_+{}[]|:;<>,.?/~`';
      final params = FileListingTypeToApiParams(
        onlyImages: true,
        cursorId: specialCursorId,
      );
      
      expect(params.cursorId, specialCursorId);
      
      final result = params.toOnlyImages();
      expect(result['cursor_id'], specialCursorId);
    });
  });
}
