
import 'dart:typed_data';

/// Photo viewer model with pagination support.
/// 
/// PAGINATION FEATURE: Uses generic type <T> to support different controller types
/// for loading photos on-demand, reducing memory usage and improving performance
/// when displaying large collections of photos.
class PhotoViewerModel<T> {
  /// The index of the image to initially scroll to when opening the viewer.
  int scrollTo;
  
  /// List of all images to display in the photo viewer.
  List<PhotoDetails> allImages;
  
  /// The controller that will handle loading more photos.
  /// This enables pagination functionality in the photo viewer.
  T? controller;

  /// Creates a new instance of [PhotoViewerModel].
  /// 
  /// [scrollTo] - The index of the image to initially display.
  /// [allImages] - The list of images to show in the viewer.
  /// [controller] - Optional controller for handling pagination.
  PhotoViewerModel(this.scrollTo, this.allImages, {this.controller});
}

class PhotoDetails {
  String name;
  List<String>? urls;
  Uint8List? base64Image;
  String? id;
  String? originalFilePath;
  String? parentId;

  PhotoDetails(this.name, {this.urls = const [], this.base64Image, this.id, this.originalFilePath, this.parentId});
}