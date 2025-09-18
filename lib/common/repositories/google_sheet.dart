import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/create_file_actions.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_request_param.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:dio/dio.dart' as formdata;
import 'package:jobprogress/core/utils/helpers.dart';

class GoogleSheetActionRepo{

  static Future<Map<String,dynamic>> createGoogleSheet(CreateFileActions onComplete, String action,Map<String,dynamic> param,FLModule module) async {
    formdata.FormData data;
    Helper.hideKeyboard();
    data = await FilesListingRequestParam.getGoogleSheetParams(action, param);
    try {
       final response = await dio.post(module == FLModule.estimate ? Urls.createEstimatesGooglesheet : Urls.createProposalGooglesheet,data: data);
       Map<String,dynamic> dataToReturn = {};

      if (response.data["status"] == 200) {
        dataToReturn = {
          "google_sheet_url" : response.data["data"]["google_sheet_url"]
        };
      }
      return dataToReturn;
    } catch(e) {
      rethrow;
    }
  }

}