import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/snippet_trade_script.dart';
import 'package:jobprogress/common/models/snippet_listing/snippet_listing.dart';
import 'package:jobprogress/modules/snippets/listing/controller.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SnippetsListingController controller = SnippetsListingController();

  test('SnippetsListingController should be initialized with default values', () {
    expect(controller.isLoading, true);
    expect(controller.isLoadingMore, false);
    expect(controller.canShowMore, false);
    expect(controller.filterByList, <JPSingleSelectModel>[]);
    expect(controller.selectedFilterByOptions, null);
    expect(controller.snippetList, <SnippetListModel>[]);
    expect(controller.type, STArg.snippet);
    expect(controller.searchController.text, '');
    expect(controller.snippetListingParam.limit, '20');
    expect(controller.snippetListingParam.page, 1);
    expect(controller.snippetListingParam.title, '');
  });

  test('SnippetListing should loadMore when api request for data', () {
    int page = controller.snippetListingParam.page;
    controller.loadMore();
    expect(controller.snippetListingParam.page, page + 1);
    expect(controller.isLoadingMore, true);
  });

  test('SnippetListing should refresh when api request for data ', () {
    controller.refreshList();
    expect(controller.snippetListingParam.page, 1);
    expect(controller.isLoading, false);
  });

  test('SnippetListing should search when api request for data', () {
    controller.onSearchTextChanged('hello');
    expect(controller.snippetListingParam.page, 1);
    expect(controller.snippetListingParam.title, 'hello');
    expect(controller.isLoading, true);
  });

  test('SnippetListing should search when user clears search field', () {
    controller.onSearchTextChanged('');
    expect(controller.snippetListingParam.page, 1);
    expect(controller.snippetListingParam.title, '');
    expect(controller.isLoading, true);
  });

  test('SnippetListing should filter when api request for data', () {
    controller.onSelectingFilter('33');
    expect(controller.selectedFilterByOptions, '33');
    expect(controller.isLoading, true);
  });
}
