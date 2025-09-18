import 'package:get/get.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/photo_viewer_model.dart';
import 'package:jobprogress/common/services/download.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/photo_viewer_dialog/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';

class AttachmentController extends GetxController {
  AttachmentController(this.attachments);

  final List<AttachmentResourceModel> attachments;

  String getAttachmentExtension(int index) {
    String? extension = FileHelper.getFileExtension(attachments[index].url ?? '');
    return extension ?? attachments[index].classType ?? '';
  }

  Future<void> openFile(int i) async {

    if(attachments[i].localUrl != null) {
      FileHelper.openLocalFile(attachments[i].localUrl!);
    } else {
      String fileName = FileHelper.getFileName(attachments[i].url.toString());
      DownloadService.downloadFile(
          attachments[i].url.toString(), fileName,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              attachments[i].downloadProgress = (received / total);
              if (attachments[i].downloadProgress == 1) {
                attachments[i].downloadProgress = 0;
              }
            }
            update();
          }
      );
    }
  }

  void onTapFile(int index, {bool openImageInJPPreview = false}) {
    if (openImageInJPPreview && attachments[index].isImage) {
      goToPhotoViewer(index);
      return;
    }
    openFile(index);
  }

  // goToPhotoViewer() will fetches only images from displayed documents and
  // send them to PhotoViewer()
  void goToPhotoViewer(int index) {

    List<AttachmentResourceModel> tempList = attachments
        .where((attachment) => attachment.isImage)
        .toList();

    List<PhotoDetails> imageList = [];

    for (AttachmentResourceModel file in tempList) {
      if (file.url == null) continue;
      imageList.add(
          PhotoDetails(
            file.name ?? 'photos'.tr,
            urls: [file.url!],
          )
      );
      imageList.last.urls!.insert(0, file.thumbUrl ?? file.url ?? "");
    }

    int scrollToIndex = tempList
        .indexWhere((element) => element.id == attachments[index].id);

    final data = PhotoViewerModel<AttachmentController>(scrollToIndex, imageList);

    showJPBottomSheet(
      child: (_) {
        return JPSafeArea(
          child: PhotosViewerDialog(
            data: data,
          ),
        );
      },
      isScrollControlled: true,
      ignoreSafeArea: false,
      allowFullWidth: true,
    );

  }

}

