import 'dart:convert';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class JobContractsRepository {
  /// [fetchFiles] Fetches a list of files and their pagination data from a remote server.
  /// The map has two keys:
  ///   - "list": A list of `FilesListingModel` objects representing the fetched files.
  ///   - "pagination": A map containing pagination information (e.g., current page, total pages).
  static Future<Map<String, dynamic>> fetchFiles(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.contracts, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<FilesListingModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData["meta"]["pagination"]
      };
      //Converting api data to model
      jsonData["data"].forEach((dynamic contract) =>
          dataToReturn['list'].add(FilesListingModel.fromContractsJson(contract)),
      );

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  /// [fileRename] Renames a file on a remote server.
  ///
  /// [params] A map of parameters including:
  ///   - "id":The ID of the file to rename.
  ///   - Other parameters required for the rename operation (e.g., the new name).
  /// Returns a Future that resolves to `true` if the rename operation was successful,
  /// `false` otherwise.
  static Future<bool> fileRename(Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put('${Urls.contractsRename}/${params['id']}', queryParameters: params);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  /// [removeFile] Removes a file from a remote server.
  ///
  /// [id] The ID of the file to remove.
  /// Returns a Future that resolves to `true` if the removal operation was successful,
  /// `false` otherwise.
  static Future<bool> removeFile(String id) async {
    try {
      final response = await dio.delete(Urls.getContractsFile(id));
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> makeACopy(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.contractsCopy, queryParameters: params);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  /// [showHideOnCustomerWebPage] Shows or hides a file on a customer web page.
  /// [params] - A map of parameters including:
  ///  - "id": The ID of the file to show or hide.
  ///  - Other parameters required for the show/hide operation.
  static Future<bool> showHideOnCustomerWebPage(Map<String, dynamic> params) async {
    try {
      final response = await dio.put(Urls.jobContractShareOnHop(int.parse(params['id'])), queryParameters: params);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}