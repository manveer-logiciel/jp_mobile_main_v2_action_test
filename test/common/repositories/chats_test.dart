import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/chats.dart';
import 'package:jobprogress/common/repositories/chats.dart';
import 'package:jobprogress/core/constants/urls.dart';

void main() {
  group("ApiChatsRepo.getSendMessageUrl should give correct send message URL as per type", () {
    test("Default URL should be api message", () {
      expect(ApiChatsRepo.getSendMessageUrl(null), Urls.messagesSend);
    });

    test("Message URL should be api texts message", () {
      expect(ApiChatsRepo.getSendMessageUrl(GroupsListingType.apiTexts), Urls.shareViaJobProgress);
    });

    test("Message URL should be api messages", () {
      expect(ApiChatsRepo.getSendMessageUrl(GroupsListingType.apiMessages), Urls.messagesSend);
    });
  });
}