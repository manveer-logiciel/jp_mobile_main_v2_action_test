
import 'package:get/get.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/services/file_attachment/quick_actions.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class AddEditJobNoteDialogBoxController extends GetxController {

  AddEditJobNoteDialogBoxController(this.jobId, this.jobNoteAttachments);

  int jobId; // jobId will be used in quick actions sheet

  List<AttachmentResourceModel> jobNoteAttachments = []; // used to receive uploaded attachments
  List<AttachmentResourceModel> uploadedAttachments = []; // used to display uploaded attachments
  List<AttachmentResourceModel> attachments = []; // used to store and display selected attachments
  List<int> deletedAttachments = []; // stores id of deleted/removed uploaded attachments

  @override
  void onInit() {
   uploadedAttachments.addAll(jobNoteAttachments);
   super.onInit();
  }

  // showFileAttachmentSheet() : displays quick actions sheet to select files from
  void showFileAttachmentSheet() {
    Helper.hideKeyboard();
    FileAttachService.openQuickActions(
        maxSize: Helper.flagBasedUploadSize(fileSize: CommonConstants.totalAttachmentMaxSize),
        jobId: jobId,
        onFilesSelected: addSelectedFilesToAttachment,
    );
  }

  // removeAttachment() : will remove attachment
  void removeAttachment(int index) {
    final uploadAttachmentLength = uploadedAttachments.length;
    if(index < uploadAttachmentLength) {
      addToDeleteAttachments(index);
    } else {
      removeAttachedItem(index - uploadAttachmentLength);
    }
  }

  // removeAttachedItem() : will remove items from selected attachments
  void removeAttachedItem(int index) {
    attachments.removeAt(index);
    update();
  }

  // addToDeleteAttachments() : will remove items from uploaded attachments
  //                            and add them to deleted attachments
  void addToDeleteAttachments(int index) {
    deletedAttachments.add(uploadedAttachments[index].id);
    uploadedAttachments.removeAt(index);
    update();
  }

  // addSelectedFilesToAttachment() : add files to attachment list
  void addSelectedFilesToAttachment(List<AttachmentResourceModel> files, {int? jobId}) {
    for (var file in files) {
      // checking whether file is already attached
      if(!attachments.any((element) => element.id == file.id)) {
        attachments.add(file);
      }
    }
    update();
  }

}