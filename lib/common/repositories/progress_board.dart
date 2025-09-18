import 'dart:convert';

import 'package:jobprogress/common/services/download.dart';

import '../../core/constants/urls.dart';
import '../models/job/job.dart';
import '../models/pagination_model.dart';
import '../models/progress_board/production_board_column.dart';
import '../models/progress_board/progress_board_entries.dart';
import '../models/progress_board/progress_board_moadel.dart';
import '../providers/http/interceptor.dart';

class ProgressBoardRepository {

  Future<Map<String, dynamic>> fetchProgressBoardList(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.progressBoard, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<ProgressBoardModel> list = [];
      Map<String, dynamic> dataToReturn = {
        "list": list,
      };
      //Converting api data to model
      jsonData["data"].forEach((dynamic board) => dataToReturn['list'].add(ProgressBoardModel.fromJson(board)));
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchProgressBoardColumns(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.progressBoardColumns, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<ProductionBoardColumn> list = [];
      Map<String, dynamic> dataToReturn = {
        "list": list,
      };
      //Converting api data to model
      jsonData["data"].forEach((dynamic board) => dataToReturn['list'].add(ProductionBoardColumn.fromJson(board)));
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchJobProgressBoardList(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.jobProgressBoardList, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<JobModel> list = [];
      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": PaginationModel.fromJson(jsonData["meta"]["pagination"]),
      };
      //Converting api data to model
      jsonData["data"].forEach((dynamic board) => dataToReturn['list'].add(JobModel.fromProgressBoardJson(board)));
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }//pb_only_archived_jobs

  Future<Map<String, dynamic>> fetchColorList(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.progressBoardColors, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<String> list = [];
      Map<String, dynamic> dataToReturn = {
        "list": list,
      };
      //Converting api data to model
      jsonData["data"].forEach((dynamic color) => dataToReturn['list'].add(color));
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> editProgressBoardEntries(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.editProgressBoardEntries, queryParameters: params);
      final jsonData = json.decode(response.toString());
      Map<String, dynamic> dataToReturn = {
        "data": ProgressBoardEntriesModel.fromJson(jsonData["data"]),
      };
      //Converting api data to model
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> archiveJob(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.pbArchiveJob, queryParameters: params);
      final jsonData = json.decode(response.toString());
      Map<String, dynamic> dataToReturn = {
        "data": jsonData["status"],
      };
      //Converting api data to model
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteJob(Map<String, dynamic> params) async {
    try {
      final response = await dio.delete(Urls.pbDeleteJob, queryParameters: params);
      final jsonData = json.decode(response.toString());
      Map<String, dynamic> dataToReturn = {
        "data": jsonData["status"],
      };
      //Converting api data to model
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<bool> reorderJob(Map<String, dynamic> params) async {
    try {
      final response = await dio.put(Urls.pbReorderJob, queryParameters: params);
      final jsonData = json.decode(response.toString());
      return jsonData["status"] == 200;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> printProgressBoard(String boardId) async {
    try {
      final url = Urls.printProgressBoard(boardId);
      await DownloadService.downloadFile(url, '${DateTime.now()}.pdf', action: 'print');
    } catch (e) {
      rethrow;
    }
  }

}