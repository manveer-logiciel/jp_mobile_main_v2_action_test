import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/modules/email/template_listing/controller.dart';

void main(){

  test("Email template listing should be initialised", () {
    final controller = EmailTemplateListingController();
    Map<String, dynamic> tempParams = controller.getEmailParams();
    expect(controller.isLoadingMore, false);
    expect(controller.isLoading, true);
    expect(controller.page, 1);
    expect(controller.seachKeyword, '');
    expect(controller.templateList, isEmpty);
    expect(controller.canShowMore, false);
    expect(tempParams['sort_order'], 'asc');
    expect(tempParams['includes[0]'], ['attachments']);
    expect(tempParams['sort_by'], 'id');
    expect(tempParams['keyword'], '');
    expect(tempParams['page'], 1);
  });

  test('Email template listing loadMore function should set values', () {
    
    final controller = EmailTemplateListingController();
    controller.loadMore();

    expect(controller.page, 2);
    expect(controller.isLoading, true);

  });

  group('Email template listing refreshList should refresh', () {

    test('When api request for data with showLoading passes true', () {
      final controller = EmailTemplateListingController(); 
      bool showLoading = true;
      controller.refreshList(showLoading: showLoading);
      expect(controller.isLoading, showLoading);
      expect(controller.page, 1);
    });

    test('When api request for data', () {
      final controller = EmailTemplateListingController();
      controller.refreshList();
      expect(controller.isLoading, false);
      expect(controller.page, 1);
    });
    
  });

  test('Email template listing onSearchTextChanged function should set values', () {
    
    final controller = EmailTemplateListingController();
    String text = 'name';
    controller.onSearchTextChanged(text);

    expect(controller.page, 1);
    expect(controller.isLoading, true);
    expect(controller.seachKeyword, 'name');
    
  });

  group('EmailTemplateListingController@toggleFavoriteOnly should set favoriteOnly value accordingly', () {
    final controller = EmailTemplateListingController();

    test('Should set favoriteOnly to true when value is true', () {
      controller.toggleFavoriteOnly(true);
      expect(controller.favoriteOnly, true); 
    });

    test('Should set favoriteOnly to false when value is false', () {
      controller.toggleFavoriteOnly(false);
      expect(controller.favoriteOnly, false); 
    });
  
  });
}