import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/modules/email/listing/controller.dart';

import '../files_listing/file_listing_test.dart';

void main() {
  AuthService.userDetails = UserModel.fromJson(userJson);

  test("Email listing should be constructed with default values", () {
    
  final controller = EmailListingController();
    expect(controller.canShowLoadMore, false);
    expect(controller.isLoading, true);
    expect(controller.isLoadMore, false);
    expect(controller.paramKeys.withReply, true);
    expect(controller.paramKeys.users, 1);
    expect(controller.paramKeys.labelId, null);
    expect(controller.paramKeys.limit, 20);
    expect(controller.paramKeys.keyword, null);
    expect(controller.paramKeys.page, 1);
    expect(controller.isLoadingInDialog, false);
    expect(controller.isMultiSelectionOn, false);
    expect(controller.jobId, -1);
  });

  group('Email listing loadMore function should set values', () {
    
    final controller = EmailListingController();
    controller.loadMore();  
    test('Email listing loadMore function should set page to 1', () {
      expect(controller.paramKeys.page, 2);
    });
    test('Email listing loadmore function should set isLoading to true', () {
      expect(controller.isLoading, true);
    });
  });

  // group('Email listing refreshList function should set values', () {
  //   controller.refreshList();
  //   test('Email listing refreshList function should set page to 1', () {
  //     expect(controller.paramkeys.page, 1);
  //   });
  //   test('Email listing refreshList function should set isLoading to true', () {
  //     expect(controller.isLoading, true);
  //   });
  // });
test('Email listing refreshList should refresh when api request for data with showLoading passes true', () {
    final controller = EmailListingController();
    bool showLoading = true;
    controller.refreshList(showLoading: showLoading);
    expect(controller.isLoading, showLoading);
    expect(controller.paramKeys.page, 1);
  });
  
  test('Email listing refreshList should refresh when api request for data', () {
    final controller = EmailListingController();
    controller.refreshList();
    expect(controller.isLoading, false);
    expect(controller.paramKeys.page, 1);
  });

  group('Email listing onSearchTextChanged function should set values', () {
    
    final controller = EmailListingController();
    String text = 'name';
    controller.onSearchTextChanged(text);
    test('Email listing onSearchTextChanged function should set text', () {
      expect(text, 'name');
    });
    test('Email listing onSearchTextChanged function should set page to 1', () {
      expect(controller.paramKeys.page, 1);
    });
    test('Email listing onSearchTextChanged function should set isLoading to true', () {
      expect(controller.isLoading, true);
    });
    test('Email listing onSearchTextChanged function should set ismultiselection to true', () {
      expect(controller.isMultiSelectionOn, false);
    });
    test('Email listing onSearchTextChanged function should set keyword value', () {
      expect(controller.paramKeys.keyword, text);
    });
  });
}

