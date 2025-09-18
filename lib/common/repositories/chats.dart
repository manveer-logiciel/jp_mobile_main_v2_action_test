
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jobprogress/common/enums/chats.dart';
import 'package:jobprogress/common/models/firebase/firestore/chat_group.dart';
import 'package:jobprogress/common/models/firebase/firestore/group_message.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class ApiChatsRepo {

  static Future<Map<String, dynamic>> fetchThreads(Map<String, dynamic> params, {
    bool canUsePhoneAsTitle = false,
    bool includeUnreadCount = true
  }) async {
    try {
      final response = await dio.get(Urls.threadList, queryParameters: params);
      final jsonData = json.decode(response.toString());

      List<ChatGroupModel> groups = [];

      jsonData['data'].forEach((dynamic group) {
        final groupData = ChatGroupModel.fromApiJson(group,
            canUsePhoneAsTitle: canUsePhoneAsTitle,
            includeUnreadCount: includeUnreadCount
        );
        groups.add(groupData);
      });

      return {
        'groups' : groups,
        'pagination' : jsonData['meta']['pagination']
      };

    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchMessages(Map<String, dynamic> params) async {
    try {
      final response = await dio.get("${Urls.messages}/" + params['thread_id'], queryParameters: params);
      final jsonData = json.decode(response.toString());

      List<GroupMessageModel> groups = [];

      jsonData['data'].forEach((dynamic data) {
        groups.add(GroupMessageModel.fromApiJson(data));
      });

      groups = groups.reversed.toList();

      return {
        'messages' : groups,
        'pagination' : jsonData['meta']['pagination']
      };

    } catch (e) {
      rethrow;
    }
  }

  static String getSendMessageUrl(GroupsListingType? type) {
    switch (type) {
      case GroupsListingType.apiTexts:
        return Urls.shareViaJobProgress;
      default:
        return Urls.messagesSend;
    }
  }

  static Future<GroupMessageModel> sendMessage(Map<String, dynamic> params, {GroupsListingType? type}) async {
    try {

      String url = getSendMessageUrl(type);

      FormData formData = FormData.fromMap(params);

      final response = await dio.post(url, data: formData);
      final jsonData = json.decode(response.toString());

      return GroupMessageModel.fromApiJson(jsonData['data']);

    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> markAsRead(Map<String, dynamic> params) async {
    try {

      final response = await dio.get(Urls.messagesUnreadCount, queryParameters: params);
      final jsonData = json.decode(response.toString());

      return jsonData['status'] == 200;

    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> markAsUnread(Map<String, dynamic> params) async {
    try {

      final response = await dio.put(Urls.messagesMarkAsUnread(params['id']));
      final jsonData = json.decode(response.toString());

      return jsonData['status'] == 200;

    } catch (e) {
      rethrow;
    }
  }

}