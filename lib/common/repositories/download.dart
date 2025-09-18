import 'package:dio/dio.dart';
import 'dart:io';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/cookies.dart';
import 'package:jobprogress/core/utils/file_helper.dart';

class DownloadRepository {
  //Downloading file from server and saving in device temp storage
  static Future<String> downloadFileFromServer(String url, String fullPath,
      void Function(int, int)? onReceiveProgress) async {
    try {
      final response = await dio.get(
        url,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          responseType: ResponseType.bytes,
          headers: CookiesService.savedCookies,
        ),
      );

      File file = await FileHelper.saveFile(fullPath, response.data);

      return file.path;
    } catch (e) {
      rethrow;
    }
  }
}
