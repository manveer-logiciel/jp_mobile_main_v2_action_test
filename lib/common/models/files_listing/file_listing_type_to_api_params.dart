/// API parameters for paginated file listing operations.
/// 
/// PAGINATION SUPPORT: This class enables cursor-based pagination for photo listings
/// by providing a standardized way to pass cursor IDs and filtering options to API calls.
class FileListingTypeToApiParams {
  /// The ID of the last item in the current list, used for cursor-based pagination.
  String? cursorId;
  
  /// Flag to indicate if only images should be returned.
  bool onlyImages;
  
  /// Flag to indicate if this is a search operation.
  bool search;
  
  /// Optional index parameter for pagination.
  int? index;

  /// Creates a new instance of [FileListingTypeToApiParams].
  /// 
  /// [search] - Whether this is a search operation.
  /// [index] - Optional index for pagination.
  /// [cursorId] - ID of the last item for cursor-based pagination.
  /// [onlyImages] - Whether to filter results to only include images.
  FileListingTypeToApiParams({
    this.search = false,
    this.index,
    this.cursorId,
    this.onlyImages = false
  });

  /// Converts the parameters to a map for API calls that filter by image type.
  /// 
  /// Returns a map with cursor_id and mime_type parameters if [onlyImages] is true,
  /// otherwise returns an empty map.
  Map<String, dynamic> toOnlyImages() {
    if (onlyImages) {
      return {
        'cursor_id': cursorId,
        'mime_type': 'images'
      };
    }
    return {};
  }
}