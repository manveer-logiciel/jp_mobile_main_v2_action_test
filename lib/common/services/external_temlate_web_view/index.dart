
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/routes/pages.dart';

class ExternalTemplateWebViewService {

  static String urlPrefix = Urls.externalTemplateURL;

  static Future<void> navigateToExternalTemplateWebView(String url, Function({bool showLoading}) onActionComplete, {dynamic type}) async {
    Map<String, dynamic> args = {
      NavigationParams.operationType : 'create',
      NavigationParams.url : url,
      NavigationParams.pageType: type,
    };
    final result = await Get.toNamed(Routes.externalTemplateWebView,arguments: args);
    if((result is bool) ? result : result != null) {
      onActionComplete.call(showLoading: true);
    }
  }

  static Future<String> createProposalTemplateUrl(JobModel? jobModel, String? fileId) async {
    String accessToken = await AuthService.getAccessToken();
    dynamic userId = AuthService.userDetails?.id;
    final customerId = jobModel?.customer?.id;
    final jobId = jobModel?.id;
    return '${urlPrefix}customer-jobs/$customerId/job/$jobId/proposals/$fileId/create?access_token=$accessToken&user_id=$userId';
  }

  static Future<String> getEditTemplateUrl(FilesListingQuickActionParams params) async {
    final customerId = params.jobModel?.customer?.id;
    final jobId = params.jobModel?.id;
    final fileId = params.fileList.first.id;
    bool isInsuranceEstimate = params.fileList.first.insuranceEstimate ?? false;
    String accessToken = await AuthService.getAccessToken();
    String templateType = isInsuranceEstimate ? 'insurance' : 'proposals';
    dynamic userId = AuthService.userDetails?.id;

    String url = '${urlPrefix}customer-jobs/$customerId/job/$jobId/$templateType/$fileId/edit?access_token=$accessToken&user_id=$userId';

    return url;
  }

  static Future<String> createMergeTemplateUrl(List<int> selectedFileOrder, List<FilesListingModel> resourceList, JobModel? jobModel) async {
    List<String> selectedGroups = [];
    List<int> selectedTemplates = [];
    List<String> selectedGroupsPageType = [];
    String url = "";
    String pageType = "";
    String firstSelectedFileId = "";
    String urlParams = "";
    selectedFileOrder = selectedFileOrder.toSet().toList(); // remove duplicate enteries

    String accessToken = await AuthService.getAccessToken();
    dynamic userId = AuthService.userDetails?.id;
    List<FilesListingModel> fileList = resourceList.where((element) => element.isFile == true).toList();
    for(FilesListingModel file in fileList) {
      if(file.isGroup ?? false) {
        if(file.isSelected ?? false) {
          selectedGroups.add(file.groupId!);
          selectedGroupsPageType.add(file.pageType!);
        } else {
          for(FormProposalTemplateModel page in file.proposalTemplatePages!) {
            if(page.isSelected) {
              selectedTemplates.add(page.templateId!);
              selectedGroupsPageType.add(file.pageType!);
            }
          }
        }
      } else if(((file.proposalTemplatePages?.first.isImageTemplate ?? false) || (file.proposalTemplatePages?.first.isEmptySellingPriceSheet ?? false)) && (file.isSelected ?? false)) {
        selectedTemplates.add(file.proposalTemplatePages!.first.id!);
        selectedGroupsPageType.add(file.proposalTemplatePages!.first.pageType!);
      } else if(file.isSelected ?? false) {
        selectedTemplates.add(file.proposalTemplatePages!.first.id!);
        selectedGroupsPageType.add(file.pageType!);
      }
    }

    pageType = selectedGroupsPageType.contains("a4-page") ? 'a4' : 'legal';
    firstSelectedFileId = getFirstSelectedFileId(selectedFileOrder,selectedGroups,resourceList);
    urlParams = getUrlParams(selectedGroups, selectedTemplates);
    
    // Creating URL for web-view
    url = '${urlPrefix}customer-jobs/${jobModel?.customer?.id}/job/${jobModel?.id}/insurance/$pageType/$firstSelectedFileId/create?${urlParams}access_token=$accessToken&user_id=$userId';
    debugPrint("Create Merge template URL : $url");
    return url;
  }

  static String getFirstSelectedFileId(List<int> order, List<String> groups, List<FilesListingModel> resourceList){
    String dataToReturn;
    int firstFileId = order.first;
    dynamic id;
    if(groups.isNotEmpty && (resourceList[firstFileId].isSelected ?? false) && (resourceList[firstFileId].isGroup ?? false)) {
      id = 'group';
    } else if(resourceList[firstFileId].isGroup ?? false) {
      id = resourceList[firstFileId].proposalTemplatePages?.firstWhereOrNull((element) => element.isSelected == true)?.templateId;
    } else {
      id = resourceList[firstFileId].proposalTemplatePages?.first.id;
    }

    if(id == -1) {
      dataToReturn = "images";
    } else if(id == -2) {
      dataToReturn = "pricing";
    } else {
      dataToReturn = id.toString();
    }
    return dataToReturn;
  }

  static String getUrlParams (List<String> groupIds, List<int> templateIds){
    String urlData = "";
    if(groupIds.isNotEmpty) {
      for(String id in groupIds) {
        urlData = '${urlData}groups=$id&';
      }
      if(templateIds.isNotEmpty) {
        urlData = urlData + getUrlData(templateIds);
      }
    } else {
      urlData = urlData + getUrlData(templateIds);
    }
    return urlData;
  }

  static String getUrlData(List<int> templateIds){
    String urlData = "";
    for(int id in templateIds) {
      if(id == -1) {
        urlData = '${urlData}templates=images&';
      } else if(id == -2) {
        urlData = '${urlData}templates=pricing&';
      } else {
        urlData = '${urlData}templates=$id&';
      }
    }
    return urlData;
  }
   
}