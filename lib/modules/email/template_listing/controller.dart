import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/email/template_list.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/repositories/email_template.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/modules/email/template_listing/detail_dialog/index.dart';

class EmailTemplateListingController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: 'email_template_listing_controller_scaffold_key');

  int page = 1;
  String seachKeyword = '';
  List<EmailTemplateListingModel> templateList = [];
  bool isLoadingMore = false;
  bool isLoading = true;
  bool canShowMore = false;
  bool favoriteOnly = false;
  TextEditingController searchController = TextEditingController();

  Map<String, dynamic> getEmailParams() {
    Map<String, dynamic> params = {
      'active': 1,
      'includes[0]': ['attachments'],
      'sort_by': 'id',
      'sort_order': 'asc',
      'keyword': seachKeyword,
      'limit': PaginationConstants.pageLimit,
      'page': page,
    };
    if(favoriteOnly) {
      params['favourite_for[]'] = [AuthService.userDetails?.id];
    }
    return params;
  }


  Future<void> getEmailTemplateList() async {
    Map<String, dynamic> emailsParams = getEmailParams();

    try {
      Map<String, dynamic> response = await EmaiTemplatelListingRepository.fetchTemplateList(emailsParams,'');
      
      List<EmailTemplateListingModel> list = response['list'];
      PaginationModel pagination = response['pagination'];

      if (!isLoadingMore) {
        templateList = [];
      }

      templateList.addAll(list);

      canShowMore = templateList.length < pagination.total!;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadingMore = false;
      update();
    }
  }

  Future<void> loadMore() async {
    page += 1;
    isLoadingMore = true;
    update();
    await getEmailTemplateList();
  }

  void toggleFavoriteOnly(bool value) {
    favoriteOnly = value;
    refreshList(showLoading: true);
  }

  Future<void> refreshList({bool? showLoading}) async {
    page = 1;
    isLoading = showLoading ?? false;
    update();
    await getEmailTemplateList();
  }

  onSearchTextChanged(String text) {
    page = 1;
    seachKeyword = text;
    isLoading = true;
    update();
    getEmailTemplateList();
  }

  void openTemplateInDialog(EmailTemplateListingModel template) {
    showJPBottomSheet(child: (controller) {
      return EmailTemplateViewDialog(data: template, onSelect: () {
        Get.back();
        Get.back(result: template);
      });
    }, isScrollControlled: true);
  }

  List<int> favouriteForList(EmailTemplateListingModel template) {
    List<int> favoriteFor = template.favoriteFor ?? [];
    if(!template.favorite) {
      favoriteFor.insert(0, AuthService.userDetails!.id);
    } else {
      favoriteFor.removeWhere((element) => element == AuthService.userDetails?.id);
    }
    return favoriteFor;

  }
  
  Future<void> onFavoritePressed(EmailTemplateListingModel template) async {
    try {
      List <int> favoriteFor = favouriteForList(template);
      template.isLoading = true;
      update();
      
      Map<String, dynamic> params = {
        'favourite_for[]': favoriteFor.isNotEmpty ? favoriteFor : ['']
      };
      
      await EmaiTemplatelListingRepository.markAsFavorite(params, template.id.toString());
      
      template.favorite = !template.favorite;
      template.favoriteFor = favoriteFor;
      Helper.showToastMessage(template.favorite ? 'template_added_to_favorites'.tr : 'template_removed_from_favorites'.tr);
    } catch(e) {
      rethrow;
    } finally {
      template.isLoading = false;
      update();
    }
  }

  void cancelOnGoingRequest() {
    cancelToken?.cancel();
  }

  @override
  void dispose() {
    cancelOnGoingRequest();
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    getEmailTemplateList();
  }
}