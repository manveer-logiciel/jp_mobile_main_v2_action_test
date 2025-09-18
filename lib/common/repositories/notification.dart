import 'dart:convert';
import 'package:jobprogress/common/models/notification/notification.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class NotificationListingRepository {
  Future<Map<String, dynamic>> fetchNotificationList(Map<String, dynamic> notificationParams) async {
    try {
      final response = await dio.get(Urls.notificationList, queryParameters: notificationParams);
      final jsonData = json.decode(response.toString());
      List<NotificationListingModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": PaginationModel.fromJson(jsonData["meta"]["pagination"])
      };

      jsonData["data"].forEach((dynamic notification) => {
        dataToReturn['list'].add(NotificationListingModel.fromJson(notification))
      });
      return dataToReturn;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> markAsRead(int id) async {
    try {
      final response = await dio.get(
        '${Urls.notificationSetAsRead}/$id'
      );
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
  
  Future<dynamic> markAllAsRead() async {
    try {
      final response = await dio.get(
        Urls.notificationSetAllAsRead
      );
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }  
}
