
import 'dart:convert';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/files_listing/delivery_date.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/srs/delivery_detail.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/download.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';
import '../../core/utils/helpers.dart';
import '../models/files_listing/srs/srs_order_detail.dart';
import '../models/job/job.dart';

class MaterialListsRepository {

  static Future<Map<String, dynamic>> fetchFiles(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.materialLists, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<FilesListingModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData?["meta"]?["pagination"]
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic estimate) =>
      {dataToReturn['list'].add(FilesListingModel.fromMaterialListsJson(estimate))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
  Future<SrsOrderModel> fetchSrsOrderDetail(String srsOrderId, Map<String, dynamic> params) async {
    try {
      final response = await dio.get('${Urls.srsOrderDetail}/$srsOrderId',queryParameters: params);
      final jsonData = json.decode(response.toString());
 
      return SrsOrderModel.fromJson(jsonData['data']);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<String?> fetchTrackingDetails(String orderId, Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.srsOrderTrackingDetails(orderId), queryParameters: params);
      final jsonData = json.decode(response.toString());
      return jsonData['data']['tracking_url'];
    } catch (e) {
      rethrow;
    }
  }

  Future<SrsDeliveryDetailModel> fetchSrsDeliveryDetail(String orderId, Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.srsOrderDeliveryDetails(orderId), queryParameters: params);
      final jsonData = json.decode(response.toString());
      return SrsDeliveryDetailModel.fromJson(jsonData['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> fetchSrsInvoiceTotal(String invoiceNumber, int? srsSupplierId) async {
    try {
      final response = await dio.get(Urls.srsOrderInvoiceTotal(invoiceNumber, srsSupplierId));
      final jsonData = json.decode(response.toString());
      return jsonData['data']['total'].toString();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> downloadPdf(String orderId, int? srsSupplierId) async {
    try {
      int? supplierId = srsSupplierId ?? Helper.getSupplierId();
      String url = Urls.srsOrderDeliveryImage(orderId, supplierId);
      String fileName = '${FileHelper.getFileName(Urls.srsOrderDeliveryImage(orderId, supplierId))}.pdf';
      await DownloadService.downloadFile(
        url.toString(), fileName,
        action:'open',
      );
    } catch(e) {
      rethrow;
    } 
  }

  Future<void> downloadAttachment(String orderId, int? srsSupplierId) async {
    try {
      int? supplierId = srsSupplierId ?? Helper.getSupplierId();
      String url =Urls.srsOrderInvoicePdf(orderId, supplierId);
      String fileName = '${FileHelper.getFileName(Urls.srsOrderInvoicePdf(orderId, supplierId))}.pdf';
      await DownloadService.downloadFile(
        url.toString(), fileName,
        action:'open',
      );
    } catch(e) {
      rethrow;
    } 
  }

  static Future<bool> fileRename(Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put(Urls.materialListRename(int.parse(params['id'])), queryParameters: params);
      final jsonData = json.decode(response.toString());


      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> folderRename(Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put(Urls.materialListFolderRename(params['id']), queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> showHideOnCustomerWebPage(Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put(Urls.estimationsShareOnHop(params['id']), queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> rotateImage(
    String id, Map<String, dynamic> params) async {
    try {
      final response =
      await dio.post(Urls.materialListRotateImage(id), queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return FilesListingModel.fromMaterialListsJson(jsonData["data"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> moveFiles(
      Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put(Urls.materialListsMoveFiles, queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> removeFile(String id) async {
    try {
      final response = await dio.delete(Urls.deleteMaterialListFile(id));
      final jsonData = json.decode(response.toString());

      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> removeDirectory(String id) async {
    try {
      final response =
      await dio.delete(Urls.deleteMaterialListsFolder(id));
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> createDirectory(
      Map<String, dynamic> params) async {
    try {
      final response =
      await dio.post(Urls.materialListsFolder, queryParameters: params);
      final jsonData = json.decode(response.toString());

      jsonData["data"]['is_dir'] = 1;
      // Converting api data to model
      return FilesListingModel.fromMaterialListsJson(jsonData["data"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> unMarkAsFavourite(int id) async {
    try {
      final response =
      await dio.delete(Urls.unMarkFavouriteEntities(id));
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<DeliveryDateModel> createUpdateDeliveryDate(Map<String, dynamic> params) async {
    try {
      late dynamic response;
      if(params['materialId'] != null){
        response = await dio.put(Urls.updateDeliveryDate(params['jobId'].toString(), params['materialId'].toString()), queryParameters: params);
      }else{
        response = await dio.post(Urls.createDeliveryDate(params['jobId']), queryParameters: params);
      }

      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return DeliveryDateModel.fromJson(jsonData['data']);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> deleteDeliveryDate(Map<String, dynamic> params) async {
    try {
      dynamic response = await dio.delete(Urls.updateDeliveryDate(params['jobId'].toString(), params['materialId'].toString()));

      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<List<JPSingleSelectModel>> fetchMaterialList(Map<String, dynamic> params) async {
    try {
      dynamic response = await dio.get(Urls.materialLists, queryParameters: params);

      final jsonData = json.decode(response.toString());

      List<FilesListingModel> materials = [];

      jsonData['data'].forEach((dynamic material) {
        materials.add(FilesListingModel.fromMaterialListsJson(material));
      });

      return materials.map((material) => JPSingleSelectModel(label: material.name ?? "", id: material.id ?? "-1")).toList();
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> uploadFile(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.materialLists, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<FilesListingModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData["meta"]["pagination"]
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic estimate) =>
      {dataToReturn['list'].add(FilesListingModel.fromMaterialListsJson(estimate))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<AttachmentResourceModel> getAttachment(String id) async {
    try {
      final response = await dio.get(Urls.materialsAttachment(id));
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return AttachmentResourceModel.fromEmailJson(jsonData, FLModule.materialLists);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
  static Future<JobModel> updateMaterialPO(Map<String, dynamic> params) async {
    try {
      late dynamic response;
      response = await dio.put(Urls.updateMaterialPO(params['jobId'].toString()), queryParameters: params);
      final jsonData = json.decode(response.toString());
      return JobModel.fromJson(jsonData["data"]);
      // Converting api data to model
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel?> createPlaceSRSOrder(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.placeSRSOrder, queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return FilesListingModel.fromMaterialListsJson(jsonData['data']);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel?> createPlaceBeaconOrder(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.placeBeaconOrder, data: params, queryParameters: CommonConstants.ignoreToastQueryParam);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return FilesListingModel.fromMaterialListsJson(jsonData['data']);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> changeStatus(String id, Map<String, dynamic> requestedParams) async {
    try {
      final response = await dio.put(Urls.changeMaterialListStatus(id), queryParameters: requestedParams);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<List<FilesListingModel>> getBeaconOrderStatuses(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.beaconOrderStatus, data: params, queryParameters: CommonConstants.ignoreToastQueryParam);
      final jsonData = json.decode(response.toString());

      List<FilesListingModel> list = [];

      //Converting api data to model
      jsonData["data"].forEach((dynamic json) => list.add(FilesListingModel.fromBeaconOrderStatus(json)));
      return list;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel?> createPlaceABCOrder(int? supplierId, Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.placeABCOrder(supplierId), queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return FilesListingModel.fromMaterialListsJson(jsonData['data']);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}