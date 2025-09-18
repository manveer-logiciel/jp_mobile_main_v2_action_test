import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:jp_mobile_flutter_ui/ZoomInZoomOut/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../common/enums/file_listing.dart';
import '../../common/models/photo_viewer_model.dart';
import '../../common/services/drawing_tool/index.dart';
import '../../modules/files_listing/controller.dart';
import '../network_image/index.dart';
import '../safearea/safearea.dart';
import '../step_image_loader/index.dart';
import 'controller.dart';

/// Photo viewer dialog with lazy-loading pagination.
///
/// PAGINATION FEATURE:
/// - Displays thumbnails in a horizontally scrollable list
/// - Loads additional photos on-demand as user scrolls
/// - Shows loading indicators while fetching more photos
/// - Maintains smooth scrolling experience with large photo collections
///
/// Generic type <T> allows different controller implementations for photo loading.
class PhotosViewerDialog<T> extends GetView<PhotosViewerController<T>> {

  /// Creates a new instance of [PhotosViewerDialog].
  ///
  /// [data] - The photo viewer model containing images and pagination controller.
  /// [type] - Optional module type that determines available actions and pagination behavior.
  /// [jobId] - Optional job ID associated with these photos.
   PhotosViewerDialog({Key? key, required this.data, this.type, this.jobId}) : super(key: key);

  /// The photo viewer model containing images and pagination controller.
  final PhotoViewerModel<T> data;
  
  /// The module type that determines available actions and pagination behavior.
  final FLModule? type;
  
  /// Optional job ID associated with these photos.
  final int? jobId;
  
  /// File controller for handling company cam projects.
  final FilesListingController fileController = FilesListingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PhotosViewerController<T>>(
      init: PhotosViewerController<T>(data, type ?? FLModule.jobPhotos, jobId),
      global: false,
      builder: (PhotosViewerController<T> controller) {
        return Material(
          color: Colors.black.withValues(alpha: 0.65),
          child: JPSafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: JPText(
                            text: controller.imageName,
                            textColor: JPAppTheme.themeColors.base,
                            textAlign: TextAlign.start,
                            maxLine: 1,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: JPFontWeight.medium,
                            fontFamily: JPFontFamily.montserrat,
                          ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      if(controller.doShowEditButton)...{
                        JPTextButton(
                          icon: Icons.edit_outlined,
                          iconSize: 24,
                          color: JPAppTheme.themeColors.base,
                          onPressed: controller.editFile,
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                      },
                      JPTextButton(
                        icon: Icons.print_outlined,
                        iconSize: 24,
                        color: JPAppTheme.themeColors.base,
                        onPressed: controller.printFile,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      JPTextButton(
                        icon: Icons.photo_outlined,
                        iconSize: 24,
                        color: JPAppTheme.themeColors.base,
                        onPressed: controller.downloadAndOpenFile,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      JPTextButton(
                        icon: Icons.close_outlined,
                        iconSize: 24,
                        color: JPAppTheme.themeColors.base,
                        onPressed: () {
                          controller.saveAsImages.clear();
                          if(controller.type == FLModule.companyCamProjects){
                            fileController.fetchResources();
                          }
                          if(controller.action == 'save_as' && (controller.isSaveAsPerformed ?? false)){
                            Get.back(
                              result: {
                                'file' : DrawingToolService.fileList,
                                'save_as': controller.isSaveAsPerformed
                              }
                            );
                          } else {
                            Get.back(
                              result: {
                                'file': controller.editedImages,
                                'save_as': controller.isSaveAsPerformed
                              }
                            );
                          }                          
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: TabBarView(
                      physics: controller.enableScrolling ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
                      controller: controller.tabController,
                      children: controller.data.allImages.map((e) {
                        return JPZoomInZoomOut(
                          callBack: (val){
                            controller.toggleEnableScrolling(val);
                          },
                          child: StepImageLoader(
                            imageList: e.urls,
                            base64Images: e.base64Image,
                          ),
                        );
                      }).toList(),
                    ),
                ),
                // PAGINATION UI: Horizontally scrollable thumbnail list with loading indicators
                if(controller.data.allImages.length > 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                    child: SizedBox(
                      height: 50, // Fixed height for the thumbnail list
                      child: ListView.builder(
                        // AutoScrollController enables programmatic scrolling to center selected thumbnails
                        controller: controller.thumbnailScrollController,
                        scrollDirection: Axis.horizontal,
                        // Dynamic item count includes actual photos plus loading indicators
                        itemCount: controller.getItemCount,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          // PAGINATION LOADING INDICATOR: Show loading circle when fetching more photos
                          // This appears at the end of the list when scrolling triggers more photo loading
                          if (index >= controller.data.allImages.length) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(5, 5, 25, 5),
                              child: Center(
                                child: FadingCircle(
                                  color: JPAppTheme.themeColors.base,
                                  size: 28,
                                ),
                              ),
                            );
                          }
                          
                          // PAGINATION THUMBNAIL: Each photo is wrapped in AutoScrollTag
                          // This enables auto-scrolling to center the selected thumbnail
                          // when navigating through paginated photos
                          final photo = controller.data.allImages[index];
                          return AutoScrollTag(
                            key: ValueKey(index),
                            controller: controller.thumbnailScrollController,
                            index: index, // Index used for programmatic scrolling
                            child: GestureDetector(
                              onTap: () {
                                controller.tabController.animateTo(index);
                              },
                              child: Container(
                                padding:const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: controller.tabController.index == index
                                        ? JPAppTheme.themeColors.base
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  color: Colors.transparent,
                                ),
                                child: photo.base64Image != null
                                  ? Image.memory(
                                      photo.base64Image!,
                                      width: 42,
                                      height: 42,
                                      fit: BoxFit.cover,
                                    )
                                  : JPNetworkImage(
                                      src: photo.urls!.first,
                                      width: 42,
                                      height: 42,
                                      boxFit: BoxFit.cover,
                                      borderRadius: 0,
                                      placeHolder: Opacity(
                                        opacity: 0.5,
                                        child: Container(
                                          color: JPAppTheme.themeColors.lightestGray,
                                          child: Image.asset(
                                            'assets/images/alt-image.png',
                                            width: 42,
                                            height: 42,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
