import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/notification/notification_group.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';
import 'package:jobprogress/modules/notification_listing/controller.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  Get.testMode = true;
  final controller = NotificationListingController();

  group("Notification listing", () {

    test("NotificationListing should be constructed with default values", (){
      expect(controller.canShowLoadMore, false);
      expect(controller.isLoading, true);
      expect(controller.isLoadMore, false);
      expect(controller.totalNotificationLength, 0);
      expect(controller.selectedFilterByOptions, 'all');

      expect(controller.paramkeys.limit, PaginationConstants.pageLimit);
      expect(controller.paramkeys.page, 1);
      expect(controller.paramkeys.unreadOnly, false);
      expect(controller.paramkeys.readOnly, false);

      List<GroupNotificationListingModel> notificationGroup = [];

      expect(controller.notificationGroup, notificationGroup);
    });

    test('NotificationListing@fetchNotifications should set values after requesting data from api', () {
      controller.fetchNotifications();

      expect(controller.paramkeys.page, 1);
      expect(controller.paramkeys.limit, PaginationConstants.pageLimit);
      expect(controller.paramkeys.unreadOnly, false);
      expect(controller.paramkeys.readOnly, false);
      expect(controller.isLoading, true);
      expect(controller.isLoadMore, false);
    });

    test('NotificationListing should refresh list without showing shimmer ', () {
      controller.refreshList();

      expect(controller.paramkeys.page, 1);
      expect(controller.isLoading, false);
    });

    test('NotificationListing@refreshList should refresh list with showing shimmer', () {
      controller.refreshList(showLoading: true);

      expect(controller.paramkeys.page, 1);
      expect(controller.isLoading, true);
    });

    test('NotificationListing should loadmore notification data & set data accordinglly', () {
      int currentPage = controller.paramkeys.page;
      controller.loadMore();

      expect(controller.paramkeys.page, ++currentPage);
      expect(controller.isLoading, true);
    });

    test('NotificationListing@updateFilter should Filter only read_only notification', () {
      controller.updateFilter('read_only');

      expect(controller.paramkeys.readOnly, true);
      expect(controller.paramkeys.unreadOnly, false);
      expect(controller.selectedFilterByOptions, 'read_only');
      expect(controller.isLoading, true);
    });

    test('NotificationListing@updateFilter should Filter only unread_only notification', () {
      controller.updateFilter('unread_only');

      expect(controller.paramkeys.readOnly, false);
      expect(controller.paramkeys.unreadOnly, true);
      expect(controller.selectedFilterByOptions, 'unread_only');
      expect(controller.isLoading, true);
    });

  });
}