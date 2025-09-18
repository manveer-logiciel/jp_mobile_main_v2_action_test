
import 'package:dio/dio.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_model.dart';
import 'package:jobprogress/common/providers/http/dio_exception_handler.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import '../../core/utils/helpers.dart';
import '../providers/http/interceptor.dart';

class UploadRepository {

  static Future<void> uploadFileToServer({
    required FileUploaderModel uploadItem,
    required Function(double progress) onProgressUpdate,
    required Function(int itemId, dynamic response) onFileUploaded,
    required Function(int id, String error) onError,
  }) async {

    try {

      /// [FileUploadType.srsOrder] api request require supplierId
      if(uploadItem.type == FileUploadType.srsOrder) {
        uploadItem.params['supplier_id'] = Helper.getSupplierId();
      }

      /// adding request params and file
      var formData = FormData.fromMap({
          ...uploadItem.params,
        (uploadItem.fileFormParamKey ?? 'file'): await MultipartFile.fromFile(
          uploadItem.localPath,
        ),
        if (uploadItem.type == FileUploadType.template)
          'image': await MultipartFile.fromFile(
            uploadItem.localPath,
          ),
      });

      /// calling Api
      final response = await dio.post(
          uploadItem.apiAddress,
          data: formData,
          queryParameters: CommonConstants.avoidGlobalCancelToken,
          cancelToken: uploadItem.cancelToken,
          onSendProgress: (int uploadedBytes, int totalBytes) {
            double progress = uploadedBytes/totalBytes;
            /// listening to file upload progress
              onProgressUpdate(progress);
          }
      );

      /// when file is uploading sending callback for the same
      onFileUploaded(uploadItem.id!, parseResponse(response.data, uploadItem));

    } on DioException catch(e) {
      /// in case of cancelling api request no error should be thrown
      if(e.type != DioExceptionType.cancel) {
        if(e.type == DioExceptionType.unknown) {
          /// On error, if error message is not known setting below message by default
          onError(uploadItem.id!, 'upload_failed'.tr);
        } else {
          /// On error, if error message is known setting respective message
          onError(uploadItem.id!, DioExceptions.fromDioError(e).message);
        }
        rethrow;
      }
    }
  }

  static dynamic parseResponse(Map<String, dynamic> response, FileUploaderModel item) {
    if(item.type == FileUploadType.attachment) {
      Map<String, dynamic> res = response['file'];
      res.putIfAbsent('local_url', () => item.localPath);
      return AttachmentResourceModel.fromJson(res);
    } else if(item.type == FileUploadType.template) {
      Map<String, dynamic> res = response['data'];
      res.putIfAbsent('local_url', () => item.localPath);
      return AttachmentResourceModel.fromJson(res);
    } else if(item.type == FileUploadType.srsOrder){
      Map<String, dynamic> res = response['data'];  
      res.putIfAbsent('local_url', () => item.localPath);
      return AttachmentResourceModel.fromSrsOrderForm(res);
    } else {
      return response;
    }
  }

}