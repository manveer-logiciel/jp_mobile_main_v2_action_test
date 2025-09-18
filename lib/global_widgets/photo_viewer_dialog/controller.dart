import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/file_listing_type_to_api_params.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/photo_viewer_model.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/download.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

/// Controller for the photo viewer dialog with lazy loading pagination.
///
/// Key features:
/// - Loads photos on-demand as user scrolls through thumbnails
/// - Supports different controller types via generic type parameter <T>
/// - Provides smooth scrolling and centering of selected thumbnails
/// - Handles memory efficiently by loading photos only when needed
class PhotosViewerController<T> extends GetxController with GetTickerProviderStateMixin {

  /// Creates a new instance of [PhotosViewerController].
  ///
  /// [data] - The photo viewer model containing images and pagination controller.
  /// [type] - The module type that determines available actions and pagination behavior.
  /// [jobId] - Optional job ID associated with these photos.
  PhotosViewerController(this.data, this.type, this.jobId);

  /// The photo viewer model containing images and pagination controller.
  final PhotoViewerModel<T> data;
  
  /// Optional job ID associated with these photos.
  final int? jobId;

  /// The module type that determines available actions and pagination behavior.
  final FLModule type;

  /// Whether scrolling is enabled in the photo viewer.
  bool enableScrolling = true;
  
  /// Flag indicating whether more photos are currently being loaded.
  bool isLoadingMore = false;
  
  /// Flag indicating whether there are more photos available to load.
  bool hasMorePhotos = true;
  
  /// Number of shimmer placeholders to show when loading more photos.
  /// This creates a loading indicator at the end of the thumbnail list.
  final int shimmerPlaceholderCount = 1;
  
  /// Auto scroll controller for the thumbnail ListView with index-based scrolling.
  /// This enables programmatic scrolling to specific thumbnails.
  late final AutoScrollController thumbnailScrollController;

  /// Action being performed on the current photo.
  String? action;
  
  /// Whether a save-as operation has been performed.
  bool? isSaveAsPerformed;

  /// Tab controller for managing the currently displayed photo.
  late TabController tabController;
  
  /// Name of the currently displayed image.
  String imageName = "";

  /// List of images that have been edited.
  List<FilesListingModel> editedImages = [];
  
  /// List of images that have been saved with a different name.
  List<FilesListingModel> saveAsImages = [];

  /// Whether to show the edit button based on the module type and user permissions.
  bool get doShowEditButton => type == FLModule.jobPhotos || type == FLModule.estimate || (type == FLModule.jobProposal && PermissionService.hasUserPermissions([PermissionConstants.manageProposals]));

  /// Total item count for the thumbnail list, including loading indicators.
  /// This is used by the ListView.builder to determine how many items to render.
  get getItemCount => data.allImages.length
      + (isLoadingMore || hasMorePhotos ? shimmerPlaceholderCount : 0);

  /// Initializes the controller when it's created.
  /// 
  /// Sets up the tab controller for photo navigation and the auto scroll controller
  /// for the thumbnail list. Also initializes pagination state and scrolls to the
  /// initially selected photo.
  @override
  void onInit() {
    // Initialize tab controller for photo navigation
    tabController = TabController(length: data.allImages.length, vsync: this)
      ..addListener(() => tabControllerListener());
      
    // Initialize auto scroll controller with options for the thumbnail list
    thumbnailScrollController = AutoScrollController(
      viewportBoundaryGetter: () => const Rect.fromLTRB(0, 0, 0, 0),
      axis: Axis.horizontal,
    )..addListener(handleThumbnailScroll);
    
    // Scroll to the initially selected photo if there are multiple images
    if (data.allImages.length > 1) {
      tabController.animateTo(data.scrollTo);
    }
    
    // Initialize the image name if it's empty
    if(imageName.isEmpty) {
      updateImageName();
    }

    // Determine if pagination is available for this module type
    hasMorePhotos = canPerformLoadMore();

    super.onInit();
  }

  /// Listener for tab controller changes.
  /// 
  /// Updates the displayed image name and ensures the thumbnail list
  /// scrolls to keep the selected thumbnail visible and centered.
  void tabControllerListener() {
    // Update the displayed image name when tab changes
    updateImageName();
    
    // Re-enable scrolling when tab changes
    toggleEnableScrolling(true);

    // Schedule thumbnail scrolling after the frame is rendered
    // This ensures the UI is updated before scrolling occurs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToSelectedThumbnail();
    });
  }
  
  /// Scrolls the thumbnail list to center the currently selected thumbnail.
  /// 
  /// Uses the scroll_to_index package to programmatically scroll to a specific
  /// item in the ListView and center it in the viewport.
  void scrollToSelectedThumbnail() {
    // Skip if there's only one or no images
    if (data.allImages.length <= 1) return;
    
    try {
      // Only proceed if the scroll controller is attached to a ScrollView
      if (!thumbnailScrollController.hasClients) return;
      
      // Use the scroll_to_index package to scroll to the selected thumbnail
      // with automatic centering in the viewport for better UX
      thumbnailScrollController.scrollToIndex(
        tabController.index,
        preferPosition: AutoScrollPosition.middle,  // Center the thumbnail
        duration: const Duration(milliseconds: 150), // Smooth animation
      );
    } catch (e) {
      // Log any errors that occur during scrolling
      Helper.recordError(e);
    }
  }
  
  /// Handles scroll events in the thumbnail ListView.
  /// 
  /// Detects when the user has scrolled near the end of the list
  /// and triggers loading of more photos if available.
  void handleThumbnailScroll() {
    // Only proceed if the scroll controller is attached to a ScrollView
    if (!thumbnailScrollController.hasClients) return;
    
    // Calculate if we're near the end of the list to trigger pagination
    final maxScroll = thumbnailScrollController.position.maxScrollExtent;
    final currentScroll = thumbnailScrollController.position.pixels;
    
    // Define a threshold before the end of the list (200 pixels)
    // to start loading more photos before reaching the absolute end
    final threshold = maxScroll - 200;

    // If we've scrolled past the threshold and aren't already loading more photos,
    // trigger the pagination to load more photos
    if (currentScroll >= threshold && !isLoadingMore) {
      loadMorePhotos();
    }
  }
  
  /// Called after the widget is fully built and rendered.
  /// 
  /// Ensures that the thumbnail list is properly scrolled to the selected thumbnail
  /// after the UI is fully built and rendered.
  @override
  void onReady() {
    super.onReady();
    
    // Ensure thumbnail centering after the UI is fully built
    // This is important for initial positioning of the thumbnail list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToSelectedThumbnail();
    });
  }

  void updateImageList(int newLength){
    updateImageName();
    tabController = TabController(length: newLength, vsync: this)..addListener(() {
      updateImageName();
    });
    if(imageName.isEmpty) {
      updateImageName();
    }
  }

  printFile() async {
    try {
      showJPLoader(
          msg: 'downloading_file'.tr
      );

      if(type == FLModule.dropBoxListing) {
           String token = await AuthService.getAccessToken();
        data.allImages[tabController.index].originalFilePath = '${Urls.dropBoxDownLoading}?file_id=${data.allImages[tabController.index].id}&access_token=$token';

          String fileName =
        FileHelper.getFileName(data.allImages[tabController.index].name);
        await DownloadService.downloadFile(
            data.allImages[tabController.index].originalFilePath!, fileName, action: 'print', classType: 'png');
      } else {
        String fileName =
        FileHelper.getFileName(data.allImages[tabController.index].urls!.last);
        await DownloadService.downloadFile(
            data.allImages[tabController.index].urls!.last, fileName,
            action: 'print',
            classType: 'png'
        );
      }

    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  editFile() async {

    dynamic result = await Get.toNamed(
      Routes.imageEditor,
      arguments: {
        'id': data.allImages[tabController.index].id,
        'module': type,
        'title': data.allImages[tabController.index].name,
        'isPreviewImage': true,
        'jobId': jobId,
        NavigationParams.parentId: data.allImages[tabController.index].parentId.toString(),
      },
      preventDuplicates: false
    );
    if(result != null) {
      addUpdateImageList(result);
    }
    
  }

  void addUpdateImageList(dynamic result){
    List<PhotoDetails> tempFiles = [];
    action = result['action'] ?? '';
    
    
    if(result["action"] == 'save_as') {
      for(FilesListingModel file in result['files']){
        tempFiles.add(
          PhotoDetails(
            file.name ?? 'photos'.tr,
            urls: file.multiSizeImages ?? (file.originalFilePath != null ? [file.originalFilePath!] : [file.url.toString()]),
            base64Image: file.base64Image,
            id: file.id.toString(),
            parentId: file.parentId.toString(),
          )
        );
        saveAsImages.add(file);
      }

      for(PhotoDetails file in tempFiles){
        data.allImages.insert(0, file);
        updateImageList(data.allImages.length); 
      }
      update();
    } else {
      editedImages.add(result['file']);

      PhotoDetails photoDetails = PhotoDetails(
        result['file'].name ?? 'photos'.tr,
        urls: result['file'].multiSizeImages ?? (result['file'].originalFilePath != null ? [result['file'].originalFilePath!] : [result['file'].url.toString()]),
        base64Image: result['file'].base64Image,
        id: result['file'].id.toString(),
        parentId: result['file'].parentId.toString(),
      );

      data.allImages[tabController.index] = photoDetails;

      if(!Helper.isValueNullOrEmpty(result['files'])){
        tempFiles.clear();
        saveAsImages.clear();
        saveAsImages.addAll(result['files']);
        for(FilesListingModel file in result['files']){
          tempFiles.add(
            PhotoDetails(
              file.name ?? 'photos'.tr,
              urls: file.multiSizeImages ?? (file.originalFilePath != null ? [file.originalFilePath!] : [file.url.toString()]),
              base64Image: file.base64Image,
              id: file.id.toString(),
              parentId: file.parentId.toString(),
            )
          );
        }

        for(PhotoDetails file in tempFiles){
          data.allImages.insert(0, file);
          updateImageList(data.allImages.length); 
        }
      }
      update();
    }
    isSaveAsPerformed = !Helper.isValueNullOrEmpty(saveAsImages);
  }

  downloadAndOpenFile() async {
    try {
      showJPLoader(
          msg: 'downloading_file'.tr
      );
      if(type == FLModule.dropBoxListing) {
        String token = await AuthService.getAccessToken();
        data.allImages[tabController.index].originalFilePath = '${Urls.dropBoxDownLoading}?file_id=${data.allImages[tabController.index].id}&access_token=$token';

          String fileName =
        FileHelper.getFileName(data.allImages[tabController.index].name);
        await DownloadService.downloadFile(
            data.allImages[tabController.index].originalFilePath!, fileName, classType: 'png');
      } else {
        String fileName =
        FileHelper.getFileName(data.allImages[tabController.index].urls!.last);
        await DownloadService.downloadFile(
            data.allImages[tabController.index].urls!.last, fileName, classType: 'png');
      }

    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  toggleEnableScrolling(bool val) {
    if (val == enableScrolling) return;

    enableScrolling = val;
    update();
  }

  void updateImageName() {
    imageName = data.allImages[tabController.index].name;
    update();
  }

  /// Loads more photos when user scrolls to the end of the thumbnail list.
  /// 
  /// PAGINATION ENTRY POINT: This method is triggered by scroll events and
  /// manages the entire pagination flow including loading states and error handling.
  Future<void> loadMorePhotos() async {
    // Don't attempt to load more if already loading or if there are no more photos
    if (isLoadingMore || !hasMorePhotos) return;

    // Set loading state to show loading indicators
    toggleLoadingMore(true);
    
    try {
      // Delegate to the appropriate controller type for loading more photos
      await typeToLoadMorePhotos();
    } catch (e) {
      // If an error occurs, assume there are no more photos to load
      hasMorePhotos = false;
      rethrow;
    } finally {
      // Reset loading state regardless of success or failure
      toggleLoadingMore(false);
    }
  }

  /// Delegates to the appropriate controller type for loading more photos.
  /// 
  /// This method uses the generic type parameter T to determine which
  /// controller implementation to use for loading more photos.
  Future<void> typeToLoadMorePhotos() async {
    switch (T) {
      case FilesListingController:
        // For FilesListingController, use the specialized implementation
        await loadMoreWithFilesListingController(data.controller as FilesListingController);
        break;
      default:
        // For any other controller type, assume no more photos are available
        hasMorePhotos = false;
    }
  }

  /// Updates the loading state and triggers a UI update.
  /// 
  /// [val] - The new loading state (true = loading, false = not loading).
  void toggleLoadingMore(bool val) {
    isLoadingMore = val;
    update(); // Trigger GetX UI update
  }
  
  /// PAGINATION IMPLEMENTATION: Fetches more photos using cursor-based pagination.
  /// 
  /// Technical details:
  /// - Uses the last image's ID as cursor for pagination
  /// - Filters API request to only return images
  /// - Converts API response to PhotoDetails models
  /// - Updates UI components when new photos are loaded
  /// - Supports multiple module types (job photos, company files, estimates, proposals)
  /// 
  /// [controller] - The FilesListingController that makes the API call
  Future<void> loadMoreWithFilesListingController(FilesListingController controller) async {
    debugPrint("HITTING LOAD MORE FOR ${type.toString()}");
    
    // Check if the controller indicates more photos can be loaded
    if (!controller.canShowLoadMore) {
      hasMorePhotos = false;
      return;
    }

    // Create API parameters for pagination request
    // Using cursor-based pagination with the last image's ID as the cursor
    final typeToApiParams = FileListingTypeToApiParams(
      onlyImages: true,  // Only fetch images, not other file types
      cursorId: data.allImages.last.id  // Use the last image's ID as the cursor
    );

    // Call the API to fetch more photos
    dynamic response = await controller.typeToApi(typeToApiParams);
    List<FilesListingModel> list = response['list'];

    if (list.isNotEmpty) {
      // Convert each file listing model to a photo details model and add to the list
      for (FilesListingModel file in list) {
        data.allImages.add(file.toPhotoDetailModel(type));
      }

      // Update the tab controller to reflect the new total count of images
      updateTabController();
    } else {
      // If no more photos were returned, mark that there are no more to load
      hasMorePhotos = false;
    }
  }

  /// Determines if pagination is supported for the current module type.
  /// 
  /// Supports pagination for job photos, company files, estimates, proposals,
  /// measurements, material lists, work orders, stage resources, customer files,
  /// and instant photo gallery.
  /// This method can be extended to support additional module types in the future.
  /// 
  /// Returns true if pagination is supported, false otherwise.
  bool canPerformLoadMore() {
    switch (type) {
      case FLModule.jobPhotos:
      case FLModule.companyFiles:
      case FLModule.estimate:
      case FLModule.jobProposal:
      case FLModule.measurements:
      case FLModule.materialLists:
      case FLModule.workOrder:
      case FLModule.stageResources:
      case FLModule.customerFiles:
      case FLModule.instantPhotoGallery:
        return true;
      default:
        // Other module types don't support pagination yet
        return false;
    }
  }

  /// Updates the tab controller when new photos are added.
  /// 
  /// This recreates the tab controller with the new total count of images
  /// while preserving the currently selected tab.
  void updateTabController() {
    // Store the current tab index to restore it after recreation
    final int currentIndex = tabController.index;
    
    // Dispose the old tab controller to prevent memory leaks
    tabController.dispose();
    
    // Create a new tab controller with the updated image count
    tabController = TabController(
      length: data.allImages.length,
      vsync: this,
      initialIndex: currentIndex,  // Preserve the current tab
    )..addListener(() => tabControllerListener());

    // Trigger a UI update
    update();
  }
  
  /// Called when the controller is being disposed.
  /// 
  /// Properly disposes of all controllers and removes listeners to prevent memory leaks.
  /// This is crucial for clean-up when the photo viewer is closed.
  @override
  void onClose() {
    // Dispose of the tab controller to free resources
    tabController.dispose();
    
    // Remove the scroll listener to prevent memory leaks
    // This is important to avoid callback references after disposal
    thumbnailScrollController.removeListener(handleThumbnailScroll);
    
    // Dispose of the thumbnail scroll controller to free resources
    thumbnailScrollController.dispose();
    
    super.onClose();
  }
}
